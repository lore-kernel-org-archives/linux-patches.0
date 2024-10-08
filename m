Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8515D1C2420;
	Tue,  8 Oct 2024 12:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391758; cv=none; b=H7QIk9mmT58HFmw4gF6LINXQY0ZPLi6WB5xhKEnlKwCl3+HDe9yWuEb3IBtmnyrwspCxAwEd1vpwf2YrxVHQJRuOuEnsWtauB6f1mXc5MgEuA2Vst80qPU4EomeMXjVjk42qsfCu0FDkYpTViwbG5WzRebNUVY1/GE7irsnGa3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391758; c=relaxed/simple;
	bh=P+nLC9VhkPVL7j8OTLg7xsrvCL/0DHb+ZIy51f7n8Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epuzHV8+7TMMWlqt1f4+ivmyqdQGL/Ud4aT7VL0Z+EjRRlF8Bs302tnnGhvW2whPQ/J3Gtx8oxZMm7/cDWOTuuPliXfW/OC55gKlvW9I7zZEB4193fFlwb9mcF9BXH2kGo0WdYTC2hxaZepPdXbKt6F6ZjliIpf3gqsqRoiTKCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0lGgLfk9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0lGgLfk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA5FC4CEC7;
	Tue,  8 Oct 2024 12:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391758;
	bh=P+nLC9VhkPVL7j8OTLg7xsrvCL/0DHb+ZIy51f7n8Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0lGgLfk9W856oaqngzUQ9P3/ts8KSHN+KNoCiPZ6Di80vHZxNWTW4ZSx6ACPxuTdr
	 GdmrBaZKWtgwIVWh4m9r8ahN3y6AGJxdu3jnd6T71tOd9H53kr+ziLjkvUiaAJgl/H
	 Yhb39312nm6n592+bInaYkJOeWJR1pLr+v2lpmPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 206/558] drm/amd/display: Check null pointers before multiple uses
Date: Tue,  8 Oct 2024 14:03:56 +0200
Message-ID: <20241008115710.451128532@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit fdd5ecbbff751c3b9061d8ebb08e5c96119915b4 ]

[WHAT & HOW]
Poniters, such as stream_enc and dc->bw_vbios, are null checked previously
in the same function, so Coverity warns "implies that stream_enc and
dc->bw_vbios might be null". They are used multiple times in the
subsequent code and need to be checked.

This fixes 10 FORWARD_NULL issues reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/core/dc_hw_sequencer.c | 96 ++++++++++---------
 .../amd/display/dc/hwss/dcn20/dcn20_hwseq.c   |  8 +-
 .../display/dc/link/accessories/link_dp_cts.c |  5 +-
 .../amd/display/dc/link/hwss/link_hwss_dio.c  |  5 +-
 .../dc/resource/dce112/dce112_resource.c      |  5 +-
 .../dc/resource/dcn32/dcn32_resource.c        |  3 +
 .../resource/dcn32/dcn32_resource_helpers.c   | 10 +-
 7 files changed, 76 insertions(+), 56 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
