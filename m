Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2881010E0;
	Fri,  6 Dec 2024 14:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496414; cv=none; b=nbXUQ63VCEzTOrM1yP2nPysNQ9/LqqTAuYWltWBIUTLBuWvS63OaxUUNnSHHABJKUzmUevBieSRReeoaYaSewvVBSEwGSP7BPesJewbJ2z4r/M0T1p15xMbwvDDdaoU5YPzZhBiVqvJ+6mpr+MrG/MI+BrOKlVsIQofdXYuMyIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496414; c=relaxed/simple;
	bh=eTdSaf2Sak3S8tzvxzOgIrr85p5kAMMtLJm/Vjl7V+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4ijy6xCjQQyfpaoUeW8LHfqu00Upc7nTCI08ZVsU2tgYKfw5eGCBMqhhd11sczo5pSRAfmaVPTzZL8zDViewOMuqaw4VUrFQ+SX7n430varZxe8X0cSdXXvvH8Cu7rCBgKpSRD1UreILurgsTpHiURv4c0FsoJd25U6d7SFkZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JB2rsP2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JB2rsP2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86767C4CED1;
	Fri,  6 Dec 2024 14:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496414;
	bh=eTdSaf2Sak3S8tzvxzOgIrr85p5kAMMtLJm/Vjl7V+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JB2rsP2K4hOHmydvKBWiGUFbB61iXNnKFy0a8CLYQaNwTdvkRq+i05Znmy1TCWa4p
	 h9Qxg/pj3cvsXhukcyjLzIkrEB0wjkRC2TCxeXIGH+3VEEf84f6kD6bJx0wDZAGJiT
	 MIIUkD+fRvClyjAXWc5eVGgcD6xB9Ix8/lPdTHhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Yihan Zhu <Yihan.Zhu@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 144/146] drm/amd/display: update pipe selection policy to check head pipe
Date: Fri,  6 Dec 2024 15:37:55 +0100
Message-ID: <20241206143533.196263972@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihan Zhu <Yihan.Zhu@amd.com>

commit 8fef253c94a5312b9150b2ff8e633b331bac7e88 upstream.

[Why]
No check on head pipe during the dml to dc hw mapping will allow illegal
pipe usage. This will result in a wrong pipe topology to cause mpcc tree
totally mess up then cause a display hang.

[How]
Avoid to use the pipe is head in all check and avoid ODM slice during
preferred pipe check.

Cc: stable@vger.kernel.org
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Yihan Zhu <Yihan.Zhu@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml2_dc_resource_mgmt.c |   23 +++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_dc_resource_mgmt.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_dc_resource_mgmt.c
@@ -258,12 +258,25 @@ static unsigned int find_preferred_pipe_
 	 * However this condition comes with a caveat. We need to ignore pipes that will
 	 * require a change in OPP but still have the same stream id. For example during
 	 * an MPC to ODM transiton.
+	 *
+	 * Adding check to avoid pipe select on the head pipe by utilizing dc resource
+	 * helper function resource_get_primary_dpp_pipe and comparing the pipe index.
 	 */
 	if (existing_state) {
 		for (i = 0; i < pipe_count; i++) {
 			if (existing_state->res_ctx.pipe_ctx[i].stream && existing_state->res_ctx.pipe_ctx[i].stream->stream_id == stream_id) {
+				struct pipe_ctx *head_pipe =
+					resource_is_pipe_type(&existing_state->res_ctx.pipe_ctx[i], DPP_PIPE) ?
+						resource_get_primary_dpp_pipe(&existing_state->res_ctx.pipe_ctx[i]) :
+							NULL;
+
+				// we should always respect the head pipe from selection
+				if (head_pipe && head_pipe->pipe_idx == i)
+					continue;
 				if (existing_state->res_ctx.pipe_ctx[i].plane_res.hubp &&
-					existing_state->res_ctx.pipe_ctx[i].plane_res.hubp->opp_id != i)
+					existing_state->res_ctx.pipe_ctx[i].plane_res.hubp->opp_id != i &&
+						(existing_state->res_ctx.pipe_ctx[i].prev_odm_pipe ||
+						existing_state->res_ctx.pipe_ctx[i].next_odm_pipe))
 					continue;
 
 				preferred_pipe_candidates[num_preferred_candidates++] = i;
@@ -292,6 +305,14 @@ static unsigned int find_last_resort_pip
 	 */
 	if (existing_state) {
 		for (i  = 0; i < pipe_count; i++) {
+			struct pipe_ctx *head_pipe =
+				resource_is_pipe_type(&existing_state->res_ctx.pipe_ctx[i], DPP_PIPE) ?
+					resource_get_primary_dpp_pipe(&existing_state->res_ctx.pipe_ctx[i]) :
+						NULL;
+
+			// we should always respect the head pipe from selection
+			if (head_pipe && head_pipe->pipe_idx == i)
+				continue;
 			if ((existing_state->res_ctx.pipe_ctx[i].plane_res.hubp &&
 				existing_state->res_ctx.pipe_ctx[i].plane_res.hubp->opp_id != i) ||
 				existing_state->res_ctx.pipe_ctx[i].stream_res.tg)


