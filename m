Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8AA2EAE5;
	Thu, 11 Apr 2024 10:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829652; cv=none; b=rboqI/mvESR+mQ4stYMlQvpAToNvfXX5QQqIJtyzB4t0AHxkuLtTV3vU6agBe3Ih1MmAIwkF3eyGHaE+EJtBjBUNZdHr1/QEhIUrg52wHf1JUAC2X9Lnba0obsU1BYrpNNzaDolE+CUBsT8FKhaLoqGtiVQA4uz2f004CfKWBkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829652; c=relaxed/simple;
	bh=UvGcaGw3J0975VjgPE7EdMngo7vFiOSXyVSzH6MRuWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6SroJDojdSOZXYxG2Ad7r0bnl0rRAAt2qs75U7voXlJMnGd5Cp6fJTHjcfQ6F6qJrk1wU5KTiW7ebNYq/0sUxp+p5PHLFzFBTAAZEC5byoMWREK9eHiLX3oqM6t4KZfn8gcMCiS7tpD8oLQEVKI3VdwLSb2LfSiW4YynU0dtNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1UQ54Fje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1UQ54Fje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5713C433F1;
	Thu, 11 Apr 2024 10:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829652;
	bh=UvGcaGw3J0975VjgPE7EdMngo7vFiOSXyVSzH6MRuWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1UQ54FjemO3nnnp+gnnv2+9xNPUhfZseRRWIbOiiQnthnGfcq2Os6bmXIYd49i+Yk
	 h3lP9hZCW9SZUWttYR3jZa4now+/d4yR1o+OH1nrFMMWRIcYhIsBbRX5VijJlJFsd9
	 bF4I+l5CaE25lZB6TPG6Op0451ZAPFTbqmV1iXOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 059/175] drm/imx: pd: Use bus format/flags provided by the bridge when available
Date: Thu, 11 Apr 2024 11:54:42 +0200
Message-ID: <20240411095421.343366883@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit fe141cedc4333e3b76307f096e02b2c1e60f65d5 ]

Now that bridges can expose the bus format/flags they expect, we can
use those instead of the relying on the display_info provided by the
connector (which is only valid if the encoder is directly connected
to bridge element driving the panel/display).

We also explicitly expose the bus formats supported by our encoder by
filling encoder->output_bus_caps with proper info.

v10:
* Add changelog to the commit message
* Use kmalloc() instead of kcalloc()
* Add a dev_warn() when unsupported flags are requested

v8 -> v9:
* No changes

v7:
* Add an imx_pd_format_supported() helper (suggested by Philipp)
* Simplify imx_pd_bridge_atomic_get_output_bus_fmts() (suggested by Philipp)
* Simplify imx_pd_bridge_atomic_get_input_bus_fmts()
* Explicitly set the duplicate/destro_state() and reset() hooks

v4 -> v6:
* Patch was not part of the series

v3 (all suggested by Philipp):
* Adjust to match core changes
* Propagate output format to input format
* Pick a default value when output_fmt = _FIXED
* Add missing BGR888 and GBR888 fmts to imx_pd_bus_fmts[]

