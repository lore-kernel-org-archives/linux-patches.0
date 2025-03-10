Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4342236445;
	Mon, 10 Mar 2025 17:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627515; cv=none; b=aICRFIcg858JfeQxrb4Q2ioXjTKFh+tKIWss3d1kwuSzldifxyrsuCN7DlAh+alaTnZQ6AjwX9QWdvYzTMQczNh7t+dgoXNGXm4L0h0ukcE9kpVSljyAhkDtGIAuLFcAuEBqwLWwr8VCs6bnvxsKQ3Vsi+W/uuSXUE4QEx0KisA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627515; c=relaxed/simple;
	bh=mTUoxGaDOOsyyXT98TneQKepaNXG7aYs2pnwKO10ejQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VE+oP1k2QYXi9W/B0rsalSfJXDkthY8MguaBqQmYcGiqgTsjvC4GuJl2QT5iciDNg4S/QxmbF4WHPAo2dmQ8iqNoRZRyQNGUodSEtZHeWEiqSf8bo2G75xI6ryMPu7wUJ+hRP7J2Sc3oEct4N5lawOBoj1E3rhWf8jQeGG4BY0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCoVb61M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCoVb61M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50EEC4CEE5;
	Mon, 10 Mar 2025 17:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627515;
	bh=mTUoxGaDOOsyyXT98TneQKepaNXG7aYs2pnwKO10ejQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCoVb61MMyFxdiFPp0G/ujUkiXWk1nPdAsJH4/rYChOWZyojSnkK9GfirwkUQb/q4
	 LO6dm86cSkvpmYS/ZlV8fGxg8ScS7yG2yYCOFcgic/jcHNVXDWXV6yaUqCTSCNM5fE
	 oEBnH38k2CMA+jIuX5iy79a8XzDnqs7Os173q0Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 156/269] drm/fbdev-helper: Move color-mode lookup into 4CC format helper
Date: Mon, 10 Mar 2025 18:05:09 +0100
Message-ID: <20250310170503.940285837@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit eb1f4adf9101573fc2347978a60d71c4f1176cca ]

The color mode as specified on the kernel command line gives the user's
preferred color depth and number of bits per pixel. Move the
color-mode-to-format conversion from fbdev helpers into a 4CC helper,
so that it can be shared among DRM clients.

v2:
- fix grammar in commit message (Laurent)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240924071734.98201-2-tzimmermann@suse.de
Stable-dep-of: 6b481ab0e685 ("drm/nouveau: select FW caching")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_fb_helper.c | 70 +++++++--------------------------
 drivers/gpu/drm/drm_fourcc.c    | 30 +++++++++++++-
 include/drm/drm_fourcc.h        |  1 +
 3 files changed, 45 insertions(+), 56 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index eaac2e5726e75..29b0cf3a3fb19 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1443,67 +1443,27 @@ int drm_fb_helper_pan_display(struct fb_var_screeninfo *var,
 EXPORT_SYMBOL(drm_fb_helper_pan_display);
 
 static uint32_t drm_fb_helper_find_format(struct drm_fb_helper *fb_helper, const uint32_t *formats,
-					  size_t format_count, uint32_t bpp, uint32_t depth)
+					  size_t format_count, unsigned int color_mode)
 {
 	struct drm_device *dev = fb_helper->dev;
 	uint32_t format;
 	size_t i;
 
-	/*
-	 * Do not consider YUV or other complicated formats
-	 * for framebuffers. This means only legacy formats
-	 * are supported (fmt->depth is a legacy field), but
-	 * the framebuffer emulation can only deal with such
-	 * formats, specifically RGB/BGA formats.
-	 */
-	format = drm_mode_legacy_fb_format(bpp, depth);
-	if (!format)
-		goto err;
+	format = drm_driver_color_mode_format(dev, color_mode);
+	if (!format) {
+		drm_info(dev, "unsupported color mode of %d\n", color_mode);
+		return DRM_FORMAT_INVALID;
+	}
 
 	for (i = 0; i < format_count; ++i) {
 		if (formats[i] == format)
 			return format;
 	}
-
-err:
-	/* We found nothing. */
-	drm_warn(dev, "bpp/depth value of %u/%u not supported\n", bpp, depth);
+	drm_warn(dev, "format %p4cc not supported\n", &format);
 
 	return DRM_FORMAT_INVALID;
 }
 
