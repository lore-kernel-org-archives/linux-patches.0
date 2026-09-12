Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB35941C302;
	Sat, 12 Sep 2026 10:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209180; cv=none; b=q0GmWKqYD/HE0amMjhbyYisdC4mIGE2GyWG/SsUIvaBp3UfES1Vffa6AepjCAhs1mPlVTOtJih6pmYIDZnzhSHyZnE9fW3wCVW+C5xiCtqE9KTr1d05BNdX+6NaRDAjalrxZDllTDTaMRUxLq9a80eh1rBzE8T9HvucG6eov8OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209180; c=relaxed/simple;
	bh=oNjSa2EuUYRomRq85JFmRxffW7jLLa3rqKBlK5lHyos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMRbSzUR0KSQzJhAhW9D/5AY1lwtVi0WFGMeHmzYnSSoezA1KOWRvoFFWJRrp1BzX5Gxss2y61ph+Auyc9kBk/jaZ+hnDCADrhof+llAk3yJZZyd085+6bPLViEa4rUYQp8IT2BDSRtmgDYEnvn+aql6x1aY91a2ZJj9xO00Hl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mfVpbJcN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mfVpbJcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313041F00898;
	Sat, 12 Sep 2026 10:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209177;
	bh=nX4Fv+VGuSZGV15wm1UftwqSjjzDp3eSCEOl2f9myhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mfVpbJcNU4B+pZn2AuLhBueED4T+m7bBkbTqfPoXx6KvQhK10ryhgknZeqTs8+vh7
	 CPOsaQiSTKxzhHOkdQiQgpt/oxYfhCbNBIaj1rZ66mXr/6DPjL85ZH/y1o269uD6Hu
	 Y4Jcmz5brlTw09n+SQLrv/u4a5PQaSgnmhKvU96U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0767/1518] drm/msm/dp: reject YUV420-only modes without VSC SDP support
Date: Sat, 12 Sep 2026 08:48:56 +0200
Message-ID: <20260912065640.784300314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 777eab5ad844e..e21aa5cdbaf29 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -709,8 +709,7 @@ void dpu_encoder_update_topology(struct drm_encoder *drm_enc,
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
index c6f5422b60ddb..5b630dbb16952 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -930,6 +930,7 @@ enum drm_mode_status msm_dp_bridge_mode_valid(struct drm_bridge *bridge,
 	u32 mode_rate_khz = 0, supported_rate_khz = 0, mode_bpp = 0;
 	struct msm_dp *dp;
 	int mode_pclk_khz = mode->clock;
+	bool is_yuv_420;
 
 	dp = to_dp_bridge(bridge)->msm_dp_display;
 
@@ -941,9 +942,16 @@ enum drm_mode_status msm_dp_bridge_mode_valid(struct drm_bridge *bridge,
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
@@ -1506,22 +1514,10 @@ void __exit msm_dp_unregister(void)
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
index 6d847d593f1ae..d40793845541e 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -357,8 +357,6 @@ void __exit msm_dp_unregister(void);
 int msm_dp_modeset_init(struct msm_dp *dp_display, struct drm_device *dev,
 			 struct drm_encoder *encoder, bool yuv_supported);
 void msm_dp_snapshot(struct msm_disp_state *disp_state, struct msm_dp *dp_display);
-bool msm_dp_is_yuv_420_enabled(const struct msm_dp *dp_display,
-			       const struct drm_display_mode *mode);
 bool msm_dp_needs_periph_flush(const struct msm_dp *dp_display,
 			       const struct drm_display_mode *mode);
 bool msm_dp_wide_bus_available(const struct msm_dp *dp_display);
@@ -383,12 +381,6 @@ static inline void msm_dp_snapshot(struct msm_disp_state *disp_state, struct msm
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



