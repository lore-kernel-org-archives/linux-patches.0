Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F944071DA;
	Sun,  7 Jun 2026 10:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827438; cv=none; b=q0v8UyVQWW0kagKRewPFfJeneZ6lWqlC0cRF+nn5pYysL7Q+Z9i0tVKo2iLqDerrst1wyLxio49uCq3A5EDHggc5RJXnb757mYfU2jC6iVJ+GUZsFr2RHWFjtVO6qgITxqu2aBenmxtSq2sE5N01jd9Ldu5ZxTDrr1+tKwwNABw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827438; c=relaxed/simple;
	bh=PP3nO/QFg+l1DYB0rfABtXMAzi7BxjS0l15RJWPCPPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJqIRctpxNBEjwCeEI0x23s+fqF3TiocZQhF3rulS90hBomVlBGS8YmcjlXp5EKq5iBIL6zxN1vw2NBdTdVx0i06cwwgxlsxgv7JbG19JEVnKNOUEXBUSvPg0WRuqyDDPX/lMAyfTwTtGrUb1y98XZPHP1924LhZMF7v6c9N6l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLNxvp7s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLNxvp7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8755C1F00893;
	Sun,  7 Jun 2026 10:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827437;
	bh=n51MvPGTzNEqFjf+1JtsqpHFE8nAvqdpP2pYlE/ya+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PLNxvp7sLJet04V4AC6ES/254hqc2TE7lK4W/YR8Zdf6GQ7ZL0hULDFAFuNoWzncp
	 v/6hOyV2luXnhW2ZFg59iCiQ66u1OuWcd3XJM+s7TZfmNU/sVoGG0tS8q6+/uUImR1
	 sk56giEKUY9FsqWT6vHACftynExqwMQjZFYoyWCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 093/332] dpll: zl3073x: detect DPLL channel count from chip ID at runtime
Date: Sun,  7 Jun 2026 11:57:42 +0200
Message-ID: <20260607095731.571473787@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 4845f2fff730f0cdf8f7fe6401c8b871891cf1cb ]

Replace the five per-variant zl3073x_chip_info structures and their
exported symbol definitions with a single consolidated chip ID lookup
table. The chip variant is now detected at runtime by reading the chip
ID register from hardware and looking it up in the table, rather than
being selected at compile time via the bus driver match data.

Repurpose struct zl3073x_chip_info to hold a single chip ID, its
channel count, and a flags field. Introduce enum zl3073x_flags with
ZL3073X_FLAG_REF_PHASE_COMP_32 to replace the chip_id switch statement
in zl3073x_dev_is_ref_phase_comp_32bit(). Store a pointer to the
detected chip_info entry in struct zl3073x_dev for runtime access.

