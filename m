Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7304B482CB;
	Thu, 30 Nov 2023 16:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+E6+fM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA00BC433C9;
	Thu, 30 Nov 2023 16:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361534;
	bh=Vi6qW9819ZV9gD6MOgLYvuuPcqOVaSCSEAjcuUdO7OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+E6+fM5QIVqwXLcrVlDuu/z6XTZeQV7r8d5LxrZ6ejURQmMYsBLh1VPfHO8um4jy
	 lqso1RV8PzmvcAnshcwmMiPpYVJExMdO/VYZJ4ynfx1qPh3rciAASfclPNwU00vDnL
	 kh1+vA4DN7sQ+WeO+K5qFzfOMFjQ6Pzj7GcT7Sgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.6 061/112] drm/ast: Disconnect BMC if physical connector is connected
Date: Thu, 30 Nov 2023 16:21:48 +0000
Message-ID: <20231130162142.259400373@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 8d6ef26501b97243ee6c16b8187c5b38cb69b77d upstream.

Many user-space compositors fail with mode setting if a CRTC has
more than one connected connector. This is the case with the BMC
on Aspeed systems. Work around this problem by setting the BMC's
connector status to disconnected when the physical connector has
a display attached. This way compositors will only see one connected
connector at a time; either the physical one or the BMC.

Suggested-by: Jocelyn Falempe <jfalempe@redhat.com>
Fixes: e329cb53b45d ("drm/ast: Add BMC virtual connector")
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: <stable@vger.kernel.org> # v6.6+
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231116130217.22931-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ast/ast_drv.h  |   13 +++++++-
 drivers/gpu/drm/ast/ast_mode.c |   62 ++++++++++++++++++++++++++++++++++++-----
 2 files changed, 67 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -172,6 +172,17 @@ to_ast_sil164_connector(struct drm_conne
 	return container_of(connector, struct ast_sil164_connector, base);
 }
 
+struct ast_bmc_connector {
+	struct drm_connector base;
+	struct drm_connector *physical_connector;
+};
+
+static inline struct ast_bmc_connector *
+to_ast_bmc_connector(struct drm_connector *connector)
+{
+	return container_of(connector, struct ast_bmc_connector, base);
+}
+
 /*
  * Device
  */
@@ -216,7 +227,7 @@ struct ast_device {
 		} astdp;
 		struct {
 			struct drm_encoder encoder;
-			struct drm_connector connector;
+			struct ast_bmc_connector bmc_connector;
 		} bmc;
 	} output;
 
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -1767,6 +1767,30 @@ static const struct drm_encoder_funcs as
 	.destroy = drm_encoder_cleanup,
 };
 
