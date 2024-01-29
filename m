Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2FE15FB01;
	Mon, 29 Jan 2024 17:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548290; cv=none; b=tGxRqVdickPWI86JiKrVmfRdxdaGw/N1Z86xcP0+tgKlph6rKOnpcHtdlhFoI/jOTckkZmWTpQPDiGsMVMyW3owp+dcU+tsqp4UjP6pWppDiEA309MKZ9lCoM6W+DnYBBi++Fni0CSKzFnb387lapTIK2IDNABl+t4UyNSqFPrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548290; c=relaxed/simple;
	bh=awA2mJlBXok56fs7e+XgK3H8KrDU0i/Lw0Ae3j0YfE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBwsPdFwiQ7UTQIBAQbgqJeLW983CR08swI++afzosDwbcuhJt4CZ4m0oc1oN8pSvCrRy0TcQ6gp4IrUh0S4bvYZ+oO7iXrWS87eVJH0azwZu99osC++wbliuF1Qy26Q8p+ePSt3RjC8VZZ9p+QJ4gAAEzkew64bdOcWXd4wLZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bElnlC5t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bElnlC5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D725EC43394;
	Mon, 29 Jan 2024 17:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548289;
	bh=awA2mJlBXok56fs7e+XgK3H8KrDU0i/Lw0Ae3j0YfE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bElnlC5tYvj4+RTogWGw49d3nBMkxE8ofyxvnmRqhsJVz6TLKpQo6qs/b/AVRMZ/r
	 3mS0foDGoV6Hzi6DD/cRWrDk85QvEzkKgWTAvPfKr2//PcThyhgKvqMtzQC83qW1w4
	 HXUAGN6sDwXgGrd+WuMyr4ek5UJvxuUHdySj7fqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sung joon Kim <sungjoon.kim@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 300/346] drm/amd/display: Add logging resource checks
Date: Mon, 29 Jan 2024 09:05:31 -0800
Message-ID: <20240129170025.245874161@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

From: Charlene Liu <charlene.liu@amd.com>

[ Upstream commit 8a51cc097dd590a86e8eec5398934ef389ff9a7b ]

[Why]
When mapping resources, resources could be unavailable.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Sung joon Kim <sungjoon.kim@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Charlene Liu <charlene.liu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c          | 4 +++-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 7 ++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index c535ddb45a36..bc098098345c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3626,7 +3626,7 @@ static void commit_planes_for_stream(struct dc *dc,
 	top_pipe_to_program = resource_get_otg_master_for_stream(
 				&context->res_ctx,
 				stream);
-
+	ASSERT(top_pipe_to_program != NULL);
 	for (i = 0; i < dc->res_pool->pipe_count; i++) {
 		struct pipe_ctx *old_pipe = &dc->current_state->res_ctx.pipe_ctx[i];
 
@@ -4457,6 +4457,8 @@ static bool should_commit_minimal_transition_for_windowed_mpo_odm(struct dc *dc,
 
 	cur_pipe = resource_get_otg_master_for_stream(&dc->current_state->res_ctx, stream);
 	new_pipe = resource_get_otg_master_for_stream(&context->res_ctx, stream);
+	if (!cur_pipe || !new_pipe)
+		return false;
 	cur_is_odm_in_use = resource_get_odm_slice_count(cur_pipe) > 1;
 	new_is_odm_in_use = resource_get_odm_slice_count(new_pipe) > 1;
 	if (cur_is_odm_in_use == new_is_odm_in_use)
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index e4bb1e25ee3b..ae275f1780d5 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -2170,6 +2170,10 @@ void resource_log_pipe_topology_update(struct dc *dc, struct dc_state *state)
 	for (stream_idx = 0; stream_idx < state->stream_count; stream_idx++) {
 		otg_master = resource_get_otg_master_for_stream(
 				&state->res_ctx, state->streams[stream_idx]);
+		if (!otg_master	|| otg_master->stream_res.tg == NULL) {
+			DC_LOG_DC("topology update: otg_master NULL stream_idx %d!\n", stream_idx);
+			return;
+		}
 		slice_count = resource_get_opp_heads_for_otg_master(otg_master,
 				&state->res_ctx, opp_heads);
 		for (slice_idx = 0; slice_idx < slice_count; slice_idx++) {
@@ -2990,7 +2994,8 @@ bool dc_add_plane_to_context(
 
 	otg_master_pipe = resource_get_otg_master_for_stream(
 			&context->res_ctx, stream);
-	added = resource_append_dpp_pipes_for_plane_composition(context,
+	if (otg_master_pipe)
+		added = resource_append_dpp_pipes_for_plane_composition(context,
 			dc->current_state, pool, otg_master_pipe, plane_state);
 
 	if (added) {
-- 
2.43.0



