Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B3E38734D;
	Thu, 12 Mar 2026 20:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347288; cv=none; b=qNIsJyoiT5Zx4WLOm3TgS/kVv3hCFPli2EHhtmjYG/19I59CZZO6P0I4JJ/xnPV8wDQYg3Pi7qivBZOmekGC6rCSvGdopc5/p9Bkz6O2yU8QIRrMJ6y4Tcv9H4cpvVhfMWfMfy6BlQdQjpEPsBUpjnPyTFtRBdyionKFcEF2TGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347288; c=relaxed/simple;
	bh=3KG3gz7nesUdUPRQSzARX+O4p2KlvyfC0HIcPjbEVxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtvFFoVhuCeOpuKgHzEYDUdpudlLxsaIdxJzxzoE/nsotRN35xkzHPok+mqEi+JIOogCBD7ohJ9MdI7tM1ZxhfYmUq5mMpMMV+8aEMFcTGErgOpZz8O6hWHnv6VUtmCHjLygFY2mGQTZJ9VhHbCHT9xTvlcdCDu7in+qx215pnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boXYSmTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boXYSmTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCB8C2BC86;
	Thu, 12 Mar 2026 20:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347285;
	bh=3KG3gz7nesUdUPRQSzARX+O4p2KlvyfC0HIcPjbEVxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boXYSmTpwh3ZupiyFP5OFMC+kZVUXS/WFjQMX2dMj8aISrvxE7zG0xSUwZv8aOvq0
	 zLPTrcnCNesWnSmbWGKSPFtcHmL/z2llr70XmJx0KrHZmmW6wey+hdKoOuqoxODslj
	 mgRs0nPmICN5fC3gq85ojhhnmpl6b0XOefJEWaNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naresh Solanki <naresh.solanki@9elements.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 225/265] hwmon: (max6639) : Configure based on DT property
Date: Thu, 12 Mar 2026 21:10:12 +0100
Message-ID: <20260312201026.453533701@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Naresh Solanki <naresh.solanki@9elements.com>

[ Upstream commit 7506ebcd662b868780774d191a7c024c18c557a8 ]

Remove platform data & initialize with defaults
configuration & overwrite based on DT properties.

Signed-off-by: Naresh Solanki <naresh.solanki@9elements.com>
Message-ID: <20241007090426.811736-1-naresh.solanki@9elements.com>
[groeck: Dropped some unnecessary empty lines]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 170a4b21f49b ("hwmon: (max6639) fix inverted polarity")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/max6639.c               | 83 +++++++++++++++++++--------
 include/linux/platform_data/max6639.h | 15 -----
 2 files changed, 60 insertions(+), 38 deletions(-)
 delete mode 100644 include/linux/platform_data/max6639.h

diff --git a/drivers/hwmon/max6639.c b/drivers/hwmon/max6639.c
index c955b0f3a8d31..32b4d54b20766 100644
--- a/drivers/hwmon/max6639.c
+++ b/drivers/hwmon/max6639.c
@@ -19,7 +19,6 @@
 #include <linux/hwmon-sysfs.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
-#include <linux/platform_data/max6639.h>
 #include <linux/regmap.h>
 #include <linux/util_macros.h>
 
@@ -531,14 +530,49 @@ static int rpm_range_to_reg(int range)
 	return 1; /* default: 4000 RPM */
 }
 
