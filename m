Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45BE1A255D;
	Thu,  6 Jun 2024 14:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683750; cv=none; b=Kl3o4nhL6dOHrNJ0kW2KXCiAeuPQ1RARzcof/mUfoaknRG6A63xLJU8Cc5eYEa4j3pZJK7Nvg4YVm8LA8p2nyikwcxC7oucJYJJ0agfipKeuiGWf8T17PdKSok/hILpyqr5Cz7VfGNWvQRencxj9A+h2sa8kib9rvIz2i4AKH+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683750; c=relaxed/simple;
	bh=m9kJazNci5XIxePLyL7Lwa2WrfOz5L2swMUSJ93M74c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQ7uo7t5D7eH02t0n2Ke1jfnYdL6QvHT/mk43izTaKO5pOFeVIUmA9vmW9nQMbMf6ShkZMfG38bji3/Jotfnl9sm8paW10emjazkCW9oAL3Ktm4sd5QXz3T9WoKG3SyU85XZ6G5DV8o2Xd1n7hHS8NOjNsO7oCfCHsuv+6t8ATI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCrTAKu9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCrTAKu9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D06C2BD10;
	Thu,  6 Jun 2024 14:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683750;
	bh=m9kJazNci5XIxePLyL7Lwa2WrfOz5L2swMUSJ93M74c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JCrTAKu94J+VhXZJT2RcemqmvnyOrjcOX661dFyU6N8/OERFwlnZLXJZTA4hk8Y7+
	 Me/lEwpc0jwSZTAFi1ZUbdvzIHY40B3LQmDIe/GY4XzKh2sfgmoKleSgKqf4Mx/XZe
	 htNRglWE4euiKgtDAlL65REmmcw4tguiYDQTA6Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Chris Wilson <chris.p.wilson@linux.intel.com>,
	Gnattu OC <gnattuoc@me.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Jian Ye <jian.ye@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 719/744] drm/i915/gt: Fix CCS ids calculation for CCS mode setting
Date: Thu,  6 Jun 2024 16:06:31 +0200
Message-ID: <20240606131755.527882830@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Shyti <andi.shyti@linux.intel.com>

[ Upstream commit ee01b6a386eaf9984b58a2476e8f531149679da9 ]

The whole point of the previous fixes has been to change the CCS
hardware configuration to generate only one stream available to
the compute users. We did this by changing the info.engine_mask
that is set during device probe, reset during the detection of
the fused engines, and finally reset again when choosing the CCS
mode.

We can't use the engine_mask variable anymore, as with the
current configuration, it imposes only one CCS no matter what the
hardware configuration is.

Before changing the engine_mask for the third time, save it and
use it for calculating the CCS mode.

After the previous changes, the user reported a performance drop
to around 1/4. We have tested that the compute operations, with
the current patch, have improved by the same factor.

Fixes: 6db31251bb26 ("drm/i915/gt: Enable only one CCS for compute workload")
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Chris Wilson <chris.p.wilson@linux.intel.com>
Cc: Gnattu OC <gnattuoc@me.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Tested-by: Jian Ye <jian.ye@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Tested-by: Gnattu OC <gnattuoc@me.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240517090616.242529-1-andi.shyti@linux.intel.com
(cherry picked from commit a09d2327a9ba8e3f5be238bc1b7ca2809255b464)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_cs.c   | 6 ++++++
 drivers/gpu/drm/i915/gt/intel_gt_ccs_mode.c | 2 +-
 drivers/gpu/drm/i915/gt/intel_gt_types.h    | 8 ++++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index 765387639dabb..d9bb352b8baab 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -923,6 +923,12 @@ static intel_engine_mask_t init_engine_mask(struct intel_gt *gt)
 	if (IS_DG2(gt->i915)) {
 		u8 first_ccs = __ffs(CCS_MASK(gt));
 
+		/*
+		 * Store the number of active cslices before
+		 * changing the CCS engine configuration
+		 */
+		gt->ccs.cslices = CCS_MASK(gt);
+
 		/* Mask off all the CCS engine */
 		info->engine_mask &= ~GENMASK(CCS3, CCS0);
 		/* Put back in the first CCS engine */
diff --git a/drivers/gpu/drm/i915/gt/intel_gt_ccs_mode.c b/drivers/gpu/drm/i915/gt/intel_gt_ccs_mode.c
index 99b71bb7da0a6..3c62a44e9106c 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_ccs_mode.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_ccs_mode.c
@@ -19,7 +19,7 @@ unsigned int intel_gt_apply_ccs_mode(struct intel_gt *gt)
 
 	/* Build the value for the fixed CCS load balancing */
 	for (cslice = 0; cslice < I915_MAX_CCS; cslice++) {
-		if (CCS_MASK(gt) & BIT(cslice))
+		if (gt->ccs.cslices & BIT(cslice))
 			/*
 			 * If available, assign the cslice
 			 * to the first available engine...
diff --git a/drivers/gpu/drm/i915/gt/intel_gt_types.h b/drivers/gpu/drm/i915/gt/intel_gt_types.h
index def7dd0eb6f19..cfdd2ad5e9549 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt_types.h
@@ -207,6 +207,14 @@ struct intel_gt {
 					    [MAX_ENGINE_INSTANCE + 1];
 	enum intel_submission_method submission_method;
 
+	struct {
+		/*
+		 * Mask of the non fused CCS slices
+		 * to be used for the load balancing
+		 */
+		intel_engine_mask_t cslices;
+	} ccs;
+
 	/*
 	 * Default address space (either GGTT or ppGTT depending on arch).
 	 *
-- 
2.43.0



