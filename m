Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F74AD512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AB2C433D2;
	Mon, 12 Jun 2023 10:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566943;
	bh=95LNQWjUAcowZhyDsy24EH+Ps2LqUdJJ0WYqyDR+H4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agpv0oqQR9k0t+0Jj4xugfw+2Fx2hTraJSLkHWgsecO3ADZiuL6cpudoCqUGAhl3l
	 OvZ+jh+h3KzR0zimH0WFEiBJLSI9VvoVz7dmOIXx2619KUg6qOBWG9gG/VhgXUnRDR
	 8jEoVOftdm1f6ZA1zLs7lTGLlrVl/bma2ux0Bdmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Stylon Wang <stylon.wang@amd.com>,
	Samson Tam <samson.tam@amd.com>,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.3 091/160] drm/amd/display: add ODM case when looking for first split pipe
Date: Mon, 12 Jun 2023 12:27:03 +0200
Message-ID: <20230612101719.182771813@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Samson Tam <samson.tam@amd.com>

commit 59de751e3845d699e02dc4da47322b92d83a41e2 upstream.

[Why]
When going from ODM 2:1 single display case to max displays, second
odm pipe needs to be repurposed for one of the new single displays.
However, acquire_first_split_pipe() only handles MPC case and not
ODM case

[How]
Add ODM conditions in acquire_first_split_pipe()
Add commit_minimal_transition_state() in commit_streams() to handle
odm 2:1 exit first, and then process new streams
Handle ODM condition in commit_minimal_transition_state()

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Acked-by: Stylon Wang <stylon.wang@amd.com>
Signed-off-by: Samson Tam <samson.tam@amd.com>
Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c          |   36 +++++++++++++++++++++-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c |   20 ++++++++++++
 2 files changed, 55 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1962,6 +1962,9 @@ static enum dc_status dc_commit_state_no
 	return result;
 }
 
+static bool commit_minimal_transition_state(struct dc *dc,
+		struct dc_state *transition_base_context);
+
 /**
  * dc_commit_streams - Commit current stream state
  *
@@ -1983,6 +1986,8 @@ enum dc_status dc_commit_streams(struct
 	struct dc_state *context;
 	enum dc_status res = DC_OK;
 	struct dc_validation_set set[MAX_STREAMS] = {0};
+	struct pipe_ctx *pipe;
+	bool handle_exit_odm2to1 = false;
 
 	if (dc->ctx->dce_environment == DCE_ENV_VIRTUAL_HW)
 		return res;
@@ -2007,6 +2012,22 @@ enum dc_status dc_commit_streams(struct
 		}
 	}
 
+	/* Check for case where we are going from odm 2:1 to max
+	 *  pipe scenario.  For these cases, we will call
+	 *  commit_minimal_transition_state() to exit out of odm 2:1
+	 *  first before processing new streams
+	 */
+	if (stream_count == dc->res_pool->pipe_count) {
+		for (i = 0; i < dc->res_pool->pipe_count; i++) {
+			pipe = &dc->current_state->res_ctx.pipe_ctx[i];
+			if (pipe->next_odm_pipe)
+				handle_exit_odm2to1 = true;
+		}
+	}
+
+	if (handle_exit_odm2to1)
+		res = commit_minimal_transition_state(dc, dc->current_state);
+
 	context = dc_create_state(dc);
 	if (!context)
 		goto context_alloc_fail;
@@ -3915,6 +3936,7 @@ static bool commit_minimal_transition_st
 	unsigned int i, j;
 	unsigned int pipe_in_use = 0;
 	bool subvp_in_use = false;
+	bool odm_in_use = false;
 
 	if (!transition_context)
 		return false;
@@ -3943,6 +3965,18 @@ static bool commit_minimal_transition_st
 		}
 	}
 
+	/* If ODM is enabled and we are adding or removing planes from any ODM
+	 * pipe, we must use the minimal transition.
+	 */
+	for (i = 0; i < dc->res_pool->pipe_count; i++) {
+		struct pipe_ctx *pipe = &dc->current_state->res_ctx.pipe_ctx[i];
+
+		if (pipe->stream && pipe->next_odm_pipe) {
+			odm_in_use = true;
+			break;
+		}
+	}
+
 	/* When the OS add a new surface if we have been used all of pipes with odm combine
 	 * and mpc split feature, it need use commit_minimal_transition_state to transition safely.
 	 * After OS exit MPO, it will back to use odm and mpc split with all of pipes, we need
@@ -3951,7 +3985,7 @@ static bool commit_minimal_transition_st
 	 * Reduce the scenarios to use dc_commit_state_no_check in the stage of flip. Especially
 	 * enter/exit MPO when DCN still have enough resources.
 	 */
-	if (pipe_in_use != dc->res_pool->pipe_count && !subvp_in_use) {
+	if (pipe_in_use != dc->res_pool->pipe_count && !subvp_in_use && !odm_in_use) {
 		dc_release_state(transition_context);
 		return true;
 	}
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1446,6 +1446,26 @@ static int acquire_first_split_pipe(
 
 			split_pipe->stream = stream;
 			return i;
+		} else if (split_pipe->prev_odm_pipe &&
+				split_pipe->prev_odm_pipe->plane_state == split_pipe->plane_state) {
+			split_pipe->prev_odm_pipe->next_odm_pipe = split_pipe->next_odm_pipe;
+			if (split_pipe->next_odm_pipe)
+				split_pipe->next_odm_pipe->prev_odm_pipe = split_pipe->prev_odm_pipe;
+
+			if (split_pipe->prev_odm_pipe->plane_state)
+				resource_build_scaling_params(split_pipe->prev_odm_pipe);
+
+			memset(split_pipe, 0, sizeof(*split_pipe));
+			split_pipe->stream_res.tg = pool->timing_generators[i];
+			split_pipe->plane_res.hubp = pool->hubps[i];
+			split_pipe->plane_res.ipp = pool->ipps[i];
+			split_pipe->plane_res.dpp = pool->dpps[i];
+			split_pipe->stream_res.opp = pool->opps[i];
+			split_pipe->plane_res.mpcc_inst = pool->dpps[i]->inst;
+			split_pipe->pipe_idx = i;
+
+			split_pipe->stream = stream;
+			return i;
 		}
 	}
 	return -1;


