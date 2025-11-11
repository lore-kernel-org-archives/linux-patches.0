Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D21724113D;
	Tue, 11 Nov 2025 00:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822748; cv=none; b=a35YTbZ6+/GybO5WW+Pp0c1JxSr2i9ESywFj5BjKTgCBRSE+QWT+ssnMulv3su4WrR/xcS0VDTC7z48q+o75E/NATVriQV/7g+V9fl8t2YGlxGdx0LkgjfjTrUJd9KQRf2osB/bOB73pALPax6TFTWwVTRKPw3OIuJKY1xGKJqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822748; c=relaxed/simple;
	bh=ujacUXIcdcsVOL7jeRhPwG2ADn0Fd1gLxyU3/Ywz0U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KG4SrQ6togTjbAeqykDFPXtX4yejzsvkfLE/CJF5CQjxH4V8GEuUl2Ecyk9ywbN//Rjm9pg4EDt/vGaqijmxi0Ts9bx8wPkWyNGKQlNH9m/zj548tE8RheIVNtuC/9sX/SzwXQoqZTq7em9/VhFvtepKoEtz/hJwYYTCoRhGO5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvA7ycw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvA7ycw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC02C116B1;
	Tue, 11 Nov 2025 00:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822748;
	bh=ujacUXIcdcsVOL7jeRhPwG2ADn0Fd1gLxyU3/Ywz0U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvA7ycw6o/9qj6jf2KLrv47fEiuB3IJeAxFv/TwCWl60Ui7X/i8aNMVnkD3aayImW
	 MclqejHXRENlh4AH4UTYZNAF97IFgHkErcqjjgt9DWmnCbKJhv2N87BrQqCPCv7Eas
	 vFicirAe0YwXzHx6HtXK8OMWXj4TOoX/6KjPU2b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabien Proriol <fabien.proriol@viavisolutions.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 160/849] power: supply: sbs-charger: Support multiple devices
Date: Tue, 11 Nov 2025 09:35:30 +0900
Message-ID: <20251111004540.301666216@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Fabien Proriol <fabien.proriol@viavisolutions.com>

[ Upstream commit 3ec600210849cf122606e24caab85f0b936cf63c ]

If we have 2 instances of sbs-charger in the DTS, the driver probe for the second instance will fail:

[    8.012874] sbs-battery 18-000b: sbs-battery: battery gas gauge device registered
[    8.039094] sbs-charger 18-0009: ltc4100: smart charger device registered
[    8.112911] sbs-battery 20-000b: sbs-battery: battery gas gauge device registered
[    8.134533] sysfs: cannot create duplicate filename '/class/power_supply/sbs-charger'
[    8.143871] CPU: 3 PID: 295 Comm: systemd-udevd Tainted: G           O      5.10.147 #22
[    8.151974] Hardware name: ALE AMB (DT)
[    8.155828] Call trace:
[    8.158292]  dump_backtrace+0x0/0x1d4
[    8.161960]  show_stack+0x18/0x6c
[    8.165280]  dump_stack+0xcc/0x128
[    8.168687]  sysfs_warn_dup+0x60/0x7c
[    8.172353]  sysfs_do_create_link_sd+0xf0/0x100
[    8.176886]  sysfs_create_link+0x20/0x40
[    8.180816]  device_add+0x270/0x7a4
[    8.184311]  __power_supply_register+0x304/0x560
[    8.188930]  devm_power_supply_register+0x54/0xa0
[    8.193644]  sbs_probe+0xc0/0x214 [sbs_charger]
[    8.198183]  i2c_device_probe+0x2dc/0x2f4
[    8.202196]  really_probe+0xf0/0x510
[    8.205774]  driver_probe_device+0xfc/0x160
[    8.209960]  device_driver_attach+0xc0/0xcc
[    8.214146]  __driver_attach+0xc0/0x170
[    8.218002]  bus_for_each_dev+0x74/0xd4
[    8.221862]  driver_attach+0x24/0x30
[    8.225444]  bus_add_driver+0x148/0x250
[    8.229283]  driver_register+0x78/0x130
[    8.233140]  i2c_register_driver+0x4c/0xe0
[    8.237250]  sbs_driver_init+0x20/0x1000 [sbs_charger]
[    8.242424]  do_one_initcall+0x50/0x1b0
[    8.242434]  do_init_module+0x44/0x230
[    8.242438]  load_module+0x2200/0x27c0
[    8.242442]  __do_sys_finit_module+0xa8/0x11c
[    8.242447]  __arm64_sys_finit_module+0x20/0x30
[    8.242457]  el0_svc_common.constprop.0+0x64/0x154
[    8.242464]  do_el0_svc+0x24/0x8c
[    8.242474]  el0_svc+0x10/0x20
[    8.242481]  el0_sync_handler+0x108/0x114
[    8.242485]  el0_sync+0x180/0x1c0
[    8.243847] sbs-charger 20-0009: Failed to register power supply
[    8.287934] sbs-charger: probe of 20-0009 failed with error -17

