Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C741C7C098;
	Mon,  8 Apr 2024 13:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581884; cv=none; b=ENCOFH1R7An/OFhQfIc25830x08NH8ZhbF/q1RVAYBsfdGkI0Pg4Xa3wx7Aj+G20i22H0kHF3nyLiJhrmN6R9t/Ay1lhAXe8wKwznrkf4JtrmikDx5wK/lNEAc6U3XMIa0XX6bjSCdDI18kd4+L0vlMkRuuD8a7GgRWTZaS+jxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581884; c=relaxed/simple;
	bh=APSgdtPkUyBelO096cON3JQdcxwtD0DVeK4rNDTy9UI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bf9Z6Yr/rJ7xW6VNJ1wS50vKvRA2YDo+ezRUorzbkSzT4cgxKAm5KdZtXQdkpfTSM3j2ADPLrZDSx6qVipVndxUXmg/3fg7GuBUqAtnKGip9ITqbS0PneiGNeuWWMkatzATRKvQg7AS54dcBxkCcPRnBNPhflsGWEw9S/PnNSVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XX1w/JtY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XX1w/JtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB53C433F1;
	Mon,  8 Apr 2024 13:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581884;
	bh=APSgdtPkUyBelO096cON3JQdcxwtD0DVeK4rNDTy9UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XX1w/JtYAalISwwFG0GixwrugvqVACU5rcv4ckc8yA7iRTPQGTlJLeL9GLMOg43CN
	 GcwIdOCEEMVSQ2pfChg+5sah1HSsNRrZZdEYkdSPfwzpGjrX8Bg3oJcVgn5Yj/lX1I
	 oay9hn7nif2EX6SDAw9aNt2qty6dtDBbbuPXnwBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/252] drm/i915: Replace several IS_METEORLAKE with proper IP version checks
Date: Mon,  8 Apr 2024 14:55:46 +0200
Message-ID: <20240408125308.097539150@linuxfoundation.org>
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

[ Upstream commit 14128d64090fa88445376cb8ccf91c50c08bd410 ]

Many of the IS_METEORLAKE conditions throughout the driver are supposed
to be checks for Xe_LPG and/or Xe_LPM+ IP, not for the MTL platform
specifically.  Update those checks to ensure that the code will still
operate properly if/when these IP versions show up on future platforms.

v2:
 - Update two more conditions (one for pg_enable, one for MTL HuC
   compatibility).
v3:
 - Don't change GuC/HuC compatibility check, which sounds like it truly
   is specific to the MTL platform.  (Gustavo)
 - Drop a non-lineage workaround number for the OA timestamp frequency
   workaround.  (Gustavo)

Cc: Gustavo Sousa <gustavo.sousa@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230821180619.650007-20-matthew.d.roper@intel.com
Stable-dep-of: 186bce682772 ("drm/i915/mtl: Update workaround 14018575942")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_create.c |  4 ++--
 drivers/gpu/drm/i915/gt/intel_engine_pm.c  |  2 +-
 drivers/gpu/drm/i915/gt/intel_mocs.c       |  2 +-
 drivers/gpu/drm/i915/gt/intel_rc6.c        |  2 +-
 drivers/gpu/drm/i915/gt/intel_reset.c      |  2 +-
 drivers/gpu/drm/i915/gt/intel_rps.c        |  2 +-
 drivers/gpu/drm/i915/i915_debugfs.c        |  2 +-
 drivers/gpu/drm/i915/i915_perf.c           | 11 +++++------
 8 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_create.c b/drivers/gpu/drm/i915/gem/i915_gem_create.c
index d24c0ce8805c7..19156ba4b9ef4 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_create.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_create.c
@@ -405,8 +405,8 @@ static int ext_set_pat(struct i915_user_extension __user *base, void *data)
 	BUILD_BUG_ON(sizeof(struct drm_i915_gem_create_ext_set_pat) !=
 		     offsetofend(struct drm_i915_gem_create_ext_set_pat, rsvd));
 
