Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F8A381B1A;
	Thu, 20 Aug 2026 15:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239278; cv=none; b=pUPR/Vz4kmOvou1XaQfTATfS7QgNaDa8mhsQIxGP3xkiLdS8RRYi03jiMyVOhL4C/MPYdNqz/aL1xhVNaJBm3nj9DN6kAKxK8eU5W9pY4CeKUCjuozhl7Ky1oLU5vAd2U/qbQrClvEqsr8E1b6t2CGXudfG9JF7IyIBSmhO5GHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239278; c=relaxed/simple;
	bh=8hOWF7WzZeXUXqlwXsX26WtTN6GnRaXv+7mQwz8aLcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xp0FOb+IiroqjkrZ2mwNTxnhU8O32750JG6EBwGcLNXePAftfUTbRxtihCRTYSkn4/cHEzonbLD8BJTUh/vCpmTWiyIQJ7vuFVshVjfQwwUfq4kEiBP/RyC5xXHEe6jWRXO7J+KIZSshAqg1d1OieU+iK/efqx5D/ruzrvhs71Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJ+bI3hL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJ+bI3hL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC1F1F000E9;
	Thu, 20 Aug 2026 15:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239276;
	bh=pz7n1rYx9sN6rYVxCJ/G98EGdD5awLaD5X2A85g1HoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJ+bI3hLGdKPs/7GiQsHGsez+OJpC2MhD3A3rLtGMTUS60X8vm436NAJ0tiWezB5o
	 VN6X9xxYcSV6/SDSjHqaFPe8nOdudo5RuKjgC1NG4jzPgKiDvZYcdWrURdZZihvtXA
	 UhoPlZZbSVAVYGq3FkEbq8BWNjEl+xzZ7TlQtx9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Francesco Valla <francesco@valla.it>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 212/217] drm/client: Remove drm_client_framebuffer_delete()
Date: Thu, 20 Aug 2026 16:56:20 +0200
Message-ID: <20260820145244.068439535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 3e3153325fd3693d0f9fe235c4afbcd68ef102e1 ]

Release client buffers with drm_client_buffer_delete() instead of
drm_client_framebuffer_delete(). The latter is just a tiny wrapper
around the former.

Move the test for !buffer into drm_client_buffer_delete(), although
all callers appear to always have a valid pointer.

v2:
- test for !buffer before deref-ing pointer (Jocelyn, Dan)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Tested-by: Francesco Valla <francesco@valla.it>
Link: https://patch.msgid.link/20251027121042.143588-6-tzimmermann@suse.de
Stable-dep-of: f4f2bba28df9 ("drm/log: Fix infinite loop when scale is too large for display")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/clients/drm_log.c |  4 ++--
 drivers/gpu/drm/drm_client.c      | 28 ++++++++++++----------------
 drivers/gpu/drm/drm_fbdev_dma.c   |  6 +++---
 drivers/gpu/drm/drm_fbdev_shmem.c |  4 ++--
 drivers/gpu/drm/drm_fbdev_ttm.c   |  8 ++++----
 include/drm/drm_client.h          |  2 +-
 6 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/clients/drm_log.c b/drivers/gpu/drm/clients/drm_log.c
index 0ac97550fc619..d040b55e5badd 100644
--- a/drivers/gpu/drm/clients/drm_log.c
+++ b/drivers/gpu/drm/clients/drm_log.c
@@ -275,7 +275,7 @@ static void drm_log_init_client(struct drm_log *dlog)
 
 err_failed_commit:
 	for (i = 0; i < n_modeset; i++)
-		drm_client_framebuffer_delete(dlog->scanout[i].buffer);
+		drm_client_buffer_delete(dlog->scanout[i].buffer);
 
 err_nomodeset:
 	kfree(dlog->scanout);
@@ -289,7 +289,7 @@ static void drm_log_free_scanout(struct drm_client_dev *client)
 
 	if (dlog->n_scanout) {
 		for (i = 0; i < dlog->n_scanout; i++)
-			drm_client_framebuffer_delete(dlog->scanout[i].buffer);
+			drm_client_buffer_delete(dlog->scanout[i].buffer);
 		dlog->n_scanout = 0;
 		kfree(dlog->scanout);
 		dlog->scanout = NULL;
diff --git a/drivers/gpu/drm/drm_client.c b/drivers/gpu/drm/drm_client.c
index 9bb49d3771cb7..6a6ba50e69289 100644
--- a/drivers/gpu/drm/drm_client.c
+++ b/drivers/gpu/drm/drm_client.c
@@ -173,11 +173,19 @@ void drm_client_release(struct drm_client_dev *client)
 }
 EXPORT_SYMBOL(drm_client_release);
 
