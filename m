Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96ABD127B5F;
	Mon,  8 Apr 2024 13:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581858; cv=none; b=ukC6SlAoKOoi79euC6sVnR3cGmx8t6Gg0vvY2flcNaSvK7ETmHpOE4w6zgErmCeCu19V92F78XfiN3Lvpd4bV3/SMFAdk2SWWCla00RYgkoagxf0SfDVNX9TQUSMm2L1qNNiBo78mE0UjzA9tATK8+x5L6mqvgSYvVTTTNCcTY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581858; c=relaxed/simple;
	bh=ows1Pmz0MVo239cJvDD+Vf5r2ru3o5Q/caRlTCf5l0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOWfQfg9BmGFyfC0X9yDZlMf7mdeAHxmXjYtKAAV+EFd5jZMAI+FtNx8Qy8MMHnLPfhs/rCkFJwj4zruuxl06V2S05XcMm0ul6ELbpkiVs8ZSO4Wc7kxtpIZ+EIqUc2A3kzhTdP1zQSHoCHzB5PnTG5wj0O4WeRG8+xV2MQh7UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PU/oOkZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PU/oOkZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2043BC433C7;
	Mon,  8 Apr 2024 13:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581858;
	bh=ows1Pmz0MVo239cJvDD+Vf5r2ru3o5Q/caRlTCf5l0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PU/oOkZx5LFk+WCyCz7yI92IEOlNKLhv8y7MJ41pHFJ10yeKbp76wxkxGzIh0R4AO
	 hgg+bV47ssbq7pY0L4AOHjHfCvrLnJQs+KRnBTRHQ4aaj2QyFTV55eJVpxKFja/grq
	 mhnBY7jKwe88eSCP2zIYM73BjYgGpE5He4Ftf7rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/252] drm/i915/xelpg: Call Xe_LPG workaround functions based on IP version
Date: Mon,  8 Apr 2024 14:55:44 +0200
Message-ID: <20240408125308.035967565@linuxfoundation.org>
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

[ Upstream commit f7696ded7c9e358670dae1801660f442f059c7db ]

Although some of our Xe_LPG workarounds were already being applied based
on IP version correctly, others were matching on MTL as a base platform,
which is incorrect.  Although MTL is the only platform right now that
uses Xe_LPG IP, this may not always be the case.  If a future platform
re-uses this graphics IP, the same workarounds should be applied, even
if it isn't a "MTL" platform.

We were also incorrectly applying Xe_LPG workarounds/tuning to the
Xe_LPM+ media IP in one or two places; we should make sure that we don't
try to apply graphics workarounds to the media GT and vice versa where
they don't belong.  A new helper macro IS_GT_IP_RANGE() is added to help
ensure this is handled properly -- it checks that the GT matches the IP
type being tested as well as the IP version falling in the proper range.

Note that many of the stepping-based workarounds are still incorrectly
checking for a MTL base platform; that will be remedied in a later
patch.

v2:
 - Rework macro into a slightly more generic IS_GT_IP_RANGE() that can
   be used for either GFX or MEDIA checks.

v3:
 - Switch back to separate macros for gfx and media.  (Jani)
 - Move macro to intel_gt.h.  (Andi)

Cc: Gustavo Sousa <gustavo.sousa@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230821180619.650007-14-matthew.d.roper@intel.com
Stable-dep-of: 186bce682772 ("drm/i915/mtl: Update workaround 14018575942")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gt.h          | 11 ++++++
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 38 +++++++++++----------
 2 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt.h b/drivers/gpu/drm/i915/gt/intel_gt.h
index 6c34547b58b59..15c25980411db 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt.h
@@ -14,6 +14,17 @@
 struct drm_i915_private;
 struct drm_printer;
 
