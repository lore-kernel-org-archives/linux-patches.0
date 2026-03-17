Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F482F6160;
	Tue, 17 Mar 2026 17:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768207; cv=none; b=WwNIBHP0+6TyVZCQqrlTY0yve/W2GzZRxsj0AwakdHjpogH8i0Rn8rMF3Ghwa+y8IDjwessqxboSjhGCbw/XphKtmh2hUZvIbmi0mRdYQ2Ddpr1bmYyhE2v5EnPq3h/OCsZdnuF1IE88WmfcMK44fGo98zesepoNzKLj6tz8lQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768207; c=relaxed/simple;
	bh=dtDimHzr4B9POLXeeI1CKlbgK5oFXULF2kWsNfnX+Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iZc3eIE2VdnZYucMQEEPiXMjxAmUOBZN+4Zh/Uw3O8/GKUzgVki+l3OtPow53ZkmTlYue2BqCz/hc7xYzZzV086UyFI32sBbr8CtnpffHKBO1QNypBYPtGR8+8RrAJBLu5OlBDo4aB263tdCkzTwQ6hK57CNZzk4MZIXANGnd6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+gmIWl5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+gmIWl5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66372C19424;
	Tue, 17 Mar 2026 17:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768206;
	bh=dtDimHzr4B9POLXeeI1CKlbgK5oFXULF2kWsNfnX+Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+gmIWl5BaOs/tWU856Gq2RfdKji2xmV5N/BL8sZULrdgt68PiohZH7os9eaiNAbu
	 8ECXdyV9L0NzsAHGvTKaZiZJSYfyVG7F8qY02oRY0tcRz484R6GZRSPjBo5m6sRoQw
	 SpUfFKrv4xXNPbpFgbx4v+vgHvrmiOy+KZMiZsUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.18 257/333] drm/i915/psr: Repeat Selective Update area alignment
Date: Tue, 17 Mar 2026 17:34:46 +0100
Message-ID: <20260317163008.899702213@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

commit 1be2fca84f520105413d0d89ed04bb0ff742ab16 upstream.

Currently we are aligning Selective Update area to cover cursor fully if
needed only once. It may happen that cursor is in Selective Update area
after pipe alignment and after that covering cursor plane only
partially. Fix this by looping alignment as long as alignment isn't needed
anymore.

v2:
  - do not unecessarily loop if cursor was already fully covered
  - rename aligned as su_area_changed

Fixes: 1bff93b8bc27 ("drm/i915/psr: Extend SU area to cover cursor fully if needed")
Cc: <stable@vger.kernel.org> # v6.9+
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patch.msgid.link/20260304113011.626542-2-jouni.hogander@intel.com
(cherry picked from commit 681e12440d8b110350a5709101169f319e10ccbb)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c |   50 +++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2559,11 +2559,12 @@ static void clip_area_update(struct drm_
 		overlap_damage_area->y2 = damage_area->y2;
 }
 
-static void intel_psr2_sel_fetch_pipe_alignment(struct intel_crtc_state *crtc_state)
+static bool intel_psr2_sel_fetch_pipe_alignment(struct intel_crtc_state *crtc_state)
 {
 	struct intel_display *display = to_intel_display(crtc_state);
 	const struct drm_dsc_config *vdsc_cfg = &crtc_state->dsc.config;
 	u16 y_alignment;
+	bool su_area_changed = false;
 
 	/* ADLP aligns the SU region to vdsc slice height in case dsc is enabled */
 	if (crtc_state->dsc.compression_enable &&
@@ -2572,10 +2573,18 @@ static void intel_psr2_sel_fetch_pipe_al
 	else
 		y_alignment = crtc_state->su_y_granularity;
 
-	crtc_state->psr2_su_area.y1 -= crtc_state->psr2_su_area.y1 % y_alignment;
-	if (crtc_state->psr2_su_area.y2 % y_alignment)
+	if (crtc_state->psr2_su_area.y1 % y_alignment) {
+		crtc_state->psr2_su_area.y1 -= crtc_state->psr2_su_area.y1 % y_alignment;
+		su_area_changed = true;
+	}
+
+	if (crtc_state->psr2_su_area.y2 % y_alignment) {
 		crtc_state->psr2_su_area.y2 = ((crtc_state->psr2_su_area.y2 /
 						y_alignment) + 1) * y_alignment;
+		su_area_changed = true;
+	}
+
+	return su_area_changed;
 }
 
 /*
@@ -2708,7 +2717,7 @@ int intel_psr2_sel_fetch_update(struct i
 	struct intel_crtc_state *crtc_state = intel_atomic_get_new_crtc_state(state, crtc);
 	struct intel_plane_state *new_plane_state, *old_plane_state;
 	struct intel_plane *plane;
-	bool full_update = false, cursor_in_su_area = false;
+	bool full_update = false, su_area_changed;
 	int i, ret;
 
 	if (!crtc_state->enable_psr2_sel_fetch)
@@ -2815,15 +2824,32 @@ int intel_psr2_sel_fetch_update(struct i
 	if (ret)
 		return ret;
 
-	/*
-	 * Adjust su area to cover cursor fully as necessary (early
-	 * transport). This needs to be done after
-	 * drm_atomic_add_affected_planes to ensure visible cursor is added into
-	 * affected planes even when cursor is not updated by itself.
-	 */
-	intel_psr2_sel_fetch_et_alignment(state, crtc, &cursor_in_su_area);
+	do {
+		bool cursor_in_su_area;
 
-	intel_psr2_sel_fetch_pipe_alignment(crtc_state);
+		/*
+		 * Adjust su area to cover cursor fully as necessary
+		 * (early transport). This needs to be done after
+		 * drm_atomic_add_affected_planes to ensure visible
+		 * cursor is added into affected planes even when
+		 * cursor is not updated by itself.
+		 */
+		intel_psr2_sel_fetch_et_alignment(state, crtc, &cursor_in_su_area);
+
+		su_area_changed = intel_psr2_sel_fetch_pipe_alignment(crtc_state);
+
+		/*
+		 * If the cursor was outside the SU area before
+		 * alignment, the alignment step (which only expands
+		 * SU) may pull the cursor partially inside, so we
+		 * must run ET alignment again to fully cover it. But
+		 * if the cursor was already fully inside before
+		 * alignment, expanding the SU area won't change that,
+		 * so no further work is needed.
+		 */
+		if (cursor_in_su_area)
+			break;
+	} while (su_area_changed);
 
 	/*
 	 * Now that we have the pipe damaged area check if it intersect with


