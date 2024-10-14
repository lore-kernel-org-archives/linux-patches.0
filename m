Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4053D1AB525;
	Mon, 14 Oct 2024 14:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916687; cv=none; b=e/kZZwYh6LSJyCdh1Rmi0P4D+y8+Ico52iLTqH21VKw7YrAy9trYxCPYAzTkODePq1bAJ236RcXVCmBHEoSWxLe478jVwK2FgnhG2JN98ZunlWtghP3PETQ40LREK+Sv18ZAE0J61ev1cRdLpZgpOk1cWXM95cr7TWvFOJGJ+hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916687; c=relaxed/simple;
	bh=zPllwFRAKOae2rJtCHvW1B7JTWVTGnLrV/sJtjxvzWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5a/Pjy0rKA4cZlq48rrCtgaSYe6bWal1iMarUtlNBBZDew9UgtX2ME5vL2junDvz/AzSUfPRYUPas3Z99MrpzdDyop+e1Fmu+vek3Uih55lHpNgFNhSrkk4wIE0qoo15g7rhVZ0cXQfPUVrK9BMEVlDSGnw+halnDI+1chqvT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x72JZ0mR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x72JZ0mR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAC8C4CEC7;
	Mon, 14 Oct 2024 14:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916687;
	bh=zPllwFRAKOae2rJtCHvW1B7JTWVTGnLrV/sJtjxvzWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x72JZ0mR2MT+tOhWp9gjhkgLSxdndmcCCk1bGoFKw1SCv7yuvdngc25lUkXzG6VKN
	 RSfJaljWlTibgsDhI0MpX533oFEuSdbLR0leD1ai9hfOyVaYza+bbIgI2iaLfgxdMJ
	 burERFNMzfRUTQtZ7nF79br8qwAbW7b/S5uZ3bCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Elliot Berman <quic_eberman@quicinc.com>
Subject: [PATCH 6.6 006/213] phy: qualcomm: eusb2-repeater: Rework init to drop redundant zero-out loop
Date: Mon, 14 Oct 2024 16:18:32 +0200
Message-ID: <20241014141043.223253103@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 734550d60cdf634299f0eac7f7fe15763ed990bb ]

Instead of incrementing the base of the global reg fields, which renders
the second instance of the repeater broken due to wrong offsets, use
regmap with base and offset. As for zeroing out the rest of the tuning
regs, avoid looping though the table and just use the table as is,
as it is already zero initialized.

Fixes: 99a517a582fc ("phy: qualcomm: phy-qcom-eusb2-repeater: Zero out untouched tuning regs")
Tested-by: Elliot Berman <quic_eberman@quicinc.com> # sm8650-qrd
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20240201-phy-qcom-eusb2-repeater-fixes-v4-1-cf18c8cef6d7@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../phy/qualcomm/phy-qcom-eusb2-repeater.c    | 166 +++++++-----------
 1 file changed, 62 insertions(+), 104 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c b/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c
index a623f092b11f6..a43e20abb10d5 100644
--- a/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c
+++ b/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c
@@ -37,56 +37,28 @@
 #define EUSB2_TUNE_EUSB_EQU		0x5A
 #define EUSB2_TUNE_EUSB_HS_COMP_CUR	0x5B
 
