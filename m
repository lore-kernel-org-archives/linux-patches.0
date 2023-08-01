Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91461F955
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA6DC433C8;
	Tue,  1 Aug 2023 09:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882233;
	bh=VAirNb1QFOoBJ9VMCKjDwlVdQq1UaXHfbslTPQjKGeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpNEu+BuKjiwpaagkqmvN+Ft/Fd38kCDIwMI87r7JfQyFzYQu0LLTY8FFoVXW4k3m
	 psYnpaQz3Yu8OJNtc4zYsHvGNftMRAZcm8TLlVeeZZAxhDN/0ZkVumMKjRPsaVPHtH
	 lWWH30ZhmvQbgtRx8EoBzufV3G6XM0LEpfKzk9BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Li <sunpeng.li@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/228] drm/amd/display: add FB_DAMAGE_CLIPS support
Date: Tue,  1 Aug 2023 11:18:11 +0200
Message-ID: <20230801091924.079806310@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

[ Upstream commit 30ebe41582d1ea5a7de990319f9e593dad4886f7 ]

Currently, userspace doesn't have a way to communicate selective updates
to displays. So, enable support for FB_DAMAGE_CLIPS for DCN ASICs newer
than DCN301, convert DRM damage clips to dc dirty rectangles and fill
them into dirty_rects in fill_dc_dirty_rects().

Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 72f1de49ffb9 ("drm/dp_mst: Clear MSG_RDY flag before sending new message")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 130 +++++++++++-------
 .../amd/display/amdgpu_dm/amdgpu_dm_plane.c   |   4 +
 2 files changed, 88 insertions(+), 46 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index ce5df7927c21f..f6165edc6c433 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4948,6 +4948,35 @@ static int fill_dc_plane_attributes(struct amdgpu_device *adev,
 	return 0;
 }
 
