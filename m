Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EDB2E8E11;
	Sun, 26 Oct 2025 14:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490267; cv=none; b=CpIVrNw1aoF9anNLWv9TGWQMuRwnv2koDRdLZJ26//Xt2JJtCFtzctC2DoAV6vfOOOaS5LgsveMc33I2MBgu0fqhMB0mstmsCDQQSZ0Gn4Rd6BrOTSwmExrbHIC3UXMZEtqeKnfrbeS3sbwfuHPquUsFdlDWhXlb7oxPoNjbYzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490267; c=relaxed/simple;
	bh=2Zk0BrTQrIpGuIeefScq3Jbl10WMyfDwjyfD4QAcohw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i/0xIbK+sq5mRUqC/mEr3l3EC4iryKLiE2ESHwQEL/DnlAOr5nc4OBy6reQ4JN7AsnKHqXiBKqG/VXi/QPeNIGIhp2a+zSR9PFwt8yIdSIGRNvVlWsfBJS21FO6VhCdJNGjlz+8CzzAPc2sRfiu5tqRv8b1lbXEYuwblmpt9ahU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ugAn5cXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ugAn5cXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D37BC4CEF1;
	Sun, 26 Oct 2025 14:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490267;
	bh=2Zk0BrTQrIpGuIeefScq3Jbl10WMyfDwjyfD4QAcohw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugAn5cXW7N6RjkEyB6SrOxAF1o5jFsnte5rEtZpGXOobVH2xXiTcbinOYmzvP2+8Y
	 p/9ecx3Ink8eX+T3s+ksK1BSDmIEMY5AJ+VFme66kLlLl2REFGnQLzGrwe0idYUW8B
	 mZYcgYaB0byucM1PCjStKUqQvwIMOGPkgK1DRxgKSqaqWSrcSjivbpBL7P2kEA8VtU
	 P9YB32FFkWMr0x3/9SPIeeOSWrEdA2t5i7VMMMiRXfffF+753TU8MOq67Ob7eQlO+x
	 BPsnpkpNUFgIwStsEx2MzVvqAs9BRTlZIm7p35v5jDHiOaM8SkYcFy8OO/TIfFutoU
	 7t00Iaro6KiAg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>,
	Ryan Wanner <ryan.wanner@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.belloni@bootlin.com,
	alexandre.f.demers@gmail.com,
	cristian.birsan@microchip.com,
	andrei.simion@microchip.com,
	bmasney@redhat.com,
	Ryan.Wanner@microchip.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.1] clk: at91: clk-sam9x60-pll: force write to PLL_UPDT register
Date: Sun, 26 Oct 2025 10:49:10 -0400
Message-ID: <20251026144958.26750-32-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES
- `regmap_update_bits()` skips the hardware write when the target value
  matches the current value, so repeated programming of the PLL update
  register could silently do nothing. The replacement with
  `regmap_write_bits()`—which forces the transaction by passing
  `force=true` down to `_regmap_update_bits()` (see
  `include/linux/regmap.h:1340` and
  `drivers/base/regmap/regmap.c:3247`)—guarantees every update command
  actually reaches the PMC.
- The fix touches every path that modifies PLL state: the PLL enable
  sequence now forces the ID latch and both update pulses in
  `sam9x60_frac_pll_set()` (`drivers/clk/at91/clk-sam9x60-pll.c:96`,
  `:128`, `:136`), and the disable path does the same (`:164-175`).
  Without these forced writes, the “apply changes” strobes could be
  dropped, leaving MUL/FRAC reprogramming or ENPLL clears
  unapplied—manifesting as PLLs that refuse to retune or power down.
- Divider programming follows the same requirement:
  `sam9x60_div_pll_set()`, `_unprepare()`, `_set_rate_chg()`, and the
  notifier all now force the ID and UPDATE pulse (`drivers/clk/at91/clk-
  sam9x60-pll.c:365-413`, `:528-599`). This prevents cases where DVFS
  notifier transitions or runtime rate changes fail because the write
  was skipped, which can lead to over-clocking or clocks stuck at stale
  divisors.
- Read-only users are intentionally left on `regmap_update_bits()` (e.g.
  `sam9x60_div_pll_is_prepared()` at `drivers/clk/at91/clk-
  sam9x60-pll.c:427-434`), and the new comment at `:343-348` documents
  the datasheet requirement that the correct PLL ID already be latched
  before issuing the forced update. That keeps behaviour consistent and
  avoids accidental misuse.
- The change is localized to the AT91 SAM9x60 PLL driver, introduces no
  new APIs, and simply guarantees the hardware sequencing works as
  documented; it has been validated on Sama7D65/Sam9x75 hardware per the
  Tested-by tag. The bug being fixed—lost update strobes leading to PLLs
  that won’t reliably enable/disable—is severe for users, while the
  regression risk from issuing guaranteed writes is minimal.

 drivers/clk/at91/clk-sam9x60-pll.c | 75 ++++++++++++++++--------------
 1 file changed, 39 insertions(+), 36 deletions(-)

