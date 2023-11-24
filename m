Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F265F2511F;
	Fri, 24 Nov 2023 18:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jf9NRm7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82172C433C8;
	Fri, 24 Nov 2023 18:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849105;
	bh=mp9++GihYOJvq+L5ZHRDDom+g7YoiyLGneI7IZdYzyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jf9NRm7hJVVqC9LivevbYSvWmelRITro15zZ1KRgj2awZ0004apdReikoCWjSgZVU
	 7b8iA8qxn3/2hW+ejd/Or8qKJH99kY6kXn8argS8v7R7cILlZGFdnTCbPyPF34WSsr
	 Yhul6miBaNNywX3YzVf2Ri8KwBKB8xfo8WkblXe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samson Tam <samson.tam@amd.com>,
	Stylon Wang <stylon.wang@amd.com>,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/530] drm/amd/display: Blank phantom OTG before enabling
Date: Fri, 24 Nov 2023 17:43:35 +0000
Message-ID: <20231124172029.549953083@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Alvin Lee <Alvin.Lee2@amd.com>

[ Upstream commit e87a6c5b7780b5f423797351eb586ed96cc6d151 ]

[Description]
Before enabling the phantom OTG for an update we
must enable DPG to avoid underflow.

Reviewed-by: Samson Tam <samson.tam@amd.com>
Acked-by: Stylon Wang <stylon.wang@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c      | 50 +------------------
 .../drm/amd/display/dc/dcn20/dcn20_hwseq.c    | 10 +++-
 .../drm/amd/display/dc/dcn32/dcn32_hwseq.c    | 46 +++++++++++++++++
 .../drm/amd/display/dc/dcn32/dcn32_hwseq.h    |  5 ++
 .../gpu/drm/amd/display/dc/dcn32/dcn32_init.c |  1 +
 .../gpu/drm/amd/display/dc/inc/hw_sequencer.h |  5 ++
 6 files changed, 68 insertions(+), 49 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index d08e60dff46de..3b9d6fa50d170 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1069,53 +1069,6 @@ static void apply_ctx_interdependent_lock(struct dc *dc,
 	}
 }
 
-static void phantom_pipe_blank(
-		struct dc *dc,
-		struct timing_generator *tg,
-		int width,
-		int height)
-{
-	struct dce_hwseq *hws = dc->hwseq;
-	enum dc_color_space color_space;
-	struct tg_color black_color = {0};
-	struct output_pixel_processor *opp = NULL;
-	uint32_t num_opps, opp_id_src0, opp_id_src1;
-	uint32_t otg_active_width, otg_active_height;
-	uint32_t i;
-
-	/* program opp dpg blank color */
-	color_space = COLOR_SPACE_SRGB;
-	color_space_to_black_color(dc, color_space, &black_color);
-
-	otg_active_width = width;
-	otg_active_height = height;
-
-	/* get the OPTC source */
-	tg->funcs->get_optc_source(tg, &num_opps, &opp_id_src0, &opp_id_src1);
-	ASSERT(opp_id_src0 < dc->res_pool->res_cap->num_opp);
-
-	for (i = 0; i < dc->res_pool->res_cap->num_opp; i++) {
-		if (dc->res_pool->opps[i] != NULL && dc->res_pool->opps[i]->inst == opp_id_src0) {
-			opp = dc->res_pool->opps[i];
-			break;
-		}
-	}
-
-	if (opp && opp->funcs->opp_set_disp_pattern_generator)
-		opp->funcs->opp_set_disp_pattern_generator(
-				opp,
-				CONTROLLER_DP_TEST_PATTERN_SOLID_COLOR,
-				CONTROLLER_DP_COLOR_SPACE_UDEFINED,
-				COLOR_DEPTH_UNDEFINED,
-				&black_color,
-				otg_active_width,
-				otg_active_height,
-				0);
-
-	if (tg->funcs->is_tg_enabled(tg))
-		hws->funcs.wait_for_blank_complete(opp);
-}
-
 static void dc_update_viusal_confirm_color(struct dc *dc, struct dc_state *context, struct pipe_ctx *pipe_ctx)
 {
 	if (dc->ctx->dce_version >= DCN_VERSION_1_0) {
@@ -1206,7 +1159,8 @@ static void disable_dangling_plane(struct dc *dc, struct dc_state *context)
 
 					main_pipe_width = old_stream->mall_stream_config.paired_stream->dst.width;
 					main_pipe_height = old_stream->mall_stream_config.paired_stream->dst.height;
-					phantom_pipe_blank(dc, tg, main_pipe_width, main_pipe_height);
+					if (dc->hwss.blank_phantom)
+						dc->hwss.blank_phantom(dc, tg, main_pipe_width, main_pipe_height);
 					tg->funcs->enable_crtc(tg);
 				}
 			}
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index aeadc587433fd..a2e1ca3b93e86 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1830,8 +1830,16 @@ void dcn20_program_front_end_for_ctx(
 			dc->current_state->res_ctx.pipe_ctx[i].stream->mall_stream_config.type == SUBVP_PHANTOM) {
 			struct timing_generator *tg = dc->current_state->res_ctx.pipe_ctx[i].stream_res.tg;
 
-			if (tg->funcs->enable_crtc)
+			if (tg->funcs->enable_crtc) {
+				if (dc->hwss.blank_phantom) {
+					int main_pipe_width, main_pipe_height;
+
+					main_pipe_width = dc->current_state->res_ctx.pipe_ctx[i].stream->mall_stream_config.paired_stream->dst.width;
+					main_pipe_height = dc->current_state->res_ctx.pipe_ctx[i].stream->mall_stream_config.paired_stream->dst.height;
+					dc->hwss.blank_phantom(dc, tg, main_pipe_width, main_pipe_height);
+				}
 				tg->funcs->enable_crtc(tg);
+			}
 		}
 	}
 	/* OTG blank before disabling all front ends */
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
index 680e7fa8d18ab..cae5e1e68c860 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
@@ -1573,3 +1573,49 @@ void dcn32_init_blank(
 	if (opp)
 		hws->funcs.wait_for_blank_complete(opp);
 }
