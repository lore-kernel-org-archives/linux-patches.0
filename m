Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD9A29A1;
	Tue, 17 Feb 2026 20:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361456; cv=none; b=cFqLWoEKv4q5Qgjd+GAGHn3h50mycL9G0mE7mgnkOL5F3j5VatNR7GB9iIFUdKeHJc4Spi+VExxMwPm08fqFsv/nquoTRzDGZNPod4XMEKw9tIYiBzQpgLcACCjQygi9antwRsU+G1YPbNH7mWl3sr7R+cKDdFs8tLEgVWf1lC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361456; c=relaxed/simple;
	bh=L7A3OuD3G5JKaDpHgHM1eDTz18k3s78x/gvxkoaomzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FT4zWQ+ggNVw2lblxkP6CyQgrMsuG3O4PNCf39w4xOMqcKrqK7l8oIyoJL4PD9vkDiq9HUJsbmxJpgJoOjlyVuaeSs3TgPcYTN3ItSROjCwfrRyk9qpW8X0PSk5DiEcbxmJgTPcg/vNDhIl6dUKV6DAeWglawhfbA3vT0CtM4W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CiDQHIos; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CiDQHIos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9D2C19421;
	Tue, 17 Feb 2026 20:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361456;
	bh=L7A3OuD3G5JKaDpHgHM1eDTz18k3s78x/gvxkoaomzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiDQHIosYHHaNdG2+PnwiGwhf5MiOs3Rr95ly8K4VPmF11Pj7XSw/7v60n7zV7LjL
	 Ya6Xf9lR24ojul9uBw76k9hq6mSWie7hUQcWfB/u1lBHikDnCwNOxbH5wxxFvxoXOV
	 a34xk0cNUbIoqQi7vRt2FaOoNpmSpvjUlcNjCVJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 21/43] drm/amd/display: extend delta clamping logic to CM3 LUT helper
Date: Tue, 17 Feb 2026 21:32:01 +0100
Message-ID: <20260217200007.279394854@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
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

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit d25b32aa829a3ed5570138e541a71fb7805faec3 ]

Commit 27fc10d1095f ("drm/amd/display: Fix the delta clamping for shaper
LUT") fixed banding when using plane shaper LUT in DCN10 CM helper.  The
problem is also present in DCN30 CM helper, fix banding by extending the
same bug delta clamping fix to CM3.

Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0274a54897f356f9c78767c4a2a5863f7dde90c6)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dcn30/dcn30_cm_common.c    | 30 +++++++++++++++----
 .../display/dc/dwb/dcn30/dcn30_cm_common.h    |  2 +-
 .../amd/display/dc/hwss/dcn30/dcn30_hwseq.c   |  9 +++---
 .../amd/display/dc/hwss/dcn32/dcn32_hwseq.c   | 17 ++++++-----
 .../amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 16 +++++-----
 5 files changed, 49 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c
