Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59052265630;
	Tue,  8 Apr 2025 10:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109816; cv=none; b=kf2Kc1tAG+cnFYsuEGbn/c8BsAOJEYSXvvkVUSqacYG06hG9M4sI6I6d69pWG6hGSbaFW2iy7luct2vtIE8QBiB2cy4NeADgMUV0Bnct7il/qB0sGNJPa8FUfbB6R0TfispSZpmBkO/pMk4T58xNnYo4Pyi0S41PGDUTEj2wH28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109816; c=relaxed/simple;
	bh=XAHS2fZh1X/rp2exWXSAnDcaDDAgH9cfSG+5EdJ1Bvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwPafV6/cuXBdEKN7xxIEK3/JuMOQXlW8ENjI6dQIjZ8L+8APfEOlCEukQV1nuDddSBgURL859vwlt5jABTtZpyEICz5EVJdADS/5Y7Rz3CVyt9Xg56OEeKwC2GoyzoT+0KX/byW55SVS4HFx/3m1gxkqAYwrPFQFqcQ/1chSis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTB14Brs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTB14Brs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862CFC4CEE5;
	Tue,  8 Apr 2025 10:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109815;
	bh=XAHS2fZh1X/rp2exWXSAnDcaDDAgH9cfSG+5EdJ1Bvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTB14Brsw5TG6vgfaKFj8F9ymgVIyllkJcdZ75pikjEiQ7vQmvIbbUhI9twe0MDfJ
	 AFzbHy7vgtyhrCqLEHQvUuY2aQ+GlS3cSsce9uLPBGeodDZBgkgB3v/ivfeblECNJ1
	 pjskhtgC+QQ43bNbqy/GMI8nyErRuM1n1BKqIs/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikola Cornij <nikola.cornij@amd.com>,
	Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
	Anson Jacob <Anson.Jacob@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/227] drm/amd/display: Reject too small viewport size when validating plane
Date: Tue,  8 Apr 2025 12:47:21 +0200
Message-ID: <20250408104822.298744373@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikola Cornij <nikola.cornij@amd.com>

[ Upstream commit 40d916a2602c8920e0f04a49abfd1ff7c1e54e91 ]

[why]
Overlay won't move to a new positon if viewport size is smaller than
what can be handled. It'd either disappear or stay at the old
position. This condition is for example hit if overlay is moved too
much outside of left or top edge of the screen, but it applies to
any non-cursor plane type.

[how]
Reject this contidion at validation time. This gives the calling
level a chance to handle this gracefully and avoid inconsistent
behaivor.

Signed-off-by: Nikola Cornij <nikola.cornij@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 374c9faac5a7 ("drm/amd/display: Fix null check for pipe_ctx->plane_state in resource_build_scaling_params")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 27 ++++++++++++++++++-
 .../gpu/drm/amd/display/dc/core/dc_resource.c |  4 +--
 drivers/gpu/drm/amd/display/dc/dc.h           |  1 +
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 4b4de1751c53f..786cd892f1797 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6066,8 +6066,33 @@ static int dm_plane_helper_check_state(struct drm_plane_state *state,
 	int min_scale = 0;
 	int max_scale = INT_MAX;
 
-	/* Plane enabled? Get min/max allowed scaling factors from plane caps. */
+	/* Plane enabled? Validate viewport and get scaling factors from plane caps. */
 	if (fb && state->crtc) {
+		/* Validate viewport to cover the case when only the position changes */
+		if (state->plane->type != DRM_PLANE_TYPE_CURSOR) {
+			int viewport_width = state->crtc_w;
+			int viewport_height = state->crtc_h;
+
+			if (state->crtc_x < 0)
+				viewport_width += state->crtc_x;
+			else if (state->crtc_x + state->crtc_w > new_crtc_state->mode.crtc_hdisplay)
+				viewport_width = new_crtc_state->mode.crtc_hdisplay - state->crtc_x;
+
+			if (state->crtc_y < 0)
+				viewport_height += state->crtc_y;
+			else if (state->crtc_y + state->crtc_h > new_crtc_state->mode.crtc_vdisplay)
+				viewport_height = new_crtc_state->mode.crtc_vdisplay - state->crtc_y;
+
+			/* If completely outside of screen, viewport_width and/or viewport_height will be negative,
+			 * which is still OK to satisfy the condition below, thereby also covering these cases
+			 * (when plane is completely outside of screen).
+			 * x2 for width is because of pipe-split.
+			 */
+			if (viewport_width < MIN_VIEWPORT_SIZE*2 || viewport_height < MIN_VIEWPORT_SIZE)
+				return -EINVAL;
+		}
+
+		/* Get min/max allowed scaling factors from plane caps. */
 		get_min_max_dc_plane_scaling(state->crtc->dev, fb,
 					     &min_downscale, &max_upscale);
 		/*
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 5dc6840cea248..d77001b2e106b 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1144,8 +1144,8 @@ bool resource_build_scaling_params(struct pipe_ctx *pipe_ctx)
 
 	calculate_viewport(pipe_ctx);
 
-	if (pipe_ctx->plane_res.scl_data.viewport.height < 12 ||
-		pipe_ctx->plane_res.scl_data.viewport.width < 12) {
+	if (pipe_ctx->plane_res.scl_data.viewport.height < MIN_VIEWPORT_SIZE ||
+		pipe_ctx->plane_res.scl_data.viewport.width < MIN_VIEWPORT_SIZE) {
 		if (store_h_border_left) {
 			restore_border_left_from_dst(pipe_ctx,
 				store_h_border_left);
diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 1df7c49ac8d77..d3a4a55f3f1fa 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -48,6 +48,7 @@
 #define MAX_PLANES 6
 #define MAX_STREAMS 6
 #define MAX_SINKS_PER_LINK 4
+#define MIN_VIEWPORT_SIZE 12
 
 /*******************************************************************************
  * Display Core Interfaces
-- 
2.39.5



