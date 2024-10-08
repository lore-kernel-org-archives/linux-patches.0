Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28B31DEFE1;
	Tue,  8 Oct 2024 12:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390041; cv=none; b=RMgDHQl4MkYAaj5R5ObhhB4cLG0/m/BT0ojNdLth/x0A9OhWLrNWwwc2mcSOt+GtF4+GAnlwJR4JcOmb7pB/30tdDzNwWjgW1ZtPguaRTm8pD10DPDMEspN3t4oElaUyDdw22J+A3fteL3qUm1JRjIaFNzgXwm5xHeMjWTqcfU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390041; c=relaxed/simple;
	bh=Ub/HuRS9WoQmskrPmicmxmDzwWnnCi049r5uW3WPjDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pk625s+sN2NHMQJMOg0sWzUJnRw0EjK/4bLDs/vjSpsU66sWLYwBlcXv3XmzLcoKhWBxZk2kGzpvTJwCnGKMwE3ifhmrOMZxtfbNTEL7imCylGYNf2jz8GH0liPg40RhboS0MdOH09vR4eQmu/riHy5RpDq3HQrKD3NuMm8BBc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/6VeJwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/6VeJwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F65C4CEC7;
	Tue,  8 Oct 2024 12:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390041;
	bh=Ub/HuRS9WoQmskrPmicmxmDzwWnnCi049r5uW3WPjDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/6VeJwas5g4qWrQVHC/rMyV9vf8PtPaiK5vOOON2K6QzUel6ZZapNUjWrZZ9pVGF
	 Zm+wb51muwyI3PzieYMknWW/1MhBrbD0vjZHxQZiSDMrVQT74E+FIFAo8qWM7afJ0I
	 v3aK7z+5f3plsf0bIe4nPJQINEElVknobkukCmfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Katya Orlova <e.orlova@ispras.ru>,
	=?UTF-8?q?Rapha=C3=ABl=20Gallais-Pou?= <raphael.gallais-pou@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 173/482] drm/stm: Avoid use-after-free issues with crtc and plane
Date: Tue,  8 Oct 2024 14:03:56 +0200
Message-ID: <20241008115655.113925490@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Katya Orlova <e.orlova@ispras.ru>

[ Upstream commit 19dd9780b7ac673be95bf6fd6892a184c9db611f ]

ltdc_load() calls functions drm_crtc_init_with_planes(),
drm_universal_plane_init() and drm_encoder_init(). These functions
should not be called with parameters allocated with devm_kzalloc()
to avoid use-after-free issues [1].

Use allocations managed by the DRM framework.

Found by Linux Verification Center (linuxtesting.org).

[1]
https://lore.kernel.org/lkml/u366i76e3qhh3ra5oxrtngjtm2u5lterkekcz6y2jkndhuxzli@diujon4h7qwb/

Signed-off-by: Katya Orlova <e.orlova@ispras.ru>
Acked-by: Raphaël Gallais-Pou <raphael.gallais-pou@foss.st.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240216125040.8968-1-e.orlova@ispras.ru
Signed-off-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/stm/drv.c  |  3 +-
 drivers/gpu/drm/stm/ltdc.c | 73 ++++++++++----------------------------
 2 files changed, 20 insertions(+), 56 deletions(-)

diff --git a/drivers/gpu/drm/stm/drv.c b/drivers/gpu/drm/stm/drv.c
index 4d2db079ad4ff..e1232f74dfa53 100644
--- a/drivers/gpu/drm/stm/drv.c
+++ b/drivers/gpu/drm/stm/drv.c
@@ -25,6 +25,7 @@
 #include <drm/drm_module.h>
 #include <drm/drm_probe_helper.h>
 #include <drm/drm_vblank.h>
+#include <drm/drm_managed.h>
 
 #include "ltdc.h"
 
@@ -75,7 +76,7 @@ static int drv_load(struct drm_device *ddev)
 
 	DRM_DEBUG("%s\n", __func__);
 
-	ldev = devm_kzalloc(ddev->dev, sizeof(*ldev), GFP_KERNEL);
+	ldev = drmm_kzalloc(ddev, sizeof(*ldev), GFP_KERNEL);
 	if (!ldev)
 		return -ENOMEM;
 
diff --git a/drivers/gpu/drm/stm/ltdc.c b/drivers/gpu/drm/stm/ltdc.c
index 5aec1e58c968c..056642d12265c 100644
--- a/drivers/gpu/drm/stm/ltdc.c
+++ b/drivers/gpu/drm/stm/ltdc.c
@@ -36,6 +36,7 @@
 #include <drm/drm_probe_helper.h>
 #include <drm/drm_simple_kms_helper.h>
 #include <drm/drm_vblank.h>
