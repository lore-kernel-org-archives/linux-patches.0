Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBB93E2AAD;
	Wed, 20 May 2026 18:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302520; cv=none; b=XLuq8vM6+SAv+pLKNjsAj/Kgp7lrBcta6McGkzWg354aDbwGX7fBnfT4dVjCjk5m+oj3rZmwqNcv9FpmRAdICjo26QatrUrPFHmxcPDua/Fn9S24TvEr8SavdWEW+kiYyhgMa0bKECH5ttr2qixiJyCZ9029PTQKNGEVp9UP9GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302520; c=relaxed/simple;
	bh=I3G534GRBGS/AX2Iwz7AViu+ajCD7qwloZwAue26O1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SX7BYRU7srfG3JHYH2vGUtmcHwWL1tWEDoZEqTMfO9JSNQknZen0lihH55iFs+gTx4tdeaq9xys4YSqCYpYEe2f9XlT6Oj6sVpOHLJYcOOxu0Dnq6t+c4ikGgisp2vWMYUcCINmcnSWPf8qjbnS/zKJHAC72jQML2Qqc0MP1OEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4GX5ylX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4GX5ylX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA2A1F000E9;
	Wed, 20 May 2026 18:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302519;
	bh=h/hBajvDbwye39xt9jtO32/BK4WLJ3lcFhYWRxq941Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4GX5ylXI0/TrvfU1HU9XV0YtSW8ZlxpS8+vkuMCMVaNrz8ADd/a1FiWH6fld3Wx4
	 0QG6pWsNbGdEU8fJ6EcpLbb2Jh3psttG4gSc7m4NNswU9c/p8Yy0yTaYQ2gLr2NvbL
	 LPHdjlY3GZ4gjgpagYN626DZlIWtmsKnTcuovjP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 296/508] drm/i915: Simplify watermark state checker calling convention
Date: Wed, 20 May 2026 18:21:59 +0200
Message-ID: <20260520162105.057773774@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 8f0994d47e89711e654df4e31eabb8881079880a ]

There is never any reason to pass in both the crtc and its state
as one can always dig out the crtc from its state. But for more
consistency across the whole state checker let's just pass the
overall atomic state+crtc here as well.

v2: Also pass state+crtc here (Jani)

Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231005122713.3531-1-ville.syrjala@linux.intel.com
Stable-dep-of: a97c88a176b6 ("drm/i915/wm: Verify the correct plane DDB entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_modeset_verify.c | 2 +-
 drivers/gpu/drm/i915/display/skl_watermark.c        | 8 +++++---
 drivers/gpu/drm/i915/display/skl_watermark.h        | 4 ++--
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_modeset_verify.c b/drivers/gpu/drm/i915/display/intel_modeset_verify.c
index 138144a65a457..6e65b867137e7 100644
--- a/drivers/gpu/drm/i915/display/intel_modeset_verify.c
+++ b/drivers/gpu/drm/i915/display/intel_modeset_verify.c
@@ -234,7 +234,7 @@ void intel_modeset_verify_crtc(struct intel_crtc *crtc,
 	    !intel_crtc_needs_fastset(new_crtc_state))
 		return;
 
-	intel_wm_state_verify(crtc, new_crtc_state);
+	intel_wm_state_verify(state, crtc);
 	verify_connector_state(state, crtc);
 	verify_crtc_state(crtc, old_crtc_state, new_crtc_state);
 	intel_shared_dpll_state_verify(crtc, old_crtc_state, new_crtc_state);
diff --git a/drivers/gpu/drm/i915/display/skl_watermark.c b/drivers/gpu/drm/i915/display/skl_watermark.c
index 8a82576ca0289..d77e598deb2d9 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.c
+++ b/drivers/gpu/drm/i915/display/skl_watermark.c
@@ -3132,10 +3132,12 @@ static void skl_wm_get_hw_state_and_sanitize(struct drm_i915_private *i915)
 	skl_wm_sanitize(i915);
 }
 
-void intel_wm_state_verify(struct intel_crtc *crtc,
-			   const struct intel_crtc_state *new_crtc_state)
+void intel_wm_state_verify(struct intel_atomic_state *state,
+			   struct intel_crtc *crtc)
 {
-	struct drm_i915_private *i915 = to_i915(crtc->base.dev);
+	struct drm_i915_private *i915 = to_i915(state->base.dev);
+	const struct intel_crtc_state *new_crtc_state =
+		intel_atomic_get_new_crtc_state(state, crtc);
 	struct skl_hw_state {
 		struct skl_ddb_entry ddb[I915_MAX_PLANES];
 		struct skl_ddb_entry ddb_y[I915_MAX_PLANES];
diff --git a/drivers/gpu/drm/i915/display/skl_watermark.h b/drivers/gpu/drm/i915/display/skl_watermark.h
index 3aa138d387900..c7de2b3b2f915 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.h
+++ b/drivers/gpu/drm/i915/display/skl_watermark.h
@@ -38,8 +38,8 @@ bool skl_ddb_allocation_overlaps(const struct skl_ddb_entry *ddb,
 				 const struct skl_ddb_entry *entries,
 				 int num_entries, int ignore_idx);
 
-void intel_wm_state_verify(struct intel_crtc *crtc,
-			   const struct intel_crtc_state *new_crtc_state);
+void intel_wm_state_verify(struct intel_atomic_state *state,
+			   struct intel_crtc *crtc);
 
 void skl_watermark_ipc_init(struct drm_i915_private *i915);
 void skl_watermark_ipc_update(struct drm_i915_private *i915);
-- 
2.53.0