-	/* Limiting the extension only to Meteor Lake */
-	if (!IS_METEORLAKE(i915))
+	/* Limiting the extension only to Xe_LPG and beyond */
+	if (GRAPHICS_VER_FULL(i915) < IP_VER(12, 70))
 		return -ENODEV;
 
 	if (copy_from_user(&ext, base, sizeof(ext)))
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_pm.c b/drivers/gpu/drm/i915/gt/intel_engine_pm.c
index a95615b345cd7..5a3a5b29d1507 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_pm.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_pm.c
@@ -21,7 +21,7 @@ static void intel_gsc_idle_msg_enable(struct intel_engine_cs *engine)
 {
 	struct drm_i915_private *i915 = engine->i915;
 
-	if (IS_METEORLAKE(i915) && engine->id == GSC0) {
+	if (MEDIA_VER(i915) >= 13 && engine->id == GSC0) {
 		intel_uncore_write(engine->gt->uncore,
 				   RC_PSMI_CTRL_GSCCS,
 				   _MASKED_BIT_DISABLE(IDLE_MSG_DISABLE));
diff --git a/drivers/gpu/drm/i915/gt/intel_mocs.c b/drivers/gpu/drm/i915/gt/intel_mocs.c
index bf8b42d2d3279..07269ff3be136 100644
--- a/drivers/gpu/drm/i915/gt/intel_mocs.c
+++ b/drivers/gpu/drm/i915/gt/intel_mocs.c
@@ -495,7 +495,7 @@ static unsigned int get_mocs_settings(const struct drm_i915_private *i915,
 	memset(table, 0, sizeof(struct drm_i915_mocs_table));
 
 	table->unused_entries_index = I915_MOCS_PTE;
-	if (IS_METEORLAKE(i915)) {
+	if (IS_GFX_GT_IP_RANGE(&i915->gt0, IP_VER(12, 70), IP_VER(12, 71))) {
 		table->size = ARRAY_SIZE(mtl_mocs_table);
 		table->table = mtl_mocs_table;
 		table->n_entries = MTL_NUM_MOCS_ENTRIES;
diff --git a/drivers/gpu/drm/i915/gt/intel_rc6.c b/drivers/gpu/drm/i915/gt/intel_rc6.c
index b8c9338176bd6..9e113e9473260 100644
--- a/drivers/gpu/drm/i915/gt/intel_rc6.c
+++ b/drivers/gpu/drm/i915/gt/intel_rc6.c
@@ -123,7 +123,7 @@ static void gen11_rc6_enable(struct intel_rc6 *rc6)
 	 * temporary wa and should be removed after fixing real cause
 	 * of forcewake timeouts.
 	 */
-	if (IS_METEORLAKE(gt->i915))
+	if (IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 70), IP_VER(12, 71)))
 		pg_enable =
 			GEN9_MEDIA_PG_ENABLE |
 			GEN11_MEDIA_SAMPLER_PG_ENABLE;
diff --git a/drivers/gpu/drm/i915/gt/intel_reset.c b/drivers/gpu/drm/i915/gt/intel_reset.c
index 63d0892d3c45a..13fb8e5042c58 100644
--- a/drivers/gpu/drm/i915/gt/intel_reset.c
+++ b/drivers/gpu/drm/i915/gt/intel_reset.c
@@ -705,7 +705,7 @@ static int __reset_guc(struct intel_gt *gt)
 
 static bool needs_wa_14015076503(struct intel_gt *gt, intel_engine_mask_t engine_mask)
 {
-	if (!IS_METEORLAKE(gt->i915) || !HAS_ENGINE(gt, GSC0))
+	if (MEDIA_VER_FULL(gt->i915) != IP_VER(13, 0) || !HAS_ENGINE(gt, GSC0))
 		return false;
 
 	if (!__HAS_ENGINE(engine_mask, GSC0))
diff --git a/drivers/gpu/drm/i915/gt/intel_rps.c b/drivers/gpu/drm/i915/gt/intel_rps.c
index 092542f53aad9..4feef874e6d69 100644
--- a/drivers/gpu/drm/i915/gt/intel_rps.c
+++ b/drivers/gpu/drm/i915/gt/intel_rps.c
@@ -1161,7 +1161,7 @@ void gen6_rps_get_freq_caps(struct intel_rps *rps, struct intel_rps_freq_caps *c
 {
 	struct drm_i915_private *i915 = rps_to_i915(rps);
 
-	if (IS_METEORLAKE(i915))
+	if (GRAPHICS_VER_FULL(i915) >= IP_VER(12, 70))
 		return mtl_get_freq_caps(rps, caps);
 	else
 		return __gen6_rps_get_freq_caps(rps, caps);
diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 4de44cf1026dc..7a90a2e32c9f1 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -144,7 +144,7 @@ static const char *i915_cache_level_str(struct drm_i915_gem_object *obj)
 {
 	struct drm_i915_private *i915 = obj_to_i915(obj);
 
-	if (IS_METEORLAKE(i915)) {
+	if (IS_GFX_GT_IP_RANGE(to_gt(i915), IP_VER(12, 70), IP_VER(12, 71))) {
 		switch (obj->pat_index) {
 		case 0: return " WB";
 		case 1: return " WT";
diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index 8f4a25d2cfc24..48ea17b49b3a0 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -3255,11 +3255,10 @@ get_sseu_config(struct intel_sseu *out_sseu,
  */
 u32 i915_perf_oa_timestamp_frequency(struct drm_i915_private *i915)
 {
-	/*
-	 * Wa_18013179988:dg2
-	 * Wa_14015846243:mtl
-	 */
-	if (IS_DG2(i915) || IS_METEORLAKE(i915)) {
+	struct intel_gt *gt = to_gt(i915);
+
+	/* Wa_18013179988 */
+	if (IS_DG2(i915) || IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 70), IP_VER(12, 71))) {
 		intel_wakeref_t wakeref;
 		u32 reg, shift;
 
@@ -4564,7 +4563,7 @@ static bool xehp_is_valid_b_counter_addr(struct i915_perf *perf, u32 addr)
 
 static bool gen12_is_valid_mux_addr(struct i915_perf *perf, u32 addr)
 {
-	if (IS_METEORLAKE(perf->i915))
+	if (GRAPHICS_VER_FULL(perf->i915) >= IP_VER(12, 70))
 		return reg_in_range_table(addr, mtl_oa_mux_regs);
 	else
 		return reg_in_range_table(addr, gen12_oa_mux_regs);
-- 
2.43.0



