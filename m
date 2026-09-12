Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4318A23BD03;
	Sat, 12 Sep 2026 15:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225660; cv=none; b=E70E7OmmBu+jEUoPdO9/FfM34huIFsUsRK/4MAFVpj2R5a0vfzsSI9/r6eKOIzNVklpsHd1PXtNaMGBIaQweadrKJvJAxN2aUsQz0G9d5xW7bS2xV7VF25aceIBHUSJlSB4qRQ7ymq5y6RKlAZrtlejU7nsmp/EV/fo1lDHewKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225660; c=relaxed/simple;
	bh=sfXZiWy57bmGT+E8t34Baq1bb7P8d9Nt4c8hrwyF58c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Liz4a8AKKku3EcBQHSODYmkoyjLOOAiEuO8qwQttPyZNMpmQ3FKEKEOepRzeofzqLGckPyHfws9wwbn7lL9Bd8HwpOWz8VuNcG5s8A7hEwip0NmYPSh9waF12jjK6VTrAUyJtKyhCjLWCOesl48iqp0uEK1trwUh3SQ0xCdBiv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RaLmpc/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RaLmpc/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482DB1F00893;
	Sat, 12 Sep 2026 15:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225659;
	bh=h7Qt94qN8ZZ8FewlMBkVqitsZCauun1TFHcqt2zuyaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RaLmpc/CujqeNpqoy/7cjvtDHbz4TOiAWEM/VEejDpcTo8FxyMQYB1wFK/880/Ckk
	 r3pcR+IzvQHr653hWSOntyymOmpfmsPWz9mXik5bK9yAN2JIRCJMaThdvj7vx7fYM8
	 o7UMoaqOLrpts+W1SWIGNUAgacNZiZXdsrYr3omQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1244/1424] hwmon: (emc1403) Rely on subsystem locking
Date: Sat, 12 Sep 2026 09:01:16 +0200
Message-ID: <20260912065635.143008112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 61e9b50ffa2390a2927051d335b2ba04b8f791ce ]

Attribute access is now serialized in the hardware monitoring core,
so locking in the driver code is no longer necessary. Drop it.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 75f2c0b36907 ("hwmon: (emc1403) Drop hysteresis for low limit temperature")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/emc1403.c | 46 +++++++++--------------------------------
 1 file changed, 10 insertions(+), 36 deletions(-)

diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index 0011a1d100075..ad4fc64824bc4 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -17,7 +17,6 @@
 #include <linux/hwmon-sysfs.h>
 #include <linux/err.h>
 #include <linux/sysfs.h>
-#include <linux/mutex.h>
 #include <linux/regmap.h>
 
 #define THERMAL_PID_REG		0xfd
@@ -29,7 +28,6 @@ enum emc1403_chip { emc1402, emc1403, emc1404, emc1428 };
 struct thermal_data {
 	enum emc1403_chip chip;
 	struct regmap *regmap;
-	struct mutex mutex;
 };
 
 static ssize_t power_state_show(struct device *dev, struct device_attribute *attr, char *buf)
@@ -267,8 +265,8 @@ static s8 emc1403_temp_regs_low[][4] = {
 	},
 };
 
-static int __emc1403_get_temp(struct thermal_data *data, int channel,
-			      enum emc1403_reg_map map, long *val)
+static int emc1403_get_temp(struct thermal_data *data, int channel,
+			    enum emc1403_reg_map map, long *val)
 {
 	unsigned int regvalh;
 	unsigned int regvall = 0;
@@ -294,38 +292,23 @@ static int __emc1403_get_temp(struct thermal_data *data, int channel,
 	return 0;
 }
 
-static int emc1403_get_temp(struct thermal_data *data, int channel,
-			    enum emc1403_reg_map map, long *val)
-{
-	int ret;
-
-	mutex_lock(&data->mutex);
-	ret = __emc1403_get_temp(data, channel, map, val);
-	mutex_unlock(&data->mutex);
-
-	return ret;
-}
-
 static int emc1403_get_hyst(struct thermal_data *data, int channel,
 			    enum emc1403_reg_map map, long *val)
 {
 	int hyst, ret;
 	long limit;
 
-	mutex_lock(&data->mutex);
-	ret = __emc1403_get_temp(data, channel, map, &limit);
+	ret = emc1403_get_temp(data, channel, map, &limit);
 	if (ret < 0)
-		goto unlock;
+		return ret;
 	ret = regmap_read(data->regmap, 0x21, &hyst);
 	if (ret < 0)
-		goto unlock;
+		return ret;
 	if (map == temp_min)
 		*val = limit + hyst * 1000;
 	else
 		*val = limit - hyst * 1000;
-unlock:
-	mutex_unlock(&data->mutex);
-	return ret;
+	return 0;
 }
 
 static int emc1403_temp_read(struct thermal_data *data, u32 attr, int channel, long *val)
@@ -423,20 +406,16 @@ static int emc1403_set_hyst(struct thermal_data *data, long val)
 	else
 		val = clamp_val(val, 0, 255000);
 
-	mutex_lock(&data->mutex);
-	ret = __emc1403_get_temp(data, 0, temp_crit, &limit);
+	ret = emc1403_get_temp(data, 0, temp_crit, &limit);
 	if (ret < 0)
-		goto unlock;
+		return ret;
 
 	hyst = limit - val;
 	if (data->chip == emc1428)
 		hyst = clamp_val(DIV_ROUND_CLOSEST(hyst, 1000), 0, 127);
 	else
 		hyst = clamp_val(DIV_ROUND_CLOSEST(hyst, 1000), 0, 255);
-	ret = regmap_write(data->regmap, 0x21, hyst);
-unlock:
-	mutex_unlock(&data->mutex);
-	return ret;
+	return regmap_write(data->regmap, 0x21, hyst);
 }
 
 static int emc1403_set_temp(struct thermal_data *data, int channel,
@@ -450,7 +429,6 @@ static int emc1403_set_temp(struct thermal_data *data, int channel,
 	regh = emc1403_temp_regs[channel][map];
 	regl = emc1403_temp_regs_low[channel][map];
 
-	mutex_lock(&data->mutex);
 	if (regl >= 0) {
 		if (data->chip == emc1428)
 			val = clamp_val(val, -128000, 127875);
@@ -459,7 +437,7 @@ static int emc1403_set_temp(struct thermal_data *data, int channel,
 		regval = DIV_ROUND_CLOSEST(val, 125);
 		ret = regmap_write(data->regmap, regh, (regval >> 3) & 0xff);
 		if (ret < 0)
-			goto unlock;
+			return ret;
 		ret = regmap_write(data->regmap, regl, (regval & 0x07) << 5);
 	} else {
 		if (data->chip == emc1428)
@@ -469,8 +447,6 @@ static int emc1403_set_temp(struct thermal_data *data, int channel,
 		regval = DIV_ROUND_CLOSEST(val, 1000);
 		ret = regmap_write(data->regmap, regh, regval);
 	}
-unlock:
-	mutex_unlock(&data->mutex);
 	return ret;
 }
 
@@ -628,8 +604,6 @@ static int emc1403_probe(struct i2c_client *client)
 	if (IS_ERR(data->regmap))
 		return PTR_ERR(data->regmap);
 
-	mutex_init(&data->mutex);
-
 	hwmon_dev = devm_hwmon_device_register_with_info(&client->dev,
 							 client->name, data,
 							 &emc1403_chip_info,
-- 
2.53.0