+static inline void fill_dc_dirty_rect(struct drm_plane *plane,
+				      struct rect *dirty_rect, int32_t x,
+				      int32_t y, int32_t width, int32_t height,
+				      int *i, bool ffu)
+{
+	if (*i > DC_MAX_DIRTY_RECTS)
+		return;
+
+	if (*i == DC_MAX_DIRTY_RECTS)
+		goto out;
+
+	dirty_rect->x = x;
+	dirty_rect->y = y;
+	dirty_rect->width = width;
+	dirty_rect->height = height;
+
+	if (ffu)
+		drm_dbg(plane->dev,
+			"[PLANE:%d] PSR FFU dirty rect size (%d, %d)\n",
+			plane->base.id, width, height);
+	else
+		drm_dbg(plane->dev,
+			"[PLANE:%d] PSR SU dirty rect at (%d, %d) size (%d, %d)",
+			plane->base.id, x, y, width, height);
+
+out:
+	(*i)++;
+}
+
 /**
  * fill_dc_dirty_rects() - Fill DC dirty regions for PSR selective updates
  *
@@ -4968,10 +4997,6 @@ static int fill_dc_plane_attributes(struct amdgpu_device *adev,
  * addition, certain use cases - such as cursor and multi-plane overlay (MPO) -
  * implicitly provide damage clips without any client support via the plane
  * bounds.
- *
- * Today, amdgpu_dm only supports the MPO and cursor usecase.
- *
- * TODO: Also enable for FB_DAMAGE_CLIPS
  */
 static void fill_dc_dirty_rects(struct drm_plane *plane,
 				struct drm_plane_state *old_plane_state,
@@ -4982,12 +5007,11 @@ static void fill_dc_dirty_rects(struct drm_plane *plane,
 	struct dm_crtc_state *dm_crtc_state = to_dm_crtc_state(crtc_state);
 	struct rect *dirty_rects = flip_addrs->dirty_rects;
 	uint32_t num_clips;
+	struct drm_mode_rect *clips;
 	bool bb_changed;
 	bool fb_changed;
 	u32 i = 0;
 
-	flip_addrs->dirty_rect_count = 0;
-
 	/*
 	 * Cursor plane has it's own dirty rect update interface. See
 	 * dcn10_dmub_update_cursor_data and dmub_cmd_update_cursor_info_data
@@ -4995,20 +5019,20 @@ static void fill_dc_dirty_rects(struct drm_plane *plane,
 	if (plane->type == DRM_PLANE_TYPE_CURSOR)
 		return;
 
-	/*
-	 * Today, we only consider MPO use-case for PSR SU. If MPO not
-	 * requested, and there is a plane update, do FFU.
-	 */
+	num_clips = drm_plane_get_damage_clips_count(new_plane_state);
+	clips = drm_plane_get_damage_clips(new_plane_state);
+
 	if (!dm_crtc_state->mpo_requested) {
-		dirty_rects[0].x = 0;
-		dirty_rects[0].y = 0;
-		dirty_rects[0].width = dm_crtc_state->base.mode.crtc_hdisplay;
-		dirty_rects[0].height = dm_crtc_state->base.mode.crtc_vdisplay;
-		flip_addrs->dirty_rect_count = 1;
-		DRM_DEBUG_DRIVER("[PLANE:%d] PSR FFU dirty rect size (%d, %d)\n",
-				 new_plane_state->plane->base.id,
-				 dm_crtc_state->base.mode.crtc_hdisplay,
-				 dm_crtc_state->base.mode.crtc_vdisplay);
+		if (!num_clips || num_clips > DC_MAX_DIRTY_RECTS)
+			goto ffu;
+
+		for (; flip_addrs->dirty_rect_count < num_clips; clips++)
+			fill_dc_dirty_rect(new_plane_state->plane,
+					   &dirty_rects[i], clips->x1,
+					   clips->y1, clips->x2 - clips->x1,
+					   clips->y2 - clips->y1,
+					   &flip_addrs->dirty_rect_count,
+					   false);
 		return;
 	}
 
@@ -5019,7 +5043,6 @@ static void fill_dc_dirty_rects(struct drm_plane *plane,
 	 * If plane is moved or resized, also add old bounding box to dirty
 	 * rects.
 	 */
-	num_clips = drm_plane_get_damage_clips_count(new_plane_state);
 	fb_changed = old_plane_state->fb->base.id !=
 		     new_plane_state->fb->base.id;
 	bb_changed = (old_plane_state->crtc_x != new_plane_state->crtc_x ||
@@ -5027,36 +5050,51 @@ static void fill_dc_dirty_rects(struct drm_plane *plane,
 		      old_plane_state->crtc_w != new_plane_state->crtc_w ||
 		      old_plane_state->crtc_h != new_plane_state->crtc_h);
 
-	DRM_DEBUG_DRIVER("[PLANE:%d] PSR bb_changed:%d fb_changed:%d num_clips:%d\n",
-			 new_plane_state->plane->base.id,
-			 bb_changed, fb_changed, num_clips);
-
-	if (num_clips || fb_changed || bb_changed) {
-		dirty_rects[i].x = new_plane_state->crtc_x;
-		dirty_rects[i].y = new_plane_state->crtc_y;
-		dirty_rects[i].width = new_plane_state->crtc_w;
-		dirty_rects[i].height = new_plane_state->crtc_h;
-		DRM_DEBUG_DRIVER("[PLANE:%d] PSR SU dirty rect at (%d, %d) size (%d, %d)\n",
-				 new_plane_state->plane->base.id,
-				 dirty_rects[i].x, dirty_rects[i].y,
-				 dirty_rects[i].width, dirty_rects[i].height);
-		i += 1;
-	}
+	drm_dbg(plane->dev,
+		"[PLANE:%d] PSR bb_changed:%d fb_changed:%d num_clips:%d\n",
+		new_plane_state->plane->base.id,
+		bb_changed, fb_changed, num_clips);
 
-	/* Add old plane bounding-box if plane is moved or resized */
 	if (bb_changed) {
-		dirty_rects[i].x = old_plane_state->crtc_x;
-		dirty_rects[i].y = old_plane_state->crtc_y;
-		dirty_rects[i].width = old_plane_state->crtc_w;
-		dirty_rects[i].height = old_plane_state->crtc_h;
-		DRM_DEBUG_DRIVER("[PLANE:%d] PSR SU dirty rect at (%d, %d) size (%d, %d)\n",
-				old_plane_state->plane->base.id,
-				dirty_rects[i].x, dirty_rects[i].y,
-				dirty_rects[i].width, dirty_rects[i].height);
-		i += 1;
-	}
+		fill_dc_dirty_rect(new_plane_state->plane, &dirty_rects[i],
+				   new_plane_state->crtc_x,
+				   new_plane_state->crtc_y,
+				   new_plane_state->crtc_w,
+				   new_plane_state->crtc_h, &i, false);
+
+		/* Add old plane bounding-box if plane is moved or resized */
+		fill_dc_dirty_rect(new_plane_state->plane, &dirty_rects[i],
+				   old_plane_state->crtc_x,
+				   old_plane_state->crtc_y,
+				   old_plane_state->crtc_w,
+				   old_plane_state->crtc_h, &i, false);
+	}
+
+	if (num_clips) {
+		for (; i < num_clips; clips++)
+			fill_dc_dirty_rect(new_plane_state->plane,
+					   &dirty_rects[i], clips->x1,
+					   clips->y1, clips->x2 - clips->x1,
+					   clips->y2 - clips->y1, &i, false);
+	} else if (fb_changed && !bb_changed) {
+		fill_dc_dirty_rect(new_plane_state->plane, &dirty_rects[i],
+				   new_plane_state->crtc_x,
+				   new_plane_state->crtc_y,
+				   new_plane_state->crtc_w,
+				   new_plane_state->crtc_h, &i, false);
+	}
+
+	if (i > DC_MAX_DIRTY_RECTS)
+		goto ffu;
 
 	flip_addrs->dirty_rect_count = i;
+	return;
+
+ffu:
+	fill_dc_dirty_rect(new_plane_state->plane, &dirty_rects[0], 0, 0,
+			   dm_crtc_state->base.mode.crtc_hdisplay,
+			   dm_crtc_state->base.mode.crtc_vdisplay,
+			   &flip_addrs->dirty_rect_count, true);
 }
 
 static void update_stream_scaling_settings(const struct drm_display_mode *mode,
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
index e6854f7270a66..3c50b3ff79541 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -1600,6 +1600,10 @@ int amdgpu_dm_plane_init(struct amdgpu_display_manager *dm,
 		drm_plane_create_rotation_property(plane, DRM_MODE_ROTATE_0,
 						   supported_rotations);
 
+	if (dm->adev->ip_versions[DCE_HWIP][0] > IP_VERSION(3, 0, 1) &&
+	    plane->type != DRM_PLANE_TYPE_CURSOR)
+		drm_plane_enable_fb_damage_clips(plane);
+
 	drm_plane_helper_add(plane, &dm_plane_helper_funcs);
 
 #ifdef CONFIG_DRM_AMD_DC_HDR
-- 
2.39.2



