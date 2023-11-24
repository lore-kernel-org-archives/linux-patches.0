Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CE9341AE;
	Fri, 24 Nov 2023 18:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xmT16MG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902FBC433C8;
	Fri, 24 Nov 2023 18:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850666;
	bh=DAA8mNk+w3fpjNXmzqTyQTaDxB7DwzSR+x639HQzrXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xmT16MG1BH0ggrVl5K0snQKNxv6r77t8XCNoZNUysRbN+if98NKY9cVsDJzuXk4Y8
	 KdTLntJuSEM2w3zPdxmHw8okFHynZFMlL9AsqPBZwbnB4RwjZSXYbAgY9fIcf6sXtn
	 Zn5jjredEZPkynZ7klIXWZro/61x+VYAWVbngksg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 116/491] phy: qualcomm: phy-qcom-eusb2-repeater: Use regmap_fields
Date: Fri, 24 Nov 2023 17:45:52 +0000
Message-ID: <20231124172028.014533809@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 4ba2e52718c0ce4ece6a269bec84319c355c030f ]

Switch to regmap_fields, so that the values written into registers are
sanitized by their explicit sizes and the different registers are
structured in an iterable object to make external changes to the init
sequence simpler.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230830-topic-eusb2_override-v2-2-7d8c893d93f6@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../phy/qualcomm/phy-qcom-eusb2-repeater.c    | 91 +++++++++++++------
 1 file changed, 61 insertions(+), 30 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c b/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c
index 90f8543ba265b..b20b805414a2a 100644
--- a/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c
+++ b/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c
@@ -29,14 +29,42 @@
 #define EUSB2_TUNE_SQUELCH_U		0x54
 #define EUSB2_TUNE_USB2_PREEM		0x57
 
-#define QCOM_EUSB2_REPEATER_INIT_CFG(o, v)	\
+#define QCOM_EUSB2_REPEATER_INIT_CFG(r, v)	\
 	{					\
-		.offset = o,			\
+		.reg = r,			\
 		.val = v,			\
 	}
 
+enum reg_fields {
+	F_TUNE_USB2_PREEM,
+	F_TUNE_SQUELCH_U,
+	F_TUNE_IUSB2,
+	F_NUM_TUNE_FIELDS,
+
+	F_FORCE_VAL_5 = F_NUM_TUNE_FIELDS,
+	F_FORCE_EN_5,
+
+	F_EN_CTL1,
+
+	F_RPTR_STATUS,
+	F_NUM_FIELDS,
+};
+
+static struct reg_field eusb2_repeater_tune_reg_fields[F_NUM_FIELDS] = {
+	[F_TUNE_USB2_PREEM] = REG_FIELD(EUSB2_TUNE_USB2_PREEM, 0, 2),
+	[F_TUNE_SQUELCH_U] = REG_FIELD(EUSB2_TUNE_SQUELCH_U, 0, 2),
+	[F_TUNE_IUSB2] = REG_FIELD(EUSB2_TUNE_IUSB2, 0, 3),
+
+	[F_FORCE_VAL_5] = REG_FIELD(EUSB2_FORCE_VAL_5, 0, 7),
+	[F_FORCE_EN_5] = REG_FIELD(EUSB2_FORCE_EN_5, 0, 7),
+
+	[F_EN_CTL1] = REG_FIELD(EUSB2_EN_CTL1, 0, 7),
+
+	[F_RPTR_STATUS] = REG_FIELD(EUSB2_RPTR_STATUS, 0, 7),
+};
+
 struct eusb2_repeater_init_tbl {
-	unsigned int offset;
+	unsigned int reg;
 	unsigned int val;
 };
 
