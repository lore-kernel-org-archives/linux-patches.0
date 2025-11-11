Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BB72F49E9;
	Tue, 11 Nov 2025 01:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823797; cv=none; b=U9Oi6GF6dzac229Fgq2S1ThdDeQ6AS4vJ5zWxzHl8RdQbdD+UP03xFViD0S+PHia9nA+TTsDzWRukh/L46mhvR44xNDDcVcYyEc/wT9lPqoIaIXl/uKWvH0mbOe9/Z65tIeR6J3BRO0JvqkcipzPfy+tB30Yl8XGBG9QF2MDp2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823797; c=relaxed/simple;
	bh=b2eFOjuCiwxEfdCM321223R1OMJ1fOT79S0dSjSPbjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0iOzovzonkHD3xJft1oqOt67bjH1K09JZXq3URZQPBHi44zgQ1AXtTXwYf5s6tWtCPC4KNL+iCRcBf7l/yQEG3EKDIIxES6yZAwdbTj8TPjuW8/ipc1pQP9j3S1M49unLiTCi9wd/1PA3HyzGGT43gb4SUK7B6C2OqnMD27Q+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yw06v+dK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yw06v+dK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679DCC19425;
	Tue, 11 Nov 2025 01:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823797;
	bh=b2eFOjuCiwxEfdCM321223R1OMJ1fOT79S0dSjSPbjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yw06v+dKeQEML8kEBxsKssDaWezUoowIbHiOED03zoLaGTUpQowElIrbsWaAYMhVq
	 5qzoSojm2sFrcn3FptW6TNJ9+MJNU9zStvuhAqae/p4rTht4FJ7gWVB97ifpQwJ0Pp
	 T/JWX5wGlCB7MtzvCfhz5ZYic105m6mN8JqQvCC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 374/849] drm/amd/display: Support HW cursor 180 rot for any number of pipe splits
Date: Tue, 11 Nov 2025 09:39:04 +0900
Message-ID: <20251111004545.473075958@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Ivan Lipski <ivan.lipski@amd.com>

[ Upstream commit 8a359f0f138d5ac7ceffd21b73279be50e516c0a ]

[Why]
For the HW cursor, its current position in the pipe_ctx->stream struct is
not affected by the 180 rotation, i. e. the top left corner is still at
0,0. However, the DPP & HUBP set_cursor_position functions require rotated
position.

The current approach is hard-coded for ODM 2:1, thus it's failing for
ODM 4:1, resulting in a double cursor.

[How]
Instead of calculating the new cursor position relatively to the
viewports, we calculate it using a viewavable clip_rect of each plane.

The clip_rects are first offset and scaled to the same space as the
src_rect, i. e. Stream space -> Plane space.

In case of a pipe split, which divides the plane into 2 or more viewports,
the clip_rect is the union of all the viewports of the given plane.

With the assumption that the viewports in HUBP's set_cursor_position are
in the Plane space as well, it should produce a correct cursor position
for any number of pipe splits.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/hwss/dcn10/dcn10_hwseq.c   | 73 +++++++------------
 1 file changed, 27 insertions(+), 46 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
index 39910f73ecd06..6a2fdbe974b53 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
@@ -3628,6 +3628,8 @@ void dcn10_set_cursor_position(struct pipe_ctx *pipe_ctx)
 	int y_plane = pipe_ctx->plane_state->dst_rect.y;
 	int x_pos = pos_cpy.x;
 	int y_pos = pos_cpy.y;
