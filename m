Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BF93B8BAA;
	Wed, 21 Jan 2026 18:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020436; cv=none; b=r950mvX/8ADn3xcXJpQc/tnXi0rI4TIMw85eJxdxf7x7jIft2aLdY7/ZnIZXFkKGyqxAJv8TKbrQiqkvV+KBKL1j9it6sLzn984nhoXjinXszg92Pq+nhthqnm3t2c3R2MQef74w1iFTbFbH3B8jvFgGv/8QKhcFVTlmin0kXj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020436; c=relaxed/simple;
	bh=sPf8m4VkHeIvxK11AprUy9k/0Ocqc+lOR/cT2W1ciX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNknCbuR0V1APOorRqI/m20zb5KH4p0aSqmECyRXUidSOiVwyk30gwzxUXzprnOS4saz8XSmDKcVfXj1ira15Qgqv33fhSC4PYlixnHqHhuzKK99GDxfZsU0PTgavkLC+g6xBjCKydDL+xr1WerDWniymOWag2PqLURkWOazPfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=agIC0Q2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="agIC0Q2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A37C4CEF1;
	Wed, 21 Jan 2026 18:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020435;
	bh=sPf8m4VkHeIvxK11AprUy9k/0Ocqc+lOR/cT2W1ciX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agIC0Q2IqzR/jsMK9PO/hgiIaxviKb8Obhj4TA5rI/kWUrRyoh9wRCNHHsI4IgEV2
	 ZNO0W3K4CQObzn1AhPy0HbeNN/CTTQTBlh+SxG3qkIw7PJq4G/jAwJqytDy5S9Ms56
	 jZm+87B3W6szK3DANFRBXRZdC9eqLCdlG0aVYg6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ludovic Desroches <ludovic.desroches@microchip.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.18 157/198] drm/panel: simple: restore connector_type fallback
Date: Wed, 21 Jan 2026 19:16:25 +0100
Message-ID: <20260121181424.202395120@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Ludovic Desroches <ludovic.desroches@microchip.com>

commit 9380dc33cd6ae4a6857818fcefce31cf716f3fae upstream.

The switch from devm_kzalloc() + drm_panel_init() to
devm_drm_panel_alloc() introduced a regression.

Several panel descriptors do not set connector_type. For those panels,
panel_simple_probe() used to compute a connector type (currently DPI as a
fallback) and pass that value to drm_panel_init(). After the conversion
to devm_drm_panel_alloc(), the call unconditionally used
desc->connector_type instead, ignoring the computed fallback and
potentially passing DRM_MODE_CONNECTOR_Unknown, which
drm_panel_bridge_add() does not allow.

Move the connector_type validation / fallback logic before the
devm_drm_panel_alloc() call and pass the computed connector_type to
devm_drm_panel_alloc(), so panels without an explicit connector_type
once again get the DPI default.

Signed-off-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Fixes: de04bb0089a9 ("drm/panel/panel-simple: Use the new allocation in place of devm_kzalloc()")
Cc: stable@vger.kernel.org
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://lore.kernel.org/stable/20251126-lcd_panel_connector_type_fix-v2-1-c15835d1f7cb%40microchip.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20251218-lcd_panel_connector_type_fix-v3-1-ddcea6d8d7ef@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/panel-simple.c |   89 +++++++++++++++++------------------
 1 file changed, 44 insertions(+), 45 deletions(-)

--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -623,49 +623,6 @@ static struct panel_simple *panel_simple
 	if (IS_ERR(desc))
 		return ERR_CAST(desc);
 
