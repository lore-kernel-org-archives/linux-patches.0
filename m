Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6C83AC1E
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64628C433C7;
	Wed, 20 Sep 2023 12:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213091;
	bh=0i1zai7EkZlEDorUDBkBivFwUUWq8mjjmrz0N+dnBZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+tggrfVA1tZawcmG+uDyT3LL2O50FsOY9RVKShB1xXyJfQ75A7zuC9wTwvoste4e
	 ygQ47qM2ycMe39d83erUqIqwwbYkFYhTf1FuNWSKEGax+CrTZEoZDTSgPwRJrXLf9N
	 rNgS4/pROKvaekM78be9BfF1KS8nhWaL5G/T4WH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 132/367] clk: imx: composite-8m: fix clock pauses when set_rate would be a no-op
Date: Wed, 20 Sep 2023 13:28:29 +0200
Message-ID: <20230920112902.110116314@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit 4dd432d985ef258e3bc436e568fba4b987b59171 ]

Reconfiguring the clock divider to the exact same value is observed
on an i.MX8MN to often cause a longer than usual clock pause, probably
because the divider restarts counting whenever the register is rewritten.

This issue doesn't show up normally, because the clock framework will
take care to not call set_rate when the clock rate is the same.
However, when we reconfigure an upstream clock, the common code will
call set_rate with the newly calculated rate on all children, e.g.:

  - sai5 is running normally and divides Audio PLL out by 16.
  - Audio PLL rate is increased by 32Hz (glitch-free kdiv change)
  - rates for children are recalculated and rates are set recursively
  - imx8m_clk_composite_divider_set_rate(sai5) is called with
    32/16 = 2Hz more
  - imx8m_clk_composite_divider_set_rate computes same divider as before
  - divider register is written, so it restarts counting from zero and
    MCLK is briefly paused, so instead of e.g. 40ns, MCLK is low for 120ns.

Some external clock consumers can be upset by such unexpected clock pauses,
so let's make sure we only rewrite the divider value when the value to be
written is actually different.

Fixes: d3ff9728134e ("clk: imx: Add imx composite clock")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20230807082201.2332746-1-a.fatoum@pengutronix.de
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-composite-8m.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/imx/clk-composite-8m.c b/drivers/clk/imx/clk-composite-8m.c
index d3486ee79ab54..78122188ac39e 100644
--- a/drivers/clk/imx/clk-composite-8m.c
+++ b/drivers/clk/imx/clk-composite-8m.c
@@ -95,7 +95,7 @@ static int imx8m_clk_composite_divider_set_rate(struct clk_hw *hw,
 	int prediv_value;
 	int div_value;
 	int ret;
-	u32 val;
+	u32 orig, val;
 
 	ret = imx8m_clk_composite_compute_dividers(rate, parent_rate,
 						&prediv_value, &div_value);
@@ -104,13 +104,15 @@ static int imx8m_clk_composite_divider_set_rate(struct clk_hw *hw,
 
 	spin_lock_irqsave(divider->lock, flags);
 
-	val = readl(divider->reg);
-	val &= ~((clk_div_mask(divider->width) << divider->shift) |
-			(clk_div_mask(PCG_DIV_WIDTH) << PCG_DIV_SHIFT));
+	orig = readl(divider->reg);
+	val = orig & ~((clk_div_mask(divider->width) << divider->shift) |
+		       (clk_div_mask(PCG_DIV_WIDTH) << PCG_DIV_SHIFT));
 
 	val |= (u32)(prediv_value  - 1) << divider->shift;
 	val |= (u32)(div_value - 1) << PCG_DIV_SHIFT;
-	writel(val, divider->reg);
+
+	if (val != orig)
+		writel(val, divider->reg);
 
 	spin_unlock_irqrestore(divider->lock, flags);
 
-- 
2.40.1



