Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894721F955
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0605DC433CA;
	Tue,  1 Aug 2023 09:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882253;
	bh=La6xybk4y1y3c9oVbfgpNQSQ9WSokpYnLRVxGTNbh48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k3j935M7aZiPO/98kJ9gdhFisUUsNKZWZQ39xBeS3Rfxov7TKFkpBjoMmiQD45N9j
	 DExN1HCdEOaxtcdlpl4zXaoGv337Ksu+EaGAzf2ZFzbHYYUhICMaqdxy7zpPTNK5KT
	 VZycxLJXmi069f4snuPMHvcHyGfUsXRcTPVqFkU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Lei <Jun.Lei@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/228] drm/amd/display: Use min transition for all SubVP plane add/remove
Date: Tue,  1 Aug 2023 11:18:17 +0200
Message-ID: <20230801091924.301875218@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alvin Lee <Alvin.Lee2@amd.com>

[ Upstream commit e4c1b01bc35b04e15782608165aa85b9e1724f7b ]

[Description]
- Whenever disabling a phantom pipe, we must run through the
  minimal transition sequence
- In the case where SetVisibility = false for the main pipe,
  we also need to run through the min transtion when disabling
  the phantom pipes

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 59de751e3845 ("drm/amd/display: add ODM case when looking for first split pipe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 31 +++++++++++++++++-------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index cbbad496cfc63..c429748c86cdb 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3731,17 +3731,17 @@ static bool could_mpcc_tree_change_for_active_pipes(struct dc *dc,
 		}
 	}
 
-	/* For SubVP when adding MPO video we need to add a minimal transition.
+	/* For SubVP when adding or removing planes we need to add a minimal transition
+	 * (even when disabling all planes). Whenever disabling a phantom pipe, we
+	 * must use the minimal transition path to disable the pipe correctly.
 	 */
 	if (cur_stream_status && stream->mall_stream_config.type == SUBVP_MAIN) {
 		/* determine if minimal transition is required due to SubVP*/
-		if (surface_count > 0) {
-			if (cur_stream_status->plane_count > surface_count) {
-				force_minimal_pipe_splitting = true;
-			} else if (cur_stream_status->plane_count < surface_count) {
-				force_minimal_pipe_splitting = true;
-				*is_plane_addition = true;
-			}
+		if (cur_stream_status->plane_count > surface_count) {
+			force_minimal_pipe_splitting = true;
+		} else if (cur_stream_status->plane_count < surface_count) {
+			force_minimal_pipe_splitting = true;
+			*is_plane_addition = true;
 		}
 	}
 
@@ -3758,6 +3758,7 @@ static bool commit_minimal_transition_state(struct dc *dc,
 	enum dc_status ret = DC_ERROR_UNEXPECTED;
 	unsigned int i, j;
 	unsigned int pipe_in_use = 0;
+	bool subvp_in_use = false;
 
 	if (!transition_context)
 		return false;
@@ -3770,6 +3771,18 @@ static bool commit_minimal_transition_state(struct dc *dc,
 			pipe_in_use++;
 	}
 
+	/* If SubVP is enabled and we are adding or removing planes from any main subvp
+	 * pipe, we must use the minimal transition.
+	 */
+	for (i = 0; i < dc->res_pool->pipe_count; i++) {
+		struct pipe_ctx *pipe = &dc->current_state->res_ctx.pipe_ctx[i];
+
+		if (pipe->stream && pipe->stream->mall_stream_config.type == SUBVP_PHANTOM) {
+			subvp_in_use = true;
+			break;
+		}
+	}
+
 	/* When the OS add a new surface if we have been used all of pipes with odm combine
 	 * and mpc split feature, it need use commit_minimal_transition_state to transition safely.
 	 * After OS exit MPO, it will back to use odm and mpc split with all of pipes, we need
@@ -3778,7 +3791,7 @@ static bool commit_minimal_transition_state(struct dc *dc,
 	 * Reduce the scenarios to use dc_commit_state_no_check in the stage of flip. Especially
 	 * enter/exit MPO when DCN still have enough resources.
 	 */
-	if (pipe_in_use != dc->res_pool->pipe_count) {
+	if (pipe_in_use != dc->res_pool->pipe_count && !subvp_in_use) {
 		dc_release_state(transition_context);
 		return true;
 	}
-- 
2.39.2



