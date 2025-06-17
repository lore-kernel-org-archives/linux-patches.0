Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB842E92CD;
	Tue, 17 Jun 2025 16:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176074; cv=none; b=qK5usqaAdAqKu6wbJEMkZgI0KmTuWpBq34qObZfQwizUhL3sVLiY3DGf/4ETCBdhNH5X0D4r2vTnPhfy+1R7SpCO7vTGu7/f2RhL8rI2d2ft6q7+YDnbmnxZucnWF9imNmgYHPYN+mEqhmj1p8hNd2WVfPJPL/T3aHfos6zRxwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176074; c=relaxed/simple;
	bh=3v4tjjxXokqGuypTDdXzzPI6KuHSuQXGEqKq6dYvubg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9D3v0+PYuCnGZJJ/InsIukkG3yYFTbPMo1Dx2exS64IaQBf1/XRNGYt1o8hfpkz6Wk9Dm7bLufo1TbiLaUA9xE8FHsnAiXO4jAG090CZVbDR13K5/LLQgW3CuKuYK6tlhX9rkAO7Rr27YL/hb7Jyp80JRAYW6FZS+6hNvelCcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSItWsZ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSItWsZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4868BC4CEE3;
	Tue, 17 Jun 2025 16:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176074;
	bh=3v4tjjxXokqGuypTDdXzzPI6KuHSuQXGEqKq6dYvubg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSItWsZ1UVNUHX6QxS1wFzxX0g6sDIHC1rF4lB+v7L+/3mAyGZ5R1695xYS8o7p7z
	 SVi5Z1vOSCUaTS/+Pnlr/34mOKOdT/0YYvFqWtZRK/4RwgoEGR32rA9pvyPaKHwFLh
	 CrjrYWDPMwiVktnlTqboaI34oov7nFqT2X3Nkm10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 149/780] drm/i915/dp_mst: Use the correct connector while computing the link BPP limit on MST
Date: Tue, 17 Jun 2025 17:17:37 +0200
Message-ID: <20250617152457.572680077@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit a92e390e0d438e021de0e52065121484b6cca675 ]

Atm, on an MST link in DSC mode
intel_dp_compute_config_link_bpp_limits() calculates the maximum link
bpp limit using the MST root connector's DSC capabilities. That's not
correct in general: the decompression could be performed by a branch
device downstream of the root branch device or the sink itself.

Fix the above by passing to intel_dp_compute_config_link_bpp_limits()
the actual connector being modeset, containing the correct DSC
capabilities.

Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Fixes: 1c5b72daff46 ("drm/i915/dp: Set the DSC link limits in intel_dp_compute_config_link_bpp_limits")
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://lore.kernel.org/r/20250509180340.554867-2-imre.deak@intel.com
(cherry picked from commit 266e2fcfe2ea0d062ea392cd22f6250ae0d11c04)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c     | 7 ++++---
 drivers/gpu/drm/i915/display/intel_dp.h     | 1 +
 drivers/gpu/drm/i915/display/intel_dp_mst.c | 5 +++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 392c3653d0d73..cd8f728d5fddc 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -2523,6 +2523,7 @@ intel_dp_dsc_compute_pipe_bpp_limits(struct intel_dp *intel_dp,
 
 bool
 intel_dp_compute_config_limits(struct intel_dp *intel_dp,
+			       struct intel_connector *connector,
 			       struct intel_crtc_state *crtc_state,
 			       bool respect_downstream_limits,
 			       bool dsc,
@@ -2576,7 +2577,7 @@ intel_dp_compute_config_limits(struct intel_dp *intel_dp,
 	intel_dp_test_compute_config(intel_dp, crtc_state, limits);
 
 	return intel_dp_compute_config_link_bpp_limits(intel_dp,
-						       intel_dp->attached_connector,
+						       connector,
 						       crtc_state,
 						       dsc,
 						       limits);
@@ -2637,7 +2638,7 @@ intel_dp_compute_link_config(struct intel_encoder *encoder,
 	joiner_needs_dsc = intel_dp_joiner_needs_dsc(display, num_joined_pipes);
 
 	dsc_needed = joiner_needs_dsc || intel_dp->force_dsc_en ||
-		     !intel_dp_compute_config_limits(intel_dp, pipe_config,
+		     !intel_dp_compute_config_limits(intel_dp, connector, pipe_config,
 						     respect_downstream_limits,
 						     false,
 						     &limits);
@@ -2671,7 +2672,7 @@ intel_dp_compute_link_config(struct intel_encoder *encoder,
 			    str_yes_no(ret), str_yes_no(joiner_needs_dsc),
 			    str_yes_no(intel_dp->force_dsc_en));
 
-		if (!intel_dp_compute_config_limits(intel_dp, pipe_config,
+		if (!intel_dp_compute_config_limits(intel_dp, connector, pipe_config,
 						    respect_downstream_limits,
 						    true,
 						    &limits))
diff --git a/drivers/gpu/drm/i915/display/intel_dp.h b/drivers/gpu/drm/i915/display/intel_dp.h
index 9189db4c25946..98f90955fdb1d 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.h
+++ b/drivers/gpu/drm/i915/display/intel_dp.h
@@ -194,6 +194,7 @@ void intel_dp_wait_source_oui(struct intel_dp *intel_dp);
 int intel_dp_output_bpp(enum intel_output_format output_format, int bpp);
 
 bool intel_dp_compute_config_limits(struct intel_dp *intel_dp,
+				    struct intel_connector *connector,
 				    struct intel_crtc_state *crtc_state,
 				    bool respect_downstream_limits,
 				    bool dsc,
diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index 6dc2d31ccb5a5..fe685f098ba9a 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -590,12 +590,13 @@ adjust_limits_for_dsc_hblank_expansion_quirk(struct intel_dp *intel_dp,
 
 static bool
 mst_stream_compute_config_limits(struct intel_dp *intel_dp,
-				 const struct intel_connector *connector,
+				 struct intel_connector *connector,
 				 struct intel_crtc_state *crtc_state,
 				 bool dsc,
 				 struct link_config_limits *limits)
 {
-	if (!intel_dp_compute_config_limits(intel_dp, crtc_state, false, dsc,
+	if (!intel_dp_compute_config_limits(intel_dp, connector,
+					    crtc_state, false, dsc,
 					    limits))
 		return false;
 
-- 
2.39.5



