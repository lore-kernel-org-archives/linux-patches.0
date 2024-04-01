Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097C6446AC;
	Mon,  1 Apr 2024 15:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987191; cv=none; b=BJkoiQqUGZILU4t9flXANiycD1WQPuqhx70sRg9CP9U6He+HLcDPATwFBG7UMarTX5LMoOkpX7x/CqoZo+4eRxTUKHkmrWb5Uq/BDe4OWTdW+7Ky/gY+2W5zF1S8B0Ju+4iV9VW/uGdR6J12ve3/mMEfBWhpfXEzd4SIPtqVUMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987191; c=relaxed/simple;
	bh=SxlBJ0/qoWt/Nzq5BRcEc1KsyIRySIHVSuoelUyhsng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUDuLy+Q27sVcD2vHn2WyZ2PO2luesdgumlESA0+hJSQH0WTHrX8GoeOsArgkC7s5+aWPPSbyyAS/pltHnmqA/rEqK4qV/TsTB6zZ8xfrwa0R8bvlWhZkJEPIaddfq+UdgzcqB4qSnfSSt9y6LWmtDrcJea3uH+xMVUxl6CyGXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAtRu4E0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAtRu4E0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC14C433F1;
	Mon,  1 Apr 2024 15:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987190;
	bh=SxlBJ0/qoWt/Nzq5BRcEc1KsyIRySIHVSuoelUyhsng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAtRu4E0cgKsw4UFIbQ/lne6NuwyukDHlLgyGtYykJfpi71T2TpqmuiDkgRvwooG1
	 vA6rhwWVl0GhsFaWCvBtPW0i0sYZOX+JNr7AzCbAMKas55ZfvEpqhOdEsiQJ2Sa6B9
	 kjH278xihKdMR+eKadSm6aosD3iM1LohtiK+G/fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 212/399] drm/amd/display: Update odm when ODM combine is changed on an otg master pipe with no plane
Date: Mon,  1 Apr 2024 17:42:58 +0200
Message-ID: <20240401152555.512811570@linuxfoundation.org>
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

[ Upstream commit 86e9523fb0efce27095d3086473c739cce720d01 ]

[WHY]
When committing an update with ODM combine change when the plane is
removing or already removed, we fail to detect odm change in pipe
update flags. This has caused mismatch between new dc state and the
actual hardware state, because we missed odm programming.

[HOW]
- Detect odm change even for otg master pipe without a plane.
- Update odm config before calling program pipes for pipe with planes.

The commit also updates blank pattern programming when odm is changed
without plane. This is because number of OPP is changed when ODM
combine is changed. Blank pattern is per OPP so we will need to
reprogram OPP based on the new pipe topology.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Wenjing Liu <wenjing.liu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/hwss/dcn20/dcn20_hwseq.c   | 41 ++++++++++---------
 .../amd/display/dc/hwss/dcn32/dcn32_hwseq.c   |  7 ++++
 2 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index 931ac8ed7069d..eb0480aee859d 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -1392,6 +1392,11 @@ static void dcn20_detect_pipe_changes(struct dc_state *old_state,
 		return;
 	}
 
+	if (resource_is_pipe_type(new_pipe, OTG_MASTER) &&
+			resource_is_odm_topology_changed(new_pipe, old_pipe))
+		/* Detect odm changes */
+		new_pipe->update_flags.bits.odm = 1;
+
 	/* Exit on unchanged, unused pipe */
 	if (!old_pipe->plane_state && !new_pipe->plane_state)
 		return;