+/*
+ * Check that the GT is a graphics GT and has an IP version within the
+ * specified range (inclusive).
+ */
+#define IS_GFX_GT_IP_RANGE(gt, from, until) ( \
+	BUILD_BUG_ON_ZERO((from) < IP_VER(2, 0)) + \
+	BUILD_BUG_ON_ZERO((until) < (from)) + \
+	((gt)->type != GT_MEDIA && \
+	 GRAPHICS_VER_FULL((gt)->i915) >= (from) && \
+	 GRAPHICS_VER_FULL((gt)->i915) <= (until)))
+
 #define GT_TRACE(gt, fmt, ...) do {					\
 	const struct intel_gt *gt__ __maybe_unused = (gt);		\
 	GEM_TRACE("%s " fmt, dev_name(gt__->i915->drm.dev),		\
diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 69973dc518280..4c24f3897aee1 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -781,8 +781,8 @@ static void dg2_ctx_workarounds_init(struct intel_engine_cs *engine,
 	wa_masked_en(wal, CACHE_MODE_1, MSAA_OPTIMIZATION_REDUC_DISABLE);
 }
 
-static void mtl_ctx_gt_tuning_init(struct intel_engine_cs *engine,
-				   struct i915_wa_list *wal)
+static void xelpg_ctx_gt_tuning_init(struct intel_engine_cs *engine,
+				     struct i915_wa_list *wal)
 {
 	struct drm_i915_private *i915 = engine->i915;
 
@@ -793,12 +793,12 @@ static void mtl_ctx_gt_tuning_init(struct intel_engine_cs *engine,
 		wa_add(wal, DRAW_WATERMARK, VERT_WM_VAL, 0x3FF, 0, false);
 }
 
-static void mtl_ctx_workarounds_init(struct intel_engine_cs *engine,
-				     struct i915_wa_list *wal)
+static void xelpg_ctx_workarounds_init(struct intel_engine_cs *engine,
+				       struct i915_wa_list *wal)
 {
 	struct drm_i915_private *i915 = engine->i915;
 
-	mtl_ctx_gt_tuning_init(engine, wal);
+	xelpg_ctx_gt_tuning_init(engine, wal);
 
 	if (IS_MTL_GRAPHICS_STEP(i915, M, STEP_A0, STEP_B0) ||
 	    IS_MTL_GRAPHICS_STEP(i915, P, STEP_A0, STEP_B0)) {
@@ -907,8 +907,8 @@ __intel_engine_init_ctx_wa(struct intel_engine_cs *engine,
 	if (engine->class != RENDER_CLASS)
 		goto done;
 
-	if (IS_METEORLAKE(i915))
-		mtl_ctx_workarounds_init(engine, wal);
+	if (IS_GFX_GT_IP_RANGE(engine->gt, IP_VER(12, 70), IP_VER(12, 71)))
+		xelpg_ctx_workarounds_init(engine, wal);
 	else if (IS_PONTEVECCHIO(i915))
 		; /* noop; none at this time */
 	else if (IS_DG2(i915))
@@ -1688,10 +1688,8 @@ xelpmp_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
  */
 static void gt_tuning_settings(struct intel_gt *gt, struct i915_wa_list *wal)
 {
-	if (IS_METEORLAKE(gt->i915)) {
-		if (gt->type != GT_MEDIA)
-			wa_mcr_write_or(wal, XEHP_L3SCQREG7, BLEND_FILL_CACHING_OPT_DIS);
-
+	if (IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 70), IP_VER(12, 71))) {
+		wa_mcr_write_or(wal, XEHP_L3SCQREG7, BLEND_FILL_CACHING_OPT_DIS);
 		wa_mcr_write_or(wal, XEHP_SQCM, EN_32B_ACCESS);
 	}
 
@@ -1723,7 +1721,7 @@ gt_init_workarounds(struct intel_gt *gt, struct i915_wa_list *wal)
 		return;
 	}
 
-	if (GRAPHICS_VER_FULL(i915) >= IP_VER(12, 70))
+	if (IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 70), IP_VER(12, 71)))
 		xelpg_gt_workarounds_init(gt, wal);
 	else if (IS_PONTEVECCHIO(i915))
 		pvc_gt_workarounds_init(gt, wal);
@@ -2172,7 +2170,7 @@ static void pvc_whitelist_build(struct intel_engine_cs *engine)
 	blacklist_trtt(engine);
 }
 
-static void mtl_whitelist_build(struct intel_engine_cs *engine)
+static void xelpg_whitelist_build(struct intel_engine_cs *engine)
 {
 	struct i915_wa_list *w = &engine->whitelist;
 
@@ -2194,8 +2192,10 @@ void intel_engine_init_whitelist(struct intel_engine_cs *engine)
 
 	wa_init_start(w, engine->gt, "whitelist", engine->name);
 
-	if (IS_METEORLAKE(i915))
-		mtl_whitelist_build(engine);
+	if (engine->gt->type == GT_MEDIA)
+		; /* none yet */
+	else if (IS_GFX_GT_IP_RANGE(engine->gt, IP_VER(12, 70), IP_VER(12, 71)))
+		xelpg_whitelist_build(engine);
 	else if (IS_PONTEVECCHIO(i915))
 		pvc_whitelist_build(engine);
 	else if (IS_DG2(i915))
@@ -2795,10 +2795,12 @@ ccs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
  * function invoked by __intel_engine_init_ctx_wa().
  */
 static void
-add_render_compute_tuning_settings(struct drm_i915_private *i915,
+add_render_compute_tuning_settings(struct intel_gt *gt,
 				   struct i915_wa_list *wal)
 {
-	if (IS_METEORLAKE(i915) || IS_DG2(i915))
+	struct drm_i915_private *i915 = gt->i915;
+
+	if (IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 70), IP_VER(12, 71)) || IS_DG2(i915))
 		wa_mcr_write_clr_set(wal, RT_CTRL, STACKID_CTRL, STACKID_CTRL_512);
 
 	/*
@@ -2828,7 +2830,7 @@ general_render_compute_wa_init(struct intel_engine_cs *engine, struct i915_wa_li
 {
 	struct drm_i915_private *i915 = engine->i915;
 
-	add_render_compute_tuning_settings(i915, wal);
+	add_render_compute_tuning_settings(engine->gt, wal);
 
 	if (GRAPHICS_VER(i915) >= 11) {
 		/* This is not a Wa (although referred to as
-- 
2.43.0