+
+void dcn32_blank_phantom(struct dc *dc,
+		struct timing_generator *tg,
+		int width,
+		int height)
+{
+	struct dce_hwseq *hws = dc->hwseq;
+	enum dc_color_space color_space;
+	struct tg_color black_color = {0};
+	struct output_pixel_processor *opp = NULL;
+	uint32_t num_opps, opp_id_src0, opp_id_src1;
+	uint32_t otg_active_width, otg_active_height;
+	uint32_t i;
+
+	/* program opp dpg blank color */
+	color_space = COLOR_SPACE_SRGB;
+	color_space_to_black_color(dc, color_space, &black_color);
+
+	otg_active_width = width;
+	otg_active_height = height;
+
+	/* get the OPTC source */
+	tg->funcs->get_optc_source(tg, &num_opps, &opp_id_src0, &opp_id_src1);
+	ASSERT(opp_id_src0 < dc->res_pool->res_cap->num_opp);
+
+	for (i = 0; i < dc->res_pool->res_cap->num_opp; i++) {
+		if (dc->res_pool->opps[i] != NULL && dc->res_pool->opps[i]->inst == opp_id_src0) {
+			opp = dc->res_pool->opps[i];
+			break;
+		}
+	}
+
+	if (opp && opp->funcs->opp_set_disp_pattern_generator)
+		opp->funcs->opp_set_disp_pattern_generator(
+				opp,
+				CONTROLLER_DP_TEST_PATTERN_SOLID_COLOR,
+				CONTROLLER_DP_COLOR_SPACE_UDEFINED,
+				COLOR_DEPTH_UNDEFINED,
+				&black_color,
+				otg_active_width,
+				otg_active_height,
+				0);
+
+	if (tg->funcs->is_tg_enabled(tg))
+		hws->funcs.wait_for_blank_complete(opp);
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.h b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.h
index 2d2628f31bed7..616d5219119e9 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.h
@@ -115,4 +115,9 @@ void dcn32_init_blank(
 		struct dc *dc,
 		struct timing_generator *tg);
 
+void dcn32_blank_phantom(struct dc *dc,
+		struct timing_generator *tg,
+		int width,
+		int height);
+
 #endif /* __DC_HWSS_DCN32_H__ */
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_init.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_init.c
index c7417147dff19..eb4227926006a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_init.c
@@ -115,6 +115,7 @@ static const struct hw_sequencer_funcs dcn32_funcs = {
 	.update_phantom_vp_position = dcn32_update_phantom_vp_position,
 	.update_dsc_pg = dcn32_update_dsc_pg,
 	.apply_update_flags_for_phantom = dcn32_apply_update_flags_for_phantom,
+	.blank_phantom = dcn32_blank_phantom,
 };
 
 static const struct hwseq_private_funcs dcn32_private_funcs = {
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
index 02ff99f7bec2b..7a702e216e530 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
@@ -388,6 +388,11 @@ struct hw_sequencer_funcs {
 	void (*z10_restore)(const struct dc *dc);
 	void (*z10_save_init)(struct dc *dc);
 
+	void (*blank_phantom)(struct dc *dc,
+			struct timing_generator *tg,
+			int width,
+			int height);
+
 	void (*update_visual_confirm_color)(struct dc *dc,
 			struct pipe_ctx *pipe_ctx,
 			int mpcc_id);
-- 
2.42.0