@@ -1445,10 +1450,6 @@ static void dcn20_detect_pipe_changes(struct dc_state *old_state,
 
 	/* Detect top pipe only changes */
 	if (resource_is_pipe_type(new_pipe, OTG_MASTER)) {
-		/* Detect odm changes */
-		if (resource_is_odm_topology_changed(new_pipe, old_pipe))
-			new_pipe->update_flags.bits.odm = 1;
-
 		/* Detect global sync changes */
 		if (old_pipe->pipe_dlg_param.vready_offset != new_pipe->pipe_dlg_param.vready_offset
 				|| old_pipe->pipe_dlg_param.vstartup_start != new_pipe->pipe_dlg_param.vstartup_start
@@ -1891,19 +1892,20 @@ void dcn20_program_front_end_for_ctx(
 	DC_LOGGER_INIT(dc->ctx->logger);
 	unsigned int prev_hubp_count = 0;
 	unsigned int hubp_count = 0;
+	struct pipe_ctx *pipe;
 
 	if (resource_is_pipe_topology_changed(dc->current_state, context))
 		resource_log_pipe_topology_update(dc, context);
 
 	if (dc->hwss.program_triplebuffer != NULL && dc->debug.enable_tri_buf) {
 		for (i = 0; i < dc->res_pool->pipe_count; i++) {
-			struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i];
+			pipe = &context->res_ctx.pipe_ctx[i];
 
-			if (!pipe_ctx->top_pipe && !pipe_ctx->prev_odm_pipe && pipe_ctx->plane_state) {
-				ASSERT(!pipe_ctx->plane_state->triplebuffer_flips);
+			if (!pipe->top_pipe && !pipe->prev_odm_pipe && pipe->plane_state) {
+				ASSERT(!pipe->plane_state->triplebuffer_flips);
 				/*turn off triple buffer for full update*/
 				dc->hwss.program_triplebuffer(
-						dc, pipe_ctx, pipe_ctx->plane_state->triplebuffer_flips);
+						dc, pipe, pipe->plane_state->triplebuffer_flips);
 			}
 		}
 	}
@@ -1978,12 +1980,22 @@ void dcn20_program_front_end_for_ctx(
 			DC_LOG_DC("Reset mpcc for pipe %d\n", dc->current_state->res_ctx.pipe_ctx[i].pipe_idx);
 		}
 
+	/* update ODM for blanked OTG master pipes */
+	for (i = 0; i < dc->res_pool->pipe_count; i++) {
+		pipe = &context->res_ctx.pipe_ctx[i];
+		if (resource_is_pipe_type(pipe, OTG_MASTER) &&
+				!resource_is_pipe_type(pipe, DPP_PIPE) &&
+				pipe->update_flags.bits.odm &&
+				hws->funcs.update_odm)
+			hws->funcs.update_odm(dc, context, pipe);
+	}
+
 	/*
 	 * Program all updated pipes, order matters for mpcc setup. Start with
 	 * top pipe and program all pipes that follow in order
 	 */
 	for (i = 0; i < dc->res_pool->pipe_count; i++) {
-		struct pipe_ctx *pipe = &context->res_ctx.pipe_ctx[i];
+		pipe = &context->res_ctx.pipe_ctx[i];
 
 		if (pipe->plane_state && !pipe->top_pipe) {
 			while (pipe) {
@@ -2022,17 +2034,6 @@ void dcn20_program_front_end_for_ctx(
 			context->stream_status[0].plane_count > 1) {
 			pipe->plane_res.hubp->funcs->hubp_wait_pipe_read_start(pipe->plane_res.hubp);
 		}
-
-		/* when dynamic ODM is active, pipes must be reconfigured when all planes are
-		 * disabled, as some transitions will leave software and hardware state
-		 * mismatched.
-		 */
-		if (dc->debug.enable_single_display_2to1_odm_policy &&
-			pipe->stream &&
-			pipe->update_flags.bits.disable &&
-			!pipe->prev_odm_pipe &&
-			hws->funcs.update_odm)
-			hws->funcs.update_odm(dc, context, pipe);
 	}
 }
 
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
index aa36d7a56ca8c..b890db0bfc46b 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
@@ -1156,6 +1156,13 @@ void dcn32_update_odm(struct dc *dc, struct dc_state *context, struct pipe_ctx *
 			dsc->funcs->dsc_disconnect(dsc);
 		}
 	}
+
+	if (!resource_is_pipe_type(pipe_ctx, DPP_PIPE))
+		/*
+		 * blank pattern is generated by OPP, reprogram blank pattern
+		 * due to OPP count change
+		 */
+		dc->hwseq->funcs.blank_pixel_data(dc, pipe_ctx, true);
 }
 
 unsigned int dcn32_calculate_dccg_k1_k2_values(struct pipe_ctx *pipe_ctx, unsigned int *k1_div, unsigned int *k2_div)
-- 
2.43.0



