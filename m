Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91CF230D0F;
	Mon, 10 Mar 2025 17:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627640; cv=none; b=RC51L+SFJ65YA1XW8hkJDx6hmj7anL9tfER+V4aawaZZ50aAAUsRLs0yKNlHJfX/IXl/8QJ9yZsKn2/BFv1DTAoa0fWguDllbx7WSKO9PkZn/pHHm2Mj/1P6bvqce8RvfV7YUxAQftJxQ1AubAwLYC5Ix5U9b6fdOFIfgm/ivPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627640; c=relaxed/simple;
	bh=BZN8RhzyCd6aIfl01iJ98EE9A1g/ZPvxoDlmR4Krl2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ivZi9FYjy55ukvqmpeA9F93KKDfUFLWY03/jk8NgXFvsS6Xnd1BXQOgKoCKy95GOcIjviQwqeDCBwSK+wLuHUt9y3rJv3J7jkJZ5QAI0E34rfDwJWMDXstYZoiSvTFlNPFfbEmHzRyFQvftS9YRV6qyhjkmBH+lUX/B02DOPfWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvCj6q8U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvCj6q8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A278C4CEE5;
	Mon, 10 Mar 2025 17:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627639;
	bh=BZN8RhzyCd6aIfl01iJ98EE9A1g/ZPvxoDlmR4Krl2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvCj6q8U8uxgPLHCHykZFCrrrffWwtdd1q7EMGB+waPNIwys4FBPItehZ0z0znP/5
	 k1JrO2N5j18gjbR2tmvWLUfmZWyIPA+pbpPdhp1AMigcYX3Ycz3pJTRkmIRgw0/uGB
	 Li46i+haO4lCYz0XMk73E7Vebef/yYPev1X4VvjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 181/269] drm/i915/color: Extract intel_color_modeset()
Date: Mon, 10 Mar 2025 18:05:34 +0100
Message-ID: <20250310170504.924742892@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 84d2d0430f0833cdf52a3d051906add051f20ef0 ]

We always perform the same steps to program color management
stuff during a full modeset. Extract that code to a helper
to avoid duplication.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240916152958.17332-2-ville.syrjala@linux.intel.com
Reviewed-by: Luca Coelho <luciano.coelho@intel.com>
Stable-dep-of: 30bfc151f0c1 ("drm/xe: Remove double pageflip")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_color.c   | 17 ++++++++++
 drivers/gpu/drm/i915/display/intel_color.h   |  1 +
 drivers/gpu/drm/i915/display/intel_display.c | 33 +++-----------------
 3 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_color.c b/drivers/gpu/drm/i915/display/intel_color.c
index ec55cb651d449..808bece71c247 100644
--- a/drivers/gpu/drm/i915/display/intel_color.c
+++ b/drivers/gpu/drm/i915/display/intel_color.c
@@ -1912,6 +1912,23 @@ void intel_color_post_update(const struct intel_crtc_state *crtc_state)
 		i915->display.funcs.color->color_post_update(crtc_state);
 }
 
