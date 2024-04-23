Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D940D145321;
	Tue, 23 Apr 2024 21:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908563; cv=none; b=MlIXv0S+qVGpGeXQIGV1UiAtKJ2STtRuk+SaKEjD7bx4p9YtzUa1oRVrz1RicFUMP44Z8+qE8Aq1Je8WEt2BrelEuW6oYVA+jsQtd5Jyo1qR+pdC52mPuMRXDAOCGlix1Nlj2XN78IxVAPY5ZGoQqaziejITBVHwnnHADva7Cd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908563; c=relaxed/simple;
	bh=piv09Ar5x4T0DIIs0Y7TnBgnuElD1Y0l949kIlX5RAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GW19r77OO5j54e6min8BKkGgMnoT3Zkc9szm/2Z7nQ3mwblUNxtfqQyirXxJl8SjE9BS45divNwccwTO+zifyhk0krhERuMLH1e/oyJKIVjm6gJA0dZO8iBHvzCbuWGIp8gdSq0ZYQ7HvOi7DBlZZATL5WbkPIelK/jnhVpF8yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0FRvU7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0FRvU7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC42C3277B;
	Tue, 23 Apr 2024 21:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908563;
	bh=piv09Ar5x4T0DIIs0Y7TnBgnuElD1Y0l949kIlX5RAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0FRvU7l+9O93oW3qDKjZPY66INIrmuO22odRyHtqjiPMtWAgigH8sP0aMu858OlI
	 5hfNi/hthtcuEZK5uuPRSBeKkwnczJSEfD3eYVthzkMTNIT012k/q2b/ElisKm0vup
	 inxDx3jYh79dfRJDja0qB7Sa4j6bbkxL9vBDYbQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manasi Navare <navaremanasi@chromium.org>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/158] drm/i915: Enable VRR later during fastsets
Date: Tue, 23 Apr 2024 14:37:28 -0700
Message-ID: <20240423213856.092108199@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 691dec86acc3afb469f09e9a4a00508b458bdb0c ]

In order to reconcile seamless M/N updates with VRR we'll
need to defer the fastset VRR enable to happen after the
seamless M/N update (which happens during the vblank evade
critical section). So just push the VRR enable to be the last
thing during the update.

This will also affect the vblank evasion as the transcoder
will now still be running with the old VRR state during
the vblank evasion. So just grab the timings always from the
old crtc state during any non-modeset commit, and also grab
the current state of VRR from the active timings (as we disable
VRR before vblank evasion during fastsets).

This also fixes vblank evasion for seamless M/N updates as
we now properly account for the fact that the M/N update
happens after vblank evasion.

Cc: Manasi Navare <navaremanasi@chromium.org>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230901130440.2085-5-ville.syrjala@linux.intel.com
Reviewed-by: Manasi Navare <navaremanasi@chromium.org>
Reviewed-by: Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>
Stable-dep-of: 4a36e46df7aa ("drm/i915: Disable live M/N updates when using bigjoiner")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_crtc.c    | 35 ++++++++++++--------
 drivers/gpu/drm/i915/display/intel_display.c | 21 ++++++++----
 2 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_crtc.c b/drivers/gpu/drm/i915/display/intel_crtc.c
