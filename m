Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237292E8DEB;
	Sat, 17 Oct 2026 16:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253424; cv=none; b=aUnfKYqjYo+rAjsiTosuA2MbmAiilpPjNheLGCEUJQvRwF6ObFZn275HVA/aXqDbbmPlqZZGObIPxDDyj2R1QvWKRnFDFxUUD9ZxEAjIMAeMgxJduXqxl+O8mIKl76RVjzd8zMDWhl0QF8rDgUfRs9L+6MqhXVU2uA9M5aVj9zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253424; c=relaxed/simple;
	bh=s5xEzg+OoH0t3gTW8EgvbTZCvPEnjwrA0H7dTdJIeGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQaiu4WSSwn/DQhltNH9w4u8A1c3S7NbG1wNnm7xcFAIFWipheco7IPB8GplSAtOzzDiJe2a89IofUYYNqWQ8ug7dbWAkR4SZcq/pOjS5p4EtjsjjV4PBZCCTZt0xF7c2n6rwlKtzIIxf11aC9kR1Zp+QsV13MyzKHCEZywTfo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRPDZyTP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRPDZyTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E92F1F000C4;
	Sat, 17 Oct 2026 16:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253423;
	bh=ovygKlaQVU6nOM6smhJL02QodRGq/Q1r4mbOCKc3hpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bRPDZyTP8ocxJLbsI5v8mDz8TdgP8bdNPWfYa1FjIgCFpW4caq9Qa5zWRrgDxKE4P
	 dQGfoONjy3F+sBCEHEVGtUSMSKMJT3hzuIFQ/M0/ldoQgtDXCJ0Kbb1rW9aPeme2xs
	 fYWoHoyKrB3zqLCLHY9dqveelbZnIkVxos3IjSgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philippe Simons <simons.philippe@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/869] clk: sunxi-ng: h616: Reparent GPU clock during frequency changes
Date: Sat, 17 Oct 2026 17:48:32 +0200
Message-ID: <20261017160038.845914023@linuxfoundation.org>
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

From: Philippe Simons <simons.philippe@gmail.com>

[ Upstream commit eb963d7948ce6571939c6875424b557b25f16610 ]

The H616 manual does not state that the GPU PLL supports
dynamic frequency configuration, so we must take extra care when changing
the frequency. Currently any attempt to do device DVFS on the GPU lead
to panfrost various ooops, and GPU hangs.

The manual describes the algorithm for changing the PLL
frequency, which the CPU PLL notifier code already support, so we reuse
that to reparent the GPU clock to GPU1 clock during frequency
changes.

Signed-off-by: Philippe Simons <simons.philippe@gmail.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20250220113808.1122414-2-simons.philippe@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun50i-h616.c | 36 +++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun50i-h616.c b/drivers/clk/sunxi-ng/ccu-sun50i-h616.c
index 85eea196f25e3..d4e3838ed90ba 100644
--- a/drivers/clk/sunxi-ng/ccu-sun50i-h616.c
+++ b/drivers/clk/sunxi-ng/ccu-sun50i-h616.c
@@ -318,10 +318,16 @@ static SUNXI_CCU_M_WITH_MUX_GATE(gpu0_clk, "gpu0", gpu0_parents, 0x670,
 				       24, 1,	/* mux */
 				       BIT(31),	/* gate */
 				       CLK_SET_RATE_PARENT);
+
+/*
+ * This clk is needed as a temporary fall back during GPU PLL freq changes.
+ * Set CLK_IS_CRITICAL flag to prevent from being disabled.
+ */
+#define SUN50I_H616_GPU_CLK1_REG        0x674
 static SUNXI_CCU_M_WITH_GATE(gpu1_clk, "gpu1", "pll-periph0-2x", 0x674,
 					0, 2,	/* M */
 					BIT(31),/* gate */
-					0);
+					CLK_IS_CRITICAL);
 
 static SUNXI_CCU_GATE(bus_gpu_clk, "bus-gpu", "psi-ahb1-ahb2",
 		      0x67c, BIT(0), 0);
@@ -1108,6 +1114,19 @@ static struct ccu_pll_nb sun50i_h616_pll_cpu_nb = {
 	.lock		= BIT(28),
 };
 
+static struct ccu_mux_nb sun50i_h616_gpu_nb = {
+	.common		= &gpu0_clk.common,
+	.cm		= &gpu0_clk.mux,
+	.delay_us	= 1, /* manual doesn't really say */
+	.bypass_index	= 1, /* GPU_CLK1@400MHz */
+};
+
+static struct ccu_pll_nb sun50i_h616_pll_gpu_nb = {
+	.common		= &pll_gpu_clk.common,
+	.enable		= BIT(29),	/* LOCK_ENABLE */
+	.lock		= BIT(28),
+};
+
 static int sun50i_h616_ccu_probe(struct platform_device *pdev)
 {
 	void __iomem *reg;
@@ -1156,6 +1175,14 @@ static int sun50i_h616_ccu_probe(struct platform_device *pdev)
 	val &= ~(GENMASK(21, 16) | BIT(0));
 	writel(val | (11 << 16) | BIT(0), reg + SUN50I_H616_PLL_AUDIO_REG);
 
+	/*
+	 * Set the input-divider for the gpu1 clock to 3, to reach a safe 400 MHz.
+	 */
+	val = readl(reg + SUN50I_H616_GPU_CLK1_REG);
+	val &= ~GENMASK(1, 0);
+	val |= 2;
+	writel(val, reg + SUN50I_H616_GPU_CLK1_REG);
+
 	/*
 	 * First clock parent (osc32K) is unusable for CEC. But since there
 	 * is no good way to force parent switch (both run with same frequency),
@@ -1176,6 +1203,13 @@ static int sun50i_h616_ccu_probe(struct platform_device *pdev)
 	/* Re-lock the CPU PLL after any rate changes */
 	ccu_pll_notifier_register(&sun50i_h616_pll_cpu_nb);
 
+	/* Reparent GPU during GPU PLL rate changes */
+	ccu_mux_notifier_register(pll_gpu_clk.common.hw.clk,
+				  &sun50i_h616_gpu_nb);
+
+	/* Re-lock the GPU PLL after any rate changes */
+	ccu_pll_notifier_register(&sun50i_h616_pll_gpu_nb);
+
 	return 0;
 }
 
-- 
2.53.0