-static uint32_t drm_fb_helper_find_color_mode_format(struct drm_fb_helper *fb_helper,
-						     const uint32_t *formats, size_t format_count,
-						     unsigned int color_mode)
-{
-	struct drm_device *dev = fb_helper->dev;
-	uint32_t bpp, depth;
-
-	switch (color_mode) {
-	case 1:
-	case 2:
-	case 4:
-	case 8:
-	case 16:
-	case 24:
-		bpp = depth = color_mode;
-		break;
-	case 15:
-		bpp = 16;
-		depth = 15;
-		break;
-	case 32:
-		bpp = 32;
-		depth = 24;
-		break;
-	default:
-		drm_info(dev, "unsupported color mode of %d\n", color_mode);
-		return DRM_FORMAT_INVALID;
-	}
-
-	return drm_fb_helper_find_format(fb_helper, formats, format_count, bpp, depth);
-}
-
 static int __drm_fb_helper_find_sizes(struct drm_fb_helper *fb_helper,
 				      struct drm_fb_helper_surface_size *sizes)
 {
@@ -1533,10 +1493,10 @@ static int __drm_fb_helper_find_sizes(struct drm_fb_helper *fb_helper,
 			if (!cmdline_mode->bpp_specified)
 				continue;
 
-			surface_format = drm_fb_helper_find_color_mode_format(fb_helper,
-									      plane->format_types,
-									      plane->format_count,
-									      cmdline_mode->bpp);
+			surface_format = drm_fb_helper_find_format(fb_helper,
+								   plane->format_types,
+								   plane->format_count,
+								   cmdline_mode->bpp);
 			if (surface_format != DRM_FORMAT_INVALID)
 				break; /* found supported format */
 		}
@@ -1546,10 +1506,10 @@ static int __drm_fb_helper_find_sizes(struct drm_fb_helper *fb_helper,
 			break; /* found supported format */
 
 		/* try preferred color mode */
-		surface_format = drm_fb_helper_find_color_mode_format(fb_helper,
-								      plane->format_types,
-								      plane->format_count,
-								      fb_helper->preferred_bpp);
+		surface_format = drm_fb_helper_find_format(fb_helper,
+							   plane->format_types,
+							   plane->format_count,
+							   fb_helper->preferred_bpp);
 		if (surface_format != DRM_FORMAT_INVALID)
 			break; /* found supported format */
 	}
diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
index 193cf8ed79128..3a94ca211f9ce 100644
--- a/drivers/gpu/drm/drm_fourcc.c
+++ b/drivers/gpu/drm/drm_fourcc.c
@@ -36,7 +36,6 @@
  * @depth: bit depth per pixel
  *
  * Computes a drm fourcc pixel format code for the given @bpp/@depth values.
- * Useful in fbdev emulation code, since that deals in those values.
  */
 uint32_t drm_mode_legacy_fb_format(uint32_t bpp, uint32_t depth)
 {
@@ -140,6 +139,35 @@ uint32_t drm_driver_legacy_fb_format(struct drm_device *dev,
 }
 EXPORT_SYMBOL(drm_driver_legacy_fb_format);
 
+/**
+ * drm_driver_color_mode_format - Compute DRM 4CC code from color mode
+ * @dev: DRM device
+ * @color_mode: command-line color mode
+ *
+ * Computes a DRM 4CC pixel format code for the given color mode using
+ * drm_driver_color_mode(). The color mode is in the format used and the
+ * kernel command line. It specifies the number of bits per pixel
+ * and color depth in a single value.
+ *
+ * Useful in fbdev emulation code, since that deals in those values. The
+ * helper does not consider YUV or other complicated formats. This means
+ * only legacy formats are supported (fmt->depth is a legacy field), but
+ * the framebuffer emulation can only deal with such formats, specifically
+ * RGB/BGA formats.
+ */
+uint32_t drm_driver_color_mode_format(struct drm_device *dev, unsigned int color_mode)
+{
+	switch (color_mode) {
+	case 15:
+		return drm_driver_legacy_fb_format(dev, 16, 15);
+	case 32:
+		return drm_driver_legacy_fb_format(dev, 32, 24);
+	default:
+		return drm_driver_legacy_fb_format(dev, color_mode, color_mode);
+	}
+}
+EXPORT_SYMBOL(drm_driver_color_mode_format);
+
 /*
  * Internal function to query information for a given format. See
  * drm_format_info() for the public API.
diff --git a/include/drm/drm_fourcc.h b/include/drm/drm_fourcc.h
index ccf91daa43070..c3f4405d66629 100644
--- a/include/drm/drm_fourcc.h
+++ b/include/drm/drm_fourcc.h
@@ -313,6 +313,7 @@ drm_get_format_info(struct drm_device *dev,
 uint32_t drm_mode_legacy_fb_format(uint32_t bpp, uint32_t depth);
 uint32_t drm_driver_legacy_fb_format(struct drm_device *dev,
 				     uint32_t bpp, uint32_t depth);
+uint32_t drm_driver_color_mode_format(struct drm_device *dev, unsigned int color_mode);
 unsigned int drm_format_info_block_width(const struct drm_format_info *info,
 					 int plane);
 unsigned int drm_format_info_block_height(const struct drm_format_info *info,
-- 
2.39.5



