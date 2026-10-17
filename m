Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EAF385D7B;
	Sat, 17 Oct 2026 17:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258015; cv=none; b=K3cuo4UEvmV3o96cXVMgOmc3aX6nvFcEY89Rj+S0opUxn2d8k1qlVCf8q7nxFpMTq94dNtwJyxHyO91xAh0dUcpbt/3V7C6WxN/Cd3pcMLbebG/DKRx1fADZ23+cO/6+Oo5TvIk/Q06Us6cUJcEkuY8egxrKBdLElFTrowCtDY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258015; c=relaxed/simple;
	bh=OF63KRhLMGUUiIgq3l/9+xKKrcQy5sLi2UbVulMjL3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2/wX0qxP39DGh+721+ZTxkS/gheiXQoxb5axZcrNdPL8PUP7eJyqJHiQrcxDQmU+WYHABQlgsI3Ze/FmgmRDlzRa6NhF6XS5zOevHfB0BNFfk3AJbvAmEnvXks+QWTbAVOLMObV/Bk+FMjuSO+YIuGNbfO+T65ls8/XH2Jv1Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EsX9xRiU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EsX9xRiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A68F1F000C4;
	Sat, 17 Oct 2026 17:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258013;
	bh=ybyco5JFCn9mLMcLnqKJWqfH5TQX/9tC0DH2U9uaxqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EsX9xRiUI1NwUwqayUsPMdB7V2B7IdGOY06Kgx0bxORHhrSwHazxF8AD851kS0XEN
	 MKFVuM+2jTAkUKl/GThc/1ULwKc43TvF/Bhqsuc8wldLctsJbPmuc+MkNay21ODhcm
	 nBnX0movPPEYkI+5o1ZmDA2D7WFfR+lyxJZWbyqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Evgeny Boger <boger@wirenboard.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0742/1674] clk: sunxi-ng: h616: Reparent CPU clock during frequency changes
Date: Sat, 17 Oct 2026 17:50:14 +0200
Message-ID: <20261017160450.142576284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 21e918582aa56..e52f94822aff8 100644
--- a/drivers/clk/sunxi-ng/ccu-sun50i-h616.c
+++ b/drivers/clk/sunxi-ng/ccu-sun50i-h616.c
@@ -1090,11 +1090,24 @@ static const u32 usb2_clk_regs[] = {
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
@@ -1147,7 +1160,18 @@ static int sun50i_h616_ccu_probe(struct platform_device *pdev)
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



