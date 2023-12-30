Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CE079CD;
	Sat, 30 Dec 2023 12:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxVPEagi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DAFC433C8;
	Sat, 30 Dec 2023 12:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937707;
	bh=0NoMbjtM3Gz6L6/dw8NURG3u0qxvDbd4Ri4BGY6vA0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxVPEagigV5XbJvecr7ECVNY9FhyfdJwKTyDjtBYiZcKyUymJRLZ374ZB0espkMdE
	 wbMpO0LIxbdauZTQm5kRuYbYAv2ArNokxom4b7baK1nMA2YHmnS3aNSQs1EaiSrs3W
	 5ZCQVS8s3rhuPA2VfO0l4ioy4+f6Xngsd93IK4+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/156] drm/i915: Introduce crtc_state->enhanced_framing
Date: Sat, 30 Dec 2023 11:57:43 +0000
Message-ID: <20231230115812.662514386@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 3072a24c778a7102d70692af5556e47363114c67 ]

Track DP enhanced framing properly in the crtc state instead
of relying just on the cached DPCD everywhere, and hook it
up into the state check and dump.

v2: Actually set enhanced_framing in .compute_config()

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230503113659.16305-1-ville.syrjala@linux.intel.com
Reviewed-by: Luca Coelho <luciano.coelho@intel.com>
Stable-dep-of: e6861d8264cd ("drm/i915/edp: don't write to DP_LINK_BW_SET when using rate select")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/g4x_dp.c                 | 10 ++++++++--
 drivers/gpu/drm/i915/display/intel_crt.c              |  2 ++
 drivers/gpu/drm/i915/display/intel_crtc_state_dump.c  |  5 +++--
 drivers/gpu/drm/i915/display/intel_ddi.c              | 11 +++++++++--
 drivers/gpu/drm/i915/display/intel_display.c          |  1 +
 drivers/gpu/drm/i915/display/intel_display_types.h    |  2 ++
 drivers/gpu/drm/i915/display/intel_dp.c               |  3 +++
 drivers/gpu/drm/i915/display/intel_dp_link_training.c |  2 +-
 8 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/g4x_dp.c b/drivers/gpu/drm/i915/display/g4x_dp.c
