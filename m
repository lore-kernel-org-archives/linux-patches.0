Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E550451C37;
	Mon, 11 Dec 2023 18:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tw70ANe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD07C433C8;
	Mon, 11 Dec 2023 18:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320797;
	bh=b9yN0ETCg6H9f7VxAx/nIsWofeAMFoZ1kdEXDsZnx/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tw70ANe4/JV4ozWYiNi6dGymnwCqEBhJwM7MPuyHttbNePdD44Ei/Jd0unL3HSt68
	 JzcfXk5HmyR/r/Q4tA2mPCTiTBfrmnltqimD/F97DZ3ZVnvKa6ygI9ZugSOXlHQ+5v
	 EaJKe69dtpu4TOCYEFW9yFWZii3HU5u9kiBckEug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 194/194] drm/i915: Skip some timing checks on BXT/GLK DSI transcoders
Date: Mon, 11 Dec 2023 19:23:04 +0100
Message-ID: <20231211182045.361769302@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 20c2dbff342aec13bf93c2f6c951da198916a455 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/icl_dsi.c       |  7 +++++++
 drivers/gpu/drm/i915/display/intel_crt.c     |  5 +++++
 drivers/gpu/drm/i915/display/intel_display.c | 10 ++++++++++
 drivers/gpu/drm/i915/display/intel_display.h |  3 +++
 drivers/gpu/drm/i915/display/intel_dp.c      |  4 ++++
 drivers/gpu/drm/i915/display/intel_dp_mst.c  |  4 ++++
 drivers/gpu/drm/i915/display/intel_dvo.c     |  6 ++++++
 drivers/gpu/drm/i915/display/intel_hdmi.c    |  4 ++++
 drivers/gpu/drm/i915/display/intel_lvds.c    |  5 +++++
 drivers/gpu/drm/i915/display/intel_sdvo.c    |  8 +++++++-
 drivers/gpu/drm/i915/display/intel_tv.c      |  8 +++++++-
 drivers/gpu/drm/i915/display/vlv_dsi.c       | 18 +++++++++++++++++-
 12 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i915/display/icl_dsi.c
