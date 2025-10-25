Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D74307AC2;
	Sat, 25 Oct 2025 16:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408979; cv=none; b=IMXbK1okUub9SKMmzzBW2NnlMHd8QN0Xq04fbaO8Y7/vTwXLiv2ZKgnf48PHGG3lGAEEE5Ype5FASxoTyciYzDF0uOPAxIEhZ4MoQnlWkgRpATpOzIHSC3DHnwRdfeg2LwgLAwaZ6V4c05QN+72UzWM6FZLsceP099chShHWcgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408979; c=relaxed/simple;
	bh=L1uUNHgl8/4BeQBUyYtJsKfCyFA5W2f7bRP8dMJzZcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IDZSty9kmSIu0tfcJnRtJrUho27uneRdHl4XdikJSft0lkfi2hHYYxt5eFXcLKrPoqTk5iNoAAi7aqQuT6rhCsHCOxHVEDOiNpRHSnp/kh5aJbpU2McZvBdXGeenSPawR8jcBKZPzbQvmPh3urmAtq4uxZWQKj7qahNovSp4mI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HnSkbfVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HnSkbfVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49EBC4CEFB;
	Sat, 25 Oct 2025 16:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408979;
	bh=L1uUNHgl8/4BeQBUyYtJsKfCyFA5W2f7bRP8dMJzZcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HnSkbfVbGJdGehNCnJ7hWX1woxvZFAP7qgOurw/MiYR3hi/mNjqS7vRCCt7Qs9Na3
	 ckMLlS/iBAw+EcNdza3JxmnXdhXItzjx4/UUy5YfQI8eCCyR054/VdEn2ekSMqGiKm
	 vFnZRMJKB9On94r4sj3z9DqUgHKyMOriM2Q2dx7LKtV8H794IUlCHVxe/16gz762vF
	 iDEioPiglK+bPNNicVf3+VSasvmhFQUdA85Ti2BPCU9S4SnBCq5u0BgaCzPjs7/+EL
	 pT5lkErPxFbOXgp7Tr3U/j4uVTgXaexiDCAwAfyuXsFTVskYr+orxhpP+w7IhnYkcq
	 ZS0idYgUm9vSw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ivan Lipski <ivan.lipski@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	wayne.lin@amd.com,
	roman.li@amd.com,
	reza.amini@amd.com,
	Yihan.Zhu@amd.com,
	zhikai.zhai@amd.com,
	peterson.guo@amd.com,
	siqueira@igalia.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amd/display: Support HW cursor 180 rot for any number of pipe splits
Date: Sat, 25 Oct 2025 11:56:32 -0400
Message-ID: <20251025160905.3857885-161-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Addresses a user-visible bug where the HW cursor shows up twice
    (“double cursor”) when the plane is rotated 180° and split via ODM
    4:1. The prior logic only handled ODM 2:1, so 4:1 (and generally
    N:1) cases miscomputed the mirrored X coordinate (commit message).
  - The bug affects real users in multi-pipe/high-resolution scenarios
    and is limited to cursor positioning logic.

- How it fixes it
  - Replaces ODM-2:1-specific mirroring math with a general solution
    that mirrors across the plane’s visible clip rectangle, which by
    definition equals the union of all viewports for that plane under
    pipe split:
    - Adds and uses `clip_x`/`clip_width` from `plane_state->clip_rect`,
      normalized to plane space alongside the cursor position
      (drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c:3666,
      drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c:3700).
    - For ROTATION_ANGLE_0 with horizontal mirror, and for
      ROTATION_ANGLE_180 without horizontal mirror, replaces the entire
      older ODM-specific branching with the single correct transform:
      - `pos_cpy.x = clip_width - pos_cpy.x + 2 * clip_x;`
      - drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c:3750
      - drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c:3831
  - The cursor position remains computed in plane space as required by
    HUBP/DPP programming; clip rect is a standard part of `struct
    dc_plane_state` (drivers/gpu/drm/amd/display/dc/dc.h:1418).

- Scope and risk
  - Change is small and self-contained to one function
    (`dcn10_set_cursor_position`) used by DCN HWSS init across DCN
    generations, but only affects cursor position logic for:
    - Rotation 0° with horizontal mirror, and 180° without mirror (the
      problematic cases).
    - 90°/270° paths are untouched except for the benign addition of
      clip rect normalization in the non-rotated path, preserving prior
      behavior where appropriate.
  - Removes brittle 2:1-specific branches and hotspot/width-dependent
    corner cases that previously oscillated via fixes, reducing
    regression risk.
  - No API/ABI or architectural changes; no new features; strictly a
    correctness fix in a well-contained area.

- Stable backport criteria
  - Fixes an important, user-visible bug (double cursor under ODM 4:1
    with 180° rotation).
  - Minimal, localized patch with clear intent and low risk of side
    effects.
  - Conforms to stable rules (bugfix, not a feature; no broad subsystem
    refactor).
  - Aligns with how HUBP/DPP expect rotated/plane-space positions to be
    supplied (drivers/gpu/drm/amd/display/dc/dpp/dcn10/dcn10_dpp.c:434).

Given the above, this is a strong candidate for stable backporting.

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