index a4f14b16564c2..227aa8672d17b 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c
@@ -105,9 +105,12 @@ void cm_helper_program_gamcor_xfer_func(
 #define NUMBER_REGIONS     32
 #define NUMBER_SW_SEGMENTS 16
 
-bool cm3_helper_translate_curve_to_hw_format(
-				const struct dc_transfer_func *output_tf,
-				struct pwl_params *lut_params, bool fixpoint)
+#define DC_LOGGER \
+		ctx->logger
+
+bool cm3_helper_translate_curve_to_hw_format(struct dc_context *ctx,
+					     const struct dc_transfer_func *output_tf,
+					     struct pwl_params *lut_params, bool fixpoint)
 {
 	struct curve_points3 *corner_points;
 	struct pwl_result_data *rgb_resulted;
@@ -251,6 +254,10 @@ bool cm3_helper_translate_curve_to_hw_format(
 	if (fixpoint == true) {
 		i = 1;
 		while (i != hw_points + 2) {
+			uint32_t red_clamp;
+			uint32_t green_clamp;
+			uint32_t blue_clamp;
+
 			if (i >= hw_points) {
 				if (dc_fixpt_lt(rgb_plus_1->red, rgb->red))
 					rgb_plus_1->red = dc_fixpt_add(rgb->red,
@@ -263,9 +270,20 @@ bool cm3_helper_translate_curve_to_hw_format(
 							rgb_minus_1->delta_blue);
 			}
 
-			rgb->delta_red_reg   = dc_fixpt_clamp_u0d10(rgb->delta_red);
-			rgb->delta_green_reg = dc_fixpt_clamp_u0d10(rgb->delta_green);
-			rgb->delta_blue_reg  = dc_fixpt_clamp_u0d10(rgb->delta_blue);
+			rgb->delta_red   = dc_fixpt_sub(rgb_plus_1->red,   rgb->red);
+			rgb->delta_green = dc_fixpt_sub(rgb_plus_1->green, rgb->green);
+			rgb->delta_blue  = dc_fixpt_sub(rgb_plus_1->blue,  rgb->blue);
+
+			red_clamp = dc_fixpt_clamp_u0d14(rgb->delta_red);
+			green_clamp = dc_fixpt_clamp_u0d14(rgb->delta_green);
+			blue_clamp = dc_fixpt_clamp_u0d14(rgb->delta_blue);
+
+			if (red_clamp >> 10 || green_clamp >> 10 || blue_clamp >> 10)
+				DC_LOG_ERROR("Losing delta precision while programming shaper LUT.");
+
+			rgb->delta_red_reg   = red_clamp & 0x3ff;
+			rgb->delta_green_reg = green_clamp & 0x3ff;
+			rgb->delta_blue_reg  = blue_clamp & 0x3ff;
 			rgb->red_reg         = dc_fixpt_clamp_u0d14(rgb->red);
 			rgb->green_reg       = dc_fixpt_clamp_u0d14(rgb->green);
 			rgb->blue_reg        = dc_fixpt_clamp_u0d14(rgb->blue);
diff --git a/drivers/gpu/drm/amd/display/dc/dwb/dcn30/dcn30_cm_common.h b/drivers/gpu/drm/amd/display/dc/dwb/dcn30/dcn30_cm_common.h
index b86347c9b0389..95f9318a54efc 100644
--- a/drivers/gpu/drm/amd/display/dc/dwb/dcn30/dcn30_cm_common.h
+++ b/drivers/gpu/drm/amd/display/dc/dwb/dcn30/dcn30_cm_common.h
@@ -59,7 +59,7 @@ void cm_helper_program_gamcor_xfer_func(
 	const struct pwl_params *params,
 	const struct dcn3_xfer_func_reg *reg);
 
-bool cm3_helper_translate_curve_to_hw_format(
+bool cm3_helper_translate_curve_to_hw_format(struct dc_context *ctx,
 	const struct dc_transfer_func *output_tf,
 	struct pwl_params *lut_params, bool fixpoint);
 
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c
index e47ed5571dfdd..731645a2ab9aa 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c
@@ -238,7 +238,7 @@ bool dcn30_set_blend_lut(
 	if (plane_state->blend_tf.type == TF_TYPE_HWPWL)
 		blend_lut = &plane_state->blend_tf.pwl;
 	else if (plane_state->blend_tf.type == TF_TYPE_DISTRIBUTED_POINTS) {
-		result = cm3_helper_translate_curve_to_hw_format(
+		result = cm3_helper_translate_curve_to_hw_format(plane_state->ctx,
 				&plane_state->blend_tf, &dpp_base->regamma_params, false);
 		if (!result)
 			return result;
@@ -333,8 +333,9 @@ bool dcn30_set_input_transfer_func(struct dc *dc,
 	if (plane_state->in_transfer_func.type == TF_TYPE_HWPWL)
 		params = &plane_state->in_transfer_func.pwl;
 	else if (plane_state->in_transfer_func.type == TF_TYPE_DISTRIBUTED_POINTS &&
-		cm3_helper_translate_curve_to_hw_format(&plane_state->in_transfer_func,
-				&dpp_base->degamma_params, false))
+		cm3_helper_translate_curve_to_hw_format(plane_state->ctx,
+							&plane_state->in_transfer_func,
+							&dpp_base->degamma_params, false))
 		params = &dpp_base->degamma_params;
 
 	result = dpp_base->funcs->dpp_program_gamcor_lut(dpp_base, params);
@@ -405,7 +406,7 @@ bool dcn30_set_output_transfer_func(struct dc *dc,
 				params = &stream->out_transfer_func.pwl;
 			else if (pipe_ctx->stream->out_transfer_func.type ==
 					TF_TYPE_DISTRIBUTED_POINTS &&
-					cm3_helper_translate_curve_to_hw_format(
+					cm3_helper_translate_curve_to_hw_format(stream->ctx,
 					&stream->out_transfer_func,
 					&mpc->blender_params, false))
 				params = &mpc->blender_params;
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
index f39292952702f..30bb5d8d85dc2 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
@@ -486,8 +486,9 @@ bool dcn32_set_mcm_luts(
 	if (plane_state->blend_tf.type == TF_TYPE_HWPWL)
 		lut_params = &plane_state->blend_tf.pwl;
 	else if (plane_state->blend_tf.type == TF_TYPE_DISTRIBUTED_POINTS) {
-		result = cm3_helper_translate_curve_to_hw_format(&plane_state->blend_tf,
-				&dpp_base->regamma_params, false);
+		result = cm3_helper_translate_curve_to_hw_format(plane_state->ctx,
+								 &plane_state->blend_tf,
+								 &dpp_base->regamma_params, false);
 		if (!result)
 			return result;
 
@@ -502,8 +503,9 @@ bool dcn32_set_mcm_luts(
 	else if (plane_state->in_shaper_func.type == TF_TYPE_DISTRIBUTED_POINTS) {
 		// TODO: dpp_base replace
 		ASSERT(false);
-		cm3_helper_translate_curve_to_hw_format(&plane_state->in_shaper_func,
-				&dpp_base->shaper_params, true);
+		cm3_helper_translate_curve_to_hw_format(plane_state->ctx,
+							&plane_state->in_shaper_func,
+							&dpp_base->shaper_params, true);
 		lut_params = &dpp_base->shaper_params;
 	}
 
@@ -543,8 +545,9 @@ bool dcn32_set_input_transfer_func(struct dc *dc,
 	if (plane_state->in_transfer_func.type == TF_TYPE_HWPWL)
 		params = &plane_state->in_transfer_func.pwl;
 	else if (plane_state->in_transfer_func.type == TF_TYPE_DISTRIBUTED_POINTS &&
-		cm3_helper_translate_curve_to_hw_format(&plane_state->in_transfer_func,
-				&dpp_base->degamma_params, false))
+		cm3_helper_translate_curve_to_hw_format(plane_state->ctx,
+							&plane_state->in_transfer_func,
+							&dpp_base->degamma_params, false))
 		params = &dpp_base->degamma_params;
 
 	dpp_base->funcs->dpp_program_gamcor_lut(dpp_base, params);
@@ -575,7 +578,7 @@ bool dcn32_set_output_transfer_func(struct dc *dc,
 				params = &stream->out_transfer_func.pwl;
 			else if (pipe_ctx->stream->out_transfer_func.type ==
 					TF_TYPE_DISTRIBUTED_POINTS &&
-					cm3_helper_translate_curve_to_hw_format(
+					cm3_helper_translate_curve_to_hw_format(stream->ctx,
 					&stream->out_transfer_func,
 					&mpc->blender_params, false))
 				params = &mpc->blender_params;
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index 68e48a2492c9e..77cdd02a41bdd 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -427,7 +427,7 @@ void dcn401_populate_mcm_luts(struct dc *dc,
 		if (mcm_luts.lut1d_func->type == TF_TYPE_HWPWL)
 			m_lut_params.pwl = &mcm_luts.lut1d_func->pwl;
 		else if (mcm_luts.lut1d_func->type == TF_TYPE_DISTRIBUTED_POINTS) {
-			rval = cm3_helper_translate_curve_to_hw_format(
+			rval = cm3_helper_translate_curve_to_hw_format(mpc->ctx,
 					mcm_luts.lut1d_func,
 					&dpp_base->regamma_params, false);
 			m_lut_params.pwl = rval ? &dpp_base->regamma_params : NULL;
@@ -447,7 +447,7 @@ void dcn401_populate_mcm_luts(struct dc *dc,
 			m_lut_params.pwl = &mcm_luts.shaper->pwl;
 		else if (mcm_luts.shaper->type == TF_TYPE_DISTRIBUTED_POINTS) {
 			ASSERT(false);
-			rval = cm3_helper_translate_curve_to_hw_format(
+			rval = cm3_helper_translate_curve_to_hw_format(mpc->ctx,
 					mcm_luts.shaper,
 					&dpp_base->regamma_params, true);
 			m_lut_params.pwl = rval ? &dpp_base->regamma_params : NULL;
@@ -624,8 +624,9 @@ bool dcn401_set_mcm_luts(struct pipe_ctx *pipe_ctx,
 	if (plane_state->blend_tf.type == TF_TYPE_HWPWL)
 		lut_params = &plane_state->blend_tf.pwl;
 	else if (plane_state->blend_tf.type == TF_TYPE_DISTRIBUTED_POINTS) {
-		rval = cm3_helper_translate_curve_to_hw_format(&plane_state->blend_tf,
-				&dpp_base->regamma_params, false);
+		rval = cm3_helper_translate_curve_to_hw_format(plane_state->ctx,
+							       &plane_state->blend_tf,
+							       &dpp_base->regamma_params, false);
 		lut_params = rval ? &dpp_base->regamma_params : NULL;
 	}
 	result = mpc->funcs->program_1dlut(mpc, lut_params, mpcc_id);
@@ -636,8 +637,9 @@ bool dcn401_set_mcm_luts(struct pipe_ctx *pipe_ctx,
 		lut_params = &plane_state->in_shaper_func.pwl;
 	else if (plane_state->in_shaper_func.type == TF_TYPE_DISTRIBUTED_POINTS) {
 		// TODO: dpp_base replace
-		rval = cm3_helper_translate_curve_to_hw_format(&plane_state->in_shaper_func,
-				&dpp_base->shaper_params, true);
+		rval = cm3_helper_translate_curve_to_hw_format(plane_state->ctx,
+							       &plane_state->in_shaper_func,
+							       &dpp_base->shaper_params, true);
 		lut_params = rval ? &dpp_base->shaper_params : NULL;
 	}
 	result &= mpc->funcs->program_shaper(mpc, lut_params, mpcc_id);
@@ -671,7 +673,7 @@ bool dcn401_set_output_transfer_func(struct dc *dc,
 				params = &stream->out_transfer_func.pwl;
 			else if (pipe_ctx->stream->out_transfer_func.type ==
 					TF_TYPE_DISTRIBUTED_POINTS &&
-					cm3_helper_translate_curve_to_hw_format(
+					cm3_helper_translate_curve_to_hw_format(stream->ctx,
 					&stream->out_transfer_func,
 					&mpc->blender_params, false))
 				params = &mpc->blender_params;
-- 
2.51.0



