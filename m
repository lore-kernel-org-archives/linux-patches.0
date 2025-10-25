Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BD278F36;
	Sat, 25 Oct 2025 16:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409279; cv=none; b=s8lEZRd0U7X05Ck5mc8cB5cipjxvHWvhlL1rifC0VeSQ0jTOm2yxIW1LWoTix2u94qyb1L31zLTRwYFtI1FN56Myh7eUnQDNIqgMUMKNJSeaPGYdVeZPmaAfJE+f4W68tjCIgJ4uGNTvOgdqdnZyDRIKWnK7mYSmeQx1Ba5OwOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409279; c=relaxed/simple;
	bh=Tz3JD8lA7fydnafavQSE7tQ5diF4dj53zSCHl9zVL28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AMwwE6jv1cXciWfeDfVd8OWwm9rY/AhNDgc7OQdu2XSSJjmToSDUQ74vTNX594ljV5r6NZxngRQvq891usSB3wRfrIKvKBEIhbeIuyFsjKuGwgDKHpzKDos1K4FQeQMHSSIwd8tkeoDBflrrUjHnrQWV/LqN3fr3fUZ7HEAA/zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M1R5468r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M1R5468r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5B0C19422;
	Sat, 25 Oct 2025 16:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409278;
	bh=Tz3JD8lA7fydnafavQSE7tQ5diF4dj53zSCHl9zVL28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1R5468rTsio7t8BO8z0hpMiIFt0AEpB7wlAH6wwheVRzDNZqkfk4w9MMylQbLrG7
	 AX48EquP7jqbXBIsqFxPni/5bsd8vMSQF9QQBG/gfvRX6pficfs+N50k4/SC9kWRoe
	 8qwSnutCSamWgOu25cWevxRWnhpU+T60SKoZQOMQAKI2KGlBsRMbJlIwx/rOhr93yv
	 QTf2u/TN2H6CYDw9j0xA/tLbD+9+MEEB49UZQMfOkklV4+Hcea5Oc8r+UdbBEy3fMg
	 7PlAuBiof1e3rjTt+ngBqIK6efyHureccOko4UL6JUU3o3TX2OHVrVA3RWBbbTo998
	 2jA5L2fT02duw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	lanzano.alex@gmail.com
Subject: [PATCH AUTOSEL 6.17] drm/sharp-memory: Do not access GEM-DMA vaddr directly
Date: Sat, 25 Oct 2025 11:58:10 -0400
Message-ID: <20251025160905.3857885-259-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES

Explanation
- Fixes an architectural misuse and a real correctness bug. The driver
  previously read the DMA GEM buffer’s CPU pointer directly via
  `dma_obj->vaddr` in `sharp_memory_set_tx_buffer_data()` and fed it to
  `drm_fb_xrgb8888_to_mono()`. That bypasses the proper vmap abstraction
  and, more importantly, fails to account for framebuffer plane offsets.
  The conversion helpers expect src pointers that already include
  `fb->offsets[0]`. See `drm_fb_xrgb8888_to_mono()` which uses
  `src[0].vaddr` directly (drivers/gpu/drm/drm_format_helper.c:1210) and
  does not add `fb->offsets[0]`. Properly computed data pointers are
  provided by `drm_gem_fb_vmap()` into the shadow state’s `data[]` array
  (drivers/gpu/drm/drm_gem_framebuffer_helper.c:352 and :320), where
  `data[i]` is `map[i] + fb->offsets[i]`. This commit switches to that
  path, fixing potential misreads when offsets are non‑zero.
- Uses standard GEM shadow-plane helpers already present in stable. The
  patch adopts `DRM_GEM_SHADOW_PLANE_HELPER_FUNCS` and
  `DRM_GEM_SHADOW_PLANE_FUNCS`, which wire up
  `.begin_fb_access`/`.end_fb_access` and state reset/dup/destroy for
  shadow-buffered planes. These helpers exist in stable trees (e.g.,
  6.12.x). See include/drm/drm_gem_atomic_helper.h:109 and :125 and
  their implementation in drivers/gpu/drm/drm_gem_atomic_helper.c:365
  and :416, which call `drm_gem_fb_vmap()`/`drm_gem_fb_vunmap()` to
  manage mappings correctly and surface `shadow_plane_state->data` for
  use in `atomic_update`.
- Changes are small and self-contained to the tiny driver. Only
  `drivers/gpu/drm/tiny/sharp-memory.c` is touched:
  - `sharp_memory_set_tx_buffer_data()` now takes `const struct
    iosys_map *vmap` and uses that instead of `dma_obj->vaddr`.
  - `sharp_memory_update_display()` and `sharp_memory_fb_dirty()` are
    updated to thread `vmap` through.
  - `sharp_memory_plane_atomic_update()` switches to
    `to_drm_shadow_plane_state(plane_state)` and uses
    `shadow_plane_state->data` and `shadow_plane_state->fmtcnv_state`,
    removing manual `drm_format_conv_state` handling.
  - Plane helper/func tables add `DRM_GEM_SHADOW_PLANE_HELPER_FUNCS` and
    replace manual reset/dup/destroy with `DRM_GEM_SHADOW_PLANE_FUNCS`.
- No feature additions or architecture changes. This is a
  correctness/abstraction fix with minimal surface area. The functional
  behavior (convert XR24 to mono and push via SPI) remains the same;
  mapping and format-conversion state are now handled via shared
  helpers.
- Low regression risk and consistent with other drivers. Multiple DRM
  tiny and simple drivers already use these shadow-plane helpers in
  stable (for example tiny/simpledrm.c:690 and tiny/ofdrm.c:876,
  vboxvideo/vbox_mode.c:474, and ast/ast_mode.c:721 reference the same
  macros). The conversion helper semantics remain unchanged.
- Stable policy alignment. While the commit message doesn’t carry
  “Fixes:”/“Cc: stable”, it resolves a real bug (incorrect source
  pointer when `fb->offsets[0] != 0`) and removes a layering violation
  that could break if underlying implementation details change. It is
  localized, low-risk, and improves ABI/locking correctness by using
  `drm_gem_fb_vmap()` and the begin/end access hooks.

Notes
- Ensure the target stable branch actually contains this driver. If the
  driver isn’t present in the target tree, the backport is moot. Where
  present and the shadow-plane helpers are available (they are in
  6.12.x), this change should apply cleanly.

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

