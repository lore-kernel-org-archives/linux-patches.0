Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20ED33E347;
	Fri, 24 Apr 2026 13:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037777; cv=none; b=VM5eqOpXRClfXOYAh5qLQTjupjVTFTLOozLL+iKeVVhslQZOPU9tiN0BFGsqGs6BbpixJvNROX+A3mQAI9/meIjU5arlwPDKbZIh4UJKOcj6KquhLGZGmZe+rPHhI9Xd/0P5wwtdCY71+JhqyiWZT+sgWvlUZFY0HnkHHbzX3Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037777; c=relaxed/simple;
	bh=K/4TZLKXiye1lpgefABBSHlBcfXX6qt0ZsmCZfoTQvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A2DugAxxC8WYGilFxB/4MjGqgMpgLqAvG1riYmMXUtXWknZUXo6fa1jiFoZkt96gxkR6v0Seymb3CYPyqZzxiM5OS6c1ZZw9wXHjGQZM88F8HZnNWX2P/LYFH+jatvtt6wyx2NdLj3hONHk47NTJAJGnoRqw9gCOYK01SPLVhTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ehKGOTe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ehKGOTe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332D2C19425;
	Fri, 24 Apr 2026 13:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037777;
	bh=K/4TZLKXiye1lpgefABBSHlBcfXX6qt0ZsmCZfoTQvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehKGOTe95l4RNXPVewNnkIC3wu2j1nS/8ZYw1cleTiCkBj/lRrlEAEwXJxxhkrcyf
	 6TRlDRZ/pbHeZd8f0mEhaiZ8aBz3k06ZL6IjjnD38V6HzlpGiKrfLeACZZP1udknKu
	 jdKJfvzAM6hUrR4/zsAKUnvNfA5h8M4Yk2w9d8KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/166] drm/i915/psr: Do not use pipe_src as borders for SU area
Date: Fri, 24 Apr 2026 15:29:40 +0200
Message-ID: <20260424132546.544127336@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 75519f5df2a9b23f7bf305e12dc9a6e3e65c24b7 ]

This far using crtc_state->pipe_src as borders for Selective Update area
haven't caused visible problems as drm_rect_width(crtc_state->pipe_src) ==
crtc_state->hw.adjusted_mode.crtc_hdisplay and
drm_rect_height(crtc_state->pipe_src) ==
crtc_state->hw.adjusted_mode.crtc_vdisplay when pipe scaling is not
used. On the other hand using pipe scaling is forcing full frame updates and all the
Selective Update area calculations are skipped. Now this improper usage of
crtc_state->pipe_src is causing following warnings:

<4> [7771.978166] xe 0000:00:02.0: [drm] drm_WARN_ON_ONCE(su_lines % vdsc_cfg->slice_height)

after WARN_ON_ONCE was added by commit:

"drm/i915/dsc: Add helper for writing DSC Selective Update ET parameters"

These warnings are seen when DSC and pipe scaling are enabled
simultaneously. This is because on full frame update SU area is improperly
set as pipe_src which is not aligned with DSC slice height.

Fix these by creating local rectangle using
crtc_state->hw.adjusted_mode.crtc_hdisplay and
crtc_state->hw.adjusted_mode.crtc_vdisplay. Use this local rectangle as
borders for SU area.

Fixes: d6774b8c3c58 ("drm/i915: Ensure damage clip area is within pipe area")
Cc: <stable@vger.kernel.org> # v6.0+
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Link: https://patch.msgid.link/20260327114553.195285-1-jouni.hogander@intel.com
(cherry picked from commit da0cdc1c329dd2ff09c41fbbe9fbd9c92c5d2c6e)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
[ omitted hunks for DSC selective update ET alignment infrastructure ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 5cf3db7058b98..b0818dc8480ed 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -1924,9 +1924,9 @@ static void psr2_man_trk_ctl_calc(struct intel_crtc_state *crtc_state,
 
 static void clip_area_update(struct drm_rect *overlap_damage_area,
 			     struct drm_rect *damage_area,
-			     struct drm_rect *pipe_src)
+			     struct drm_rect *display_area)
 {
-	if (!drm_rect_intersect(damage_area, pipe_src))
+	if (!drm_rect_intersect(damage_area, display_area))
 		return;
 
 	if (overlap_damage_area->y1 == -1) {
@@ -2004,6 +2004,12 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 	struct drm_rect pipe_clip = { .x1 = 0, .y1 = -1, .x2 = INT_MAX, .y2 = -1 };
 	struct intel_plane_state *new_plane_state, *old_plane_state;
 	struct intel_plane *plane;
+	struct drm_rect display_area = {
+		.x1 = 0,
+		.y1 = 0,
+		.x2 = crtc_state->hw.adjusted_mode.crtc_hdisplay,
+		.y2 = crtc_state->hw.adjusted_mode.crtc_vdisplay,
+	};
 	bool full_update = false;
 	int i, ret;
 
@@ -2050,14 +2056,14 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 				damaged_area.y1 = old_plane_state->uapi.dst.y1;
 				damaged_area.y2 = old_plane_state->uapi.dst.y2;
 				clip_area_update(&pipe_clip, &damaged_area,
-						 &crtc_state->pipe_src);
+						 &display_area);
 			}
 
 			if (new_plane_state->uapi.visible) {
 				damaged_area.y1 = new_plane_state->uapi.dst.y1;
 				damaged_area.y2 = new_plane_state->uapi.dst.y2;
 				clip_area_update(&pipe_clip, &damaged_area,
-						 &crtc_state->pipe_src);
+						 &display_area);
 			}
 			continue;
 		} else if (new_plane_state->uapi.alpha != old_plane_state->uapi.alpha) {
@@ -2065,7 +2071,7 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 			damaged_area.y1 = new_plane_state->uapi.dst.y1;
 			damaged_area.y2 = new_plane_state->uapi.dst.y2;
 			clip_area_update(&pipe_clip, &damaged_area,
-					 &crtc_state->pipe_src);
+					 &display_area);
 			continue;
 		}
 
@@ -2081,7 +2087,7 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 		damaged_area.x1 += new_plane_state->uapi.dst.x1 - src.x1;
 		damaged_area.x2 += new_plane_state->uapi.dst.x1 - src.x1;
 
-		clip_area_update(&pipe_clip, &damaged_area, &crtc_state->pipe_src);
+		clip_area_update(&pipe_clip, &damaged_area, &display_area);
 	}
 
 	/*
-- 
2.53.0



