Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E366619AD46;
	Thu,  6 Jun 2024 14:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683332; cv=none; b=kfTMr4mTOIhyffyD9YsEOU7hyCuIqS2Uu4qWQr5HraaPJcjMVWmR95HVzX5nP2RpSSPNoYwsrXrG4SaRS9GpF9Ud7sHZ7XqmFsLJADYTVeydYs9W1+O9k/5PRpIuk8pcCeooxrMnC1U+ECoDxDJf5xwbbRv7G1YuZqs9ho/LcyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683332; c=relaxed/simple;
	bh=C+dxkKEibI1M2QNL66H1F8YwMtEwuHtXbImeYGByfJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7KivhTZBb96F9m9zZtTD2v5lFkq7S8AGcf7O33rJoWxzYGsrrP9Owu4AR3oGgeNN7FYZ5XejzwYU3gUSrIjWJ9UUDXJnt3jOLMsevYRfW9iDX+gFE00JH3+GFwAPI0dpnzI8QWPIDhOTN768XCGcnuvQjy+RwCbWRdsx4I8IwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsOOpdmr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsOOpdmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC46AC2BD10;
	Thu,  6 Jun 2024 14:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683331;
	bh=C+dxkKEibI1M2QNL66H1F8YwMtEwuHtXbImeYGByfJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsOOpdmr69n4p1Qed68KDVlnOC39NToau4MvzlpQxQ7GP38zIuyjKwaMssQ8BNy29
	 SYwhncL0sKwJnHa+XetCzwPb1SShfu9YaPTrfR9Zd27S0zgRWGN3AA8BATUK1npBD4
	 ivbqLlNRhdR3E6ATnZtJ5/8+85iBTEfMijOwGws8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tony Lindgren <tony@atomide.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 273/744] drm/omapdrm: Fix console with deferred ops
Date: Thu,  6 Jun 2024 15:59:05 +0200
Message-ID: <20240606131741.138442845@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 01c0cce88c5480cc2505b79330246ef12eda938f ]

Commit 95da53d63dcf ("drm/omapdrm: Use regular fbdev I/O helpers")
stopped console from updating for command mode displays because there is
no damage handling in fb_sys_write() unlike we had earlier in
drm_fb_helper_sys_write().

Let's fix the issue by adding FB_GEN_DEFAULT_DEFERRED_DMAMEM_OPS and
FB_DMAMEM_HELPERS_DEFERRED as suggested by Thomas. We cannot use the
FB_DEFAULT_DEFERRED_OPS as fb_deferred_io_mmap() won't work properly
for write-combine.

Fixes: 95da53d63dcf ("drm/omapdrm: Use regular fbdev I/O helpers")
Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240228063540.4444-3-tony@atomide.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/Kconfig      |  2 +-
 drivers/gpu/drm/omapdrm/omap_fbdev.c | 28 ++++++++++++++++++++++------
 drivers/video/fbdev/core/Kconfig     |  6 ++++++
 include/linux/fb.h                   |  4 ++++
 4 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/Kconfig b/drivers/gpu/drm/omapdrm/Kconfig
index b715301ec79f6..6c49270cb290a 100644
--- a/drivers/gpu/drm/omapdrm/Kconfig
+++ b/drivers/gpu/drm/omapdrm/Kconfig
@@ -4,7 +4,7 @@ config DRM_OMAP
 	depends on DRM && OF
 	depends on ARCH_OMAP2PLUS
 	select DRM_KMS_HELPER
-	select FB_DMAMEM_HELPERS if DRM_FBDEV_EMULATION
+	select FB_DMAMEM_HELPERS_DEFERRED if DRM_FBDEV_EMULATION
 	select VIDEOMODE_HELPERS
 	select HDMI
 	default n
diff --git a/drivers/gpu/drm/omapdrm/omap_fbdev.c b/drivers/gpu/drm/omapdrm/omap_fbdev.c
index 7c5af3de1e727..523be34682caf 100644
--- a/drivers/gpu/drm/omapdrm/omap_fbdev.c
+++ b/drivers/gpu/drm/omapdrm/omap_fbdev.c
@@ -51,6 +51,10 @@ static void pan_worker(struct work_struct *work)
 	omap_gem_roll(bo, fbi->var.yoffset * npages);
 }
 
