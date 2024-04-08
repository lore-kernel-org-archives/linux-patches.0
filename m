Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700E07BAE7;
	Mon,  8 Apr 2024 13:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581832; cv=none; b=Vz+LG5HMSuKMD4CQthGWzeS0yE3GsRMkklfaqHPUl+MtJk/cALNLkT40ZOzNxxRmAwwmLmKSavX/46lO0MOP7I4N0hbw4FGxydmIJVOf8yMUMFj+OC2EHxNr/7W7B2hjtqurDdGvWeRA+/9e7C41oznMO6rTuZLxCPubJn/1dO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581832; c=relaxed/simple;
	bh=cveR2VnG6Z6tfljjrwe3/wRIWNBwZJEh9bu7aDvvs/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0L7K1GmmJLRb7JRTJbNUEfQ3VwdeLyBd9Ixpt9aPw+vnD6fIPr1BjZKRzaew/nR6IVPj7GdLWINoVWKSiZJCRY7PGvdquCml7Y75RvjhkVp7aw9RR0nuwqsa+NSwz9Hb8abBMHj3+4D93UUlK/RvdEi9Bh0YaUFheeD6RFaBIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TpG/MGw+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TpG/MGw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA168C433F1;
	Mon,  8 Apr 2024 13:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581832;
	bh=cveR2VnG6Z6tfljjrwe3/wRIWNBwZJEh9bu7aDvvs/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TpG/MGw+7g6iB5wzDHgAdUGaZsMqWwF56uWUJZhw0smkBOs7TIcBQpfA2HT6iwqD3
	 vX78fdhAnHkmyQPsLq4rV5+NUrv8WoqIbGm7k0mmZJ0C2R77zuLJ1AZBYN6CSPIZlv
	 n1SXySN4m66zbHfOBAmQo/oiAx4pXjSxCzvMiWig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Matt Atwood <matthew.s.atwood@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/252] drm/i915: Tidy workaround definitions
Date: Mon,  8 Apr 2024 14:55:42 +0200
Message-ID: <20240408125307.975468213@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit f1c805716516f9e648e13f0108cea8096e0c7023 ]

Removal of the DG2 pre-production workarounds has left duplicate
condition blocks in a couple places, as well as some inconsistent
platform ordering.  Reshuffle and consolidate some of the workarounds to
reduce the number of condition blocks and to more consistently follow
the "newest platform first" convention.  Code movement only; no
functional change.

Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Matt Atwood <matthew.s.atwood@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230816214201.534095-11-matthew.d.roper@intel.com
Stable-dep-of: 186bce682772 ("drm/i915/mtl: Update workaround 14018575942")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 100 +++++++++-----------
 1 file changed, 46 insertions(+), 54 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 7b426f3015b34..69973dc518280 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -2337,6 +2337,19 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 			   true);
 	}
 
+	if (IS_DG2(i915) || IS_ALDERLAKE_P(i915) || IS_ALDERLAKE_S(i915) ||
+	    IS_DG1(i915) || IS_ROCKETLAKE(i915) || IS_TIGERLAKE(i915)) {
+		/*
+		 * Wa_1606700617:tgl,dg1,adl-p
+		 * Wa_22010271021:tgl,rkl,dg1,adl-s,adl-p
+		 * Wa_14010826681:tgl,dg1,rkl,adl-p
+		 * Wa_18019627453:dg2
+		 */
+		wa_masked_en(wal,
+			     GEN9_CS_DEBUG_MODE1,
+			     FF_DOP_CLOCK_GATE_DISABLE);
+	}
+
 	if (IS_ALDERLAKE_P(i915) || IS_ALDERLAKE_S(i915) || IS_DG1(i915) ||
 	    IS_ROCKETLAKE(i915) || IS_TIGERLAKE(i915)) {
 		/* Wa_1606931601:tgl,rkl,dg1,adl-s,adl-p */
@@ -2350,19 +2363,11 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 		 */
 		wa_write_or(wal, GEN7_FF_THREAD_MODE,
 			    GEN12_FF_TESSELATION_DOP_GATE_DISABLE);
-	}
 
-	if (IS_ALDERLAKE_P(i915) || IS_DG2(i915) || IS_ALDERLAKE_S(i915) ||
-	    IS_DG1(i915) || IS_ROCKETLAKE(i915) || IS_TIGERLAKE(i915)) {
-		/*
-		 * Wa_1606700617:tgl,dg1,adl-p
-		 * Wa_22010271021:tgl,rkl,dg1,adl-s,adl-p
-		 * Wa_14010826681:tgl,dg1,rkl,adl-p
-		 * Wa_18019627453:dg2
-		 */
-		wa_masked_en(wal,
-			     GEN9_CS_DEBUG_MODE1,
-			     FF_DOP_CLOCK_GATE_DISABLE);
+		/* Wa_1406941453:tgl,rkl,dg1,adl-s,adl-p */
+		wa_mcr_masked_en(wal,
+				 GEN10_SAMPLER_MODE,
+				 ENABLE_SMALLPL);
 	}
 
 	if (IS_ALDERLAKE_P(i915) || IS_ALDERLAKE_S(i915) ||
@@ -2389,14 +2394,6 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 			     GEN8_RC_SEMA_IDLE_MSG_DISABLE);
 	}
 
