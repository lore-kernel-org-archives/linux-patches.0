Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7564746A3;
	Fri,  7 Aug 2026 15:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117488; cv=none; b=IAoXR1P1o/d2vE2QASNaNpr+qqGvKURR1INPQ9iiTc59V9rW6OAL27QOtImsZiplJVRZ4fjWvQ07xeRHE+qLEJBU2d2BaBfUAU4/Si9uNM+AqqkxYqiillBlIXjwhbKLejUt0WyrhUDpZXerAgSuzb/zH0JItlZFxKyS6GmKAVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117488; c=relaxed/simple;
	bh=8d2+6BF5C58ZepSICvpGAutdEbffzx7mtnIs7+pWEAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AdGH4TTxVX2nqS4xT3tZrIghaddrdGHpiTv36iT8lzAn6K1uY/vFNZsP1V//s71GSnHmbl4bV+LCpmXsCsHJnSr81iv6ZsoiLqaHlUTWVENfWTOWlZbivxSYvUULfzMiUZ5CcBj51o+PeNd7wsGMCMzAcsd7BpNh5kbdTGvew2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0iLUPIcX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0iLUPIcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1785F1F000E9;
	Fri,  7 Aug 2026 15:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117486;
	bh=tIzysnc6r2Nq9aRsB4bBBCt4A7mNIUI+52SYVk04pVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0iLUPIcXiPHVyA+6Bx3VmqswzDjdcA3hSEzGGGZjKB7yziUMwOeOLAvx6pV0Zpoqi
	 LuF6RDk+V/WZLmsTF1+QLHR8orKkr2ODB+5MKeojt0pmIJUHa70TATDqFD2eq+9yuC
	 UPZl+86K7RD4Pyyi7V3lo8XsyozPNmKtF02JScS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Janne Grunau <j@jannau.net>,
	Sasha Finkelstein <k@chaosmail.tech>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 7.1 335/438] power: supply: macsmc: Support macOS 27 SMC firmware
Date: Fri,  7 Aug 2026 16:38:51 +0200
Message-ID: <20260807143435.115379040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Finkelstein <k@chaosmail.tech>

commit f7b253a6e217f71d754d70c525e9b4c1dcbd4414 upstream.

The SMC firmware included in macOS 27 changed the size of BCF0 key from
4 to 1 bytes. This key is used for indicating that battery state is
critically low. In addition, B0RM key has changed endianness.

Reviewed-by: Sven Peter <sven@kernel.org>
Reviewed-by: Joshua Peisach <jpeisach@ubuntu.com>
Reviewed-by: Janne Grunau <j@jannau.net>
Cc: stable@vger.kernel.org
Fixes: 0ebf821cf6c7 ("power: supply: Add macsmc-power driver for Apple Silicon")
Signed-off-by: Sasha Finkelstein <k@chaosmail.tech>
Link: https://patch.msgid.link/20260712-gate-power-v4-1-aa59c6583247@chaosmail.tech
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/macsmc-power.c |   52 +++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 7 deletions(-)

