Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0611B423A89;
	Tue, 31 Mar 2026 16:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976125; cv=none; b=Q+j2aiy8L2OQ0SvC34G/eSoyfLk3ag5bwfAZvDqnJQFBlCqjpwywOewN5+D9rslbEzzQTnPmkxz+oEwCrCmrFohsTe12xIGrb1xjPz2IPBPrcrm7q1Jqv+kQpGFvA+qXJs9+sN7S7TRTTOKjMLkUjdqyEsRss7tcIQ/g3xjztq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976125; c=relaxed/simple;
	bh=hDtnEAoj1DfLSCBxm7FyAmm37kh9Ha2AXOVuw8tGP+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RZ4cDgp4NeVD1aosA5kK+L05rxtSptVI9aMj9Dv6orLy8e//IYJkS07ghmNRl9b4HhHn2fV3OIEWueKA+HiTt8mrInzFt2zxR864/tOaXXZZg/YKAPLPEqdHi5b5rQ0o16LStu3R3FIQMZRZQFkVkT90xmzx9XG7JXo7CovBZds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPY00zcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPY00zcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F0CC19423;
	Tue, 31 Mar 2026 16:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976124;
	bh=hDtnEAoj1DfLSCBxm7FyAmm37kh9Ha2AXOVuw8tGP+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPY00zcNp9+7c4A7XnpuDc+2SLXcmauJhZ/j7Xt9gA4Rz7V/g9jBAbIAA1g27hO/M
	 AYcSrptpz4OJw0TNCUfaFw0bJi5HBjbroGynawL5MbqzklYd3T13Fx2aRVW0DoJX6Y
	 480oiVJdSJiFluwQlGJU3lDDas6qw0Dd0ZB0uTrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uma Shankar <uma.shankar@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	=?UTF-8?q?Micha=C5=82=20Grzelak?= <michal.grzelak@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.12 173/244] drm/i915/dp_tunnel: Fix error handling when clearing stream BW in atomic state
Date: Tue, 31 Mar 2026 18:22:03 +0200
Message-ID: <20260331161748.147451621@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Imre Deak <imre.deak@intel.com>

commit 77fcf58df15edcf3f5b5421f24814fb72796def9 upstream.

Clearing the DP tunnel stream BW in the atomic state involves getting
the tunnel group state, which can fail. Handle the error accordingly.

This fixes at least one issue where drm_dp_tunnel_atomic_set_stream_bw()
failed to get the tunnel group state returning -EDEADLK, which wasn't
handled. This lead to the ctx->contended warn later in modeset_lock()
while taking a WW mutex for another object in the same atomic state, and
thus within the same already contended WW context.

Moving intel_crtc_state_alloc() later would avoid freeing saved_state on
the error path; this stable patch leaves that simplification for a
follow-up.

Cc: Uma Shankar <uma.shankar@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v6.9+
Fixes: a4efae87ecb2 ("drm/i915/dp: Compute DP tunnel BW during encoder state computation")
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/7617
Reviewed-by: Michał Grzelak <michal.grzelak@intel.com>
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patch.msgid.link/20260320092900.13210-1-imre.deak@intel.com
(cherry picked from commit fb69d0076e687421188bc8103ab0e8e5825b1df1)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display.c   |    8 +++++++-
 drivers/gpu/drm/i915/display/intel_dp_tunnel.c |   20 ++++++++++++++------
 drivers/gpu/drm/i915/display/intel_dp_tunnel.h |   11 +++++++----
 3 files changed, 28 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -4588,6 +4588,7 @@ intel_crtc_prepare_cleared_state(struct
 		intel_atomic_get_new_crtc_state(state, crtc);
 	struct drm_i915_private *dev_priv = to_i915(crtc->base.dev);
 	struct intel_crtc_state *saved_state;
+	int err;
 
 	saved_state = intel_crtc_state_alloc(crtc);
 	if (!saved_state)
@@ -4596,7 +4597,12 @@ intel_crtc_prepare_cleared_state(struct
 	/* free the old crtc_state->hw members */
 	intel_crtc_free_hw_state(crtc_state);
 
-	intel_dp_tunnel_atomic_clear_stream_bw(state, crtc_state);
+	err = intel_dp_tunnel_atomic_clear_stream_bw(state, crtc_state);
+	if (err) {
+		kfree(saved_state);
+
+		return err;
+	}
 
 	/* FIXME: before the switch to atomic started, a new pipe_config was
 	 * kzalloc'd. Code that depends on any field being zero should be
--- a/drivers/gpu/drm/i915/display/intel_dp_tunnel.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_tunnel.c
@@ -622,19 +622,27 @@ int intel_dp_tunnel_atomic_compute_strea
  *
  * Clear any DP tunnel stream BW requirement set by
  * intel_dp_tunnel_atomic_compute_stream_bw().
+ *
+ * Returns 0 in case of success, a negative error code otherwise.
  */
-void intel_dp_tunnel_atomic_clear_stream_bw(struct intel_atomic_state *state,
-					    struct intel_crtc_state *crtc_state)
+int intel_dp_tunnel_atomic_clear_stream_bw(struct intel_atomic_state *state,
+					   struct intel_crtc_state *crtc_state)
 {
 	struct intel_crtc *crtc = to_intel_crtc(crtc_state->uapi.crtc);
+	int err;
 
 	if (!crtc_state->dp_tunnel_ref.tunnel)
-		return;
+		return 0;
+
+	err = drm_dp_tunnel_atomic_set_stream_bw(&state->base,
+						 crtc_state->dp_tunnel_ref.tunnel,
+						 crtc->pipe, 0);
+	if (err)
+		return err;
 
-	drm_dp_tunnel_atomic_set_stream_bw(&state->base,
-					   crtc_state->dp_tunnel_ref.tunnel,
-					   crtc->pipe, 0);
 	drm_dp_tunnel_ref_put(&crtc_state->dp_tunnel_ref);
+
+	return 0;
 }
 
 /**
--- a/drivers/gpu/drm/i915/display/intel_dp_tunnel.h
+++ b/drivers/gpu/drm/i915/display/intel_dp_tunnel.h
@@ -39,8 +39,8 @@ int intel_dp_tunnel_atomic_compute_strea
 					     struct intel_dp *intel_dp,
 					     const struct intel_connector *connector,
 					     struct intel_crtc_state *crtc_state);
-void intel_dp_tunnel_atomic_clear_stream_bw(struct intel_atomic_state *state,
-					    struct intel_crtc_state *crtc_state);
+int intel_dp_tunnel_atomic_clear_stream_bw(struct intel_atomic_state *state,
+					   struct intel_crtc_state *crtc_state);
 
 int intel_dp_tunnel_atomic_add_state_for_crtc(struct intel_atomic_state *state,
 					      struct intel_crtc *crtc);
@@ -87,9 +87,12 @@ intel_dp_tunnel_atomic_compute_stream_bw
 	return 0;
 }
 
-static inline void
+static inline int
 intel_dp_tunnel_atomic_clear_stream_bw(struct intel_atomic_state *state,
-				       struct intel_crtc_state *crtc_state) {}
+				       struct intel_crtc_state *crtc_state)
+{
+	return 0;
+}
 
 static inline int
 intel_dp_tunnel_atomic_add_state_for_crtc(struct intel_atomic_state *state,