index 9693747a18c66..5c89eba8148c0 100644
--- a/drivers/gpu/drm/i915/display/intel_crtc.c
+++ b/drivers/gpu/drm/i915/display/intel_crtc.c
@@ -472,15 +472,31 @@ static void intel_crtc_vblank_evade_scanlines(struct intel_atomic_state *state,
 					      struct intel_crtc *crtc,
 					      int *min, int *max, int *vblank_start)
 {
+	const struct intel_crtc_state *old_crtc_state =
+		intel_atomic_get_old_crtc_state(state, crtc);
 	const struct intel_crtc_state *new_crtc_state =
 		intel_atomic_get_new_crtc_state(state, crtc);
-	const struct drm_display_mode *adjusted_mode = &new_crtc_state->hw.adjusted_mode;
+	const struct intel_crtc_state *crtc_state;
+	const struct drm_display_mode *adjusted_mode;
 
-	if (new_crtc_state->vrr.enable) {
-		if (intel_vrr_is_push_sent(new_crtc_state))
-			*vblank_start = intel_vrr_vmin_vblank_start(new_crtc_state);
+	/*
+	 * During fastsets/etc. the transcoder is still
+	 * running with the old timings at this point.
+	 *
+	 * TODO: maybe just use the active timings here?
+	 */
+	if (intel_crtc_needs_modeset(new_crtc_state))
+		crtc_state = new_crtc_state;
+	else
+		crtc_state = old_crtc_state;
+
+	adjusted_mode = &crtc_state->hw.adjusted_mode;
+
+	if (crtc->mode_flags & I915_MODE_FLAG_VRR) {
+		if (intel_vrr_is_push_sent(crtc_state))
+			*vblank_start = intel_vrr_vmin_vblank_start(crtc_state);
 		else
-			*vblank_start = intel_vrr_vmax_vblank_start(new_crtc_state);
+			*vblank_start = intel_vrr_vmax_vblank_start(crtc_state);
 	} else {
 		*vblank_start = intel_mode_vblank_start(adjusted_mode);
 	}
@@ -712,15 +728,6 @@ void intel_pipe_update_end(struct intel_atomic_state *state,
 	 */
 	intel_vrr_send_push(new_crtc_state);
 
-	/*
-	 * Seamless M/N update may need to update frame timings.
-	 *
-	 * FIXME Should be synchronized with the start of vblank somehow...
-	 */
-	if (new_crtc_state->seamless_m_n && intel_crtc_needs_fastset(new_crtc_state))
-		intel_crtc_update_active_timings(new_crtc_state,
-						 new_crtc_state->vrr.enable);
-
 	local_irq_enable();
 
 	if (intel_vgpu_active(dev_priv))
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index af93761e82cac..39efd67cc3232 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -6533,6 +6533,8 @@ static void commit_pipe_post_planes(struct intel_atomic_state *state,
 				    struct intel_crtc *crtc)
 {
 	struct drm_i915_private *dev_priv = to_i915(state->base.dev);
+	const struct intel_crtc_state *old_crtc_state =
+		intel_atomic_get_old_crtc_state(state, crtc);
 	const struct intel_crtc_state *new_crtc_state =
 		intel_atomic_get_new_crtc_state(state, crtc);
 
@@ -6544,6 +6546,9 @@ static void commit_pipe_post_planes(struct intel_atomic_state *state,
 	if (DISPLAY_VER(dev_priv) >= 9 &&
 	    !intel_crtc_needs_modeset(new_crtc_state))
 		skl_detach_scalers(new_crtc_state);
+
+	if (vrr_enabling(old_crtc_state, new_crtc_state))
+		intel_vrr_enable(new_crtc_state);
 }
 
 static void intel_enable_crtc(struct intel_atomic_state *state,
@@ -6584,12 +6589,6 @@ static void intel_update_crtc(struct intel_atomic_state *state,
 			intel_dpt_configure(crtc);
 	}
 
-	if (vrr_enabling(old_crtc_state, new_crtc_state)) {
-		intel_vrr_enable(new_crtc_state);
-		intel_crtc_update_active_timings(new_crtc_state,
-						 new_crtc_state->vrr.enable);
-	}
-
 	if (!modeset) {
 		if (new_crtc_state->preload_luts &&
 		    intel_crtc_needs_color_update(new_crtc_state))
@@ -6626,6 +6625,16 @@ static void intel_update_crtc(struct intel_atomic_state *state,
 
 	intel_pipe_update_end(state, crtc);
 
+	/*
+	 * VRR/Seamless M/N update may need to update frame timings.
+	 *
+	 * FIXME Should be synchronized with the start of vblank somehow...
+	 */
+	if (vrr_enabling(old_crtc_state, new_crtc_state) ||
+	    (new_crtc_state->seamless_m_n && intel_crtc_needs_fastset(new_crtc_state)))
+		intel_crtc_update_active_timings(new_crtc_state,
+						 new_crtc_state->vrr.enable);
+
 	/*
 	 * We usually enable FIFO underrun interrupts as part of the
 	 * CRTC enable sequence during modesets.  But when we inherit a
-- 
2.43.0



