Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D681779B1;
	Tue,  8 Oct 2024 12:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391199; cv=none; b=Gpe0Nu+3gUrC+XQ991BQlTNdl+M924v1p8stVGcLQL3dqqB9xiaed/dKIiWCefHW3E2eUV3zmNe6XJh6/HhukGhOrfDfyX8h2R1TDj+KmQCtgOHPgj7iiNHxRAiibywXo9IoPsPR0InYxbow6r2ldJ7uxWj3DVMo6sAjoGgxKC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391199; c=relaxed/simple;
	bh=jdkWzGnCG+nLtCohRn9xfLki8qzM5VsqjiLDeL9Mh1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsXWOyJY+D/6OW6vZrpgsjIoLjzrG95Ib9lLV4l69AEZfNEYtwYBSU9+nkNDm19bu8wjMZKagmI2MqAbQgqG6KTIzoL+iFKlQB8/hW57N4WD7GBzHlbjFUoWhNWpUY124ZNZMfPj1d8TfBfARd3tUhsNyMF5jb03pdDnHZlvoK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvYFjtW0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvYFjtW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B2CC4CEC7;
	Tue,  8 Oct 2024 12:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391198;
	bh=jdkWzGnCG+nLtCohRn9xfLki8qzM5VsqjiLDeL9Mh1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvYFjtW0NH6nKICWnuunF8j/1t3lJW452qtmhvyj17Jyr6GfETF3xOEPARokGb09j
	 0U54wzJYrgD6wLYI3sYq3rZExNTSLSPf+S8GHzlI1HvINoWf2Rp11coXTO1smM6U9J
	 xcJ18LCbqOElSGnNV/J9D3GXN/I1DvOaVIs9leVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Animesh Manna <animesh.manna@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 008/558] drm/i915/dp: Fix AUX IO power enabling for eDP PSR
Date: Tue,  8 Oct 2024 14:00:38 +0200
Message-ID: <20241008115702.549621423@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit ec2231b8dd2dc515912ff7816c420153b4a95e92 ]

Panel Self Refresh on eDP requires the AUX IO power to be enabled
whenever the output (main link) is enabled. This is required by the
AUX_PHY_WAKE/ML_PHY_LOCK signaling initiated by the HW automatically to
re-enable the main link after it got disabled in power saving states
(see eDP v1.4b, sections 5.1, 6.1.3.3.1.1).

The Panel Replay mode on non-eDP outputs on the other hand is only
supported by keeping the main link active, thus not requiring the above
AUX_PHY_WAKE/ML_PHY_LOCK signaling (eDP v1.4b, section 6.1.3.3.1.2).
Thus enabling the AUX IO power for this case is not required either.

Based on the above enable the AUX IO power only for eDP/PSR outputs.

Bspec: 49274, 53370

v2:
- Add a TODO comment to adjust the requirement for AUX IO based on
  whether the ALPM/main-link off mode gets enabled. (Rodrigo)

Cc: Animesh Manna <animesh.manna@intel.com>
Fixes: b8cf5b5d266e ("drm/i915/panelreplay: Initializaton and compute config for panel replay")
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240910111847.2995725-1-imre.deak@intel.com
(cherry picked from commit f7c2ed9d4ce80a2570c492825de239dc8b500f2e)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_ddi.c |  2 +-
 drivers/gpu/drm/i915/display/intel_psr.c | 19 +++++++++++++++++++
 drivers/gpu/drm/i915/display/intel_psr.h |  2 ++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index a07aca96e5517..5b6aabce4c32f 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -916,7 +916,7 @@ intel_ddi_main_link_aux_domain(struct intel_digital_port *dig_port,
 	 * instead of a specific AUX_IO_<port> reference without powering up any
 	 * extra wells.
 	 */
-	if (intel_encoder_can_psr(&dig_port->base))
+	if (intel_psr_needs_aux_io_power(&dig_port->base, crtc_state))
 		return intel_display_power_aux_io_domain(i915, dig_port->aux_ch);
 	else if (DISPLAY_VER(i915) < 14 &&
 		 (intel_crtc_has_dp_encoder(crtc_state) ||
diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index d404ad93e91c7..da242ba19ed95 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -203,6 +203,25 @@ bool intel_encoder_can_psr(struct intel_encoder *encoder)
 		return false;
 }
 
+bool intel_psr_needs_aux_io_power(struct intel_encoder *encoder,
+				  const struct intel_crtc_state *crtc_state)
+{
+	/*
+	 * For PSR/PR modes only eDP requires the AUX IO power to be enabled whenever
+	 * the output is enabled. For non-eDP outputs the main link is always
+	 * on, hence it doesn't require the HW initiated AUX wake-up signaling used
+	 * for eDP.
+	 *
+	 * TODO:
+	 * - Consider leaving AUX IO disabled for eDP / PR as well, in case
+	 *   the ALPM with main-link off mode is not enabled.
+	 * - Leave AUX IO enabled for DP / PR, once support for ALPM with
+	 *   main-link off mode is added for it and this mode gets enabled.
+	 */
+	return intel_crtc_has_type(crtc_state, INTEL_OUTPUT_EDP) &&
+	       intel_encoder_can_psr(encoder);
+}
+
 static bool psr_global_enabled(struct intel_dp *intel_dp)
 {
 	struct intel_connector *connector = intel_dp->attached_connector;
diff --git a/drivers/gpu/drm/i915/display/intel_psr.h b/drivers/gpu/drm/i915/display/intel_psr.h
index d483c85870e1d..e719f548e1606 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.h
+++ b/drivers/gpu/drm/i915/display/intel_psr.h
@@ -25,6 +25,8 @@ struct intel_plane_state;
 				    (intel_dp)->psr.source_panel_replay_support)
 
 bool intel_encoder_can_psr(struct intel_encoder *encoder);
+bool intel_psr_needs_aux_io_power(struct intel_encoder *encoder,
+				  const struct intel_crtc_state *crtc_state);
 void intel_psr_init_dpcd(struct intel_dp *intel_dp);
 void intel_psr_enable_sink(struct intel_dp *intel_dp,
 			   const struct intel_crtc_state *crtc_state);
-- 
2.43.0



