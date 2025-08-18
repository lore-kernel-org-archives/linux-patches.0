Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4C928C014;
	Mon, 18 Aug 2025 13:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523347; cv=none; b=pLYZKLjrXMkK9vNlJcGZyTzj6gZkUYcxIoLsV0Myt3Go0hZSS7yYHCW+3yQD0txnhpLkAaLBN43KC/8WfzdzjLlus+YZdh7H56vcLdNLZOuXZbMQY+cagh01J4vz9q+YtRtPLFmtEj1a18maiw+ghcQp057aVRJqpqewFHTKAqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523347; c=relaxed/simple;
	bh=PO4pzC17v64Rh0zgmXrTkNVMJTl3Veu3ZQo890K25cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTlVi9JtiSnpxDIs4BE+o+9sk/nklsjJuIDvs/nZB4aTOmJIHv70FchoJXHe/Ddt7LvRlq9m8+w1ficxMvVIgb7wNlXG/qhwc6OBF7MsYDQ4wrmEv9Yi1L5ePY7msrnz8dwi0xVYa/2RfHqiRp6NEgVqXOmKgrpU6fJixGXQILU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjoOQW93; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjoOQW93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E45BC4CEEB;
	Mon, 18 Aug 2025 13:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523347;
	bh=PO4pzC17v64Rh0zgmXrTkNVMJTl3Veu3ZQo890K25cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjoOQW93B4Bo5ut6jMql2njhoKwBxcirFkYRbmzOUcjvRfM7pwnX+X3Jj9wekUB9C
	 +c7O/9jQxUrhsRC8cUTLQgbFXZ9JYXvkh+705WV/mezSU39hMJEb8NNwOs0NJ6fiWr
	 XgbxxBkuVHVvMdbGVCl/BCgOsz/aD0aGzZj1rRMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 143/515] mfd: tps6594: Add TI TPS652G1 support
Date: Mon, 18 Aug 2025 14:42:09 +0200
Message-ID: <20250818124503.895473535@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 626bb0a45584d544d84eab909795ccb355062bcc ]

The TPS652G1 is a stripped down version of the TPS65224. From a software
point of view, it lacks any voltage monitoring, the watchdog, the ESM
and the ADC.

Signed-off-by: Michael Walle <mwalle@kernel.org>
Link: https://lore.kernel.org/r/20250613114518.1772109-2-mwalle@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps6594-core.c  | 88 ++++++++++++++++++++++++++++++++++---
 drivers/mfd/tps6594-i2c.c   | 10 ++++-
 drivers/mfd/tps6594-spi.c   | 10 ++++-
 include/linux/mfd/tps6594.h |  1 +
 4 files changed, 99 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/tps6594-core.c b/drivers/mfd/tps6594-core.c
index a7223e873cd1..c16c37e36617 100644
--- a/drivers/mfd/tps6594-core.c
+++ b/drivers/mfd/tps6594-core.c
@@ -1,6 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Core functions for TI TPS65224/TPS6594/TPS6593/LP8764 PMICs
+ * Core functions for following TI PMICs:
+ *  - LP8764
+ *  - TPS65224
+ *  - TPS652G1
+ *  - TPS6593
+ *  - TPS6594
  *
  * Copyright (C) 2023 BayLibre Incorporated - https://www.baylibre.com/
  */
@@ -414,6 +419,61 @@ static const unsigned int tps65224_irq_reg[] = {
 	TPS6594_REG_INT_FSM_ERR,
 };
 
