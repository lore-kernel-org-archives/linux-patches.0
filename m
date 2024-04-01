Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3525A383BA;
	Mon,  1 Apr 2024 16:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987207; cv=none; b=SEQQrLfQ6Ke5X/PHYaE/SwaiI9NluqwXvAxxgqLpUfDKFHXj40+q10J1rPAi717efQK2N/FxBp06JYmlnvSByVFVjczTulwd0Cv+sOeZvnVIjStWVcjml2xUuyuvAMUdbKIPBwwQkd501FMNpROZVewYK7V/VjxO9SAmvTqoozc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987207; c=relaxed/simple;
	bh=yNBoEy0IXliv9Vb81B4MMNTRYn2l4dAmJAkQkIAiyQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCeNFA1e1FVroyWKM94hkaamaFQbKCGrGBwcOxuO6yrAh/voybANn2buHu23hWlPCnEeMpPgx/woupBio25gDa1D75qHCf/NZcaZW8JifTXzBe1t6DtOZ1y4n2hm0z7JBqjrqnBA2G5QB+okLfAo6ND6i8uXgqzpKEIDTQsBNoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTl+nKwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTl+nKwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB17C433F1;
	Mon,  1 Apr 2024 16:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987207;
	bh=yNBoEy0IXliv9Vb81B4MMNTRYn2l4dAmJAkQkIAiyQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTl+nKwc8kbbwo8jNtTUOME+sqoonhcnBZvBTv3mOBRtltqkiKs5CZ2nEpX9IoFEw
	 yfeEjo63YYDLnWIyy6QJiE78avCpqLTs5Ph7MDzkQNcix02T0vGgXZi4C/fllU24fw
	 vdvJ1iGNlRu57WhMJ7n4qxvPe/BIAnjlNv5lXwHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 216/399] drm/amd/display: Implement wait_for_odm_update_pending_complete
Date: Mon,  1 Apr 2024 17:43:02 +0200
Message-ID: <20240401152555.630200915@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjing Liu <wenjing.liu@amd.com>

[ Upstream commit 2d7f3d1a5866705be2393150e1ffdf67030ab88d ]

[WHY]
Odm update is doubled buffered. We need to wait for ODM update to be
completed before optimizing bandwidth or programming new udpates.

[HOW]
implement wait_for_odm_update_pending_complete function to wait for:
1. odm configuration update is no longer pending in timing generator.
2. no pending dpg pattern update for each active OPP.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Wenjing Liu <wenjing.liu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c      | 56 ++++++++++++++++++-
 .../gpu/drm/amd/display/dc/dcn10/dcn10_opp.c  |  1 +
 .../gpu/drm/amd/display/dc/dcn20/dcn20_opp.c  | 14 +++++
 .../gpu/drm/amd/display/dc/dcn20/dcn20_opp.h  |  2 +
 .../drm/amd/display/dc/dcn201/dcn201_opp.c    |  1 +
 .../amd/display/dc/hwss/dcn20/dcn20_hwseq.c   |  4 +-
 drivers/gpu/drm/amd/display/dc/inc/hw/opp.h   |  3 +
 .../amd/display/dc/inc/hw/timing_generator.h  |  1 +
 .../amd/display/dc/optc/dcn10/dcn10_optc.h    |  3 +-
 .../amd/display/dc/optc/dcn32/dcn32_optc.c    |  8 +++
 .../amd/display/dc/optc/dcn32/dcn32_optc.h    |  1 +
 11 files changed, 90 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index fdff99a1dff7a..02e85b832a7d3 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1282,6 +1282,54 @@ static void disable_vbios_mode_if_required(
 	}
 }
 
