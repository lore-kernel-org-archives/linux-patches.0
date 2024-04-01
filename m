Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04C9C129;
	Mon,  1 Apr 2024 16:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988525; cv=none; b=Hr4/s5hFpnW672wzO6nKi2PxqRt8Tb/Bbdf/C0lezuZzIVRCaJyYJ7mKqlv26l+KoAPqxXQXzd3iv5NN4eIVEtX+BNOioyATaklmMA64Cu251jky/5uMS/aSEgAESnbkXhcPSd8xe8lnAnQessWZZd3cmQD21i+DWYQa1e6WkvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988525; c=relaxed/simple;
	bh=TpDU4tJSLCpjo6iMCGnLS29hwSIzIgBEVGZgVRpEbrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tV6TlbBQXZK+aOD5F2LdoXeWLUJtQ9zt7Vl585RuJXXNkFeZHCbDJ7KmjV9PYkX2+VHU2CJ+Pfoa/V9DKknG2tXGY8U/02MyZhjqPrL+D+ZDLTgqQNFHv+YQbxCDIsaSzckHiToWIqeFDHPR1w6nAJLSje7/azAZ+f5rH8c0bzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mfPloYA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mfPloYA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C19C433F1;
	Mon,  1 Apr 2024 16:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988525;
	bh=TpDU4tJSLCpjo6iMCGnLS29hwSIzIgBEVGZgVRpEbrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mfPloYA+AOg8qwx9NqbphhqtMBSM4VyFYqXucI7i+226E5skU7Lr3YbJoQ2xXj4hK
	 8T5Zbnvdmtv7ooG9lPryhlEmVe3QeDJA9iBZI3JMFZ/g+gyAol0QydyBmTgv7qVBRI
	 o9q6yztmEcXJquDygtTluf6Yo3DbcVcyc5RTlMaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Relja Vojvodic <relja.vojvodic@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 211/432] drm/amd/display: Add ODM check during pipe split/merge validation
Date: Mon,  1 Apr 2024 17:43:18 +0200
Message-ID: <20240401152559.436601744@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Relja Vojvodic <relja.vojvodic@amd.com>

[ Upstream commit dd2c5fac91d46df9dc1bf025ef23eff4704bd85f ]

[why]
When querying DML for a vlevel after pipes have been split or merged the
ODM policy would revert to a default policy, which could cause the query
to use the incorrect ODM status. In this case ODM 2to1 was validated,
but the last DML query would assume no ODM and return the incorrect
vlevel.

[how]
Added ODM check to apply the correct ODM policy before querying DML.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Relja Vojvodic <relja.vojvodic@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 26fbcb3da77e ("drm/amd/display: Override min required DCFCLK in dml1_validate")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dcn32/dcn32_resource.h |  2 ++
 .../display/dc/dcn32/dcn32_resource_helpers.c | 26 +++++++++++++++++++
 .../drm/amd/display/dc/dml/dcn32/dcn32_fpu.c  |  3 +++
 3 files changed, 31 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
index b931008114c91..58943835fb638 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
@@ -183,6 +183,8 @@ bool dcn32_subvp_drr_admissable(struct dc *dc, struct dc_state *context);
 
 bool dcn32_subvp_vblank_admissable(struct dc *dc, struct dc_state *context, int vlevel);
 
+void dcn32_update_dml_pipes_odm_policy_based_on_context(struct dc *dc, struct dc_state *context, display_e2e_pipe_params_st *pipes);
+
 /* definitions for run time init of reg offsets */
 
 /* CLK SRC */
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
index bc5f0db23d0c3..c80d6485f6ffa 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
@@ -778,3 +778,29 @@ bool dcn32_subvp_vblank_admissable(struct dc *dc, struct dc_state *context, int
 
 	return result;
 }
+
+void dcn32_update_dml_pipes_odm_policy_based_on_context(struct dc *dc, struct dc_state *context,
+		display_e2e_pipe_params_st *pipes)
+{
+	int i, pipe_cnt;
+	struct resource_context *res_ctx = &context->res_ctx;
+	struct pipe_ctx *pipe = NULL;
+
+	for (i = 0, pipe_cnt = 0; i < dc->res_pool->pipe_count; i++) {
+		int odm_slice_count = 0;
+
+		if (!res_ctx->pipe_ctx[i].stream)
+			continue;
+		pipe = &res_ctx->pipe_ctx[i];
+		odm_slice_count = resource_get_odm_slice_count(pipe);
+
+		if (odm_slice_count == 1)
+			pipes[pipe_cnt].pipe.dest.odm_combine_policy = dm_odm_combine_policy_dal;
+		else if (odm_slice_count == 2)
+			pipes[pipe_cnt].pipe.dest.odm_combine_policy = dm_odm_combine_policy_2to1;
+		else if (odm_slice_count == 4)
+			pipes[pipe_cnt].pipe.dest.odm_combine_policy = dm_odm_combine_policy_4to1;
+
+		pipe_cnt++;
+	}
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index fe2b67d745f0d..5b6d9643b02dc 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -2178,6 +2178,7 @@ bool dcn32_internal_validate_bw(struct dc *dc,
 		int i;
 
 		pipe_cnt = dc->res_pool->funcs->populate_dml_pipes(dc, context, pipes, fast_validate);
+		dcn32_update_dml_pipes_odm_policy_based_on_context(dc, context, pipes);
 
 		/* repopulate_pipes = 1 means the pipes were either split or merged. In this case
 		 * we have to re-calculate the DET allocation and run through DML once more to
@@ -2186,7 +2187,9 @@ bool dcn32_internal_validate_bw(struct dc *dc,
 		 * */
 		context->bw_ctx.dml.soc.allow_for_pstate_or_stutter_in_vblank_final =
 					dm_prefetch_support_uclk_fclk_and_stutter_if_possible;
+
 		vlevel = dml_get_voltage_level(&context->bw_ctx.dml, pipes, pipe_cnt);
+
 		if (vlevel == context->bw_ctx.dml.soc.num_states) {
 			/* failed after DET size changes */
 			goto validate_fail;
-- 
2.43.0



