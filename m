Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4922051DB00;
	Wed, 30 Sep 2026 17:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789171; cv=none; b=gevS99q97lo5X51dUgzTzJjMqkEgH3ia48CVFTKxfy3HgKB4/akvMtlV/dmq21BBRp60X8VZHnFe9F0YpXzXf+KKOIsTvdl9gWdkXY1kNNGpo1/EDcK5cENLuGVv9k8tIPDBXSz5nbToj1carz6TgahaQPjzKvt0oGZ6AdIFsog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789171; c=relaxed/simple;
	bh=F2O+5/YyMacDmp2GMdf05bGF6Oi6tVyDKcrtSOsToJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nmeNaP2i4abmyLqjM5ELlg7Rfrnel+00EY4KafAYwO699CTlsuUb4uRiT48S62kZE/AEgpqTYWqKG6HqllyR6/l28iGNn0/ogjfeR8psekll33JS1fgaIS/v6sGeKhxDsmp8TrdIkNRqiaCg40nPnQVsuy/LTy8m0lKEWo/WdU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbH9F7/j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbH9F7/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34DE1F000FF;
	Wed, 30 Sep 2026 17:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789170;
	bh=5d7gkaa3itqG/SNlsuuAC5ueDZECye8D1T2OZFEFvko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PbH9F7/jkLxlK6rJkLOisg+kBEB8KzsGwrMBsEP6XPzYHcgbzhc3NerpDfLnegc8t
	 ArG/GlsIaMyiokv52JmZivMSQP9g+uBSCJ2ztSS0KzFRnMf/C0wySQES/JdSapmBLF
	 b9/aM2p4kvKLF/WGpyg3yWvB/bTieCC4FSH1wsEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 382/877] drm/i915/psr: Add new SU area calculation helper to apply workarounds
Date: Wed, 30 Sep 2026 17:21:33 +0200
Message-ID: <20260930152422.918182163@linuxfoundation.org>
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

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit f3c25031bb321d8cef15ecd4df27d0f644a95193 ]

intel_psr2_sel_fetch_update is already quite long function. Now we are
about to add one more HW workaround. Let's split applying workarounds to
selective update area into a separate function.

Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240926064759.1313335-2-jouni.hogander@intel.com
Stable-dep-of: 2777ec985227 ("drm/i915/psr: Clear stale sel fetch enable bits on sel fetch disable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 5173f5759ce88..af4548d1f724c 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2529,11 +2529,24 @@ static bool psr2_sel_fetch_pipe_state_supported(const struct intel_crtc_state *c
 	return true;
 }
 
+static void
+intel_psr_apply_su_area_workarounds(struct intel_crtc_state *crtc_state)
+{
+	struct intel_display *display = to_intel_display(crtc_state);
+	struct drm_i915_private *i915 = to_i915(crtc_state->uapi.crtc->dev);
+
+	/* Wa_14014971492 */
+	if (!crtc_state->has_panel_replay &&
+	    ((IS_DISPLAY_VER_STEP(display, IP_VER(14, 0), STEP_A0, STEP_B0) ||
+	      IS_ALDERLAKE_P(i915) || IS_TIGERLAKE(i915))) &&
+	    crtc_state->splitter.enable)
+		crtc_state->psr2_su_area.y1 = 0;
+}
+
 int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 				struct intel_crtc *crtc)
 {
 	struct intel_display *display = to_intel_display(state);
-	struct drm_i915_private *dev_priv = to_i915(state->base.dev);
 	struct intel_crtc_state *crtc_state = intel_atomic_get_new_crtc_state(state, crtc);
 	struct intel_plane_state *new_plane_state, *old_plane_state;
 	struct intel_plane *plane;
@@ -2644,12 +2657,7 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 	if (full_update)
 		goto skip_sel_fetch_set_loop;
 
-	/* Wa_14014971492 */
-	if (!crtc_state->has_panel_replay &&
-	    ((IS_DISPLAY_VER_STEP(display, IP_VER(14, 0), STEP_A0, STEP_B0) ||
-	      IS_ALDERLAKE_P(dev_priv) || IS_TIGERLAKE(dev_priv))) &&
-	    crtc_state->splitter.enable)
-		crtc_state->psr2_su_area.y1 = 0;
+	intel_psr_apply_su_area_workarounds(crtc_state);
 
 	ret = drm_atomic_add_affected_planes(&state->base, &crtc->base);
 	if (ret)
-- 
2.53.0



