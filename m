Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1156339B946
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302586; cv=none; b=sgr/WK+/ZXCSPkXm5i4uXmHWB3Cn0FvnVQ/Jzh/2nwXonNIad6lU4vNxFHCuK4A/YPwkynQcfu3SHZ8MoHpkAtDRZYRTr43P4XMzN8afNdWHBxtJpLTD4yKxLvoa8jdp574Xw1Ok21yQwWD2FW7Q13SNgFGaGMYMEyiH9fZWPLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302586; c=relaxed/simple;
	bh=UaC3z+7McdY0bhVwIOllUItp948wc0foMp/xTaOM+gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxhkeDqiKsnTXZ3lrTr7wjnpaQ2CKTd5R3cd1GhcAm7e3BIOkO2R31v6PgEDQ49pMUr/HBBb6M3rmjCIBs1Mo6MHgawcEFSb5i1WO7UH78GDQg90cKc4Y2y+yObxruK/v+wgWCs8VHUuUY0Er2uRtDmlmGnA8uvWCxX4mNH7sdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJhBoCl9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJhBoCl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78401C116D0;
	Sat, 28 Feb 2026 18:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302585;
	bh=UaC3z+7McdY0bhVwIOllUItp948wc0foMp/xTaOM+gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJhBoCl98p3W80E1kEY01nxXR/827rFSTcD1lEEMcJGcxqf2bwnZH75DMEZ5B6Cii
	 U52RBsaE+AaClDZ/2aqocaTOsqyZs8dOQ+DBz1hi+K3znJPfNcR7B3xuTQt+4x3yp0
	 O7VJGhiU50d+DQC0q2eD9YTQeRaKe67hv4s8a2mTDvhCi6GAyJVB/xscP9aBRJ2zGH
	 mQm3n/ijAWFhaoCulUDGLtdlG9G6AgmbJ9nMi6doQnOlkVmPe+lpN8qZxfMyd8zIAO
	 de4jPy4SEDbqWXUX9ctHbCBS6Qefwxw7C7Bmg98J72/XaD0sv/2aEM8iHSZwv17KfI
	 EhNczV1tJpsww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/164] power: supply: ab8500: Use core battery parser
Date: Sat, 28 Feb 2026 13:13:54 -0500
Message-ID: <20260228181505.1600663-95-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 59f1b854706d4d6830a3ed0f6b535a2ba5d425a6 ]

