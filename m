Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10854288D6;
	Tue, 20 May 2025 14:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750418; cv=none; b=FfT6PvO5L1fPei45ePrbIx++Bzx1ticl/D+ak0LOdTp+57l1xwuRoTmeaesGZEz79BXC0tp+DNvo7fvWGJtcfHTRpLilmteLITDT4tBs5qXkZecp5CulW9FnrVPjb3lrYd23HxTlMRpdeP0KQ1m+4G9iXre5e+0dQFn9Uf1QZuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750418; c=relaxed/simple;
	bh=J6x5ViGPIDWlBxGpXpO3PpEVtZNOFUgJjq0ZpoRHoXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgJ5CsMqD4QFW9DdiB8NuUImBsJrhDpJlUZwMNhWGjNGa4vuI+e5s98BiHgdo8YvKOnz9kwCDkyFTbJPDBaJro3k6mpF+HjP+xbX4zPW/2GCLAUtbMrrFtcpzTcykDJse9eCehw0AY3HziMB6gLbp/CAla4wWmLB25y2WzzuLWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlTONdHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlTONdHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9697CC4CEE9;
	Tue, 20 May 2025 14:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750417;
	bh=J6x5ViGPIDWlBxGpXpO3PpEVtZNOFUgJjq0ZpoRHoXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LlTONdHvYZFsEK4h1WR7PppjNMlEcsaOlsfewaE2f5l+AE1452MJ3zt3E2ngrfHug
	 TD6BFIMidjDkSyqn8M6JVUoANfm1q3qXtRrPIHaXKrrgE+dXz++UWulXQ+cQ1An1IV
	 QJhyKu9E1wfklJWcBYOafzV9knQpC6MFjSOGzHdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Fabio Estevam <festevam@denx.de>
Subject: [PATCH 6.12 138/143] drm/fbdev-dma: Support struct drm_driver.fbdev_probe
Date: Tue, 20 May 2025 15:51:33 +0200
Message-ID: <20250520125815.441736462@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

commit 8998eedda2539d2528cfebdc7c17eed0ad35b714 upstream.

Rework fbdev probing to support fbdev_probe in struct drm_driver
and reimplement the old fb_probe callback on top of it. Provide an
initializer macro for struct drm_driver that sets the callback
according to the kernel configuration.

This change allows the common fbdev client to run on top of DMA-
based DRM drivers.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240924071734.98201-6-tzimmermann@suse.de
Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_fbdev_dma.c |   60 ++++++++++++++++++++++++----------------
 include/drm/drm_fbdev_dma.h     |   12 ++++++++
 2 files changed, 48 insertions(+), 24 deletions(-)

--- a/drivers/gpu/drm/drm_fbdev_dma.c
+++ b/drivers/gpu/drm/drm_fbdev_dma.c
@@ -106,6 +106,40 @@ static const struct fb_ops drm_fbdev_dma
 static int drm_fbdev_dma_helper_fb_probe(struct drm_fb_helper *fb_helper,
 					 struct drm_fb_helper_surface_size *sizes)
 {
+	return drm_fbdev_dma_driver_fbdev_probe(fb_helper, sizes);
+}
+
+static int drm_fbdev_dma_helper_fb_dirty(struct drm_fb_helper *helper,
+					 struct drm_clip_rect *clip)
+{
+	struct drm_device *dev = helper->dev;
+	int ret;
+
+	/* Call damage handlers only if necessary */
+	if (!(clip->x1 < clip->x2 && clip->y1 < clip->y2))
+		return 0;
+
+	if (helper->fb->funcs->dirty) {
+		ret = helper->fb->funcs->dirty(helper->fb, NULL, 0, 0, clip, 1);
+		if (drm_WARN_ONCE(dev, ret, "Dirty helper failed: ret=%d\n", ret))
+			return ret;
+	}
+
+	return 0;
+}
+
+static const struct drm_fb_helper_funcs drm_fbdev_dma_helper_funcs = {
+	.fb_probe = drm_fbdev_dma_helper_fb_probe,
+	.fb_dirty = drm_fbdev_dma_helper_fb_dirty,
+};
+
+/*
+ * struct drm_fb_helper
+ */
+
+int drm_fbdev_dma_driver_fbdev_probe(struct drm_fb_helper *fb_helper,
+				     struct drm_fb_helper_surface_size *sizes)
+{
 	struct drm_client_dev *client = &fb_helper->client;
 	struct drm_device *dev = fb_helper->dev;
 	bool use_deferred_io = false;
@@ -148,6 +182,7 @@ static int drm_fbdev_dma_helper_fb_probe
 		goto err_drm_client_buffer_delete;
 	}
 
+	fb_helper->funcs = &drm_fbdev_dma_helper_funcs;
 	fb_helper->buffer = buffer;
 	fb_helper->fb = fb;
 
@@ -211,30 +246,7 @@ err_drm_client_buffer_delete:
 	drm_client_framebuffer_delete(buffer);
 	return ret;
 }
-
-static int drm_fbdev_dma_helper_fb_dirty(struct drm_fb_helper *helper,
-					 struct drm_clip_rect *clip)
-{
-	struct drm_device *dev = helper->dev;
-	int ret;
-
-	/* Call damage handlers only if necessary */
-	if (!(clip->x1 < clip->x2 && clip->y1 < clip->y2))
-		return 0;
-
-	if (helper->fb->funcs->dirty) {
-		ret = helper->fb->funcs->dirty(helper->fb, NULL, 0, 0, clip, 1);
-		if (drm_WARN_ONCE(dev, ret, "Dirty helper failed: ret=%d\n", ret))
-			return ret;
-	}
-
-	return 0;
-}
-
-static const struct drm_fb_helper_funcs drm_fbdev_dma_helper_funcs = {
-	.fb_probe = drm_fbdev_dma_helper_fb_probe,
-	.fb_dirty = drm_fbdev_dma_helper_fb_dirty,
-};
+EXPORT_SYMBOL(drm_fbdev_dma_driver_fbdev_probe);
 
 /*
  * struct drm_client_funcs
--- a/include/drm/drm_fbdev_dma.h
+++ b/include/drm/drm_fbdev_dma.h
@@ -4,12 +4,24 @@
 #define DRM_FBDEV_DMA_H
 
 struct drm_device;
+struct drm_fb_helper;
+struct drm_fb_helper_surface_size;
 
 #ifdef CONFIG_DRM_FBDEV_EMULATION
+int drm_fbdev_dma_driver_fbdev_probe(struct drm_fb_helper *fb_helper,
+				     struct drm_fb_helper_surface_size *sizes);
+
+#define DRM_FBDEV_DMA_DRIVER_OPS \
+	.fbdev_probe = drm_fbdev_dma_driver_fbdev_probe
+
 void drm_fbdev_dma_setup(struct drm_device *dev, unsigned int preferred_bpp);
 #else
 static inline void drm_fbdev_dma_setup(struct drm_device *dev, unsigned int preferred_bpp)
 { }
+
+#define DRM_FBDEV_DMA_DRIVER_OPS \
+	.fbdev_probe = NULL
+
 #endif
 
 #endif


