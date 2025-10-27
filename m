Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B89248898;
	Mon, 27 Oct 2025 19:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593449; cv=none; b=QfqfcxTok83dqkWdFqFqtfqZZqwnrjs81KQwB9hmdfFAyzojUm9QANqI3PaDDYo3fXYIfI0Hk9PmAINosBj4XafLDJ9av+jGoZv831/rW9nIylXyWWBUNMOl78p0qB8XtTGYQcIqt8h30irJ9wu7iJjK/z6wTkWtA2om8c4NUlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593449; c=relaxed/simple;
	bh=ywpgz5JkIBi7qXyyVO+yqyK379eiH/xD7NswlMb53jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGq2qD5uAIaFj4WcokHA4uPd+Xb0Sg8qf9tPJob6fArwTzxrvSqOgEuModZje1hHBDz3FKdmT9YNY40UFhlwmgI41HeCkKzXWDwJ4vkCsn29FU9RbHLkBS1YzgkLTzWTr5wetAJ/dfRsPb4Btjh6xg/LsUAU7C09wJLGWo1smqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vy4iFXo+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vy4iFXo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9B8C4CEF1;
	Mon, 27 Oct 2025 19:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593449;
	bh=ywpgz5JkIBi7qXyyVO+yqyK379eiH/xD7NswlMb53jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vy4iFXo+HRkdSLQ6sljX4qi/LB0V4azO2oRHlBVDIJkRPv0AzmwE7gJScBkB2c2fi
	 98nSoXYpUq+X9WpAvMgbXPIfcxDAmdhQ0qwaHpq76buI3mk2n8o5rIkI9CnP0us8R5
	 i7xMm351dO1uegrWpaRSMFLpUEcnTP/AN0Dbk7fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	JuenKit Yip <JuenKit_Yip@hotmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 137/184] hwmon: (sht3x) Fix error handling
Date: Mon, 27 Oct 2025 19:36:59 +0100
Message-ID: <20251027183518.636164566@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 8dcc66ad379ec0642fb281c45ccfd7d2d366e53f ]

Handling of errors when reading status, temperature, and humidity returns
the error number as negative attribute value. Fix it up by returning
the error as return value.

Fixes: a0ac418c6007c ("hwmon: (sht3x) convert some of sysfs interface to hwmon")
Cc: JuenKit Yip <JuenKit_Yip@hotmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sht3x.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/hwmon/sht3x.c b/drivers/hwmon/sht3x.c
index 557ad3e7752a9..f36c0229328fa 100644
--- a/drivers/hwmon/sht3x.c
+++ b/drivers/hwmon/sht3x.c
@@ -291,24 +291,26 @@ static struct sht3x_data *sht3x_update_client(struct device *dev)
 	return data;
 }
 
-static int temp1_input_read(struct device *dev)
+static int temp1_input_read(struct device *dev, long *temp)
 {
 	struct sht3x_data *data = sht3x_update_client(dev);
 
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-	return data->temperature;
+	*temp = data->temperature;
+	return 0;
 }
 
-static int humidity1_input_read(struct device *dev)
+static int humidity1_input_read(struct device *dev, long *humidity)
 {
 	struct sht3x_data *data = sht3x_update_client(dev);
 
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-	return data->humidity;
+	*humidity = data->humidity;
+	return 0;
 }
 
 /*
@@ -706,6 +708,7 @@ static int sht3x_read(struct device *dev, enum hwmon_sensor_types type,
 		      u32 attr, int channel, long *val)
 {
 	enum sht3x_limits index;
+	int ret;
 
 	switch (type) {
 	case hwmon_chip:
@@ -720,10 +723,12 @@ static int sht3x_read(struct device *dev, enum hwmon_sensor_types type,
 	case hwmon_temp:
 		switch (attr) {
 		case hwmon_temp_input:
-			*val = temp1_input_read(dev);
-			break;
+			return temp1_input_read(dev, val);
 		case hwmon_temp_alarm:
-			*val = temp1_alarm_read(dev);
+			ret = temp1_alarm_read(dev);
+			if (ret < 0)
+				return ret;
+			*val = ret;
 			break;
 		case hwmon_temp_max:
 			index = limit_max;
@@ -748,10 +753,12 @@ static int sht3x_read(struct device *dev, enum hwmon_sensor_types type,
 	case hwmon_humidity:
 		switch (attr) {
 		case hwmon_humidity_input:
-			*val = humidity1_input_read(dev);
-			break;
+			return humidity1_input_read(dev, val);
 		case hwmon_humidity_alarm:
-			*val = humidity1_alarm_read(dev);
+			ret = humidity1_alarm_read(dev);
+			if (ret < 0)
+				return ret;
+			*val = ret;
 			break;
 		case hwmon_humidity_max:
 			index = limit_max;
-- 
2.51.0



