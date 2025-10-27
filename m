Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D1931BCBC;
	Mon, 27 Oct 2025 19:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592971; cv=none; b=YHkldWjTbi2ssB+9MLjKu51EH5jgEMYUXOi94NP/xI40GYH+BKSe62F4DDO1Oe7w+bU4YTBOJcVjienax7bHhrrOfnDh2WJ/9/Juoh3doOpBcJIRUqG4KneYGSMs0vi2hNvhQhaXXN3t3DWLbpF3GhiE3XiFXDwJDqRHEEYT61k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592971; c=relaxed/simple;
	bh=tG2wfFnbIV7IO5Jq0CCr1+3HZO7NL1C/ko5Xkv+0qOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gtn/x/qr0Hr4nhazRwZaLpjTID7ngKvVbcEdIndHKqDraiMV30dtRo8FLiPHt04LKDxjjXwGKsQyOaMg8YrTypxkemNy0mMf5u7PLS9ks729hy/0HxQ9/zZVHoCXC6ksyUCStnxex0QCe7KxBDLf6U94xV/zjDpMs7UZS06SXYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5mLZpaf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5mLZpaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B27C4CEF1;
	Mon, 27 Oct 2025 19:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592971;
	bh=tG2wfFnbIV7IO5Jq0CCr1+3HZO7NL1C/ko5Xkv+0qOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c5mLZpaf4rQ1NSu5elYjFn8ixU2lB/slcXaVZ5MAWRK2VK9CH2Pe8rCEry9JOvool
	 RsQZuBDxQGzXXWjxVeNEs7tVNF0TWbhzVgpVinY6cKipVL8XjQfbwkE2OPLZJFqAJ9
	 9P0IWKjxQFhlK6/Qb5wp7XC+EWkTKjz07lND5sYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	JuenKit Yip <JuenKit_Yip@hotmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/117] hwmon: (sht3x) Fix error handling
Date: Mon, 27 Oct 2025 19:36:49 +0100
Message-ID: <20251027183456.271021806@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 650b0bcc2359e..94466e28dc56f 100644
--- a/drivers/hwmon/sht3x.c
+++ b/drivers/hwmon/sht3x.c
@@ -294,24 +294,26 @@ static struct sht3x_data *sht3x_update_client(struct device *dev)
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
@@ -709,6 +711,7 @@ static int sht3x_read(struct device *dev, enum hwmon_sensor_types type,
 		      u32 attr, int channel, long *val)
 {
 	enum sht3x_limits index;
+	int ret;
 
 	switch (type) {
 	case hwmon_chip:
@@ -723,10 +726,12 @@ static int sht3x_read(struct device *dev, enum hwmon_sensor_types type,
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
@@ -751,10 +756,12 @@ static int sht3x_read(struct device *dev, enum hwmon_sensor_types type,
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