--- a/drivers/power/supply/macsmc-power.c
+++ b/drivers/power/supply/macsmc-power.c
@@ -86,6 +86,11 @@ struct macsmc_power {
 	bool has_ch0i; /* Force discharge (Older firmware) */
 	bool has_ch0c; /* Inhibit charge (Older firmware) */
 	bool has_chte; /* Inhibit charge (Modern firmware) */
+	/*
+	 * Battery critical key is 1 byte and charge key is little endian
+	 * (Modern firmware)
+	 */
+	bool fw_ge_27;
 
 	u8 num_cells;
 	int nominal_voltage_mv;
@@ -273,6 +278,20 @@ static int macsmc_battery_get_date(const
 	return 0;
 }
 
+static int macsmc_battery_read_bcf0(struct macsmc_power *power, u32 *val)
+{
+	u8 tval = 0;
+	int ret;
+
+	if (power->fw_ge_27) {
+		ret = apple_smc_read_u8(power->smc, SMC_KEY(BCF0), &tval);
+		*val = tval;
+		return ret;
+	}
+
+	return apple_smc_read_u32(power->smc, SMC_KEY(BCF0), val);
+}
+
 static int macsmc_battery_get_capacity_level(struct macsmc_power *power)
 {
 	bool flag;
@@ -280,7 +299,7 @@ static int macsmc_battery_get_capacity_l
 	int ret;
 
 	/* Check for emergency shutdown condition */
-	if (apple_smc_read_u32(power->smc, SMC_KEY(BCF0), &val) >= 0 && val)
+	if (macsmc_battery_read_bcf0(power, &val) >= 0 && val)
 		return POWER_SUPPLY_CAPACITY_LEVEL_CRITICAL;
 
 	/* Check AC status for whether we could boot in this state */
@@ -303,6 +322,12 @@ static int macsmc_battery_get_capacity_l
 		return POWER_SUPPLY_CAPACITY_LEVEL_NORMAL;
 }
 
+static s16 macsmc_swap_b0rm(struct macsmc_power *power, s16 b0rm)
+{
+	/* B0RM was Big Endian, likely pass through from TI gas gauge */
+	return power->fw_ge_27 ? b0rm : (s16)swab16(b0rm);
+}
+
 static int macsmc_battery_get_property(struct power_supply *psy,
 				       enum power_supply_property psp,
 				       union power_supply_propval *val)
@@ -397,8 +422,7 @@ static int macsmc_battery_get_property(s
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_NOW:
 		ret = apple_smc_read_u16(power->smc, SMC_KEY(B0RM), &vu16);
-		/* B0RM is Big Endian, likely pass through from TI gas gauge */
-		val->intval = (s16)swab16(vu16) * 1000;
+		val->intval = macsmc_swap_b0rm(power, vu16) * 1000;
 		break;
 	case POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN:
 		ret = apple_smc_read_u16(power->smc, SMC_KEY(B0DC), &vu16);
@@ -410,8 +434,7 @@ static int macsmc_battery_get_property(s
 		break;
 	case POWER_SUPPLY_PROP_ENERGY_NOW:
 		ret = apple_smc_read_u16(power->smc, SMC_KEY(B0RM), &vu16);
-		/* B0RM is Big Endian, likely pass through from TI gas gauge */
-		val->intval = (s16)swab16(vu16) * power->nominal_voltage_mv;
+		val->intval = macsmc_swap_b0rm(power, vu16) * power->nominal_voltage_mv;
 		break;
 	case POWER_SUPPLY_PROP_TEMP:
 		ret = apple_smc_read_u16(power->smc, SMC_KEY(B0AT), &vu16);
@@ -577,7 +600,7 @@ static void macsmc_power_critical_work(s
 	 * Check if SMC flagged the battery as empty.
 	 * We trigger a graceful shutdown to let the OS save data.
 	 */
-	if (apple_smc_read_u32(power->smc, SMC_KEY(BCF0), &bcf0) == 0 && bcf0 != 0) {
+	if (macsmc_battery_read_bcf0(power, &bcf0) == 0 && bcf0 != 0) {
 		power->orderly_shutdown_triggered = true;
 		dev_crit(power->dev, "Battery critical (empty flag set). Triggering orderly shutdown.\n");
 		orderly_poweroff(true);
@@ -616,6 +639,7 @@ static int macsmc_power_probe(struct pla
 	struct device *dev = &pdev->dev;
 	struct apple_smc *smc = dev_get_drvdata(pdev->dev.parent);
 	struct power_supply_config psy_cfg = {};
+	struct apple_smc_key_info info;
 	struct macsmc_power *power;
 	bool has_battery = false;
 	bool has_ac_adapter = false;
@@ -714,6 +738,20 @@ static int macsmc_power_probe(struct pla
 		if (apple_smc_key_exists(smc, SMC_KEY(CH0I)))
 			power->has_ch0i = true;
 
+		ret = apple_smc_get_key_info(power->smc, SMC_KEY(BCF0), &info);
+		if (ret) {
+			dev_err(&pdev->dev, "Failed to determine BCF0 key size\n");
+			return ret;
+		}
+		if (info.size == 1)
+			power->fw_ge_27 = true;
+		else if (info.size == 4)
+			power->fw_ge_27 = false;
+		else {
+			dev_err(&pdev->dev, "Unexpected BCF0 key size %d\n", info.size);
+			return -EIO;
+		}
+
 		/* Reset "Optimised Battery Charging" flags to default state */
 		if (power->has_chte)
 			apple_smc_write_u32(smc, SMC_KEY(CHTE), 0);
@@ -766,7 +804,7 @@ static int macsmc_power_probe(struct pla
 		power->nominal_voltage_mv = MACSMC_NOMINAL_CELL_VOLTAGE_MV * power->num_cells;
 
 		/* Enable critical shutdown notifications by reading status once */
-		apple_smc_read_u32(power->smc, SMC_KEY(BCF0), &val32);
+		macsmc_battery_read_bcf0(power, &val32);
 
 		psy_cfg.drv_data = power;
 		power->batt = devm_power_supply_register(dev, &power->batt_desc, &psy_cfg);