+#include <drm/drm_managed.h>
 
 #include <video/videomode.h>
 
@@ -1199,7 +1200,6 @@ static void ltdc_crtc_atomic_print_state(struct drm_printer *p,
 }
 
 static const struct drm_crtc_funcs ltdc_crtc_funcs = {
-	.destroy = drm_crtc_cleanup,
 	.set_config = drm_atomic_helper_set_config,
 	.page_flip = drm_atomic_helper_page_flip,
 	.reset = drm_atomic_helper_crtc_reset,
@@ -1212,7 +1212,6 @@ static const struct drm_crtc_funcs ltdc_crtc_funcs = {
 };
 
 static const struct drm_crtc_funcs ltdc_crtc_with_crc_support_funcs = {
-	.destroy = drm_crtc_cleanup,
 	.set_config = drm_atomic_helper_set_config,
 	.page_flip = drm_atomic_helper_page_flip,
 	.reset = drm_atomic_helper_crtc_reset,
@@ -1545,7 +1544,6 @@ static void ltdc_plane_atomic_print_state(struct drm_printer *p,
 static const struct drm_plane_funcs ltdc_plane_funcs = {
 	.update_plane = drm_atomic_helper_update_plane,
 	.disable_plane = drm_atomic_helper_disable_plane,
-	.destroy = drm_plane_cleanup,
 	.reset = drm_atomic_helper_plane_reset,
 	.atomic_duplicate_state = drm_atomic_helper_plane_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_plane_destroy_state,
@@ -1572,7 +1570,6 @@ static struct drm_plane *ltdc_plane_create(struct drm_device *ddev,
 	const u64 *modifiers = ltdc_format_modifiers;
 	u32 lofs = index * LAY_OFS;
 	u32 val;
-	int ret;
 
 	/* Allocate the biggest size according to supported color formats */
 	formats = devm_kzalloc(dev, (ldev->caps.pix_fmt_nb +
@@ -1615,14 +1612,10 @@ static struct drm_plane *ltdc_plane_create(struct drm_device *ddev,
 		}
 	}
 
-	plane = devm_kzalloc(dev, sizeof(*plane), GFP_KERNEL);
-	if (!plane)
-		return NULL;
-
-	ret = drm_universal_plane_init(ddev, plane, possible_crtcs,
-				       &ltdc_plane_funcs, formats, nb_fmt,
-				       modifiers, type, NULL);
-	if (ret < 0)
+	plane = drmm_universal_plane_alloc(ddev, struct drm_plane, dev,
+					   possible_crtcs, &ltdc_plane_funcs, formats,
+					   nb_fmt, modifiers, type, NULL);
+	if (IS_ERR(plane))
 		return NULL;
 
 	if (ldev->caps.ycbcr_input) {
@@ -1645,15 +1638,6 @@ static struct drm_plane *ltdc_plane_create(struct drm_device *ddev,
 	return plane;
 }
 
-static void ltdc_plane_destroy_all(struct drm_device *ddev)
-{
-	struct drm_plane *plane, *plane_temp;
-
-	list_for_each_entry_safe(plane, plane_temp,
-				 &ddev->mode_config.plane_list, head)
-		drm_plane_cleanup(plane);
-}
-
 static int ltdc_crtc_init(struct drm_device *ddev, struct drm_crtc *crtc)
 {
 	struct ltdc_device *ldev = ddev->dev_private;
@@ -1679,14 +1663,14 @@ static int ltdc_crtc_init(struct drm_device *ddev, struct drm_crtc *crtc)
 
 	/* Init CRTC according to its hardware features */
 	if (ldev->caps.crc)
-		ret = drm_crtc_init_with_planes(ddev, crtc, primary, NULL,
-						&ltdc_crtc_with_crc_support_funcs, NULL);
+		ret = drmm_crtc_init_with_planes(ddev, crtc, primary, NULL,
+						 &ltdc_crtc_with_crc_support_funcs, NULL);
 	else
-		ret = drm_crtc_init_with_planes(ddev, crtc, primary, NULL,
-						&ltdc_crtc_funcs, NULL);
+		ret = drmm_crtc_init_with_planes(ddev, crtc, primary, NULL,
+						 &ltdc_crtc_funcs, NULL);
 	if (ret) {
 		DRM_ERROR("Can not initialize CRTC\n");
-		goto cleanup;
+		return ret;
 	}
 
 	drm_crtc_helper_add(crtc, &ltdc_crtc_helper_funcs);
@@ -1700,9 +1684,8 @@ static int ltdc_crtc_init(struct drm_device *ddev, struct drm_crtc *crtc)
 	for (i = 1; i < ldev->caps.nb_layers; i++) {
 		overlay = ltdc_plane_create(ddev, DRM_PLANE_TYPE_OVERLAY, i);
 		if (!overlay) {
-			ret = -ENOMEM;
 			DRM_ERROR("Can not create overlay plane %d\n", i);
-			goto cleanup;
+			return -ENOMEM;
 		}
 		if (ldev->caps.dynamic_zorder)
 			drm_plane_create_zpos_property(overlay, i, 0, ldev->caps.nb_layers - 1);
@@ -1715,10 +1698,6 @@ static int ltdc_crtc_init(struct drm_device *ddev, struct drm_crtc *crtc)
 	}
 
 	return 0;
-
-cleanup:
-	ltdc_plane_destroy_all(ddev);
-	return ret;
 }
 
 static void ltdc_encoder_disable(struct drm_encoder *encoder)
@@ -1778,23 +1757,19 @@ static int ltdc_encoder_init(struct drm_device *ddev, struct drm_bridge *bridge)
 	struct drm_encoder *encoder;
 	int ret;
 
-	encoder = devm_kzalloc(ddev->dev, sizeof(*encoder), GFP_KERNEL);
-	if (!encoder)
-		return -ENOMEM;
+	encoder = drmm_simple_encoder_alloc(ddev, struct drm_encoder, dev,
+					    DRM_MODE_ENCODER_DPI);
+	if (IS_ERR(encoder))
+		return PTR_ERR(encoder);
 
 	encoder->possible_crtcs = CRTC_MASK;
 	encoder->possible_clones = 0;	/* No cloning support */
 
-	drm_simple_encoder_init(ddev, encoder, DRM_MODE_ENCODER_DPI);
-
 	drm_encoder_helper_add(encoder, &ltdc_encoder_helper_funcs);
 
 	ret = drm_bridge_attach(encoder, bridge, NULL, 0);
-	if (ret) {
-		if (ret != -EPROBE_DEFER)
-			drm_encoder_cleanup(encoder);
+	if (ret)
 		return ret;
-	}
 
 	DRM_DEBUG_DRIVER("Bridge encoder:%d created\n", encoder->base.id);
 
@@ -1964,8 +1939,7 @@ int ltdc_load(struct drm_device *ddev)
 			goto err;
 
 		if (panel) {
-			bridge = drm_panel_bridge_add_typed(panel,
-							    DRM_MODE_CONNECTOR_DPI);
+			bridge = drmm_panel_bridge_add(ddev, panel);
 			if (IS_ERR(bridge)) {
 				DRM_ERROR("panel-bridge endpoint %d\n", i);
 				ret = PTR_ERR(bridge);
@@ -2047,7 +2021,7 @@ int ltdc_load(struct drm_device *ddev)
 		}
 	}
 
-	crtc = devm_kzalloc(dev, sizeof(*crtc), GFP_KERNEL);
+	crtc = drmm_kzalloc(ddev, sizeof(*crtc), GFP_KERNEL);
 	if (!crtc) {
 		DRM_ERROR("Failed to allocate crtc\n");
 		ret = -ENOMEM;
@@ -2074,9 +2048,6 @@ int ltdc_load(struct drm_device *ddev)
 
 	return 0;
 err:
-	for (i = 0; i < nb_endpoints; i++)
-		drm_of_panel_bridge_remove(ddev->dev->of_node, 0, i);
-
 	clk_disable_unprepare(ldev->pixel_clk);
 
 	return ret;
@@ -2084,16 +2055,8 @@ int ltdc_load(struct drm_device *ddev)
 
 void ltdc_unload(struct drm_device *ddev)
 {
-	struct device *dev = ddev->dev;
-	int nb_endpoints, i;
-
 	DRM_DEBUG_DRIVER("\n");
 
-	nb_endpoints = of_graph_get_endpoint_count(dev->of_node);
-
-	for (i = 0; i < nb_endpoints; i++)
-		drm_of_panel_bridge_remove(ddev->dev->of_node, 0, i);
-
 	pm_runtime_disable(ddev->dev);
 }
 
-- 
2.43.0



