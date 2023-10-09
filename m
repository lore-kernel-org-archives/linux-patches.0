Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FCD1A596
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAqaArO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD05C433C8;
	Mon,  9 Oct 2023 13:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857563;
	bh=b7Q4+wZ+XR9G3e9jCkSIPn9iKaQHkIeXPeL/eqTtc58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAqaArO/q58U64hGuqiSAsXKU4o0u5SRpuYXfOEtH/ntE21KpKwMbsx1C58LZ3xhP
	 RPWTCEtIgfd0WaoCANsbDt0O5RPYgs2jDN/AfgK5qV4QPp7ficfHxS71ZgaHEiC7St
	 0IkrII/Ras69ntX0TinsqawlX1sUkO8FDza81Iu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/162] regulator: mt6358: Use linear voltage helpers for single range regulators
Date: Mon,  9 Oct 2023 15:01:07 +0200
Message-ID: <20231009130125.294976713@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit ea861df772fd8cca715d43f62fe13c09c975f7a2 ]

Some of the regulators on the MT6358/MT6366 PMICs have just one linear
voltage range. These are the bulk regulators and VSRAM_* LDOs. Currently
they are modeled with one linear range, but also have their minimum,
maximum, and step voltage described.

Convert them to the linear voltage helpers. These helpers are a bit
simpler, and we can also drop the linear range definitions. Also reflow
the touched lines now that they are shorter.

Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20230609083009.2822259-7-wenst@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 7e37c851374e ("regulator: mt6358: split ops for buck and linear range LDO regulators")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mt6358-regulator.c | 121 +++++++++------------------
 1 file changed, 40 insertions(+), 81 deletions(-)

diff --git a/drivers/regulator/mt6358-regulator.c b/drivers/regulator/mt6358-regulator.c
index 153c1fd5fb0b7..56b5fc9f62c94 100644
--- a/drivers/regulator/mt6358-regulator.c
+++ b/drivers/regulator/mt6358-regulator.c
@@ -35,7 +35,7 @@ struct mt6358_regulator_info {
 };
 
 #define MT6358_BUCK(match, vreg, min, max, step,		\
