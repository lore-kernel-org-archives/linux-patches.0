Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797531DFD1;
	Sun,  1 Sep 2024 16:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209647; cv=none; b=fIArvZy33pRpy3T0KnSNgAd+y2Gng5DSflO5GJhYBjVV5ZOaRMHcL7+0VMA3vO79gfuMSZoBhrjxjC3vn6JodwTdXYBbWQFgW74ODXH1GwVBREoTFZJYo6hkUJEnNlECGb12CPGdcSqDPgrgpt/ferWYCjbKb+K/yj2D6uLLFPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209647; c=relaxed/simple;
	bh=5VaBse1ywGEDoRYcG+sHdPvb7A/k5UdlRZCK9TO69Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/xaIRdTGmfr0ILjljQBQgPbw+5znF6MRhOhWzxrqU+sK5WkmkZbp9QrDraNeMrykbMAtN2E9T94wsvvrSIsye4QtPqEku5Ey6zYV8ZXMrluLBKxy1a57c5lV41/NPWD1SCjCc24zEVfTk0OVqKCr5zw1H/sPsqJLqEcQWHlnJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHnuxyn+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHnuxyn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77F0C4CEC3;
	Sun,  1 Sep 2024 16:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209647;
	bh=5VaBse1ywGEDoRYcG+sHdPvb7A/k5UdlRZCK9TO69Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHnuxyn+rgxi0rX1/DafIQeh1x1oAUZY3yjGKqUlUyArCQ625o2vPGpZLyMn9+GPy
	 MeqrRc4OV31hVHv6pe2hE7Mh46UQ6zi4KhJh69UnLuu2LT/FoMui9zIBww+XnPq/9f
	 apK5RiGqHDAh0DCOj06/rhzOaFRuf3KN8FVSFXYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Kerello <christophe.kerello@foss.st.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/151] memory: stm32-fmc2-ebi: check regmap_read return value
Date: Sun,  1 Sep 2024 18:17:00 +0200
Message-ID: <20240901160816.375499054@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Kerello <christophe.kerello@foss.st.com>

[ Upstream commit 722463f73bcf65a8c818752a38c14ee672c77da1 ]

Check regmap_read return value to avoid to use uninitialized local
variables.

Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
Link: https://lore.kernel.org/r/20240226101428.37791-3-christophe.kerello@foss.st.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/stm32-fmc2-ebi.c | 122 +++++++++++++++++++++++---------
 1 file changed, 88 insertions(+), 34 deletions(-)

