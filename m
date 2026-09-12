Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC5F364059;
	Sat, 12 Sep 2026 08:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203207; cv=none; b=LwatDfWDy55yXroiKbBf2KcJCV+ZQY7/WQ324nMj+VWfwOLT+gOvO8AacaJ42YRbl6N8izBl/G8L6GiUAyRnGSTGUUYdF8h+3DvGz0DQ1JGLRE4pWQ3drQYybXDsAAxwNpFpi2LTeq75bI+pvcQXbA8Yvx0Es/F0oTjLMsGpT9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203207; c=relaxed/simple;
	bh=ITe5iKFkVndPpJkOc9DaMAJZ4n6G0rGrRBuyQNuLG5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vc+2Yx/fLYnOIykVNkeOkevxs9ApM6FvHE8Id0TVjaxUaCErl48ftcLRl4DalGfj+sCbQ88MLV/Y+rZl9ZCuaFMGXcvd+Qp8QJsIjdL7Ihonzfl76531fz3hInZBgoLWmw80blRLvSW2ds7rQNY1RLD9XM5y0tLtacRn3eMUNu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oyXy+Gvg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oyXy+Gvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816DE1F000FF;
	Sat, 12 Sep 2026 08:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203206;
	bh=N9q2YeaHh2szhLV6oNAEFnQlT7ZTsYLriNDIivZ96RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oyXy+Gvg8wcaKP+lhecnWmgB21TzUOlgFHOKxKGTx4jscDK5sTUCYCCXbvMRgq0PE
	 V881Y7Qz6huxlCcZKw1kBo/qwd1ByNtycn91gjsgNC32iIJw9Ko2oM3HqOkWfNGy3Y
	 hUPrweJJLPHr2p5oVfK+P05ySLrXqy9iWoBOhqaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Niederpr=C3=BCm?= <dubito@online.de>,
	Simon Wright <simon@symple.nz>,
	Andy Yan <andyshrk@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Diederik de Haas <diederik@cknow-tech.com>
Subject: [PATCH 7.2 1360/1815] phy: rockchip: samsung-hdptx: Fix rate recalculation for high bpc
Date: Sat, 12 Sep 2026 08:51:50 +0200
Message-ID: <20260912065720.955398113@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit f0c2c9c58a48b621b1cb90f0821da422b31af814 ]

The PHY PLL can be programmed by an external component, e.g. the
bootloader, just before the recalc_rate() callback is invoked during
devm_clk_hw_register() in the probe path.

Therefore rk_hdptx_phy_clk_recalc_rate() finds the PLL enabled and
attempts to compute the clock rate, while making use of the bpc value
from the HDMI PHY configuration, which always defaults to 8 because
phy_configure() was not run at that point.  As a consequence, the
(re)calculated rate is incorrect when the actual bpc was higher than 8.

Do not rely on any of the hdmi_cfg members when computing the clock rate
and, instead, read the required input data (i.e. bpc), directly from the
hardware registers.

Fixes: 3481fc04d969 ("phy: rockchip: samsung-hdptx: Compute clk rate from PLL config")
Tested-by: Thomas Niederprüm <dubito@online.de>
Tested-by: Simon Wright <simon@symple.nz>
Tested-by: Diederik de Haas <diederik@cknow-tech.com>  # NanoPC-T6 LTS
Reviewed-by: Andy Yan <andyshrk@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20260811-hdptx-clk-fixes-v6-1-75bca0ee5753@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
index 2d973bc37f076..710603afff866 100644
--- a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
+++ b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
@@ -2168,7 +2168,7 @@ static u64 rk_hdptx_phy_clk_calc_rate_from_pll_cfg(struct rk_hdptx_phy *hdptx)
 	struct lcpll_config lcpll_hw;
 	struct ropll_config ropll_hw;
 	u64 fout, sdm;
-	u32 mode, val;
+	u32 mode, bpc, val;
 	int ret, i;
 
 	ret = regmap_read(hdptx->regmap, CMN_REG(0008), &mode);
@@ -2266,6 +2266,7 @@ static u64 rk_hdptx_phy_clk_calc_rate_from_pll_cfg(struct rk_hdptx_phy *hdptx)
 	if (ret)
 		return 0;
 	ropll_hw.pms_sdiv = ((val & PLL_PCG_POSTDIV_SEL_MASK) >> 4) + 1;
+	bpc = (FIELD_GET(PLL_PCG_CLK_SEL_MASK, val) << 1) + 8;
 
 	fout = PLL_REF_CLK * ropll_hw.pms_mdiv;
 	if (ropll_hw.sdm_en) {
@@ -2280,7 +2281,7 @@ static u64 rk_hdptx_phy_clk_calc_rate_from_pll_cfg(struct rk_hdptx_phy *hdptx)
 			fout = fout + sdm;
 	}
 
-	return div_u64(fout * 2, ropll_hw.pms_sdiv * 10);
+	return DIV_ROUND_CLOSEST_ULL(fout * 2 * 8, ropll_hw.pms_sdiv * 10 * bpc);
 }
 
 static unsigned long rk_hdptx_phy_clk_recalc_rate(struct clk_hw *hw,
@@ -2288,19 +2289,13 @@ static unsigned long rk_hdptx_phy_clk_recalc_rate(struct clk_hw *hw,
 {
 	struct rk_hdptx_phy *hdptx = to_rk_hdptx_phy(hw);
 	u32 status;
-	u64 rate;
 	int ret;
 
 	ret = regmap_read(hdptx->grf, GRF_HDPTX_CON0, &status);
 	if (ret || !(status & HDPTX_I_PLL_EN))
 		return 0;
 
-	rate = rk_hdptx_phy_clk_calc_rate_from_pll_cfg(hdptx);
-
-	if (hdptx->hdmi_cfg.mode == PHY_HDMI_MODE_FRL)
-		return rate;
-
-	return DIV_ROUND_CLOSEST_ULL(rate * 8, hdptx->hdmi_cfg.bpc);
+	return rk_hdptx_phy_clk_calc_rate_from_pll_cfg(hdptx);
 }
 
 static int rk_hdptx_phy_clk_determine_rate(struct clk_hw *hw,
-- 
2.53.0