index 8219310025de5..f7422f0cf579d 100644
--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -1500,6 +1500,13 @@ static void gen11_dsi_post_disable(struct intel_atomic_state *state,
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
diff --git a/drivers/gpu/drm/i915/display/intel_crt.c b/drivers/gpu/drm/i915/display/intel_crt.c
index 4a8ff2f976085..e60b2cf84b851 100644
--- a/drivers/gpu/drm/i915/display/intel_crt.c
+++ b/drivers/gpu/drm/i915/display/intel_crt.c
@@ -343,8 +343,13 @@ intel_crt_mode_valid(struct drm_connector *connector,
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
 
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 96e679a176e94..1777a12f2f421 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -8229,6 +8229,16 @@ intel_mode_valid(struct drm_device *dev,
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
diff --git a/drivers/gpu/drm/i915/display/intel_display.h b/drivers/gpu/drm/i915/display/intel_display.h
index 884e8e67b17c7..b4f941674357b 100644
--- a/drivers/gpu/drm/i915/display/intel_display.h
+++ b/drivers/gpu/drm/i915/display/intel_display.h
@@ -554,6 +554,9 @@ enum drm_mode_status
 intel_mode_valid_max_plane_size(struct drm_i915_private *dev_priv,
 				const struct drm_display_mode *mode,
 				bool bigjoiner);
+enum drm_mode_status
+intel_cpu_transcoder_mode_valid(struct drm_i915_private *i915,
+				const struct drm_display_mode *mode);
 enum phy intel_port_to_phy(struct drm_i915_private *i915, enum port port);
 bool is_trans_port_sync_mode(const struct intel_crtc_state *state);
 bool intel_crtc_is_bigjoiner_slave(const struct intel_crtc_state *crtc_state);
diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index fd7c360bb44d7..5970f4149090f 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -973,6 +973,10 @@ intel_dp_mode_valid(struct drm_connector *_connector,
 	enum drm_mode_status status;
 	bool dsc = false, bigjoiner = false;
 
+	status = intel_cpu_transcoder_mode_valid(dev_priv, mode);
+	if (status != MODE_OK)
+		return status;
+
 	if (mode->flags & DRM_MODE_FLAG_DBLCLK)
 		return MODE_H_ILLEGAL;
 
diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index 9a6822256ddf6..eec32f682012c 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -703,6 +703,10 @@ intel_dp_mst_mode_valid_ctx(struct drm_connector *connector,
 		return 0;
 	}
 
+	*status = intel_cpu_transcoder_mode_valid(dev_priv, mode);
+	if (*status != MODE_OK)
+		return 0;
+
 	if (mode->flags & DRM_MODE_FLAG_DBLSCAN) {
 		*status = MODE_NO_DBLESCAN;
 		return 0;
diff --git a/drivers/gpu/drm/i915/display/intel_dvo.c b/drivers/gpu/drm/i915/display/intel_dvo.c
index 5572e43026e4d..511c589070087 100644
--- a/drivers/gpu/drm/i915/display/intel_dvo.c
+++ b/drivers/gpu/drm/i915/display/intel_dvo.c
@@ -225,10 +225,16 @@ intel_dvo_mode_valid(struct drm_connector *connector,
 {
 	struct intel_connector *intel_connector = to_intel_connector(connector);
 	struct intel_dvo *intel_dvo = intel_attached_dvo(intel_connector);
+	struct drm_i915_private *i915 = to_i915(intel_connector->base.dev);
 	const struct drm_display_mode *fixed_mode =
 		intel_panel_fixed_mode(intel_connector, mode);
 	int max_dotclk = to_i915(connector->dev)->max_dotclk_freq;
 	int target_clock = mode->clock;
+	enum drm_mode_status status;
+
+	status = intel_cpu_transcoder_mode_valid(i915, mode);
+	if (status != MODE_OK)
+		return status;
 
 	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
 		return MODE_NO_DBLESCAN;
diff --git a/drivers/gpu/drm/i915/display/intel_hdmi.c b/drivers/gpu/drm/i915/display/intel_hdmi.c
index 4f31355d09a4e..2600019fc8b96 100644
--- a/drivers/gpu/drm/i915/display/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
@@ -1987,6 +1987,10 @@ intel_hdmi_mode_valid(struct drm_connector *connector,
 	bool has_hdmi_sink = intel_has_hdmi_sink(hdmi, connector->state);
 	bool ycbcr_420_only;
 
+	status = intel_cpu_transcoder_mode_valid(dev_priv, mode);
+	if (status != MODE_OK)
+		return status;
+
 	if ((mode->flags & DRM_MODE_FLAG_3D_MASK) == DRM_MODE_FLAG_3D_FRAME_PACKING)
 		clock *= 2;
 
diff --git a/drivers/gpu/drm/i915/display/intel_lvds.c b/drivers/gpu/drm/i915/display/intel_lvds.c
index e4606d9a25edb..40b5d3d3c7e14 100644
--- a/drivers/gpu/drm/i915/display/intel_lvds.c
+++ b/drivers/gpu/drm/i915/display/intel_lvds.c
@@ -389,11 +389,16 @@ intel_lvds_mode_valid(struct drm_connector *connector,
 		      struct drm_display_mode *mode)
 {
 	struct intel_connector *intel_connector = to_intel_connector(connector);
+	struct drm_i915_private *i915 = to_i915(intel_connector->base.dev);
 	const struct drm_display_mode *fixed_mode =
 		intel_panel_fixed_mode(intel_connector, mode);
 	int max_pixclk = to_i915(connector->dev)->max_dotclk_freq;
 	enum drm_mode_status status;
 
+	status = intel_cpu_transcoder_mode_valid(i915, mode);
+	if (status != MODE_OK)
+		return status;
+
 	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
 		return MODE_NO_DBLESCAN;
 
diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu/drm/i915/display/intel_sdvo.c
index c1a85128911e1..8294dddfd9de8 100644
--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -1873,13 +1873,19 @@ static enum drm_mode_status
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
 
diff --git a/drivers/gpu/drm/i915/display/intel_tv.c b/drivers/gpu/drm/i915/display/intel_tv.c
index dcf89d701f0f6..fb25be800e753 100644
--- a/drivers/gpu/drm/i915/display/intel_tv.c
+++ b/drivers/gpu/drm/i915/display/intel_tv.c
@@ -956,8 +956,14 @@ static enum drm_mode_status
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
diff --git a/drivers/gpu/drm/i915/display/vlv_dsi.c b/drivers/gpu/drm/i915/display/vlv_dsi.c
index 00c80f29ad999..114088ca59ed4 100644
--- a/drivers/gpu/drm/i915/display/vlv_dsi.c
+++ b/drivers/gpu/drm/i915/display/vlv_dsi.c
@@ -1627,9 +1627,25 @@ static const struct drm_encoder_funcs intel_dsi_funcs = {
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
 
-- 
2.42.0



