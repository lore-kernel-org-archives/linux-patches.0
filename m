Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA51221F00;
	Mon, 13 Oct 2025 15:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369353; cv=none; b=QVwaQi2PpGargNB2hgRuubSrh1xIb/gzCWk19rhsAURTw+dGbzs5GpAJcbyF67cMZcsbX1PU8esNuhAkpIs5yZcw/1hB1Vh31DPdWpbKSKHJxgeWZ47KcCksMeDHeBUsqZwnVLKOe6lGHp3BuZREqZDOBnNrvsbIwTrPRQV22yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369353; c=relaxed/simple;
	bh=t2OHuwNWEuuNjg3jbWJExlVAhCW857tflQhQp97n1Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdDG3hfK9s8yKuli9/CP6CouufhF7hnH+4nUvCa70dPehclAtkZO+Qh3Qhqp5UJZeRTb0L2PYB2iHhOEksbncvk9fU7WBYg2RIxwX1wVChbfdkNklfB3MRpNvx8RT5rishLUAoMvrvWErJtIIMA+90Q4Y/kcvkggp3T3L+h6I/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N6+vARAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N6+vARAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0204AC4CEE7;
	Mon, 13 Oct 2025 15:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369353;
	bh=t2OHuwNWEuuNjg3jbWJExlVAhCW857tflQhQp97n1Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N6+vARAqQoH3lsxJz2glkcg55kxcMut4/gGZs5JoPZeP7wwWPbhcALhlp8jHyuLaI
	 6gAcC4jSC9u/zkjuu45gUWXZUzicy28JKyjZoDh5vbRmPrC2mQbzbYs0DI+lw5YxNV
	 mSws/XbFlxRLlOJ2zP1duSveTxRjBfOBf5sxeTfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	George Shen <george.shen@amd.com>,
	Michael Strauss <michael.strauss@amd.com>,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 216/563] drm/amd/display: Reduce Stack Usage by moving audio_output into stream_res v4
Date: Mon, 13 Oct 2025 16:41:17 +0200
Message-ID: <20251013144419.109274119@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 1cf1205ef2685cf43db3785706b017d1e54e0bec ]

The function `dp_retrain_link_dp_test` currently allocates a large
audio_output array on the stack, causing the stack frame size to exceed
the compiler limit (1080 bytes > 1024 bytes).