diff --git a/drivers/clk/at91/clk-sam9x60-pll.c b/drivers/clk/at91/clk-sam9x60-pll.c
index cefd9948e1039..a035dc15454b0 100644
--- a/drivers/clk/at91/clk-sam9x60-pll.c
+++ b/drivers/clk/at91/clk-sam9x60-pll.c
@@ -93,8 +93,8 @@ static int sam9x60_frac_pll_set(struct sam9x60_pll_core *core)
 
 	spin_lock_irqsave(core->lock, flags);
 
-	regmap_update_bits(regmap, AT91_PMC_PLL_UPDT,
-			   AT91_PMC_PLL_UPDT_ID_MSK, core->id);
+	regmap_write_bits(regmap, AT91_PMC_PLL_UPDT,
+			  AT91_PMC_PLL_UPDT_ID_MSK, core->id);
 	regmap_read(regmap, AT91_PMC_PLL_CTRL1, &val);
 	cmul = (val & core->layout->mul_mask) >> core->layout->mul_shift;
 	cfrac = (val & core->layout->frac_mask) >> core->layout->frac_shift;
@@ -128,17 +128,17 @@ static int sam9x60_frac_pll_set(struct sam9x60_pll_core *core)
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
@@ -164,8 +164,8 @@ static void sam9x60_frac_pll_unprepare(struct clk_hw *hw)
 
 	spin_lock_irqsave(core->lock, flags);
 
-	regmap_update_bits(regmap, AT91_PMC_PLL_UPDT,
-			   AT91_PMC_PLL_UPDT_ID_MSK, core->id);
+	regmap_write_bits(regmap, AT91_PMC_PLL_UPDT,
+			  AT91_PMC_PLL_UPDT_ID_MSK, core->id);
 
 	regmap_update_bits(regmap, AT91_PMC_PLL_CTRL0, AT91_PMC_PLL_CTRL0_ENPLL, 0);
 
@@ -173,9 +173,9 @@ static void sam9x60_frac_pll_unprepare(struct clk_hw *hw)
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
@@ -262,8 +262,8 @@ static int sam9x60_frac_pll_set_rate_chg(struct clk_hw *hw, unsigned long rate,
 
 	spin_lock_irqsave(core->lock, irqflags);
 
-	regmap_update_bits(regmap, AT91_PMC_PLL_UPDT, AT91_PMC_PLL_UPDT_ID_MSK,
-			   core->id);
+	regmap_write_bits(regmap, AT91_PMC_PLL_UPDT, AT91_PMC_PLL_UPDT_ID_MSK,
+			  core->id);
 	regmap_read(regmap, AT91_PMC_PLL_CTRL1, &val);
 	cmul = (val & core->layout->mul_mask) >> core->layout->mul_shift;
 	cfrac = (val & core->layout->frac_mask) >> core->layout->frac_shift;
@@ -275,18 +275,18 @@ static int sam9x60_frac_pll_set_rate_chg(struct clk_hw *hw, unsigned long rate,
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
@@ -338,7 +338,10 @@ static const struct clk_ops sam9x60_frac_pll_ops_chg = {
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
@@ -350,9 +353,9 @@ static void sam9x60_div_pll_set_div(struct sam9x60_pll_core *core, u32 div,
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
@@ -366,8 +369,8 @@ static int sam9x60_div_pll_set(struct sam9x60_pll_core *core)
 	unsigned int val, cdiv;
 
 	spin_lock_irqsave(core->lock, flags);
-	regmap_update_bits(regmap, AT91_PMC_PLL_UPDT,
-			   AT91_PMC_PLL_UPDT_ID_MSK, core->id);
+	regmap_write_bits(regmap, AT91_PMC_PLL_UPDT,
+			  AT91_PMC_PLL_UPDT_ID_MSK, core->id);
 	regmap_read(regmap, AT91_PMC_PLL_CTRL0, &val);
 	cdiv = (val & core->layout->div_mask) >> core->layout->div_shift;
 
@@ -398,15 +401,15 @@ static void sam9x60_div_pll_unprepare(struct clk_hw *hw)
 
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
@@ -518,8 +521,8 @@ static int sam9x60_div_pll_set_rate_chg(struct clk_hw *hw, unsigned long rate,
 	div->div = DIV_ROUND_CLOSEST(parent_rate, rate) - 1;
 
 	spin_lock_irqsave(core->lock, irqflags);
-	regmap_update_bits(regmap, AT91_PMC_PLL_UPDT, AT91_PMC_PLL_UPDT_ID_MSK,
-			   core->id);
+	regmap_write_bits(regmap, AT91_PMC_PLL_UPDT, AT91_PMC_PLL_UPDT_ID_MSK,
+			  core->id);
 	regmap_read(regmap, AT91_PMC_PLL_CTRL0, &val);
 	cdiv = (val & core->layout->div_mask) >> core->layout->div_shift;
 
@@ -574,8 +577,8 @@ static int sam9x60_div_pll_notifier_fn(struct notifier_block *notifier,
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