index 4c7187f7913ea..e8ee0a08947e8 100644
--- a/drivers/gpu/drm/i915/display/g4x_dp.c
+++ b/drivers/gpu/drm/i915/display/g4x_dp.c
@@ -141,7 +141,7 @@ static void intel_dp_prepare(struct intel_encoder *encoder,
 
 		intel_de_rmw(dev_priv, TRANS_DP_CTL(crtc->pipe),
 			     TRANS_DP_ENH_FRAMING,
-			     drm_dp_enhanced_frame_cap(intel_dp->dpcd) ?
+			     pipe_config->enhanced_framing ?
 			     TRANS_DP_ENH_FRAMING : 0);
 	} else {
 		if (IS_G4X(dev_priv) && pipe_config->limited_color_range)
@@ -153,7 +153,7 @@ static void intel_dp_prepare(struct intel_encoder *encoder,
 			intel_dp->DP |= DP_SYNC_VS_HIGH;
 		intel_dp->DP |= DP_LINK_TRAIN_OFF;
 
-		if (drm_dp_enhanced_frame_cap(intel_dp->dpcd))
+		if (pipe_config->enhanced_framing)
 			intel_dp->DP |= DP_ENHANCED_FRAMING;
 
 		if (IS_CHERRYVIEW(dev_priv))
@@ -351,6 +351,9 @@ static void intel_dp_get_config(struct intel_encoder *encoder,
 		u32 trans_dp = intel_de_read(dev_priv,
 					     TRANS_DP_CTL(crtc->pipe));
 
+		if (trans_dp & TRANS_DP_ENH_FRAMING)
+			pipe_config->enhanced_framing = true;
+
 		if (trans_dp & TRANS_DP_HSYNC_ACTIVE_HIGH)
 			flags |= DRM_MODE_FLAG_PHSYNC;
 		else
@@ -361,6 +364,9 @@ static void intel_dp_get_config(struct intel_encoder *encoder,
 		else
 			flags |= DRM_MODE_FLAG_NVSYNC;
 	} else {
+		if (tmp & DP_ENHANCED_FRAMING)
+			pipe_config->enhanced_framing = true;
+
 		if (tmp & DP_SYNC_HS_HIGH)
 			flags |= DRM_MODE_FLAG_PHSYNC;
 		else
diff --git a/drivers/gpu/drm/i915/display/intel_crt.c b/drivers/gpu/drm/i915/display/intel_crt.c
index d23020eb87f46..4352f90177615 100644
--- a/drivers/gpu/drm/i915/display/intel_crt.c
+++ b/drivers/gpu/drm/i915/display/intel_crt.c
@@ -456,6 +456,8 @@ static int hsw_crt_compute_config(struct intel_encoder *encoder,
 	/* FDI must always be 2.7 GHz */
 	pipe_config->port_clock = 135000 * 2;
 
+	pipe_config->enhanced_framing = true;
+
 	adjusted_mode->crtc_clock = lpt_iclkip(pipe_config);
 
 	return 0;
diff --git a/drivers/gpu/drm/i915/display/intel_crtc_state_dump.c b/drivers/gpu/drm/i915/display/intel_crtc_state_dump.c
index 8b34fa55fa1bd..66fe880af8f3f 100644
--- a/drivers/gpu/drm/i915/display/intel_crtc_state_dump.c
+++ b/drivers/gpu/drm/i915/display/intel_crtc_state_dump.c
@@ -258,8 +258,9 @@ void intel_crtc_state_dump(const struct intel_crtc_state *pipe_config,
 		intel_dump_m_n_config(pipe_config, "dp m2_n2",
 				      pipe_config->lane_count,
 				      &pipe_config->dp_m2_n2);
-		drm_dbg_kms(&i915->drm, "fec: %s\n",
-			    str_enabled_disabled(pipe_config->fec_enable));
+		drm_dbg_kms(&i915->drm, "fec: %s, enhanced framing: %s\n",
+			    str_enabled_disabled(pipe_config->fec_enable),
+			    str_enabled_disabled(pipe_config->enhanced_framing));
 	}
 
 	drm_dbg_kms(&i915->drm, "framestart delay: %d, MSA timing delay: %d\n",
diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 85e2263e688de..c7e00f57cb7ab 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -3432,7 +3432,7 @@ static void mtl_ddi_prepare_link_retrain(struct intel_dp *intel_dp,
 		dp_tp_ctl |= DP_TP_CTL_MODE_MST;
 	} else {
 		dp_tp_ctl |= DP_TP_CTL_MODE_SST;
-		if (drm_dp_enhanced_frame_cap(intel_dp->dpcd))
+		if (crtc_state->enhanced_framing)
 			dp_tp_ctl |= DP_TP_CTL_ENHANCED_FRAME_ENABLE;
 	}
 	intel_de_write(dev_priv, dp_tp_ctl_reg(encoder, crtc_state), dp_tp_ctl);
@@ -3489,7 +3489,7 @@ static void intel_ddi_prepare_link_retrain(struct intel_dp *intel_dp,
 		dp_tp_ctl |= DP_TP_CTL_MODE_MST;
 	} else {
 		dp_tp_ctl |= DP_TP_CTL_MODE_SST;
-		if (drm_dp_enhanced_frame_cap(intel_dp->dpcd))
+		if (crtc_state->enhanced_framing)
 			dp_tp_ctl |= DP_TP_CTL_ENHANCED_FRAME_ENABLE;
 	}
 	intel_de_write(dev_priv, dp_tp_ctl_reg(encoder, crtc_state), dp_tp_ctl);
@@ -3724,6 +3724,10 @@ static void intel_ddi_read_func_ctl(struct intel_encoder *encoder,
 		intel_cpu_transcoder_get_m2_n2(crtc, cpu_transcoder,
 					       &pipe_config->dp_m2_n2);
 
+		pipe_config->enhanced_framing =
+			intel_de_read(dev_priv, dp_tp_ctl_reg(encoder, pipe_config)) &
+			DP_TP_CTL_ENHANCED_FRAME_ENABLE;
+
 		if (DISPLAY_VER(dev_priv) >= 11)
 			pipe_config->fec_enable =
 				intel_de_read(dev_priv,
@@ -3740,6 +3744,9 @@ static void intel_ddi_read_func_ctl(struct intel_encoder *encoder,
 		if (!HAS_DP20(dev_priv)) {
 			/* FDI */
 			pipe_config->output_types |= BIT(INTEL_OUTPUT_ANALOG);
+			pipe_config->enhanced_framing =
+				intel_de_read(dev_priv, dp_tp_ctl_reg(encoder, pipe_config)) &
+				DP_TP_CTL_ENHANCED_FRAME_ENABLE;
 			break;
 		}
 		fallthrough; /* 128b/132b */
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 1e2b09ae09b9c..2d9d96ecbb251 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -5255,6 +5255,7 @@ intel_pipe_config_compare(const struct intel_crtc_state *current_config,
 	PIPE_CONF_CHECK_BOOL(hdmi_scrambling);
 	PIPE_CONF_CHECK_BOOL(hdmi_high_tmds_clock_ratio);
 	PIPE_CONF_CHECK_BOOL(has_infoframe);
+	PIPE_CONF_CHECK_BOOL(enhanced_framing);
 	PIPE_CONF_CHECK_BOOL(fec_enable);
 
 	PIPE_CONF_CHECK_BOOL_INCOMPLETE(has_audio);
diff --git a/drivers/gpu/drm/i915/display/intel_display_types.h b/drivers/gpu/drm/i915/display/intel_display_types.h
index 731f2ec04d5cd..7fc92b1474cc4 100644
--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1362,6 +1362,8 @@ struct intel_crtc_state {
 	u16 linetime;
 	u16 ips_linetime;
 
+	bool enhanced_framing;
+
 	/* Forward Error correction State */
 	bool fec_enable;
 
diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 66e35f8443e1a..b4fb7ce39d06f 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -2312,6 +2312,9 @@ intel_dp_compute_config(struct intel_encoder *encoder,
 	pipe_config->limited_color_range =
 		intel_dp_limited_color_range(pipe_config, conn_state);
 
+	pipe_config->enhanced_framing =
+		drm_dp_enhanced_frame_cap(intel_dp->dpcd);
+
 	if (pipe_config->dsc.compression_enable)
 		output_bpp = pipe_config->dsc.compressed_bpp;
 	else
diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
index a263773f4d68a..d09e43a38fa61 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -655,7 +655,7 @@ intel_dp_update_link_bw_set(struct intel_dp *intel_dp,
 	/* Write the link configuration data */
 	link_config[0] = link_bw;
 	link_config[1] = crtc_state->lane_count;
-	if (drm_dp_enhanced_frame_cap(intel_dp->dpcd))
+	if (crtc_state->enhanced_framing)
 		link_config[1] |= DP_LANE_COUNT_ENHANCED_FRAME_EN;
 	drm_dp_dpcd_write(&intel_dp->aux, DP_LINK_BW_SET, link_config, 2);
 
-- 
2.43.0



