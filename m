Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FF2187328;
	Mon, 12 Aug 2024 16:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480130; cv=none; b=CF7OxF6J7qkfpS9XmpfabKLG0LQVZhjJv9VndwkOqFo7YNRaMuMFX4vc0EdAnkWiFuXqtb2hjIgCYVeay9MF5nmx/TH9h30l3w+xMVBJiW2uw198l27CrBPbawj4mr7P6d1LKsblBfRzmuKYd0mac9T9EXnI5lp7miExgEEnBSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480130; c=relaxed/simple;
	bh=YzY1nOOudOc526l1oU1QvFS9vAnizDNJbSRu41BWjGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAtd79xp32NHWEoKgnwgg1iIAppO7eSVkO/6oJc5nQOrMTrcQ8kA1mv69/QlYFB7Dl2RGXFgzcWZ0hxWlFBgA4gYIyeeDlI0ls76Gl+N/nfbpnxnzvjOrjGWmGzAwQeTSX3QWxTce8yENqT5yM/7RKNH4UjcgjRs4zpdb4TS1Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIToBXyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIToBXyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3E0C32782;
	Mon, 12 Aug 2024 16:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480130;
	bh=YzY1nOOudOc526l1oU1QvFS9vAnizDNJbSRu41BWjGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIToBXyU47UuvmBxozRFTOftu2MMMopJqImsO52/tgGTd1mKpLYxghYinSRZOJDAQ
	 c/gzRFkDmXVx6hgH5ABS6xz4J41Wljai7RFFzTcv74TFnjnrV4ph2PS4Cp263eO86m
	 waH5Kfqvt0/A/PVJX0WIe1uUfVxVWbpg1/PemotA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 105/263] drm/amd/display: remove dpp pipes on failure to update pipe params
Date: Mon, 12 Aug 2024 18:01:46 +0200
Message-ID: <20240812160150.563794252@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjing Liu <wenjing.liu@amd.com>

[ Upstream commit 3ddd9c83ff7ac0ead38188425b14d03dc2f2c133 ]

[why]
There are cases where update pipe params could fail but dpp pipes are already
added to the state. In this case, we should remove dpp pipes so dc state is
restored back. If it is not restored, dc state is corrupted after calling this
function, so if we call the same interface with the corrupted state again, we
may end up programming pipe topology based on a corrupted dc state.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: Wenjing Liu <wenjing.liu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index a2ca66a268c2d..a51e5de6554ee 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -2701,6 +2701,7 @@ bool resource_append_dpp_pipes_for_plane_composition(
 		struct dc_plane_state *plane_state)
 {
 	bool success;
+
 	if (otg_master_pipe->plane_state == NULL)
 		success = add_plane_to_opp_head_pipes(otg_master_pipe,
 				plane_state, new_ctx);
@@ -2708,10 +2709,15 @@ bool resource_append_dpp_pipes_for_plane_composition(
 		success = acquire_secondary_dpp_pipes_and_add_plane(
 				otg_master_pipe, plane_state, new_ctx,
 				cur_ctx, pool);
-	if (success)
+	if (success) {
 		/* when appending a plane mpc slice count changes from 0 to 1 */
 		success = update_pipe_params_after_mpc_slice_count_change(
 				plane_state, new_ctx, pool);
+		if (!success)
+			resource_remove_dpp_pipes_for_plane_composition(new_ctx,
+					pool, plane_state);
+	}
+
 	return success;
 }
 
@@ -2721,6 +2727,7 @@ void resource_remove_dpp_pipes_for_plane_composition(
 		const struct dc_plane_state *plane_state)
 {
 	int i;
+
 	for (i = pool->pipe_count - 1; i >= 0; i--) {
 		struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i];
 
-- 
2.43.0



