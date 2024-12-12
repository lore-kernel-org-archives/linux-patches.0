Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC79211476;
	Thu, 12 Dec 2024 15:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015916; cv=none; b=lf0nlzq+3D2lc3KDShoZtmqA/DLx6OQRm1q9imOvuDpZV1qNnGMw4HkSVdp1QMgWDxSyNqahac6PaJYKY4fM4QWM8jciER2SvzOt5off//T0g56ZINzEzXQFTYnxuR1cpJ80frBgfA7dLbVjF5plVZqSYfxHsNi6wBpPIOTJ0iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015916; c=relaxed/simple;
	bh=VWyKMh4h7MTaTTsaAwDXPlrTKb3tGfcNuTpfoL3nUFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dO91vfhSyipVULIHilyuMJV8S7auI0PJmIqfaxkfyWE13VmkLaTN03ziWZLSQgIQ0jia6RgMReTbiTp0ITs0iOfqgO1WH7vbRosjmJc+0RR+ekwpfHEfvMsIQXHWEZxIj5LHXMzp56fhji1/lKdEWqr8UQmOtjHyZ2CX8BQQsaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9D9t/QP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9D9t/QP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F33BC4CED4;
	Thu, 12 Dec 2024 15:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015916;
	bh=VWyKMh4h7MTaTTsaAwDXPlrTKb3tGfcNuTpfoL3nUFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9D9t/QPXC3MioA3Hc+eJr6HuSUhbuWIqEIo9v8ECWf2o9MAeRV0M+DnYmFW0Uh97
	 jbe8XCyCPYUFsA8IKLnHkhqj6iLERH1pffvU+nFv0uuHBfLkFa240YZr8d8kyGB/nr
	 rBCI1UXajXME3rdAeg7KGwl9pHRTeO54/H9U5A3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>,
	Yihan Zhu <Yihan.Zhu@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/466] drm/amd/display: calculate final viewport before TAP optimization
Date: Thu, 12 Dec 2024 15:54:08 +0100
Message-ID: <20241212144309.934986087@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihan Zhu <Yihan.Zhu@amd.com>

[ Upstream commit e982310c9ce074e428abc260dc3cba1b1ea62b78 ]

Viewport size excess surface size observed sometime with some timings or
resizing the MPO video window to cause MPO unsupported. Calculate final
viewport size first with a 100x100 dummy viewport to get the max TAP
support and then re-run final viewport calculation if TAP value changed.
Removed obsolete preliminary viewport calculation for TAP validation.

Reviewed-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Signed-off-by: Yihan Zhu <Yihan.Zhu@amd.com>
Signed-off-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: c33a93201ca0 ("drm/amd/display: Ignore scalar validation failure if pipe is phantom")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/core/dc_resource.c | 49 +++++++++----------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index c7599c40d4be3..df513dbd32bdf 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -765,25 +765,6 @@ static inline void get_vp_scan_direction(
 		*flip_horz_scan_dir = !*flip_horz_scan_dir;
 }
 