+/**
+ * wait_for_blank_complete - wait for all active OPPs to finish pending blank
+ * pattern updates
+ *
+ * @dc: [in] dc reference
+ * @context: [in] hardware context in use
+ */
+static void wait_for_blank_complete(struct dc *dc,
+		struct dc_state *context)
+{
+	struct pipe_ctx *opp_head;
+	struct dce_hwseq *hws = dc->hwseq;
+	int i;
+
+	if (!hws->funcs.wait_for_blank_complete)
+		return;
+
+	for (i = 0; i < MAX_PIPES; i++) {
+		opp_head = &context->res_ctx.pipe_ctx[i];
+
+		if (!resource_is_pipe_type(opp_head, OPP_HEAD) ||
+				dc_state_get_pipe_subvp_type(context, opp_head) == SUBVP_PHANTOM)
+			continue;
+
+		hws->funcs.wait_for_blank_complete(opp_head->stream_res.opp);
+	}
+}
+
+static void wait_for_odm_update_pending_complete(struct dc *dc, struct dc_state *context)
+{
+	struct pipe_ctx *otg_master;
+	struct timing_generator *tg;
+	int i;
+
+	for (i = 0; i < MAX_PIPES; i++) {
+		otg_master = &context->res_ctx.pipe_ctx[i];
+		if (!resource_is_pipe_type(otg_master, OTG_MASTER) ||
+				dc_state_get_pipe_subvp_type(context, otg_master) == SUBVP_PHANTOM)
+			continue;
+		tg = otg_master->stream_res.tg;
+		if (tg->funcs->wait_odm_doublebuffer_pending_clear)
+			tg->funcs->wait_odm_doublebuffer_pending_clear(tg);
+	}
+
+	/* ODM update may require to reprogram blank pattern for each OPP */
+	wait_for_blank_complete(dc, context);
+}
+
 static void wait_for_no_pipes_pending(struct dc *dc, struct dc_state *context)
 {
 	int i;
@@ -1969,6 +2017,11 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 		context->stream_count == 0) {
 		/* Must wait for no flips to be pending before doing optimize bw */
 		wait_for_no_pipes_pending(dc, context);
+		/*
+		 * optimized dispclk depends on ODM setup. Need to wait for ODM
+		 * update pending complete before optimizing bandwidth.
+		 */
+		wait_for_odm_update_pending_complete(dc, context);
 		/* pplib is notified if disp_num changed */
 		dc->hwss.optimize_bandwidth(dc, context);
 		/* Need to do otg sync again as otg could be out of sync due to otg
@@ -3447,7 +3500,7 @@ static void commit_planes_for_stream_fast(struct dc *dc,
 		top_pipe_to_program->stream->update_flags.raw = 0;
 }
 
-static void wait_for_outstanding_hw_updates(struct dc *dc, const struct dc_state *dc_context)
+static void wait_for_outstanding_hw_updates(struct dc *dc, struct dc_state *dc_context)
 {
 /*
  * This function calls HWSS to wait for any potentially double buffered
@@ -3485,6 +3538,7 @@ static void wait_for_outstanding_hw_updates(struct dc *dc, const struct dc_state
 			}
 		}
 	}
+	wait_for_odm_update_pending_complete(dc, dc_context);
 }
 
 static void commit_planes_for_stream(struct dc *dc,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_opp.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_opp.c
index 0dec57679269b..86bfed5dea2e2 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_opp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_opp.c
@@ -377,6 +377,7 @@ static const struct opp_funcs dcn10_opp_funcs = {
 		.opp_set_disp_pattern_generator = NULL,
 		.opp_program_dpg_dimensions = NULL,
 		.dpg_is_blanked = NULL,
+		.dpg_is_pending = NULL,
 		.opp_destroy = opp1_destroy
 };
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_opp.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_opp.c
index 0784d01986610..fbf1b6370eb23 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_opp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_opp.c
@@ -337,6 +337,19 @@ bool opp2_dpg_is_blanked(struct output_pixel_processor *opp)
 		(double_buffer_pending == 0);
 }
 
+bool opp2_dpg_is_pending(struct output_pixel_processor *opp)
+{
+	struct dcn20_opp *oppn20 = TO_DCN20_OPP(opp);
+	uint32_t double_buffer_pending;
+	uint32_t dpg_en;
+
+	REG_GET(DPG_CONTROL, DPG_EN, &dpg_en);
+
+	REG_GET(DPG_STATUS, DPG_DOUBLE_BUFFER_PENDING, &double_buffer_pending);
+
+	return (dpg_en == 1 && double_buffer_pending == 1);
+}
+
 void opp2_program_left_edge_extra_pixel (
 		struct output_pixel_processor *opp,
 		bool count)
@@ -363,6 +376,7 @@ static struct opp_funcs dcn20_opp_funcs = {
 		.opp_set_disp_pattern_generator = opp2_set_disp_pattern_generator,
 		.opp_program_dpg_dimensions = opp2_program_dpg_dimensions,
 		.dpg_is_blanked = opp2_dpg_is_blanked,
+		.dpg_is_pending = opp2_dpg_is_pending,
 		.opp_dpg_set_blank_color = opp2_dpg_set_blank_color,
 		.opp_destroy = opp1_destroy,
 		.opp_program_left_edge_extra_pixel = opp2_program_left_edge_extra_pixel,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_opp.h b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_opp.h
index 3ab221bdd27dd..8f186abd558db 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_opp.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_opp.h
@@ -159,6 +159,8 @@ void opp2_program_dpg_dimensions(
 
 bool opp2_dpg_is_blanked(struct output_pixel_processor *opp);
 
+bool opp2_dpg_is_pending(struct output_pixel_processor *opp);
+
 void opp2_dpg_set_blank_color(
 		struct output_pixel_processor *opp,
 		const struct tg_color *color);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_opp.c b/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_opp.c
index 8e77db46a4090..6a71ba3dfc632 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_opp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_opp.c
@@ -50,6 +50,7 @@ static struct opp_funcs dcn201_opp_funcs = {
 		.opp_set_disp_pattern_generator = opp2_set_disp_pattern_generator,
 		.opp_program_dpg_dimensions = opp2_program_dpg_dimensions,
 		.dpg_is_blanked = opp2_dpg_is_blanked,
+		.dpg_is_pending = opp2_dpg_is_pending,
 		.opp_dpg_set_blank_color = opp2_dpg_set_blank_color,
 		.opp_destroy = opp1_destroy,
 		.opp_program_left_edge_extra_pixel = opp2_program_left_edge_extra_pixel,
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index eb0480aee859d..c29c7eb017c37 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -2345,7 +2345,7 @@ bool dcn20_wait_for_blank_complete(
 	int counter;
 
 	for (counter = 0; counter < 1000; counter++) {
-		if (opp->funcs->dpg_is_blanked(opp))
+		if (!opp->funcs->dpg_is_pending(opp))
 			break;
 
 		udelay(100);
@@ -2356,7 +2356,7 @@ bool dcn20_wait_for_blank_complete(
 		return false;
 	}
 
-	return true;
+	return opp->funcs->dpg_is_blanked(opp);
 }
 
 bool dcn20_dmdata_status_done(struct pipe_ctx *pipe_ctx)
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/opp.h b/drivers/gpu/drm/amd/display/dc/inc/hw/opp.h
index 7617fabbd16ee..0717920812d86 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/opp.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/opp.h
@@ -321,6 +321,9 @@ struct opp_funcs {
 	bool (*dpg_is_blanked)(
 			struct output_pixel_processor *opp);
 
+	bool (*dpg_is_pending)(struct output_pixel_processor *opp);
+
+
 	void (*opp_dpg_set_blank_color)(
 			struct output_pixel_processor *opp,
 			const struct tg_color *color);
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h b/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h
index 9a00a99317b29..cad3e5f148cf5 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h
@@ -333,6 +333,7 @@ struct timing_generator_funcs {
 
 	void (*init_odm)(struct timing_generator *tg);
 	void (*wait_drr_doublebuffer_pending_clear)(struct timing_generator *tg);
+	void (*wait_odm_doublebuffer_pending_clear)(struct timing_generator *tg);
 };
 
 #endif
diff --git a/drivers/gpu/drm/amd/display/dc/optc/dcn10/dcn10_optc.h b/drivers/gpu/drm/amd/display/dc/optc/dcn10/dcn10_optc.h
index ab81594a7fadc..6c2e84d3967fc 100644
--- a/drivers/gpu/drm/amd/display/dc/optc/dcn10/dcn10_optc.h
+++ b/drivers/gpu/drm/amd/display/dc/optc/dcn10/dcn10_optc.h
@@ -557,7 +557,8 @@ struct dcn_optc_registers {
 	type OTG_CRC_DATA_STREAM_SPLIT_MODE;\
 	type OTG_CRC_DATA_FORMAT;\
 	type OTG_V_TOTAL_LAST_USED_BY_DRR;\
-	type OTG_DRR_TIMING_DBUF_UPDATE_PENDING;
+	type OTG_DRR_TIMING_DBUF_UPDATE_PENDING;\
+	type OTG_H_TIMING_DIV_MODE_DB_UPDATE_PENDING;
 
 #define TG_REG_FIELD_LIST_DCN3_2(type) \
 	type OTG_H_TIMING_DIV_MODE_MANUAL;
diff --git a/drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.c b/drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.c
index 8234935433254..f07a4c7e48bc2 100644
--- a/drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.c
@@ -122,6 +122,13 @@ void optc32_get_odm_combine_segments(struct timing_generator *tg, int *odm_combi
 	}
 }
 
+void optc32_wait_odm_doublebuffer_pending_clear(struct timing_generator *tg)
+{
+	struct optc *optc1 = DCN10TG_FROM_TG(tg);
+
+	REG_WAIT(OTG_DOUBLE_BUFFER_CONTROL, OTG_H_TIMING_DIV_MODE_DB_UPDATE_PENDING, 0, 2, 50000);
+}
+
 void optc32_set_h_timing_div_manual_mode(struct timing_generator *optc, bool manual_mode)
 {
 	struct optc *optc1 = DCN10TG_FROM_TG(optc);
@@ -345,6 +352,7 @@ static struct timing_generator_funcs dcn32_tg_funcs = {
 		.set_odm_bypass = optc32_set_odm_bypass,
 		.set_odm_combine = optc32_set_odm_combine,
 		.get_odm_combine_segments = optc32_get_odm_combine_segments,
+		.wait_odm_doublebuffer_pending_clear = optc32_wait_odm_doublebuffer_pending_clear,
 		.set_h_timing_div_manual_mode = optc32_set_h_timing_div_manual_mode,
 		.get_optc_source = optc2_get_optc_source,
 		.set_out_mux = optc3_set_out_mux,
diff --git a/drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.h b/drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.h
index 8ce3b178cab06..0c2c146955619 100644
--- a/drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.h
+++ b/drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.h
@@ -183,5 +183,6 @@ void optc32_set_h_timing_div_manual_mode(struct timing_generator *optc, bool man
 void optc32_get_odm_combine_segments(struct timing_generator *tg, int *odm_combine_segments);
 void optc32_set_odm_bypass(struct timing_generator *optc,
 		const struct dc_crtc_timing *dc_crtc_timing);
+void optc32_wait_odm_doublebuffer_pending_clear(struct timing_generator *tg);
 
 #endif /* __DC_OPTC_DCN32_H__ */
-- 
2.43.0



