Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2353FC0B;
	Wed,  5 Feb 2025 14:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764491; cv=none; b=Ai92YMkASZy7XOU4QP4Ytl2LOCRaTp+h3YvMfWzGvteAbFBiifAhtPJK5Chj9jW/Axg5nXaoVdznHzPJwRTtK7Hh1xJXuWGIoyTsv4HWOFS9rYHyEi9uzC26ohuxoF8wruhn+piodL2bkIx904x1lQOaCLUsAIEu10QJK8R4HQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764491; c=relaxed/simple;
	bh=Pc1ZuYvlXNi7OSlIvHuvlSx0wgKOH3g0RfFLxtj2Ew8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIpUSHn+cE14DslYp3M/h/Ce7ATlxcVLBe0VBMM4J/vEba9+c4ac3h+5hoC78bDZMLBjd+EKNdheIssFl2u3DsCO4ttIQPzZSGuwLkJCMXyO+2H0jeF1xd2kPGORw39gCfWqXZhxkV8/AlRBeu858E61C9sXC93IXTwgQvbrVR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lap2MkXj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lap2MkXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF6FC4CED1;
	Wed,  5 Feb 2025 14:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764491;
	bh=Pc1ZuYvlXNi7OSlIvHuvlSx0wgKOH3g0RfFLxtj2Ew8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lap2MkXjAgwXOBC5+RTYbOQURoDj9wGO9ZKvCBQzZyZ7KZ1puX7Kg7cZEdTSW7Z8v
	 FYirGL6SWVlviRaIPNIEyL4Mz51zTHCXtlEjSJRzWmrml3KptymMahtp+oQB3VnzXl
	 1FjoacVEM+5KuKke7wMtaTXxBluwb0eibX2OREuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Chen-Yu Tsai <wens@csie.org>,
	Vasily Khoruzhick <anarsoul@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Frank Oltmanns <frank@oltmanns.dev>,
	Stuart Gathman <stuart@gathman.org>
Subject: [PATCH 6.12 132/590] clk: sunxi-ng: a64: stop force-selecting PLL-MIPI as TCON0 parent
Date: Wed,  5 Feb 2025 14:38:07 +0100
Message-ID: <20250205134500.316045072@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Khoruzhick <anarsoul@gmail.com>

[ Upstream commit 383ca7bee8a93be9ff5a072936981c2710d2856b ]

Stop force-selecting PLL-MIPI as TCON0 parent, since it breaks video
output on Pinebook that uses RGB to eDP bridge.

Partially revert commit ca1170b69968 ("clk: sunxi-ng: a64: force
select PLL_MIPI in TCON0 mux"), while still leaving
CLK_SET_RATE_NO_REPARENT flag set, since we do not want the clock to
be reparented.

The issue is that apparently different TCON0 outputs require a different
clock, or the mux might be selecting the output type.

I did an experiment: I manually configured PLL_MIPI and PLL_VIDEO0_2X
to the same clock rate and flipped the switch with devmem. Experiment
clearly showed that whenever PLL_MIPI is selected as TCON0 clock parent,
the video output stops working.

Therefore, TCON0 clock parent corresponding to the output type must be
assigned in the device tree.

Fixes: ca1170b69968 ("clk: sunxi-ng: a64: force select PLL_MIPI in TCON0 mux")
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Tested-by: Frank Oltmanns <frank@oltmanns.dev> # on PinePhone
Tested-by: Stuart Gathman <stuart@gathman.org> # on OG Pinebook
Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Link: https://patch.msgid.link/20250104074035.1611136-5-anarsoul@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun50i-a64.c b/drivers/clk/sunxi-ng/ccu-sun50i-a64.c
index c255dba2c96db..6727a3e30a129 100644
--- a/drivers/clk/sunxi-ng/ccu-sun50i-a64.c
+++ b/drivers/clk/sunxi-ng/ccu-sun50i-a64.c
@@ -535,11 +535,11 @@ static SUNXI_CCU_M_WITH_MUX_GATE(de_clk, "de", de_parents,
 				 CLK_SET_RATE_PARENT);
 
 /*
- * DSI output seems to work only when PLL_MIPI selected. Set it and prevent
- * the mux from reparenting.
+ * Experiments showed that RGB output requires pll-video0-2x, while DSI
+ * requires pll-mipi. It will not work with incorrect clock, the screen will
+ * be blank.
+ * sun50i-a64.dtsi assigns pll-mipi as TCON0 parent by default
  */
-#define SUN50I_A64_TCON0_CLK_REG	0x118
-
 static const char * const tcon0_parents[] = { "pll-mipi", "pll-video0-2x" };
 static const u8 tcon0_table[] = { 0, 2, };
 static SUNXI_CCU_MUX_TABLE_WITH_GATE_CLOSEST(tcon0_clk, "tcon0", tcon0_parents,
@@ -959,11 +959,6 @@ static int sun50i_a64_ccu_probe(struct platform_device *pdev)
 
 	writel(0x515, reg + SUN50I_A64_PLL_MIPI_REG);
 
-	/* Set PLL MIPI as parent for TCON0 */
-	val = readl(reg + SUN50I_A64_TCON0_CLK_REG);
-	val &= ~GENMASK(26, 24);
-	writel(val | (0 << 24), reg + SUN50I_A64_TCON0_CLK_REG);
-
 	ret = devm_sunxi_ccu_probe(&pdev->dev, reg, &sun50i_a64_ccu_desc);
 	if (ret)
 		return ret;
-- 
2.39.5



