Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F97E85274;
	Tue, 23 Apr 2024 21:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908563; cv=none; b=AQoiOw0NeKsJlA+6CKCNRvy/eGoe79jH4nPEUuhSZdxT9YDE4FrsiNA2k4kHhRUbianQwKuOBpBXHjAK7L48G3NTZl8GILnIj/DrBjZRdWqG65AAiQghWBypNpjlLswm3q34ncSeIYrQMyESBixYSl/UcAApvlMmpArM/1//tWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908563; c=relaxed/simple;
	bh=0ZFcTo6ehWh21FS9BJBnC5AY+kvVcRYlkQy1X7ogLh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A+A0Fr+MF9h0yVPcf7n5vizMqOBRDtBP0MPVqqGPvVEOVJZfueRrc0GrBo3AfaHYNnHXfCBqYAcFhwBQ+nazQyKof0WEVZLXswqXpaik/5rCOFfQxeKJiQWGnC4JokVZOBCAMmdHwGTxC988a74UwgFk5GGXEoMmBEmycScbBm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTmeDcev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTmeDcev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8D5C4AF07;
	Tue, 23 Apr 2024 21:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908563;
	bh=0ZFcTo6ehWh21FS9BJBnC5AY+kvVcRYlkQy1X7ogLh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTmeDcevnMqPgkl20ewIZVU7XDdPWTWPAGs35N7TQywci/Le77+Jtjs4LHqKggbEV
	 XFnpiHgAMKQc+Y4LcM5RsuEaxf9SP0HNkj2R8/mKDJsi1UVQqA1w+QWUkxzcGyIx2L
	 mn00+gVjG//Gn5YVhPjue5XaNAfm5ZkXJOP9IkbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manasi Navare <navaremanasi@chromium.org>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/158] drm/i915: Extract intel_crtc_vblank_evade_scanlines()
Date: Tue, 23 Apr 2024 14:37:27 -0700
Message-ID: <20240423213856.051408075@linuxfoundation.org>
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

[ Upstream commit f4b0cece716c95e16d973a774d5a5c5cc8cb335d ]

Pull the vblank evasion scanline calculations into their own helper
to declutter intel_pipe_update_start() a bit.

Reviewed-by: Manasi Navare <navaremanasi@chromium.org>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230901130440.2085-4-ville.syrjala@linux.intel.com
Reviewed-by: Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>
Stable-dep-of: 4a36e46df7aa ("drm/i915: Disable live M/N updates when using bigjoiner")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_crtc.c | 53 +++++++++++++----------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_crtc.c b/drivers/gpu/drm/i915/display/intel_crtc.c
index 65d91c7ad22ff..9693747a18c66 100644
--- a/drivers/gpu/drm/i915/display/intel_crtc.c
+++ b/drivers/gpu/drm/i915/display/intel_crtc.c
@@ -468,6 +468,36 @@ static int intel_mode_vblank_start(const struct drm_display_mode *mode)
 	return vblank_start;
 }
 
+static void intel_crtc_vblank_evade_scanlines(struct intel_atomic_state *state,
+					      struct intel_crtc *crtc,
+					      int *min, int *max, int *vblank_start)
+{
+	const struct intel_crtc_state *new_crtc_state =
+		intel_atomic_get_new_crtc_state(state, crtc);
+	const struct drm_display_mode *adjusted_mode = &new_crtc_state->hw.adjusted_mode;
+
+	if (new_crtc_state->vrr.enable) {
+		if (intel_vrr_is_push_sent(new_crtc_state))
+			*vblank_start = intel_vrr_vmin_vblank_start(new_crtc_state);
+		else
+			*vblank_start = intel_vrr_vmax_vblank_start(new_crtc_state);
+	} else {
+		*vblank_start = intel_mode_vblank_start(adjusted_mode);
+	}
+
+	/* FIXME needs to be calibrated sensibly */
+	*min = *vblank_start - intel_usecs_to_scanlines(adjusted_mode,
+							VBLANK_EVASION_TIME_US);
+	*max = *vblank_start - 1;
+
+	/*
+	 * M/N is double buffered on the transcoder's undelayed vblank,
+	 * so with seamless M/N we must evade both vblanks.
+	 */
+	if (new_crtc_state->seamless_m_n && intel_crtc_needs_fastset(new_crtc_state))
+		*min -= adjusted_mode->crtc_vblank_start - adjusted_mode->crtc_vdisplay;
+}
+
 /**
  * intel_pipe_update_start() - start update of a set of display registers
  * @state: the atomic state
@@ -487,7 +517,6 @@ void intel_pipe_update_start(struct intel_atomic_state *state,
 	struct drm_i915_private *dev_priv = to_i915(crtc->base.dev);
 	struct intel_crtc_state *new_crtc_state =
 		intel_atomic_get_new_crtc_state(state, crtc);
-	const struct drm_display_mode *adjusted_mode = &new_crtc_state->hw.adjusted_mode;
 	long timeout = msecs_to_jiffies_timeout(1);
 	int scanline, min, max, vblank_start;
 	wait_queue_head_t *wq = drm_crtc_vblank_waitqueue(&crtc->base);
@@ -503,27 +532,7 @@ void intel_pipe_update_start(struct intel_atomic_state *state,
 	if (intel_crtc_needs_vblank_work(new_crtc_state))
 		intel_crtc_vblank_work_init(new_crtc_state);
 
-	if (new_crtc_state->vrr.enable) {
-		if (intel_vrr_is_push_sent(new_crtc_state))
-			vblank_start = intel_vrr_vmin_vblank_start(new_crtc_state);
-		else
-			vblank_start = intel_vrr_vmax_vblank_start(new_crtc_state);
-	} else {
-		vblank_start = intel_mode_vblank_start(adjusted_mode);
-	}
-
-	/* FIXME needs to be calibrated sensibly */
-	min = vblank_start - intel_usecs_to_scanlines(adjusted_mode,
-						      VBLANK_EVASION_TIME_US);
-	max = vblank_start - 1;
-
-	/*
-	 * M/N is double buffered on the transcoder's undelayed vblank,
-	 * so with seamless M/N we must evade both vblanks.
-	 */
-	if (new_crtc_state->seamless_m_n && intel_crtc_needs_fastset(new_crtc_state))
-		min -= adjusted_mode->crtc_vblank_start - adjusted_mode->crtc_vdisplay;
-
+	intel_crtc_vblank_evade_scanlines(state, crtc, &min, &max, &vblank_start);
 	if (min <= 0 || max <= 0)
 		goto irq_disable;
 
-- 
2.43.0