index 87e36d51c56d8..4a88412fdfab1 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -636,57 +636,59 @@ void hwss_build_fast_sequence(struct dc *dc,
 	while (current_pipe) {
 		current_mpc_pipe = current_pipe;
 		while (current_mpc_pipe) {
-			if (dc->hwss.set_flip_control_gsl && current_mpc_pipe->plane_state && current_mpc_pipe->plane_state->update_flags.raw) {
-				block_sequence[*num_steps].params.set_flip_control_gsl_params.pipe_ctx = current_mpc_pipe;
-				block_sequence[*num_steps].params.set_flip_control_gsl_params.flip_immediate = current_mpc_pipe->plane_state->flip_immediate;
-				block_sequence[*num_steps].func = HUBP_SET_FLIP_CONTROL_GSL;
-				(*num_steps)++;
-			}
-			if (dc->hwss.program_triplebuffer && dc->debug.enable_tri_buf && current_mpc_pipe->plane_state->update_flags.raw) {
-				block_sequence[*num_steps].params.program_triplebuffer_params.dc = dc;
-				block_sequence[*num_steps].params.program_triplebuffer_params.pipe_ctx = current_mpc_pipe;
-				block_sequence[*num_steps].params.program_triplebuffer_params.enableTripleBuffer = current_mpc_pipe->plane_state->triplebuffer_flips;
-				block_sequence[*num_steps].func = HUBP_PROGRAM_TRIPLEBUFFER;
-				(*num_steps)++;
-			}
-			if (dc->hwss.update_plane_addr && current_mpc_pipe->plane_state->update_flags.bits.addr_update) {
-				if (resource_is_pipe_type(current_mpc_pipe, OTG_MASTER) &&
-						stream_status->mall_stream_config.type == SUBVP_MAIN) {
-					block_sequence[*num_steps].params.subvp_save_surf_addr.dc_dmub_srv = dc->ctx->dmub_srv;
-					block_sequence[*num_steps].params.subvp_save_surf_addr.addr = &current_mpc_pipe->plane_state->address;
-					block_sequence[*num_steps].params.subvp_save_surf_addr.subvp_index = current_mpc_pipe->subvp_index;
-					block_sequence[*num_steps].func = DMUB_SUBVP_SAVE_SURF_ADDR;
+			if (current_mpc_pipe->plane_state) {
+				if (dc->hwss.set_flip_control_gsl && current_mpc_pipe->plane_state->update_flags.raw) {
+					block_sequence[*num_steps].params.set_flip_control_gsl_params.pipe_ctx = current_mpc_pipe;
+					block_sequence[*num_steps].params.set_flip_control_gsl_params.flip_immediate = current_mpc_pipe->plane_state->flip_immediate;
+					block_sequence[*num_steps].func = HUBP_SET_FLIP_CONTROL_GSL;
+					(*num_steps)++;
+				}
+				if (dc->hwss.program_triplebuffer && dc->debug.enable_tri_buf && current_mpc_pipe->plane_state->update_flags.raw) {
+					block_sequence[*num_steps].params.program_triplebuffer_params.dc = dc;
+					block_sequence[*num_steps].params.program_triplebuffer_params.pipe_ctx = current_mpc_pipe;
+					block_sequence[*num_steps].params.program_triplebuffer_params.enableTripleBuffer = current_mpc_pipe->plane_state->triplebuffer_flips;
+					block_sequence[*num_steps].func = HUBP_PROGRAM_TRIPLEBUFFER;
+					(*num_steps)++;
+				}
+				if (dc->hwss.update_plane_addr && current_mpc_pipe->plane_state->update_flags.bits.addr_update) {
+					if (resource_is_pipe_type(current_mpc_pipe, OTG_MASTER) &&
+							stream_status->mall_stream_config.type == SUBVP_MAIN) {
+						block_sequence[*num_steps].params.subvp_save_surf_addr.dc_dmub_srv = dc->ctx->dmub_srv;
+						block_sequence[*num_steps].params.subvp_save_surf_addr.addr = &current_mpc_pipe->plane_state->address;
+						block_sequence[*num_steps].params.subvp_save_surf_addr.subvp_index = current_mpc_pipe->subvp_index;
+						block_sequence[*num_steps].func = DMUB_SUBVP_SAVE_SURF_ADDR;
+						(*num_steps)++;
+					}
+
+					block_sequence[*num_steps].params.update_plane_addr_params.dc = dc;
+					block_sequence[*num_steps].params.update_plane_addr_params.pipe_ctx = current_mpc_pipe;
+					block_sequence[*num_steps].func = HUBP_UPDATE_PLANE_ADDR;
 					(*num_steps)++;
 				}
 
-				block_sequence[*num_steps].params.update_plane_addr_params.dc = dc;
-				block_sequence[*num_steps].params.update_plane_addr_params.pipe_ctx = current_mpc_pipe;
-				block_sequence[*num_steps].func = HUBP_UPDATE_PLANE_ADDR;
-				(*num_steps)++;
-			}
-
-			if (hws->funcs.set_input_transfer_func && current_mpc_pipe->plane_state->update_flags.bits.gamma_change) {
-				block_sequence[*num_steps].params.set_input_transfer_func_params.dc = dc;
-				block_sequence[*num_steps].params.set_input_transfer_func_params.pipe_ctx = current_mpc_pipe;
-				block_sequence[*num_steps].params.set_input_transfer_func_params.plane_state = current_mpc_pipe->plane_state;
-				block_sequence[*num_steps].func = DPP_SET_INPUT_TRANSFER_FUNC;
-				(*num_steps)++;
-			}
+				if (hws->funcs.set_input_transfer_func && current_mpc_pipe->plane_state->update_flags.bits.gamma_change) {
+					block_sequence[*num_steps].params.set_input_transfer_func_params.dc = dc;
+					block_sequence[*num_steps].params.set_input_transfer_func_params.pipe_ctx = current_mpc_pipe;
+					block_sequence[*num_steps].params.set_input_transfer_func_params.plane_state = current_mpc_pipe->plane_state;
+					block_sequence[*num_steps].func = DPP_SET_INPUT_TRANSFER_FUNC;
+					(*num_steps)++;
+				}
 
-			if (dc->hwss.program_gamut_remap && current_mpc_pipe->plane_state->update_flags.bits.gamut_remap_change) {
-				block_sequence[*num_steps].params.program_gamut_remap_params.pipe_ctx = current_mpc_pipe;
-				block_sequence[*num_steps].func = DPP_PROGRAM_GAMUT_REMAP;
-				(*num_steps)++;
-			}
-			if (current_mpc_pipe->plane_state->update_flags.bits.input_csc_change) {
-				block_sequence[*num_steps].params.setup_dpp_params.pipe_ctx = current_mpc_pipe;
-				block_sequence[*num_steps].func = DPP_SETUP_DPP;
-				(*num_steps)++;
-			}
-			if (current_mpc_pipe->plane_state->update_flags.bits.coeff_reduction_change) {
-				block_sequence[*num_steps].params.program_bias_and_scale_params.pipe_ctx = current_mpc_pipe;
-				block_sequence[*num_steps].func = DPP_PROGRAM_BIAS_AND_SCALE;
-				(*num_steps)++;
+				if (dc->hwss.program_gamut_remap && current_mpc_pipe->plane_state->update_flags.bits.gamut_remap_change) {
+					block_sequence[*num_steps].params.program_gamut_remap_params.pipe_ctx = current_mpc_pipe;
+					block_sequence[*num_steps].func = DPP_PROGRAM_GAMUT_REMAP;
+					(*num_steps)++;
+				}
+				if (current_mpc_pipe->plane_state->update_flags.bits.input_csc_change) {
+					block_sequence[*num_steps].params.setup_dpp_params.pipe_ctx = current_mpc_pipe;
+					block_sequence[*num_steps].func = DPP_SETUP_DPP;
+					(*num_steps)++;
+				}
+				if (current_mpc_pipe->plane_state->update_flags.bits.coeff_reduction_change) {
+					block_sequence[*num_steps].params.program_bias_and_scale_params.pipe_ctx = current_mpc_pipe;
+					block_sequence[*num_steps].func = DPP_PROGRAM_BIAS_AND_SCALE;
+					(*num_steps)++;
+				}
 			}
 			if (hws->funcs.set_output_transfer_func && current_mpc_pipe->stream->update_flags.bits.out_tf) {
 				block_sequence[*num_steps].params.set_output_transfer_func_params.dc = dc;
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index 2532ad410cb56..456e19e0d415c 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -2283,6 +2283,9 @@ void dcn20_post_unlock_program_front_end(
 		}
 	}
 
+	if (!hwseq)
+		return;
+
 	/* P-State support transitions:
 	 * Natural -> FPO: 		P-State disabled in prepare, force disallow anytime is safe
 	 * FPO -> Natural: 		Unforce anytime after FW disable is safe (P-State will assert naturally)
@@ -2290,7 +2293,7 @@ void dcn20_post_unlock_program_front_end(
 	 * FPO -> Unsupported:	P-State disabled in prepare, unforce disallow anytime is safe
 	 * FPO <-> SubVP:		Force disallow is maintained on the FPO / SubVP pipes
 	 */
-	if (hwseq && hwseq->funcs.update_force_pstate)
+	if (hwseq->funcs.update_force_pstate)
 		dc->hwseq->funcs.update_force_pstate(dc, context);
 
 	/* Only program the MALL registers after all the main and phantom pipes
@@ -2529,6 +2532,9 @@ bool dcn20_wait_for_blank_complete(
 {
 	int counter;
 
+	if (!opp)
+		return false;
+
 	for (counter = 0; counter < 1000; counter++) {
 		if (!opp->funcs->dpg_is_pending(opp))
 			break;
diff --git a/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c b/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
index 555c1c484cfdd..df3781081da7a 100644
--- a/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
+++ b/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
@@ -804,8 +804,11 @@ bool dp_set_test_pattern(
 			break;
 		}
 
+		if (!pipe_ctx->stream)
+			return false;
+
 		if (pipe_ctx->stream_res.tg->funcs->lock_doublebuffer_enable) {
-			if (pipe_ctx->stream && should_use_dmub_lock(pipe_ctx->stream->link)) {
+			if (should_use_dmub_lock(pipe_ctx->stream->link)) {
 				union dmub_hw_lock_flags hw_locks = { 0 };
 				struct dmub_hw_lock_inst_flags inst_flags = { 0 };
 
diff --git a/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_dio.c b/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_dio.c
index b76737b7b9e41..3e47a6735912a 100644
--- a/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_dio.c
+++ b/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_dio.c
@@ -74,7 +74,10 @@ void reset_dio_stream_encoder(struct pipe_ctx *pipe_ctx)
 	struct link_encoder *link_enc = link_enc_cfg_get_link_enc(pipe_ctx->stream->link);
 	struct stream_encoder *stream_enc = pipe_ctx->stream_res.stream_enc;
 
-	if (stream_enc && stream_enc->funcs->disable_fifo)
+	if (!stream_enc)
+		return;
+
+	if (stream_enc->funcs->disable_fifo)
 		stream_enc->funcs->disable_fifo(stream_enc);
 	if (stream_enc->funcs->set_input_mode)
 		stream_enc->funcs->set_input_mode(stream_enc, 0);
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dce112/dce112_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dce112/dce112_resource.c
index 88afb2a30eef5..162856c523e40 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dce112/dce112_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce112/dce112_resource.c
@@ -1067,7 +1067,10 @@ static void bw_calcs_data_update_from_pplib(struct dc *dc)
 	struct dm_pp_clock_levels clks = {0};
 	int memory_type_multiplier = MEMORY_TYPE_MULTIPLIER_CZ;
 
-	if (dc->bw_vbios && dc->bw_vbios->memory_type == bw_def_hbm)
+	if (!dc->bw_vbios)
+		return;
+
+	if (dc->bw_vbios->memory_type == bw_def_hbm)
 		memory_type_multiplier = MEMORY_TYPE_HBM;
 
 	/*do system clock  TODO PPLIB: after PPLIB implement,
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
index 969658313fd65..a43ffa53890af 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
@@ -1651,6 +1651,9 @@ static void dcn32_enable_phantom_plane(struct dc *dc,
 		else
 			phantom_plane = dc_state_create_phantom_plane(dc, context, curr_pipe->plane_state);
 
+		if (!phantom_plane)
+			continue;
+
 		memcpy(&phantom_plane->address, &curr_pipe->plane_state->address, sizeof(phantom_plane->address));
 		memcpy(&phantom_plane->scaling_quality, &curr_pipe->plane_state->scaling_quality,
 				sizeof(phantom_plane->scaling_quality));
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource_helpers.c b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource_helpers.c
index d184105ce2b3e..47c8a9fbe7546 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource_helpers.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource_helpers.c
@@ -218,12 +218,12 @@ bool dcn32_is_center_timing(struct pipe_ctx *pipe)
 				pipe->stream->timing.v_addressable != pipe->stream->src.height) {
 			is_center_timing = true;
 		}
-	}
 
-	if (pipe->plane_state) {
-		if (pipe->stream->timing.v_addressable != pipe->plane_state->dst_rect.height &&
-				pipe->stream->timing.v_addressable != pipe->plane_state->src_rect.height) {
-			is_center_timing = true;
+		if (pipe->plane_state) {
+			if (pipe->stream->timing.v_addressable != pipe->plane_state->dst_rect.height &&
+					pipe->stream->timing.v_addressable != pipe->plane_state->src_rect.height) {
+				is_center_timing = true;
+			}
 		}
 	}
 
-- 
2.43.0



