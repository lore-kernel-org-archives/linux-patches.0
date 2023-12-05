Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2378BF7;
	Tue,  5 Dec 2023 03:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzqnxx0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5149AC433C7;
	Tue,  5 Dec 2023 03:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747209;
	bh=X+4UOkeJI6ivnowTRc4K3mW0S3xuADk2WdP4vLUdEiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzqnxx0Z5bfFOjtCasQdYt+Ci0Kq1fUUAbQCfyIOwXoz45dMhbJjupS8yRYBGa09V
	 7oFU5yOSRydkn9LbOmWRNi/y82NCJOdnoiE8R4iowxI8FNYMGvm6siArdTuxWcAKLh
	 Jv0owxjKl/KKgeSDvXZfyg3evCngYhcZEQ96z40o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Krunoslav Kovac <krunoslav.kovac@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/107] drm/amd/display: Fix the delta clamping for shaper LUT
Date: Tue,  5 Dec 2023 12:17:15 +0900
Message-ID: <20231205031538.000641500@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

[ Upstream commit 27fc10d1095f7a7de7c917638d7134033a190dd8 ]

The shaper LUT requires a 10-bit value of the delta between segments. We
were using dc_fixpt_clamp_u0d10() to do that but it doesn't do what we
want it to do. It will preserve 10-bit precision after the decimal
point, but that's not quite what we want. We want 14-bit precision and
discard the 4 most-significant bytes.

To do that we'll do dc_fixpt_clamp_u0d14() & 0x3ff instead.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Krunoslav Kovac <krunoslav.kovac@amd.com>
Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 6f395cebdd89 ("drm/amd/display: Fix MPCC 1DLUT programming")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dcn10/dcn10_cm_common.c    | 19 +++++++++++++++----
 .../amd/display/dc/dcn10/dcn10_cm_common.h    |  1 +
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.c |  2 +-
 .../drm/amd/display/dc/dcn20/dcn20_hwseq.c    |  6 +++---
 .../drm/amd/display/dc/dcn30/dcn30_dwb_cm.c   |  2 +-
 .../drm/amd/display/dc/dcn30/dcn30_hwseq.c    |  2 +-
 .../drm/amd/display/dc/dcn32/dcn32_hwseq.c    |  6 +++---
 7 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c
