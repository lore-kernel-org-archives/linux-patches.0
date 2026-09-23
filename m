Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61503ADBB4;
	Wed, 23 Sep 2026 14:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173264; cv=none; b=hrBPM61uyLvxrNvxhU6mr6axAVXKHlDrcJMvsuBEXm3i4F4I4t3nuz7ogA/2A6VuoVTSLWPuCWjtbrQM1ZIf4qc8JWUUZbd1ZE7c23/z7gpDMwfBU77N6vF3LL9mRnXlw2Vn0r+iJMww+CNJCjF3sXDZS6jBygY10dO5XYunF/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173264; c=relaxed/simple;
	bh=VclnfL40pMyXrgvm7Bbt/fGThMAV8MnpUg1o5gMWe7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XnzkxNnio4gtmBxJMiHlwn8rxigh340IYytwsJ5eJd2wwB7BNWGCVamaPo+ibwaVkZHoXineOVio7+y8S4ge+kaTNOs63RdXJ6VfTlvdYkk2MTPplVaBrDlxjc+CmJqF3T/GKSbNZFebpyBP4FRqXS6ZDDYTZrL7xPldRs3lau0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zgbtGeX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zgbtGeX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7AE1F000FF;
	Wed, 23 Sep 2026 14:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173262;
	bh=ma9CBiXXG5opQBEPDO/vTvTz89/2DFC/nQ/WVMw9IIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0zgbtGeXBnNRsWc7JKmZ39choQuT4V+6RCaOIUiqfhKyZutPG8+wa7v7ksXKzBqKF
	 bbMmm3DVywncbHPiW4mzGJAutCCKznVwnBIJzeokx4jHrYBtGkzq+LEUCenCq+aToy
	 Te2qOow0nUKFU4715t3KDvAffZoGbFAaP3xEmbKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nemesa Garg <nemesa.garg@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 193/438] Revert "drm/i915/display: Clear SEL_FETCH_PLANE_CTL on plane disable"
Date: Wed, 23 Sep 2026 16:03:34 +0200
Message-ID: <20260923140649.762104905@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

[ Upstream commit a26204be587c57bd5c54fa513be26c4fd7bf252d ]

This reverts commit 7f1172a2ac0d7e50850785e2e65789c8aac8411a.

This commit replaced the crtc_state->enable_psr2_sel_fetch guard in
icl_plane_disable_sel_fetch_arm() and i9xx_cursor_disable_sel_fetch_arm()
with HAS_PSR2_SEL_FETCH(). This is a display version check and
says nothing about the pipe, so every plane and cursor disable on a
display 12+ platform started writing SEL_FETCH_PLANE_CTL() /
SEL_FETCH_CUR_CTL(), including on pipes that do not implement them.
It shows up as an unclaimed register access on pipes driving HDMI where
selective fetch was never enabled.

The stale selective fetch enable bit that commit addressed is handled
in the next patch.

Fixes: 7f1172a2ac0d ("drm/i915/display: Clear SEL_FETCH_PLANE_CTL on plane disable")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/16876
Signed-off-by: Nemesa Garg <nemesa.garg@intel.com>
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260909110332.3528029-2-nemesa.garg@intel.com
(cherry picked from commit d393529394167e0f5f706657eebe84d8529ce4fc)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_cursor.c       | 15 +++++----------
 .../gpu/drm/i915/display/skl_universal_plane.c    | 15 +++++----------
 2 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_cursor.c b/drivers/gpu/drm/i915/display/intel_cursor.c
