Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD03C17BED0;
	Sat, 17 Oct 2026 16:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253421; cv=none; b=IyrUs0uH4f7yoz3NN0xCNU9ar40V75R6r/5T6TG7cPgrusL4nkhTWTyVAzQVxazcyoD1mX9foLsIZLhrTDH7ZaX1u1+xFrob5roZLeXN1kyh/Yhvuc6unIfkQAflUyexpLsuEmZ/sXuK0dYSaPKMev0nVQnwRHTE7WS//hBIA9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253421; c=relaxed/simple;
	bh=obSfqBlvXYwzrIZuvLFanPI0ai5/dU5WtfwbmKX7bPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/IdkOhTQOCd1mr1SM3xwlErTgeP5nRk9iTwm01ELXmBj/ccwGb5Omykl0dehw0NJhk3U8dFkv+csowmsu+0L3SKyIR00izkevBfvDX+Igf1noYfM1H1zyC6rhEMQSzp97ZKR+vAGLf8DCU9Msx85rxjBaXH6L/PNzwy1QwvOu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+mI7RA/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+mI7RA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E686F1F000C4;
	Sat, 17 Oct 2026 16:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253419;
	bh=r96DEFzMcrccLms3h3KdG/gy77Gw7sgRspWzOPuIOu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S+mI7RA/iEl/FiuI0a7jHpyoYrPGxFT+StBcAeYSbDKRQCmciBpb5uaDVXW7TuMpl
	 4ZyzMbBvckwvwt923MXTfceMGxxhG33e2pX88J4DAaGOLOPoDw0Qggdhdb17P9gQ8J
	 dTX52cxdsHXlB0Lz8YJqmMnHESl4FPQ2kdh7HM7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Evgeny Boger <boger@wirenboard.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/869] clk: sunxi-ng: h616: Reparent CPU clock during frequency changes
Date: Sat, 17 Oct 2026 17:48:31 +0200
Message-ID: <20261017160038.819706592@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 087b4083d3f9d202266debc6b684b0662c96f51b ]

The H616 user manual recommends to re-parent the CPU clock during
frequency changes of the PLL, and recommends PLL_PERI0(1X), which runs
at 600 MHz. Also it asks to disable and then re-enable the PLL lock bit,
after the factor changes have been applied.

Add clock notifiers for the PLL and the CPU mux clock, using the existing
notifier callbacks, and tell them to use mux 4 (the PLL_PERI0(1X) source),
and bit 29 (the LOCK_ENABLE) bit. The existing code already follows the
correct algorithms.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Link: https://lore.kernel.org/r/20241025105620.1891596-1-andre.przywara@arm.com
Tested-by: Evgeny Boger <boger@wirenboard.com>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: eb963d7948ce ("clk: sunxi-ng: h616: Reparent GPU clock during frequency changes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun50i-h616.c | 28 ++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun50i-h616.c b/drivers/clk/sunxi-ng/ccu-sun50i-h616.c
index 84e406ddf9d12..85eea196f25e3 100644
--- a/drivers/clk/sunxi-ng/ccu-sun50i-h616.c
+++ b/drivers/clk/sunxi-ng/ccu-sun50i-h616.c
@@ -1095,11 +1095,24 @@ static const u32 usb2_clk_regs[] = {
 	SUN50I_H616_USB3_CLK_REG,
 };
 
+static struct ccu_mux_nb sun50i_h616_cpu_nb = {
+	.common		= &cpux_clk.common,
+	.cm		= &cpux_clk.mux,
+	.delay_us	= 1, /* manual doesn't really say */
+	.bypass_index	= 4, /* PLL_PERI0@600MHz, as recommended by manual */
+};
+
+static struct ccu_pll_nb sun50i_h616_pll_cpu_nb = {
+	.common		= &pll_cpux_clk.common,
+	.enable		= BIT(29),	/* LOCK_ENABLE */
+	.lock		= BIT(28),
+};
+
 static int sun50i_h616_ccu_probe(struct platform_device *pdev)
 {
 	void __iomem *reg;
 	u32 val;
-	int i;
+	int ret, i;
 
 	reg = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(reg))
@@ -1152,7 +1165,18 @@ static int sun50i_h616_ccu_probe(struct platform_device *pdev)
 	val |= BIT(24);
 	writel(val, reg + SUN50I_H616_HDMI_CEC_CLK_REG);
 
-	return devm_sunxi_ccu_probe(&pdev->dev, reg, &sun50i_h616_ccu_desc);
+	ret = devm_sunxi_ccu_probe(&pdev->dev, reg, &sun50i_h616_ccu_desc);
+	if (ret)
+		return ret;
+
+	/* Reparent CPU during CPU PLL rate changes */
+	ccu_mux_notifier_register(pll_cpux_clk.common.hw.clk,
+				  &sun50i_h616_cpu_nb);
+
+	/* Re-lock the CPU PLL after any rate changes */
+	ccu_pll_notifier_register(&sun50i_h616_pll_cpu_nb);
+
+	return 0;
 }
 
 static const struct of_device_id sun50i_h616_ccu_ids[] = {
-- 
2.53.0



