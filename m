Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A682EAB70;
	Thu,  3 Jul 2025 14:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554478; cv=none; b=IN8r5DX5MJkRwVUKVPLcyL+A3P5Cu6iD1SXPKuWN1rJQz0vGFxrnduaTLf1bFilBniZ4JmDnOwxUQRpQa6/TfMIqgbHmxpgyGAKd1ppmTjrRbkrpnUhXCZHtOqhkkLO/5fglqgQJVcFl/gsGe83u9yZuN8IdIRq0juuhc4LT1F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554478; c=relaxed/simple;
	bh=Pd4VI7qY3ZT0kGSQnbNlAF0d33nTNr2CfRC4BSuJseI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OtQ3UROKA+RKzLGpRvAXsMprxXG1i5MH97Xl1Ov1HDM03OrppuWMNLOEkcZ7WGqh7aFPDsTyDD8a/Vyw8u2IatIXDjdRjwwgAO1vVIW9YfkDeyoNTYWblLBHDLJJKVPza0uBQRf+nNSei/FmTgmmuHgHQkTrQ0neli/0lCvNiMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L81CDMJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L81CDMJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28050C4CEE3;
	Thu,  3 Jul 2025 14:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554478;
	bh=Pd4VI7qY3ZT0kGSQnbNlAF0d33nTNr2CfRC4BSuJseI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L81CDMJ6+o+Zp/d9Lz24Q/meffyagIp051x13KHHnuThU6mKrViTX4wguun+xb67s
	 aCWOzZp/Y7AAghrdj02EaMtAy/Oewsn6YVZ6SL0fCyiRTiHosPj2+bbyASJaTxGdt1
	 fPokQCi3GFqbHfpQeGdfNbdjpDZiCU1d4NfDflTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	=?UTF-8?q?Nuno=20Gon=C3=A7alves?= <nunojpg@gmail.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 201/218] drm/fbdev-dma: Add shadow buffering for deferred I/O
Date: Thu,  3 Jul 2025 16:42:29 +0200
Message-ID: <20250703144004.251406187@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 3603996432997f7c88da37a97062a46cda01ac9d ]

DMA areas are not necessarily backed by struct page, so we cannot
rely on it for deferred I/O. Allocate a shadow buffer for drivers
that require deferred I/O and use it as framebuffer memory.

Fixes driver errors about being "Unable to handle kernel NULL pointer
dereference at virtual address" or "Unable to handle kernel paging
request at virtual address".

The patch splits drm_fbdev_dma_driver_fbdev_probe() in an initial
allocation, which creates the DMA-backed buffer object, and a tail
that sets up the fbdev data structures. There is a tail function for
direct memory mappings and a tail function for deferred I/O with
the shadow buffer.

It is no longer possible to use deferred I/O without shadow buffer.
It can be re-added if there exists a reliably test for usable struct
page in the allocated DMA-backed buffer object.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reported-by: Nuno Gonçalves <nunojpg@gmail.com>
CLoses: https://lore.kernel.org/dri-devel/CAEXMXLR55DziAMbv_+2hmLeH-jP96pmit6nhs6siB22cpQFr9w@mail.gmail.com/
Tested-by: Nuno Gonçalves <nunojpg@gmail.com>
Fixes: 5ab91447aa13 ("drm/tiny/ili9225: Use fbdev-dma")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: <stable@vger.kernel.org> # v6.11+
Reviewed-by: Simona Vetter <simona.vetter@ffwll.ch>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241211090643.74250-1-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_fbdev_dma.c | 219 +++++++++++++++++++++++---------
 1 file changed, 156 insertions(+), 63 deletions(-)

diff --git a/drivers/gpu/drm/drm_fbdev_dma.c b/drivers/gpu/drm/drm_fbdev_dma.c
index 7c8287c18e381..6fcf2a8bf6762 100644
--- a/drivers/gpu/drm/drm_fbdev_dma.c
+++ b/drivers/gpu/drm/drm_fbdev_dma.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: MIT
 
 #include <linux/fb.h>
+#include <linux/vmalloc.h>
 
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_drv.h>
@@ -72,43 +73,108 @@ static const struct fb_ops drm_fbdev_dma_fb_ops = {
 	.fb_destroy = drm_fbdev_dma_fb_destroy,
 };
 
