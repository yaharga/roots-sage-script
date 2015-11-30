#!/bin/bash
# Written by Yaser Ali <yaharga@gmail.com>
echo "Please enter the name of the project:"
read projectName
echo "Please enter the title of the site:"
read siteTitle
echo "Please enter the username of the administrator:"
read siteUsername
echo "Please enter the password of the administrator:"
read sitePassword
echo "Please enter the email of the administrator:"
read siteEmail
echo "Please enter the name of the database:"
read databaseName
echo "Please enter the username of the database:"
read databaseUsername
echo "Please enter the password of the database:"
read databasePassword
echo "Please enter the host of the database:"
read databaseHost
echo "Please enter the environment of the WordPress site:"
read wpEnvironment
echo "Please enter the full URL of the WordPress site home:"
read wpURL
echo "Please enter the name of the theme:"
read themeName
sudo -u $(whoami) git clone https://github.com/roots/bedrock.git /applications/mamp/htdocs/$projectName
cd /applications/mamp/htdocs/$projectName
composer install
mv .env.example .env
wp dotenv set DB_NAME $databaseName
wp dotenv set DB_USER $databaseUsername
wp dotenv set DB_PASSWORD $databasePassword
wp dotenv set DB_HOST $databaseHost
wp dotenv set WP_ENV $wpEnvironment
wp dotenv set WP_HOME http://$wpURL
wp dotenv set WP_SITEURL http://$wpURL/wp
wp dotenv salts regenerate
echo "CREATE DATABASE $databaseName; GRANT ALL ON $databaseName.* TO '$databaseUsername'@'localhost';" | /Applications/MAMP/Library/bin/mysql -u$databaseUsername -p$databasePassword
wp core install --url=null --title=$siteTitle --admin_user=$siteUsername --admin_password=$sitePassword --admin_email=$siteEmail
cd ./web/app/themes
sudo -u $(whoami) git clone https://github.com/roots/sage.git $themeName
cd $themeName
npm install -g gulp
npm install -g bower
npm install -g json
npm install
sudo -u $(whoami) bower install
gulp
json -I -f manifest.json -e 'this.config.devUrl='"'$wpURL'"''
