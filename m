Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C911F8910;
	Tue,  3 Dec 2024 15:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238877; cv=none; b=ZiT1VIAe5b8CR8pOyZgc6dzbAOezEpaiqoiZREpEWj8csJUv0Ev65JEx0MlPXXbSdus9gtiTxg0+a5YAxAWbsp018Y3T++jFuEW96SbR8Qkb5zbFDRZuWumyYJkjJOpbyGYpTK2GKU4dsfWKsHlR/pQMTnW9mgRTvhR40XN2JXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238877; c=relaxed/simple;
	bh=voc/BlpgnlR4e55WTbtxKhfFbv6u/S/0AaVUTc0JvE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPjDuf78Vv5eLE0slZdY9ionaCB0ctUDgUfX0naphe3l9sojXgJFb3/HZwf7lnqELpb1BxlisV2acc+U0ylnOxDPv99bZdQhBe5LvOKrqJS7C6K0/7TwVt2cvJCsXfv69LYQ6oGibD2HuHisyvIWDOGNc40ekkq2D+TU8nTwXQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWtdItQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWtdItQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82101C4CECF;
	Tue,  3 Dec 2024 15:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238876;
	bh=voc/BlpgnlR4e55WTbtxKhfFbv6u/S/0AaVUTc0JvE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWtdItQmOGEYNwfBvLLVAzpzNS3mVPS4t1mKldqGgYr2DlLtSbaymzf6JtLyEcZcX
	 G0Pa2ktciQEkk9mzGuPnKpSq8K8ZjRX/FAJpV/3gWS+z/VkT/iMk4WMQaSuZ1m+TgP
	 jRh5kQPY/M+Oc4p/RE0k1M4CdBpFlHmLeIxxbnYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 427/817] clk: imx: fracn-gppll: fix pll power up
Date: Tue,  3 Dec 2024 15:39:59 +0100
Message-ID: <20241203144012.552086205@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit ff4279618f0aec350b0fb41b2b35841324fbd96e ]

To i.MX93 which features dual Cortex-A55 cores and DSU, when using
writel_relaxed to write value to PLL registers, the value might be
buffered. To make sure the value has been written into the hardware,
using readl to read back the register could achieve the goal.

current PLL power up flow can be simplified as below:
  1. writel_relaxed to set the PLL POWERUP bit;
  2. readl_poll_timeout to check the PLL lock bit:
     a). timeout = ktime_add_us(ktime_get(), timeout_us);
     b). readl the pll the lock reg;
     c). check if the pll lock bit ready
     d). check if timeout

But in some corner cases, both the write in step 1 and read in
step 2 will be blocked by other bus transaction in the SoC for a
long time, saying the value into real hardware is just before step b).
That means the timeout counting has begins for quite sometime since
step a), but value still not written into real hardware until bus
released just at a point before step b).

Then there maybe chances that the pll lock bit is not ready
when readl done but the timeout happens. readl_poll_timeout will
err return due to timeout. To avoid such unexpected failure,
read back the reg to make sure the write has been done in HW
reg.

So use readl after writel_relaxed to fix the issue.

Since we are here, to avoid udelay to run before writel_relaxed, use
readl before udelay.

Fixes: 1b26cb8a77a4 ("clk: imx: support fracn gppll")
Co-developed-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20241027-imx-clk-v1-v3-3-89152574d1d7@nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-fracn-gppll.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clk/imx/clk-fracn-gppll.c b/drivers/clk/imx/clk-fracn-gppll.c
index f85dd8798f15c..b12b00a2f07fa 100644
--- a/drivers/clk/imx/clk-fracn-gppll.c
+++ b/drivers/clk/imx/clk-fracn-gppll.c
@@ -252,9 +252,11 @@ static int clk_fracn_gppll_set_rate(struct clk_hw *hw, unsigned long drate,
 	pll_div = FIELD_PREP(PLL_RDIV_MASK, rate->rdiv) | rate->odiv |
 		FIELD_PREP(PLL_MFI_MASK, rate->mfi);
 	writel_relaxed(pll_div, pll->base + PLL_DIV);
+	readl(pll->base + PLL_DIV);
 	if (pll->flags & CLK_FRACN_GPPLL_FRACN) {
 		writel_relaxed(rate->mfd, pll->base + PLL_DENOMINATOR);
 		writel_relaxed(FIELD_PREP(PLL_MFN_MASK, rate->mfn), pll->base + PLL_NUMERATOR);
+		readl(pll->base + PLL_NUMERATOR);
 	}
 
 	/* Wait for 5us according to fracn mode pll doc */
@@ -263,6 +265,7 @@ static int clk_fracn_gppll_set_rate(struct clk_hw *hw, unsigned long drate,
 	/* Enable Powerup */
 	tmp |= POWERUP_MASK;
 	writel_relaxed(tmp, pll->base + PLL_CTRL);
+	readl(pll->base + PLL_CTRL);
 
 	/* Wait Lock */
 	ret = clk_fracn_gppll_wait_lock(pll);
@@ -300,6 +303,7 @@ static int clk_fracn_gppll_prepare(struct clk_hw *hw)
 
 	val |= POWERUP_MASK;
 	writel_relaxed(val, pll->base + PLL_CTRL);
+	readl(pll->base + PLL_CTRL);
 
 	ret = clk_fracn_gppll_wait_lock(pll);
 	if (ret)
-- 
2.43.0