v2:
* Adjust things to match the new bus-format negotiation infra

Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20200128135514.108171-8-boris.brezillon@collabora.com
Stable-dep-of: c2da9ada6496 ("drm/imx/ipuv3: do not return negative values from .get_modes()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/parallel-display.c | 176 +++++++++++++++++++++----
 1 file changed, 151 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/imx/parallel-display.c b/drivers/gpu/drm/imx/parallel-display.c
index e9dff31b377c4..a96d99cbec4d0 100644
--- a/drivers/gpu/drm/imx/parallel-display.c
+++ b/drivers/gpu/drm/imx/parallel-display.c
@@ -29,6 +29,7 @@
 struct imx_parallel_display {
 	struct drm_connector connector;
 	struct drm_encoder encoder;
+	struct drm_bridge bridge;
 	struct device *dev;
 	void *edid;
 	int edid_len;
@@ -36,7 +37,7 @@ struct imx_parallel_display {
 	u32 bus_flags;
 	struct drm_display_mode mode;
 	struct drm_panel *panel;
-	struct drm_bridge *bridge;
+	struct drm_bridge *next_bridge;
 };
 
 static inline struct imx_parallel_display *con_to_imxpd(struct drm_connector *c)
@@ -49,6 +50,11 @@ static inline struct imx_parallel_display *enc_to_imxpd(struct drm_encoder *e)
 	return container_of(e, struct imx_parallel_display, encoder);
 }
 
+static inline struct imx_parallel_display *bridge_to_imxpd(struct drm_bridge *b)
+{
+	return container_of(b, struct imx_parallel_display, bridge);
+}
+
 static int imx_pd_connector_get_modes(struct drm_connector *connector)
 {
 	struct imx_parallel_display *imxpd = con_to_imxpd(connector);
@@ -99,37 +105,148 @@ static struct drm_encoder *imx_pd_connector_best_encoder(
 	return &imxpd->encoder;
 }
 
-static void imx_pd_encoder_enable(struct drm_encoder *encoder)
+static void imx_pd_bridge_enable(struct drm_bridge *bridge)
 {
-	struct imx_parallel_display *imxpd = enc_to_imxpd(encoder);
+	struct imx_parallel_display *imxpd = bridge_to_imxpd(bridge);
 
 	drm_panel_prepare(imxpd->panel);
 	drm_panel_enable(imxpd->panel);
 }
 
-static void imx_pd_encoder_disable(struct drm_encoder *encoder)
+static void imx_pd_bridge_disable(struct drm_bridge *bridge)
 {
-	struct imx_parallel_display *imxpd = enc_to_imxpd(encoder);
+	struct imx_parallel_display *imxpd = bridge_to_imxpd(bridge);
 
 	drm_panel_disable(imxpd->panel);
 	drm_panel_unprepare(imxpd->panel);
 }
 
-static int imx_pd_encoder_atomic_check(struct drm_encoder *encoder,
-				       struct drm_crtc_state *crtc_state,
-				       struct drm_connector_state *conn_state)
+static const u32 imx_pd_bus_fmts[] = {
+	MEDIA_BUS_FMT_RGB888_1X24,
+	MEDIA_BUS_FMT_BGR888_1X24,
+	MEDIA_BUS_FMT_GBR888_1X24,
+	MEDIA_BUS_FMT_RGB666_1X18,
+	MEDIA_BUS_FMT_RGB666_1X24_CPADHI,
+	MEDIA_BUS_FMT_RGB565_1X16,
+};
+
+static u32 *
+imx_pd_bridge_atomic_get_output_bus_fmts(struct drm_bridge *bridge,
+					 struct drm_bridge_state *bridge_state,
+					 struct drm_crtc_state *crtc_state,
+					 struct drm_connector_state *conn_state,
+					 unsigned int *num_output_fmts)
 {
-	struct imx_crtc_state *imx_crtc_state = to_imx_crtc_state(crtc_state);
 	struct drm_display_info *di = &conn_state->connector->display_info;
-	struct imx_parallel_display *imxpd = enc_to_imxpd(encoder);
+	struct imx_parallel_display *imxpd = bridge_to_imxpd(bridge);
+	u32 *output_fmts;
 
-	if (!imxpd->bus_format && di->num_bus_formats) {
-		imx_crtc_state->bus_flags = di->bus_flags;
-		imx_crtc_state->bus_format = di->bus_formats[0];
-	} else {
-		imx_crtc_state->bus_flags = imxpd->bus_flags;
-		imx_crtc_state->bus_format = imxpd->bus_format;
+	if (!imxpd->bus_format && !di->num_bus_formats) {
+		*num_output_fmts = ARRAY_SIZE(imx_pd_bus_fmts);
+		return kmemdup(imx_pd_bus_fmts, sizeof(imx_pd_bus_fmts),
+			       GFP_KERNEL);
+	}
+
+	*num_output_fmts = 1;
+	output_fmts = kmalloc(sizeof(*output_fmts), GFP_KERNEL);
+	if (!output_fmts)
+		return NULL;
+
+	if (!imxpd->bus_format && di->num_bus_formats)
+		output_fmts[0] = di->bus_formats[0];
+	else
+		output_fmts[0] = imxpd->bus_format;
+
+	return output_fmts;
+}
+
+static bool imx_pd_format_supported(u32 output_fmt)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(imx_pd_bus_fmts); i++) {
+		if (imx_pd_bus_fmts[i] == output_fmt)
+			return true;
+	}
+
+	return false;
+}
+
+static u32 *
+imx_pd_bridge_atomic_get_input_bus_fmts(struct drm_bridge *bridge,
+					struct drm_bridge_state *bridge_state,
+					struct drm_crtc_state *crtc_state,
+					struct drm_connector_state *conn_state,
+					u32 output_fmt,
+					unsigned int *num_input_fmts)
+{
+	struct imx_parallel_display *imxpd = bridge_to_imxpd(bridge);
+	u32 *input_fmts;
+
+	/*
+	 * If the next bridge does not support bus format negotiation, let's
+	 * use the static bus format definition (imxpd->bus_format) if it's
+	 * specified, RGB888 when it's not.
+	 */
+	if (output_fmt == MEDIA_BUS_FMT_FIXED)
+		output_fmt = imxpd->bus_format ? : MEDIA_BUS_FMT_RGB888_1X24;
+
+	/* Now make sure the requested output format is supported. */
+	if ((imxpd->bus_format && imxpd->bus_format != output_fmt) ||
+	    !imx_pd_format_supported(output_fmt)) {
+		*num_input_fmts = 0;
+		return NULL;
+	}
+
+	*num_input_fmts = 1;
+	input_fmts = kmalloc(sizeof(*input_fmts), GFP_KERNEL);
+	if (!input_fmts)
+		return NULL;
+
+	input_fmts[0] = output_fmt;
+	return input_fmts;
+}
+
+static int imx_pd_bridge_atomic_check(struct drm_bridge *bridge,
+				      struct drm_bridge_state *bridge_state,
+				      struct drm_crtc_state *crtc_state,
+				      struct drm_connector_state *conn_state)
+{
+	struct imx_crtc_state *imx_crtc_state = to_imx_crtc_state(crtc_state);
+	struct drm_display_info *di = &conn_state->connector->display_info;
+	struct imx_parallel_display *imxpd = bridge_to_imxpd(bridge);
+	struct drm_bridge_state *next_bridge_state = NULL;
+	struct drm_bridge *next_bridge;
+	u32 bus_flags, bus_fmt;
+
+	next_bridge = drm_bridge_get_next_bridge(bridge);
+	if (next_bridge)
+		next_bridge_state = drm_atomic_get_new_bridge_state(crtc_state->state,
+								    next_bridge);
+
+	if (next_bridge_state)
+		bus_flags = next_bridge_state->input_bus_cfg.flags;
+	else if (!imxpd->bus_format && di->num_bus_formats)
+		bus_flags = di->bus_flags;
+	else
+		bus_flags = imxpd->bus_flags;
+
+	bus_fmt = bridge_state->input_bus_cfg.format;
+	if (!imx_pd_format_supported(bus_fmt))
+		return -EINVAL;
+
+	if (bus_flags &
+	    ~(DRM_BUS_FLAG_DE_LOW | DRM_BUS_FLAG_DE_HIGH |
+	      DRM_BUS_FLAG_PIXDATA_DRIVE_POSEDGE |
+	      DRM_BUS_FLAG_PIXDATA_DRIVE_NEGEDGE)) {
+		dev_warn(imxpd->dev, "invalid bus_flags (%x)\n", bus_flags);
+		return -EINVAL;
 	}
+
+	bridge_state->output_bus_cfg.flags = bus_flags;
+	bridge_state->input_bus_cfg.flags = bus_flags;
+	imx_crtc_state->bus_flags = bus_flags;
+	imx_crtc_state->bus_format = bridge_state->input_bus_cfg.format;
 	imx_crtc_state->di_hsync_pin = 2;
 	imx_crtc_state->di_vsync_pin = 3;
 
@@ -153,10 +270,15 @@ static const struct drm_encoder_funcs imx_pd_encoder_funcs = {
 	.destroy = imx_drm_encoder_destroy,
 };
 
-static const struct drm_encoder_helper_funcs imx_pd_encoder_helper_funcs = {
-	.enable = imx_pd_encoder_enable,
-	.disable = imx_pd_encoder_disable,
-	.atomic_check = imx_pd_encoder_atomic_check,
+static const struct drm_bridge_funcs imx_pd_bridge_funcs = {
+	.enable = imx_pd_bridge_enable,
+	.disable = imx_pd_bridge_disable,
+	.atomic_reset = drm_atomic_helper_bridge_reset,
+	.atomic_duplicate_state = drm_atomic_helper_bridge_duplicate_state,
+	.atomic_destroy_state = drm_atomic_helper_bridge_destroy_state,
+	.atomic_check = imx_pd_bridge_atomic_check,
+	.atomic_get_input_bus_fmts = imx_pd_bridge_atomic_get_input_bus_fmts,
+	.atomic_get_output_bus_fmts = imx_pd_bridge_atomic_get_output_bus_fmts,
 };
 
 static int imx_pd_register(struct drm_device *drm,
@@ -176,11 +298,13 @@ static int imx_pd_register(struct drm_device *drm,
 	 */
 	imxpd->connector.dpms = DRM_MODE_DPMS_OFF;
 
-	drm_encoder_helper_add(encoder, &imx_pd_encoder_helper_funcs);
 	drm_encoder_init(drm, encoder, &imx_pd_encoder_funcs,
 			 DRM_MODE_ENCODER_NONE, NULL);
 
-	if (!imxpd->bridge) {
+	imxpd->bridge.funcs = &imx_pd_bridge_funcs;
+	drm_bridge_attach(encoder, &imxpd->bridge, NULL);
+
+	if (!imxpd->next_bridge) {
 		drm_connector_helper_add(&imxpd->connector,
 				&imx_pd_connector_helper_funcs);
 		drm_connector_init(drm, &imxpd->connector,
@@ -191,8 +315,9 @@ static int imx_pd_register(struct drm_device *drm,
 	if (imxpd->panel)
 		drm_panel_attach(imxpd->panel, &imxpd->connector);
 
-	if (imxpd->bridge) {
-		ret = drm_bridge_attach(encoder, imxpd->bridge, NULL);
+	if (imxpd->next_bridge) {
+		ret = drm_bridge_attach(encoder, imxpd->next_bridge,
+					&imxpd->bridge);
 		if (ret < 0) {
 			dev_err(imxpd->dev, "failed to attach bridge: %d\n",
 				ret);
@@ -237,7 +362,8 @@ static int imx_pd_bind(struct device *dev, struct device *master, void *data)
 	imxpd->bus_format = bus_format;
 
 	/* port@1 is the output port */
-	ret = drm_of_find_panel_or_bridge(np, 1, 0, &imxpd->panel, &imxpd->bridge);
+	ret = drm_of_find_panel_or_bridge(np, 1, 0, &imxpd->panel,
+					  &imxpd->next_bridge);
 	if (ret && ret != -ENODEV)
 		return ret;
 
-- 
2.43.0



