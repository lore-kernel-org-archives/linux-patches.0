Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958C02C032C;
	Sat, 12 Sep 2026 08:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201025; cv=none; b=rxBBR2r7VDZXRfPPbbSnzLrI3gAR3e/b9TdoI4RvkSlnpkaUosBYI3q78PMq92RxwRAZz5S6GwaOI6+1uw43mhThKahqwrI4r++T9kchDMdgOSqTiyOJWU3mc8xFurRUHkhFrNSX0flzNLCfeqnjHKHl0Sh6T4mmY2ca6Q/y6BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201025; c=relaxed/simple;
	bh=OFsszFA5XDswBQPcbfivkapMV/w9N1LL6B9LP2K+8tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naMX11J4MZ0cvWTRgU8queUAnWQ92G6WXhUKO4adMroThhtlkXr2LxI4OBTFsXt0NuFm2yT992US9MZ4a6xaHFGWEHJfaDhgXtjNG73j6qN5kgV9/IELv5COMAPDyLRzKEdC6P5A0BgYB4a12uJB3MEyqWU20jFbkOQF4dHnsAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skf2Pzbu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skf2Pzbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7622D1F000FF;
	Sat, 12 Sep 2026 08:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201024;
	bh=EEL+dPFAbnkHOCFdJEWwHeQsVVeszgFj+8TfwpddY4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=skf2PzbuG/k9IQmtVOsweeuXwPkE6K1IpI/wgsMtr1epPD5oMk6SKeFSUGrr21xSV
	 vUymZqZFTRqFlq+DuDb5kU5uuY8Z1dBBo2YNvCwvmStOCypquGGP3hDRR6A2lPH2v+
	 IFtYo4tC3wiW/hNys2Vle4KW2LTKSbL1cZJOIFZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0909/1815] drm/msm/dp: reject YUV420-only modes without VSC SDP support
Date: Sat, 12 Sep 2026 08:44:19 +0200
Message-ID: <20260912065710.261848851@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 684f95fb4e9ad10aac39fbb1fa7592a59d7f54ea ]

DP conveys YUV 420 colorimetry through a VSC SDP. A sink that advertises
a mode as YUV-420-only therefore cannot be driven at all unless the panel
supports VSC SDP, yet msm_dp_bridge_mode_valid() only used the VSC SDP
capability to decide whether to halve the pixel clock, otherwise letting
such modes through to be validated (and possibly accepted) at the full
RGB clock the sink cannot display.

Reject 420-only modes with MODE_NO_420 when the panel does not support
VSC SDP. With those modes filtered out, being a 420-only mode implies VSC
SDP support, so the YUV-420 test reduces to drm_mode_is_420_only(): drop
msm_dp_is_yuv_420_enabled() and call the DRM helper directly at its two
callers (the DPU encoder already has the connector from the atomic state).

Fixes: df9cf852ca30 ("drm/msm/dp: account for widebus and yuv420 during mode validation")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/741713/
Link: https://lore.kernel.org/r/20260722-drm-msm-display-interface-v1-1-368c10fe62fd@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c |  3 +--
 drivers/gpu/drm/msm/dp/dp_display.c         | 28 +++++++++------------
 drivers/gpu/drm/msm/msm_drv.h               |  8 ------
 3 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 778e231d49677..1f20695f81e35 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -710,8 +710,7 @@ void dpu_encoder_update_topology(struct drm_encoder *drm_enc,
 		if (fb && MSM_FORMAT_IS_YUV(msm_framebuffer_format(fb)))
 			topology->num_cdm++;
 	} else if (disp_info->intf_type == INTF_DP) {
-		if (msm_dp_is_yuv_420_enabled(priv->kms->dp[disp_info->h_tile_instance[0]],
-					      adj_mode))
+		if (drm_mode_is_420_only(&connector->display_info, adj_mode))
 			topology->num_cdm++;
 	}
 }
diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index dc6f33809ca5f..e0c44eef3abab 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -698,6 +698,7 @@ enum drm_mode_status msm_dp_bridge_mode_valid(struct drm_bridge *bridge,
 	u32 mode_rate_khz = 0, supported_rate_khz = 0, mode_bpp = 0;
 	struct msm_dp *dp;
 	int mode_pclk_khz = mode->clock;
+	bool is_yuv_420;
 
 	dp = to_dp_bridge(bridge)->msm_dp_display;
 
@@ -709,9 +710,16 @@ enum drm_mode_status msm_dp_bridge_mode_valid(struct drm_bridge *bridge,
 	msm_dp_display = container_of(dp, struct msm_dp_display_private, msm_dp_display);
 	link_info = &msm_dp_display->panel->link_info;
 
-	if ((drm_mode_is_420_only(&dp->connector->display_info, mode) &&
-	     msm_dp_display->panel->vsc_sdp_supported) ||
-	     msm_dp_wide_bus_available(dp))
+	is_yuv_420 = drm_mode_is_420_only(&dp->connector->display_info, mode);
+
+	/*
+	 * YUV 420 is carried over DP by signalling the colorimetry through a
+	 * VSC SDP, so a 420-only mode cannot be driven without VSC SDP support.
+	 */
+	if (is_yuv_420 && !msm_dp_display->panel->vsc_sdp_supported)
+		return MODE_NO_420;
+
+	if (is_yuv_420 || msm_dp_wide_bus_available(dp))
 		mode_pclk_khz /= 2;
 
 	if (mode_pclk_khz > DP_MAX_PIXEL_CLK_KHZ)
@@ -1277,22 +1285,10 @@ void __exit msm_dp_unregister(void)
 	platform_driver_unregister(&msm_dp_display_driver);
 }
 
-bool msm_dp_is_yuv_420_enabled(const struct msm_dp *msm_dp_display,
-			       const struct drm_display_mode *mode)
-{
-	struct msm_dp_display_private *dp;
-	const struct drm_display_info *info;
-
-	dp = container_of(msm_dp_display, struct msm_dp_display_private, msm_dp_display);
-	info = &msm_dp_display->connector->display_info;
-
-	return dp->panel->vsc_sdp_supported && drm_mode_is_420_only(info, mode);
-}
-
 bool msm_dp_needs_periph_flush(const struct msm_dp *msm_dp_display,
 			       const struct drm_display_mode *mode)
 {
-	return msm_dp_is_yuv_420_enabled(msm_dp_display, mode);
+	return drm_mode_is_420_only(&msm_dp_display->connector->display_info, mode);
 }
 
 bool msm_dp_wide_bus_available(const struct msm_dp *msm_dp_display)
diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
index 3787db8770ada..3d5679be488e7 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -356,8 +356,6 @@ void __exit msm_dp_unregister(void);
 int msm_dp_modeset_init(struct msm_dp *dp_display, struct drm_device *dev,
 			 struct drm_encoder *encoder, bool yuv_supported);
 void msm_dp_snapshot(struct msm_disp_state *disp_state, struct msm_dp *dp_display);
-bool msm_dp_is_yuv_420_enabled(const struct msm_dp *dp_display,
-			       const struct drm_display_mode *mode);
 bool msm_dp_needs_periph_flush(const struct msm_dp *dp_display,
 			       const struct drm_display_mode *mode);
 bool msm_dp_wide_bus_available(const struct msm_dp *dp_display);
@@ -382,12 +380,6 @@ static inline void msm_dp_snapshot(struct msm_disp_state *disp_state, struct msm
 {
 }
 
-static inline bool msm_dp_is_yuv_420_enabled(const struct msm_dp *dp_display,
-					     const struct drm_display_mode *mode)
-{
-	return false;
-}
-
 static inline bool msm_dp_needs_periph_flush(const struct msm_dp *dp_display,
 					     const struct drm_display_mode *mode)
 {
-- 
2.53.0



