Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2923CB56A;
	Wed, 30 Sep 2026 19:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795911; cv=none; b=jq3cz3KvuRjnvBSbUk02b3hhT/1PJ5+koMTWYIg62kmQjVxeT6TgkoqTlBO1ZdQYk935qhJu4XPEvOr8PxM8ion/Ukbh6ORe+jFqj8CzWdEOlw3Oqts7SwX9U4eNgv+Llghotp9qWdAvk+i9Fzz0bu3eoRlJjQOboIOGN/nclEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795911; c=relaxed/simple;
	bh=nBJEprNNyS9ZWhvHn09JuHWo3b6AhVc6K9MPjy6TXZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sr/hDqRezp5hUqB7AUUW7k1bL6mvxJAohGDivMfYQkaUdZffvgjfgzWquyk/V165YqScyTC4szGmk4ilogaBKLM7z5N75aXGZvix4baoPetnZq/mvupMHeN2rwn1+9aW1SRY3HyWejabsNzLHmaPLFgDfBfzmknzPsSontlyjCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1m07l1ps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1m07l1ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F7C1F000FF;
	Wed, 30 Sep 2026 19:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795910;
	bh=Lt/BzHK82vj9TA8L9YCEBQtW66/KfcRgfCU5UlwCO/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1m07l1psoXY1Jo4VIhJqnrbwo+besySgj6LbvFhb0oiAh4UPrj/NwM9XzvJCRRb6L
	 nbGH43fij0iI6Nb1ZyhIjHr6dDQcvb+UmVUQDLucDY8QwYwa2sIrZ70e4+mUPhQjrH
	 toSuyczOTj98zELLPmKMBT0Dh6b7fiyVkY/9ACPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0710/1193] Revert "hwmon: (emc1403) Rely on subsystem locking"
Date: Wed, 30 Sep 2026 17:23:14 +0200
Message-ID: <20260930152450.023989115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

This reverts commit e43ba8be636ab54bcf3f90a0ccd36e2bc3df3274.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/emc1403.c | 46 ++++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index ad4fc64824bc4..0011a1d100075 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -17,6 +17,7 @@
 #include <linux/hwmon-sysfs.h>
 #include <linux/err.h>
 #include <linux/sysfs.h>
+#include <linux/mutex.h>
 #include <linux/regmap.h>
 
 #define THERMAL_PID_REG		0xfd
@@ -28,6 +29,7 @@ enum emc1403_chip { emc1402, emc1403, emc1404, emc1428 };
 struct thermal_data {
 	enum emc1403_chip chip;
 	struct regmap *regmap;
+	struct mutex mutex;
 };
 
 static ssize_t power_state_show(struct device *dev, struct device_attribute *attr, char *buf)
@@ -265,8 +267,8 @@ static s8 emc1403_temp_regs_low[][4] = {
 	},
 };
 
-static int emc1403_get_temp(struct thermal_data *data, int channel,
-			    enum emc1403_reg_map map, long *val)
+static int __emc1403_get_temp(struct thermal_data *data, int channel,
+			      enum emc1403_reg_map map, long *val)
 {
 	unsigned int regvalh;
 	unsigned int regvall = 0;
@@ -292,23 +294,38 @@ static int emc1403_get_temp(struct thermal_data *data, int channel,
 	return 0;
 }
 
+static int emc1403_get_temp(struct thermal_data *data, int channel,
+			    enum emc1403_reg_map map, long *val)
+{
+	int ret;
+
+	mutex_lock(&data->mutex);
+	ret = __emc1403_get_temp(data, channel, map, val);
+	mutex_unlock(&data->mutex);
+
+	return ret;
+}
+
 static int emc1403_get_hyst(struct thermal_data *data, int channel,
 			    enum emc1403_reg_map map, long *val)
 {
 	int hyst, ret;
 	long limit;
 
-	ret = emc1403_get_temp(data, channel, map, &limit);
+	mutex_lock(&data->mutex);
+	ret = __emc1403_get_temp(data, channel, map, &limit);
 	if (ret < 0)
-		return ret;
+		goto unlock;
 	ret = regmap_read(data->regmap, 0x21, &hyst);
 	if (ret < 0)
-		return ret;
+		goto unlock;
 	if (map == temp_min)
 		*val = limit + hyst * 1000;
 	else
 		*val = limit - hyst * 1000;
-	return 0;
+unlock:
+	mutex_unlock(&data->mutex);
+	return ret;
 }
 
 static int emc1403_temp_read(struct thermal_data *data, u32 attr, int channel, long *val)
@@ -406,16 +423,20 @@ static int emc1403_set_hyst(struct thermal_data *data, long val)
 	else
 		val = clamp_val(val, 0, 255000);
 
-	ret = emc1403_get_temp(data, 0, temp_crit, &limit);
+	mutex_lock(&data->mutex);
+	ret = __emc1403_get_temp(data, 0, temp_crit, &limit);
 	if (ret < 0)
-		return ret;
+		goto unlock;
 
 	hyst = limit - val;
 	if (data->chip == emc1428)
 		hyst = clamp_val(DIV_ROUND_CLOSEST(hyst, 1000), 0, 127);
 	else
 		hyst = clamp_val(DIV_ROUND_CLOSEST(hyst, 1000), 0, 255);
-	return regmap_write(data->regmap, 0x21, hyst);
+	ret = regmap_write(data->regmap, 0x21, hyst);
+unlock:
+	mutex_unlock(&data->mutex);
+	return ret;
 }
 
 static int emc1403_set_temp(struct thermal_data *data, int channel,
@@ -429,6 +450,7 @@ static int emc1403_set_temp(struct thermal_data *data, int channel,
 	regh = emc1403_temp_regs[channel][map];
 	regl = emc1403_temp_regs_low[channel][map];
 
+	mutex_lock(&data->mutex);
 	if (regl >= 0) {
 		if (data->chip == emc1428)
 			val = clamp_val(val, -128000, 127875);
@@ -437,7 +459,7 @@ static int emc1403_set_temp(struct thermal_data *data, int channel,
 		regval = DIV_ROUND_CLOSEST(val, 125);
 		ret = regmap_write(data->regmap, regh, (regval >> 3) & 0xff);
 		if (ret < 0)
-			return ret;
+			goto unlock;
 		ret = regmap_write(data->regmap, regl, (regval & 0x07) << 5);
 	} else {
 		if (data->chip == emc1428)
@@ -447,6 +469,8 @@ static int emc1403_set_temp(struct thermal_data *data, int channel,
 		regval = DIV_ROUND_CLOSEST(val, 1000);
 		ret = regmap_write(data->regmap, regh, regval);
 	}
+unlock:
+	mutex_unlock(&data->mutex);
 	return ret;
 }
 
@@ -604,6 +628,8 @@ static int emc1403_probe(struct i2c_client *client)
 	if (IS_ERR(data->regmap))
 		return PTR_ERR(data->regmap);
 
+	mutex_init(&data->mutex);
+
 	hwmon_dev = devm_hwmon_device_register_with_info(&client->dev,
 							 client->name, data,
 							 &emc1403_chip_info,
-- 
2.53.0



