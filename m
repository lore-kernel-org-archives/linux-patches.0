Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22732673BB;
	Tue,  8 Apr 2025 10:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109810; cv=none; b=qZ89WhKtViX4kUCHjgf0CURVQnWHbBM+gWuxLLsaTHIJwitQu0pnxdGRXEqrFE3Bcr1pJyWtdFzmk/kLTZVFE/srI1niaCvykqsCN7YfRwcky659kIvQ72ynBfIO5s/Xiv5ksIWgTl0698vGJt57aykmd+smt/gDng7za2MJWR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109810; c=relaxed/simple;
	bh=6+Me7MmEbD1fgx72XOq8e0MRoHiONLNh40Bl4qwXcrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+tAOjPv3sjpZ4nWaCMPxeFFUhKfAjjuPrg6c68sjpel2zmvsEaAqtHePAHWmp2lkjdITnI3OFINbjsEk2s7WmZZQGN49KLR4kX9ah+L5XpHNApawGozh7e/Dy8lvm324cmkf5Sl3AHoxTqT6IUHgLK8duUlStZdfERFPnzWST0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kviX/HD8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kviX/HD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4373AC4CEE5;
	Tue,  8 Apr 2025 10:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109810;
	bh=6+Me7MmEbD1fgx72XOq8e0MRoHiONLNh40Bl4qwXcrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kviX/HD8EnWh0VVh9m1c6HBhKtvJe/415zqjO09S+a47ok1ogAJuXg3cN238GxerY
	 YL0N8ZklPPgvfhRDzCoJtFUTURLHpM9RcQ9hQRa3LZxJ/0VuMyqrJCKhMSlR/SxJyh
	 czalO/oNdOoz6gAQvyScpfyUnlkerVwQeo87K1zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Mario Kleiner <mario.kleiner.de@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/227] drm/amd/display: Check plane scaling against format specific hw plane caps.
Date: Tue,  8 Apr 2025 12:47:19 +0200
Message-ID: <20250408104822.235966115@linuxfoundation.org>
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

From: Mario Kleiner <mario.kleiner.de@gmail.com>

[ Upstream commit 6300b3bd9d0d7afaf085dd086ce6258511c3f057 ]

This takes hw constraints specific to pixel formats into account,
e.g., the inability of older hw to scale fp16 format framebuffers.

It should now allow safely to enable fp16 formats also on DCE-8,
DCE-10, DCE-11.0

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 374c9faac5a7 ("drm/amd/display: Fix null check for pipe_ctx->plane_state in resource_build_scaling_params")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 81 +++++++++++++++++--
 1 file changed, 73 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 50921b340b886..4b4de1751c53f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3719,10 +3719,53 @@ static const struct drm_encoder_funcs amdgpu_dm_encoder_funcs = {
 };
 
 
+static void get_min_max_dc_plane_scaling(struct drm_device *dev,
+					 struct drm_framebuffer *fb,
+					 int *min_downscale, int *max_upscale)
+{
+	struct amdgpu_device *adev = drm_to_adev(dev);
+	struct dc *dc = adev->dm.dc;
+	/* Caps for all supported planes are the same on DCE and DCN 1 - 3 */
+	struct dc_plane_cap *plane_cap = &dc->caps.planes[0];
+
+	switch (fb->format->format) {
+	case DRM_FORMAT_P010:
+	case DRM_FORMAT_NV12:
+	case DRM_FORMAT_NV21:
+		*max_upscale = plane_cap->max_upscale_factor.nv12;
+		*min_downscale = plane_cap->max_downscale_factor.nv12;
+		break;
+
+	case DRM_FORMAT_XRGB16161616F:
+	case DRM_FORMAT_ARGB16161616F:
+	case DRM_FORMAT_XBGR16161616F:
+	case DRM_FORMAT_ABGR16161616F:
+		*max_upscale = plane_cap->max_upscale_factor.fp16;
+		*min_downscale = plane_cap->max_downscale_factor.fp16;
+		break;
+
+	default:
+		*max_upscale = plane_cap->max_upscale_factor.argb8888;
+		*min_downscale = plane_cap->max_downscale_factor.argb8888;
+		break;
+	}
+
+	/*
+	 * A factor of 1 in the plane_cap means to not allow scaling, ie. use a
+	 * scaling factor of 1.0 == 1000 units.
+	 */
+	if (*max_upscale == 1)
+		*max_upscale = 1000;
+
+	if (*min_downscale == 1)
+		*min_downscale = 1000;
+}
+
+
 static int fill_dc_scaling_info(const struct drm_plane_state *state,
 				struct dc_scaling_info *scaling_info)
 {
-	int scale_w, scale_h;
+	int scale_w, scale_h, min_downscale, max_upscale;
 
 	memset(scaling_info, 0, sizeof(*scaling_info));
 
@@ -3788,17 +3831,25 @@ static int fill_dc_scaling_info(const struct drm_plane_state *state,
 	/* DRM doesn't specify clipping on destination output. */
 	scaling_info->clip_rect = scaling_info->dst_rect;
 
-	/* TODO: Validate scaling per-format with DC plane caps */
+	/* Validate scaling per-format with DC plane caps */
+	if (state->plane && state->plane->dev && state->fb) {
+		get_min_max_dc_plane_scaling(state->plane->dev, state->fb,
+					     &min_downscale, &max_upscale);
+	} else {
+		min_downscale = 250;
+		max_upscale = 16000;
+	}
+
 	scale_w = scaling_info->dst_rect.width * 1000 /
 		  scaling_info->src_rect.width;
 
-	if (scale_w < 250 || scale_w > 16000)
+	if (scale_w < min_downscale || scale_w > max_upscale)
 		return -EINVAL;
 
 	scale_h = scaling_info->dst_rect.height * 1000 /
 		  scaling_info->src_rect.height;
 
-	if (scale_h < 250 || scale_h > 16000)
+	if (scale_h < min_downscale || scale_h > max_upscale)
 		return -EINVAL;
 
 	/*
@@ -6010,12 +6061,26 @@ static void dm_plane_helper_cleanup_fb(struct drm_plane *plane,
 static int dm_plane_helper_check_state(struct drm_plane_state *state,
 				       struct drm_crtc_state *new_crtc_state)
 {
-	int max_downscale = 0;
-	int max_upscale = INT_MAX;
+	struct drm_framebuffer *fb = state->fb;
+	int min_downscale, max_upscale;
+	int min_scale = 0;
+	int max_scale = INT_MAX;
+
+	/* Plane enabled? Get min/max allowed scaling factors from plane caps. */
+	if (fb && state->crtc) {
+		get_min_max_dc_plane_scaling(state->crtc->dev, fb,
+					     &min_downscale, &max_upscale);
+		/*
+		 * Convert to drm convention: 16.16 fixed point, instead of dc's
+		 * 1.0 == 1000. Also drm scaling is src/dst instead of dc's
+		 * dst/src, so min_scale = 1.0 / max_upscale, etc.
+		 */
+		min_scale = (1000 << 16) / max_upscale;
+		max_scale = (1000 << 16) / min_downscale;
+	}
 
-	/* TODO: These should be checked against DC plane caps */
 	return drm_atomic_helper_check_plane_state(
-		state, new_crtc_state, max_downscale, max_upscale, true, true);
+		state, new_crtc_state, min_scale, max_scale, true, true);
 }
 
 static int dm_plane_atomic_check(struct drm_plane *plane,
-- 
2.39.5



