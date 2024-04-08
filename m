Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E66B7F7CB;
	Mon,  8 Apr 2024 13:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581844; cv=none; b=u2DfTzmu6+/ImXlC09a5P7S4Xcn57X73F9rbnezRU3pvPcIR6l3A9k8SKObHa7GGQUJ3fO3RrxQI4/IOTmXM2xTtQ6q2V7SVaYjiY8Zs4MUt+dXXfrpd5OV2N4LiuoAz8AGjR+i4E+sG+HiMzItgVxJXlpF8ypKvfdq7VL+cAS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581844; c=relaxed/simple;
	bh=RxaPcp7Rs9brI6VOzeF4dIy/cnBDfbkfcN5zTEcyiZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoMAqf01zOrgVfaPLVhQeF0Mk7RZSqNNknGg4RL8WM91tc6AH1+8TtxICAD/YKCSzqBCzt3jWtcqV1Jz2TOd3Cr0TO7kg53pph6eSGyXn+s7mMZqPR0W19G6UC7rgO2BNRKR9kInclCahx/bEdtIyjhw/aIz0PLSoYT90NHxe9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pkFG5kLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkFG5kLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA46C43399;
	Mon,  8 Apr 2024 13:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581843;
	bh=RxaPcp7Rs9brI6VOzeF4dIy/cnBDfbkfcN5zTEcyiZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pkFG5kLP8QO1z5Ap1vwuZR4jnwbLLxpCzvEStd5SeQ96ZDM/sL9wiQ3MyLdPTLWcL
	 SGD8LM067Pb0iigmzZR3olbEdnQJRske0+jCJqcR/F4nwPRoTjiZyVBfoElBnlLyN+
	 tI5T0qNYe/HQhlaZkSTz5U6JCQJ5BKLjRueb/z18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/252] drm/i915: Consolidate condition for Wa_22011802037
Date: Mon,  8 Apr 2024 14:55:43 +0200
Message-ID: <20240408125308.005822053@linuxfoundation.org>
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

[ Upstream commit 28c46feec7f8760683ef08f12746630a3598173e ]

The workaround bounds for Wa_22011802037 are somewhat complex and are
replicated in several places throughout the code.  Pull the condition
out to a helper function to prevent mistakes if this condition needs to
change again in the future.

Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230821180619.650007-12-matthew.d.roper@intel.com
Stable-dep-of: 186bce682772 ("drm/i915/mtl: Update workaround 14018575942")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_cs.c      |  4 +---
 .../drm/i915/gt/intel_execlists_submission.c   |  4 +---
 drivers/gpu/drm/i915/gt/intel_reset.c          | 18 ++++++++++++++++++
 drivers/gpu/drm/i915/gt/intel_reset.h          |  2 ++
 drivers/gpu/drm/i915/gt/uc/intel_guc.c         |  4 +---
 .../gpu/drm/i915/gt/uc/intel_guc_submission.c  |  4 +---
 6 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index e85d70a62123f..84a75c95f3f7d 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -1616,9 +1616,7 @@ static int __intel_engine_stop_cs(struct intel_engine_cs *engine,
 	 * Wa_22011802037: Prior to doing a reset, ensure CS is
 	 * stopped, set ring stop bit and prefetch disable bit to halt CS
 	 */
-	if (IS_MTL_GRAPHICS_STEP(engine->i915, M, STEP_A0, STEP_B0) ||
-	    (GRAPHICS_VER(engine->i915) >= 11 &&
-	    GRAPHICS_VER_FULL(engine->i915) < IP_VER(12, 70)))
+	if (intel_engine_reset_needs_wa_22011802037(engine->gt))
 		intel_uncore_write_fw(uncore, RING_MODE_GEN7(engine->mmio_base),
 				      _MASKED_BIT_ENABLE(GEN12_GFX_PREFETCH_DISABLE));
 
diff --git a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
index 5a720e2523126..42e09f1589205 100644
--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -3001,9 +3001,7 @@ static void execlists_reset_prepare(struct intel_engine_cs *engine)
 	 * Wa_22011802037: In addition to stopping the cs, we need
 	 * to wait for any pending mi force wakeups
 	 */
-	if (IS_MTL_GRAPHICS_STEP(engine->i915, M, STEP_A0, STEP_B0) ||
-	    (GRAPHICS_VER(engine->i915) >= 11 &&
-	    GRAPHICS_VER_FULL(engine->i915) < IP_VER(12, 70)))
+	if (intel_engine_reset_needs_wa_22011802037(engine->gt))
 		intel_engine_wait_for_pending_mi_fw(engine);
 
 	engine->execlists.reset_ccid = active_ccid(engine);
diff --git a/drivers/gpu/drm/i915/gt/intel_reset.c b/drivers/gpu/drm/i915/gt/intel_reset.c
index 5fa57a34cf4bb..3a3f71ce3cb77 100644
--- a/drivers/gpu/drm/i915/gt/intel_reset.c
+++ b/drivers/gpu/drm/i915/gt/intel_reset.c
@@ -1632,6 +1632,24 @@ void __intel_fini_wedge(struct intel_wedge_me *w)
 	w->gt = NULL;
 }
 
