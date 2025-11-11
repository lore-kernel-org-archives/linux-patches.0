Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C49303CAE;
	Tue, 11 Nov 2025 01:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823294; cv=none; b=We56jNmqQ3rIVyI/e73Kt7Uv5FTbt5YZBPjzYLi8/q1wLMijB78UVZyaaoSR1nQt7QN1FW6k6DDS0Hl/IxZZ09MkvknFTOT1UJprCATAdNfSrCM7Gs3gNgt9GgoK4H0jrHFdY4CGtZEXIrAqM1Gswc3jkptxS8oZRRYHRG/HnSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823294; c=relaxed/simple;
	bh=3iXnmmi16rEpRBDcRIA0W0fdnYWw5WC6Zl03GVUBg+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UODVBbs0R3r5ZGs4kwZ8dd8aJS9Y922wfiJmsBnw+GqE7sp0LK4j9L4z9xFKxjadd95qtCIKRtz6huJnj4tZS7V4m+Ud8NxpeEX39AT+InSM9CFugrT+/CvqVAFGDsgisX47ha6ac4gr0xBR/3xJbs/SyvuSKF+GG03qo6RaRTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJWQBkJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJWQBkJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2973FC4CEFB;
	Tue, 11 Nov 2025 01:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823294;
	bh=3iXnmmi16rEpRBDcRIA0W0fdnYWw5WC6Zl03GVUBg+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJWQBkJUvflz5EteC/ABNs7/PC630maPg7KDIFgMtQQbeMvt3ZSn8Z16yaODTWbQD
	 W96HrzJgO9++Yvm4Ilt012BTuKmMz9lW+2duO+Vtgmgn5Px5NWznDYpkP4Ap6TQPGj
	 N2CtKDIwCh/FfeIUj8eprk6LMMXUo+Ldrji0iDGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 270/849] drm/sharp-memory: Do not access GEM-DMA vaddr directly
Date: Tue, 11 Nov 2025 09:37:20 +0900
Message-ID: <20251111004542.957821040@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 136c374d8c80378d2982a46b2adabfc007299641 ]

Use DRM's shadow-plane helper to map and access the GEM object's buffer
within kernel address space. Encapsulates the vmap logic in the GEM-DMA
helpers.

The sharp-memory driver currently reads the vaddr field from the GME
buffer object directly. This only works because GEM code 'automagically'
sets vaddr.

Shadow-plane helpers perform the same steps, but with correct abstraction
behind drm_gem_vmap(). The shadow-plane state provides the buffer address
in kernel address space and the format-conversion state.

