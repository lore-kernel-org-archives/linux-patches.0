Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE01252908;
	Wed,  5 Mar 2025 17:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197292; cv=none; b=IV9HIBUnXjfvH9opRRqDHUj06zTxMOwmkZ8+jewo/DrBMXRiETTju27EEqpS+QMeDyywf1pWCfntkYNJqP+t/fF7yRu4IPJE/yy0NO1B0nRif0Pw+V7xkkIOFuaOCkC8rgZWdBnHnbodx0wKdh50jUdBxC32IGOmy0DP508I4aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197292; c=relaxed/simple;
	bh=R5V8ucSDUEiz2C0ECwPU7q4jb88MemiNBqAmKiSzoGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hQeHeGYjbZoL/LG31OkKDp6plse3Ue40tjcXT3ugHaPTkmiqnJTMHPQTCYVy9PTWfG3pJLHO526fq92reieqETAg2DnpTsg/n58p80eURcEKnlHJuwQ4ESlZzHlLnZbVK8IFXAjwtFXKZdWlfkS7CR3cuhsRZm6xN/P7walRngM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzUakfbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzUakfbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F781C4CEE0;
	Wed,  5 Mar 2025 17:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197291;
	bh=R5V8ucSDUEiz2C0ECwPU7q4jb88MemiNBqAmKiSzoGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzUakfbQ/PQnkfxibqNEH7dr0DI9yqRTt5mwSTLTq5f9RvTynehw7AxsCeUCkO17S
	 Z1N0+7cs1v15M6ceG61+qox3vH6emB5pAY4tjGbzuD2HUmu0cnSiW+hpmmbt0HHu+I
	 4suRLzV7BRndy4sLnnIL7k0PlohblSbkgGnaAOCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 073/176] drm/i915: Make sure all planes in use by the joiner have their crtc included
Date: Wed,  5 Mar 2025 18:47:22 +0100
Message-ID: <20250305174508.393175654@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 07fb70d82e0df085980246bf17bc12537588795f upstream.

Any active plane needs to have its crtc included in the atomic
state. For planes enabled via uapi that is all handler in the core.
But when we use a plane for joiner the uapi code things the plane
is disabled and therefore doesn't have a crtc. So we need to pull
those in by hand. We do it first thing in
intel_joiner_add_affected_crtcs() so that any newly added crtc will
subsequently pull in all of its joined crtcs as well.

The symptoms from failing to do this are:
- duct tape in the form of commit 1d5b09f8daf8 ("drm/i915: Fix NULL
  ptr deref by checking new_crtc_state")
- the plane's hw state will get overwritten by the disabled
  uapi state if it can't find the uapi counterpart plane in
  the atomic state from where it should copy the correct state

Cc: stable@vger.kernel.org
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250212164330.16891-2-ville.syrjala@linux.intel.com
(cherry picked from commit 91077d1deb5374eb8be00fb391710f00e751dc4b)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -6691,12 +6691,30 @@ static int intel_async_flip_check_hw(str
 static int intel_bigjoiner_add_affected_crtcs(struct intel_atomic_state *state)
 {
 	struct drm_i915_private *i915 = to_i915(state->base.dev);
+	const struct intel_plane_state *plane_state;
 	struct intel_crtc_state *crtc_state;
+	struct intel_plane *plane;
 	struct intel_crtc *crtc;
 	u8 affected_pipes = 0;
 	u8 modeset_pipes = 0;
 	int i;
 
+	/*
+	 * Any plane which is in use by the joiner needs its crtc.
+	 * Pull those in first as this will not have happened yet
+	 * if the plane remains disabled according to uapi.
+	 */
+	for_each_new_intel_plane_in_state(state, plane, plane_state, i) {
+		crtc = to_intel_crtc(plane_state->hw.crtc);
+		if (!crtc)
+			continue;
+
+		crtc_state = intel_atomic_get_crtc_state(&state->base, crtc);
+		if (IS_ERR(crtc_state))
+			return PTR_ERR(crtc_state);
+	}
+
+	/* Now pull in all joined crtcs */
 	for_each_new_intel_crtc_in_state(state, crtc, crtc_state, i) {
 		affected_pipes |= crtc_state->bigjoiner_pipes;
 		if (intel_crtc_needs_modeset(crtc_state))


