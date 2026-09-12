Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94862E718B;
	Sat, 12 Sep 2026 08:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203232; cv=none; b=r33a51x/n1B3Iigb/cTu8KBynctFE/P5sgrKw9ekT+JJPCgORafdRj7g7HOFDsHLDqph50jedSDNXMogMqu7dRUCIuR+HbceZBjSpdqdxNlNl2EQHdAmtacIu8UTqQ81o7PQrk9gqqyzieNpgcRcivOZT06eHBUL+HS+tOgH95k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203232; c=relaxed/simple;
	bh=hMjHj0LVbWK6cMDQgSqdCQ3fV+cgqRHRtvIMnfmo47o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JSYczrpXkspetx/wCMnLGjrmYg8yawmsq7QEBIphvGsoj1QOlBz2XRaK8Ha6SvkIR76ZSdDrSwGNyKmv8VrNRzBACrLgT6VcmDQBuSLhewRCQ98rZmOsECERS4j3t1sZ6C10OUmvTz1EUQHlkgG/wsqNZoxRLpDdG9bHj7FxQDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XI9bl9b4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XI9bl9b4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623951F000FF;
	Sat, 12 Sep 2026 08:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203230;
	bh=4Ed48PcyodmwPQg+Jf6wm0SGACViE7MJX6dSHfjKCCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XI9bl9b4NkpekrGVhZ0KOAlpD9Z04Ze2uX8P22kkhkxyjiHxL/tH6Y/34FyL4olzJ
	 bKClnhq7Mfci1xwoL3FYWm8oxGW/iPHOqX/Z72zEK6FiAHM3L4MM+3QCR5qyIci3qU
	 HlqdQIlYtGe/+5BFFw2qpgpQqDXfHsQZeh85MY+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Niederpr=C3=BCm?= <dubito@online.de>,
	Simon Wright <simon@symple.nz>,
	Andy Yan <andy.yan@rock-chips.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Diederik de Haas <diederik@cknow-tech.com>
Subject: [PATCH 7.2 1364/1815] phy: rockchip: samsung-hdptx: Handle uncommitted PHY config changes
Date: Sat, 12 Sep 2026 08:51:54 +0200
Message-ID: <20260912065721.049038685@linuxfoundation.org>
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

[ Upstream commit aec3e4ce25da4ed37bbbfedcbb7107ae9428b183 ]

Any changes to the PHY link rate and/or color depth done via the HDMI
PHY configuration API are not immediately programmed into the hardware,
but are delayed until the PHY usage count gets incremented from 0 to 1,
that is when it is powered on or when the PLL clock exposed through
the CCF API is prepared, whichever comes first.

Since the clock might remain in prepared state after subsequent PHY
config changes, the programming can also be triggered via
clk_ops.set_rate().  However, from the clock consumer perspective (i.e.
VOP2 display controller), the (pixel) clock rate doesn't vary with bpc,
as that is handled internally by the PHY and reflected in the TDMS
character rate only.

As a consequence, changing the bpc while preserving the modeline may
lead to out-of-sync issues between CCF and HDMI PHY config state,
because the .set_rate() callback is not invoked when clock rate remains
constant.  This may also happen when the PHY PLL has been pre-programmed
by an external entity, e.g. the bootloader, which is actually a
regression introduced by the recent FRL-related changes.

Introduce a pll_config_dirty flag to keep track of uncommitted PHY
config changes and use it in clk_ops.determine_rate() to invalidate the
current clock rate (as known by CCF) and, consequently, ensure those
changes are programmed into hardware via clk_ops.set_rate().

Moreover, proceed with a similar fix in phy_ops.power_on() callback, to
handle the scenario where the CCF API is not used due to operating in
FRL mode, while the clock is still in a prepared state and thus
preventing rk_hdptx_phy_consumer_get() to apply the updated PHY
configuration.

Fixes: de5dba833118 ("phy: rockchip: samsung-hdptx: Add HDMI 2.1 FRL support")
Fixes: 9d0ec51d7c22 ("phy: rockchip: samsung-hdptx: Add high color depth management")
Tested-by: Thomas Niederprüm <dubito@online.de>
Tested-by: Simon Wright <simon@symple.nz>
Tested-by: Diederik de Haas <diederik@cknow-tech.com>  # NanoPC-T6 LTS
Reviewed-by: Andy Yan <andy.yan@rock-chips.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20260811-hdptx-clk-fixes-v6-5-75bca0ee5753@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../phy/rockchip/phy-rockchip-samsung-hdptx.c | 84 +++++++++++--------
 1 file changed, 48 insertions(+), 36 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
