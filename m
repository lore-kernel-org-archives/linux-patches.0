Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808C4FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EDEC433D2;
	Mon, 15 May 2023 17:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170092;
	bh=eVxlkhFDQ8P0oSPyzRU8a03o0UJh4A8zZkXgKFMIk0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LN9xOgXTZ1SSJhUzU9ZWJVggXPb5L31TDxoB/dp/hT0PxuZR05tacfyprzTUByCEw
	 CsZfdttoNlZuWwkrymR/rrF8p1tndIkGhz53zgbg73TL9c4nIn3tCNjUSRNT8Ukr/Z
	 jkn+7koxkv2b01oXsQ5a+VC5d+hKjMoOflGf6byk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Krastev <krastevm@vmware.com>,
	Maaz Mombasawala <mombasawalam@vmware.com>,
	Zack Rusin <zackr@vmware.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/239] drm/vmwgfx: Fix Legacy Display Unit atomic drm support
Date: Mon, 15 May 2023 18:24:27 +0200
Message-Id: <20230515161721.688281014@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Krastev <krastevm@vmware.com>

[ Upstream commit a37a512db3fa1b65fe9087003e5b2072cefb3667 ]

Legacy Display Unit (LDU) fb dirty support used a custom fb dirty callback. Latter
handled only the DIRTYFB IOCTL presentation path but not the ADDFB2/PAGE_FLIP/RMFB
IOCTL path, common for Wayland compositors.

Get rid of the custom callback in favor of drm_atomic_helper_dirtyfb and unify the
handling of the presentation paths inside of vmw_ldu_primary_plane_atomic_update.
This also homogenizes the fb dirty callbacks across all DUs: LDU, SOU and STDU.

Signed-off-by: Martin Krastev <krastevm@vmware.com>
Reviewed-by: Maaz Mombasawala <mombasawalam@vmware.com>
Fixes: 2f5544ff0300 ("drm/vmwgfx: Use atomic helper function for dirty fb IOCTL")
Cc: <stable@vger.kernel.org> # v5.0+
Signed-off-by: Zack Rusin <zackr@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230321020949.335012-3-zack@kde.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 62 +----------------------------
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h |  5 ---
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c | 45 +++++++++++++++++----
 3 files changed, 38 insertions(+), 74 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index d5c4da2b05b1a..aab6389cb4aab 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1264,70 +1264,10 @@ static void vmw_framebuffer_bo_destroy(struct drm_framebuffer *framebuffer)
 	kfree(vfbd);
 }
 
-static int vmw_framebuffer_bo_dirty(struct drm_framebuffer *framebuffer,
-				    struct drm_file *file_priv,
-				    unsigned int flags, unsigned int color,
-				    struct drm_clip_rect *clips,
-				    unsigned int num_clips)
-{
-	struct vmw_private *dev_priv = vmw_priv(framebuffer->dev);
-	struct vmw_framebuffer_bo *vfbd =
-		vmw_framebuffer_to_vfbd(framebuffer);
-	struct drm_clip_rect norect;
-	int ret, increment = 1;
-
-	drm_modeset_lock_all(&dev_priv->drm);
-
-	if (!num_clips) {
-		num_clips = 1;
-		clips = &norect;
-		norect.x1 = norect.y1 = 0;
-		norect.x2 = framebuffer->width;
-		norect.y2 = framebuffer->height;
-	} else if (flags & DRM_MODE_FB_DIRTY_ANNOTATE_COPY) {
-		num_clips /= 2;
-		increment = 2;
-	}
-
-	switch (dev_priv->active_display_unit) {
-	case vmw_du_legacy:
-		ret = vmw_kms_ldu_do_bo_dirty(dev_priv, &vfbd->base, 0, 0,
-					      clips, num_clips, increment);
-		break;
-	default:
-		ret = -EINVAL;
-		WARN_ONCE(true, "Dirty called with invalid display system.\n");
-		break;
-	}
-
-	vmw_cmd_flush(dev_priv, false);
-
-	drm_modeset_unlock_all(&dev_priv->drm);
-
-	return ret;
-}
-
-static int vmw_framebuffer_bo_dirty_ext(struct drm_framebuffer *framebuffer,
-					struct drm_file *file_priv,
-					unsigned int flags, unsigned int color,
-					struct drm_clip_rect *clips,
-					unsigned int num_clips)
-{
-	struct vmw_private *dev_priv = vmw_priv(framebuffer->dev);
-
-	if (dev_priv->active_display_unit == vmw_du_legacy &&
-	    vmw_cmd_supported(dev_priv))
-		return vmw_framebuffer_bo_dirty(framebuffer, file_priv, flags,
-						color, clips, num_clips);
-
-	return drm_atomic_helper_dirtyfb(framebuffer, file_priv, flags, color,
-					 clips, num_clips);
-}
-
 static const struct drm_framebuffer_funcs vmw_framebuffer_bo_funcs = {
 	.create_handle = vmw_framebuffer_bo_create_handle,
 	.destroy = vmw_framebuffer_bo_destroy,
-	.dirty = vmw_framebuffer_bo_dirty_ext,
+	.dirty = drm_atomic_helper_dirtyfb,
 };
 
 /*
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
index 85f86faa32439..b02d2793659f9 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
@@ -517,11 +517,6 @@ void vmw_du_connector_destroy_state(struct drm_connector *connector,
  */
 int vmw_kms_ldu_init_display(struct vmw_private *dev_priv);
 int vmw_kms_ldu_close_display(struct vmw_private *dev_priv);
