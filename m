Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4B81E009F;
	Wed,  6 Nov 2024 12:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896501; cv=none; b=p8foPrZzAi+M+HXHGJOLtLs9xtzp7/rFvO18w79PDfzwPJjFuvsYk2BSBbRKmVOJQacwnZ/Aq9E49UXY92qCeS7Ud8at1uvTQSheZEo7xhERpvS3VVAt5vvE9vvWxvksp2LW/+OqZ/viRrI92dAuu5jYc1af6M9Yv+7xr+Mg5rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896501; c=relaxed/simple;
	bh=/MH7jk2rdPG/5JiYvZJ6TDVaETN86+S9WtnMsz9oZMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFS4iR1lDC38fKBi7B2nHgPbP82jAiDeq5ORNxLrDfefn1SXVXwrFr8bC8K5z7gyWhxB5GCnGZmHr5Nwawo8had3v3q9LKYbS/WXieJkXhGkzGKlah2EdcGn45MTuergpviBrtn/SrIL0YnD0pj8KZ3+1YTCcbiBG8tYzvXZLl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Za0Pumq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Za0Pumq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F23C4CECD;
	Wed,  6 Nov 2024 12:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896501;
	bh=/MH7jk2rdPG/5JiYvZJ6TDVaETN86+S9WtnMsz9oZMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Za0PumqxgkNeIEu05uufcwHX8uX0Jab65TFBcqliE1+ypYmF0MDQ757zwK7yfVyW
	 ZHO3eb00Yr080fDfW0bTDOQV0gbncOD2NnjAsjR1QSC5B30maY3iR7443L6BTFsU53
	 x4KLsvcmEiHFFPaLwmRj/B3aVpRPvJGxxJuEZjNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Arun R Murthy <arun.r.murthy@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 223/245] drm/i915/display: Cache adpative sync caps to use it later
Date: Wed,  6 Nov 2024 13:04:36 +0100
Message-ID: <20241106120324.749033598@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

From: Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>

commit b2013783c4458a1fe8b25c0b249d2e878bcf6999 upstream.

Add new member to struct intel_dp to cache support of Adaptive Sync
SDP capabilities and use it whenever required to avoid HW access
to read capability during each atomic commit.

-v2:
- Squash both the patches

Signed-off-by: Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>
Reviewed-by: Arun R Murthy <arun.r.murthy@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240704082638.2302092-2-mitulkumar.ajitkumar.golani@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_alpm.c          |    2 -
 drivers/gpu/drm/i915/display/intel_display_types.h |    1 
 drivers/gpu/drm/i915/display/intel_dp.c            |   22 +++++++++++----------
 drivers/gpu/drm/i915/display/intel_dp.h            |    1 
 drivers/gpu/drm/i915/display/intel_vrr.c           |    3 --
 5 files changed, 15 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_alpm.c
+++ b/drivers/gpu/drm/i915/display/intel_alpm.c
@@ -280,7 +280,7 @@ void intel_alpm_lobf_compute_config(stru
 	if (DISPLAY_VER(i915) < 20)
 		return;
 
-	if (!intel_dp_as_sdp_supported(intel_dp))
+	if (!intel_dp->as_sdp_supported)
 		return;
 
 	if (crtc_state->has_psr)
--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1806,6 +1806,7 @@ struct intel_dp {
 
 	/* connector directly attached - won't be use for modeset in mst world */
 	struct intel_connector *attached_connector;
+	bool as_sdp_supported;
 
 	struct drm_dp_tunnel *tunnel;
 	bool tunnel_suspended:1;
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -130,14 +130,6 @@ bool intel_dp_is_edp(struct intel_dp *in
 	return dig_port->base.type == INTEL_OUTPUT_EDP;
 }
 
-bool intel_dp_as_sdp_supported(struct intel_dp *intel_dp)
-{
-	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
-
-	return HAS_AS_SDP(i915) &&
-		drm_dp_as_sdp_supported(&intel_dp->aux, intel_dp->dpcd);
-}
-
 static void intel_dp_unset_edid(struct intel_dp *intel_dp);
 
 /* Is link rate UHBR and thus 128b/132b? */
@@ -2635,8 +2627,7 @@ static void intel_dp_compute_as_sdp(stru
 	const struct drm_display_mode *adjusted_mode =
 		&crtc_state->hw.adjusted_mode;
 
-	if (!crtc_state->vrr.enable ||
-	    !intel_dp_as_sdp_supported(intel_dp))
+	if (!crtc_state->vrr.enable || intel_dp->as_sdp_supported)
 		return;
 
 	crtc_state->infoframes.enable |= intel_hdmi_infoframe_enable(DP_SDP_ADAPTIVE_SYNC);
@@ -5921,6 +5912,15 @@ intel_dp_detect_dsc_caps(struct intel_dp
 					  connector);
 }
 
+static void
+intel_dp_detect_sdp_caps(struct intel_dp *intel_dp)
+{
+	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
+
+	intel_dp->as_sdp_supported = HAS_AS_SDP(i915) &&
+		drm_dp_as_sdp_supported(&intel_dp->aux, intel_dp->dpcd);
+}
+
 static int
 intel_dp_detect(struct drm_connector *connector,
 		struct drm_modeset_acquire_ctx *ctx,
@@ -5991,6 +5991,8 @@ intel_dp_detect(struct drm_connector *co
 
 	intel_dp_detect_dsc_caps(intel_dp, intel_connector);
 
+	intel_dp_detect_sdp_caps(intel_dp);
+
 	intel_dp_mst_configure(intel_dp);
 
 	if (intel_dp->reset_link_params) {
--- a/drivers/gpu/drm/i915/display/intel_dp.h
+++ b/drivers/gpu/drm/i915/display/intel_dp.h
@@ -85,7 +85,6 @@ void intel_dp_audio_compute_config(struc
 				   struct drm_connector_state *conn_state);
 bool intel_dp_has_hdmi_sink(struct intel_dp *intel_dp);
 bool intel_dp_is_edp(struct intel_dp *intel_dp);
-bool intel_dp_as_sdp_supported(struct intel_dp *intel_dp);
 bool intel_dp_is_uhbr(const struct intel_crtc_state *crtc_state);
 bool intel_dp_has_dsc(const struct intel_connector *connector);
 int intel_dp_link_symbol_size(int rate);
--- a/drivers/gpu/drm/i915/display/intel_vrr.c
+++ b/drivers/gpu/drm/i915/display/intel_vrr.c
@@ -233,8 +233,7 @@ intel_vrr_compute_config(struct intel_cr
 		crtc_state->mode_flags |= I915_MODE_FLAG_VRR;
 	}
 
-	if (intel_dp_as_sdp_supported(intel_dp) &&
-	    crtc_state->vrr.enable) {
+	if (intel_dp->as_sdp_supported && crtc_state->vrr.enable) {
 		crtc_state->vrr.vsync_start =
 			(crtc_state->hw.adjusted_mode.crtc_vtotal -
 			 crtc_state->hw.adjusted_mode.vsync_start);


