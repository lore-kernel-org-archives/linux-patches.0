Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703B152F8E;
	Mon, 11 Dec 2023 18:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBXCWE1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C48C433C9;
	Mon, 11 Dec 2023 18:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319709;
	bh=Ke0kyGUzUReOuwLUfV/h0UI1vTlaGoz/Pqwy0oTlcig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBXCWE1TFZKvSG1EQalyK1aLmqrgWGIpy4l+qEElzBIMsc5zhymUBXpu82TY/0Mzr
	 l2NIz6iqOU4Sy+35aVUHZxRNj6ejQxmi97OMpl9eLlbIDg5hLq7dfwH0rQ3/3Y/Pya
	 o4r3ObmH3qkXr5zKYIoaes7W+lV97w9qyWXAweaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.6 175/244] drm/i915: Skip some timing checks on BXT/GLK DSI transcoders
Date: Mon, 11 Dec 2023 19:21:08 +0100
Message-ID: <20231211182053.777710521@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

commit 20c2dbff342aec13bf93c2f6c951da198916a455 upstream.

Apparently some BXT/GLK systems have DSI panels whose timings
don't agree with the normal cpu transcoder hblank>=32 limitation.
This is perhaps fine as there are no specific hblank/etc. limits
listed for the BXT/GLK DSI transcoders.