+void intel_color_modeset(const struct intel_crtc_state *crtc_state)
+{
+	struct intel_display *display = to_intel_display(crtc_state);
+
+	intel_color_load_luts(crtc_state);
+	intel_color_commit_noarm(crtc_state);
+	intel_color_commit_arm(crtc_state);
+
+	if (DISPLAY_VER(display) < 9) {
+		struct intel_crtc *crtc = to_intel_crtc(crtc_state->uapi.crtc);
+		struct intel_plane *plane = to_intel_plane(crtc->base.primary);
+
+		/* update DSPCNTR to configure gamma/csc for pipe bottom color */
+		plane->disable_arm(plane, crtc_state);
+	}
+}
+
 void intel_color_prepare_commit(struct intel_atomic_state *state,
 				struct intel_crtc *crtc)
 {
diff --git a/drivers/gpu/drm/i915/display/intel_color.h b/drivers/gpu/drm/i915/display/intel_color.h
index 79f230a1709ad..ab3aaec06a2ac 100644
--- a/drivers/gpu/drm/i915/display/intel_color.h
+++ b/drivers/gpu/drm/i915/display/intel_color.h
@@ -28,6 +28,7 @@ void intel_color_commit_noarm(const struct intel_crtc_state *crtc_state);
 void intel_color_commit_arm(const struct intel_crtc_state *crtc_state);
 void intel_color_post_update(const struct intel_crtc_state *crtc_state);
 void intel_color_load_luts(const struct intel_crtc_state *crtc_state);
+void intel_color_modeset(const struct intel_crtc_state *crtc_state);
 void intel_color_get_config(struct intel_crtc_state *crtc_state);
 bool intel_color_lut_equal(const struct intel_crtc_state *crtc_state,
 			   const struct drm_property_blob *blob1,
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 2c6d0da8a16f8..ac5febd076e10 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -1502,14 +1502,6 @@ static void intel_encoders_update_pipe(struct intel_atomic_state *state,
 	}
 }
 
-static void intel_disable_primary_plane(const struct intel_crtc_state *crtc_state)
-{
-	struct intel_crtc *crtc = to_intel_crtc(crtc_state->uapi.crtc);
-	struct intel_plane *plane = to_intel_plane(crtc->base.primary);
-
-	plane->disable_arm(plane, crtc_state);
-}
-
 static void ilk_configure_cpu_transcoder(const struct intel_crtc_state *crtc_state)
 {
 	struct intel_crtc *crtc = to_intel_crtc(crtc_state->uapi.crtc);
@@ -1575,11 +1567,7 @@ static void ilk_crtc_enable(struct intel_atomic_state *state,
 	 * On ILK+ LUT must be loaded before the pipe is running but with
 	 * clocks enabled
 	 */
-	intel_color_load_luts(new_crtc_state);
-	intel_color_commit_noarm(new_crtc_state);
-	intel_color_commit_arm(new_crtc_state);
-	/* update DSPCNTR to configure gamma for pipe bottom color */
-	intel_disable_primary_plane(new_crtc_state);
+	intel_color_modeset(new_crtc_state);
 
 	intel_initial_watermarks(state, crtc);
 	intel_enable_transcoder(new_crtc_state);
@@ -1741,12 +1729,7 @@ static void hsw_crtc_enable(struct intel_atomic_state *state,
 		 * On ILK+ LUT must be loaded before the pipe is running but with
 		 * clocks enabled
 		 */
-		intel_color_load_luts(pipe_crtc_state);
-		intel_color_commit_noarm(pipe_crtc_state);
-		intel_color_commit_arm(pipe_crtc_state);
-		/* update DSPCNTR to configure gamma/csc for pipe bottom color */
-		if (DISPLAY_VER(dev_priv) < 9)
-			intel_disable_primary_plane(pipe_crtc_state);
+		intel_color_modeset(pipe_crtc_state);
 
 		hsw_set_linetime_wm(pipe_crtc_state);
 
@@ -2147,11 +2130,7 @@ static void valleyview_crtc_enable(struct intel_atomic_state *state,
 
 	i9xx_pfit_enable(new_crtc_state);
 
-	intel_color_load_luts(new_crtc_state);
-	intel_color_commit_noarm(new_crtc_state);
-	intel_color_commit_arm(new_crtc_state);
-	/* update DSPCNTR to configure gamma for pipe bottom color */
-	intel_disable_primary_plane(new_crtc_state);
+	intel_color_modeset(new_crtc_state);
 
 	intel_initial_watermarks(state, crtc);
 	intel_enable_transcoder(new_crtc_state);
@@ -2187,11 +2166,7 @@ static void i9xx_crtc_enable(struct intel_atomic_state *state,
 
 	i9xx_pfit_enable(new_crtc_state);
 
-	intel_color_load_luts(new_crtc_state);
-	intel_color_commit_noarm(new_crtc_state);
-	intel_color_commit_arm(new_crtc_state);
-	/* update DSPCNTR to configure gamma for pipe bottom color */
-	intel_disable_primary_plane(new_crtc_state);
+	intel_color_modeset(new_crtc_state);
 
 	if (!intel_initial_watermarks(state, crtc))
 		intel_update_watermarks(dev_priv);
-- 
2.39.5



