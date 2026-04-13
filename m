Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57EB25DB12;
	Mon, 13 Apr 2026 16:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096302; cv=none; b=e+vbHRM/ZT+S/L/2+XrLgtbVI2s9XCWvS5225wrbe7cTswM1Gy/Xv3uW2SDKMItta3kTrTceE7stPMIZV0Hj36B+DkMNt6MxUzg20DFTU261IdYCpPoX+1jntN7icUtpMe8h+kAsVFyifxiYkJwwRxkVvWzEYDFQap8zHehYHmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096302; c=relaxed/simple;
	bh=4SZiwO3b61GI+L3Io96ryRcel+feNtUh3Ut5iwaDJyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CQ/OZNMz6VDAcRI2KHq9bzKH9d6HUdEbqiIXVbI+GI5wMtN8xBBan1vikclK3/AEWzYlF+0KjZNOG3jpjx/O0QtJUIEpCXY1pmuOpZL6lKE/DBk1I7HF+E3psk6opsyCZoGfFkO9ww8Jyywobp/Nk3Jh6KhqKh2Mwm7g7C/kFmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMD5Zssn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMD5Zssn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A801C2BCB0;
	Mon, 13 Apr 2026 16:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096302;
	bh=4SZiwO3b61GI+L3Io96ryRcel+feNtUh3Ut5iwaDJyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hMD5ZssnvQAt5ia+GQg4zZI843KsVNZrRXc2ad6AThXbHfAr66yFgiTyfaPlENur3
	 2L4NQ0xvMgchVo5Icm5tAgAszNm+iWX3+U5kqfdWF5/Bc19imFc/MjDtSOCTUP+i4N
	 /smQr5w9Kxl4/27fyQKbuls2SqpeWNyF6xVTjmMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.19 46/86] drm/i915/psr: Do not use pipe_src as borders for SU area
Date: Mon, 13 Apr 2026 17:59:53 +0200
Message-ID: <20260413155733.287003706@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

commit 75519f5df2a9b23f7bf305e12dc9a6e3e65c24b7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2656,9 +2656,9 @@ static u32 psr2_pipe_srcsz_early_tpt_cal
 
 static void clip_area_update(struct drm_rect *overlap_damage_area,
 			     struct drm_rect *damage_area,
-			     struct drm_rect *pipe_src)
+			     struct drm_rect *display_area)
 {
-	if (!drm_rect_intersect(damage_area, pipe_src))
+	if (!drm_rect_intersect(damage_area, display_area))
 		return;
 
 	if (overlap_damage_area->y1 == -1) {
@@ -2709,6 +2709,7 @@ static bool intel_psr2_sel_fetch_pipe_al
 static void
 intel_psr2_sel_fetch_et_alignment(struct intel_atomic_state *state,
 				  struct intel_crtc *crtc,
+				  struct drm_rect *display_area,
 				  bool *cursor_in_su_area)
 {
 	struct intel_crtc_state *crtc_state = intel_atomic_get_new_crtc_state(state, crtc);
@@ -2736,7 +2737,7 @@ intel_psr2_sel_fetch_et_alignment(struct
 			continue;
 
 		clip_area_update(&crtc_state->psr2_su_area, &new_plane_state->uapi.dst,
-				 &crtc_state->pipe_src);
+				 display_area);
 		*cursor_in_su_area = true;
 	}
 }
@@ -2832,6 +2833,12 @@ int intel_psr2_sel_fetch_update(struct i
 	struct intel_crtc_state *crtc_state = intel_atomic_get_new_crtc_state(state, crtc);
 	struct intel_plane_state *new_plane_state, *old_plane_state;
 	struct intel_plane *plane;
+	struct drm_rect display_area = {
+		.x1 = 0,
+		.y1 = 0,
+		.x2 = crtc_state->hw.adjusted_mode.crtc_hdisplay,
+		.y2 = crtc_state->hw.adjusted_mode.crtc_vdisplay,
+	};
 	bool full_update = false, su_area_changed;
 	int i, ret;
 
@@ -2845,7 +2852,7 @@ int intel_psr2_sel_fetch_update(struct i
 
 	crtc_state->psr2_su_area.x1 = 0;
 	crtc_state->psr2_su_area.y1 = -1;
-	crtc_state->psr2_su_area.x2 = drm_rect_width(&crtc_state->pipe_src);
+	crtc_state->psr2_su_area.x2 = drm_rect_width(&display_area);
 	crtc_state->psr2_su_area.y2 = -1;
 
 	/*
@@ -2883,14 +2890,14 @@ int intel_psr2_sel_fetch_update(struct i
 				damaged_area.y1 = old_plane_state->uapi.dst.y1;
 				damaged_area.y2 = old_plane_state->uapi.dst.y2;
 				clip_area_update(&crtc_state->psr2_su_area, &damaged_area,
-						 &crtc_state->pipe_src);
+						 &display_area);
 			}
 
 			if (new_plane_state->uapi.visible) {
 				damaged_area.y1 = new_plane_state->uapi.dst.y1;
 				damaged_area.y2 = new_plane_state->uapi.dst.y2;
 				clip_area_update(&crtc_state->psr2_su_area, &damaged_area,
-						 &crtc_state->pipe_src);
+						 &display_area);
 			}
 			continue;
 		} else if (new_plane_state->uapi.alpha != old_plane_state->uapi.alpha) {
@@ -2898,7 +2905,7 @@ int intel_psr2_sel_fetch_update(struct i
 			damaged_area.y1 = new_plane_state->uapi.dst.y1;
 			damaged_area.y2 = new_plane_state->uapi.dst.y2;
 			clip_area_update(&crtc_state->psr2_su_area, &damaged_area,
-					 &crtc_state->pipe_src);
+					 &display_area);
 			continue;
 		}
 
@@ -2914,7 +2921,7 @@ int intel_psr2_sel_fetch_update(struct i
 		damaged_area.x1 += new_plane_state->uapi.dst.x1 - src.x1;
 		damaged_area.x2 += new_plane_state->uapi.dst.x1 - src.x1;
 
-		clip_area_update(&crtc_state->psr2_su_area, &damaged_area, &crtc_state->pipe_src);
+		clip_area_update(&crtc_state->psr2_su_area, &damaged_area, &display_area);
 	}
 
 	/*
@@ -2949,7 +2956,8 @@ int intel_psr2_sel_fetch_update(struct i
 		 * cursor is added into affected planes even when
 		 * cursor is not updated by itself.
 		 */
-		intel_psr2_sel_fetch_et_alignment(state, crtc, &cursor_in_su_area);
+		intel_psr2_sel_fetch_et_alignment(state, crtc, &display_area,
+						  &cursor_in_su_area);
 
 		su_area_changed = intel_psr2_sel_fetch_pipe_alignment(crtc_state);
 
@@ -3025,8 +3033,8 @@ int intel_psr2_sel_fetch_update(struct i
 
 skip_sel_fetch_set_loop:
 	if (full_update)
-		clip_area_update(&crtc_state->psr2_su_area, &crtc_state->pipe_src,
-				 &crtc_state->pipe_src);
+		clip_area_update(&crtc_state->psr2_su_area, &display_area,
+				 &display_area);
 
 	psr2_man_trk_ctl_calc(crtc_state, full_update);
 	crtc_state->pipe_srcsz_early_tpt =


