Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FF3322B9F;
	Mon, 13 Apr 2026 16:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099311; cv=none; b=az0Khb2fQmO8Q73bTKkpvZbWMqfKoJnljZucTeSAncPRNpy12c6wo/xQ8koCKmaO6AvQ4PFLjd2VfGD0Q/zIngB2b6YfQx6iP+kFCka+/KoW+7Zl12JvsWSOmmrhIijXst5uEagT9i3q85svUfmpMaia13+zZyBxHbZDCr1HoWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099311; c=relaxed/simple;
	bh=X3tAUJ002kdZbFyCwkgiWoC0bB+cqWv7CQGGyjzOwGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WfqLYKYk9MN8Q/D4pcUmgMyRZYPiphygYvvJhabFPwgwa6cntNa1mZPuWIXdkECzM0e6v56gModhmCKFHW+3/gPLwRaZFRDgy0kVv8I18CAQXdOeWOJUGt+JxPwvKgFgT2cz/15U9Pg1CnV2D39aZAQV5JBzA+h255mTA7MBY00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+TGrSvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+TGrSvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CD2C2BCAF;
	Mon, 13 Apr 2026 16:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099311;
	bh=X3tAUJ002kdZbFyCwkgiWoC0bB+cqWv7CQGGyjzOwGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+TGrSvFkpylDdCixGvm59Hw5lL+etUHZBAsjee6HhZSkaR5RY1E9WHLf7a4D4AD/
	 MYr1i9H7lli+MP0N64pzHrAxaWEiZ998Gk7iybPJFrqphxmErv503bGnbhLlwHmyCU
	 fZsY4NvO7TV3hq4sv+KKUvqIl7PNNNsEAV9Adyec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 292/491] hwmon: (adm1177) fix sysfs ABI violation and current unit conversion
Date: Mon, 13 Apr 2026 17:58:57 +0200
Message-ID: <20260413155829.977215188@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

[ Upstream commit bf08749a6abb6d1959bfdc0edc32c640df407558 ]

The adm1177 driver exposes the current alert threshold through
hwmon_curr_max_alarm. This violates the hwmon sysfs ABI, where
*_alarm attributes are read-only status flags and writable thresholds
must use currN_max.

The driver also stores the threshold internally in microamps, while
currN_max is defined in milliamps. Convert the threshold accordingly
on both the read and write paths.

Widen the cached threshold and related calculations to 64 bits so
that small shunt resistor values do not cause truncation or overflow.
Also use 64-bit arithmetic for the mA/uA conversions, clamp writes
to the range the hardware can represent, and propagate failures from
adm1177_write_alert_thr() instead of silently ignoring them.

Update the hwmon documentation to reflect the attribute rename and
the correct units returned by the driver.

Fixes: 09b08ac9e8d5 ("hwmon: (adm1177) Add ADM1177 Hot Swap Controller and Digital Power Monitor driver")
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20260325051246.28262-1-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/adm1177.rst |  8 ++---
 drivers/hwmon/adm1177.c         | 54 +++++++++++++++++++--------------
 2 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/Documentation/hwmon/adm1177.rst b/Documentation/hwmon/adm1177.rst
index 471be1e98d6f6..fc0c3390c302a 100644
--- a/Documentation/hwmon/adm1177.rst
+++ b/Documentation/hwmon/adm1177.rst
@@ -26,10 +26,10 @@ devices explicitly. Please see :doc:`/i2c/instantiating-devices` for details.
 Sysfs entries
 -------------
 
-The following attributes are supported. Current maxim attribute
+The following attributes are supported. Current maximum attribute
 is read-write, all other attributes are read-only.
 
-in0_input		Measured voltage in microvolts.
+in0_input		Measured voltage in millivolts.
 
-curr1_input		Measured current in microamperes.
-curr1_max_alarm		Overcurrent alarm in microamperes.
+curr1_input		Measured current in milliamperes.
+curr1_max		Overcurrent shutdown threshold in milliamperes.
diff --git a/drivers/hwmon/adm1177.c b/drivers/hwmon/adm1177.c
index 6e8bb661894b9..1ddc95646f19a 100644
--- a/drivers/hwmon/adm1177.c
+++ b/drivers/hwmon/adm1177.c
@@ -10,6 +10,8 @@
 #include <linux/hwmon.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
+#include <linux/math64.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/regulator/consumer.h>
 
@@ -35,7 +37,7 @@ struct adm1177_state {
 	struct i2c_client	*client;
 	struct regulator	*reg;
 	u32			r_sense_uohm;
-	u32			alert_threshold_ua;
+	u64			alert_threshold_ua;
 	bool			vrange_high;
 };
 