This deploys the core battery DT parser to read the basic properties
of the battery. We only use very little of it as we start out, but
we will improve as we go along.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: c4af8a98bb52 ("power: supply: ab8500: Fix use-after-free in power_supply_changed()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500-bm.h      |  3 +--
 drivers/power/supply/ab8500_bmdata.c  | 31 +++++++++++----------------
 drivers/power/supply/ab8500_charger.c | 16 +++++++++-----
 3 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/power/supply/ab8500-bm.h b/drivers/power/supply/ab8500-bm.h
index d11405b7ee1aa..33c7e15f5d96e 100644
--- a/drivers/power/supply/ab8500-bm.h
+++ b/drivers/power/supply/ab8500-bm.h
@@ -570,8 +570,7 @@ int ab8500_fg_inst_curr_start(struct ab8500_fg *di);
 int ab8500_fg_inst_curr_finalize(struct ab8500_fg *di, int *res);
 int ab8500_fg_inst_curr_started(struct ab8500_fg *di);
 int ab8500_fg_inst_curr_done(struct ab8500_fg *di);
-int ab8500_bm_of_probe(struct device *dev,
-		       struct device_node *np,
+int ab8500_bm_of_probe(struct power_supply *psy,
 		       struct ab8500_bm_data *bm);
 
 extern struct platform_driver ab8500_fg_driver;
diff --git a/drivers/power/supply/ab8500_bmdata.c b/drivers/power/supply/ab8500_bmdata.c
index bfc1245d79123..a515dfad4c3fd 100644
--- a/drivers/power/supply/ab8500_bmdata.c
+++ b/drivers/power/supply/ab8500_bmdata.c
@@ -488,29 +488,22 @@ struct ab8500_bm_data ab8500_bm_data = {
         .n_chg_in_curr          = ARRAY_SIZE(ab8500_charge_input_curr_map),
 };
 
-int ab8500_bm_of_probe(struct device *dev,
-		       struct device_node *np,
+int ab8500_bm_of_probe(struct power_supply *psy,
 		       struct ab8500_bm_data *bm)
 {
 	const struct batres_vs_temp *tmp_batres_tbl;
-	struct device_node *battery_node;
-	const char *btech;
+	struct power_supply_battery_info info;
+	struct device *dev = &psy->dev;
+	int ret;
 	int i;
 
-	battery_node = of_parse_phandle(np, "monitored-battery", 0);
-	if (!battery_node) {
-		dev_err(dev, "battery node or reference missing\n");
-		return -EINVAL;
+	ret = power_supply_get_battery_info(psy, &info);
+	if (ret) {
+		dev_err(dev, "cannot retrieve battery info\n");
+		return ret;
 	}
 
-	btech = of_get_property(battery_node, "stericsson,battery-type", NULL);
-	if (!btech) {
-		dev_warn(dev, "missing property battery-name/type\n");
-		of_node_put(battery_node);
-		return -EINVAL;
-	}
-
-	if (strncmp(btech, "LION", 4) == 0) {
+	if (info.technology == POWER_SUPPLY_TECHNOLOGY_LION) {
 		bm->no_maintenance  = true;
 		bm->chg_unknown_bat = true;
 		bm->bat_type[BATTERY_UNKNOWN].charge_full_design = 2600;
@@ -520,8 +513,8 @@ int ab8500_bm_of_probe(struct device *dev,
 		bm->bat_type[BATTERY_UNKNOWN].normal_vol_lvl     = 4200;
 	}
 
-	if (of_property_read_bool(battery_node, "thermistor-on-batctrl")) {
-		if (strncmp(btech, "LION", 4) == 0)
+	if (of_property_read_bool(psy->of_node, "thermistor-on-batctrl")) {
+		if (info.technology == POWER_SUPPLY_TECHNOLOGY_LION)
 			tmp_batres_tbl = temp_to_batres_tbl_9100;
 		else
 			tmp_batres_tbl = temp_to_batres_tbl_thermistor;
@@ -536,7 +529,7 @@ int ab8500_bm_of_probe(struct device *dev,
 	for (i = 0; i < bm->n_btypes; ++i)
 		bm->bat_type[i].batres_tbl = tmp_batres_tbl;
 
-	of_node_put(battery_node);
+	power_supply_put_battery_info(psy, &info);
 
 	return 0;
 }
diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index a4f766fc7c9d7..6af946ca06a94 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3413,11 +3413,6 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 
 	di->bm = &ab8500_bm_data;
 
-	ret = ab8500_bm_of_probe(dev, np, di->bm);
-	if (ret) {
-		dev_err(dev, "failed to get battery information\n");
-		return ret;
-	}
 	di->autopower_cfg = of_property_read_bool(np, "autopower_cfg");
 
 	/* get parent data */
@@ -3490,9 +3485,11 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	di->invalid_charger_detect_state = 0;
 
 	/* AC and USB supply config */
+	ac_psy_cfg.of_node = np;
 	ac_psy_cfg.supplied_to = supply_interface;
 	ac_psy_cfg.num_supplicants = ARRAY_SIZE(supply_interface);
 	ac_psy_cfg.drv_data = &di->ac_chg;
+	usb_psy_cfg.of_node = np;
 	usb_psy_cfg.supplied_to = supply_interface;
 	usb_psy_cfg.num_supplicants = ARRAY_SIZE(supply_interface);
 	usb_psy_cfg.drv_data = &di->usb_chg;
@@ -3610,6 +3607,15 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 		return PTR_ERR(di->usb_chg.psy);
 	}
 
+	/*
+	 * Check what battery we have, since we always have the USB
+	 * psy, use that as a handle.
+	 */
+	ret = ab8500_bm_of_probe(di->usb_chg.psy, di->bm);
+	if (ret)
+		return dev_err_probe(dev, ret,
+				     "failed to get battery information\n");
+
 	/* Identify the connected charger types during startup */
 	charger_status = ab8500_charger_detect_chargers(di, true);
 	if (charger_status & AC_PW_CONN) {
-- 
2.51.0