diff --git a/drivers/memory/stm32-fmc2-ebi.c b/drivers/memory/stm32-fmc2-ebi.c
index ffec26a99313b..5c387d32c078f 100644
--- a/drivers/memory/stm32-fmc2-ebi.c
+++ b/drivers/memory/stm32-fmc2-ebi.c
@@ -179,8 +179,11 @@ static int stm32_fmc2_ebi_check_mux(struct stm32_fmc2_ebi *ebi,
 				    int cs)
 {
 	u32 bcr;
+	int ret;
 
-	regmap_read(ebi->regmap, FMC2_BCR(cs), &bcr);
+	ret = regmap_read(ebi->regmap, FMC2_BCR(cs), &bcr);
+	if (ret)
+		return ret;
 
 	if (bcr & FMC2_BCR_MTYP)
 		return 0;
@@ -193,8 +196,11 @@ static int stm32_fmc2_ebi_check_waitcfg(struct stm32_fmc2_ebi *ebi,
 					int cs)
 {
 	u32 bcr, val = FIELD_PREP(FMC2_BCR_MTYP, FMC2_BCR_MTYP_NOR);
+	int ret;
 
-	regmap_read(ebi->regmap, FMC2_BCR(cs), &bcr);
+	ret = regmap_read(ebi->regmap, FMC2_BCR(cs), &bcr);
+	if (ret)
+		return ret;
 
 	if ((bcr & FMC2_BCR_MTYP) == val && bcr & FMC2_BCR_BURSTEN)
 		return 0;
@@ -207,8 +213,11 @@ static int stm32_fmc2_ebi_check_sync_trans(struct stm32_fmc2_ebi *ebi,
 					   int cs)
 {
 	u32 bcr;
+	int ret;
 
-	regmap_read(ebi->regmap, FMC2_BCR(cs), &bcr);
+	ret = regmap_read(ebi->regmap, FMC2_BCR(cs), &bcr);
+	if (ret)
+		return ret;
 
 	if (bcr & FMC2_BCR_BURSTEN)
 		return 0;
@@ -221,8 +230,11 @@ static int stm32_fmc2_ebi_check_async_trans(struct stm32_fmc2_ebi *ebi,
 					    int cs)
 {
 	u32 bcr;
+	int ret;
 
-	regmap_read(ebi->regmap, FMC2_BCR(cs), &bcr);
+	ret = regmap_read(ebi->regmap, FMC2_BCR(cs), &bcr);
+	if (ret)
+		return ret;
 
 	if (!(bcr & FMC2_BCR_BURSTEN) || !(bcr & FMC2_BCR_CBURSTRW))
 		return 0;
@@ -235,8 +247,11 @@ static int stm32_fmc2_ebi_check_cpsize(struct stm32_fmc2_ebi *ebi,
 				       int cs)
 {
 	u32 bcr, val = FIELD_PREP(FMC2_BCR_MTYP, FMC2_BCR_MTYP_PSRAM);
+	int ret;
 
-	regmap_read(ebi->regmap, FMC2_BCR(cs), &bcr);
+	ret = regmap_read(ebi->regmap, FMC2_BCR(cs), &bcr);
+	if (ret)
+		return ret;
 
 	if ((bcr & FMC2_BCR_MTYP) == val && bcr & FMC2_BCR_BURSTEN)
 		return 0;
@@ -249,12 +264,18 @@ static int stm32_fmc2_ebi_check_address_hold(struct stm32_fmc2_ebi *ebi,
 					     int cs)
 {
 	u32 bcr, bxtr, val = FIELD_PREP(FMC2_BXTR_ACCMOD, FMC2_BXTR_EXTMOD_D);
+	int ret;
+
+	ret = regmap_read(ebi->regmap, FMC2_BCR(cs), &bcr);
+	if (ret)
+		return ret;
 
-	regmap_read(ebi->regmap, FMC2_BCR(cs), &bcr);
 	if (prop->reg_type == FMC2_REG_BWTR)
-		regmap_read(ebi->regmap, FMC2_BWTR(cs), &bxtr);
+		ret = regmap_read(ebi->regmap, FMC2_BWTR(cs), &bxtr);
 	else
-		regmap_read(ebi->regmap, FMC2_BTR(cs), &bxtr);
+		ret = regmap_read(ebi->regmap, FMC2_BTR(cs), &bxtr);
+	if (ret)
+		return ret;
 
 	if ((!(bcr & FMC2_BCR_BURSTEN) || !(bcr & FMC2_BCR_CBURSTRW)) &&
 	    ((bxtr & FMC2_BXTR_ACCMOD) == val || bcr & FMC2_BCR_MUXEN))
@@ -268,12 +289,19 @@ static int stm32_fmc2_ebi_check_clk_period(struct stm32_fmc2_ebi *ebi,
 					   int cs)
 {
 	u32 bcr, bcr1;
+	int ret;
 
-	regmap_read(ebi->regmap, FMC2_BCR(cs), &bcr);
-	if (cs)
-		regmap_read(ebi->regmap, FMC2_BCR1, &bcr1);
-	else
+	ret = regmap_read(ebi->regmap, FMC2_BCR(cs), &bcr);
+	if (ret)
+		return ret;
+
+	if (cs) {
+		ret = regmap_read(ebi->regmap, FMC2_BCR1, &bcr1);
+		if (ret)
+			return ret;
+	} else {
 		bcr1 = bcr;
+	}
 
 	if (bcr & FMC2_BCR_BURSTEN && (!cs || !(bcr1 & FMC2_BCR1_CCLKEN)))
 		return 0;
@@ -305,12 +333,18 @@ static u32 stm32_fmc2_ebi_ns_to_clk_period(struct stm32_fmc2_ebi *ebi,
 {
 	u32 nb_clk_cycles = stm32_fmc2_ebi_ns_to_clock_cycles(ebi, cs, setup);
 	u32 bcr, btr, clk_period;
+	int ret;
+
+	ret = regmap_read(ebi->regmap, FMC2_BCR1, &bcr);
+	if (ret)
+		return ret;
 
-	regmap_read(ebi->regmap, FMC2_BCR1, &bcr);
 	if (bcr & FMC2_BCR1_CCLKEN || !cs)
-		regmap_read(ebi->regmap, FMC2_BTR1, &btr);
+		ret = regmap_read(ebi->regmap, FMC2_BTR1, &btr);
 	else
-		regmap_read(ebi->regmap, FMC2_BTR(cs), &btr);
+		ret = regmap_read(ebi->regmap, FMC2_BTR(cs), &btr);
+	if (ret)
+		return ret;
 
 	clk_period = FIELD_GET(FMC2_BTR_CLKDIV, btr) + 1;
 
@@ -569,11 +603,16 @@ static int stm32_fmc2_ebi_set_address_setup(struct stm32_fmc2_ebi *ebi,
 	if (ret)
 		return ret;
 
-	regmap_read(ebi->regmap, FMC2_BCR(cs), &bcr);
+	ret = regmap_read(ebi->regmap, FMC2_BCR(cs), &bcr);
+	if (ret)
+		return ret;
+
 	if (prop->reg_type == FMC2_REG_BWTR)
-		regmap_read(ebi->regmap, FMC2_BWTR(cs), &bxtr);
+		ret = regmap_read(ebi->regmap, FMC2_BWTR(cs), &bxtr);
 	else
-		regmap_read(ebi->regmap, FMC2_BTR(cs), &bxtr);
+		ret = regmap_read(ebi->regmap, FMC2_BTR(cs), &bxtr);
+	if (ret)
+		return ret;
 
 	if ((bxtr & FMC2_BXTR_ACCMOD) == val || bcr & FMC2_BCR_MUXEN)
 		val = clamp_val(setup, 1, FMC2_BXTR_ADDSET_MAX);
@@ -691,11 +730,14 @@ static int stm32_fmc2_ebi_set_max_low_pulse(struct stm32_fmc2_ebi *ebi,
 					    int cs, u32 setup)
 {
 	u32 old_val, new_val, pcscntr;
+	int ret;
 
 	if (setup < 1)
 		return 0;
 
-	regmap_read(ebi->regmap, FMC2_PCSCNTR, &pcscntr);
+	ret = regmap_read(ebi->regmap, FMC2_PCSCNTR, &pcscntr);
+	if (ret)
+		return ret;
 
 	/* Enable counter for the bank */
 	regmap_update_bits(ebi->regmap, FMC2_PCSCNTR,
@@ -942,17 +984,20 @@ static void stm32_fmc2_ebi_disable_bank(struct stm32_fmc2_ebi *ebi, int cs)
 	regmap_update_bits(ebi->regmap, FMC2_BCR(cs), FMC2_BCR_MBKEN, 0);
 }
 
-static void stm32_fmc2_ebi_save_setup(struct stm32_fmc2_ebi *ebi)
+static int stm32_fmc2_ebi_save_setup(struct stm32_fmc2_ebi *ebi)
 {
 	unsigned int cs;
+	int ret;
 
 	for (cs = 0; cs < FMC2_MAX_EBI_CE; cs++) {
-		regmap_read(ebi->regmap, FMC2_BCR(cs), &ebi->bcr[cs]);
-		regmap_read(ebi->regmap, FMC2_BTR(cs), &ebi->btr[cs]);
-		regmap_read(ebi->regmap, FMC2_BWTR(cs), &ebi->bwtr[cs]);
+		ret = regmap_read(ebi->regmap, FMC2_BCR(cs), &ebi->bcr[cs]);
+		ret |= regmap_read(ebi->regmap, FMC2_BTR(cs), &ebi->btr[cs]);
+		ret |= regmap_read(ebi->regmap, FMC2_BWTR(cs), &ebi->bwtr[cs]);
+		if (ret)
+			return ret;
 	}
 
-	regmap_read(ebi->regmap, FMC2_PCSCNTR, &ebi->pcscntr);
+	return regmap_read(ebi->regmap, FMC2_PCSCNTR, &ebi->pcscntr);
 }
 
 static void stm32_fmc2_ebi_set_setup(struct stm32_fmc2_ebi *ebi)
@@ -981,22 +1026,29 @@ static void stm32_fmc2_ebi_disable_banks(struct stm32_fmc2_ebi *ebi)
 }
 
 /* NWAIT signal can not be connected to EBI controller and NAND controller */
-static bool stm32_fmc2_ebi_nwait_used_by_ctrls(struct stm32_fmc2_ebi *ebi)
+static int stm32_fmc2_ebi_nwait_used_by_ctrls(struct stm32_fmc2_ebi *ebi)
 {
+	struct device *dev = ebi->dev;
 	unsigned int cs;
 	u32 bcr;
+	int ret;
 
 	for (cs = 0; cs < FMC2_MAX_EBI_CE; cs++) {
 		if (!(ebi->bank_assigned & BIT(cs)))
 			continue;
 
-		regmap_read(ebi->regmap, FMC2_BCR(cs), &bcr);
+		ret = regmap_read(ebi->regmap, FMC2_BCR(cs), &bcr);
+		if (ret)
+			return ret;
+
 		if ((bcr & FMC2_BCR_WAITEN || bcr & FMC2_BCR_ASYNCWAIT) &&
-		    ebi->bank_assigned & BIT(FMC2_NAND))
-			return true;
+		    ebi->bank_assigned & BIT(FMC2_NAND)) {
+			dev_err(dev, "NWAIT signal connected to EBI and NAND controllers\n");
+			return -EINVAL;
+		}
 	}
 
-	return false;
+	return 0;
 }
 
 static void stm32_fmc2_ebi_enable(struct stm32_fmc2_ebi *ebi)
@@ -1083,10 +1135,9 @@ static int stm32_fmc2_ebi_parse_dt(struct stm32_fmc2_ebi *ebi)
 		return -ENODEV;
 	}
 
-	if (stm32_fmc2_ebi_nwait_used_by_ctrls(ebi)) {
-		dev_err(dev, "NWAIT signal connected to EBI and NAND controllers\n");
-		return -EINVAL;
-	}
+	ret = stm32_fmc2_ebi_nwait_used_by_ctrls(ebi);
+	if (ret)
+		return ret;
 
 	stm32_fmc2_ebi_enable(ebi);
 
@@ -1131,7 +1182,10 @@ static int stm32_fmc2_ebi_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_release;
 
-	stm32_fmc2_ebi_save_setup(ebi);
+	ret = stm32_fmc2_ebi_save_setup(ebi);
+	if (ret)
+		goto err_release;
+
 	platform_set_drvdata(pdev, ebi);
 
 	return 0;
-- 
2.43.0



