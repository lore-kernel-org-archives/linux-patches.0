Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6715B14EC77;
	Wed,  5 Feb 2025 14:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764021; cv=none; b=Kt85PhJZycAK4swVoiQ7NBxGxo9/sFOLQswCdKTb8xm2lU3T51DoTIr7xrz+g1efAyRPd1WyOIKlapFcqGsObXJdNAV8BWXWBhHsuDT8XYChYrwGsfoQPxX9p/yCQDPT8m1Mz10bxM97u/7mMT9tiPocweejiU8kg2ENvhxg7bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764021; c=relaxed/simple;
	bh=7htLj/aH+/RZhpdG0QBAHElZ3By77dUWxRdn5eP658M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JFszzJhDP2810Vj8BylkASxtYncgiJTbaBLE+cfkTMR7nE0ZP5IxXhBD3kobX4nceRVgjDBmd/elHWYKGaEraweC1F3XKdFYHAWVgVTRtfnTkgRGOevxs5wLnJGFV61g/MmR4Y6+7sCzV77C52HqDSdKE/zN3hiWbzQY2CNpfQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIMOBZ2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIMOBZ2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8991C4CED1;
	Wed,  5 Feb 2025 14:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764021;
	bh=7htLj/aH+/RZhpdG0QBAHElZ3By77dUWxRdn5eP658M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIMOBZ2avAtShc1EVVukZlNF5yrc5MxIV9hu721P5dd4WZr5XQlXtpgAkGppDwW9Y
	 u/giNu4wuwIqK+qJUkYY1cLXkLdIyb6MxIZdSi3+DI6yQK816QiubKnVRhcmXeVpLJ
	 OoIgEdQ4i657wIPjudPXzSrYzkPNIANu57on9BQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 039/623] drm/i915: Grab intel_display from the encoder to avoid potential oopsies
Date: Wed,  5 Feb 2025 14:36:21 +0100
Message-ID: <20250205134457.724613738@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit dc3806d9eb66d0105f8d55d462d4ef681d9eac59 ]

Grab the intel_display from 'encoder' rather than 'state'
in the encoder hooks to avoid the massive footgun that is
intel_sanitize_encoder(), which passes NULL as the 'state'
argument to encoder .disable() and .post_disable().

TODO: figure out how to actually fix intel_sanitize_encoder()...

Fixes: 40eb34c3f491 ("drm/i915/crt: convert to struct intel_display")
Fixes: ab0b0eb5c85c ("drm/i915/tv: convert to struct intel_display")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241107161123.16269-2-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_crt.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_crt.c b/drivers/gpu/drm/i915/display/intel_crt.c
index 74c1983fe07ea..1be55bdb48b96 100644
--- a/drivers/gpu/drm/i915/display/intel_crt.c
+++ b/drivers/gpu/drm/i915/display/intel_crt.c
@@ -244,7 +244,7 @@ static void hsw_disable_crt(struct intel_atomic_state *state,
 			    const struct intel_crtc_state *old_crtc_state,
 			    const struct drm_connector_state *old_conn_state)
 {
-	struct intel_display *display = to_intel_display(state);
+	struct intel_display *display = to_intel_display(encoder);
 	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
 
 	drm_WARN_ON(display->drm, !old_crtc_state->has_pch_encoder);
@@ -257,7 +257,7 @@ static void hsw_post_disable_crt(struct intel_atomic_state *state,
 				 const struct intel_crtc_state *old_crtc_state,
 				 const struct drm_connector_state *old_conn_state)
 {
-	struct intel_display *display = to_intel_display(state);
+	struct intel_display *display = to_intel_display(encoder);
 	struct intel_crtc *crtc = to_intel_crtc(old_crtc_state->uapi.crtc);
 	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
 
@@ -287,7 +287,7 @@ static void hsw_pre_pll_enable_crt(struct intel_atomic_state *state,
 				   const struct intel_crtc_state *crtc_state,
 				   const struct drm_connector_state *conn_state)
 {
-	struct intel_display *display = to_intel_display(state);
+	struct intel_display *display = to_intel_display(encoder);
 	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
 
 	drm_WARN_ON(display->drm, !crtc_state->has_pch_encoder);
@@ -300,7 +300,7 @@ static void hsw_pre_enable_crt(struct intel_atomic_state *state,
 			       const struct intel_crtc_state *crtc_state,
 			       const struct drm_connector_state *conn_state)
 {
-	struct intel_display *display = to_intel_display(state);
+	struct intel_display *display = to_intel_display(encoder);
 	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
 	struct intel_crtc *crtc = to_intel_crtc(crtc_state->uapi.crtc);
 	enum pipe pipe = crtc->pipe;
@@ -319,7 +319,7 @@ static void hsw_enable_crt(struct intel_atomic_state *state,
 			   const struct intel_crtc_state *crtc_state,
 			   const struct drm_connector_state *conn_state)
 {
-	struct intel_display *display = to_intel_display(state);
+	struct intel_display *display = to_intel_display(encoder);
 	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
 	struct intel_crtc *crtc = to_intel_crtc(crtc_state->uapi.crtc);
 	enum pipe pipe = crtc->pipe;
-- 
2.39.5



