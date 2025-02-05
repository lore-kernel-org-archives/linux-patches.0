Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD0714F9FD;
	Wed,  5 Feb 2025 13:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763640; cv=none; b=ffO3QkIJNbcFz35ULIfzd0AIXr8EpQe6zhfQlpqj0j/xDTPpXLnoGD1DODoztUOBvGgtoCOMl2AHIDC31LlS7kPWpX96m6zJhjECz9FIwLUP/p9Mvcit2R4/a/+NF6Gw0PiH0Rn1VTWXH12z9dDtmEbfXFnq1sfI+a96eghWDBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763640; c=relaxed/simple;
	bh=MS5PohMXpk5gN+YXnC+fyTl3ckRN+1BYAEl2WR8FqYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5y16v0QEFdwDiNSRtTWUBzAxQuyZRQhK4kM2S7SrZa5IPK0LtMhfLaVt3TmmbeRIH000ZxyI577ZIR1L0VSzWpmofYQzfv5SJviISlpfXGpngBohYm4RF+jLYiHQ6a66/anMoogdI5ldEXcn4YT8x8nLxMwy6QkYz0vhGtTLqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBZoDFGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBZoDFGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1B9C4CED1;
	Wed,  5 Feb 2025 13:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763639;
	bh=MS5PohMXpk5gN+YXnC+fyTl3ckRN+1BYAEl2WR8FqYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBZoDFGYx0dBW5hNGoNGf1gWLG6QsIf7vox/V+l33aGuuhKDBRueKnXkUSWxmvIvw
	 2kjXdrZTo222gWjUc4eSHyOsRtp9UfGVSKNiNb3tgazzMqdtCfr7005HsW1Ife/tf5
	 VERDXAtwVyi04kvhGh8SzaRG6f+PmH2wNp93ZbsU=
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
Subject: [PATCH 6.6 092/393] clk: sunxi-ng: a64: stop force-selecting PLL-MIPI as TCON0 parent
Date: Wed,  5 Feb 2025 14:40:11 +0100
Message-ID: <20250205134423.814832556@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6a4b2b9ef30a8..aee1a2f14c951 100644
--- a/drivers/clk/sunxi-ng/ccu-sun50i-a64.c
+++ b/drivers/clk/sunxi-ng/ccu-sun50i-a64.c
@@ -533,11 +533,11 @@ static SUNXI_CCU_M_WITH_MUX_GATE(de_clk, "de", de_parents,
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
@@ -957,11 +957,6 @@ static int sun50i_a64_ccu_probe(struct platform_device *pdev)
 
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



