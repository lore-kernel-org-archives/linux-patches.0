Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F75D344DB5;
	Sat, 12 Sep 2026 08:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203222; cv=none; b=dqeWPh65sG5A7ObmylELBDONJ3URSu6As+4p1NrvXM9e6TM0ZcJStbXGmomJasdLrDt+OiMrhLyZBndh2yNPKborb3W5ZyvIaBYTitraaWlQUCVP8HDaH5F9o4he19k+1BvvyGC6fBJurr6pu4OdZc85023v5HG8eOUJXSW9FxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203222; c=relaxed/simple;
	bh=kJBtjy+Xz1EXJvbx169hsxD+FIcGSkkftdLk02ZGZUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3uhWb+cII+WJT7GhR12n2pem2zR53L6xQxzkSp8vP8uYj5jBIaIU3CDLN78ZrQi3iptw3nFgYliqybPD4KvrH5iyWQi313IOGvooDOYBOkICbNWqxYZCo8oCTuEjQ16zX0I7oFuKmH6nX4udFXS+IppjDJzefrHR3oRxRgh4H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TAyqe7U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TAyqe7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7991F000FF;
	Sat, 12 Sep 2026 08:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203220;
	bh=F5vx5xflM8lpb41muzE9zTHicPKo6GxJGbYc+RXaBJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0TAyqe7UHjOg1zSyjiYFjvkY0y9Dfpt1AFoHF+37kkDpdS+z2wY0Fda8uYHjv+YQ2
	 X24CGNLjemXziuNgJunBytNPlP4sHl3IM+5oxGuYsDEShlnLjMJu182UnyfqDJ9HEP
	 oNeJgBNtrdNNyBwwYdkR6SZCXvYj1oAsGFAbVClQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Andy Yan <andy.yan@rock-chips.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Diederik de Haas <diederik@cknow-tech.com>
Subject: [PATCH 7.2 1363/1815] phy: rockchip: samsung-hdptx: Fix rate recalculation for 3.2GHz FRL
Date: Sat, 12 Sep 2026 08:51:53 +0200
Message-ID: <20260912065721.025149478@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 9ac3daadb9060360e937a5993a5fd88360d6fdad ]

rk_hdptx_phy_clk_calc_rate_from_pll_cfg() is currently unable to handle
cascade mode for the 3.2GHz FRL operating mode, as it relies solely on
LCPLL_LCVCO_MODE_EN_MASK to determinate the rate from the
rk_hdptx_frl_lcpll_cfg array.  Since there is no entry for this
particular rate, the function returns 0.

This is the only rate which requires LC_REF_CLK_SEL to be set in
GRF_HDPTX_CON0, hence extend the FRL matching accordingly.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260611-hdptx-clk-fixes-v3-0-67b1b0c00e16@collabora.com?part=1
Fixes: de5dba833118 ("phy: rockchip: samsung-hdptx: Add HDMI 2.1 FRL support")
Tested-by: Diederik de Haas <diederik@cknow-tech.com>  # NanoPC-T6 LTS
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Andy Yan <andy.yan@rock-chips.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20260811-hdptx-clk-fixes-v6-4-75bca0ee5753@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../phy/rockchip/phy-rockchip-samsung-hdptx.c | 35 +++++++++++++------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
index 3a65c26f3efab..d7d8414fdddd6 100644
--- a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
+++ b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
@@ -2206,16 +2206,31 @@ static u64 rk_hdptx_phy_clk_calc_rate_from_pll_cfg(struct rk_hdptx_phy *hdptx)
 			return 0;
 		lcpll_hw.sdc_n = (val & LCPLL_SDC_N_MASK) >> 1;
 
-		for (i = 0; i < ARRAY_SIZE(rk_hdptx_frl_lcpll_cfg); i++) {
-			const struct lcpll_config *cfg = &rk_hdptx_frl_lcpll_cfg[i];
-
-			if (cfg->pms_mdiv == lcpll_hw.pms_mdiv &&
-			    cfg->pms_sdiv == lcpll_hw.pms_sdiv &&
-			    cfg->sdm_num_sign == lcpll_hw.sdm_num_sign &&
-			    cfg->sdm_num == lcpll_hw.sdm_num &&
-			    cfg->sdm_deno == lcpll_hw.sdm_deno &&
-			    cfg->sdc_n == lcpll_hw.sdc_n)
-				return cfg->rate;
+		ret = regmap_read(hdptx->grf, GRF_HDPTX_CON0, &val);
+		if (ret)
+			return 0;
+
+		if (val & LC_REF_CLK_SEL) {
+			if (lcpll_hw.pms_mdiv == 0x6b &&
+			    lcpll_hw.sdm_num_sign == 0x01 &&
+			    lcpll_hw.sdm_num == 0x02 &&
+			    lcpll_hw.sdm_deno == 0x09 &&
+			    lcpll_hw.sdc_n == FIELD_GET(LCPLL_SDC_N_MASK, 0x02))
+				return FRL_8G4L_RATE;
+		} else {
+			const struct lcpll_config *cfg;
+
+			for (i = 0; i < ARRAY_SIZE(rk_hdptx_frl_lcpll_cfg); i++) {
+				cfg = &rk_hdptx_frl_lcpll_cfg[i];
+
+				if (cfg->pms_mdiv == lcpll_hw.pms_mdiv &&
+				    cfg->pms_sdiv == lcpll_hw.pms_sdiv &&
+				    cfg->sdm_num_sign == lcpll_hw.sdm_num_sign &&
+				    cfg->sdm_num == lcpll_hw.sdm_num &&
+				    cfg->sdm_deno == lcpll_hw.sdm_deno &&
+				    cfg->sdc_n == lcpll_hw.sdc_n)
+					return cfg->rate;
+			}
 		}
 
 		dev_dbg(hdptx->dev, "%s no FRL match found\n", __func__);
-- 
2.53.0



