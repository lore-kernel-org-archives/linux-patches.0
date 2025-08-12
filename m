Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CEA3F9D2;
	Tue, 12 Aug 2025 18:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023060; cv=none; b=KlGl2iIXrBOV6bzngZUmE413ohCtSDdEb76cbhE5MFHfpYtSSMZcqEfEUTzunmYAwvorF8r5ZyzfXoR5Dih5RzNWLhDVwaQ6tVZ81wU9i677u/giPNpqS36leHq+jQuxxY6SNMMwUQDTTTP0Q1ZF7l5Uzn6Xb1RW/nC4GpVtAU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023060; c=relaxed/simple;
	bh=N4TaGXRC7u9xrAB0iSAN1Bl8URYQ4SgfhTZg8xqnTho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfmaKho28iFV/8txumrOAsRUnPWcs5QTYgB1an2+7DlkNQWaiOSsKwhiE6RUkjAO3CkYm2jvWfN4xh7T0ENWHkQAJEfHsTZoncK4sRVLj+8UZfn2SgaAzD6ZL6+X06dPpc0hZratLdTyLImR5FA5AnEO5el5nEuImOFJpRaUHuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BVpmsweE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BVpmsweE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C29C4CEF0;
	Tue, 12 Aug 2025 18:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023058;
	bh=N4TaGXRC7u9xrAB0iSAN1Bl8URYQ4SgfhTZg8xqnTho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BVpmsweELko/0YIwk1yZyflDM2v/aIURDSWNktKFxFQ+QeKOgAnj3qAXwRQH1Z4g9
	 cXYu57+tE0gIZYf6VqF95YS9A+Ddr44B0XCnwPxIXdpbe9WrdPH8P9Uq+N7cN7CKom
	 JKFTN6FprS3oHiGf8zs5R7AykMjpz3LCNDjCfTGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Ville Syrjala <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.12 337/369] drm/i915/hdmi: add error handling in g4x_hdmi_init()
Date: Tue, 12 Aug 2025 19:30:34 +0200
Message-ID: <20250812173029.379913410@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 7603ba81225c815d2ceb4ad52f13e8df4b9d03cc upstream.

Handle encoder and connector init failures in g4x_hdmi_init(). This is
similar to g4x_dp_init().

Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Reported-and-tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Closes: https://lore.kernel.org/r/20241031105145.2140590-1-senozhatsky@chromium.org
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/cafae7bf1f9ffb8f6a1d7a508cd2ce7dcf06fef7.1735568047.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/g4x_hdmi.c |   35 +++++++++++++++++++++-----------
 drivers/gpu/drm/i915/display/g4x_hdmi.h |    5 ++--
 2 files changed, 26 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/i915/display/g4x_hdmi.c
+++ b/drivers/gpu/drm/i915/display/g4x_hdmi.c
@@ -683,7 +683,7 @@ static bool assert_hdmi_port_valid(struc
 			 "Platform does not support HDMI %c\n", port_name(port));
 }
 
-void g4x_hdmi_init(struct drm_i915_private *dev_priv,
+bool g4x_hdmi_init(struct drm_i915_private *dev_priv,
 		   i915_reg_t hdmi_reg, enum port port)
 {
 	struct intel_display *display = &dev_priv->display;
@@ -693,10 +693,10 @@ void g4x_hdmi_init(struct drm_i915_priva
 	struct intel_connector *intel_connector;
 
 	if (!assert_port_valid(dev_priv, port))
-		return;
+		return false;
 
 	if (!assert_hdmi_port_valid(dev_priv, port))
-		return;
+		return false;
 
 	devdata = intel_bios_encoder_data_lookup(display, port);
 
@@ -707,15 +707,13 @@ void g4x_hdmi_init(struct drm_i915_priva
 
 	dig_port = kzalloc(sizeof(*dig_port), GFP_KERNEL);
 	if (!dig_port)
-		return;
+		return false;
 
 	dig_port->aux_ch = AUX_CH_NONE;
 
 	intel_connector = intel_connector_alloc();
-	if (!intel_connector) {
-		kfree(dig_port);
-		return;
-	}
+	if (!intel_connector)
+		goto err_connector_alloc;
 
 	intel_encoder = &dig_port->base;
 
@@ -723,9 +721,10 @@ void g4x_hdmi_init(struct drm_i915_priva
 
 	mutex_init(&dig_port->hdcp_mutex);
 
-	drm_encoder_init(&dev_priv->drm, &intel_encoder->base,
-			 &intel_hdmi_enc_funcs, DRM_MODE_ENCODER_TMDS,
-			 "HDMI %c", port_name(port));
+	if (drm_encoder_init(&dev_priv->drm, &intel_encoder->base,
+			     &intel_hdmi_enc_funcs, DRM_MODE_ENCODER_TMDS,
+			     "HDMI %c", port_name(port)))
+		goto err_encoder_init;
 
 	intel_encoder->hotplug = intel_hdmi_hotplug;
 	intel_encoder->compute_config = g4x_hdmi_compute_config;
@@ -788,5 +787,17 @@ void g4x_hdmi_init(struct drm_i915_priva
 
 	intel_infoframe_init(dig_port);
 
-	intel_hdmi_init_connector(dig_port, intel_connector);
+	if (!intel_hdmi_init_connector(dig_port, intel_connector))
+		goto err_init_connector;
+
+	return true;
+
+err_init_connector:
+	drm_encoder_cleanup(&intel_encoder->base);
+err_encoder_init:
+	kfree(intel_connector);
+err_connector_alloc:
+	kfree(dig_port);
+
+	return false;
 }
--- a/drivers/gpu/drm/i915/display/g4x_hdmi.h
+++ b/drivers/gpu/drm/i915/display/g4x_hdmi.h
@@ -16,14 +16,15 @@ struct drm_connector;
 struct drm_i915_private;
 
 #ifdef I915
-void g4x_hdmi_init(struct drm_i915_private *dev_priv,
+bool g4x_hdmi_init(struct drm_i915_private *dev_priv,
 		   i915_reg_t hdmi_reg, enum port port);
 int g4x_hdmi_connector_atomic_check(struct drm_connector *connector,
 				    struct drm_atomic_state *state);
 #else
-static inline void g4x_hdmi_init(struct drm_i915_private *dev_priv,
+static inline bool g4x_hdmi_init(struct drm_i915_private *dev_priv,
 				 i915_reg_t hdmi_reg, int port)
 {
+	return false;
 }
 static inline int g4x_hdmi_connector_atomic_check(struct drm_connector *connector,
 						  struct drm_atomic_state *state)