Move those checks out from the global intel_mode_valid() into
into connector specific .mode_valid() hooks, skipping BXT/GLK
DSI connectors. We'll leave the basic [hv]display/[hv]total
checks in intel_mode_valid() as those seem like sensible upper
limits regardless of the transcoder used.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/9720
Fixes: 8f4b1068e7fc ("drm/i915: Check some transcoder timing minimum limits")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231127145028.4899-1-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit e0ef2daa8ca8ce4dbc2fd0959e383b753a87fd7d)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/icl_dsi.c       |    7 +++++++
 drivers/gpu/drm/i915/display/intel_crt.c     |    5 +++++
 drivers/gpu/drm/i915/display/intel_display.c |   10 ++++++++++
 drivers/gpu/drm/i915/display/intel_display.h |    3 +++
 drivers/gpu/drm/i915/display/intel_dp.c      |    4 ++++
 drivers/gpu/drm/i915/display/intel_dp_mst.c  |    4 ++++
 drivers/gpu/drm/i915/display/intel_dvo.c     |    6 ++++++
 drivers/gpu/drm/i915/display/intel_hdmi.c    |    4 ++++
 drivers/gpu/drm/i915/display/intel_lvds.c    |    5 +++++
 drivers/gpu/drm/i915/display/intel_sdvo.c    |    8 +++++++-
 drivers/gpu/drm/i915/display/intel_tv.c      |    8 +++++++-
 drivers/gpu/drm/i915/display/vlv_dsi.c       |   18 +++++++++++++++++-
 12 files changed, 79 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -1440,6 +1440,13 @@ static void gen11_dsi_post_disable(struc
 static enum drm_mode_status gen11_dsi_mode_valid(struct drm_connector *connector,
 						 struct drm_display_mode *mode)
 {
+	struct drm_i915_private *i915 = to_i915(connector->dev);
+	enum drm_mode_status status;
+
+	status = intel_cpu_transcoder_mode_valid(i915, mode);
+	if (status != MODE_OK)
+		return status;
+
 	/* FIXME: DSC? */
 	return intel_dsi_mode_valid(connector, mode);
 }
--- a/drivers/gpu/drm/i915/display/intel_crt.c
+++ b/drivers/gpu/drm/i915/display/intel_crt.c
@@ -348,8 +348,13 @@ intel_crt_mode_valid(struct drm_connecto
 	struct drm_device *dev = connector->dev;
 	struct drm_i915_private *dev_priv = to_i915(dev);
 	int max_dotclk = dev_priv->max_dotclk_freq;
+	enum drm_mode_status status;
 	int max_clock;
 
+	status = intel_cpu_transcoder_mode_valid(dev_priv, mode);
+	if (status != MODE_OK)
+		return status;
+
 	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
 		return MODE_NO_DBLESCAN;
 
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -7660,6 +7660,16 @@ enum drm_mode_status intel_mode_valid(st
 	    mode->vtotal > vtotal_max)
 		return MODE_V_ILLEGAL;
 
+	return MODE_OK;
+}
+
+enum drm_mode_status intel_cpu_transcoder_mode_valid(struct drm_i915_private *dev_priv,
+						     const struct drm_display_mode *mode)
+{
+	/*
+	 * Additional transcoder timing limits,
+	 * excluding BXT/GLK DSI transcoders.
+	 */
 	if (DISPLAY_VER(dev_priv) >= 5) {
 		if (mode->hdisplay < 64 ||
 		    mode->htotal - mode->hdisplay < 32)
--- a/drivers/gpu/drm/i915/display/intel_display.h
+++ b/drivers/gpu/drm/i915/display/intel_display.h
@@ -405,6 +405,9 @@ enum drm_mode_status
 intel_mode_valid_max_plane_size(struct drm_i915_private *dev_priv,
 				const struct drm_display_mode *mode,
 				bool bigjoiner);
+enum drm_mode_status
+intel_cpu_transcoder_mode_valid(struct drm_i915_private *i915,
+				const struct drm_display_mode *mode);
 enum phy intel_port_to_phy(struct drm_i915_private *i915, enum port port);
 bool is_trans_port_sync_mode(const struct intel_crtc_state *state);
 bool is_trans_port_sync_master(const struct intel_crtc_state *state);
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -1127,6 +1127,10 @@ intel_dp_mode_valid(struct drm_connector
 	enum drm_mode_status status;
 	bool dsc = false, bigjoiner = false;
 
+	status = intel_cpu_transcoder_mode_valid(dev_priv, mode);
+	if (status != MODE_OK)
+		return status;
+
 	if (mode->flags & DRM_MODE_FLAG_DBLCLK)
 		return MODE_H_ILLEGAL;
 
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -921,6 +921,10 @@ intel_dp_mst_mode_valid_ctx(struct drm_c
 		return 0;
 	}
 
+	*status = intel_cpu_transcoder_mode_valid(dev_priv, mode);
+	if (*status != MODE_OK)
+		return 0;
+
 	if (mode->flags & DRM_MODE_FLAG_DBLSCAN) {
 		*status = MODE_NO_DBLESCAN;
 		return 0;
--- a/drivers/gpu/drm/i915/display/intel_dvo.c
+++ b/drivers/gpu/drm/i915/display/intel_dvo.c
@@ -217,11 +217,17 @@ intel_dvo_mode_valid(struct drm_connecto
 		     struct drm_display_mode *mode)
 {
 	struct intel_connector *connector = to_intel_connector(_connector);
+	struct drm_i915_private *i915 = to_i915(connector->base.dev);
 	struct intel_dvo *intel_dvo = intel_attached_dvo(connector);
 	const struct drm_display_mode *fixed_mode =
 		intel_panel_fixed_mode(connector, mode);
 	int max_dotclk = to_i915(connector->base.dev)->max_dotclk_freq;
 	int target_clock = mode->clock;
+	enum drm_mode_status status;
+
+	status = intel_cpu_transcoder_mode_valid(i915, mode);
+	if (status != MODE_OK)
+		return status;
 
 	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
 		return MODE_NO_DBLESCAN;
--- a/drivers/gpu/drm/i915/display/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
@@ -1986,6 +1986,10 @@ intel_hdmi_mode_valid(struct drm_connect
 	bool ycbcr_420_only;
 	enum intel_output_format sink_format;
 
+	status = intel_cpu_transcoder_mode_valid(dev_priv, mode);
+	if (status != MODE_OK)
+		return status;
+
 	if ((mode->flags & DRM_MODE_FLAG_3D_MASK) == DRM_MODE_FLAG_3D_FRAME_PACKING)
 		clock *= 2;
 
--- a/drivers/gpu/drm/i915/display/intel_lvds.c
+++ b/drivers/gpu/drm/i915/display/intel_lvds.c
@@ -389,11 +389,16 @@ intel_lvds_mode_valid(struct drm_connect
 		      struct drm_display_mode *mode)
 {
 	struct intel_connector *connector = to_intel_connector(_connector);
+	struct drm_i915_private *i915 = to_i915(connector->base.dev);
 	const struct drm_display_mode *fixed_mode =
 		intel_panel_fixed_mode(connector, mode);
 	int max_pixclk = to_i915(connector->base.dev)->max_dotclk_freq;
 	enum drm_mode_status status;
 
+	status = intel_cpu_transcoder_mode_valid(i915, mode);
+	if (status != MODE_OK)
+		return status;
+
 	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
 		return MODE_NO_DBLESCAN;
 
--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -1906,13 +1906,19 @@ static enum drm_mode_status
 intel_sdvo_mode_valid(struct drm_connector *connector,
 		      struct drm_display_mode *mode)
 {
+	struct drm_i915_private *i915 = to_i915(connector->dev);
 	struct intel_sdvo *intel_sdvo = intel_attached_sdvo(to_intel_connector(connector));
 	struct intel_sdvo_connector *intel_sdvo_connector =
 		to_intel_sdvo_connector(connector);
-	int max_dotclk = to_i915(connector->dev)->max_dotclk_freq;
 	bool has_hdmi_sink = intel_has_hdmi_sink(intel_sdvo_connector, connector->state);
+	int max_dotclk = i915->max_dotclk_freq;
+	enum drm_mode_status status;
 	int clock = mode->clock;
 
+	status = intel_cpu_transcoder_mode_valid(i915, mode);
+	if (status != MODE_OK)
+		return status;
+
 	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
 		return MODE_NO_DBLESCAN;
 
--- a/drivers/gpu/drm/i915/display/intel_tv.c
+++ b/drivers/gpu/drm/i915/display/intel_tv.c
@@ -958,8 +958,14 @@ static enum drm_mode_status
 intel_tv_mode_valid(struct drm_connector *connector,
 		    struct drm_display_mode *mode)
 {
+	struct drm_i915_private *i915 = to_i915(connector->dev);
 	const struct tv_mode *tv_mode = intel_tv_mode_find(connector->state);
-	int max_dotclk = to_i915(connector->dev)->max_dotclk_freq;
+	int max_dotclk = i915->max_dotclk_freq;
+	enum drm_mode_status status;
+
+	status = intel_cpu_transcoder_mode_valid(i915, mode);
+	if (status != MODE_OK)
+		return status;
 
 	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
 		return MODE_NO_DBLESCAN;
--- a/drivers/gpu/drm/i915/display/vlv_dsi.c
+++ b/drivers/gpu/drm/i915/display/vlv_dsi.c
@@ -1540,9 +1540,25 @@ static const struct drm_encoder_funcs in
 	.destroy = intel_dsi_encoder_destroy,
 };
 
+static enum drm_mode_status vlv_dsi_mode_valid(struct drm_connector *connector,
+					       struct drm_display_mode *mode)
+{
+	struct drm_i915_private *i915 = to_i915(connector->dev);
+
+	if (IS_VALLEYVIEW(i915) || IS_CHERRYVIEW(i915)) {
+		enum drm_mode_status status;
+
+		status = intel_cpu_transcoder_mode_valid(i915, mode);
+		if (status != MODE_OK)
+			return status;
+	}
+
+	return intel_dsi_mode_valid(connector, mode);
+}
+
 static const struct drm_connector_helper_funcs intel_dsi_connector_helper_funcs = {
 	.get_modes = intel_dsi_get_modes,
-	.mode_valid = intel_dsi_mode_valid,
+	.mode_valid = vlv_dsi_mode_valid,
 	.atomic_check = intel_digital_connector_atomic_check,
 };
 