-	volt_ranges, vosel_mask, _da_vsel_reg, _da_vsel_mask,	\
+	vosel_mask, _da_vsel_reg, _da_vsel_mask,	\
 	_modeset_reg, _modeset_shift)		\
 [MT6358_ID_##vreg] = {	\
 	.desc = {	\
@@ -46,8 +46,8 @@ struct mt6358_regulator_info {
 		.id = MT6358_ID_##vreg,		\
 		.owner = THIS_MODULE,		\
 		.n_voltages = ((max) - (min)) / (step) + 1,	\
-		.linear_ranges = volt_ranges,		\
-		.n_linear_ranges = ARRAY_SIZE(volt_ranges),	\
+		.min_uV = (min),		\
+		.uV_step = (step),		\
 		.vsel_reg = MT6358_BUCK_##vreg##_ELR0,	\
 		.vsel_mask = vosel_mask,	\
 		.enable_reg = MT6358_BUCK_##vreg##_CON0,	\
@@ -87,7 +87,7 @@ struct mt6358_regulator_info {
 }
 
 #define MT6358_LDO1(match, vreg, min, max, step,	\
-	volt_ranges, _da_vsel_reg, _da_vsel_mask,	\
+	_da_vsel_reg, _da_vsel_mask,	\
 	vosel, vosel_mask)	\
 [MT6358_ID_##vreg] = {	\
 	.desc = {	\
@@ -98,8 +98,8 @@ struct mt6358_regulator_info {
 		.id = MT6358_ID_##vreg,	\
 		.owner = THIS_MODULE,	\
 		.n_voltages = ((max) - (min)) / (step) + 1,	\
-		.linear_ranges = volt_ranges,	\
-		.n_linear_ranges = ARRAY_SIZE(volt_ranges),	\
+		.min_uV = (min),		\
+		.uV_step = (step),		\
 		.vsel_reg = vosel,	\
 		.vsel_mask = vosel_mask,	\
 		.enable_reg = MT6358_LDO_##vreg##_CON0,	\
@@ -131,7 +131,7 @@ struct mt6358_regulator_info {
 }
 
 #define MT6366_BUCK(match, vreg, min, max, step,		\
-	volt_ranges, vosel_mask, _da_vsel_reg, _da_vsel_mask,	\
+	vosel_mask, _da_vsel_reg, _da_vsel_mask,	\
 	_modeset_reg, _modeset_shift)		\
 [MT6366_ID_##vreg] = {	\
 	.desc = {	\
@@ -142,8 +142,8 @@ struct mt6358_regulator_info {
 		.id = MT6366_ID_##vreg,		\
 		.owner = THIS_MODULE,		\
 		.n_voltages = ((max) - (min)) / (step) + 1,	\
-		.linear_ranges = volt_ranges,		\
-		.n_linear_ranges = ARRAY_SIZE(volt_ranges),	\
+		.min_uV = (min),		\
+		.uV_step = (step),		\
 		.vsel_reg = MT6358_BUCK_##vreg##_ELR0,	\
 		.vsel_mask = vosel_mask,	\
 		.enable_reg = MT6358_BUCK_##vreg##_CON0,	\
@@ -183,7 +183,7 @@ struct mt6358_regulator_info {
 }
 
 #define MT6366_LDO1(match, vreg, min, max, step,	\
-	volt_ranges, _da_vsel_reg, _da_vsel_mask,	\
+	_da_vsel_reg, _da_vsel_mask,	\
 	vosel, vosel_mask)	\
 [MT6366_ID_##vreg] = {	\
 	.desc = {	\
@@ -194,8 +194,8 @@ struct mt6358_regulator_info {
 		.id = MT6366_ID_##vreg,	\
 		.owner = THIS_MODULE,	\
 		.n_voltages = ((max) - (min)) / (step) + 1,	\
-		.linear_ranges = volt_ranges,	\
-		.n_linear_ranges = ARRAY_SIZE(volt_ranges),	\
+		.min_uV = (min),		\
+		.uV_step = (step),		\
 		.vsel_reg = vosel,	\
 		.vsel_mask = vosel_mask,	\
 		.enable_reg = MT6358_LDO_##vreg##_CON0,	\
@@ -226,21 +226,6 @@ struct mt6358_regulator_info {
 	.qi = BIT(15),							\
 }
 
-static const struct linear_range buck_volt_range1[] = {
-	REGULATOR_LINEAR_RANGE(500000, 0, 0x7f, 6250),
-};
-
-static const struct linear_range buck_volt_range2[] = {
-	REGULATOR_LINEAR_RANGE(500000, 0, 0x7f, 12500),
-};
-
-static const struct linear_range buck_volt_range3[] = {
-	REGULATOR_LINEAR_RANGE(500000, 0, 0x3f, 50000),
-};
-
-static const struct linear_range buck_volt_range4[] = {
-	REGULATOR_LINEAR_RANGE(1000000, 0, 0x7f, 12500),
-};
 
 static const unsigned int vdram2_voltages[] = {
 	600000, 1800000,
@@ -464,8 +449,8 @@ static unsigned int mt6358_regulator_get_mode(struct regulator_dev *rdev)
 }
 
 static const struct regulator_ops mt6358_volt_range_ops = {
-	.list_voltage = regulator_list_voltage_linear_range,
-	.map_voltage = regulator_map_voltage_linear_range,
+	.list_voltage = regulator_list_voltage_linear,
+	.map_voltage = regulator_map_voltage_linear,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_voltage_sel = mt6358_get_buck_voltage_sel,
 	.set_voltage_time_sel = regulator_set_voltage_time_sel,
@@ -500,32 +485,23 @@ static const struct regulator_ops mt6358_volt_fixed_ops = {
 /* The array is indexed by id(MT6358_ID_XXX) */
 static struct mt6358_regulator_info mt6358_regulators[] = {
 	MT6358_BUCK("buck_vdram1", VDRAM1, 500000, 2087500, 12500,
-		    buck_volt_range2, 0x7f, MT6358_BUCK_VDRAM1_DBG0, 0x7f,
-		    MT6358_VDRAM1_ANA_CON0, 8),
+		    0x7f, MT6358_BUCK_VDRAM1_DBG0, 0x7f, MT6358_VDRAM1_ANA_CON0, 8),
 	MT6358_BUCK("buck_vcore", VCORE, 500000, 1293750, 6250,
-		    buck_volt_range1, 0x7f, MT6358_BUCK_VCORE_DBG0, 0x7f,
-		    MT6358_VCORE_VGPU_ANA_CON0, 1),
+		    0x7f, MT6358_BUCK_VCORE_DBG0, 0x7f, MT6358_VCORE_VGPU_ANA_CON0, 1),
 	MT6358_BUCK("buck_vpa", VPA, 500000, 3650000, 50000,
-		    buck_volt_range3, 0x3f, MT6358_BUCK_VPA_DBG0, 0x3f,
-		    MT6358_VPA_ANA_CON0, 3),
+		    0x3f, MT6358_BUCK_VPA_DBG0, 0x3f, MT6358_VPA_ANA_CON0, 3),
 	MT6358_BUCK("buck_vproc11", VPROC11, 500000, 1293750, 6250,
-		    buck_volt_range1, 0x7f, MT6358_BUCK_VPROC11_DBG0, 0x7f,
-		    MT6358_VPROC_ANA_CON0, 1),
+		    0x7f, MT6358_BUCK_VPROC11_DBG0, 0x7f, MT6358_VPROC_ANA_CON0, 1),
 	MT6358_BUCK("buck_vproc12", VPROC12, 500000, 1293750, 6250,
-		    buck_volt_range1, 0x7f, MT6358_BUCK_VPROC12_DBG0, 0x7f,
-		    MT6358_VPROC_ANA_CON0, 2),
+		    0x7f, MT6358_BUCK_VPROC12_DBG0, 0x7f, MT6358_VPROC_ANA_CON0, 2),
 	MT6358_BUCK("buck_vgpu", VGPU, 500000, 1293750, 6250,
-		    buck_volt_range1, 0x7f, MT6358_BUCK_VGPU_ELR0, 0x7f,
-		    MT6358_VCORE_VGPU_ANA_CON0, 2),
+		    0x7f, MT6358_BUCK_VGPU_ELR0, 0x7f, MT6358_VCORE_VGPU_ANA_CON0, 2),
 	MT6358_BUCK("buck_vs2", VS2, 500000, 2087500, 12500,
-		    buck_volt_range2, 0x7f, MT6358_BUCK_VS2_DBG0, 0x7f,
-		    MT6358_VS2_ANA_CON0, 8),
+		    0x7f, MT6358_BUCK_VS2_DBG0, 0x7f, MT6358_VS2_ANA_CON0, 8),
 	MT6358_BUCK("buck_vmodem", VMODEM, 500000, 1293750, 6250,
-		    buck_volt_range1, 0x7f, MT6358_BUCK_VMODEM_DBG0, 0x7f,
-		    MT6358_VMODEM_ANA_CON0, 8),
+		    0x7f, MT6358_BUCK_VMODEM_DBG0, 0x7f, MT6358_VMODEM_ANA_CON0, 8),
 	MT6358_BUCK("buck_vs1", VS1, 1000000, 2587500, 12500,
-		    buck_volt_range4, 0x7f, MT6358_BUCK_VS1_DBG0, 0x7f,
-		    MT6358_VS1_ANA_CON0, 8),
+		    0x7f, MT6358_BUCK_VS1_DBG0, 0x7f, MT6358_VS1_ANA_CON0, 8),
 	MT6358_REG_FIXED("ldo_vrf12", VRF12,
 			 MT6358_LDO_VRF12_CON0, 0, 1200000),
 	MT6358_REG_FIXED("ldo_vio18", VIO18,
@@ -579,48 +555,35 @@ static struct mt6358_regulator_info mt6358_regulators[] = {
 	MT6358_LDO("ldo_vsim2", VSIM2, vsim_voltages, vsim_idx,
 		   MT6358_LDO_VSIM2_CON0, 0, MT6358_VSIM2_ANA_CON0, 0xf00),
 	MT6358_LDO1("ldo_vsram_proc11", VSRAM_PROC11, 500000, 1293750, 6250,
-		    buck_volt_range1, MT6358_LDO_VSRAM_PROC11_DBG0, 0x7f00,
-		    MT6358_LDO_VSRAM_CON0, 0x7f),
+		    MT6358_LDO_VSRAM_PROC11_DBG0, 0x7f00, MT6358_LDO_VSRAM_CON0, 0x7f),
 	MT6358_LDO1("ldo_vsram_others", VSRAM_OTHERS, 500000, 1293750, 6250,
-		    buck_volt_range1, MT6358_LDO_VSRAM_OTHERS_DBG0, 0x7f00,
-		    MT6358_LDO_VSRAM_CON2, 0x7f),
+		    MT6358_LDO_VSRAM_OTHERS_DBG0, 0x7f00, MT6358_LDO_VSRAM_CON2, 0x7f),
 	MT6358_LDO1("ldo_vsram_gpu", VSRAM_GPU, 500000, 1293750, 6250,
-		    buck_volt_range1, MT6358_LDO_VSRAM_GPU_DBG0, 0x7f00,
-		    MT6358_LDO_VSRAM_CON3, 0x7f),
+		    MT6358_LDO_VSRAM_GPU_DBG0, 0x7f00, MT6358_LDO_VSRAM_CON3, 0x7f),
 	MT6358_LDO1("ldo_vsram_proc12", VSRAM_PROC12, 500000, 1293750, 6250,
-		    buck_volt_range1, MT6358_LDO_VSRAM_PROC12_DBG0, 0x7f00,
-		    MT6358_LDO_VSRAM_CON1, 0x7f),
+		    MT6358_LDO_VSRAM_PROC12_DBG0, 0x7f00, MT6358_LDO_VSRAM_CON1, 0x7f),
 };
 
 /* The array is indexed by id(MT6366_ID_XXX) */
 static struct mt6358_regulator_info mt6366_regulators[] = {
 	MT6366_BUCK("buck_vdram1", VDRAM1, 500000, 2087500, 12500,
-		    buck_volt_range2, 0x7f, MT6358_BUCK_VDRAM1_DBG0, 0x7f,
-		    MT6358_VDRAM1_ANA_CON0, 8),
+		    0x7f, MT6358_BUCK_VDRAM1_DBG0, 0x7f, MT6358_VDRAM1_ANA_CON0, 8),
 	MT6366_BUCK("buck_vcore", VCORE, 500000, 1293750, 6250,
-		    buck_volt_range1, 0x7f, MT6358_BUCK_VCORE_DBG0, 0x7f,
-		    MT6358_VCORE_VGPU_ANA_CON0, 1),
+		    0x7f, MT6358_BUCK_VCORE_DBG0, 0x7f, MT6358_VCORE_VGPU_ANA_CON0, 1),
 	MT6366_BUCK("buck_vpa", VPA, 500000, 3650000, 50000,
-		    buck_volt_range3, 0x3f, MT6358_BUCK_VPA_DBG0, 0x3f,
-		    MT6358_VPA_ANA_CON0, 3),
+		    0x3f, MT6358_BUCK_VPA_DBG0, 0x3f, MT6358_VPA_ANA_CON0, 3),
 	MT6366_BUCK("buck_vproc11", VPROC11, 500000, 1293750, 6250,
-		    buck_volt_range1, 0x7f, MT6358_BUCK_VPROC11_DBG0, 0x7f,
-		    MT6358_VPROC_ANA_CON0, 1),
+		    0x7f, MT6358_BUCK_VPROC11_DBG0, 0x7f, MT6358_VPROC_ANA_CON0, 1),
 	MT6366_BUCK("buck_vproc12", VPROC12, 500000, 1293750, 6250,
-		    buck_volt_range1, 0x7f, MT6358_BUCK_VPROC12_DBG0, 0x7f,
-		    MT6358_VPROC_ANA_CON0, 2),
+		    0x7f, MT6358_BUCK_VPROC12_DBG0, 0x7f, MT6358_VPROC_ANA_CON0, 2),
 	MT6366_BUCK("buck_vgpu", VGPU, 500000, 1293750, 6250,
-		    buck_volt_range1, 0x7f, MT6358_BUCK_VGPU_ELR0, 0x7f,
-		    MT6358_VCORE_VGPU_ANA_CON0, 2),
+		    0x7f, MT6358_BUCK_VGPU_ELR0, 0x7f, MT6358_VCORE_VGPU_ANA_CON0, 2),
 	MT6366_BUCK("buck_vs2", VS2, 500000, 2087500, 12500,
-		    buck_volt_range2, 0x7f, MT6358_BUCK_VS2_DBG0, 0x7f,
-		    MT6358_VS2_ANA_CON0, 8),
+		    0x7f, MT6358_BUCK_VS2_DBG0, 0x7f, MT6358_VS2_ANA_CON0, 8),
 	MT6366_BUCK("buck_vmodem", VMODEM, 500000, 1293750, 6250,
-		    buck_volt_range1, 0x7f, MT6358_BUCK_VMODEM_DBG0, 0x7f,
-		    MT6358_VMODEM_ANA_CON0, 8),
+		    0x7f, MT6358_BUCK_VMODEM_DBG0, 0x7f, MT6358_VMODEM_ANA_CON0, 8),
 	MT6366_BUCK("buck_vs1", VS1, 1000000, 2587500, 12500,
-		    buck_volt_range4, 0x7f, MT6358_BUCK_VS1_DBG0, 0x7f,
-		    MT6358_VS1_ANA_CON0, 8),
+		    0x7f, MT6358_BUCK_VS1_DBG0, 0x7f, MT6358_VS1_ANA_CON0, 8),
 	MT6366_REG_FIXED("ldo_vrf12", VRF12,
 			 MT6358_LDO_VRF12_CON0, 0, 1200000),
 	MT6366_REG_FIXED("ldo_vio18", VIO18,
@@ -663,17 +626,13 @@ static struct mt6358_regulator_info mt6366_regulators[] = {
 	MT6366_LDO("ldo_vsim2", VSIM2, vsim_voltages, vsim_idx,
 		   MT6358_LDO_VSIM2_CON0, 0, MT6358_VSIM2_ANA_CON0, 0xf00),
 	MT6366_LDO1("ldo_vsram_proc11", VSRAM_PROC11, 500000, 1293750, 6250,
-		    buck_volt_range1, MT6358_LDO_VSRAM_PROC11_DBG0, 0x7f00,
-		    MT6358_LDO_VSRAM_CON0, 0x7f),
+		    MT6358_LDO_VSRAM_PROC11_DBG0, 0x7f00, MT6358_LDO_VSRAM_CON0, 0x7f),
 	MT6366_LDO1("ldo_vsram_others", VSRAM_OTHERS, 500000, 1293750, 6250,
-		    buck_volt_range1, MT6358_LDO_VSRAM_OTHERS_DBG0, 0x7f00,
-		    MT6358_LDO_VSRAM_CON2, 0x7f),
+		    MT6358_LDO_VSRAM_OTHERS_DBG0, 0x7f00, MT6358_LDO_VSRAM_CON2, 0x7f),
 	MT6366_LDO1("ldo_vsram_gpu", VSRAM_GPU, 500000, 1293750, 6250,
-		    buck_volt_range1, MT6358_LDO_VSRAM_GPU_DBG0, 0x7f00,
-		    MT6358_LDO_VSRAM_CON3, 0x7f),
+		    MT6358_LDO_VSRAM_GPU_DBG0, 0x7f00, MT6358_LDO_VSRAM_CON3, 0x7f),
 	MT6366_LDO1("ldo_vsram_proc12", VSRAM_PROC12, 500000, 1293750, 6250,
-		    buck_volt_range1, MT6358_LDO_VSRAM_PROC12_DBG0, 0x7f00,
-		    MT6358_LDO_VSRAM_CON1, 0x7f),
+		    MT6358_LDO_VSRAM_PROC12_DBG0, 0x7f00, MT6358_LDO_VSRAM_CON1, 0x7f),
 };
 
 static int mt6358_regulator_probe(struct platform_device *pdev)
-- 
2.40.1