v2:
- fix typo in commit description

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://lore.kernel.org/r/20250627152327.8244-1-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/sharp-memory.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/tiny/sharp-memory.c b/drivers/gpu/drm/tiny/sharp-memory.c
index 03d2850310c47..64272cd0f6e22 100644
--- a/drivers/gpu/drm/tiny/sharp-memory.c
+++ b/drivers/gpu/drm/tiny/sharp-memory.c
@@ -126,28 +126,28 @@ static inline void sharp_memory_set_tx_buffer_addresses(u8 *buffer,
 
 static void sharp_memory_set_tx_buffer_data(u8 *buffer,
 					    struct drm_framebuffer *fb,
+					    const struct iosys_map *vmap,
 					    struct drm_rect clip,
 					    u32 pitch,
 					    struct drm_format_conv_state *fmtcnv_state)
 {
 	int ret;
-	struct iosys_map dst, vmap;
-	struct drm_gem_dma_object *dma_obj = drm_fb_dma_get_gem_obj(fb, 0);
+	struct iosys_map dst;
 
 	ret = drm_gem_fb_begin_cpu_access(fb, DMA_FROM_DEVICE);
 	if (ret)
 		return;
 
 	iosys_map_set_vaddr(&dst, buffer);
-	iosys_map_set_vaddr(&vmap, dma_obj->vaddr);
 
-	drm_fb_xrgb8888_to_mono(&dst, &pitch, &vmap, fb, &clip, fmtcnv_state);
+	drm_fb_xrgb8888_to_mono(&dst, &pitch, vmap, fb, &clip, fmtcnv_state);
 
 	drm_gem_fb_end_cpu_access(fb, DMA_FROM_DEVICE);
 }
 
 static int sharp_memory_update_display(struct sharp_memory_device *smd,
 				       struct drm_framebuffer *fb,
+				       const struct iosys_map *vmap,
 				       struct drm_rect clip,
 				       struct drm_format_conv_state *fmtcnv_state)
 {
@@ -163,7 +163,7 @@ static int sharp_memory_update_display(struct sharp_memory_device *smd,
 	sharp_memory_set_tx_buffer_mode(&tx_buffer[0],
 					SHARP_MEMORY_DISPLAY_UPDATE_MODE, vcom);
 	sharp_memory_set_tx_buffer_addresses(&tx_buffer[1], clip, pitch);
-	sharp_memory_set_tx_buffer_data(&tx_buffer[2], fb, clip, pitch, fmtcnv_state);
+	sharp_memory_set_tx_buffer_data(&tx_buffer[2], fb, vmap, clip, pitch, fmtcnv_state);
 
 	ret = sharp_memory_spi_write(smd->spi, tx_buffer, tx_buffer_size);
 
@@ -206,7 +206,8 @@ static int sharp_memory_clear_display(struct sharp_memory_device *smd)
 	return ret;
 }
 
-static void sharp_memory_fb_dirty(struct drm_framebuffer *fb, struct drm_rect *rect,
+static void sharp_memory_fb_dirty(struct drm_framebuffer *fb, const struct iosys_map *vmap,
+				  struct drm_rect *rect,
 				  struct drm_format_conv_state *fmtconv_state)
 {
 	struct drm_rect clip;
@@ -218,7 +219,7 @@ static void sharp_memory_fb_dirty(struct drm_framebuffer *fb, struct drm_rect *r
 	clip.y1 = rect->y1;
 	clip.y2 = rect->y2;
 
-	sharp_memory_update_display(smd, fb, clip, fmtconv_state);
+	sharp_memory_update_display(smd, fb, vmap, clip, fmtconv_state);
 }
 
 static int sharp_memory_plane_atomic_check(struct drm_plane *plane,
@@ -242,7 +243,7 @@ static void sharp_memory_plane_atomic_update(struct drm_plane *plane,
 {
 	struct drm_plane_state *old_state = drm_atomic_get_old_plane_state(state, plane);
 	struct drm_plane_state *plane_state = plane->state;
-	struct drm_format_conv_state fmtcnv_state = DRM_FORMAT_CONV_STATE_INIT;
+	struct drm_shadow_plane_state *shadow_plane_state = to_drm_shadow_plane_state(plane_state);
 	struct sharp_memory_device *smd;
 	struct drm_rect rect;
 
@@ -251,15 +252,15 @@ static void sharp_memory_plane_atomic_update(struct drm_plane *plane,
 		return;
 
 	if (drm_atomic_helper_damage_merged(old_state, plane_state, &rect))
-		sharp_memory_fb_dirty(plane_state->fb, &rect, &fmtcnv_state);
-
-	drm_format_conv_state_release(&fmtcnv_state);
+		sharp_memory_fb_dirty(plane_state->fb, shadow_plane_state->data,
+				      &rect, &shadow_plane_state->fmtcnv_state);
 }
 
 static const struct drm_plane_helper_funcs sharp_memory_plane_helper_funcs = {
 	.prepare_fb = drm_gem_plane_helper_prepare_fb,
 	.atomic_check = sharp_memory_plane_atomic_check,
 	.atomic_update = sharp_memory_plane_atomic_update,
+	DRM_GEM_SHADOW_PLANE_HELPER_FUNCS,
 };
 
 static bool sharp_memory_format_mod_supported(struct drm_plane *plane,
@@ -273,9 +274,7 @@ static const struct drm_plane_funcs sharp_memory_plane_funcs = {
 	.update_plane = drm_atomic_helper_update_plane,
 	.disable_plane = drm_atomic_helper_disable_plane,
 	.destroy = drm_plane_cleanup,
-	.reset = drm_atomic_helper_plane_reset,
-	.atomic_duplicate_state	= drm_atomic_helper_plane_duplicate_state,
-	.atomic_destroy_state = drm_atomic_helper_plane_destroy_state,
+	DRM_GEM_SHADOW_PLANE_FUNCS,
 	.format_mod_supported = sharp_memory_format_mod_supported,
 };
 
-- 
2.51.0