-static void drm_client_buffer_delete(struct drm_client_buffer *buffer)
+/**
+ * drm_client_buffer_delete - Delete a client buffer
+ * @buffer: DRM client buffer
+ */
+void drm_client_buffer_delete(struct drm_client_buffer *buffer)
 {
-	struct drm_gem_object *gem = buffer->fb->obj[0];
+	struct drm_gem_object *gem;
 	int ret;
 
+	if (!buffer)
+		return;
+
+	gem = buffer->fb->obj[0];
 	drm_gem_vunmap(gem, &buffer->map);
 
 	ret = drm_mode_rmfb(buffer->client->dev, buffer->fb->base.id, buffer->client->file);
@@ -189,6 +197,7 @@ static void drm_client_buffer_delete(struct drm_client_buffer *buffer)
 
 	kfree(buffer);
 }
+EXPORT_SYMBOL(drm_client_buffer_delete);
 
 static struct drm_client_buffer *
 drm_client_buffer_create(struct drm_client_dev *client, u32 width, u32 height,
@@ -372,7 +381,7 @@ EXPORT_SYMBOL(drm_client_buffer_vunmap);
  *
  * This function creates a &drm_client_buffer which consists of a
  * &drm_framebuffer backed by a dumb buffer.
- * Call drm_client_framebuffer_delete() to free the buffer.
+ * Call drm_client_buffer_delete() to free the buffer.
  *
  * Returns:
  * Pointer to a client buffer or an error pointer on failure.
@@ -416,19 +425,6 @@ drm_client_framebuffer_create(struct drm_client_dev *client, u32 width, u32 heig
 }
 EXPORT_SYMBOL(drm_client_framebuffer_create);
 
-/**
- * drm_client_framebuffer_delete - Delete a client framebuffer
- * @buffer: DRM client buffer (can be NULL)
- */
-void drm_client_framebuffer_delete(struct drm_client_buffer *buffer)
-{
-	if (!buffer)
-		return;
-
-	drm_client_buffer_delete(buffer);
-}
-EXPORT_SYMBOL(drm_client_framebuffer_delete);
-
 /**
  * drm_client_framebuffer_flush - Manually flush client framebuffer
  * @buffer: DRM client buffer (can be NULL)
diff --git a/drivers/gpu/drm/drm_fbdev_dma.c b/drivers/gpu/drm/drm_fbdev_dma.c
index 7b77c801a63a3..feecd44e91eb8 100644
--- a/drivers/gpu/drm/drm_fbdev_dma.c
+++ b/drivers/gpu/drm/drm_fbdev_dma.c
@@ -55,7 +55,7 @@ static void drm_fbdev_dma_fb_destroy(struct fb_info *info)
 	drm_fb_helper_fini(fb_helper);
 
 	drm_client_buffer_vunmap(fb_helper->buffer);
-	drm_client_framebuffer_delete(fb_helper->buffer);
+	drm_client_buffer_delete(fb_helper->buffer);
 	drm_client_release(&fb_helper->client);
 	drm_fb_helper_unprepare(fb_helper);
 	kfree(fb_helper);
@@ -90,7 +90,7 @@ static void drm_fbdev_dma_shadowed_fb_destroy(struct fb_info *info)
 	vfree(shadow);
 
 	drm_client_buffer_vunmap(fb_helper->buffer);
-	drm_client_framebuffer_delete(fb_helper->buffer);
+	drm_client_buffer_delete(fb_helper->buffer);
 	drm_client_release(&fb_helper->client);
 	drm_fb_helper_unprepare(fb_helper);
 	kfree(fb_helper);
@@ -320,7 +320,7 @@ int drm_fbdev_dma_driver_fbdev_probe(struct drm_fb_helper *fb_helper,
 	fb_helper->buffer = NULL;
 	drm_client_buffer_vunmap(buffer);
 err_drm_client_buffer_delete:
-	drm_client_framebuffer_delete(buffer);
+	drm_client_buffer_delete(buffer);
 	return ret;
 }
 EXPORT_SYMBOL(drm_fbdev_dma_driver_fbdev_probe);
diff --git a/drivers/gpu/drm/drm_fbdev_shmem.c b/drivers/gpu/drm/drm_fbdev_shmem.c
index 77f3507008188..d435caed70029 100644
--- a/drivers/gpu/drm/drm_fbdev_shmem.c
+++ b/drivers/gpu/drm/drm_fbdev_shmem.c
@@ -63,7 +63,7 @@ static void drm_fbdev_shmem_fb_destroy(struct fb_info *info)
 	drm_fb_helper_fini(fb_helper);
 
 	drm_client_buffer_vunmap(fb_helper->buffer);
-	drm_client_framebuffer_delete(fb_helper->buffer);
+	drm_client_buffer_delete(fb_helper->buffer);
 	drm_client_release(&fb_helper->client);
 	drm_fb_helper_unprepare(fb_helper);
 	kfree(fb_helper);
@@ -198,7 +198,7 @@ int drm_fbdev_shmem_driver_fbdev_probe(struct drm_fb_helper *fb_helper,
 	fb_helper->buffer = NULL;
 	drm_client_buffer_vunmap(buffer);
 err_drm_client_buffer_delete:
-	drm_client_framebuffer_delete(buffer);
+	drm_client_buffer_delete(buffer);
 	return ret;
 }
 EXPORT_SYMBOL(drm_fbdev_shmem_driver_fbdev_probe);
diff --git a/drivers/gpu/drm/drm_fbdev_ttm.c b/drivers/gpu/drm/drm_fbdev_ttm.c
index 1ba258f3c8542..c2aa65b2384f7 100644
--- a/drivers/gpu/drm/drm_fbdev_ttm.c
+++ b/drivers/gpu/drm/drm_fbdev_ttm.c
@@ -50,7 +50,7 @@ static void drm_fbdev_ttm_fb_destroy(struct fb_info *info)
 	fb_deferred_io_cleanup(info);
 	drm_fb_helper_fini(fb_helper);
 	vfree(shadow);
-	drm_client_framebuffer_delete(fb_helper->buffer);
+	drm_client_buffer_delete(fb_helper->buffer);
 
 	drm_client_release(&fb_helper->client);
 	drm_fb_helper_unprepare(fb_helper);
@@ -202,7 +202,7 @@ int drm_fbdev_ttm_driver_fbdev_probe(struct drm_fb_helper *fb_helper,
 	screen_buffer = vzalloc(screen_size);
 	if (!screen_buffer) {
 		ret = -ENOMEM;
-		goto err_drm_client_framebuffer_delete;
+		goto err_drm_client_buffer_delete;
 	}
 
 	drm_fb_helper_fill_info(info, fb_helper, sizes);
@@ -227,10 +227,10 @@ int drm_fbdev_ttm_driver_fbdev_probe(struct drm_fb_helper *fb_helper,
 
 err_vfree:
 	vfree(screen_buffer);
-err_drm_client_framebuffer_delete:
+err_drm_client_buffer_delete:
 	fb_helper->fb = NULL;
 	fb_helper->buffer = NULL;
-	drm_client_framebuffer_delete(buffer);
+	drm_client_buffer_delete(buffer);
 	return ret;
 }
 EXPORT_SYMBOL(drm_fbdev_ttm_driver_fbdev_probe);
diff --git a/include/drm/drm_client.h b/include/drm/drm_client.h
index 78db5f03b80e6..8e2e51f984306 100644
--- a/include/drm/drm_client.h
+++ b/include/drm/drm_client.h
@@ -195,7 +195,7 @@ struct drm_client_buffer {
 
 struct drm_client_buffer *
 drm_client_framebuffer_create(struct drm_client_dev *client, u32 width, u32 height, u32 format);
-void drm_client_framebuffer_delete(struct drm_client_buffer *buffer);
+void drm_client_buffer_delete(struct drm_client_buffer *buffer);
 int drm_client_framebuffer_flush(struct drm_client_buffer *buffer, struct drm_rect *rect);
 int drm_client_buffer_vmap_local(struct drm_client_buffer *buffer,
 				 struct iosys_map *map_copy);
-- 
2.53.0