index 18ef7e64821be..52347668f27d6 100644
--- a/drivers/gpu/drm/i915/display/intel_cursor.c
+++ b/drivers/gpu/drm/i915/display/intel_cursor.c
@@ -530,18 +530,13 @@ static int i9xx_check_cursor(struct intel_crtc_state *crtc_state,
 }
 
 static void i9xx_cursor_disable_sel_fetch_arm(struct intel_dsb *dsb,
-					      struct intel_plane *plane)
+					      struct intel_plane *plane,
+					      const struct intel_crtc_state *crtc_state)
 {
 	struct intel_display *display = to_intel_display(plane);
 	enum pipe pipe = plane->pipe;
 
-	/*
-	 * Clear this whenever the hardware has selective fetch, not just when
-	 * the current state uses it. The cursor may have been enabled with
-	 * selective fetch earlier and had its enable bit orphaned when the
-	 * feature was switched off.
-	 */
-	if (!HAS_PSR2_SEL_FETCH(display))
+	if (!crtc_state->enable_psr2_sel_fetch)
 		return;
 
 	intel_de_write_dsb(display, dsb, SEL_FETCH_CUR_CTL(pipe), 0);
@@ -591,7 +586,7 @@ static void i9xx_cursor_update_sel_fetch_arm(struct intel_dsb *dsb,
 		if (crtc_state->enable_psr2_su_region_et)
 			wa_16021440873(dsb, plane, crtc_state, plane_state);
 		else
-			i9xx_cursor_disable_sel_fetch_arm(dsb, plane);
+			i9xx_cursor_disable_sel_fetch_arm(dsb, plane, crtc_state);
 	}
 }
 
@@ -700,7 +695,7 @@ static void i9xx_cursor_update_arm(struct intel_dsb *dsb,
 	if (plane_state)
 		i9xx_cursor_update_sel_fetch_arm(dsb, plane, crtc_state, plane_state);
 	else
-		i9xx_cursor_disable_sel_fetch_arm(dsb, plane);
+		i9xx_cursor_disable_sel_fetch_arm(dsb, plane, crtc_state);
 
 	if (plane->cursor.base != base ||
 	    plane->cursor.size != fbc_ctl ||
diff --git a/drivers/gpu/drm/i915/display/skl_universal_plane.c b/drivers/gpu/drm/i915/display/skl_universal_plane.c
index 4369c8eeaac25..164b7d61c9a31 100644
--- a/drivers/gpu/drm/i915/display/skl_universal_plane.c
+++ b/drivers/gpu/drm/i915/display/skl_universal_plane.c
@@ -879,18 +879,13 @@ skl_plane_disable_arm(struct intel_dsb *dsb,
 }
 
 static void icl_plane_disable_sel_fetch_arm(struct intel_dsb *dsb,
-					    struct intel_plane *plane)
+					    struct intel_plane *plane,
+					    const struct intel_crtc_state *crtc_state)
 {
 	struct intel_display *display = to_intel_display(plane);
 	enum pipe pipe = plane->pipe;
 
-	/*
-	 * Clear this whenever the hardware has selective fetch, not just when
-	 * the current state uses it. The plane may have been enabled with
-	 * selective fetch earlier and had its enable bit orphaned when the
-	 * feature was switched off.
-	 */
-	if (!HAS_PSR2_SEL_FETCH(display))
+	if (!crtc_state->enable_psr2_sel_fetch)
 		return;
 
 	intel_de_write_dsb(display, dsb, SEL_FETCH_PLANE_CTL(pipe, plane->id), 0);
@@ -926,7 +921,7 @@ icl_plane_disable_arm(struct intel_dsb *dsb,
 
 	skl_write_plane_wm(dsb, plane, crtc_state);
 
-	icl_plane_disable_sel_fetch_arm(dsb, plane);
+	icl_plane_disable_sel_fetch_arm(dsb, plane, crtc_state);
 
 	if (plane_has_normalizer(plane))
 		intel_de_write_dsb(display, dsb,
@@ -1646,7 +1641,7 @@ static void icl_plane_update_sel_fetch_arm(struct intel_dsb *dsb,
 		intel_de_write_dsb(display, dsb, SEL_FETCH_PLANE_CTL(pipe, plane->id),
 				   SEL_FETCH_PLANE_CTL_ENABLE);
 	else
-		icl_plane_disable_sel_fetch_arm(dsb, plane);
+		icl_plane_disable_sel_fetch_arm(dsb, plane, crtc_state);
 }
 
 static void
-- 
2.53.0