+/*
+ * Wa_22011802037 requires that we (or the GuC) ensure that no command
+ * streamers are executing MI_FORCE_WAKE while an engine reset is initiated.
+ */
+bool intel_engine_reset_needs_wa_22011802037(struct intel_gt *gt)
+{
+	if (GRAPHICS_VER(gt->i915) < 11)
+		return false;
+
+	if (IS_MTL_GRAPHICS_STEP(gt->i915, M, STEP_A0, STEP_B0))
+		return true;
+
+	if (GRAPHICS_VER_FULL(gt->i915) >= IP_VER(12, 70))
+		return false;
+
+	return true;
+}
+
 #if IS_ENABLED(CONFIG_DRM_I915_SELFTEST)
 #include "selftest_reset.c"
 #include "selftest_hangcheck.c"
diff --git a/drivers/gpu/drm/i915/gt/intel_reset.h b/drivers/gpu/drm/i915/gt/intel_reset.h
index 25c975b6e8fc0..f615b30b81c59 100644
--- a/drivers/gpu/drm/i915/gt/intel_reset.h
+++ b/drivers/gpu/drm/i915/gt/intel_reset.h
@@ -78,4 +78,6 @@ void __intel_fini_wedge(struct intel_wedge_me *w);
 bool intel_has_gpu_reset(const struct intel_gt *gt);
 bool intel_has_reset_engine(const struct intel_gt *gt);
 
+bool intel_engine_reset_needs_wa_22011802037(struct intel_gt *gt);
+
 #endif /* I915_RESET_H */
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc.c b/drivers/gpu/drm/i915/gt/uc/intel_guc.c
index 82a2ecc12b212..da967938fea58 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc.c
@@ -288,9 +288,7 @@ static u32 guc_ctl_wa_flags(struct intel_guc *guc)
 		flags |= GUC_WA_DUAL_QUEUE;
 
 	/* Wa_22011802037: graphics version 11/12 */
-	if (IS_MTL_GRAPHICS_STEP(gt->i915, M, STEP_A0, STEP_B0) ||
-	    (GRAPHICS_VER(gt->i915) >= 11 &&
-	    GRAPHICS_VER_FULL(gt->i915) < IP_VER(12, 70)))
+	if (intel_engine_reset_needs_wa_22011802037(gt))
 		flags |= GUC_WA_PRE_PARSER;
 
 	/*
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index 836e4d9d65ef6..7a3e02ea56639 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -1690,9 +1690,7 @@ static void guc_engine_reset_prepare(struct intel_engine_cs *engine)
 	 * Wa_22011802037: In addition to stopping the cs, we need
 	 * to wait for any pending mi force wakeups
 	 */
-	if (IS_MTL_GRAPHICS_STEP(engine->i915, M, STEP_A0, STEP_B0) ||
-	    (GRAPHICS_VER(engine->i915) >= 11 &&
-	     GRAPHICS_VER_FULL(engine->i915) < IP_VER(12, 70))) {
+	if (intel_engine_reset_needs_wa_22011802037(engine->gt)) {
 		intel_engine_stop_cs(engine);
 		intel_engine_wait_for_pending_mi_fw(engine);
 	}
-- 
2.43.0