-#define QCOM_EUSB2_REPEATER_INIT_CFG(r, v)	\
-	{					\
-		.reg = r,			\
-		.val = v,			\
-	}
-
-enum reg_fields {
-	F_TUNE_EUSB_HS_COMP_CUR,
-	F_TUNE_EUSB_EQU,
-	F_TUNE_EUSB_SLEW,
-	F_TUNE_USB2_HS_COMP_CUR,
-	F_TUNE_USB2_PREEM,
-	F_TUNE_USB2_EQU,
-	F_TUNE_USB2_SLEW,
-	F_TUNE_SQUELCH_U,
-	F_TUNE_HSDISC,
-	F_TUNE_RES_FSDIF,
-	F_TUNE_IUSB2,
-	F_TUNE_USB2_CROSSOVER,
-	F_NUM_TUNE_FIELDS,
-
-	F_FORCE_VAL_5 = F_NUM_TUNE_FIELDS,
-	F_FORCE_EN_5,
-
-	F_EN_CTL1,
-
-	F_RPTR_STATUS,
-	F_NUM_FIELDS,
-};
-
-static struct reg_field eusb2_repeater_tune_reg_fields[F_NUM_FIELDS] = {
-	[F_TUNE_EUSB_HS_COMP_CUR] = REG_FIELD(EUSB2_TUNE_EUSB_HS_COMP_CUR, 0, 1),
-	[F_TUNE_EUSB_EQU] = REG_FIELD(EUSB2_TUNE_EUSB_EQU, 0, 1),
-	[F_TUNE_EUSB_SLEW] = REG_FIELD(EUSB2_TUNE_EUSB_SLEW, 0, 1),
-	[F_TUNE_USB2_HS_COMP_CUR] = REG_FIELD(EUSB2_TUNE_USB2_HS_COMP_CUR, 0, 1),
-	[F_TUNE_USB2_PREEM] = REG_FIELD(EUSB2_TUNE_USB2_PREEM, 0, 2),
-	[F_TUNE_USB2_EQU] = REG_FIELD(EUSB2_TUNE_USB2_EQU, 0, 1),
-	[F_TUNE_USB2_SLEW] = REG_FIELD(EUSB2_TUNE_USB2_SLEW, 0, 1),
-	[F_TUNE_SQUELCH_U] = REG_FIELD(EUSB2_TUNE_SQUELCH_U, 0, 2),
-	[F_TUNE_HSDISC] = REG_FIELD(EUSB2_TUNE_HSDISC, 0, 2),
-	[F_TUNE_RES_FSDIF] = REG_FIELD(EUSB2_TUNE_RES_FSDIF, 0, 2),
-	[F_TUNE_IUSB2] = REG_FIELD(EUSB2_TUNE_IUSB2, 0, 3),
-	[F_TUNE_USB2_CROSSOVER] = REG_FIELD(EUSB2_TUNE_USB2_CROSSOVER, 0, 2),
-
-	[F_FORCE_VAL_5] = REG_FIELD(EUSB2_FORCE_VAL_5, 0, 7),
-	[F_FORCE_EN_5] = REG_FIELD(EUSB2_FORCE_EN_5, 0, 7),
-
-	[F_EN_CTL1] = REG_FIELD(EUSB2_EN_CTL1, 0, 7),
-
-	[F_RPTR_STATUS] = REG_FIELD(EUSB2_RPTR_STATUS, 0, 7),
+enum eusb2_reg_layout {
+	TUNE_EUSB_HS_COMP_CUR,
+	TUNE_EUSB_EQU,
+	TUNE_EUSB_SLEW,
+	TUNE_USB2_HS_COMP_CUR,
+	TUNE_USB2_PREEM,
+	TUNE_USB2_EQU,
+	TUNE_USB2_SLEW,
+	TUNE_SQUELCH_U,
+	TUNE_HSDISC,
+	TUNE_RES_FSDIF,
+	TUNE_IUSB2,
+	TUNE_USB2_CROSSOVER,
+	NUM_TUNE_FIELDS,
+
+	FORCE_VAL_5 = NUM_TUNE_FIELDS,
+	FORCE_EN_5,
+
+	EN_CTL1,
+
+	RPTR_STATUS,
+	LAYOUT_SIZE,
 };
 
 struct eusb2_repeater_cfg {
@@ -98,10 +70,11 @@ struct eusb2_repeater_cfg {
 
 struct eusb2_repeater {
 	struct device *dev;
-	struct regmap_field *regs[F_NUM_FIELDS];
+	struct regmap *regmap;
 	struct phy *phy;
 	struct regulator_bulk_data *vregs;
 	const struct eusb2_repeater_cfg *cfg;
+	u32 base;
 	enum phy_mode mode;
 };
 
@@ -109,10 +82,10 @@ static const char * const pm8550b_vreg_l[] = {
 	"vdd18", "vdd3",
 };
 
-static const u32 pm8550b_init_tbl[F_NUM_TUNE_FIELDS] = {
-	[F_TUNE_IUSB2] = 0x8,
-	[F_TUNE_SQUELCH_U] = 0x3,
-	[F_TUNE_USB2_PREEM] = 0x5,
+static const u32 pm8550b_init_tbl[NUM_TUNE_FIELDS] = {
+	[TUNE_IUSB2] = 0x8,
+	[TUNE_SQUELCH_U] = 0x3,
+	[TUNE_USB2_PREEM] = 0x5,
 };
 
 static const struct eusb2_repeater_cfg pm8550b_eusb2_cfg = {
@@ -140,47 +113,42 @@ static int eusb2_repeater_init_vregs(struct eusb2_repeater *rptr)
 
 static int eusb2_repeater_init(struct phy *phy)
 {
-	struct reg_field *regfields = eusb2_repeater_tune_reg_fields;
 	struct eusb2_repeater *rptr = phy_get_drvdata(phy);
 	struct device_node *np = rptr->dev->of_node;
-	u32 init_tbl[F_NUM_TUNE_FIELDS] = { 0 };
-	u8 override;
+	struct regmap *regmap = rptr->regmap;
+	const u32 *init_tbl = rptr->cfg->init_tbl;
+	u8 tune_usb2_preem = init_tbl[TUNE_USB2_PREEM];
+	u8 tune_hsdisc = init_tbl[TUNE_HSDISC];
+	u8 tune_iusb2 = init_tbl[TUNE_IUSB2];
+	u32 base = rptr->base;
 	u32 val;
 	int ret;
-	int i;
+
+	of_property_read_u8(np, "qcom,tune-usb2-amplitude", &tune_iusb2);
+	of_property_read_u8(np, "qcom,tune-usb2-disc-thres", &tune_hsdisc);
+	of_property_read_u8(np, "qcom,tune-usb2-preem", &tune_usb2_preem);
 
 	ret = regulator_bulk_enable(rptr->cfg->num_vregs, rptr->vregs);
 	if (ret)
 		return ret;
 
-	regmap_field_update_bits(rptr->regs[F_EN_CTL1], EUSB2_RPTR_EN, EUSB2_RPTR_EN);
+	regmap_write(regmap, base + EUSB2_EN_CTL1, EUSB2_RPTR_EN);
 
-	for (i = 0; i < F_NUM_TUNE_FIELDS; i++) {
-		if (init_tbl[i]) {
-			regmap_field_update_bits(rptr->regs[i], init_tbl[i], init_tbl[i]);
-		} else {
-			/* Write 0 if there's no value set */
-			u32 mask = GENMASK(regfields[i].msb, regfields[i].lsb);
-
-			regmap_field_update_bits(rptr->regs[i], mask, 0);
-		}
-	}
-	memcpy(init_tbl, rptr->cfg->init_tbl, sizeof(init_tbl));
+	regmap_write(regmap, base + EUSB2_TUNE_EUSB_HS_COMP_CUR, init_tbl[TUNE_EUSB_HS_COMP_CUR]);
+	regmap_write(regmap, base + EUSB2_TUNE_EUSB_EQU, init_tbl[TUNE_EUSB_EQU]);
+	regmap_write(regmap, base + EUSB2_TUNE_EUSB_SLEW, init_tbl[TUNE_EUSB_SLEW]);
+	regmap_write(regmap, base + EUSB2_TUNE_USB2_HS_COMP_CUR, init_tbl[TUNE_USB2_HS_COMP_CUR]);
+	regmap_write(regmap, base + EUSB2_TUNE_USB2_EQU, init_tbl[TUNE_USB2_EQU]);
+	regmap_write(regmap, base + EUSB2_TUNE_USB2_SLEW, init_tbl[TUNE_USB2_SLEW]);
+	regmap_write(regmap, base + EUSB2_TUNE_SQUELCH_U, init_tbl[TUNE_SQUELCH_U]);
+	regmap_write(regmap, base + EUSB2_TUNE_RES_FSDIF, init_tbl[TUNE_RES_FSDIF]);
+	regmap_write(regmap, base + EUSB2_TUNE_USB2_CROSSOVER, init_tbl[TUNE_USB2_CROSSOVER]);
 
-	if (!of_property_read_u8(np, "qcom,tune-usb2-amplitude", &override))
-		init_tbl[F_TUNE_IUSB2] = override;
+	regmap_write(regmap, base + EUSB2_TUNE_USB2_PREEM, tune_usb2_preem);
+	regmap_write(regmap, base + EUSB2_TUNE_HSDISC, tune_hsdisc);
+	regmap_write(regmap, base + EUSB2_TUNE_IUSB2, tune_iusb2);
 
-	if (!of_property_read_u8(np, "qcom,tune-usb2-disc-thres", &override))
-		init_tbl[F_TUNE_HSDISC] = override;
-
-	if (!of_property_read_u8(np, "qcom,tune-usb2-preem", &override))
-		init_tbl[F_TUNE_USB2_PREEM] = override;
-
-	for (i = 0; i < F_NUM_TUNE_FIELDS; i++)
-		regmap_field_update_bits(rptr->regs[i], init_tbl[i], init_tbl[i]);
-
-	ret = regmap_field_read_poll_timeout(rptr->regs[F_RPTR_STATUS],
-					     val, val & RPTR_OK, 10, 5);
+	ret = regmap_read_poll_timeout(regmap, base + EUSB2_RPTR_STATUS, val, val & RPTR_OK, 10, 5);
 	if (ret)
 		dev_err(rptr->dev, "initialization timed-out\n");
 
@@ -191,6 +159,8 @@ static int eusb2_repeater_set_mode(struct phy *phy,
 				   enum phy_mode mode, int submode)
 {
 	struct eusb2_repeater *rptr = phy_get_drvdata(phy);
+	struct regmap *regmap = rptr->regmap;
+	u32 base = rptr->base;
 
 	switch (mode) {
 	case PHY_MODE_USB_HOST:
@@ -199,10 +169,8 @@ static int eusb2_repeater_set_mode(struct phy *phy,
 		 * per eUSB 1.2 Spec. Below implement software workaround until
 		 * PHY and controller is fixing seen observation.
 		 */
-		regmap_field_update_bits(rptr->regs[F_FORCE_EN_5],
-					 F_CLK_19P2M_EN, F_CLK_19P2M_EN);
-		regmap_field_update_bits(rptr->regs[F_FORCE_VAL_5],
-					 V_CLK_19P2M_EN, V_CLK_19P2M_EN);
+		regmap_write(regmap, base + EUSB2_FORCE_EN_5, F_CLK_19P2M_EN);
+		regmap_write(regmap, base + EUSB2_FORCE_VAL_5, V_CLK_19P2M_EN);
 		break;
 	case PHY_MODE_USB_DEVICE:
 		/*
@@ -211,10 +179,8 @@ static int eusb2_repeater_set_mode(struct phy *phy,
 		 * repeater doesn't clear previous value due to shared
 		 * regulators (say host <-> device mode switch).
 		 */
-		regmap_field_update_bits(rptr->regs[F_FORCE_EN_5],
-					 F_CLK_19P2M_EN, 0);
-		regmap_field_update_bits(rptr->regs[F_FORCE_VAL_5],
-					 V_CLK_19P2M_EN, 0);
+		regmap_write(regmap, base + EUSB2_FORCE_EN_5, 0);
+		regmap_write(regmap, base + EUSB2_FORCE_VAL_5, 0);
 		break;
 	default:
 		return -EINVAL;
@@ -243,9 +209,8 @@ static int eusb2_repeater_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct phy_provider *phy_provider;
 	struct device_node *np = dev->of_node;
-	struct regmap *regmap;
-	int i, ret;
 	u32 res;
+	int ret;
 
 	rptr = devm_kzalloc(dev, sizeof(*rptr), GFP_KERNEL);
 	if (!rptr)
@@ -258,22 +223,15 @@ static int eusb2_repeater_probe(struct platform_device *pdev)
 	if (!rptr->cfg)
 		return -EINVAL;
 
-	regmap = dev_get_regmap(dev->parent, NULL);
-	if (!regmap)
+	rptr->regmap = dev_get_regmap(dev->parent, NULL);
+	if (!rptr->regmap)
 		return -ENODEV;
 
 	ret = of_property_read_u32(np, "reg", &res);
 	if (ret < 0)
 		return ret;
 
-	for (i = 0; i < F_NUM_FIELDS; i++)
-		eusb2_repeater_tune_reg_fields[i].reg += res;
-
-	ret = devm_regmap_field_bulk_alloc(dev, regmap, rptr->regs,
-					   eusb2_repeater_tune_reg_fields,
-					   F_NUM_FIELDS);
-	if (ret)
-		return ret;
+	rptr->base = res;
 
 	ret = eusb2_repeater_init_vregs(rptr);
 	if (ret < 0) {
-- 
2.43.0



