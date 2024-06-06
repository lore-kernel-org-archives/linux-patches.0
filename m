Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0816F198E6D;
	Thu,  6 Jun 2024 14:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683076; cv=none; b=n8CkuLNNQlTTXWypndvM1favXQVJO5kXDuWBr52oLM90OeIgPSg6vQdriXygh4xqt+1IRNKx0ya2waqEVpWx3/4yzxy0N8MkjUjp3gqIlbnIg/5OcR/Sijy3oNILCOjmUuX+FchGsVrLSdiPinYqkQjazYs68EAcwcu4BweeiSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683076; c=relaxed/simple;
	bh=4y3xkhq0RBzy2frkm7kloxkOs3Q3J05VwsXzVmQzYk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbpI7p/f7yXJKN6HYymx+dl/yBDnAb+GovLw9HV+8X+kuBN9Vq57qpGopExK0mAKB2miWy1O40ODgWJakDMResqqtH8Lj0EDDOdHqngG3F9bf1LZNMFGTBS1K1SvwgQhr6AzVddxdptdDoSCHpMdenVRgp7yKl0sQoI5t3FiRhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtp2K064; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtp2K064"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EBDC32786;
	Thu,  6 Jun 2024 14:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683075;
	bh=4y3xkhq0RBzy2frkm7kloxkOs3Q3J05VwsXzVmQzYk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gtp2K064e+1PzyvEOTyKiJOb1n1Qha13TBhOI9Mv1klK6QrPSxwgwzZNsXxmuNEAG
	 +r0fhHe5ZDWKHyVGXkQ1O/dXXF8tfa1dC5zsCLBCNdp7mKvEJ+YCkraSjWKLt2i+v0
	 q1ESRarIklwT08OvI3Ff7VlnSiBE8E8sJMq6x43Y=
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
Subject: [PATCH 6.9 342/374] drm/i915/gt: Fix CCS ids calculation for CCS mode setting
Date: Thu,  6 Jun 2024 16:05:21 +0200
Message-ID: <20240606131703.313949798@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 7a6dc371c384e..bc6209df0f680 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -919,6 +919,12 @@ static intel_engine_mask_t init_engine_mask(struct intel_gt *gt)
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



