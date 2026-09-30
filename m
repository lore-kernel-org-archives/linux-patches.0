Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2900151EE01;
	Wed, 30 Sep 2026 17:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789174; cv=none; b=SmoB7haZ6gSw/2hwo/MTJfRSWtf2tjfHzbUkV7KMCBZdvvA8PBnUJyqZjwqrrKbZs5+BIF90wR5kD5jeKwOqVAYh+gxp1sGcWBix2KbZ+gqNGbc0O00wutWlUgyxZsyw2OanLGSUY6JlQ2ruwIKXxHxZx2xb9Y7+ErZqka+ODEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789174; c=relaxed/simple;
	bh=2vHQ8lvm6rAbA2Zzcklggz/Mq8hcCedsdiOB1lPKSV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o9US476JkwyQ+eGerqtfFbCCvkc3l/3Dx2ly6Di86EJEcnJZTLNj5cDYWLv2etzdSLmZjwCmJfCkItH1Vq1IqJcPv8rJYRSCfH37n8GtfCAJuzYBgJeFVeVPory7gf1RQPuvk78qrVfHf/idEswESehNRX0VEz+f9Q6k22vZFs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZZZGDIY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZZZGDIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827A61F000FF;
	Wed, 30 Sep 2026 17:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789173;
	bh=fhSDLvBj8ud6wsB9h+MgYArD8SSQVzyGnWW1X7Om7rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZZZGDIYE55YvdKkiYMCba53l6/u5W16Kp2rAxFPxfnet2zr/hnjuPKbI9FSs0K5x
	 7F+8h43e6lVGRA0cyfDboJsQKFrVP4UXM5idRKw3rNv06VAN49uSldFnHcIyiVEk6T
	 3zNt1fh4adK5qzlcu2rk9N7Ux4suex6xohZuh714=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nemesa Garg <nemesa.garg@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 383/877] drm/i915/psr: Clear stale sel fetch enable bits on sel fetch disable
Date: Wed, 30 Sep 2026 17:21:34 +0200
Message-ID: <20260930152422.939530006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index aeadb834d3328..2a70b2f7b39c8 100644
--- a/drivers/gpu/drm/i915/display/intel_cursor.c
+++ b/drivers/gpu/drm/i915/display/intel_cursor.c
@@ -536,7 +536,8 @@ static void i9xx_cursor_disable_sel_fetch_arm(struct intel_dsb *dsb,
 	struct intel_display *display = to_intel_display(plane->base.dev);
 	enum pipe pipe = plane->pipe;
 
-	if (!crtc_state->enable_psr2_sel_fetch)
+	if (!crtc_state->enable_psr2_sel_fetch &&
+	    !crtc_state->clear_psr2_sel_fetch)
 		return;
 
 	intel_de_write_dsb(display, dsb, SEL_FETCH_CUR_CTL(pipe), 0);
@@ -571,8 +572,10 @@ static void i9xx_cursor_update_sel_fetch_arm(struct intel_dsb *dsb,
 	struct drm_i915_private *dev_priv = to_i915(plane->base.dev);
 	enum pipe pipe = plane->pipe;
 
-	if (!crtc_state->enable_psr2_sel_fetch)
+	if (!crtc_state->enable_psr2_sel_fetch) {
+		i9xx_cursor_disable_sel_fetch_arm(dsb, plane, crtc_state);
 		return;
+	}
 
 	if (drm_rect_height(&plane_state->psr2_sel_fetch_area) > 0) {
 		if (crtc_state->enable_psr2_su_region_et) {
diff --git a/drivers/gpu/drm/i915/display/intel_display_types.h b/drivers/gpu/drm/i915/display/intel_display_types.h
index 992945b37190e..92be2cf1cf3b0 100644
--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1213,6 +1213,8 @@ struct intel_crtc_state {
 	bool has_sel_update;
 	bool enable_psr2_sel_fetch;
 	bool enable_psr2_su_region_et;
+	/* Drop the stale selective fetch enable bits as selective fetch is turned off */
+	bool clear_psr2_sel_fetch;
 	bool req_psr2_sdp_prior_scanline;
 	bool has_panel_replay;
 	bool wm_level_disabled;
diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index af4548d1f724c..596b82b736b62 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2547,6 +2547,8 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 				struct intel_crtc *crtc)
 {
 	struct intel_display *display = to_intel_display(state);
+	const struct intel_crtc_state *old_crtc_state =
+		intel_atomic_get_old_crtc_state(state, crtc);
 	struct intel_crtc_state *crtc_state = intel_atomic_get_new_crtc_state(state, crtc);
 	struct intel_plane_state *new_plane_state, *old_plane_state;
 	struct intel_plane *plane;
@@ -2559,6 +2561,19 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
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
index 7f77a76309bd5..42b3bd848162f 100644
--- a/drivers/gpu/drm/i915/display/skl_universal_plane.c
+++ b/drivers/gpu/drm/i915/display/skl_universal_plane.c
@@ -776,7 +776,8 @@ static void icl_plane_disable_sel_fetch_arm(struct intel_dsb *dsb,
 	struct intel_display *display = to_intel_display(plane->base.dev);
 	enum pipe pipe = plane->pipe;
 
-	if (!crtc_state->enable_psr2_sel_fetch)
+	if (!crtc_state->enable_psr2_sel_fetch &&
+	    !crtc_state->clear_psr2_sel_fetch)
 		return;
 
 	intel_de_write_dsb(display, dsb, SEL_FETCH_PLANE_CTL(pipe, plane->id), 0);
@@ -1505,10 +1506,8 @@ static void icl_plane_update_sel_fetch_arm(struct intel_dsb *dsb,
 	struct intel_display *display = to_intel_display(plane->base.dev);
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