index 7a00fe525dfba..3538973bd0c6c 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c
@@ -308,7 +308,10 @@ bool cm_helper_convert_to_custom_float(
 #define NUMBER_REGIONS     32
 #define NUMBER_SW_SEGMENTS 16
 
-bool cm_helper_translate_curve_to_hw_format(
+#define DC_LOGGER \
+		ctx->logger
+
+bool cm_helper_translate_curve_to_hw_format(struct dc_context *ctx,
 				const struct dc_transfer_func *output_tf,
 				struct pwl_params *lut_params, bool fixpoint)
 {
@@ -482,10 +485,18 @@ bool cm_helper_translate_curve_to_hw_format(
 		rgb->delta_green = dc_fixpt_sub(rgb_plus_1->green, rgb->green);
 		rgb->delta_blue  = dc_fixpt_sub(rgb_plus_1->blue,  rgb->blue);
 
+
 		if (fixpoint == true) {
-			rgb->delta_red_reg   = dc_fixpt_clamp_u0d10(rgb->delta_red);
-			rgb->delta_green_reg = dc_fixpt_clamp_u0d10(rgb->delta_green);
-			rgb->delta_blue_reg  = dc_fixpt_clamp_u0d10(rgb->delta_blue);
+			uint32_t red_clamp = dc_fixpt_clamp_u0d14(rgb->delta_red);
+			uint32_t green_clamp = dc_fixpt_clamp_u0d14(rgb->delta_green);
+			uint32_t blue_clamp = dc_fixpt_clamp_u0d14(rgb->delta_blue);
+
+			if (red_clamp >> 10 || green_clamp >> 10 || blue_clamp >> 10)
+				DC_LOG_WARNING("Losing delta precision while programming shaper LUT.");
+
+			rgb->delta_red_reg   = red_clamp & 0x3ff;
+			rgb->delta_green_reg = green_clamp & 0x3ff;
+			rgb->delta_blue_reg  = blue_clamp & 0x3ff;
 			rgb->red_reg         = dc_fixpt_clamp_u0d14(rgb->red);
 			rgb->green_reg       = dc_fixpt_clamp_u0d14(rgb->green);
 			rgb->blue_reg        = dc_fixpt_clamp_u0d14(rgb->blue);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.h b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.h
index 3b8cd7410498a..0a68b63d61260 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.h
@@ -106,6 +106,7 @@ bool cm_helper_convert_to_custom_float(
 		bool fixpoint);
 
 bool cm_helper_translate_curve_to_hw_format(
+		struct dc_context *ctx,
 		const struct dc_transfer_func *output_tf,
 		struct pwl_params *lut_params, bool fixpoint);
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 3940271189632..d84579da64003 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1867,7 +1867,7 @@ bool dcn10_set_output_transfer_func(struct dc *dc, struct pipe_ctx *pipe_ctx,
 	/* dcn10_translate_regamma_to_hw_format takes 750us, only do it when full
 	 * update.
 	 */
-	else if (cm_helper_translate_curve_to_hw_format(
+	else if (cm_helper_translate_curve_to_hw_format(dc->ctx,
 			stream->out_transfer_func,
 			&dpp->regamma_params, false)) {
 		dpp->funcs->dpp_program_regamma_pwl(
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index fbc188812ccc9..9bd6a5716cdc1 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -843,7 +843,7 @@ bool dcn20_set_output_transfer_func(struct dc *dc, struct pipe_ctx *pipe_ctx,
 			params = &stream->out_transfer_func->pwl;
 		else if (pipe_ctx->stream->out_transfer_func->type ==
 			TF_TYPE_DISTRIBUTED_POINTS &&
-			cm_helper_translate_curve_to_hw_format(
+			cm_helper_translate_curve_to_hw_format(dc->ctx,
 			stream->out_transfer_func,
 			&mpc->blender_params, false))
 			params = &mpc->blender_params;
@@ -872,7 +872,7 @@ bool dcn20_set_blend_lut(
 		if (plane_state->blend_tf->type == TF_TYPE_HWPWL)
 			blend_lut = &plane_state->blend_tf->pwl;
 		else if (plane_state->blend_tf->type == TF_TYPE_DISTRIBUTED_POINTS) {
-			cm_helper_translate_curve_to_hw_format(
+			cm_helper_translate_curve_to_hw_format(plane_state->ctx,
 					plane_state->blend_tf,
 					&dpp_base->regamma_params, false);
 			blend_lut = &dpp_base->regamma_params;
@@ -894,7 +894,7 @@ bool dcn20_set_shaper_3dlut(
 		if (plane_state->in_shaper_func->type == TF_TYPE_HWPWL)
 			shaper_lut = &plane_state->in_shaper_func->pwl;
 		else if (plane_state->in_shaper_func->type == TF_TYPE_DISTRIBUTED_POINTS) {
-			cm_helper_translate_curve_to_hw_format(
+			cm_helper_translate_curve_to_hw_format(plane_state->ctx,
 					plane_state->in_shaper_func,
 					&dpp_base->shaper_params, true);
 			shaper_lut = &dpp_base->shaper_params;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c
index 6a3d3a0ec0a36..701c7d8bc038a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c
@@ -280,7 +280,7 @@ bool dwb3_ogam_set_input_transfer_func(
 	dwb_ogam_lut = kzalloc(sizeof(*dwb_ogam_lut), GFP_KERNEL);
 
 	if (dwb_ogam_lut) {
-		cm_helper_translate_curve_to_hw_format(
+		cm_helper_translate_curve_to_hw_format(dwbc->ctx,
 			in_transfer_func_dwb_ogam,
 			dwb_ogam_lut, false);
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
index 07691b487e28c..53262f6bc40b0 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -107,7 +107,7 @@ static bool dcn30_set_mpc_shaper_3dlut(struct pipe_ctx *pipe_ctx,
 		if (stream->func_shaper->type == TF_TYPE_HWPWL) {
 			shaper_lut = &stream->func_shaper->pwl;
 		} else if (stream->func_shaper->type == TF_TYPE_DISTRIBUTED_POINTS) {
-			cm_helper_translate_curve_to_hw_format(stream->func_shaper,
+			cm_helper_translate_curve_to_hw_format(stream->ctx, stream->func_shaper,
 							       &dpp_base->shaper_params, true);
 			shaper_lut = &dpp_base->shaper_params;
 		}
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
index 50b3547977281..f69e7d748e68b 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
@@ -530,7 +530,7 @@ static bool dcn32_set_mpc_shaper_3dlut(
 		if (stream->func_shaper->type == TF_TYPE_HWPWL)
 			shaper_lut = &stream->func_shaper->pwl;
 		else if (stream->func_shaper->type == TF_TYPE_DISTRIBUTED_POINTS) {
-			cm_helper_translate_curve_to_hw_format(
+			cm_helper_translate_curve_to_hw_format(stream->ctx,
 					stream->func_shaper,
 					&dpp_base->shaper_params, true);
 			shaper_lut = &dpp_base->shaper_params;
@@ -566,7 +566,7 @@ bool dcn32_set_mcm_luts(
 		if (plane_state->blend_tf->type == TF_TYPE_HWPWL)
 			lut_params = &plane_state->blend_tf->pwl;
 		else if (plane_state->blend_tf->type == TF_TYPE_DISTRIBUTED_POINTS) {
-			cm_helper_translate_curve_to_hw_format(
+			cm_helper_translate_curve_to_hw_format(plane_state->ctx,
 					plane_state->blend_tf,
 					&dpp_base->regamma_params, false);
 			lut_params = &dpp_base->regamma_params;
@@ -581,7 +581,7 @@ bool dcn32_set_mcm_luts(
 		else if (plane_state->in_shaper_func->type == TF_TYPE_DISTRIBUTED_POINTS) {
 			// TODO: dpp_base replace
 			ASSERT(false);
-			cm_helper_translate_curve_to_hw_format(
+			cm_helper_translate_curve_to_hw_format(plane_state->ctx,
 					plane_state->in_shaper_func,
 					&dpp_base->shaper_params, true);
 			lut_params = &dpp_base->shaper_params;
-- 
2.42.0