@@ -49,11 +77,10 @@ struct eusb2_repeater_cfg {
 
 struct eusb2_repeater {
 	struct device *dev;
-	struct regmap *regmap;
+	struct regmap_field *regs[F_NUM_FIELDS];
 	struct phy *phy;
 	struct regulator_bulk_data *vregs;
 	const struct eusb2_repeater_cfg *cfg;
-	u16 base;
 	enum phy_mode mode;
 };
 
@@ -62,9 +89,9 @@ static const char * const pm8550b_vreg_l[] = {
 };
 
 static const struct eusb2_repeater_init_tbl pm8550b_init_tbl[] = {
-	QCOM_EUSB2_REPEATER_INIT_CFG(EUSB2_TUNE_IUSB2, 0x8),
-	QCOM_EUSB2_REPEATER_INIT_CFG(EUSB2_TUNE_SQUELCH_U, 0x3),
-	QCOM_EUSB2_REPEATER_INIT_CFG(EUSB2_TUNE_USB2_PREEM, 0x5),
+	QCOM_EUSB2_REPEATER_INIT_CFG(F_TUNE_IUSB2, 0x8),
+	QCOM_EUSB2_REPEATER_INIT_CFG(F_TUNE_SQUELCH_U, 0x3),
+	QCOM_EUSB2_REPEATER_INIT_CFG(F_TUNE_USB2_PREEM, 0x5),
 };
 
 static const struct eusb2_repeater_cfg pm8550b_eusb2_cfg = {
@@ -94,7 +121,6 @@ static int eusb2_repeater_init(struct phy *phy)
 {
 	struct eusb2_repeater *rptr = phy_get_drvdata(phy);
 	const struct eusb2_repeater_init_tbl *init_tbl = rptr->cfg->init_tbl;
-	int num = rptr->cfg->init_tbl_num;
 	u32 val;
 	int ret;
 	int i;
@@ -103,17 +129,14 @@ static int eusb2_repeater_init(struct phy *phy)
 	if (ret)
 		return ret;
 
-	regmap_update_bits(rptr->regmap, rptr->base + EUSB2_EN_CTL1,
-			   EUSB2_RPTR_EN, EUSB2_RPTR_EN);
+	regmap_field_update_bits(rptr->regs[F_EN_CTL1], EUSB2_RPTR_EN, EUSB2_RPTR_EN);
 
-	for (i = 0; i < num; i++)
-		regmap_update_bits(rptr->regmap,
-				   rptr->base + init_tbl[i].offset,
-				   init_tbl[i].val, init_tbl[i].val);
+	for (i = 0; i < rptr->cfg->init_tbl_num; i++)
+		regmap_field_update_bits(rptr->regs[init_tbl[i].reg],
+					 init_tbl[i].val, init_tbl[i].val);
 
-	ret = regmap_read_poll_timeout(rptr->regmap,
-				       rptr->base + EUSB2_RPTR_STATUS, val,
-				       val & RPTR_OK, 10, 5);
+	ret = regmap_field_read_poll_timeout(rptr->regs[F_RPTR_STATUS],
+					     val, val & RPTR_OK, 10, 5);
 	if (ret)
 		dev_err(rptr->dev, "initialization timed-out\n");
 
@@ -132,10 +155,10 @@ static int eusb2_repeater_set_mode(struct phy *phy,
 		 * per eUSB 1.2 Spec. Below implement software workaround until
 		 * PHY and controller is fixing seen observation.
 		 */
-		regmap_update_bits(rptr->regmap, rptr->base + EUSB2_FORCE_EN_5,
-				   F_CLK_19P2M_EN, F_CLK_19P2M_EN);
-		regmap_update_bits(rptr->regmap, rptr->base + EUSB2_FORCE_VAL_5,
-				   V_CLK_19P2M_EN, V_CLK_19P2M_EN);
+		regmap_field_update_bits(rptr->regs[F_FORCE_EN_5],
+					 F_CLK_19P2M_EN, F_CLK_19P2M_EN);
+		regmap_field_update_bits(rptr->regs[F_FORCE_VAL_5],
+					 V_CLK_19P2M_EN, V_CLK_19P2M_EN);
 		break;
 	case PHY_MODE_USB_DEVICE:
 		/*
@@ -144,10 +167,10 @@ static int eusb2_repeater_set_mode(struct phy *phy,
 		 * repeater doesn't clear previous value due to shared
 		 * regulators (say host <-> device mode switch).
 		 */
-		regmap_update_bits(rptr->regmap, rptr->base + EUSB2_FORCE_EN_5,
-				   F_CLK_19P2M_EN, 0);
-		regmap_update_bits(rptr->regmap, rptr->base + EUSB2_FORCE_VAL_5,
-				   V_CLK_19P2M_EN, 0);
+		regmap_field_update_bits(rptr->regs[F_FORCE_EN_5],
+					 F_CLK_19P2M_EN, 0);
+		regmap_field_update_bits(rptr->regs[F_FORCE_VAL_5],
+					 V_CLK_19P2M_EN, 0);
 		break;
 	default:
 		return -EINVAL;
@@ -176,8 +199,9 @@ static int eusb2_repeater_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct phy_provider *phy_provider;
 	struct device_node *np = dev->of_node;
+	struct regmap *regmap;
+	int i, ret;
 	u32 res;
-	int ret;
 
 	rptr = devm_kzalloc(dev, sizeof(*rptr), GFP_KERNEL);
 	if (!rptr)
@@ -190,15 +214,22 @@ static int eusb2_repeater_probe(struct platform_device *pdev)
 	if (!rptr->cfg)
 		return -EINVAL;
 
-	rptr->regmap = dev_get_regmap(dev->parent, NULL);
-	if (!rptr->regmap)
+	regmap = dev_get_regmap(dev->parent, NULL);
+	if (!regmap)
 		return -ENODEV;
 
 	ret = of_property_read_u32(np, "reg", &res);
 	if (ret < 0)
 		return ret;
 
-	rptr->base = res;
+	for (i = 0; i < F_NUM_FIELDS; i++)
+		eusb2_repeater_tune_reg_fields[i].reg += res;
+
+	ret = devm_regmap_field_bulk_alloc(dev, regmap, rptr->regs,
+					   eusb2_repeater_tune_reg_fields,
+					   F_NUM_FIELDS);
+	if (ret)
+		return ret;
 
 	ret = eusb2_repeater_init_vregs(rptr);
 	if (ret < 0) {
-- 
2.42.0