-	panel = devm_drm_panel_alloc(dev, struct panel_simple, base,
-				     &panel_simple_funcs, desc->connector_type);
-	if (IS_ERR(panel))
-		return ERR_CAST(panel);
-
-	panel->desc = desc;
-
-	panel->supply = devm_regulator_get(dev, "power");
-	if (IS_ERR(panel->supply))
-		return ERR_CAST(panel->supply);
-
-	panel->enable_gpio = devm_gpiod_get_optional(dev, "enable",
-						     GPIOD_OUT_LOW);
-	if (IS_ERR(panel->enable_gpio))
-		return dev_err_cast_probe(dev, panel->enable_gpio,
-					  "failed to request GPIO\n");
-
-	err = of_drm_get_panel_orientation(dev->of_node, &panel->orientation);
-	if (err) {
-		dev_err(dev, "%pOF: failed to get orientation %d\n", dev->of_node, err);
-		return ERR_PTR(err);
-	}
-
-	ddc = of_parse_phandle(dev->of_node, "ddc-i2c-bus", 0);
-	if (ddc) {
-		panel->ddc = of_find_i2c_adapter_by_node(ddc);
-		of_node_put(ddc);
-
-		if (!panel->ddc)
-			return ERR_PTR(-EPROBE_DEFER);
-	}
-
-	if (!of_device_is_compatible(dev->of_node, "panel-dpi") &&
-	    !of_get_display_timing(dev->of_node, "panel-timing", &dt))
-		panel_simple_parse_panel_timing_node(dev, panel, &dt);
-
-	if (desc->connector_type == DRM_MODE_CONNECTOR_LVDS) {
-		/* Optional data-mapping property for overriding bus format */
-		err = panel_simple_override_nondefault_lvds_datamapping(dev, panel);
-		if (err)
-			goto free_ddc;
-	}
-
 	connector_type = desc->connector_type;
 	/* Catch common mistakes for panels. */
 	switch (connector_type) {
@@ -690,8 +647,7 @@ static struct panel_simple *panel_simple
 		break;
 	case DRM_MODE_CONNECTOR_eDP:
 		dev_warn(dev, "eDP panels moved to panel-edp\n");
-		err = -EINVAL;
-		goto free_ddc;
+		return ERR_PTR(-EINVAL);
 	case DRM_MODE_CONNECTOR_DSI:
 		if (desc->bpc != 6 && desc->bpc != 8)
 			dev_warn(dev, "Expected bpc in {6,8} but got: %u\n", desc->bpc);
@@ -720,6 +676,49 @@ static struct panel_simple *panel_simple
 		break;
 	}
 
+	panel = devm_drm_panel_alloc(dev, struct panel_simple, base,
+				     &panel_simple_funcs, connector_type);
+	if (IS_ERR(panel))
+		return ERR_CAST(panel);
+
+	panel->desc = desc;
+
+	panel->supply = devm_regulator_get(dev, "power");
+	if (IS_ERR(panel->supply))
+		return ERR_CAST(panel->supply);
+
+	panel->enable_gpio = devm_gpiod_get_optional(dev, "enable",
+						     GPIOD_OUT_LOW);
+	if (IS_ERR(panel->enable_gpio))
+		return dev_err_cast_probe(dev, panel->enable_gpio,
+					  "failed to request GPIO\n");
+
+	err = of_drm_get_panel_orientation(dev->of_node, &panel->orientation);
+	if (err) {
+		dev_err(dev, "%pOF: failed to get orientation %d\n", dev->of_node, err);
+		return ERR_PTR(err);
+	}
+
+	ddc = of_parse_phandle(dev->of_node, "ddc-i2c-bus", 0);
+	if (ddc) {
+		panel->ddc = of_find_i2c_adapter_by_node(ddc);
+		of_node_put(ddc);
+
+		if (!panel->ddc)
+			return ERR_PTR(-EPROBE_DEFER);
+	}
+
+	if (!of_device_is_compatible(dev->of_node, "panel-dpi") &&
+	    !of_get_display_timing(dev->of_node, "panel-timing", &dt))
+		panel_simple_parse_panel_timing_node(dev, panel, &dt);
+
+	if (desc->connector_type == DRM_MODE_CONNECTOR_LVDS) {
+		/* Optional data-mapping property for overriding bus format */
+		err = panel_simple_override_nondefault_lvds_datamapping(dev, panel);
+		if (err)
+			goto free_ddc;
+	}
+
 	dev_set_drvdata(dev, panel);
 
 	/*