This is mainly because the "name" field of power_supply_desc is a constant.
This patch fixes the issue by reusing the same approach as sbs-battery.
With this patch, the result is:
[    7.819532] sbs-charger 18-0009: ltc4100: smart charger device registered
[    7.825305] sbs-battery 18-000b: sbs-battery: battery gas gauge device registered
[    7.887423] sbs-battery 20-000b: sbs-battery: battery gas gauge device registered
[    7.893501] sbs-charger 20-0009: ltc4100: smart charger device registered

Signed-off-by: Fabien Proriol <fabien.proriol@viavisolutions.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/sbs-charger.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/sbs-charger.c b/drivers/power/supply/sbs-charger.c
index 27764123b929e..7d5e676205805 100644
--- a/drivers/power/supply/sbs-charger.c
+++ b/drivers/power/supply/sbs-charger.c
@@ -154,8 +154,7 @@ static const struct regmap_config sbs_regmap = {
 	.val_format_endian = REGMAP_ENDIAN_LITTLE, /* since based on SMBus */
 };
 
-static const struct power_supply_desc sbs_desc = {
-	.name = "sbs-charger",
+static const struct power_supply_desc sbs_default_desc = {
 	.type = POWER_SUPPLY_TYPE_MAINS,
 	.properties = sbs_properties,
 	.num_properties = ARRAY_SIZE(sbs_properties),
@@ -165,9 +164,20 @@ static const struct power_supply_desc sbs_desc = {
 static int sbs_probe(struct i2c_client *client)
 {
 	struct power_supply_config psy_cfg = {};
+	struct power_supply_desc *sbs_desc;
 	struct sbs_info *chip;
 	int ret, val;
 
+	sbs_desc = devm_kmemdup(&client->dev, &sbs_default_desc,
+				sizeof(*sbs_desc), GFP_KERNEL);
+	if (!sbs_desc)
+		return -ENOMEM;
+
+	sbs_desc->name = devm_kasprintf(&client->dev, GFP_KERNEL, "sbs-%s",
+					dev_name(&client->dev));
+	if (!sbs_desc->name)
+		return -ENOMEM;
+
 	chip = devm_kzalloc(&client->dev, sizeof(struct sbs_info), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
@@ -191,7 +201,7 @@ static int sbs_probe(struct i2c_client *client)
 		return dev_err_probe(&client->dev, ret, "Failed to get device status\n");
 	chip->last_state = val;
 
-	chip->power_supply = devm_power_supply_register(&client->dev, &sbs_desc, &psy_cfg);
+	chip->power_supply = devm_power_supply_register(&client->dev, sbs_desc, &psy_cfg);
 	if (IS_ERR(chip->power_supply))
 		return dev_err_probe(&client->dev, PTR_ERR(chip->power_supply),
 				     "Failed to register power supply\n");
-- 
2.51.0



