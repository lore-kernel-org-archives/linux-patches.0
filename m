Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E845C34B1B7;
	Fri, 21 Nov 2025 13:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733010; cv=none; b=SxPccrehhfSnrkFuoCyVhvIvwVg7dF7cSJlzfsoK+QOJDhlVjwVtdHGnkwPyKnjTLJe4NeWlt1Iohw3uu2AjhsWlu5EbqdsjEgxZBXn90RoSNG1m5Gn5rN7k/Xdq+xmPIATD2VIaf5Gt7uq7OEjhZBiczVMuOfZImDIpb+QZJHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733010; c=relaxed/simple;
	bh=k4e6He2cvZN/xNoPugWvS6h5WEcpz7k9eDg5byQd7NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DR6emFCXO7020/RrGe1OYHCPrm60+AgEXzOhjrYeBIM4mb68Q3NC9NjNRLNzhAMt/j0LglVL0DLpmln57rDbnPRteGwyAC+6Gv8G1aViWIxDxVCndPC3Cm0CmAgT/XIRNKQNr9ybCSbpdyZP9z8tXJ/kYzBc7xc/SvErdC6t+kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J92yC7Sd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J92yC7Sd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7033EC4CEF1;
	Fri, 21 Nov 2025 13:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733009;
	bh=k4e6He2cvZN/xNoPugWvS6h5WEcpz7k9eDg5byQd7NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J92yC7SdkflotBaJygXUUavg4ZkXN33VGeMro+K3PRVBq/H9dVjd7mond/ilcUK5R
	 X+cy0gCLJ0RI2Upupa6qRvblMUXMK+I/YGQOp44Vqy6jwzfaBhZsCUA9HAVS68oMBy
	 7ro6Ws0Pis2ItZP/8IEaRHTpbS/rcZ8urud21om4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>,
	Ryan Wanner <ryan.wanner@microchip.com>
Subject: [PATCH 6.6 312/529] clk: at91: clk-sam9x60-pll: force write to PLL_UPDT register
Date: Fri, 21 Nov 2025 14:10:11 +0100
Message-ID: <20251121130242.125036970@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Nicolas Ferre <nicolas.ferre@microchip.com>

[ Upstream commit af98caeaa7b6ad11eb7b7c8bfaddc769df2889f3 ]

This register is important for sequencing the commands to PLLs, so
actually write the update bits with regmap_write_bits() instead of
relying on a read/modify/write regmap command that could skip the actual
hardware write if the value is identical to the one read.

It's changed when modification is needed to the PLL, when
read-only operation is done, we could keep the call to
regmap_update_bits().

Add a comment to the sam9x60_div_pll_set_div() function that uses this
PLL_UPDT register so that it's used consistently, according to the
product's datasheet.

Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Tested-by: Ryan Wanner <ryan.wanner@microchip.com> # on sama7d65 and sam9x75
Link: https://lore.kernel.org/r/20250827150811.82496-1-nicolas.ferre@microchip.com
[claudiu.beznea: fix "Alignment should match open parenthesis"
 checkpatch.pl check]
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-sam9x60-pll.c | 75 ++++++++++++++++--------------
 1 file changed, 39 insertions(+), 36 deletions(-)

diff --git a/drivers/clk/at91/clk-sam9x60-pll.c b/drivers/clk/at91/clk-sam9x60-pll.c
index ff65f7b916f07..57d7aef1ea865 100644
--- a/drivers/clk/at91/clk-sam9x60-pll.c
+++ b/drivers/clk/at91/clk-sam9x60-pll.c
@@ -90,8 +90,8 @@ static int sam9x60_frac_pll_set(struct sam9x60_pll_core *core)
 
 	spin_lock_irqsave(core->lock, flags);
 
