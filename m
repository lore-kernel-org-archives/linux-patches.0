Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3711D0BBE;
	Wed,  2 Oct 2024 14:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879855; cv=none; b=D7CLTdqX9OvrJLREpBcb4uc0lc2XGw2VD5fb5JXecj3QROWmyxNbbYwbm+fTbbEF8TijfVHdzyPrhTh8vPeMznzGeE29TcLJf19xmvYf4c78WDOo7YcfWBJ1YxJ63HfjM6PNDm29BQpsVfW2FnJBflo2lMi46jk7IOAR3yAvyyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879855; c=relaxed/simple;
	bh=iy/n/YRn9F8PAM0Hhlc3Ze7UYJ5gPzAiwWbdX7b29H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y03//e606GqUnG0Y5TuiilCGEAD15aPD0Jg2ZGLB3QKP6g69lVtUAXmpusPlTifuj/qPZoADDyR9FWOKaCaF1Df/EzozM8+0yNkDf59bx8tzlAUGzN/NK9uW9Y3DquLqpTMr2YRwUMxY7rE+pMSnuPuOp0oDA1TjhPSvHy1qXgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5Si31l1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5Si31l1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A52C4CEC2;
	Wed,  2 Oct 2024 14:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879854;
	bh=iy/n/YRn9F8PAM0Hhlc3Ze7UYJ5gPzAiwWbdX7b29H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5Si31l1nxqsRy3rOcsPtxlDzt19xE2ZHiKVDdxwMbNsuOeHv4HYQCpqSoAj1fZ4y
	 eFq559TjPykwttUHVQVYm68iab8C1+fBtMz4tRGTcPP2Y6g5jISu2UVrVEPiVK5BKe
	 uVt44Sp3/LtNIF0uEptRQ5MW5gJGnCvWudGoI9wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Li <ye.li@nxp.com>,
	Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 260/538] clk: imx: composite-8m: Enable gate clk with mcore_booted
Date: Wed,  2 Oct 2024 14:58:19 +0200
Message-ID: <20241002125802.520368846@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 8f32e9dd0916eb3fd4bcf550ed1d04542a65cb9e ]

Bootloader might disable some CCM ROOT Slices. So if mcore_booted set with
display CCM ROOT disabled by Bootloader, kernel display BLK CTRL driver
imx8m_blk_ctrl_driver_init may hang the system because the BUS clk is
disabled.

Add back gate ops, but with disable doing nothing, then the CCM ROOT
will be enabled when used.

Fixes: bb7e897b002a ("clk: imx8m: check mcore_booted before register clk")
Reviewed-by: Ye Li <ye.li@nxp.com>
Reviewed-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20240607133347.3291040-2-peng.fan@oss.nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-composite-8m.c | 53 +++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 11 deletions(-)

diff --git a/drivers/clk/imx/clk-composite-8m.c b/drivers/clk/imx/clk-composite-8m.c
index eb5392f7a2574..ac5e9d60acb83 100644
--- a/drivers/clk/imx/clk-composite-8m.c
+++ b/drivers/clk/imx/clk-composite-8m.c
@@ -204,6 +204,34 @@ static const struct clk_ops imx8m_clk_composite_mux_ops = {
 	.determine_rate = imx8m_clk_composite_mux_determine_rate,
 };
 
+static int imx8m_clk_composite_gate_enable(struct clk_hw *hw)
+{
+	struct clk_gate *gate = to_clk_gate(hw);
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(gate->lock, flags);
+
+	val = readl(gate->reg);
+	val |= BIT(gate->bit_idx);
+	writel(val, gate->reg);
+
+	spin_unlock_irqrestore(gate->lock, flags);
+
+	return 0;
+}
+
+static void imx8m_clk_composite_gate_disable(struct clk_hw *hw)
+{
+	/* composite clk requires the disable hook */
+}
+
+static const struct clk_ops imx8m_clk_composite_gate_ops = {
+	.enable = imx8m_clk_composite_gate_enable,
+	.disable = imx8m_clk_composite_gate_disable,
+	.is_enabled = clk_gate_is_enabled,
+};
+
 struct clk_hw *__imx8m_clk_hw_composite(const char *name,
 					const char * const *parent_names,
 					int num_parents, void __iomem *reg,
@@ -217,6 +245,7 @@ struct clk_hw *__imx8m_clk_hw_composite(const char *name,
 	struct clk_mux *mux = NULL;
 	const struct clk_ops *divider_ops;
 	const struct clk_ops *mux_ops;
+	const struct clk_ops *gate_ops;
 
 	mux = kzalloc(sizeof(*mux), GFP_KERNEL);
 	if (!mux)
@@ -257,20 +286,22 @@ struct clk_hw *__imx8m_clk_hw_composite(const char *name,
 	div->flags = CLK_DIVIDER_ROUND_CLOSEST;
 
 	/* skip registering the gate ops if M4 is enabled */
-	if (!mcore_booted) {
-		gate = kzalloc(sizeof(*gate), GFP_KERNEL);
-		if (!gate)
-			goto free_div;
-
-		gate_hw = &gate->hw;
-		gate->reg = reg;
-		gate->bit_idx = PCG_CGC_SHIFT;
-		gate->lock = &imx_ccm_lock;
-	}
+	gate = kzalloc(sizeof(*gate), GFP_KERNEL);
+	if (!gate)
+		goto free_div;
+
+	gate_hw = &gate->hw;
+	gate->reg = reg;
+	gate->bit_idx = PCG_CGC_SHIFT;
+	gate->lock = &imx_ccm_lock;
+	if (!mcore_booted)
+		gate_ops = &clk_gate_ops;
+	else
+		gate_ops = &imx8m_clk_composite_gate_ops;
 
 	hw = clk_hw_register_composite(NULL, name, parent_names, num_parents,
 			mux_hw, mux_ops, div_hw,
-			divider_ops, gate_hw, &clk_gate_ops, flags);
+			divider_ops, gate_hw, gate_ops, flags);
 	if (IS_ERR(hw))
 		goto free_gate;
 
-- 
2.43.0



