Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB69E53A7;
	Fri,  6 Dec 2024 15:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497435; cv=none; b=iueXNV5LYE06rE+q2fxW5juZZXHdU5d/h5oToumX+y9+R3A8zXzHC87SZ5Zg+sbGVYGyo0oJHyvxicBCrWxZsj9wgdlGuqSXIzEriYWEbKgkLQkWU/SiVQsBDU4DOjxOunFe7UDryWEfrD+kCEvSEpUDHc1FCEitGNrU8icA+1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497435; c=relaxed/simple;
	bh=qIwMIXnjsk5OQewL1IH5SDomYDQatlhalpFJuiORpg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3NqJz3e2Kp2OIDi9qrknOQd6ffzCb+uwBxIJGyyLbm6GE9b1y5EA57bi/4+b47BExjC2Gh7rWAA2iGslb90mbTn6FMVBXqvezw1LSNtrAKWq/NbFTeYf18FNQWu/n3mG1Q/vpTpJhZNgxL/At57CdgnK7I2k9LE7Z1fGVFOpTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ioxnTTuv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ioxnTTuv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADE8C4CED1;
	Fri,  6 Dec 2024 15:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497435;
	bh=qIwMIXnjsk5OQewL1IH5SDomYDQatlhalpFJuiORpg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ioxnTTuvWVTSeWllh/3fYe0YtC7wVLyE71WJ/rvbJqT2sp4hZzndk4gNXBQpt6TgA
	 1vD3lmcNyTOGtRcZrqa5RPCsip80D6OopynBNhiT0IYm8lU/1lCd+FJHBYysJB7dnG
	 qKYtnA216tpfjM8a1PCwTtOfVpW1yjsG36rxY2Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 292/676] clk: imx: fracn-gppll: fix pll power up
Date: Fri,  6 Dec 2024 15:31:51 +0100
Message-ID: <20241206143704.749333365@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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



