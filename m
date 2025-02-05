Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5161017C79;
	Wed,  5 Feb 2025 15:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768213; cv=none; b=IHkEUJ1q/zu0ih1r1l9GW5/a1/qKT45rhtt+oFFeCTU2HauWOHjeGy2C1VMffttU7bRoc7FGiteKPEN3TozRNOK8DDb791uQ82yyoXeW6q/JkUrNGHBEZBa/C/aCWOtB45z5IfMc1OwlC3mwAGZxAgxcmhBhEGH7J1nqmKR/K/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768213; c=relaxed/simple;
	bh=QdYUuuSRkQhQwnWgYBuv03isPcVtqRDwPr0fT+s86pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1ak46zIi8XELsfb607fO23KsX4BYAYv28EBu1USycgWuk4jck50K1QBSglYeqwfYlmDPAaYh0RtuJ1KnLIFoUFCQ5aobjDv7eqUHRMsQ1ZdwTX6OsHAKq5qCfTaaqtJ31Ezev8TrKlzDc/3ZuhrCw+tJep/UnBnYh7kLzl3tSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HlelWn01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HlelWn01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C83C4CED1;
	Wed,  5 Feb 2025 15:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768212;
	bh=QdYUuuSRkQhQwnWgYBuv03isPcVtqRDwPr0fT+s86pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HlelWn01B+cZzcz1RSyNEhuHi3yxfyRpMUXXYn5yAKb9nohceNm9GVS0Cvs3uSMjm
	 Tc/LbJsu1/HUy5qAO2iAUvfnxYBXHMFz35SJAiLLz3shCFinWInktWQ23kUv1b0zHY
	 kozKW/fFWd+jHnTuDC0HuNFy3CoIjpy30jFWaEGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 495/623] phy: freescale: fsl-samsung-hdmi: Clean up fld_tg_code calculation
Date: Wed,  5 Feb 2025 14:43:57 +0100
Message-ID: <20250205134515.154456182@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit d567679f2b6a8bcea20589bbea6488c0236886cd ]

Currently, the calcuation for fld_tg_code is based on a lookup table,
but there are gaps in the lookup table, and frequencies in these
gaps may not properly use the correct divider.  Based on the description
of FLD_CK_DIV, the internal PLL frequency should be less than 50 MHz,
so directly calcuate the value of FLD_CK_DIV from pixclk.
This allow for proper calcuation of any pixel clock and eliminates a
few gaps in the LUT.

Since the value of the int_pllclk is in Hz, do the fixed-point
math in Hz to achieve a more accurate value and reduces the complexity
of the caluation to 24MHz * (256 / int_pllclk).

Fixes: 6ad082bee902 ("phy: freescale: add Samsung HDMI PHY")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Link: https://lore.kernel.org/r/20241026132014.73050-3-aford173@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/freescale/phy-fsl-samsung-hdmi.c | 32 +++++++-------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/phy/freescale/phy-fsl-samsung-hdmi.c b/drivers/phy/freescale/phy-fsl-samsung-hdmi.c
index d3ccf547ba1c2..17c3786c2f667 100644
--- a/drivers/phy/freescale/phy-fsl-samsung-hdmi.c
+++ b/drivers/phy/freescale/phy-fsl-samsung-hdmi.c
@@ -331,25 +331,17 @@ fsl_samsung_hdmi_phy_configure_pll_lock_det(struct fsl_samsung_hdmi_phy *phy,
 {
 	u32 pclk = cfg->pixclk;
 	u32 fld_tg_code;
-	u32 pclk_khz;
-	u8 div = 1;
-
-	switch (cfg->pixclk) {
-	case  22250000 ...  47500000:
-		div = 1;
-		break;
-	case  50349650 ...  99000000:
-		div = 2;
-		break;
-	case 100699300 ... 198000000:
-		div = 4;
-		break;
-	case 205000000 ... 297000000:
-		div = 8;
-		break;
+	u32 int_pllclk;
+	u8 div;
+
+	/* Find int_pllclk speed */
+	for (div = 0; div < 4; div++) {
+		int_pllclk = pclk / (1 << div);
+		if (int_pllclk < (50 * MHZ))
+			break;
 	}
 
-	writeb(FIELD_PREP(REG12_CK_DIV_MASK, ilog2(div)), phy->regs + PHY_REG(12));
+	writeb(FIELD_PREP(REG12_CK_DIV_MASK, div), phy->regs + PHY_REG(12));
 
 	/*
 	 * Calculation for the frequency lock detector target code (fld_tg_code)
@@ -362,10 +354,8 @@ fsl_samsung_hdmi_phy_configure_pll_lock_det(struct fsl_samsung_hdmi_phy *phy,
 	 *        settings rounding up always too. TODO: Check if that is
 	 *        correct.
 	 */
-	pclk /= div;
-	pclk_khz = pclk / 1000;
-	fld_tg_code = 256 * 1000 * 1000 / pclk_khz * 24;
-	fld_tg_code = DIV_ROUND_UP(fld_tg_code, 1000);
+
+	fld_tg_code =  DIV_ROUND_UP(24 * MHZ * 256, int_pllclk);
 
 	/* FLD_TOL and FLD_RP_CODE taken from downstream driver */
 	writeb(FIELD_PREP(REG13_TG_CODE_LOW_MASK, fld_tg_code),
-- 
2.39.5