+FB_GEN_DEFAULT_DEFERRED_DMAMEM_OPS(omap_fbdev,
+				   drm_fb_helper_damage_range,
+				   drm_fb_helper_damage_area)
+
 static int omap_fbdev_pan_display(struct fb_var_screeninfo *var,
 		struct fb_info *fbi)
 {
@@ -78,11 +82,9 @@ static int omap_fbdev_pan_display(struct fb_var_screeninfo *var,
 
 static int omap_fbdev_fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
-	struct drm_fb_helper *helper = info->par;
-	struct drm_framebuffer *fb = helper->fb;
-	struct drm_gem_object *bo = drm_gem_fb_get_obj(fb, 0);
+	vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
 
-	return drm_gem_mmap_obj(bo, omap_gem_mmap_size(bo), vma);
+	return fb_deferred_io_mmap(info, vma);
 }
 
 static void omap_fbdev_fb_destroy(struct fb_info *info)
@@ -94,6 +96,7 @@ static void omap_fbdev_fb_destroy(struct fb_info *info)
 
 	DBG();
 
+	fb_deferred_io_cleanup(info);
 	drm_fb_helper_fini(helper);
 
 	omap_gem_unpin(bo);
@@ -104,15 +107,19 @@ static void omap_fbdev_fb_destroy(struct fb_info *info)
 	kfree(fbdev);
 }
 
+/*
+ * For now, we cannot use FB_DEFAULT_DEFERRED_OPS and fb_deferred_io_mmap()
+ * because we use write-combine.
+ */
 static const struct fb_ops omap_fb_ops = {
 	.owner = THIS_MODULE,
-	__FB_DEFAULT_DMAMEM_OPS_RDWR,
+	__FB_DEFAULT_DEFERRED_OPS_RDWR(omap_fbdev),
 	.fb_check_var	= drm_fb_helper_check_var,
 	.fb_set_par	= drm_fb_helper_set_par,
 	.fb_setcmap	= drm_fb_helper_setcmap,
 	.fb_blank	= drm_fb_helper_blank,
 	.fb_pan_display = omap_fbdev_pan_display,
-	__FB_DEFAULT_DMAMEM_OPS_DRAW,
+	__FB_DEFAULT_DEFERRED_OPS_DRAW(omap_fbdev),
 	.fb_ioctl	= drm_fb_helper_ioctl,
 	.fb_mmap	= omap_fbdev_fb_mmap,
 	.fb_destroy	= omap_fbdev_fb_destroy,
@@ -213,6 +220,15 @@ static int omap_fbdev_create(struct drm_fb_helper *helper,
 	fbi->fix.smem_start = dma_addr;
 	fbi->fix.smem_len = bo->size;
 
+	/* deferred I/O */
+	helper->fbdefio.delay = HZ / 20;
+	helper->fbdefio.deferred_io = drm_fb_helper_deferred_io;
+
+	fbi->fbdefio = &helper->fbdefio;
+	ret = fb_deferred_io_init(fbi);
+	if (ret)
+		goto fail;
+
 	/* if we have DMM, then we can use it for scrolling by just
 	 * shuffling pages around in DMM rather than doing sw blit.
 	 */
diff --git a/drivers/video/fbdev/core/Kconfig b/drivers/video/fbdev/core/Kconfig
index 56f721ebcff05..acb19045d3046 100644
--- a/drivers/video/fbdev/core/Kconfig
+++ b/drivers/video/fbdev/core/Kconfig
@@ -145,6 +145,12 @@ config FB_DMAMEM_HELPERS
 	select FB_SYS_FOPS
 	select FB_SYS_IMAGEBLIT
 
+config FB_DMAMEM_HELPERS_DEFERRED
+	bool
+	depends on FB_CORE
+	select FB_DEFERRED_IO
+	select FB_DMAMEM_HELPERS
+
 config FB_IOMEM_FOPS
 	tristate
 	depends on FB_CORE
diff --git a/include/linux/fb.h b/include/linux/fb.h
index c14576458228a..322b4d20afa55 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -690,6 +690,10 @@ extern int fb_deferred_io_fsync(struct file *file, loff_t start,
 	__FB_GEN_DEFAULT_DEFERRED_OPS_RDWR(__prefix, __damage_range, sys) \
 	__FB_GEN_DEFAULT_DEFERRED_OPS_DRAW(__prefix, __damage_area, sys)
 
+#define FB_GEN_DEFAULT_DEFERRED_DMAMEM_OPS(__prefix, __damage_range, __damage_area) \
+	__FB_GEN_DEFAULT_DEFERRED_OPS_RDWR(__prefix, __damage_range, sys) \
+	__FB_GEN_DEFAULT_DEFERRED_OPS_DRAW(__prefix, __damage_area, sys)
+
 /*
  * Initializes struct fb_ops for deferred I/O.
  */
-- 
2.43.0



