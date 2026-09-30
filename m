Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCBD4CA784;
	Wed, 30 Sep 2026 16:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787184; cv=none; b=QmyDpJYi2m1Rnec9xjqm+btNkxWXoyL7yajAfnuK7F6pkU7hQUNBtpphC/fOQV+jxj8QSKxu6eOOcKWf/2DRHapHHXeFB2cRGOU6h37UwZCDy3CRS8oAVXGq5gSdC75SuTjQYUQ58WIV3YLqZFlbX3OZp0HDc2ExcrzG1SvcIEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787184; c=relaxed/simple;
	bh=MCt0Ny+9aX8A0RgzCSdlgnItJR7WFKSrtRYC+jjjBoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fWUsMvxnU1baJJI66UWXhOIZys/XSPTrlEUFtGPfh+k04DN1w5WvWf/Hk1MKGRhTuv7CVLPEl0WdEMnuyZUNU34Dwnvfz85ZT/LDmEyRjR1joAZeuUYMC85oPHQI0G5MIJbQCQmHntqIUXuYsNy8zsAZpS4pkisdrgOUIQPsQKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KedFAGTb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KedFAGTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977C01F000FF;
	Wed, 30 Sep 2026 16:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787183;
	bh=opqkBoIDwPj9GWQw/K9kqo8jx3eu/OMWAMLguBSApIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KedFAGTbIoIoOPcEHXYU2Zj8FoLhEi83J+pd+4VBNB7vgi1ij0UVIiY+k86sYR7jp
	 X55h+d8Mwt+XKEcqounrU9epXqS/EH0ZgNRpgRilth7njX2B6dk5NOJfHkZ7/ofPKU
	 GzDlsa9/WE7nr0tKHHk0Hx/KskgYFcLbVYFhdWno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nemesa Garg <nemesa.garg@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 140/457] drm/i915/psr: Clear stale sel fetch enable bits on sel fetch disable
Date: Wed, 30 Sep 2026 17:24:05 +0200
Message-ID: <20260930152349.071918262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nemesa Garg <nemesa.garg@intel.com>

[ Upstream commit 2777ec9852277a06ae68fee0c4f1a32783e4a999 ]

Selective fetch is dropped while pipe CRC is active, and the planes keep
their SEL_FETCH_PLANE_CTL / SEL_FETCH_CUR_CTL enable bit set in hardware
over that. A plane disabled while selective fetch is off never gets the
bit cleared, as the disable path is guarded by enable_psr2_sel_fetch.
Once selective fetch comes back the hardware resumes fetching for a
plane that is no longer enabled and keeps its DDB range reserved.

Clear the bits as selective fetch is turned off instead. Atomic check
has both the old and the new crtc state, so record the transition there
and let the plane and cursor arm paths write the registers to 0 for that
commit.

v2: Drop the old_crtc_state->hw.active check. [Jouni]

