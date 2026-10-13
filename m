Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DFF4F3937;
	Tue, 13 Oct 2026 12:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893296; cv=none; b=uDwV8bJHIuvwTYfZqHfOudBf4NjXJbxfnNVIvud4qFziwSXkLIxcCbFOvCsP1u/3MSc22v3in1NRCUbbI45mSLPmji5g4EovspIU/xsd/XULIYV4p0juLg626xh8EcfucW8cs9T+MWldGzfszWTOga7d7YXfhATNfuZ+IM6+DSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893296; c=relaxed/simple;
	bh=qgGYSYVsXgpyB4trjEZ7fiVExBacj1BDLAejf11CI0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyz3BhBVn0MP8jIGey5v2ElMmZoEjhbNl2H+icKGuu6tJ7sJ4HZu2wT2+/rxvT90HKLbcV0OA+KNyFH4MEs+mcmjzQAEIxKgu1k1UToJswHpiHzL/1e3uoXnuA/FGclqa08tkoOkV6t+1SLtf3GhbrU2m3TSWYBgXVm1MZr+/Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvPHB7fI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvPHB7fI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46731F000FF;
	Tue, 13 Oct 2026 12:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893294;
	bh=Meryn1k7L6o+IbkWSoC7M3e8O5hTtIj9PllYv4/L85U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zvPHB7fItkCCfdRKoihyRiXVani0CRx3usxFJltoECjY4NZ57iYW8pweXEQwWhHaG
	 ha27xhkG5vv7Pi/YILqQu1xBboyesmdd18G0cZmegOP5IEw664bjBIxZGuMSfv9G6l
	 uXUp+lqW4h379IHIrj1iFGWSMLI/lAHQcy7hm3kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Roman Li <roman.li@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 178/621] drm/amd/display: Rename FAMS2 global control lock to DMUB HW control lock
Date: Tue, 13 Oct 2026 13:32:53 +0200
Message-ID: <20261013112925.086194560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 6d92c4d03063480a60bbc3ff61d22197c931f411 ]

[Why]
FAMS2 dictates whether the inbox0 HW lock is required, but it is not the
only feature that may determine this.

In order to leverage the faster inbox0 HW lock in place of the inbox1
ringbuffer based control lock it's desirable to utilize the HWSS
based locking protocol FAMS2 has already implemented.

[How]
Rename the FAMS2 global control lock to DMUB HW control lock.

This is purely a refactor with no functional change, the logic that will
determine which features need to enable this HW lock will be added in a
future commit.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 75372d75a4e2 ("drm/amd/display: Adjust PHY FSM transition to TX_EN-to-PLL_ON for TMDS on DCN35")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c      | 29 +++++++++----------
 .../drm/amd/display/dc/core/dc_hw_sequencer.c | 24 +++++++--------
 .../amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 18 ++++++------
 .../amd/display/dc/hwss/dcn401/dcn401_hwseq.h |  4 +--
 .../amd/display/dc/hwss/dcn401/dcn401_init.c  |  4 +--
 .../drm/amd/display/dc/hwss/hw_sequencer.h    | 10 +++----
 6 files changed, 44 insertions(+), 45 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 31094d5c0f588..2abeb956260e4 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2158,8 +2158,8 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 	 */
 	if (dc->hwss.subvp_pipe_control_lock)
 		dc->hwss.subvp_pipe_control_lock(dc, context, true, true, NULL, subvp_prev_use);
-	if (dc->hwss.fams2_global_control_lock)
-		dc->hwss.fams2_global_control_lock(dc, context, true);
+	if (dc->hwss.dmub_hw_control_lock)
+		dc->hwss.dmub_hw_control_lock(dc, context, true);
 
 	if (dc->hwss.update_dsc_pg)
 		dc->hwss.update_dsc_pg(dc, context, false);
@@ -2229,8 +2229,8 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 		dc->hwss.commit_subvp_config(dc, context);
 	if (dc->hwss.subvp_pipe_control_lock)
 		dc->hwss.subvp_pipe_control_lock(dc, context, false, true, NULL, subvp_prev_use);
