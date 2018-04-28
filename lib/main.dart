import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;
import 'dart:convert' show json;

GoogleSignIn googleSignIn = new GoogleSignIn(
  scopes: <String>[
    'https://www.googleapis.com/auth/gmail.send'
  ],
);

Future<Null> handleSignOut() async {
    googleSignIn.disconnect();
  }

void main() {
  runApp(new MyApp());
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {


  Future<Null> testingEmail(userId, header) async {
    
    String url = 'https://www.googleapis.com/gmail/v1/users/' + userId + '/messages/send';

    final http.Response response = await http.post(
      url,
      headers: await header,
      body: {
        'from': userId,
        'to': userId,
        'subject': 'testing send email',
        'text': 'worked!!!'
      }
    );
    if (response.statusCode != 200) {
      setState(() {
        print('error: ' + response.statusCode.toString());
        print(url);
        print(json.decode(response.body));
      });
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    print('ok: ' + response.statusCode.toString());
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    var assetImage = new AssetImage('assets/google-g-logo.png');
    var image = new Image(image: assetImage, width: 96.0, height: 96.0);

    var loginPage = new Scaffold(
      backgroundColor: Colors.pink[400],
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Material(
              color: Colors.white,
              type: MaterialType.circle,
              elevation: 6.0,
              child: new GestureDetector(
                child: new Container(
                  width: 112.0,
                  height: 112.0,
                  child: new InkWell(
                    onTap: () async {
                      try {
                        await googleSignIn.signIn().then((data) {
                          testingEmail(data.email, data.authHeaders);
                        });
                      } catch (error) {
                        print(error);
                      }
                    },
                    child: new Center(
                      child: image
                    ),
                  )
                ),
              )
            ),

            new Container(
              margin: new EdgeInsets.only(top: 16.0),
              child: new Text(
                'Sign up with Google',
                style: new TextStyle(
                  color: Colors.white,
                  fontFamily: "Futura",
                  fontSize: 18.0
                ),
              ),
            ),
          ],
        )
      )
    );

    return loginPage;
  }
}