-/*
- * This is a preliminary vp size calculation to allow us to check taps support.
- * The result is completely overridden afterwards.
- */
-static void calculate_viewport_size(struct pipe_ctx *pipe_ctx)
-{
-	struct scaler_data *data = &pipe_ctx->plane_res.scl_data;
-
-	data->viewport.width = dc_fixpt_ceil(dc_fixpt_mul_int(data->ratios.horz, data->recout.width));
-	data->viewport.height = dc_fixpt_ceil(dc_fixpt_mul_int(data->ratios.vert, data->recout.height));
-	data->viewport_c.width = dc_fixpt_ceil(dc_fixpt_mul_int(data->ratios.horz_c, data->recout.width));
-	data->viewport_c.height = dc_fixpt_ceil(dc_fixpt_mul_int(data->ratios.vert_c, data->recout.height));
-	if (pipe_ctx->plane_state->rotation == ROTATION_ANGLE_90 ||
-			pipe_ctx->plane_state->rotation == ROTATION_ANGLE_270) {
-		swap(data->viewport.width, data->viewport.height);
-		swap(data->viewport_c.width, data->viewport_c.height);
-	}
-}
-
 static struct rect intersect_rec(const struct rect *r0, const struct rect *r1)
 {
 	struct rect rec;
@@ -1468,6 +1449,7 @@ bool resource_build_scaling_params(struct pipe_ctx *pipe_ctx)
 	const struct dc_plane_state *plane_state = pipe_ctx->plane_state;
 	struct dc_crtc_timing *timing = &pipe_ctx->stream->timing;
 	const struct rect odm_slice_src = resource_get_odm_slice_src_rect(pipe_ctx);
+	struct scaling_taps temp = {0};
 	bool res = false;
 
 	DC_LOGGER_INIT(pipe_ctx->stream->ctx->logger);
@@ -1525,8 +1507,6 @@ bool resource_build_scaling_params(struct pipe_ctx *pipe_ctx)
 	calculate_recout(pipe_ctx);
 	/* depends on pixel format */
 	calculate_scaling_ratios(pipe_ctx);
-	/* depends on scaling ratios and recout, does not calculate offset yet */
-	calculate_viewport_size(pipe_ctx);
 
 	/*
 	 * LB calculations depend on vp size, h/v_active and scaling ratios
@@ -1547,6 +1527,24 @@ bool resource_build_scaling_params(struct pipe_ctx *pipe_ctx)
 
 	pipe_ctx->plane_res.scl_data.lb_params.alpha_en = plane_state->per_pixel_alpha;
 
+	// get TAP value with 100x100 dummy data for max scaling qualify, override
+	// if a new scaling quality required
+	pipe_ctx->plane_res.scl_data.viewport.width = 100;
+	pipe_ctx->plane_res.scl_data.viewport.height = 100;
+	pipe_ctx->plane_res.scl_data.viewport_c.width = 100;
+	pipe_ctx->plane_res.scl_data.viewport_c.height = 100;
+	if (pipe_ctx->plane_res.xfm != NULL)
+		res = pipe_ctx->plane_res.xfm->funcs->transform_get_optimal_number_of_taps(
+				pipe_ctx->plane_res.xfm, &pipe_ctx->plane_res.scl_data, &plane_state->scaling_quality);
+
+	if (pipe_ctx->plane_res.dpp != NULL)
+		res = pipe_ctx->plane_res.dpp->funcs->dpp_get_optimal_number_of_taps(
+				pipe_ctx->plane_res.dpp, &pipe_ctx->plane_res.scl_data, &plane_state->scaling_quality);
+
+	temp = pipe_ctx->plane_res.scl_data.taps;
+
+	calculate_inits_and_viewports(pipe_ctx);
+
 	if (pipe_ctx->plane_res.xfm != NULL)
 		res = pipe_ctx->plane_res.xfm->funcs->transform_get_optimal_number_of_taps(
 				pipe_ctx->plane_res.xfm, &pipe_ctx->plane_res.scl_data, &plane_state->scaling_quality);
@@ -1573,11 +1571,10 @@ bool resource_build_scaling_params(struct pipe_ctx *pipe_ctx)
 					&plane_state->scaling_quality);
 	}
 
-	/*
-	 * Depends on recout, scaling ratios, h_active and taps
-	 * May need to re-check lb size after this in some obscure scenario
-	 */
-	if (res)
+	if (res && (pipe_ctx->plane_res.scl_data.taps.v_taps != temp.v_taps ||
+		pipe_ctx->plane_res.scl_data.taps.h_taps != temp.h_taps ||
+		pipe_ctx->plane_res.scl_data.taps.v_taps_c != temp.v_taps_c ||
+		pipe_ctx->plane_res.scl_data.taps.h_taps_c != temp.h_taps_c))
 		calculate_inits_and_viewports(pipe_ctx);
 
 	/*
-- 
2.43.0