@@ -50,7 +52,7 @@ static int adm1177_write_cmd(struct adm1177_state *st, u8 cmd)
 }
 
 static int adm1177_write_alert_thr(struct adm1177_state *st,
-				   u32 alert_threshold_ua)
+				   u64 alert_threshold_ua)
 {
 	u64 val;
 	int ret;
@@ -93,8 +95,8 @@ static int adm1177_read(struct device *dev, enum hwmon_sensor_types type,
 			*val = div_u64((105840000ull * dummy),
 				       4096 * st->r_sense_uohm);
 			return 0;
-		case hwmon_curr_max_alarm:
-			*val = st->alert_threshold_ua;
+		case hwmon_curr_max:
+			*val = div_u64(st->alert_threshold_ua, 1000);
 			return 0;
 		default:
 			return -EOPNOTSUPP;
@@ -128,9 +130,10 @@ static int adm1177_write(struct device *dev, enum hwmon_sensor_types type,
 	switch (type) {
 	case hwmon_curr:
 		switch (attr) {
-		case hwmon_curr_max_alarm:
-			adm1177_write_alert_thr(st, val);
-			return 0;
+		case hwmon_curr_max:
+			val = clamp_val(val, 0,
+					div_u64(105840000ULL, st->r_sense_uohm));
+			return adm1177_write_alert_thr(st, (u64)val * 1000);
 		default:
 			return -EOPNOTSUPP;
 		}
@@ -158,7 +161,7 @@ static umode_t adm1177_is_visible(const void *data,
 			if (st->r_sense_uohm)
 				return 0444;
 			return 0;
-		case hwmon_curr_max_alarm:
+		case hwmon_curr_max:
 			if (st->r_sense_uohm)
 				return 0644;
 			return 0;
@@ -172,7 +175,7 @@ static umode_t adm1177_is_visible(const void *data,
 
 static const struct hwmon_channel_info *adm1177_info[] = {
 	HWMON_CHANNEL_INFO(curr,
-			   HWMON_C_INPUT | HWMON_C_MAX_ALARM),
+			   HWMON_C_INPUT | HWMON_C_MAX),
 	HWMON_CHANNEL_INFO(in,
 			   HWMON_I_INPUT),
 	NULL
@@ -201,7 +204,8 @@ static int adm1177_probe(struct i2c_client *client)
 	struct device *dev = &client->dev;
 	struct device *hwmon_dev;
 	struct adm1177_state *st;
-	u32 alert_threshold_ua;
+	u64 alert_threshold_ua;
+	u32 prop;
 	int ret;
 
 	st = devm_kzalloc(dev, sizeof(*st), GFP_KERNEL);
@@ -229,22 +233,26 @@ static int adm1177_probe(struct i2c_client *client)
 	if (device_property_read_u32(dev, "shunt-resistor-micro-ohms",
 				     &st->r_sense_uohm))
 		st->r_sense_uohm = 0;
-	if (device_property_read_u32(dev, "adi,shutdown-threshold-microamp",
-				     &alert_threshold_ua)) {
-		if (st->r_sense_uohm)
-			/*
-			 * set maximum default value from datasheet based on
-			 * shunt-resistor
-			 */
-			alert_threshold_ua = div_u64(105840000000,
-						     st->r_sense_uohm);
-		else
-			alert_threshold_ua = 0;
+	if (!device_property_read_u32(dev, "adi,shutdown-threshold-microamp",
+				      &prop)) {
+		alert_threshold_ua = prop;
+	} else if (st->r_sense_uohm) {
+		/*
+		 * set maximum default value from datasheet based on
+		 * shunt-resistor
+		 */
+		alert_threshold_ua = div_u64(105840000000ULL,
+					     st->r_sense_uohm);
+	} else {
+		alert_threshold_ua = 0;
 	}
 	st->vrange_high = device_property_read_bool(dev,
 						    "adi,vrange-high-enable");
-	if (alert_threshold_ua && st->r_sense_uohm)
-		adm1177_write_alert_thr(st, alert_threshold_ua);
+	if (alert_threshold_ua && st->r_sense_uohm) {
+		ret = adm1177_write_alert_thr(st, alert_threshold_ua);
+		if (ret)
+			return ret;
+	}
 
 	ret = adm1177_write_cmd(st, ADM1177_CMD_V_CONT |
 				    ADM1177_CMD_I_CONT |
-- 
2.53.0