-	if (IS_DG1(i915) || IS_ROCKETLAKE(i915) || IS_TIGERLAKE(i915) ||
-	    IS_ALDERLAKE_S(i915) || IS_ALDERLAKE_P(i915)) {
-		/* Wa_1406941453:tgl,rkl,dg1,adl-s,adl-p */
-		wa_mcr_masked_en(wal,
-				 GEN10_SAMPLER_MODE,
-				 ENABLE_SMALLPL);
-	}
-
 	if (GRAPHICS_VER(i915) == 11) {
 		/* This is not an Wa. Enable for better image quality */
 		wa_masked_en(wal,
@@ -2877,6 +2874,9 @@ general_render_compute_wa_init(struct intel_engine_cs *engine, struct i915_wa_li
 		/* Wa_22013037850 */
 		wa_mcr_write_or(wal, LSC_CHICKEN_BIT_0_UDW,
 				DISABLE_128B_EVICTION_COMMAND_UDW);
+
+		/* Wa_18017747507 */
+		wa_masked_en(wal, VFG_PREEMPTION_CHICKEN, POLYGON_TRIFAN_LINELOOP_DISABLE);
 	}
 
 	if (IS_MTL_GRAPHICS_STEP(i915, M, STEP_A0, STEP_B0) ||
@@ -2887,11 +2887,20 @@ general_render_compute_wa_init(struct intel_engine_cs *engine, struct i915_wa_li
 		wa_mcr_write_or(wal, LSC_CHICKEN_BIT_0, DISABLE_D8_D16_COASLESCE);
 	}
 
-	if (IS_MTL_GRAPHICS_STEP(i915, M, STEP_A0, STEP_B0) ||
-	    IS_MTL_GRAPHICS_STEP(i915, P, STEP_A0, STEP_B0) ||
-	    IS_DG2(i915)) {
-		/* Wa_18017747507 */
-		wa_masked_en(wal, VFG_PREEMPTION_CHICKEN, POLYGON_TRIFAN_LINELOOP_DISABLE);
+	if (IS_PONTEVECCHIO(i915) || IS_DG2(i915)) {
+		/* Wa_14015227452:dg2,pvc */
+		wa_mcr_masked_en(wal, GEN9_ROW_CHICKEN4, XEHP_DIS_BBL_SYSPIPE);
+
+		/* Wa_16015675438:dg2,pvc */
+		wa_masked_en(wal, FF_SLICE_CS_CHICKEN2, GEN12_PERF_FIX_BALANCING_CFE_DISABLE);
+	}
+
+	if (IS_DG2(i915)) {
+		/*
+		 * Wa_16011620976:dg2_g11
+		 * Wa_22015475538:dg2
+		 */
+		wa_mcr_write_or(wal, LSC_CHICKEN_BIT_0_UDW, DIS_CHAIN_2XSIMD8);
 	}
 
 	if (IS_DG2_G11(i915)) {
@@ -2906,6 +2915,18 @@ general_render_compute_wa_init(struct intel_engine_cs *engine, struct i915_wa_li
 		/* Wa_22013059131:dg2 */
 		wa_mcr_write_or(wal, LSC_CHICKEN_BIT_0,
 				FORCE_1_SUB_MESSAGE_PER_FRAGMENT);
+
+		/*
+		 * Wa_22012654132
+		 *
+		 * Note that register 0xE420 is write-only and cannot be read
+		 * back for verification on DG2 (due to Wa_14012342262), so
+		 * we need to explicitly skip the readback.
+		 */
+		wa_mcr_add(wal, GEN10_CACHE_MODE_SS, 0,
+			   _MASKED_BIT_ENABLE(ENABLE_PREFETCH_INTO_IC),
+			   0 /* write-only, so skip validation */,
+			   true);
 	}
 
 	if (IS_XEHPSDV(i915)) {
@@ -2923,35 +2944,6 @@ general_render_compute_wa_init(struct intel_engine_cs *engine, struct i915_wa_li
 		wa_mcr_masked_en(wal, GEN8_HALF_SLICE_CHICKEN1,
 				 GEN7_PSD_SINGLE_PORT_DISPATCH_ENABLE);
 	}
-
-	if (IS_DG2(i915) || IS_PONTEVECCHIO(i915)) {
-		/* Wa_14015227452:dg2,pvc */
-		wa_mcr_masked_en(wal, GEN9_ROW_CHICKEN4, XEHP_DIS_BBL_SYSPIPE);
-
-		/* Wa_16015675438:dg2,pvc */
-		wa_masked_en(wal, FF_SLICE_CS_CHICKEN2, GEN12_PERF_FIX_BALANCING_CFE_DISABLE);
-	}
-
-	if (IS_DG2(i915)) {
-		/*
-		 * Wa_16011620976:dg2_g11
-		 * Wa_22015475538:dg2
-		 */
-		wa_mcr_write_or(wal, LSC_CHICKEN_BIT_0_UDW, DIS_CHAIN_2XSIMD8);
-	}
-
-	if (IS_DG2_G11(i915))
-		/*
-		 * Wa_22012654132
-		 *
-		 * Note that register 0xE420 is write-only and cannot be read
-		 * back for verification on DG2 (due to Wa_14012342262), so
-		 * we need to explicitly skip the readback.
-		 */
-		wa_mcr_add(wal, GEN10_CACHE_MODE_SS, 0,
-			   _MASKED_BIT_ENABLE(ENABLE_PREFETCH_INTO_IC),
-			   0 /* write-only, so skip validation */,
-			   true);
 }
 
 static void
-- 
2.43.0



