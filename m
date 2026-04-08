Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2694347517;
	Wed,  8 Apr 2026 18:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671832; cv=none; b=Md3Sbt4is6+Hhg1RbHnJSIHc25nj0Q5yCzy07jQaaeyt8kePDXb5AL0mJ7UmNFWKHukPydQtD1GlWAmjIWRg06DiKBU7qB+BdU7zBBVbb69cdfZKxY2EjJZyhWMdSLG6cOH/GolK6fGcKkHUxlyOAhf3mtSRhHJKFa4TOAeTq5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671832; c=relaxed/simple;
	bh=goOn7yrbyqdssegj+RxFnv/mVSi6L5e4HxSSGE03DKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kz7y2TKf4RWqlflL3zjyxvf8RQS8FNxOgWjN2fNT2WqUptYG9s9YOnMCXwOAobpjb47g+lhu5EgG9NE72p9oMyhbwxXSDcVJ0jO+HHpzsVnm09Y42Nz0BB65MocA9dHqeu6wtfUB8lnLXalZustk1dVOw3i7G/4jefss1fluTNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sofPBtyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sofPBtyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A953C19421;
	Wed,  8 Apr 2026 18:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671832;
	bh=goOn7yrbyqdssegj+RxFnv/mVSi6L5e4HxSSGE03DKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sofPBtyf7LjxkFL+JiIF5QDE9ANFU50rHZsYiIvi8tyP3aMRlNQ5zHPh+SKF1cIxS
	 o3wwoB27INFRYz1V70D31EbjBWFs+rFTy2U9TkVzEP18sowBQuaK7hSX4zlTVTkn6n
	 qcBWqYIxAebi9+TPHBN1x249gyFGmtTZIy2YOr8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/312] hwmon: (adm1177) fix sysfs ABI violation and current unit conversion
Date: Wed,  8 Apr 2026 20:00:01 +0200
Message-ID: <20260408175936.882604220@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1c85a2af92bf7..375f6d6e03a7d 100644
--- a/Documentation/hwmon/adm1177.rst
+++ b/Documentation/hwmon/adm1177.rst
@@ -27,10 +27,10 @@ for details.
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
index 0c5dbc5e33b46..d2ccb133b2927 100644
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



