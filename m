Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F09264614;
	Tue,  8 Apr 2025 11:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111111; cv=none; b=TVvdEMWNhQwvL0cSVwypXJu7OrxhuIWaD/zABBy0mrqJkeXZGiVuoLYUJ9WUqcwkawUE4l0VzBLgq5WxY6bKxtojTH+JQV5tzJWevT+7/NSf9fReLLETck9VBJOi5ryu925pt36Tqfb89MldiiksfdIx4kH7h/LQOWIwiS8wS/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111111; c=relaxed/simple;
	bh=jLfDkRyps+y0er8Vk6fl8WrgEzck+eOGTwERTxwqii4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKd97seqHAplLBac9h1DYQObuYM7i+MWfvoHgztY2EC/rm8R9MvSbF/JlHqYNkMc+h2eNNdyNIWX9jbSW4a2HeI+28oZOpPP5tGYFs2eh7cRJccx9/nqpHUJxFpjR/XjkEDMHgxlAM/RSPGjJKJDKQgPjlIm4F3kdH9SD5maqgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPOru1Zc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPOru1Zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82448C4CEE5;
	Tue,  8 Apr 2025 11:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111110;
	bh=jLfDkRyps+y0er8Vk6fl8WrgEzck+eOGTwERTxwqii4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPOru1ZcBSdqK7ogA77V2zOQZFCJehFCX2IEWvUjhy2qB31TqudpVvtrmLDA3/iVV
	 UGC18VFUYTS8Jyngc5061uNkzoJTDeOhntO03CFoWQVqX+HmMywqazSyWVeAxAvv04
	 O7F2nZtmvCr7QRKWV+VNSxv/MMdbD/MaMVNM+yi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 313/731] drm/msm/dpu: move needs_cdm setting to dpu_encoder_get_topology()
Date: Tue,  8 Apr 2025 12:43:30 +0200
Message-ID: <20250408104921.557931361@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 7d39f5bb82c0d7155037982dd0ff583a68db1c34 ]

As a preparation for calling dpu_encoder_get_topology() from different
places, move the code setting topology->needs_cdm to that function
(instead of patching topology separately).

Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/633395/
Link: https://lore.kernel.org/r/20250123-drm-dirty-modeset-v2-2-bbfd3a6cd1a4@linaro.org
Stable-dep-of: 2dde2aadaed1 ("drm/msm/dpu: don't set crtc_state->mode_changed from atomic_check()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 41 +++++++++++----------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index e3555765eefb1..66dc2b1dee7f8 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -652,8 +652,11 @@ static struct msm_display_topology dpu_encoder_get_topology(
 			struct dpu_kms *dpu_kms,
 			struct drm_display_mode *mode,
 			struct drm_crtc_state *crtc_state,
+			struct drm_connector_state *conn_state,
 			struct drm_dsc_config *dsc)
 {
+	struct msm_drm_private *priv = dpu_enc->base.dev->dev_private;
+	struct msm_display_info *disp_info = &dpu_enc->disp_info;
 	struct msm_display_topology topology = {0};
 	int i, intf_count = 0;
 
@@ -703,6 +706,23 @@ static struct msm_display_topology dpu_encoder_get_topology(
 		}
 	}
 
+	/*
+	 * Use CDM only for writeback or DP at the moment as other interfaces cannot handle it.
+	 * If writeback itself cannot handle cdm for some reason it will fail in its atomic_check()
+	 * earlier.
+	 */
+	if (disp_info->intf_type == INTF_WB && conn_state->writeback_job) {
+		struct drm_framebuffer *fb;
+
+		fb = conn_state->writeback_job->fb;
+
+		if (fb && MSM_FORMAT_IS_YUV(msm_framebuffer_format(fb)))
+			topology.needs_cdm = true;
+	} else if (disp_info->intf_type == INTF_DP) {
+		if (msm_dp_is_yuv_420_enabled(priv->dp[disp_info->h_tile_instance[0]], mode))
+			topology.needs_cdm = true;
+	}
+
 	return topology;
 }
 
@@ -750,9 +770,7 @@ static int dpu_encoder_virt_atomic_check(
 	struct dpu_kms *dpu_kms;
 	struct drm_display_mode *adj_mode;
 	struct msm_display_topology topology;
-	struct msm_display_info *disp_info;
 	struct dpu_global_state *global_state;
-	struct drm_framebuffer *fb;
 	struct drm_dsc_config *dsc;
 	int ret = 0;
 
@@ -766,7 +784,6 @@ static int dpu_encoder_virt_atomic_check(
 	DPU_DEBUG_ENC(dpu_enc, "\n");
 
 	priv = drm_enc->dev->dev_private;
-	disp_info = &dpu_enc->disp_info;
 	dpu_kms = to_dpu_kms(priv->kms);
 	adj_mode = &crtc_state->adjusted_mode;
 	global_state = dpu_kms_get_global_state(crtc_state->state);
@@ -777,22 +794,8 @@ static int dpu_encoder_virt_atomic_check(
 
 	dsc = dpu_encoder_get_dsc_config(drm_enc);
 
-	topology = dpu_encoder_get_topology(dpu_enc, dpu_kms, adj_mode, crtc_state, dsc);
-
-	/*
-	 * Use CDM only for writeback or DP at the moment as other interfaces cannot handle it.
-	 * If writeback itself cannot handle cdm for some reason it will fail in its atomic_check()
-	 * earlier.
-	 */
-	if (disp_info->intf_type == INTF_WB && conn_state->writeback_job) {
-		fb = conn_state->writeback_job->fb;
-
-		if (fb && MSM_FORMAT_IS_YUV(msm_framebuffer_format(fb)))
-			topology.needs_cdm = true;
-	} else if (disp_info->intf_type == INTF_DP) {
-		if (msm_dp_is_yuv_420_enabled(priv->dp[disp_info->h_tile_instance[0]], adj_mode))
-			topology.needs_cdm = true;
-	}
+	topology = dpu_encoder_get_topology(dpu_enc, dpu_kms, adj_mode, crtc_state, conn_state,
+					    dsc);
 
 	if (topology.needs_cdm && !dpu_enc->cur_master->hw_cdm)
 		crtc_state->mode_changed = true;
-- 
2.39.5