-	if (dc->hwss.fams2_global_control_lock)
-		dc->hwss.fams2_global_control_lock(dc, context, false);
+	if (dc->hwss.dmub_hw_control_lock)
+		dc->hwss.dmub_hw_control_lock(dc, context, false);
 
 	for (i = 0; i < context->stream_count; i++) {
 		const struct dc_link *link = context->streams[i]->link;
@@ -4184,16 +4184,16 @@ static void commit_planes_for_stream(struct dc *dc,
 		if (dc->hwss.subvp_pipe_control_lock)
 			dc->hwss.subvp_pipe_control_lock(dc, context, true, should_lock_all_pipes, NULL, subvp_prev_use);
 
-		if (dc->hwss.fams2_global_control_lock)
-			dc->hwss.fams2_global_control_lock(dc, context, true);
+		if (dc->hwss.dmub_hw_control_lock)
+			dc->hwss.dmub_hw_control_lock(dc, context, true);
 
 		dc->hwss.interdependent_update_lock(dc, context, true);
 	} else {
 		if (dc->hwss.subvp_pipe_control_lock)
 			dc->hwss.subvp_pipe_control_lock(dc, context, true, should_lock_all_pipes, top_pipe_to_program, subvp_prev_use);
 
-		if (dc->hwss.fams2_global_control_lock)
-			dc->hwss.fams2_global_control_lock(dc, context, true);
+		if (dc->hwss.dmub_hw_control_lock)
+			dc->hwss.dmub_hw_control_lock(dc, context, true);
 
 		/* Lock the top pipe while updating plane addrs, since freesync requires
 		 *  plane addr update event triggers to be synchronized.
@@ -4236,9 +4236,8 @@ static void commit_planes_for_stream(struct dc *dc,
 			dc->hwss.subvp_pipe_control_lock(dc, context, false, should_lock_all_pipes,
 							 NULL, subvp_prev_use);
 
-		if (dc->hwss.fams2_global_control_lock)
-			dc->hwss.fams2_global_control_lock(dc, context, false);
-
+		if (dc->hwss.dmub_hw_control_lock)
+			dc->hwss.dmub_hw_control_lock(dc, context, false);
 		return;
 	}
 
@@ -4475,13 +4474,13 @@ static void commit_planes_for_stream(struct dc *dc,
 	if (should_lock_all_pipes && dc->hwss.interdependent_update_lock) {
 		if (dc->hwss.subvp_pipe_control_lock)
 			dc->hwss.subvp_pipe_control_lock(dc, context, false, should_lock_all_pipes, NULL, subvp_prev_use);
-		if (dc->hwss.fams2_global_control_lock)
-			dc->hwss.fams2_global_control_lock(dc, context, false);
+		if (dc->hwss.dmub_hw_control_lock)
+			dc->hwss.dmub_hw_control_lock(dc, context, false);
 	} else {
 		if (dc->hwss.subvp_pipe_control_lock)
 			dc->hwss.subvp_pipe_control_lock(dc, context, false, should_lock_all_pipes, top_pipe_to_program, subvp_prev_use);
-		if (dc->hwss.fams2_global_control_lock)
-			dc->hwss.fams2_global_control_lock(dc, context, false);
+		if (dc->hwss.dmub_hw_control_lock)
+			dc->hwss.dmub_hw_control_lock(dc, context, false);
 	}
 
 	// Fire manual trigger only when bottom plane is flipped
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
index f56d1ae879ee3..f28f61787f16e 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -764,11 +764,11 @@ void hwss_build_fast_sequence(struct dc *dc,
 		block_sequence[*num_steps].func = DMUB_SUBVP_PIPE_CONTROL_LOCK_FAST;
 		(*num_steps)++;
 	}
-	if (dc->hwss.fams2_global_control_lock_fast) {
-		block_sequence[*num_steps].params.fams2_global_control_lock_fast_params.dc = dc;
-		block_sequence[*num_steps].params.fams2_global_control_lock_fast_params.lock = true;
-		block_sequence[*num_steps].params.fams2_global_control_lock_fast_params.is_required = dc_state_is_fams2_in_use(dc, context);
-		block_sequence[*num_steps].func = DMUB_FAMS2_GLOBAL_CONTROL_LOCK_FAST;
+	if (dc->hwss.dmub_hw_control_lock_fast) {
+		block_sequence[*num_steps].params.dmub_hw_control_lock_fast_params.dc = dc;
+		block_sequence[*num_steps].params.dmub_hw_control_lock_fast_params.lock = true;
+		block_sequence[*num_steps].params.dmub_hw_control_lock_fast_params.is_required = dc_state_is_fams2_in_use(dc, context);
+		block_sequence[*num_steps].func = DMUB_HW_CONTROL_LOCK_FAST;
 		(*num_steps)++;
 	}
 	if (dc->hwss.pipe_control_lock) {
@@ -903,11 +903,11 @@ void hwss_build_fast_sequence(struct dc *dc,
 		block_sequence[*num_steps].func = DMUB_SUBVP_PIPE_CONTROL_LOCK_FAST;
 		(*num_steps)++;
 	}
-	if (dc->hwss.fams2_global_control_lock_fast) {
-		block_sequence[*num_steps].params.fams2_global_control_lock_fast_params.dc = dc;
-		block_sequence[*num_steps].params.fams2_global_control_lock_fast_params.lock = false;
-		block_sequence[*num_steps].params.fams2_global_control_lock_fast_params.is_required = dc_state_is_fams2_in_use(dc, context);
-		block_sequence[*num_steps].func = DMUB_FAMS2_GLOBAL_CONTROL_LOCK_FAST;
+	if (dc->hwss.dmub_hw_control_lock_fast) {
+		block_sequence[*num_steps].params.dmub_hw_control_lock_fast_params.dc = dc;
+		block_sequence[*num_steps].params.dmub_hw_control_lock_fast_params.lock = false;
+		block_sequence[*num_steps].params.dmub_hw_control_lock_fast_params.is_required = dc_state_is_fams2_in_use(dc, context);
+		block_sequence[*num_steps].func = DMUB_HW_CONTROL_LOCK_FAST;
 		(*num_steps)++;
 	}
 
@@ -1010,8 +1010,8 @@ void hwss_execute_sequence(struct dc *dc,
 					params->wait_for_dcc_meta_propagation_params.dc,
 					params->wait_for_dcc_meta_propagation_params.top_pipe_to_program);
 			break;
-		case DMUB_FAMS2_GLOBAL_CONTROL_LOCK_FAST:
-			dc->hwss.fams2_global_control_lock_fast(params);
+		case DMUB_HW_CONTROL_LOCK_FAST:
+			dc->hwss.dmub_hw_control_lock_fast(params);
 			break;
 		default:
 			ASSERT(false);
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index 914c30a42ecfa..074cea5aacfeb 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -1418,9 +1418,9 @@ void dcn401_prepare_bandwidth(struct dc *dc,
 	}
 
 	if (dc->debug.fams2_config.bits.enable) {
-		dcn401_fams2_global_control_lock(dc, context, true);
+		dcn401_dmub_hw_control_lock(dc, context, true);
 		dcn401_fams2_update_config(dc, context, false);
-		dcn401_fams2_global_control_lock(dc, context, false);
+		dcn401_dmub_hw_control_lock(dc, context, false);
 	}
 
 	if (p_state_change_support != context->bw_ctx.bw.dcn.clk.p_state_change_support) {
@@ -1439,9 +1439,9 @@ void dcn401_optimize_bandwidth(
 
 	/* enable fams2 if needed */
 	if (dc->debug.fams2_config.bits.enable) {
-		dcn401_fams2_global_control_lock(dc, context, true);
+		dcn401_dmub_hw_control_lock(dc, context, true);
 		dcn401_fams2_update_config(dc, context, true);
-		dcn401_fams2_global_control_lock(dc, context, false);
+		dcn401_dmub_hw_control_lock(dc, context, false);
 	}
 
 	/* program dchubbub watermarks */
@@ -1480,7 +1480,7 @@ void dcn401_optimize_bandwidth(
 	}
 }
 
-void dcn401_fams2_global_control_lock(struct dc *dc,
+void dcn401_dmub_hw_control_lock(struct dc *dc,
 		struct dc_state *context,
 		bool lock)
 {
@@ -1497,12 +1497,12 @@ void dcn401_fams2_global_control_lock(struct dc *dc,
 	dmub_hw_lock_mgr_inbox0_cmd(dc->ctx->dmub_srv, hw_lock_cmd);
 }
 
-void dcn401_fams2_global_control_lock_fast(union block_sequence_params *params)
+void dcn401_dmub_hw_control_lock_fast(union block_sequence_params *params)
 {
-	struct dc *dc = params->fams2_global_control_lock_fast_params.dc;
-	bool lock = params->fams2_global_control_lock_fast_params.lock;
+	struct dc *dc = params->dmub_hw_control_lock_fast_params.dc;
+	bool lock = params->dmub_hw_control_lock_fast_params.lock;
 
-	if (params->fams2_global_control_lock_fast_params.is_required) {
+	if (params->dmub_hw_control_lock_fast_params.is_required) {
 		union dmub_inbox0_cmd_lock_hw hw_lock_cmd = { 0 };
 
 		hw_lock_cmd.bits.command_code = DMUB_INBOX0_CMD__HW_LOCK;
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.h b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.h
index 2621b7725267e..9591657d8eee3 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.h
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.h
@@ -73,11 +73,11 @@ void dcn401_optimize_bandwidth(
 		struct dc *dc,
 		struct dc_state *context);
 
-void dcn401_fams2_global_control_lock(struct dc *dc,
+void dcn401_dmub_hw_control_lock(struct dc *dc,
 		struct dc_state *context,
 		bool lock);
 void dcn401_fams2_update_config(struct dc *dc, struct dc_state *context, bool enable);
-void dcn401_fams2_global_control_lock_fast(union block_sequence_params *params);
+void dcn401_dmub_hw_control_lock_fast(union block_sequence_params *params);
 void dcn401_unblank_stream(struct pipe_ctx *pipe_ctx, struct dc_link_settings *link_settings);
 void dcn401_hardware_release(struct dc *dc);
 void dcn401_update_odm(struct dc *dc, struct dc_state *context,
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_init.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_init.c
index d6e11b7e4fcef..a221b8cb6d4dd 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_init.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_init.c
@@ -95,9 +95,9 @@ static const struct hw_sequencer_funcs dcn401_funcs = {
 	.apply_update_flags_for_phantom = dcn32_apply_update_flags_for_phantom,
 	.wait_for_dcc_meta_propagation = dcn401_wait_for_dcc_meta_propagation,
 	.is_pipe_topology_transition_seamless = dcn32_is_pipe_topology_transition_seamless,
-	.fams2_global_control_lock = dcn401_fams2_global_control_lock,
+	.dmub_hw_control_lock = dcn401_dmub_hw_control_lock,
 	.fams2_update_config = dcn401_fams2_update_config,
-	.fams2_global_control_lock_fast = dcn401_fams2_global_control_lock_fast,
+	.dmub_hw_control_lock_fast = dcn401_dmub_hw_control_lock_fast,
 	.program_outstanding_updates = dcn401_program_outstanding_updates,
 	.wait_for_all_pending_updates = dcn30_wait_for_all_pending_updates,
 	.detect_pipe_changes = dcn401_detect_pipe_changes,
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h
index 1723bbcf2c46a..619ac4dfff078 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h
@@ -148,7 +148,7 @@ struct wait_for_dcc_meta_propagation_params {
 	const struct pipe_ctx *top_pipe_to_program;
 };
 
-struct fams2_global_control_lock_fast_params {
+struct dmub_hw_control_lock_fast_params {
 	struct dc *dc;
 	bool is_required;
 	bool lock;
@@ -173,7 +173,7 @@ union block_sequence_params {
 	struct set_ocsc_default_params set_ocsc_default_params;
 	struct subvp_save_surf_addr subvp_save_surf_addr;
 	struct wait_for_dcc_meta_propagation_params wait_for_dcc_meta_propagation_params;
-	struct fams2_global_control_lock_fast_params fams2_global_control_lock_fast_params;
+	struct dmub_hw_control_lock_fast_params dmub_hw_control_lock_fast_params;
 };
 
 enum block_sequence_func {
@@ -195,7 +195,7 @@ enum block_sequence_func {
 	MPC_SET_OCSC_DEFAULT,
 	DMUB_SUBVP_SAVE_SURF_ADDR,
 	HUBP_WAIT_FOR_DCC_META_PROP,
-	DMUB_FAMS2_GLOBAL_CONTROL_LOCK_FAST,
+	DMUB_HW_CONTROL_LOCK_FAST,
 	/* This must be the last value in this enum, add new ones above */
 	HWSS_BLOCK_SEQUENCE_FUNC_COUNT
 };
@@ -452,13 +452,13 @@ struct hw_sequencer_funcs {
 			const struct dc_state *new_ctx);
 	void (*wait_for_dcc_meta_propagation)(const struct dc *dc,
 		const struct pipe_ctx *top_pipe_to_program);
-	void (*fams2_global_control_lock)(struct dc *dc,
+	void (*dmub_hw_control_lock)(struct dc *dc,
 			struct dc_state *context,
 			bool lock);
 	void (*fams2_update_config)(struct dc *dc,
 			struct dc_state *context,
 			bool enable);
-	void (*fams2_global_control_lock_fast)(union block_sequence_params *params);
+	void (*dmub_hw_control_lock_fast)(union block_sequence_params *params);
 	void (*set_long_vtotal)(struct pipe_ctx **pipe_ctx, int num_pipes, uint32_t v_total_min, uint32_t v_total_max);
 	void (*program_outstanding_updates)(struct dc *dc,
 			struct dc_state *context);
-- 
2.53.0