index d7d8414fdddd6..c24e7f2841703 100644
--- a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
+++ b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
@@ -413,6 +413,7 @@ struct rk_hdptx_phy {
 
 	/* clk provider */
 	struct clk_hw hw;
+	bool pll_config_dirty;
 	bool restrict_rate_change;
 
 	atomic_t usage_count;
@@ -1260,13 +1261,19 @@ static int rk_hdptx_tmds_ropll_cmn_config(struct rk_hdptx_phy *hdptx)
 
 static int rk_hdptx_pll_cmn_config(struct rk_hdptx_phy *hdptx)
 {
+	int ret;
+
 	if (hdptx->hdmi_cfg.rate <= HDMI20_MAX_RATE)
-		return rk_hdptx_tmds_ropll_cmn_config(hdptx);
+		ret = rk_hdptx_tmds_ropll_cmn_config(hdptx);
+	else if (hdptx->hdmi_cfg.rate == FRL_8G4L_RATE)
+		ret = rk_hdptx_frl_lcpll_ropll_cmn_config(hdptx);
+	else
+		ret = rk_hdptx_frl_lcpll_cmn_config(hdptx);
 
-	if (hdptx->hdmi_cfg.rate == FRL_8G4L_RATE)
-		return rk_hdptx_frl_lcpll_ropll_cmn_config(hdptx);
+	if (!ret)
+		hdptx->pll_config_dirty = false;
 
-	return rk_hdptx_frl_lcpll_cmn_config(hdptx);
+	return ret;
 }
 
 static int rk_hdptx_frl_lcpll_mode_config(struct rk_hdptx_phy *hdptx)
@@ -1347,25 +1354,22 @@ static int rk_hdptx_phy_consumer_get(struct rk_hdptx_phy *hdptx)
 		return 0;
 
 	ret = regmap_read(hdptx->grf, GRF_HDPTX_STATUS, &status);
-	if (ret)
-		goto dec_usage;
-
-	if (status & HDPTX_O_PLL_LOCK_DONE)
-		dev_warn(hdptx->dev, "PLL locked by unknown consumer!\n");
+	if (ret) {
+		atomic_dec(&hdptx->usage_count);
+		return ret;
+	}
 
 	if (mode == PHY_MODE_DP) {
 		rk_hdptx_dp_reset(hdptx);
 	} else {
-		ret = rk_hdptx_pll_cmn_config(hdptx);
-		if (ret)
-			goto dec_usage;
+		/*
+		 * Ignore PLL config errors at this point as pll_config_dirty
+		 * was not reset and, therefore, operation will be retried.
+		 */
+		rk_hdptx_pll_cmn_config(hdptx);
 	}
 
 	return 0;
-
-dec_usage:
-	atomic_dec(&hdptx->usage_count);
-	return ret;
 }
 
 static int rk_hdptx_phy_consumer_put(struct rk_hdptx_phy *hdptx, bool force)
@@ -1700,13 +1704,18 @@ static int rk_hdptx_phy_power_on(struct phy *phy)
 		if (ret)
 			rk_hdptx_phy_consumer_put(hdptx, true);
 	} else {
-		regmap_write(hdptx->grf, GRF_HDPTX_CON0,
-			     HDPTX_MODE_SEL << 16 | FIELD_PREP(HDPTX_MODE_SEL, 0x0));
+		if (hdptx->pll_config_dirty)
+			ret = rk_hdptx_pll_cmn_config(hdptx);
+
+		if (!ret) {
+			regmap_write(hdptx->grf, GRF_HDPTX_CON0,
+				     HDPTX_MODE_SEL << 16 | FIELD_PREP(HDPTX_MODE_SEL, 0x0));
 
-		if (hdptx->hdmi_cfg.mode == PHY_HDMI_MODE_FRL)
-			ret = rk_hdptx_frl_lcpll_mode_config(hdptx);
-		else
-			ret = rk_hdptx_tmds_ropll_mode_config(hdptx);
+			if (hdptx->hdmi_cfg.mode == PHY_HDMI_MODE_FRL)
+				ret = rk_hdptx_frl_lcpll_mode_config(hdptx);
+			else
+				ret = rk_hdptx_tmds_ropll_mode_config(hdptx);
+		}
 
 		if (ret)
 			rk_hdptx_phy_consumer_put(hdptx, true);
@@ -2081,7 +2090,10 @@ static int rk_hdptx_phy_configure(struct phy *phy, union phy_configure_opts *opt
 			dev_err(hdptx->dev, "invalid hdmi params for phy configure\n");
 		} else {
 			hdptx->restrict_rate_change = true;
-			dev_dbg(hdptx->dev, "%s rate=%llu bpc=%u\n", __func__,
+			hdptx->pll_config_dirty = true;
+
+			dev_dbg(hdptx->dev, "%s %s rate=%llu bpc=%u\n", __func__,
+				hdptx->hdmi_cfg.mode ? "FRL" : "TMDS",
 				hdptx->hdmi_cfg.rate, hdptx->hdmi_cfg.bpc);
 		}
 
@@ -2338,8 +2350,19 @@ static int rk_hdptx_phy_clk_determine_rate(struct clk_hw *hw,
 {
 	struct rk_hdptx_phy *hdptx = to_rk_hdptx_phy(hw);
 
-	if (hdptx->hdmi_cfg.mode == PHY_HDMI_MODE_FRL)
-		return hdptx->hdmi_cfg.rate;
+	/*
+	 * Invalidate current clock rate to ensure rk_hdptx_phy_clk_set_rate()
+	 * will be invoked to commit PLL configuration.
+	 */
+	if (hdptx->pll_config_dirty) {
+		req->rate = 0;
+		return 0;
+	}
+
+	if (hdptx->hdmi_cfg.mode == PHY_HDMI_MODE_FRL) {
+		req->rate = hdptx->hdmi_cfg.rate;
+		return 0;
+	}
 
 	/*
 	 * FIXME: Temporarily allow altering TMDS char rate via CCF.
@@ -2371,17 +2394,6 @@ static int rk_hdptx_phy_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 				     unsigned long parent_rate)
 {
 	struct rk_hdptx_phy *hdptx = to_rk_hdptx_phy(hw);
-	unsigned long long link_rate = rate;
-
-	if (hdptx->hdmi_cfg.mode != PHY_HDMI_MODE_FRL)
-		link_rate = DIV_ROUND_CLOSEST_ULL(rate * hdptx->hdmi_cfg.bpc, 8);
-
-	/* Revert any unlikely link rate change since determine_rate() */
-	if (hdptx->hdmi_cfg.rate != link_rate) {
-		dev_warn(hdptx->dev, "Reverting unexpected rate change from %llu to %llu\n",
-			 link_rate, hdptx->hdmi_cfg.rate);
-		hdptx->hdmi_cfg.rate = link_rate;
-	}
 
 	/*
 	 * The link rate would be normally programmed in HW during
-- 
2.53.0