-FB_GEN_DEFAULT_DEFERRED_DMAMEM_OPS(drm_fbdev_dma,
+FB_GEN_DEFAULT_DEFERRED_DMAMEM_OPS(drm_fbdev_dma_shadowed,
 				   drm_fb_helper_damage_range,
 				   drm_fb_helper_damage_area);
 
-static int drm_fbdev_dma_deferred_fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
+static void drm_fbdev_dma_shadowed_fb_destroy(struct fb_info *info)
 {
 	struct drm_fb_helper *fb_helper = info->par;
-	struct drm_framebuffer *fb = fb_helper->fb;
-	struct drm_gem_dma_object *dma = drm_fb_dma_get_gem_obj(fb, 0);
+	void *shadow = info->screen_buffer;
+
+	if (!fb_helper->dev)
+		return;
 
-	if (!dma->map_noncoherent)
-		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+	if (info->fbdefio)
+		fb_deferred_io_cleanup(info);
+	drm_fb_helper_fini(fb_helper);
+	vfree(shadow);
 
-	return fb_deferred_io_mmap(info, vma);
+	drm_client_buffer_vunmap(fb_helper->buffer);
+	drm_client_framebuffer_delete(fb_helper->buffer);
+	drm_client_release(&fb_helper->client);
+	drm_fb_helper_unprepare(fb_helper);
+	kfree(fb_helper);
 }
 
-static const struct fb_ops drm_fbdev_dma_deferred_fb_ops = {
+static const struct fb_ops drm_fbdev_dma_shadowed_fb_ops = {
 	.owner = THIS_MODULE,
 	.fb_open = drm_fbdev_dma_fb_open,
 	.fb_release = drm_fbdev_dma_fb_release,
-	__FB_DEFAULT_DEFERRED_OPS_RDWR(drm_fbdev_dma),
+	FB_DEFAULT_DEFERRED_OPS(drm_fbdev_dma_shadowed),
 	DRM_FB_HELPER_DEFAULT_OPS,
-	__FB_DEFAULT_DEFERRED_OPS_DRAW(drm_fbdev_dma),
-	.fb_mmap = drm_fbdev_dma_deferred_fb_mmap,
-	.fb_destroy = drm_fbdev_dma_fb_destroy,
+	.fb_destroy = drm_fbdev_dma_shadowed_fb_destroy,
 };
 
 /*
  * struct drm_fb_helper
  */
 
+static void drm_fbdev_dma_damage_blit_real(struct drm_fb_helper *fb_helper,
+					   struct drm_clip_rect *clip,
+					   struct iosys_map *dst)
+{
+	struct drm_framebuffer *fb = fb_helper->fb;
+	size_t offset = clip->y1 * fb->pitches[0];
+	size_t len = clip->x2 - clip->x1;
+	unsigned int y;
+	void *src;
+
+	switch (drm_format_info_bpp(fb->format, 0)) {
+	case 1:
+		offset += clip->x1 / 8;
+		len = DIV_ROUND_UP(len + clip->x1 % 8, 8);
+		break;
+	case 2:
+		offset += clip->x1 / 4;
+		len = DIV_ROUND_UP(len + clip->x1 % 4, 4);
+		break;
+	case 4:
+		offset += clip->x1 / 2;
+		len = DIV_ROUND_UP(len + clip->x1 % 2, 2);
+		break;
+	default:
+		offset += clip->x1 * fb->format->cpp[0];
+		len *= fb->format->cpp[0];
+		break;
+	}
+
+	src = fb_helper->info->screen_buffer + offset;
+	iosys_map_incr(dst, offset); /* go to first pixel within clip rect */
+
+	for (y = clip->y1; y < clip->y2; y++) {
+		iosys_map_memcpy_to(dst, 0, src, len);
+		iosys_map_incr(dst, fb->pitches[0]);
+		src += fb->pitches[0];
+	}
+}
+
+static int drm_fbdev_dma_damage_blit(struct drm_fb_helper *fb_helper,
+				     struct drm_clip_rect *clip)
+{
+	struct drm_client_buffer *buffer = fb_helper->buffer;
+	struct iosys_map dst;
+
+	/*
+	 * For fbdev emulation, we only have to protect against fbdev modeset
+	 * operations. Nothing else will involve the client buffer's BO. So it
+	 * is sufficient to acquire struct drm_fb_helper.lock here.
+	 */
+	mutex_lock(&fb_helper->lock);
+
+	dst = buffer->map;
+	drm_fbdev_dma_damage_blit_real(fb_helper, clip, &dst);
+
+	mutex_unlock(&fb_helper->lock);
+
+	return 0;
+}
+
 static int drm_fbdev_dma_helper_fb_probe(struct drm_fb_helper *fb_helper,
 					 struct drm_fb_helper_surface_size *sizes)
 {
 	return drm_fbdev_dma_driver_fbdev_probe(fb_helper, sizes);
 }
-
 static int drm_fbdev_dma_helper_fb_dirty(struct drm_fb_helper *helper,
 					 struct drm_clip_rect *clip)
 {
@@ -120,6 +186,10 @@ static int drm_fbdev_dma_helper_fb_dirty(struct drm_fb_helper *helper,
 		return 0;
 
 	if (helper->fb->funcs->dirty) {
+		ret = drm_fbdev_dma_damage_blit(helper, clip);
+		if (drm_WARN_ONCE(dev, ret, "Damage blitter failed: ret=%d\n", ret))
+			return ret;
+
 		ret = helper->fb->funcs->dirty(helper->fb, NULL, 0, 0, clip, 1);
 		if (drm_WARN_ONCE(dev, ret, "Dirty helper failed: ret=%d\n", ret))
 			return ret;
@@ -137,14 +207,80 @@ static const struct drm_fb_helper_funcs drm_fbdev_dma_helper_funcs = {
  * struct drm_fb_helper
  */
 
+static int drm_fbdev_dma_driver_fbdev_probe_tail(struct drm_fb_helper *fb_helper,
+						 struct drm_fb_helper_surface_size *sizes)
+{
+	struct drm_device *dev = fb_helper->dev;
+	struct drm_client_buffer *buffer = fb_helper->buffer;
+	struct drm_gem_dma_object *dma_obj = to_drm_gem_dma_obj(buffer->gem);
+	struct drm_framebuffer *fb = fb_helper->fb;
+	struct fb_info *info = fb_helper->info;
+	struct iosys_map map = buffer->map;
+
+	info->fbops = &drm_fbdev_dma_fb_ops;
+
+	/* screen */
+	info->flags |= FBINFO_VIRTFB; /* system memory */
+	if (dma_obj->map_noncoherent)
+		info->flags |= FBINFO_READS_FAST; /* signal caching */
+	info->screen_size = sizes->surface_height * fb->pitches[0];
+	info->screen_buffer = map.vaddr;
+	if (!(info->flags & FBINFO_HIDE_SMEM_START)) {
+		if (!drm_WARN_ON(dev, is_vmalloc_addr(info->screen_buffer)))
+			info->fix.smem_start = page_to_phys(virt_to_page(info->screen_buffer));
+	}
+	info->fix.smem_len = info->screen_size;
+
+	return 0;
+}
+
+static int drm_fbdev_dma_driver_fbdev_probe_tail_shadowed(struct drm_fb_helper *fb_helper,
+							  struct drm_fb_helper_surface_size *sizes)
+{
+	struct drm_client_buffer *buffer = fb_helper->buffer;
+	struct fb_info *info = fb_helper->info;
+	size_t screen_size = buffer->gem->size;
+	void *screen_buffer;
+	int ret;
+
+	/*
+	 * Deferred I/O requires struct page for framebuffer memory,
+	 * which is not guaranteed for all DMA ranges. We thus create
+	 * a shadow buffer in system memory.
+	 */
+	screen_buffer = vzalloc(screen_size);
+	if (!screen_buffer)
+		return -ENOMEM;
+
+	info->fbops = &drm_fbdev_dma_shadowed_fb_ops;
+
+	/* screen */
+	info->flags |= FBINFO_VIRTFB; /* system memory */
+	info->flags |= FBINFO_READS_FAST; /* signal caching */
+	info->screen_buffer = screen_buffer;
+	info->fix.smem_len = screen_size;
+
+	fb_helper->fbdefio.delay = HZ / 20;
+	fb_helper->fbdefio.deferred_io = drm_fb_helper_deferred_io;
+
+	info->fbdefio = &fb_helper->fbdefio;
+	ret = fb_deferred_io_init(info);
+	if (ret)
+		goto err_vfree;
+
+	return 0;
+
+err_vfree:
+	vfree(screen_buffer);
+	return ret;
+}
+
 int drm_fbdev_dma_driver_fbdev_probe(struct drm_fb_helper *fb_helper,
 				     struct drm_fb_helper_surface_size *sizes)
 {
 	struct drm_client_dev *client = &fb_helper->client;
 	struct drm_device *dev = fb_helper->dev;
-	bool use_deferred_io = false;
 	struct drm_client_buffer *buffer;
-	struct drm_gem_dma_object *dma_obj;
 	struct drm_framebuffer *fb;
 	struct fb_info *info;
 	u32 format;
@@ -161,19 +297,9 @@ int drm_fbdev_dma_driver_fbdev_probe(struct drm_fb_helper *fb_helper,
 					       sizes->surface_height, format);
 	if (IS_ERR(buffer))
 		return PTR_ERR(buffer);
-	dma_obj = to_drm_gem_dma_obj(buffer->gem);
 
 	fb = buffer->fb;
 
-	/*
-	 * Deferred I/O requires struct page for framebuffer memory,
-	 * which is not guaranteed for all DMA ranges. We thus only
-	 * install deferred I/O if we have a framebuffer that requires
-	 * it.
-	 */
-	if (fb->funcs->dirty)
-		use_deferred_io = true;
-
 	ret = drm_client_buffer_vmap(buffer, &map);
 	if (ret) {
 		goto err_drm_client_buffer_delete;
@@ -194,45 +320,12 @@ int drm_fbdev_dma_driver_fbdev_probe(struct drm_fb_helper *fb_helper,
 
 	drm_fb_helper_fill_info(info, fb_helper, sizes);
 
-	if (use_deferred_io)
-		info->fbops = &drm_fbdev_dma_deferred_fb_ops;
+	if (fb->funcs->dirty)
+		ret = drm_fbdev_dma_driver_fbdev_probe_tail_shadowed(fb_helper, sizes);
 	else
-		info->fbops = &drm_fbdev_dma_fb_ops;
-
-	/* screen */
-	info->flags |= FBINFO_VIRTFB; /* system memory */
-	if (dma_obj->map_noncoherent)
-		info->flags |= FBINFO_READS_FAST; /* signal caching */
-	info->screen_size = sizes->surface_height * fb->pitches[0];
-	info->screen_buffer = map.vaddr;
-	if (!(info->flags & FBINFO_HIDE_SMEM_START)) {
-		if (!drm_WARN_ON(dev, is_vmalloc_addr(info->screen_buffer)))
-			info->fix.smem_start = page_to_phys(virt_to_page(info->screen_buffer));
-	}
-	info->fix.smem_len = info->screen_size;
-
-	/*
-	 * Only set up deferred I/O if the screen buffer supports
-	 * it. If this disagrees with the previous test for ->dirty,
-	 * mmap on the /dev/fb file might not work correctly.
-	 */
-	if (!is_vmalloc_addr(info->screen_buffer) && info->fix.smem_start) {
-		unsigned long pfn = info->fix.smem_start >> PAGE_SHIFT;
-
-		if (drm_WARN_ON(dev, !pfn_to_page(pfn)))
-			use_deferred_io = false;
-	}
-
-	/* deferred I/O */
-	if (use_deferred_io) {
-		fb_helper->fbdefio.delay = HZ / 20;
-		fb_helper->fbdefio.deferred_io = drm_fb_helper_deferred_io;
-
-		info->fbdefio = &fb_helper->fbdefio;
-		ret = fb_deferred_io_init(info);
-		if (ret)
-			goto err_drm_fb_helper_release_info;
-	}
+		ret = drm_fbdev_dma_driver_fbdev_probe_tail(fb_helper, sizes);
+	if (ret)
+		goto err_drm_fb_helper_release_info;
 
 	return 0;
 
-- 
2.39.5