This simplifies the bus drivers by removing per-variant .data and
.driver_data references from the I2C/SPI match tables, and makes
adding support for new chip variants a single-line table addition.

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Link: https://patch.msgid.link/20260227105300.710272-2-ivecera@redhat.com
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: d733f519f644 ("dpll: zl3073x: use __dpll_device_change_ntf() and remove change_work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/zl3073x/core.c | 118 ++++++++++--------------------------
 drivers/dpll/zl3073x/core.h |  57 +++++++++--------
 drivers/dpll/zl3073x/i2c.c  |  37 ++++-------
 drivers/dpll/zl3073x/spi.c  |  37 ++++-------
 4 files changed, 82 insertions(+), 167 deletions(-)

diff --git a/drivers/dpll/zl3073x/core.c b/drivers/dpll/zl3073x/core.c
index 37f3c33570eef2..c8af3430104505 100644
--- a/drivers/dpll/zl3073x/core.c
+++ b/drivers/dpll/zl3073x/core.c
@@ -20,79 +20,30 @@
 #include "dpll.h"
 #include "regs.h"
 
-/* Chip IDs for zl30731 */
-static const u16 zl30731_ids[] = {
-	0x0E93,
-	0x1E93,
-	0x2E93,
+#define ZL_CHIP_INFO(_id, _nchannels, _flags)				\
+	{ .id = (_id), .num_channels = (_nchannels), .flags = (_flags) }
+
+static const struct zl3073x_chip_info zl3073x_chip_ids[] = {
+	ZL_CHIP_INFO(0x0E30, 2, ZL3073X_FLAG_REF_PHASE_COMP_32),
+	ZL_CHIP_INFO(0x0E93, 1, ZL3073X_FLAG_REF_PHASE_COMP_32),
+	ZL_CHIP_INFO(0x0E94, 2, ZL3073X_FLAG_REF_PHASE_COMP_32),
+	ZL_CHIP_INFO(0x0E95, 3, ZL3073X_FLAG_REF_PHASE_COMP_32),
+	ZL_CHIP_INFO(0x0E96, 4, ZL3073X_FLAG_REF_PHASE_COMP_32),
+	ZL_CHIP_INFO(0x0E97, 5, ZL3073X_FLAG_REF_PHASE_COMP_32),
+	ZL_CHIP_INFO(0x1E93, 1, 0),
+	ZL_CHIP_INFO(0x1E94, 2, 0),
+	ZL_CHIP_INFO(0x1E95, 3, 0),
+	ZL_CHIP_INFO(0x1E96, 4, 0),
+	ZL_CHIP_INFO(0x1E97, 5, 0),
+	ZL_CHIP_INFO(0x1F60, 2, ZL3073X_FLAG_REF_PHASE_COMP_32),
+	ZL_CHIP_INFO(0x2E93, 1, 0),
+	ZL_CHIP_INFO(0x2E94, 2, 0),
+	ZL_CHIP_INFO(0x2E95, 3, 0),
+	ZL_CHIP_INFO(0x2E96, 4, 0),
+	ZL_CHIP_INFO(0x2E97, 5, 0),
+	ZL_CHIP_INFO(0x3FC4, 2, 0),
 };
 
-const struct zl3073x_chip_info zl30731_chip_info = {
-	.ids = zl30731_ids,
-	.num_ids = ARRAY_SIZE(zl30731_ids),
-	.num_channels = 1,
-};
-EXPORT_SYMBOL_NS_GPL(zl30731_chip_info, "ZL3073X");
-
-/* Chip IDs for zl30732 */
-static const u16 zl30732_ids[] = {
-	0x0E30,
-	0x0E94,
-	0x1E94,
-	0x1F60,
-	0x2E94,
-	0x3FC4,
-};
-
-const struct zl3073x_chip_info zl30732_chip_info = {
-	.ids = zl30732_ids,
-	.num_ids = ARRAY_SIZE(zl30732_ids),
-	.num_channels = 2,
-};
-EXPORT_SYMBOL_NS_GPL(zl30732_chip_info, "ZL3073X");
-
-/* Chip IDs for zl30733 */
-static const u16 zl30733_ids[] = {
-	0x0E95,
-	0x1E95,
-	0x2E95,
-};
-
-const struct zl3073x_chip_info zl30733_chip_info = {
-	.ids = zl30733_ids,
-	.num_ids = ARRAY_SIZE(zl30733_ids),
-	.num_channels = 3,
-};
-EXPORT_SYMBOL_NS_GPL(zl30733_chip_info, "ZL3073X");
-
-/* Chip IDs for zl30734 */
-static const u16 zl30734_ids[] = {
-	0x0E96,
-	0x1E96,
-	0x2E96,
-};
-
-const struct zl3073x_chip_info zl30734_chip_info = {
-	.ids = zl30734_ids,
-	.num_ids = ARRAY_SIZE(zl30734_ids),
-	.num_channels = 4,
-};
-EXPORT_SYMBOL_NS_GPL(zl30734_chip_info, "ZL3073X");
-
-/* Chip IDs for zl30735 */
-static const u16 zl30735_ids[] = {
-	0x0E97,
-	0x1E97,
-	0x2E97,
-};
-
-const struct zl3073x_chip_info zl30735_chip_info = {
-	.ids = zl30735_ids,
-	.num_ids = ARRAY_SIZE(zl30735_ids),
-	.num_channels = 5,
-};
-EXPORT_SYMBOL_NS_GPL(zl30735_chip_info, "ZL3073X");
-
 #define ZL_RANGE_OFFSET		0x80
 #define ZL_PAGE_SIZE		0x80
 #define ZL_NUM_PAGES		256
@@ -942,7 +893,7 @@ static void zl3073x_dev_dpll_fini(void *ptr)
 }
 
 static int
-zl3073x_devm_dpll_init(struct zl3073x_dev *zldev, u8 num_dplls)
+zl3073x_devm_dpll_init(struct zl3073x_dev *zldev)
 {
 	struct kthread_worker *kworker;
 	struct zl3073x_dpll *zldpll;
@@ -952,7 +903,7 @@ zl3073x_devm_dpll_init(struct zl3073x_dev *zldev, u8 num_dplls)
 	INIT_LIST_HEAD(&zldev->dplls);
 
 	/* Allocate all DPLLs */
-	for (i = 0; i < num_dplls; i++) {
+	for (i = 0; i < zldev->info->num_channels; i++) {
 		zldpll = zl3073x_dpll_alloc(zldev, i);
 		if (IS_ERR(zldpll)) {
 			dev_err_probe(zldev->dev, PTR_ERR(zldpll),
@@ -992,14 +943,12 @@ zl3073x_devm_dpll_init(struct zl3073x_dev *zldev, u8 num_dplls)
 /**
  * zl3073x_dev_probe - initialize zl3073x device
  * @zldev: pointer to zl3073x device
- * @chip_info: chip info based on compatible
  *
  * Common initialization of zl3073x device structure.
  *
  * Returns: 0 on success, <0 on error
  */
-int zl3073x_dev_probe(struct zl3073x_dev *zldev,
-		      const struct zl3073x_chip_info *chip_info)
+int zl3073x_dev_probe(struct zl3073x_dev *zldev)
 {
 	u16 id, revision, fw_ver;
 	unsigned int i;
@@ -1011,18 +960,17 @@ int zl3073x_dev_probe(struct zl3073x_dev *zldev,
 	if (rc)
 		return rc;
 
-	/* Check it matches */
-	for (i = 0; i < chip_info->num_ids; i++) {
-		if (id == chip_info->ids[i])
+	/* Detect chip variant */
+	for (i = 0; i < ARRAY_SIZE(zl3073x_chip_ids); i++) {
+		if (zl3073x_chip_ids[i].id == id)
 			break;
 	}
 
-	if (i == chip_info->num_ids) {
+	if (i == ARRAY_SIZE(zl3073x_chip_ids))
 		return dev_err_probe(zldev->dev, -ENODEV,
-				     "Unknown or non-match chip ID: 0x%0x\n",
-				     id);
-	}
-	zldev->chip_id = id;
+				     "Unknown chip ID: 0x%04x\n", id);
+
+	zldev->info = &zl3073x_chip_ids[i];
 
 	/* Read revision, firmware version and custom config version */
 	rc = zl3073x_read_u16(zldev, ZL_REG_REVISION, &revision);
@@ -1061,7 +1009,7 @@ int zl3073x_dev_probe(struct zl3073x_dev *zldev,
 				     "Failed to initialize mutex\n");
 
 	/* Register DPLL channels */
-	rc = zl3073x_devm_dpll_init(zldev, chip_info->num_channels);
+	rc = zl3073x_devm_dpll_init(zldev);
 	if (rc)
 		return rc;
 
diff --git a/drivers/dpll/zl3073x/core.h b/drivers/dpll/zl3073x/core.h
index fd2af3c62a7d5c..fde5c8371fbd28 100644
--- a/drivers/dpll/zl3073x/core.h
+++ b/drivers/dpll/zl3073x/core.h
@@ -30,12 +30,32 @@ struct zl3073x_dpll;
 #define ZL3073X_NUM_PINS	(ZL3073X_NUM_INPUT_PINS + \
 				 ZL3073X_NUM_OUTPUT_PINS)
 
+enum zl3073x_flags {
+	ZL3073X_FLAG_REF_PHASE_COMP_32_BIT,
+	ZL3073X_FLAGS_NBITS /* must be last */
+};
+
+#define __ZL3073X_FLAG(name)	BIT(ZL3073X_FLAG_ ## name ## _BIT)
+#define ZL3073X_FLAG_REF_PHASE_COMP_32	__ZL3073X_FLAG(REF_PHASE_COMP_32)
+
+/**
+ * struct zl3073x_chip_info - chip variant identification
+ * @id: chip ID
+ * @num_channels: number of DPLL channels supported by this variant
+ * @flags: chip variant flags
+ */
+struct zl3073x_chip_info {
+	u16		id;
+	u8		num_channels;
+	unsigned long	flags;
+};
+
 /**
  * struct zl3073x_dev - zl3073x device
  * @dev: pointer to device
  * @regmap: regmap to access device registers
+ * @info: detected chip info
  * @multiop_lock: to serialize multiple register operations
- * @chip_id: chip ID read from hardware
  * @ref: array of input references' invariants
  * @out: array of outs' invariants
  * @synth: array of synths' invariants
@@ -46,10 +66,10 @@ struct zl3073x_dpll;
  * @phase_avg_factor: phase offset measurement averaging factor
  */
 struct zl3073x_dev {
-	struct device		*dev;
-	struct regmap		*regmap;
-	struct mutex		multiop_lock;
-	u16			chip_id;
+	struct device			*dev;
+	struct regmap			*regmap;
+	const struct zl3073x_chip_info	*info;
+	struct mutex			multiop_lock;
 
 	/* Invariants */
 	struct zl3073x_ref	ref[ZL3073X_NUM_REFS];
@@ -68,22 +88,10 @@ struct zl3073x_dev {
 	u8			phase_avg_factor;
 };
 
-struct zl3073x_chip_info {
-	const u16	*ids;
-	size_t		num_ids;
-	int		num_channels;
-};
-
-extern const struct zl3073x_chip_info zl30731_chip_info;
-extern const struct zl3073x_chip_info zl30732_chip_info;
-extern const struct zl3073x_chip_info zl30733_chip_info;
-extern const struct zl3073x_chip_info zl30734_chip_info;
-extern const struct zl3073x_chip_info zl30735_chip_info;
 extern const struct regmap_config zl3073x_regmap_config;
 
 struct zl3073x_dev *zl3073x_devm_alloc(struct device *dev);
-int zl3073x_dev_probe(struct zl3073x_dev *zldev,
-		      const struct zl3073x_chip_info *chip_info);
+int zl3073x_dev_probe(struct zl3073x_dev *zldev);
 
 int zl3073x_dev_start(struct zl3073x_dev *zldev, bool full);
 void zl3073x_dev_stop(struct zl3073x_dev *zldev);
@@ -158,18 +166,7 @@ int zl3073x_ref_phase_offsets_update(struct zl3073x_dev *zldev, int channel);
 static inline bool
 zl3073x_dev_is_ref_phase_comp_32bit(struct zl3073x_dev *zldev)
 {
-	switch (zldev->chip_id) {
-	case 0x0E30:
-	case 0x0E93:
-	case 0x0E94:
-	case 0x0E95:
-	case 0x0E96:
-	case 0x0E97:
-	case 0x1F60:
-		return true;
-	default:
-		return false;
-	}
+	return zldev->info->flags & ZL3073X_FLAG_REF_PHASE_COMP_32;
 }
 
 static inline bool
diff --git a/drivers/dpll/zl3073x/i2c.c b/drivers/dpll/zl3073x/i2c.c
index 7bbfdd4ed8671d..979df85826abcc 100644
--- a/drivers/dpll/zl3073x/i2c.c
+++ b/drivers/dpll/zl3073x/i2c.c
@@ -22,40 +22,25 @@ static int zl3073x_i2c_probe(struct i2c_client *client)
 		return dev_err_probe(dev, PTR_ERR(zldev->regmap),
 				     "Failed to initialize regmap\n");
 
-	return zl3073x_dev_probe(zldev, i2c_get_match_data(client));
+	return zl3073x_dev_probe(zldev);
 }
 
 static const struct i2c_device_id zl3073x_i2c_id[] = {
-	{
-		.name = "zl30731",
-		.driver_data = (kernel_ulong_t)&zl30731_chip_info,
-	},
-	{
-		.name = "zl30732",
-		.driver_data = (kernel_ulong_t)&zl30732_chip_info,
-	},
-	{
-		.name = "zl30733",
-		.driver_data = (kernel_ulong_t)&zl30733_chip_info,
-	},
-	{
-		.name = "zl30734",
-		.driver_data = (kernel_ulong_t)&zl30734_chip_info,
-	},
-	{
-		.name = "zl30735",
-		.driver_data = (kernel_ulong_t)&zl30735_chip_info,
-	},
+	{ "zl30731" },
+	{ "zl30732" },
+	{ "zl30733" },
+	{ "zl30734" },
+	{ "zl30735" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(i2c, zl3073x_i2c_id);
 
 static const struct of_device_id zl3073x_i2c_of_match[] = {
-	{ .compatible = "microchip,zl30731", .data = &zl30731_chip_info },
-	{ .compatible = "microchip,zl30732", .data = &zl30732_chip_info },
-	{ .compatible = "microchip,zl30733", .data = &zl30733_chip_info },
-	{ .compatible = "microchip,zl30734", .data = &zl30734_chip_info },
-	{ .compatible = "microchip,zl30735", .data = &zl30735_chip_info },
+	{ .compatible = "microchip,zl30731" },
+	{ .compatible = "microchip,zl30732" },
+	{ .compatible = "microchip,zl30733" },
+	{ .compatible = "microchip,zl30734" },
+	{ .compatible = "microchip,zl30735" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, zl3073x_i2c_of_match);
diff --git a/drivers/dpll/zl3073x/spi.c b/drivers/dpll/zl3073x/spi.c
index af901b4d6dda06..f024f42b78d05f 100644
--- a/drivers/dpll/zl3073x/spi.c
+++ b/drivers/dpll/zl3073x/spi.c
@@ -22,40 +22,25 @@ static int zl3073x_spi_probe(struct spi_device *spi)
 		return dev_err_probe(dev, PTR_ERR(zldev->regmap),
 				     "Failed to initialize regmap\n");
 
-	return zl3073x_dev_probe(zldev, spi_get_device_match_data(spi));
+	return zl3073x_dev_probe(zldev);
 }
 
 static const struct spi_device_id zl3073x_spi_id[] = {
-	{
-		.name = "zl30731",
-		.driver_data = (kernel_ulong_t)&zl30731_chip_info
-	},
-	{
-		.name = "zl30732",
-		.driver_data = (kernel_ulong_t)&zl30732_chip_info,
-	},
-	{
-		.name = "zl30733",
-		.driver_data = (kernel_ulong_t)&zl30733_chip_info,
-	},
-	{
-		.name = "zl30734",
-		.driver_data = (kernel_ulong_t)&zl30734_chip_info,
-	},
-	{
-		.name = "zl30735",
-		.driver_data = (kernel_ulong_t)&zl30735_chip_info,
-	},
+	{ "zl30731" },
+	{ "zl30732" },
+	{ "zl30733" },
+	{ "zl30734" },
+	{ "zl30735" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(spi, zl3073x_spi_id);
 
 static const struct of_device_id zl3073x_spi_of_match[] = {
-	{ .compatible = "microchip,zl30731", .data = &zl30731_chip_info },
-	{ .compatible = "microchip,zl30732", .data = &zl30732_chip_info },
-	{ .compatible = "microchip,zl30733", .data = &zl30733_chip_info },
-	{ .compatible = "microchip,zl30734", .data = &zl30734_chip_info },
-	{ .compatible = "microchip,zl30735", .data = &zl30735_chip_info },
+	{ .compatible = "microchip,zl30731" },
+	{ .compatible = "microchip,zl30732" },
+	{ .compatible = "microchip,zl30733" },
+	{ .compatible = "microchip,zl30734" },
+	{ .compatible = "microchip,zl30735" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, zl3073x_spi_of_match);
-- 
2.53.0



