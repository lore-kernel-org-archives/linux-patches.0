Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FF231A7FD;
	Wed,  3 Dec 2025 16:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779650; cv=none; b=uuB6JHf8r3gKl2Z7saGYMKJOWTwP4VzteHxHUk2/SB1jmkP8AIDJQKbybras5aNHnY+wm8RuTfbxjbSphVMpq+/0sbAwt8F3nQkCpd9weMeI4ENAFLi7fL8cHFagvL2xP8aL4W1YIHb2j7tVBFxlfBzen0G0RwSvyZAFJgZ1iRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779650; c=relaxed/simple;
	bh=offzKclgq+jdkd9OLzlDBYNJbIpY0k95CSkIV55eGj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCkA8ujww7udvNAsGQ7TC19Bs+/J5IlvEXzYr8/Cu+9mk3qAbAeptGAh1gjngbzlM7gchdpsHzf1QBurf7YAJ2bSTEJ/SYMYiNZ9UjT+EbdNhzMDWXD2v0bUJRL8YZdh2bE64VlSqdAA9SD0+qb+ekR46BhDpSumXKyvQYWqWB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2g4JpW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2g4JpW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A51C4CEF5;
	Wed,  3 Dec 2025 16:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779650;
	bh=offzKclgq+jdkd9OLzlDBYNJbIpY0k95CSkIV55eGj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2g4JpW38qLkK5mO7fb7kTzoJJxbBpWBUphj/dOi9UWEWJcR0nX8LhztJSJ2KzPgn
	 6JaoGmJVxItjGf1vgmj7vTKvF0P98suGvPj340Ln9voiubVH1GbF9uhK0bsDz90hKe
	 I92yadYxFVrISvM7I6uPJXjsxjzpX1+bexx/PIgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>,
	Ryan Wanner <ryan.wanner@microchip.com>
Subject: [PATCH 6.1 287/568] clk: at91: clk-sam9x60-pll: force write to PLL_UPDT register
Date: Wed,  3 Dec 2025 16:24:49 +0100
Message-ID: <20251203152451.215817226@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0882ed01d5c27..a010a8fce58b2 100644
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



