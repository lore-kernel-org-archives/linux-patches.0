Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD1527FB37;
	Wed, 25 Feb 2026 06:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002665; cv=none; b=i1lKU57jmkeYDipufmMqWQPU4Umuy5DSZTLvI2RlUlgzt/iXIeRgxwygcgK7JI8L+r0puXDzGz/r1O7ssKmF0Y7gtUkuw8IQtBBeycQuBPNoxKcToH5LZA2vVfcMk3vjp943YqUqLd0IsqYK9balefnkIlHvcfap8lQW9z9ZPuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002665; c=relaxed/simple;
	bh=VNstu/6+BLFXu/xcSwQSRQA5PyV3oh8Qs8CvuWfO1MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oeybJgfb0HoaXHZcRZ1wANY+A2YLm6EqgZbPqKtyTwWbMwylOSOMp5ElKUWH0opfNqyraVzHmCBWHY0BIYi/z0P2P/2Mo+61E04NHwlV/ju/11pnNG4AT567ZSsI+jbBpEBEcP3T2KKxN6mvllLIwQ9HHhQANrG4joK0/zeLeeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GoZYbsnd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GoZYbsnd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942B2C116D0;
	Wed, 25 Feb 2026 06:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002665;
	bh=VNstu/6+BLFXu/xcSwQSRQA5PyV3oh8Qs8CvuWfO1MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GoZYbsndr53JSnb4r462Cp2Ku5P+EgQNBwZaL4i2GCAZGOyaeSP0B/UHqsZP67FBk
	 EUK9R8NYOqmghIwtv/TXXy2hhTHkV7fAB3u1Z6yc0QZ+t0eScMHZ5zDFyQLT7wurxX
	 AXsywX21LIhtA1P0cTgZOfnC6sYPzzWSu9S63et0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 446/641] clk: mediatek: Add mfg_eb as parent to mt8196 mfgpll clocks
Date: Tue, 24 Feb 2026 17:22:52 -0800
Message-ID: <20260225012359.330569144@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

[ Upstream commit 19024c9980c331908de0680283d572b80308654e ]

All the MFGPLL require MFG_EB to be on for any operation on them, and
they only tick when MFG_EB is on as well, therefore making this a
parent-child relationship.

This dependency wasn't clear during the initial upstreaming of these
clock controllers, as it only made itself known when I could observe
the effects of the clock by bringing up a different piece of hardware.

Add a new PLL_PARENT_EN flag to mediatek's clk-pll.h, and check for it
when initialising the pll to then translate it into the actual
CLK_OPS_PARENT_ENABLE flag.

Then add the mfg_eb parent to the mfgpll clocks, and set the new
PLL_PARENT_EN flag.

Fixes: 03dc02f8c7dc ("clk: mediatek: Add MT8196 mfg clock support")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt8196-mfg.c | 13 +++++++------
 drivers/clk/mediatek/clk-pll.c        |  3 +++
 drivers/clk/mediatek/clk-pll.h        |  1 +
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/mediatek/clk-mt8196-mfg.c b/drivers/clk/mediatek/clk-mt8196-mfg.c
index ae1eb9de79ae2..f40795b47ff1f 100644
--- a/drivers/clk/mediatek/clk-mt8196-mfg.c
+++ b/drivers/clk/mediatek/clk-mt8196-mfg.c
@@ -58,24 +58,25 @@
 		.pcw_shift = _pcw_shift,			\
 		.pcwbits = _pcwbits,				\
 		.pcwibits = MT8196_INTEGER_BITS,		\
+		.parent_name = "mfg_eb",			\
 	}
 
 static const struct mtk_pll_data mfg_ao_plls[] = {
-	PLL(CLK_MFG_AO_MFGPLL, "mfgpll", MFGPLL_CON0, MFGPLL_CON0, 0, 0, 0,
-	    BIT(0), MFGPLL_CON1, 24, 0, 0, 0,
+	PLL(CLK_MFG_AO_MFGPLL, "mfgpll", MFGPLL_CON0, MFGPLL_CON0, 0, 0,
+	    PLL_PARENT_EN, BIT(0), MFGPLL_CON1, 24, 0, 0, 0,
 	    MFGPLL_CON1, 0, 22),
 };
 
 static const struct mtk_pll_data mfgsc0_ao_plls[] = {
 	PLL(CLK_MFGSC0_AO_MFGPLL_SC0, "mfgpll-sc0", MFGPLL_SC0_CON0,
-	    MFGPLL_SC0_CON0, 0, 0, 0, BIT(0), MFGPLL_SC0_CON1, 24, 0, 0, 0,
-	    MFGPLL_SC0_CON1, 0, 22),
+	    MFGPLL_SC0_CON0, 0, 0, PLL_PARENT_EN, BIT(0), MFGPLL_SC0_CON1, 24,
+	    0, 0, 0, MFGPLL_SC0_CON1, 0, 22),
 };
 
 static const struct mtk_pll_data mfgsc1_ao_plls[] = {
 	PLL(CLK_MFGSC1_AO_MFGPLL_SC1, "mfgpll-sc1", MFGPLL_SC1_CON0,
-	    MFGPLL_SC1_CON0, 0, 0, 0, BIT(0), MFGPLL_SC1_CON1, 24, 0, 0, 0,
-	    MFGPLL_SC1_CON1, 0, 22),
+	    MFGPLL_SC1_CON0, 0, 0, PLL_PARENT_EN, BIT(0), MFGPLL_SC1_CON1, 24,
+	    0, 0, 0, MFGPLL_SC1_CON1, 0, 22),
 };
 
 static const struct of_device_id of_match_clk_mt8196_mfg[] = {
diff --git a/drivers/clk/mediatek/clk-pll.c b/drivers/clk/mediatek/clk-pll.c
index cd2b6ce551c6b..de3eb02670554 100644
--- a/drivers/clk/mediatek/clk-pll.c
+++ b/drivers/clk/mediatek/clk-pll.c
@@ -358,6 +358,9 @@ struct clk_hw *mtk_clk_register_pll_ops(struct mtk_clk_pll *pll,
 
 	init.name = data->name;
 	init.flags = (data->flags & PLL_AO) ? CLK_IS_CRITICAL : 0;
+	if (data->flags & PLL_PARENT_EN)
+		init.flags |= CLK_OPS_PARENT_ENABLE;
+
 	init.ops = pll_ops;
 	if (data->parent_name)
 		init.parent_names = &data->parent_name;
diff --git a/drivers/clk/mediatek/clk-pll.h b/drivers/clk/mediatek/clk-pll.h
index d71c150ce83e4..de5a8fb7cbcfe 100644
--- a/drivers/clk/mediatek/clk-pll.h
+++ b/drivers/clk/mediatek/clk-pll.h
@@ -21,6 +21,7 @@ struct mtk_pll_div_table {
 
 #define HAVE_RST_BAR	BIT(0)
 #define PLL_AO		BIT(1)
+#define PLL_PARENT_EN	BIT(2)
 #define POSTDIV_MASK	GENMASK(2, 0)
 
 struct mtk_pll_data {
-- 
2.51.0