Fixes: b1f5279b5981 ("drm/i915/psr: Move plane sel fetch configuration into plane source files")
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/work_items/8739
Assisted-by: Copilot:Claude-Opus-5
Signed-off-by: Nemesa Garg <nemesa.garg@intel.com>
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260909110332.3528029-3-nemesa.garg@intel.com
(cherry picked from commit a4c0e7f80429eda6990960971aebd4e4b9533cc6)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_cursor.c       |  7 +++++--
 .../gpu/drm/i915/display/intel_display_types.h    |  2 ++
 drivers/gpu/drm/i915/display/intel_psr.c          | 15 +++++++++++++++
 .../gpu/drm/i915/display/skl_universal_plane.c    |  9 ++++-----
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_cursor.c b/drivers/gpu/drm/i915/display/intel_cursor.c
index 52347668f27d6..dad0e0eb0e0c0 100644
--- a/drivers/gpu/drm/i915/display/intel_cursor.c
+++ b/drivers/gpu/drm/i915/display/intel_cursor.c
@@ -536,7 +536,8 @@ static void i9xx_cursor_disable_sel_fetch_arm(struct intel_dsb *dsb,
 	struct intel_display *display = to_intel_display(plane);
 	enum pipe pipe = plane->pipe;
 
-	if (!crtc_state->enable_psr2_sel_fetch)
+	if (!crtc_state->enable_psr2_sel_fetch &&
+	    !crtc_state->clear_psr2_sel_fetch)
 		return;
 
 	intel_de_write_dsb(display, dsb, SEL_FETCH_CUR_CTL(pipe), 0);
@@ -569,8 +570,10 @@ static void i9xx_cursor_update_sel_fetch_arm(struct intel_dsb *dsb,
 	struct intel_display *display = to_intel_display(plane);
 	enum pipe pipe = plane->pipe;
 
-	if (!crtc_state->enable_psr2_sel_fetch)
+	if (!crtc_state->enable_psr2_sel_fetch) {
+		i9xx_cursor_disable_sel_fetch_arm(dsb, plane, crtc_state);
 		return;
+	}
 
 	if (drm_rect_height(&plane_state->psr2_sel_fetch_area) > 0) {
 		if (crtc_state->enable_psr2_su_region_et) {
diff --git a/drivers/gpu/drm/i915/display/intel_display_types.h b/drivers/gpu/drm/i915/display/intel_display_types.h
index 96422641ae441..18e6b01efd380 100644
--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1177,6 +1177,8 @@ struct intel_crtc_state {
 	bool has_sel_update;
 	bool enable_psr2_sel_fetch;
 	bool enable_psr2_su_region_et;
+	/* Drop the stale selective fetch enable bits as selective fetch is turned off */
+	bool clear_psr2_sel_fetch;
 	bool req_psr2_sdp_prior_scanline;
 	bool has_panel_replay;
 	bool link_off_after_as_sdp_when_pr_active;
diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index beaa1d62613db..87128104476a3 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2933,6 +2933,8 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 				struct intel_crtc *crtc)
 {
 	struct intel_display *display = to_intel_display(state);
+	const struct intel_crtc_state *old_crtc_state =
+		intel_atomic_get_old_crtc_state(state, crtc);
 	struct intel_crtc_state *crtc_state = intel_atomic_get_new_crtc_state(state, crtc);
 	struct intel_plane_state *new_plane_state, *old_plane_state;
 	struct intel_plane *plane;
@@ -2945,6 +2947,19 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 	bool full_update = false, su_area_changed;
 	int i, ret;
 
+	/*
+	 * Selective fetch is not always usable, for instance it is dropped
+	 * while pipe CRC is active. The planes keep their selective fetch
+	 * enable bit set in hardware over that, and a plane disabled while
+	 * selective fetch is off never gets the bit cleared. Once selective
+	 * fetch comes back the hardware would resume fetching for a plane that
+	 * is no longer enabled and keep its DDB range reserved, so have the
+	 * plane update drop the bit for every plane of the pipe as selective
+	 * fetch is turned off.
+	 */
+	crtc_state->clear_psr2_sel_fetch = old_crtc_state->enable_psr2_sel_fetch &&
+		!crtc_state->enable_psr2_sel_fetch;
+
 	if (!crtc_state->enable_psr2_sel_fetch)
 		return 0;
 
diff --git a/drivers/gpu/drm/i915/display/skl_universal_plane.c b/drivers/gpu/drm/i915/display/skl_universal_plane.c
index 164b7d61c9a31..3dad2da4c3aaf 100644
--- a/drivers/gpu/drm/i915/display/skl_universal_plane.c
+++ b/drivers/gpu/drm/i915/display/skl_universal_plane.c
@@ -885,7 +885,8 @@ static void icl_plane_disable_sel_fetch_arm(struct intel_dsb *dsb,
 	struct intel_display *display = to_intel_display(plane);
 	enum pipe pipe = plane->pipe;
 
-	if (!crtc_state->enable_psr2_sel_fetch)
+	if (!crtc_state->enable_psr2_sel_fetch &&
+	    !crtc_state->clear_psr2_sel_fetch)
 		return;
 
 	intel_de_write_dsb(display, dsb, SEL_FETCH_PLANE_CTL(pipe, plane->id), 0);
@@ -1634,10 +1635,8 @@ static void icl_plane_update_sel_fetch_arm(struct intel_dsb *dsb,
 	struct intel_display *display = to_intel_display(plane);
 	enum pipe pipe = plane->pipe;
 
-	if (!crtc_state->enable_psr2_sel_fetch)
-		return;
-
-	if (drm_rect_height(&plane_state->psr2_sel_fetch_area) > 0)
+	if (crtc_state->enable_psr2_sel_fetch &&
+	    drm_rect_height(&plane_state->psr2_sel_fetch_area) > 0)
 		intel_de_write_dsb(display, dsb, SEL_FETCH_PLANE_CTL(pipe, plane->id),
 				   SEL_FETCH_PLANE_CTL_ENABLE);
 	else
-- 
2.53.0