+/* TPS652G1 Resources */
+
+static const struct mfd_cell tps652g1_common_cells[] = {
+	MFD_CELL_RES("tps6594-pfsm", tps65224_pfsm_resources),
+	MFD_CELL_RES("tps6594-pinctrl", tps65224_pinctrl_resources),
+	MFD_CELL_NAME("tps6594-regulator"),
+};
+
+static const struct regmap_irq tps652g1_irqs[] = {
+	/* INT_GPIO register */
+	REGMAP_IRQ_REG(TPS65224_IRQ_GPIO1, 2, TPS65224_BIT_GPIO1_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_GPIO2, 2, TPS65224_BIT_GPIO2_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_GPIO3, 2, TPS65224_BIT_GPIO3_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_GPIO4, 2, TPS65224_BIT_GPIO4_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_GPIO5, 2, TPS65224_BIT_GPIO5_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_GPIO6, 2, TPS65224_BIT_GPIO6_INT),
+
+	/* INT_STARTUP register */
+	REGMAP_IRQ_REG(TPS65224_IRQ_VSENSE, 3, TPS65224_BIT_VSENSE_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_ENABLE, 3, TPS6594_BIT_ENABLE_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_PB_SHORT, 3, TPS65224_BIT_PB_SHORT_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_FSD, 3, TPS6594_BIT_FSD_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_SOFT_REBOOT, 3, TPS6594_BIT_SOFT_REBOOT_INT),
+
+	/* INT_MISC register */
+	REGMAP_IRQ_REG(TPS65224_IRQ_BIST_PASS, 4, TPS6594_BIT_BIST_PASS_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_EXT_CLK, 4, TPS6594_BIT_EXT_CLK_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_REG_UNLOCK, 4, TPS65224_BIT_REG_UNLOCK_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_TWARN, 4, TPS6594_BIT_TWARN_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_PB_LONG, 4, TPS65224_BIT_PB_LONG_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_PB_FALL, 4, TPS65224_BIT_PB_FALL_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_PB_RISE, 4, TPS65224_BIT_PB_RISE_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_ADC_CONV_READY, 4, TPS65224_BIT_ADC_CONV_READY_INT),
+
+	/* INT_MODERATE_ERR register */
+	REGMAP_IRQ_REG(TPS65224_IRQ_TSD_ORD, 5, TPS6594_BIT_TSD_ORD_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_BIST_FAIL, 5, TPS6594_BIT_BIST_FAIL_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_REG_CRC_ERR, 5, TPS6594_BIT_REG_CRC_ERR_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_RECOV_CNT, 5, TPS6594_BIT_RECOV_CNT_INT),
+
+	/* INT_SEVERE_ERR register */
+	REGMAP_IRQ_REG(TPS65224_IRQ_TSD_IMM, 6, TPS6594_BIT_TSD_IMM_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_VCCA_OVP, 6, TPS6594_BIT_VCCA_OVP_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_PFSM_ERR, 6, TPS6594_BIT_PFSM_ERR_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_BG_XMON, 6, TPS65224_BIT_BG_XMON_INT),
+
+	/* INT_FSM_ERR register */
+	REGMAP_IRQ_REG(TPS65224_IRQ_IMM_SHUTDOWN, 7, TPS6594_BIT_IMM_SHUTDOWN_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_ORD_SHUTDOWN, 7, TPS6594_BIT_ORD_SHUTDOWN_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_MCU_PWR_ERR, 7, TPS6594_BIT_MCU_PWR_ERR_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_SOC_PWR_ERR, 7, TPS6594_BIT_SOC_PWR_ERR_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_COMM_ERR, 7, TPS6594_BIT_COMM_ERR_INT),
+	REGMAP_IRQ_REG(TPS65224_IRQ_I2C2_ERR, 7, TPS65224_BIT_I2C2_ERR_INT),
+};
+
 static inline unsigned int tps6594_get_irq_reg(struct regmap_irq_chip_data *data,
 					       unsigned int base, int index)
 {
@@ -443,7 +503,7 @@ static int tps6594_handle_post_irq(void *irq_drv_data)
 	 * a new interrupt.
 	 */
 	if (tps->use_crc) {
-		if (tps->chip_id == TPS65224) {
+		if (tps->chip_id == TPS65224 || tps->chip_id == TPS652G1) {
 			regmap_reg = TPS6594_REG_INT_FSM_ERR;
 			mask_val = TPS6594_BIT_COMM_ERR_INT;
 		} else {
@@ -481,6 +541,18 @@ static struct regmap_irq_chip tps65224_irq_chip = {
 	.handle_post_irq = tps6594_handle_post_irq,
 };
 
+static struct regmap_irq_chip tps652g1_irq_chip = {
+	.ack_base = TPS6594_REG_INT_BUCK,
+	.ack_invert = 1,
+	.clear_ack = 1,
+	.init_ack_masked = 1,
+	.num_regs = ARRAY_SIZE(tps65224_irq_reg),
+	.irqs = tps652g1_irqs,
+	.num_irqs = ARRAY_SIZE(tps652g1_irqs),
+	.get_irq_reg = tps65224_get_irq_reg,
+	.handle_post_irq = tps6594_handle_post_irq,
+};
+
 static const struct regmap_range tps6594_volatile_ranges[] = {
 	regmap_reg_range(TPS6594_REG_INT_TOP, TPS6594_REG_STAT_READBACK_ERR),
 	regmap_reg_range(TPS6594_REG_RTC_STATUS, TPS6594_REG_RTC_STATUS),
@@ -507,7 +579,7 @@ static int tps6594_check_crc_mode(struct tps6594 *tps, bool primary_pmic)
 	int ret;
 	unsigned int regmap_reg, mask_val;
 
-	if (tps->chip_id == TPS65224) {
+	if (tps->chip_id == TPS65224 || tps->chip_id == TPS652G1) {
 		regmap_reg = TPS6594_REG_CONFIG_2;
 		mask_val = TPS65224_BIT_I2C1_SPI_CRC_EN;
 	} else {
@@ -537,7 +609,7 @@ static int tps6594_set_crc_feature(struct tps6594 *tps)
 	int ret;
 	unsigned int regmap_reg, mask_val;
 
-	if (tps->chip_id == TPS65224) {
+	if (tps->chip_id == TPS65224 || tps->chip_id == TPS652G1) {
 		regmap_reg = TPS6594_REG_CONFIG_2;
 		mask_val = TPS65224_BIT_I2C1_SPI_CRC_EN;
 	} else {
@@ -628,6 +700,10 @@ int tps6594_device_init(struct tps6594 *tps, bool enable_crc)
 		irq_chip = &tps65224_irq_chip;
 		n_cells = ARRAY_SIZE(tps65224_common_cells);
 		cells = tps65224_common_cells;
+	} else if (tps->chip_id == TPS652G1) {
+		irq_chip = &tps652g1_irq_chip;
+		n_cells = ARRAY_SIZE(tps652g1_common_cells);
+		cells = tps652g1_common_cells;
 	} else {
 		irq_chip = &tps6594_irq_chip;
 		n_cells = ARRAY_SIZE(tps6594_common_cells);
@@ -651,8 +727,8 @@ int tps6594_device_init(struct tps6594 *tps, bool enable_crc)
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to add common child devices\n");
 
-	/* No RTC for LP8764 and TPS65224 */
-	if (tps->chip_id != LP8764 && tps->chip_id != TPS65224) {
+	/* No RTC for LP8764, TPS65224 and TPS652G1 */
+	if (tps->chip_id != LP8764 && tps->chip_id != TPS65224 && tps->chip_id != TPS652G1) {
 		ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, tps6594_rtc_cells,
 					   ARRAY_SIZE(tps6594_rtc_cells), NULL, 0,
 					   regmap_irq_get_domain(tps->irq_data));
diff --git a/drivers/mfd/tps6594-i2c.c b/drivers/mfd/tps6594-i2c.c
index 4ab91c34d9fb..7ff7516286fd 100644
--- a/drivers/mfd/tps6594-i2c.c
+++ b/drivers/mfd/tps6594-i2c.c
@@ -1,6 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * I2C access driver for TI TPS65224/TPS6594/TPS6593/LP8764 PMICs
+ * I2C access driver for the following TI PMICs:
+ *  - LP8764
+ *  - TPS65224
+ *  - TPS652G1
+ *  - TPS6593
+ *  - TPS6594
  *
  * Copyright (C) 2023 BayLibre Incorporated - https://www.baylibre.com/
  */
@@ -197,6 +202,7 @@ static const struct of_device_id tps6594_i2c_of_match_table[] = {
 	{ .compatible = "ti,tps6593-q1", .data = (void *)TPS6593, },
 	{ .compatible = "ti,lp8764-q1",  .data = (void *)LP8764,  },
 	{ .compatible = "ti,tps65224-q1", .data = (void *)TPS65224, },
+	{ .compatible = "ti,tps652g1", .data = (void *)TPS652G1, },
 	{}
 };
 MODULE_DEVICE_TABLE(of, tps6594_i2c_of_match_table);
@@ -222,7 +228,7 @@ static int tps6594_i2c_probe(struct i2c_client *client)
 		return dev_err_probe(dev, -EINVAL, "Failed to find matching chip ID\n");
 	tps->chip_id = (unsigned long)match->data;
 
-	if (tps->chip_id == TPS65224)
+	if (tps->chip_id == TPS65224 || tps->chip_id == TPS652G1)
 		tps6594_i2c_regmap_config.volatile_table = &tps65224_volatile_table;
 
 	tps->regmap = devm_regmap_init(dev, NULL, client, &tps6594_i2c_regmap_config);
diff --git a/drivers/mfd/tps6594-spi.c b/drivers/mfd/tps6594-spi.c
index 6ebccb79f0cc..944b7313a1d9 100644
--- a/drivers/mfd/tps6594-spi.c
+++ b/drivers/mfd/tps6594-spi.c
@@ -1,6 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * SPI access driver for TI TPS65224/TPS6594/TPS6593/LP8764 PMICs
+ * SPI access driver for the following TI PMICs:
+ *  - LP8764
+ *  - TPS65224
+ *  - TPS652G1
+ *  - TPS6593
+ *  - TPS6594
  *
  * Copyright (C) 2023 BayLibre Incorporated - https://www.baylibre.com/
  */
@@ -82,6 +87,7 @@ static const struct of_device_id tps6594_spi_of_match_table[] = {
 	{ .compatible = "ti,tps6593-q1", .data = (void *)TPS6593, },
 	{ .compatible = "ti,lp8764-q1",  .data = (void *)LP8764,  },
 	{ .compatible = "ti,tps65224-q1", .data = (void *)TPS65224, },
+	{ .compatible = "ti,tps652g1", .data = (void *)TPS652G1, },
 	{}
 };
 MODULE_DEVICE_TABLE(of, tps6594_spi_of_match_table);
@@ -107,7 +113,7 @@ static int tps6594_spi_probe(struct spi_device *spi)
 		return dev_err_probe(dev, -EINVAL, "Failed to find matching chip ID\n");
 	tps->chip_id = (unsigned long)match->data;
 
-	if (tps->chip_id == TPS65224)
+	if (tps->chip_id == TPS65224 || tps->chip_id == TPS652G1)
 		tps6594_spi_regmap_config.volatile_table = &tps65224_volatile_table;
 
 	tps->regmap = devm_regmap_init(dev, NULL, spi, &tps6594_spi_regmap_config);
diff --git a/include/linux/mfd/tps6594.h b/include/linux/mfd/tps6594.h
index 16543fd4d83e..021db8875963 100644
--- a/include/linux/mfd/tps6594.h
+++ b/include/linux/mfd/tps6594.h
@@ -19,6 +19,7 @@ enum pmic_id {
 	TPS6593,
 	LP8764,
 	TPS65224,
+	TPS652G1,
 };
 
 /* Macro to get page index from register address */
-- 
2.39.5