+static int max6639_probe_child_from_dt(struct i2c_client *client,
+				       struct device_node *child,
+				       struct max6639_data *data)
+
+{
+	struct device *dev = &client->dev;
+	u32 i;
+	int err, val;
+
+	err = of_property_read_u32(child, "reg", &i);
+	if (err) {
+		dev_err(dev, "missing reg property of %pOFn\n", child);
+		return err;
+	}
+
+	if (i > 1) {
+		dev_err(dev, "Invalid fan index reg %d\n", i);
+		return -EINVAL;
+	}
+
+	err = of_property_read_u32(child, "pulses-per-revolution", &val);
+	if (!err) {
+		if (val < 1 || val > 5) {
+			dev_err(dev, "invalid pulses-per-revolution %d of %pOFn\n", val, child);
+			return -EINVAL;
+		}
+		data->ppr[i] = val;
+	}
+
+	err = of_property_read_u32(child, "max-rpm", &val);
+	if (!err)
+		data->rpm_range[i] = rpm_range_to_reg(val);
+
+	return 0;
+}
+
 static int max6639_init_client(struct i2c_client *client,
 			       struct max6639_data *data)
 {
-	struct max6639_platform_data *max6639_info =
-		dev_get_platdata(&client->dev);
-	int i;
-	int rpm_range = 1; /* default: 4000 RPM */
-	int err, ppr;
+	struct device *dev = &client->dev;
+	const struct device_node *np = dev->of_node;
+	struct device_node *child;
+	int i, err;
 
 	/* Reset chip to default values, see below for GCONFIG setup */
 	err = regmap_write(data->regmap, MAX6639_REG_GCONFIG, MAX6639_GCONFIG_POR);
@@ -546,21 +580,29 @@ static int max6639_init_client(struct i2c_client *client,
 		return err;
 
 	/* Fans pulse per revolution is 2 by default */
-	if (max6639_info && max6639_info->ppr > 0 &&
-			max6639_info->ppr < 5)
-		ppr = max6639_info->ppr;
-	else
-		ppr = 2;
+	data->ppr[0] = 2;
+	data->ppr[1] = 2;
+
+	/* default: 4000 RPM */
+	data->rpm_range[0] = 1;
+	data->rpm_range[1] = 1;
 
-	data->ppr[0] = ppr;
-	data->ppr[1] = ppr;
+	for_each_child_of_node(np, child) {
+		if (strcmp(child->name, "fan"))
+			continue;
 
-	if (max6639_info)
-		rpm_range = rpm_range_to_reg(max6639_info->rpm_range);
-	data->rpm_range[0] = rpm_range;
-	data->rpm_range[1] = rpm_range;
+		err = max6639_probe_child_from_dt(client, child, data);
+		if (err) {
+			of_node_put(child);
+			return err;
+		}
+	}
 
 	for (i = 0; i < MAX6639_NUM_CHANNELS; i++) {
+		err = regmap_set_bits(data->regmap, MAX6639_REG_OUTPUT_MASK, BIT(1 - i));
+		if (err)
+			return err;
+
 		/* Set Fan pulse per revolution */
 		err = max6639_set_ppr(data, i, data->ppr[i]);
 		if (err)
@@ -573,12 +615,7 @@ static int max6639_init_client(struct i2c_client *client,
 			return err;
 
 		/* Fans PWM polarity high by default */
-		if (max6639_info) {
-			if (max6639_info->pwm_polarity == 0)
-				err = regmap_write(data->regmap, MAX6639_REG_FAN_CONFIG2a(i), 0x00);
-			else
-				err = regmap_write(data->regmap, MAX6639_REG_FAN_CONFIG2a(i), 0x02);
-		}
+		err = regmap_write(data->regmap, MAX6639_REG_FAN_CONFIG2a(i), 0x00);
 		if (err)
 			return err;
 
diff --git a/include/linux/platform_data/max6639.h b/include/linux/platform_data/max6639.h
deleted file mode 100644
index 65bfdb4fdc157..0000000000000
--- a/include/linux/platform_data/max6639.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _LINUX_MAX6639_H
-#define _LINUX_MAX6639_H
-
-#include <linux/types.h>
-
-/* platform data for the MAX6639 temperature sensor and fan control */
-
-struct max6639_platform_data {
-	bool pwm_polarity;	/* Polarity low (0) or high (1, default) */
-	int ppr;		/* Pulses per rotation 1..4 (default == 2) */
-	int rpm_range;		/* 2000, 4000 (default), 8000 or 16000 */
-};
-
-#endif /* _LINUX_MAX6639_H */
-- 
2.51.0