-	regmap_update_bits(regmap, AT91_PMC_PLL_UPDT,
-			   AT91_PMC_PLL_UPDT_ID_MSK, core->id);
+	regmap_write_bits(regmap, AT91_PMC_PLL_UPDT,
+			  AT91_PMC_PLL_UPDT_ID_MSK, core->id);
 	regmap_read(regmap, AT91_PMC_PLL_CTRL1, &val);
 	cmul = (val & core->layout->mul_mask) >> core->layout->mul_shift;
 	cfrac = (val & core->layout->frac_mask) >> core->layout->frac_shift;
@@ -125,17 +125,17 @@ static int sam9x60_frac_pll_set(struct sam9x60_pll_core *core)
 		udelay(10);
 	}
 
-	regmap_update_bits(regmap, AT91_PMC_PLL_UPDT,
-			   AT91_PMC_PLL_UPDT_UPDATE | AT91_PMC_PLL_UPDT_ID_MSK,
-			   AT91_PMC_PLL_UPDT_UPDATE | core->id);
+	regmap_write_bits(regmap, AT91_PMC_PLL_UPDT,
+			  AT91_PMC_PLL_UPDT_UPDATE | AT91_PMC_PLL_UPDT_ID_MSK,
+			  AT91_PMC_PLL_UPDT_UPDATE | core->id);
 
 	regmap_update_bits(regmap, AT91_PMC_PLL_CTRL0,
 			   AT91_PMC_PLL_CTRL0_ENLOCK | AT91_PMC_PLL_CTRL0_ENPLL,
 			   AT91_PMC_PLL_CTRL0_ENLOCK | AT91_PMC_PLL_CTRL0_ENPLL);
 
-	regmap_update_bits(regmap, AT91_PMC_PLL_UPDT,
-			   AT91_PMC_PLL_UPDT_UPDATE | AT91_PMC_PLL_UPDT_ID_MSK,
-			   AT91_PMC_PLL_UPDT_UPDATE | core->id);
+	regmap_write_bits(regmap, AT91_PMC_PLL_UPDT,
+			  AT91_PMC_PLL_UPDT_UPDATE | AT91_PMC_PLL_UPDT_ID_MSK,
+			  AT91_PMC_PLL_UPDT_UPDATE | core->id);
 
 	while (!sam9x60_pll_ready(regmap, core->id))
 		cpu_relax();
@@ -161,8 +161,8 @@ static void sam9x60_frac_pll_unprepare(struct clk_hw *hw)
 
 	spin_lock_irqsave(core->lock, flags);
 
-	regmap_update_bits(regmap, AT91_PMC_PLL_UPDT,
-			   AT91_PMC_PLL_UPDT_ID_MSK, core->id);
+	regmap_write_bits(regmap, AT91_PMC_PLL_UPDT,
+			  AT91_PMC_PLL_UPDT_ID_MSK, core->id);
 
 	regmap_update_bits(regmap, AT91_PMC_PLL_CTRL0, AT91_PMC_PLL_CTRL0_ENPLL, 0);
 
@@ -170,9 +170,9 @@ static void sam9x60_frac_pll_unprepare(struct clk_hw *hw)
 		regmap_update_bits(regmap, AT91_PMC_PLL_ACR,
 				   AT91_PMC_PLL_ACR_UTMIBG | AT91_PMC_PLL_ACR_UTMIVR, 0);
 
-	regmap_update_bits(regmap, AT91_PMC_PLL_UPDT,
-			   AT91_PMC_PLL_UPDT_UPDATE | AT91_PMC_PLL_UPDT_ID_MSK,
-			   AT91_PMC_PLL_UPDT_UPDATE | core->id);
+	regmap_write_bits(regmap, AT91_PMC_PLL_UPDT,
+			  AT91_PMC_PLL_UPDT_UPDATE | AT91_PMC_PLL_UPDT_ID_MSK,
+			  AT91_PMC_PLL_UPDT_UPDATE | core->id);
 
 	spin_unlock_irqrestore(core->lock, flags);
 }
