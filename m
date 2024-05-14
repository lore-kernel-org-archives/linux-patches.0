Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B38253E30;
	Tue, 14 May 2024 11:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685592; cv=none; b=TbrFBpzZAUs82trgdyvc64trta3b6lm55NF/YFwBCYCSRjynRFWmHDW4NBwTSQMO4s7hV1Ra5EZRVFkLphEk84KTbzgtGx6h6GWMEPhpdH4WgRvwj5MKgkShMcZrCKqW0o2TAHW/hvSIesSaBAzq5ZKcivcge1tWn9C3MLK/sG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685592; c=relaxed/simple;
	bh=VkmoKgjZ3wezep/iFP1HwmMQWaDPTHGg8w2KePb6ekg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DH0Bydgcmhll9Z5NXZfTjzp+zni4QhEmkH1WhfLRLQNbymFn5tJJZJkLXq4ToOKMBJ6jOrdO20Lv7OeiefA3Ny8R+ebBbB+OMeGd0rLtChxqhLGuesM3AuBGheGpJFJ4H2HyU8Bqt/C/2Rexa3AjRhL6ycq7Hou8W4Sy8VNqqFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJyw+xrT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJyw+xrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9558C2BD10;
	Tue, 14 May 2024 11:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685592;
	bh=VkmoKgjZ3wezep/iFP1HwmMQWaDPTHGg8w2KePb6ekg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJyw+xrTM3P+u2oLY/k0nRdyrUmfC5OM/aPhjL+MMovi3APsZ99auDbmt0zEcACao
	 5rUtp3tuwCvPMzePh5G5PmoefcQd459O9F1Ml3IL8q6yyGEgGwjE0l+CUOsp2aUiBs
	 5dpZQge2/JIRuk5sLwGqx8k442T5tkIkuvfvl/rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 212/301] drm/meson: dw-hdmi: power up phy on device init
Date: Tue, 14 May 2024 12:18:03 +0200
Message-ID: <20240514101040.265902929@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 04703bfd7f99c016a823c74712b97f8b5590ce87 ]

The phy is not in a useful state right after init. It will become useful,
including for auxiliary function such as CEC or ARC, after the first mode
is set. This is a problem on systems where the display is using another
interface like DSI or CVBS.

This change refactor the init and mode change callback to power up the PHY
on init and leave only what is necessary for mode changes in the related
function. This is enough to fix CEC operation when HDMI display is not
enabled.

Fixes: 3f68be7d8e96 ("drm/meson: Add support for HDMI encoder and DW-HDMI bridge + PHY")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240426160256.3089978-2-jbrunet@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240426160256.3089978-2-jbrunet@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_dw_hdmi.c | 51 +++++++++------------------
 1 file changed, 17 insertions(+), 34 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_dw_hdmi.c b/drivers/gpu/drm/meson/meson_dw_hdmi.c
index 5a9538bc0e26f..a83d93078537d 100644
--- a/drivers/gpu/drm/meson/meson_dw_hdmi.c
+++ b/drivers/gpu/drm/meson/meson_dw_hdmi.c
@@ -384,26 +384,6 @@ static int dw_hdmi_phy_init(struct dw_hdmi *hdmi, void *data,
 	    dw_hdmi_bus_fmt_is_420(hdmi))
 		mode_is_420 = true;
 
-	/* Enable clocks */
-	regmap_update_bits(priv->hhi, HHI_HDMI_CLK_CNTL, 0xffff, 0x100);
-
-	/* Bring HDMITX MEM output of power down */
-	regmap_update_bits(priv->hhi, HHI_MEM_PD_REG0, 0xff << 8, 0);
-
-	/* Bring out of reset */
-	dw_hdmi->data->top_write(dw_hdmi, HDMITX_TOP_SW_RESET,  0);
-
-	/* Enable internal pixclk, tmds_clk, spdif_clk, i2s_clk, cecclk */
-	dw_hdmi_top_write_bits(dw_hdmi, HDMITX_TOP_CLK_CNTL,
-			       0x3, 0x3);
-
-	/* Enable cec_clk and hdcp22_tmdsclk_en */
-	dw_hdmi_top_write_bits(dw_hdmi, HDMITX_TOP_CLK_CNTL,
-			       0x3 << 4, 0x3 << 4);
-
-	/* Enable normal output to PHY */
-	dw_hdmi->data->top_write(dw_hdmi, HDMITX_TOP_BIST_CNTL, BIT(12));
-
 	/* TMDS pattern setup */
 	if (mode->clock > 340000 && !mode_is_420) {
 		dw_hdmi->data->top_write(dw_hdmi, HDMITX_TOP_TMDS_CLK_PTTN_01,
@@ -425,20 +405,6 @@ static int dw_hdmi_phy_init(struct dw_hdmi *hdmi, void *data,
 	/* Setup PHY parameters */
 	meson_hdmi_phy_setup_mode(dw_hdmi, mode, mode_is_420);
 
-	/* Setup PHY */
-	regmap_update_bits(priv->hhi, HHI_HDMI_PHY_CNTL1,
-			   0xffff << 16, 0x0390 << 16);
-
-	/* BIT_INVERT */
-	if (dw_hdmi_is_compatible(dw_hdmi, "amlogic,meson-gxl-dw-hdmi") ||
-	    dw_hdmi_is_compatible(dw_hdmi, "amlogic,meson-gxm-dw-hdmi") ||
-	    dw_hdmi_is_compatible(dw_hdmi, "amlogic,meson-g12a-dw-hdmi"))
-		regmap_update_bits(priv->hhi, HHI_HDMI_PHY_CNTL1,
-				   BIT(17), 0);
-	else
-		regmap_update_bits(priv->hhi, HHI_HDMI_PHY_CNTL1,
-				   BIT(17), BIT(17));
-
 	/* Disable clock, fifo, fifo_wr */
 	regmap_update_bits(priv->hhi, HHI_HDMI_PHY_CNTL1, 0xf, 0);
 
@@ -656,6 +622,23 @@ static void meson_dw_hdmi_init(struct meson_dw_hdmi *meson_dw_hdmi)
 	meson_dw_hdmi->data->top_write(meson_dw_hdmi,
 				       HDMITX_TOP_CLK_CNTL, 0xff);
 
+	/* Enable normal output to PHY */
+	meson_dw_hdmi->data->top_write(meson_dw_hdmi, HDMITX_TOP_BIST_CNTL, BIT(12));
+
+	/* Setup PHY */
+	regmap_update_bits(priv->hhi, HHI_HDMI_PHY_CNTL1,
+			   0xffff << 16, 0x0390 << 16);
+
+	/* BIT_INVERT */
+	if (dw_hdmi_is_compatible(meson_dw_hdmi, "amlogic,meson-gxl-dw-hdmi") ||
+	    dw_hdmi_is_compatible(meson_dw_hdmi, "amlogic,meson-gxm-dw-hdmi") ||
+	    dw_hdmi_is_compatible(meson_dw_hdmi, "amlogic,meson-g12a-dw-hdmi"))
+		regmap_update_bits(priv->hhi, HHI_HDMI_PHY_CNTL1,
+				   BIT(17), 0);
+	else
+		regmap_update_bits(priv->hhi, HHI_HDMI_PHY_CNTL1,
+				   BIT(17), BIT(17));
+
 	/* Enable HDMI-TX Interrupt */
 	meson_dw_hdmi->data->top_write(meson_dw_hdmi, HDMITX_TOP_INTR_STAT_CLR,
 				       HDMITX_TOP_INTR_CORE);
-- 
2.43.0