+static int ast_bmc_connector_helper_detect_ctx(struct drm_connector *connector,
+					       struct drm_modeset_acquire_ctx *ctx,
+					       bool force)
+{
+	struct ast_bmc_connector *bmc_connector = to_ast_bmc_connector(connector);
+	struct drm_connector *physical_connector = bmc_connector->physical_connector;
+
+	/*
+	 * Most user-space compositors cannot handle more than one connected
+	 * connector per CRTC. Hence, we only mark the BMC as connected if the
+	 * physical connector is disconnected. If the physical connector's status
+	 * is connected or unknown, the BMC remains disconnected. This has no
+	 * effect on the output of the BMC.
+	 *
+	 * FIXME: Remove this logic once user-space compositors can handle more
+	 *        than one connector per CRTC. The BMC should always be connected.
+	 */
+
+	if (physical_connector && physical_connector->status == connector_status_disconnected)
+		return connector_status_connected;
+
+	return connector_status_disconnected;
+}
+
 static int ast_bmc_connector_helper_get_modes(struct drm_connector *connector)
 {
 	return drm_add_modes_noedid(connector, 4096, 4096);
@@ -1774,6 +1798,7 @@ static int ast_bmc_connector_helper_get_
 
 static const struct drm_connector_helper_funcs ast_bmc_connector_helper_funcs = {
 	.get_modes = ast_bmc_connector_helper_get_modes,
+	.detect_ctx = ast_bmc_connector_helper_detect_ctx,
 };
 
 static const struct drm_connector_funcs ast_bmc_connector_funcs = {
@@ -1784,12 +1809,33 @@ static const struct drm_connector_funcs
 	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
 };
 
-static int ast_bmc_output_init(struct ast_device *ast)
+static int ast_bmc_connector_init(struct drm_device *dev,
+				  struct ast_bmc_connector *bmc_connector,
+				  struct drm_connector *physical_connector)
+{
+	struct drm_connector *connector = &bmc_connector->base;
+	int ret;
+
+	ret = drm_connector_init(dev, connector, &ast_bmc_connector_funcs,
+				 DRM_MODE_CONNECTOR_VIRTUAL);
+	if (ret)
+		return ret;
+
+	drm_connector_helper_add(connector, &ast_bmc_connector_helper_funcs);
+
+	bmc_connector->physical_connector = physical_connector;
+
+	return 0;
+}
+
+static int ast_bmc_output_init(struct ast_device *ast,
+			       struct drm_connector *physical_connector)
 {
 	struct drm_device *dev = &ast->base;
 	struct drm_crtc *crtc = &ast->crtc;
 	struct drm_encoder *encoder = &ast->output.bmc.encoder;
-	struct drm_connector *connector = &ast->output.bmc.connector;
+	struct ast_bmc_connector *bmc_connector = &ast->output.bmc.bmc_connector;
+	struct drm_connector *connector = &bmc_connector->base;
 	int ret;
 
 	ret = drm_encoder_init(dev, encoder,
@@ -1799,13 +1845,10 @@ static int ast_bmc_output_init(struct as
 		return ret;
 	encoder->possible_crtcs = drm_crtc_mask(crtc);
 
-	ret = drm_connector_init(dev, connector, &ast_bmc_connector_funcs,
-				 DRM_MODE_CONNECTOR_VIRTUAL);
+	ret = ast_bmc_connector_init(dev, bmc_connector, physical_connector);
 	if (ret)
 		return ret;
 
-	drm_connector_helper_add(connector, &ast_bmc_connector_helper_funcs);
-
 	ret = drm_connector_attach_encoder(connector, encoder);
 	if (ret)
 		return ret;
@@ -1864,6 +1907,7 @@ static const struct drm_mode_config_func
 int ast_mode_config_init(struct ast_device *ast)
 {
 	struct drm_device *dev = &ast->base;
+	struct drm_connector *physical_connector = NULL;
 	int ret;
 
 	ret = drmm_mode_config_init(dev);
@@ -1904,23 +1948,27 @@ int ast_mode_config_init(struct ast_devi
 		ret = ast_vga_output_init(ast);
 		if (ret)
 			return ret;
+		physical_connector = &ast->output.vga.vga_connector.base;
 	}
 	if (ast->tx_chip_types & AST_TX_SIL164_BIT) {
 		ret = ast_sil164_output_init(ast);
 		if (ret)
 			return ret;
+		physical_connector = &ast->output.sil164.sil164_connector.base;
 	}
 	if (ast->tx_chip_types & AST_TX_DP501_BIT) {
 		ret = ast_dp501_output_init(ast);
 		if (ret)
 			return ret;
+		physical_connector = &ast->output.dp501.connector;
 	}
 	if (ast->tx_chip_types & AST_TX_ASTDP_BIT) {
 		ret = ast_astdp_output_init(ast);
 		if (ret)
 			return ret;
+		physical_connector = &ast->output.astdp.connector;
 	}
-	ret = ast_bmc_output_init(ast);
+	ret = ast_bmc_output_init(ast, physical_connector);
 	if (ret)
 		return ret;
 