This change prevents stack overflow issues:
amdgpu/../display/dc/link/accessories/link_dp_cts.c:65:13: warning: stack frame size (1080) exceeds limit (1024) in 'dp_retrain_link_dp_test' [-Wframe-larger-than]
static void dp_retrain_link_dp_test(struct dc_link *link,

v2: Move audio-related data like `audio_output` is kept "per pipe" to
    manage the audio for that specific display pipeline/display output path
    (stream). (Wenjing)

v3: Update in all the places where `build_audio_output` is currently
    called with a separate audio_output variable on the stack & wherever
    `audio_output` is passed to other functions
    `dce110_apply_single_controller_ctx_to_hw()` &
    `dce110_setup_audio_dto()` (like `az_configure`, `wall_dto_setup`)
    replace with usage of `pipe_ctx->stream_res.audio_output`
    to centralize audio data per pipe.

v4: Remove empty lines before `build_audio_output`. (Alex)

Fixes: 9c6669c2e21a ("drm/amd/display: Fix Link Override Sequencing When Switching Between DIO/HPO")
Cc: Wayne Lin <wayne.lin@amd.com>
Cc: George Shen <george.shen@amd.com>
Cc: Michael Strauss <michael.strauss@amd.com>
Cc: Alvin Lee <Alvin.Lee2@amd.com>
Cc: Ray Wu <ray.wu@amd.com>
Cc: Wenjing Liu <wenjing.liu@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/hwss/dce110/dce110_hwseq.c | 32 ++++++++-----------
 .../gpu/drm/amd/display/dc/inc/core_types.h   |  5 +--
 .../display/dc/link/accessories/link_dp_cts.c | 12 +++----
 .../dc/resource/dcn31/dcn31_resource.c        |  5 ++-
 .../dc/resource/dcn31/dcn31_resource.h        |  3 +-
 5 files changed, 26 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index 4ea13d0bf815e..c69194e04ff93 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1600,19 +1600,17 @@ enum dc_status dce110_apply_single_controller_ctx_to_hw(
 	}
 
 	if (pipe_ctx->stream_res.audio != NULL) {
-		struct audio_output audio_output = {0};
+		build_audio_output(context, pipe_ctx, &pipe_ctx->stream_res.audio_output);
 
-		build_audio_output(context, pipe_ctx, &audio_output);
-
-		link_hwss->setup_audio_output(pipe_ctx, &audio_output,
+		link_hwss->setup_audio_output(pipe_ctx, &pipe_ctx->stream_res.audio_output,
 				pipe_ctx->stream_res.audio->inst);
 
 		pipe_ctx->stream_res.audio->funcs->az_configure(
 				pipe_ctx->stream_res.audio,
 				pipe_ctx->stream->signal,
-				&audio_output.crtc_info,
+				&pipe_ctx->stream_res.audio_output.crtc_info,
 				&pipe_ctx->stream->audio_info,
-				&audio_output.dp_link_info);
+				&pipe_ctx->stream_res.audio_output.dp_link_info);
 
 		if (dc->config.disable_hbr_audio_dp2)
 			if (pipe_ctx->stream_res.audio->funcs->az_disable_hbr_audio &&
@@ -2386,9 +2384,7 @@ static void dce110_setup_audio_dto(
 		if (pipe_ctx->stream->signal != SIGNAL_TYPE_HDMI_TYPE_A)
 			continue;
 		if (pipe_ctx->stream_res.audio != NULL) {
-			struct audio_output audio_output;
-
-			build_audio_output(context, pipe_ctx, &audio_output);
+			build_audio_output(context, pipe_ctx, &pipe_ctx->stream_res.audio_output);
 
 			if (dc->res_pool->dccg && dc->res_pool->dccg->funcs->set_audio_dtbclk_dto) {
 				struct dtbclk_dto_params dto_params = {0};
@@ -2399,14 +2395,14 @@ static void dce110_setup_audio_dto(
 				pipe_ctx->stream_res.audio->funcs->wall_dto_setup(
 						pipe_ctx->stream_res.audio,
 						pipe_ctx->stream->signal,
-						&audio_output.crtc_info,
-						&audio_output.pll_info);
+						&pipe_ctx->stream_res.audio_output.crtc_info,
+						&pipe_ctx->stream_res.audio_output.pll_info);
 			} else
 				pipe_ctx->stream_res.audio->funcs->wall_dto_setup(
 					pipe_ctx->stream_res.audio,
 					pipe_ctx->stream->signal,
-					&audio_output.crtc_info,
-					&audio_output.pll_info);
+					&pipe_ctx->stream_res.audio_output.crtc_info,
+					&pipe_ctx->stream_res.audio_output.pll_info);
 			break;
 		}
 	}
@@ -2426,15 +2422,15 @@ static void dce110_setup_audio_dto(
 				continue;
 
 			if (pipe_ctx->stream_res.audio != NULL) {
-				struct audio_output audio_output = {0};
-
-				build_audio_output(context, pipe_ctx, &audio_output);
+				build_audio_output(context,
+						   pipe_ctx,
+						   &pipe_ctx->stream_res.audio_output);
 
 				pipe_ctx->stream_res.audio->funcs->wall_dto_setup(
 					pipe_ctx->stream_res.audio,
 					pipe_ctx->stream->signal,
-					&audio_output.crtc_info,
-					&audio_output.pll_info);
+					&pipe_ctx->stream_res.audio_output.crtc_info,
+					&pipe_ctx->stream_res.audio_output.pll_info);
 				break;
 			}
 		}
diff --git a/drivers/gpu/drm/amd/display/dc/inc/core_types.h b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
index f0d7185153b2a..f896cce87b8d4 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/core_types.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
@@ -228,8 +228,7 @@ struct resource_funcs {
 	enum dc_status (*update_dc_state_for_encoder_switch)(struct dc_link *link,
 		struct dc_link_settings *link_setting,
 		uint8_t pipe_count,
-		struct pipe_ctx *pipes,
-		struct audio_output *audio_output);
+		struct pipe_ctx *pipes);
 };
 
 struct audio_support{
@@ -361,6 +360,8 @@ struct stream_resource {
 	uint8_t gsl_group;
 
 	struct test_pattern_params test_pattern_params;
+
+	struct audio_output audio_output;
 };
 
 struct plane_resource {
diff --git a/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c b/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
index 2956c2b3ad1aa..b12d61701d4d9 100644
--- a/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
+++ b/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
@@ -75,7 +75,6 @@ static void dp_retrain_link_dp_test(struct dc_link *link,
 	bool is_hpo_acquired;
 	uint8_t count;
 	int i;
-	struct audio_output audio_output[MAX_PIPES];
 
 	needs_divider_update = (link->dc->link_srv->dp_get_encoding_format(link_setting) !=
 	link->dc->link_srv->dp_get_encoding_format((const struct dc_link_settings *) &link->cur_link_settings));
@@ -99,7 +98,7 @@ static void dp_retrain_link_dp_test(struct dc_link *link,
 	if (needs_divider_update && link->dc->res_pool->funcs->update_dc_state_for_encoder_switch) {
 		link->dc->res_pool->funcs->update_dc_state_for_encoder_switch(link,
 				link_setting, count,
-				*pipes, &audio_output[0]);
+				*pipes);
 		for (i = 0; i < count; i++) {
 			pipes[i]->clock_source->funcs->program_pix_clk(
 					pipes[i]->clock_source,
@@ -111,15 +110,16 @@ static void dp_retrain_link_dp_test(struct dc_link *link,
 				const struct link_hwss *link_hwss = get_link_hwss(
 					link, &pipes[i]->link_res);
 
-				link_hwss->setup_audio_output(pipes[i], &audio_output[i],
-						pipes[i]->stream_res.audio->inst);
+				link_hwss->setup_audio_output(pipes[i],
+							      &pipes[i]->stream_res.audio_output,
+							      pipes[i]->stream_res.audio->inst);
 
 				pipes[i]->stream_res.audio->funcs->az_configure(
 						pipes[i]->stream_res.audio,
 						pipes[i]->stream->signal,
-						&audio_output[i].crtc_info,
+						&pipes[i]->stream_res.audio_output.crtc_info,
 						&pipes[i]->stream->audio_info,
-						&audio_output[i].dp_link_info);
+						&pipes[i]->stream_res.audio_output.dp_link_info);
 
 				if (link->dc->config.disable_hbr_audio_dp2 &&
 						pipes[i]->stream_res.audio->funcs->az_disable_hbr_audio &&
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c
index 3ed7f50554e21..ca17e5d8fdc2a 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c
@@ -2239,8 +2239,7 @@ struct resource_pool *dcn31_create_resource_pool(
 enum dc_status dcn31_update_dc_state_for_encoder_switch(struct dc_link *link,
 	struct dc_link_settings *link_setting,
 	uint8_t pipe_count,
-	struct pipe_ctx *pipes,
-	struct audio_output *audio_output)
+	struct pipe_ctx *pipes)
 {
 	struct dc_state *state = link->dc->current_state;
 	int i;
@@ -2255,7 +2254,7 @@ enum dc_status dcn31_update_dc_state_for_encoder_switch(struct dc_link *link,
 
 		// Setup audio
 		if (pipes[i].stream_res.audio != NULL)
-			build_audio_output(state, &pipes[i], &audio_output[i]);
+			build_audio_output(state, &pipes[i], &pipes[i].stream_res.audio_output);
 	}
 #else
 	/* This DCN requires rate divider updates and audio reprogramming to allow DP1<-->DP2 link rate switching,
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.h b/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.h
index c32c85ef0ba47..7e8fde65528f1 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.h
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.h
@@ -69,8 +69,7 @@ unsigned int dcn31_get_det_buffer_size(
 enum dc_status dcn31_update_dc_state_for_encoder_switch(struct dc_link *link,
 	struct dc_link_settings *link_setting,
 	uint8_t pipe_count,
-	struct pipe_ctx *pipes,
-	struct audio_output *audio_output);
+	struct pipe_ctx *pipes);
 
 /*temp: B0 specific before switch to dcn313 headers*/
 #ifndef regPHYPLLF_PIXCLK_RESYNC_CNTL
-- 
2.51.0