@@ -257,8 +257,8 @@ static int sam9x60_frac_pll_set_rate_chg(struct clk_hw *hw, unsigned long rate,
 
 	spin_lock_irqsave(core->lock, irqflags);
 
-	regmap_update_bits(regmap, AT91_PMC_PLL_UPDT, AT91_PMC_PLL_UPDT_ID_MSK,
-			   core->id);
+	regmap_write_bits(regmap, AT91_PMC_PLL_UPDT, AT91_PMC_PLL_UPDT_ID_MSK,
+			  core->id);
 	regmap_read(regmap, AT91_PMC_PLL_CTRL1, &val);
 	cmul = (val & core->layout->mul_mask) >> core->layout->mul_shift;
 	cfrac = (val & core->layout->frac_mask) >> core->layout->frac_shift;
@@ -270,18 +270,18 @@ static int sam9x60_frac_pll_set_rate_chg(struct clk_hw *hw, unsigned long rate,
 		     (frac->mul << core->layout->mul_shift) |
 		     (frac->frac << core->layout->frac_shift));
 
-	regmap_update_bits(regmap, AT91_PMC_PLL_UPDT,
-			   AT91_PMC_PLL_UPDT_UPDATE | AT91_PMC_PLL_UPDT_ID_MSK,
-			   AT91_PMC_PLL_UPDT_UPDATE | core->id);
+	regmap_write_bits(regmap, AT91_PMC_PLL_UPDT,
+			  AT91_PMC_PLL_UPDT_UPDATE | AT91_PMC_PLL_UPDT_ID_MSK,
+			  AT91_PMC_PLL_UPDT_UPDATE | core->id);
 
 	regmap_update_bits(regmap, AT91_PMC_PLL_CTRL0,
 			   AT91_PMC_PLL_CTRL0_ENLOCK | AT91_PMC_PLL_CTRL0_ENPLL,
 			   AT91_PMC_PLL_CTRL0_ENLOCK |
 			   AT91_PMC_PLL_CTRL0_ENPLL);
 
-	regmap_update_bits(regmap, AT91_PMC_PLL_UPDT,
-			   AT91_PMC_PLL_UPDT_UPDATE | AT91_PMC_PLL_UPDT_ID_MSK,
-			   AT91_PMC_PLL_UPDT_UPDATE | core->id);
+	regmap_write_bits(regmap, AT91_PMC_PLL_UPDT,
+			  AT91_PMC_PLL_UPDT_UPDATE | AT91_PMC_PLL_UPDT_ID_MSK,
+			  AT91_PMC_PLL_UPDT_UPDATE | core->id);
 
 	while (!sam9x60_pll_ready(regmap, core->id))
 		cpu_relax();
@@ -333,7 +333,10 @@ static const struct clk_ops sam9x60_frac_pll_ops_chg = {
 	.restore_context = sam9x60_frac_pll_restore_context,
 };
 
-/* This function should be called with spinlock acquired. */
+/* This function should be called with spinlock acquired.
+ * Warning: this function must be called only if the same PLL ID was set in
+ *          PLL_UPDT register previously.
+ */
 static void sam9x60_div_pll_set_div(struct sam9x60_pll_core *core, u32 div,
 				    bool enable)
 {
@@ -345,9 +348,9 @@ static void sam9x60_div_pll_set_div(struct sam9x60_pll_core *core, u32 div,
 			   core->layout->div_mask | ena_msk,
 			   (div << core->layout->div_shift) | ena_val);
 
-	regmap_update_bits(regmap, AT91_PMC_PLL_UPDT,
-			   AT91_PMC_PLL_UPDT_UPDATE | AT91_PMC_PLL_UPDT_ID_MSK,
-			   AT91_PMC_PLL_UPDT_UPDATE | core->id);
+	regmap_write_bits(regmap, AT91_PMC_PLL_UPDT,
+			  AT91_PMC_PLL_UPDT_UPDATE | AT91_PMC_PLL_UPDT_ID_MSK,
+			  AT91_PMC_PLL_UPDT_UPDATE | core->id);
 
 	while (!sam9x60_pll_ready(regmap, core->id))
 		cpu_relax();
@@ -361,8 +364,8 @@ static int sam9x60_div_pll_set(struct sam9x60_pll_core *core)
 	unsigned int val, cdiv;
 
 	spin_lock_irqsave(core->lock, flags);
-	regmap_update_bits(regmap, AT91_PMC_PLL_UPDT,
-			   AT91_PMC_PLL_UPDT_ID_MSK, core->id);
+	regmap_write_bits(regmap, AT91_PMC_PLL_UPDT,
+			  AT91_PMC_PLL_UPDT_ID_MSK, core->id);
 	regmap_read(regmap, AT91_PMC_PLL_CTRL0, &val);
 	cdiv = (val & core->layout->div_mask) >> core->layout->div_shift;
 
@@ -393,15 +396,15 @@ static void sam9x60_div_pll_unprepare(struct clk_hw *hw)
 
 	spin_lock_irqsave(core->lock, flags);
 
-	regmap_update_bits(regmap, AT91_PMC_PLL_UPDT,
-			   AT91_PMC_PLL_UPDT_ID_MSK, core->id);
+	regmap_write_bits(regmap, AT91_PMC_PLL_UPDT,
+			  AT91_PMC_PLL_UPDT_ID_MSK, core->id);
 
 	regmap_update_bits(regmap, AT91_PMC_PLL_CTRL0,
 			   core->layout->endiv_mask, 0);
 
-	regmap_update_bits(regmap, AT91_PMC_PLL_UPDT,
-			   AT91_PMC_PLL_UPDT_UPDATE | AT91_PMC_PLL_UPDT_ID_MSK,
-			   AT91_PMC_PLL_UPDT_UPDATE | core->id);
+	regmap_write_bits(regmap, AT91_PMC_PLL_UPDT,
+			  AT91_PMC_PLL_UPDT_UPDATE | AT91_PMC_PLL_UPDT_ID_MSK,
+			  AT91_PMC_PLL_UPDT_UPDATE | core->id);
 
 	spin_unlock_irqrestore(core->lock, flags);
 }
@@ -507,8 +510,8 @@ static int sam9x60_div_pll_set_rate_chg(struct clk_hw *hw, unsigned long rate,
 	div->div = DIV_ROUND_CLOSEST(parent_rate, rate) - 1;
 
 	spin_lock_irqsave(core->lock, irqflags);
-	regmap_update_bits(regmap, AT91_PMC_PLL_UPDT, AT91_PMC_PLL_UPDT_ID_MSK,
-			   core->id);
+	regmap_write_bits(regmap, AT91_PMC_PLL_UPDT, AT91_PMC_PLL_UPDT_ID_MSK,
+			  core->id);
 	regmap_read(regmap, AT91_PMC_PLL_CTRL0, &val);
 	cdiv = (val & core->layout->div_mask) >> core->layout->div_shift;
 
@@ -563,8 +566,8 @@ static int sam9x60_div_pll_notifier_fn(struct notifier_block *notifier,
 	div->div = div->safe_div;
 
 	spin_lock_irqsave(core.lock, irqflags);
-	regmap_update_bits(regmap, AT91_PMC_PLL_UPDT, AT91_PMC_PLL_UPDT_ID_MSK,
-			   core.id);
+	regmap_write_bits(regmap, AT91_PMC_PLL_UPDT, AT91_PMC_PLL_UPDT_ID_MSK,
+			  core.id);
 	regmap_read(regmap, AT91_PMC_PLL_CTRL0, &val);
 	cdiv = (val & core.layout->div_mask) >> core.layout->div_shift;
 
-- 
2.51.0