+	int clip_x = pipe_ctx->plane_state->clip_rect.x;
+	int clip_width = pipe_ctx->plane_state->clip_rect.width;
 
 	if ((pipe_ctx->top_pipe != NULL) || (pipe_ctx->bottom_pipe != NULL)) {
 		if ((pipe_ctx->plane_state->src_rect.width != pipe_ctx->plane_res.scl_data.viewport.width) ||
@@ -3646,7 +3648,7 @@ void dcn10_set_cursor_position(struct pipe_ctx *pipe_ctx)
 	 */
 
 	/**
-	 * Translate cursor from stream space to plane space.
+	 * Translate cursor and clip offset from stream space to plane space.
 	 *
 	 * If the cursor is scaled then we need to scale the position
 	 * to be in the approximately correct place. We can't do anything
@@ -3663,6 +3665,10 @@ void dcn10_set_cursor_position(struct pipe_ctx *pipe_ctx)
 				pipe_ctx->plane_state->dst_rect.width;
 		y_pos = (y_pos - y_plane) * pipe_ctx->plane_state->src_rect.height /
 				pipe_ctx->plane_state->dst_rect.height;
+		clip_x = (clip_x - x_plane) * pipe_ctx->plane_state->src_rect.width /
+				pipe_ctx->plane_state->dst_rect.width;
+		clip_width = clip_width * pipe_ctx->plane_state->src_rect.width /
+				pipe_ctx->plane_state->dst_rect.width;
 	}
 
 	/**
@@ -3709,30 +3715,18 @@ void dcn10_set_cursor_position(struct pipe_ctx *pipe_ctx)
 
 
 	if (param.rotation == ROTATION_ANGLE_0) {
-		int viewport_width =
-			pipe_ctx->plane_res.scl_data.viewport.width;
-		int viewport_x =
-			pipe_ctx->plane_res.scl_data.viewport.x;
 
 		if (param.mirror) {
-			if (pipe_split_on || odm_combine_on) {
-				if (pos_cpy.x >= viewport_width + viewport_x) {
-					pos_cpy.x = 2 * viewport_width
-							- pos_cpy.x + 2 * viewport_x;
-				} else {
-					uint32_t temp_x = pos_cpy.x;
-
-					pos_cpy.x = 2 * viewport_x - pos_cpy.x;
-					if (temp_x >= viewport_x +
-						(int)hubp->curs_attr.width || pos_cpy.x
-						<= (int)hubp->curs_attr.width +
-						pipe_ctx->plane_state->src_rect.x) {
-						pos_cpy.x = 2 * viewport_width - temp_x;
-					}
-				}
-			} else {
-				pos_cpy.x = viewport_width - pos_cpy.x + 2 * viewport_x;
-			}
+			/*
+			 * The plane is split into multiple viewports.
+			 * The combination of all viewports span the
+			 * entirety of the clip rect.
+			 *
+			 * For no pipe_split, viewport_width is represents
+			 * the full width of the clip_rect, so we can just
+			 * mirror it.
+			 */
+			pos_cpy.x = clip_width - pos_cpy.x + 2 * clip_x;
 		}
 	}
 	// Swap axis and mirror horizontally
@@ -3802,30 +3796,17 @@ void dcn10_set_cursor_position(struct pipe_ctx *pipe_ctx)
 	}
 	// Mirror horizontally and vertically
 	else if (param.rotation == ROTATION_ANGLE_180) {
-		int viewport_width =
-			pipe_ctx->plane_res.scl_data.viewport.width;
-		int viewport_x =
-			pipe_ctx->plane_res.scl_data.viewport.x;
-
 		if (!param.mirror) {
-			if (pipe_split_on || odm_combine_on) {
-				if (pos_cpy.x >= viewport_width + viewport_x) {
-					pos_cpy.x = 2 * viewport_width
-							- pos_cpy.x + 2 * viewport_x;
-				} else {
-					uint32_t temp_x = pos_cpy.x;
-
-					pos_cpy.x = 2 * viewport_x - pos_cpy.x;
-					if (temp_x >= viewport_x +
-						(int)hubp->curs_attr.width || pos_cpy.x
-						<= (int)hubp->curs_attr.width +
-						pipe_ctx->plane_state->src_rect.x) {
-						pos_cpy.x = temp_x + viewport_width;
-					}
-				}
-			} else {
-				pos_cpy.x = viewport_width - pos_cpy.x + 2 * viewport_x;
-			}
+			/*
+			 * The plane is split into multiple viewports.
+			 * The combination of all viewports span the
+			 * entirety of the clip rect.
+			 *
+			 * For no pipe_split, viewport_width is represents
+			 * the full width of the clip_rect, so we can just
+			 * mirror it.
+			 */
+			pos_cpy.x = clip_width - pos_cpy.x + 2 * clip_x;
 		}
 
 		/**
-- 
2.51.0