-int vmw_kms_ldu_do_bo_dirty(struct vmw_private *dev_priv,
-			    struct vmw_framebuffer *framebuffer,
-			    unsigned int flags, unsigned int color,
-			    struct drm_clip_rect *clips,
-			    unsigned int num_clips, int increment);
 int vmw_kms_update_proxy(struct vmw_resource *res,
 			 const struct drm_clip_rect *clips,
 			 unsigned num_clips,
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c b/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
index a56e5d0ca3c65..ac72c20715f32 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
@@ -234,6 +234,7 @@ static const struct drm_crtc_funcs vmw_legacy_crtc_funcs = {
 	.atomic_duplicate_state = vmw_du_crtc_duplicate_state,
 	.atomic_destroy_state = vmw_du_crtc_destroy_state,
 	.set_config = drm_atomic_helper_set_config,
+	.page_flip = drm_atomic_helper_page_flip,
 };
 
 
@@ -273,6 +274,12 @@ static const struct
 drm_connector_helper_funcs vmw_ldu_connector_helper_funcs = {
 };
 
+static int vmw_kms_ldu_do_bo_dirty(struct vmw_private *dev_priv,
+				   struct vmw_framebuffer *framebuffer,
+				   unsigned int flags, unsigned int color,
+				   struct drm_mode_rect *clips,
+				   unsigned int num_clips);
+
 /*
  * Legacy Display Plane Functions
  */
@@ -291,7 +298,6 @@ vmw_ldu_primary_plane_atomic_update(struct drm_plane *plane,
 	struct drm_framebuffer *fb;
 	struct drm_crtc *crtc = new_state->crtc ?: old_state->crtc;
 
-
 	ldu = vmw_crtc_to_ldu(crtc);
 	dev_priv = vmw_priv(plane->dev);
 	fb       = new_state->fb;
@@ -304,8 +310,31 @@ vmw_ldu_primary_plane_atomic_update(struct drm_plane *plane,
 		vmw_ldu_del_active(dev_priv, ldu);
 
 	vmw_ldu_commit_list(dev_priv);
-}
 
+	if (vfb && vmw_cmd_supported(dev_priv)) {
+		struct drm_mode_rect fb_rect = {
+			.x1 = 0,
+			.y1 = 0,
+			.x2 = vfb->base.width,
+			.y2 = vfb->base.height
+		};
+		struct drm_mode_rect *damage_rects = drm_plane_get_damage_clips(new_state);
+		u32 rect_count = drm_plane_get_damage_clips_count(new_state);
+		int ret;
+
+		if (!damage_rects) {
+			damage_rects = &fb_rect;
+			rect_count = 1;
+		}
+
+		ret = vmw_kms_ldu_do_bo_dirty(dev_priv, vfb, 0, 0, damage_rects, rect_count);
+
+		drm_WARN_ONCE(plane->dev, ret,
+			"vmw_kms_ldu_do_bo_dirty failed with: ret=%d\n", ret);
+
+		vmw_cmd_flush(dev_priv, false);
+	}
+}
 
 static const struct drm_plane_funcs vmw_ldu_plane_funcs = {
 	.update_plane = drm_atomic_helper_update_plane,
@@ -536,11 +565,11 @@ int vmw_kms_ldu_close_display(struct vmw_private *dev_priv)
 }
 
 
-int vmw_kms_ldu_do_bo_dirty(struct vmw_private *dev_priv,
-			    struct vmw_framebuffer *framebuffer,
-			    unsigned int flags, unsigned int color,
-			    struct drm_clip_rect *clips,
-			    unsigned int num_clips, int increment)
+static int vmw_kms_ldu_do_bo_dirty(struct vmw_private *dev_priv,
+				   struct vmw_framebuffer *framebuffer,
+				   unsigned int flags, unsigned int color,
+				   struct drm_mode_rect *clips,
+				   unsigned int num_clips)
 {
 	size_t fifo_size;
 	int i;
@@ -556,7 +585,7 @@ int vmw_kms_ldu_do_bo_dirty(struct vmw_private *dev_priv,
 		return -ENOMEM;
 
 	memset(cmd, 0, fifo_size);
-	for (i = 0; i < num_clips; i++, clips += increment) {
+	for (i = 0; i < num_clips; i++, clips++) {
 		cmd[i].header = SVGA_CMD_UPDATE;
 		cmd[i].body.x = clips->x1;
 		cmd[i].body.y = clips->y1;
-- 
2.39.2



