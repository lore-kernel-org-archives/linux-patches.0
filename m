Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622186;
	b=Omxd7ANIecNUBc5nJdSU7lgia3BwspDOGHrsgjT4Weix7phVj9xRWB95X0tyK66GbYMa
	 4SsWpSm2OADtgWGLvf5ea8Sz5zh1Jb3dpXpcyuPwZeKB817rk63xqPsdJFCuQhJrhheXi
	 SDTpOsY+dd2aGCPL3Gs3WK2kSU69AWygWzXXOiJYFFvwImUr25NEIup+2dLOSa1fzd19g
	 A8LVi7HQTrAIfwekVPWmEMu+xPUUwI4s4ACVc4OMM6yq8kT8cIu2yCnPm2VjN7sqxgYE0
	 WlkJdm5eh71ABr2Mdg8rqWovPvodxkiXeR0MdqhQtvsZFmorTwGu2A6KRxOKm7jFEbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F/mRknEzLyHNCsLb56RYENxB1TUrGX/Ot40ObJHRMf4=;
	b=Io2ZKcsZsTx9lwgqrVOK16J7xtllA8zxQEVxDA7dkPG7sNK0qzXdmwHsjdnoIe3+0GVB
	 6W8WiDUEbjZMk+NTKU7tyCg7ogmJBaeO1LfAFnjQiC4TA7kl5JC0ZvpStHRdQgMsS0DjM
	 jl4tt9lx2VftjoJgdNYR0sX8j0MFsp6qWYNhYQZP+kE0JwnOpMbQVwuxaBcTytTSbO9Vc
	 ea6DRrgo/0Ad0lq+3rliiytcntmHAjb6+6fNi4NB2XhbIvaAEsUd/so8EpOoRvBHTHm5v
	 Aqy2L9fzXY0fH62RUutOAikqXUA55YkKmjckr+7BS/V2S8pitckyITWfIWkQGklsJWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7OkKNek;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFD7606A333;
	Wed, 25 Nov 2026 15:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7OkKNek
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A511F000CF;
	Wed, 25 Nov 2026 15:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622186;
	bh=F/mRknEzLyHNCsLb56RYENxB1TUrGX/Ot40ObJHRMf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7OkKNekSkg0u1sPeumXB8zRdbXVg1gwjtz48l1HzLi5q1MTyL55GNhEtGGgfzCPf
	 9lC2srB3teENvPpB+jWFUT5ns7F+8GkyoF1BakhitdqEkvnoEDZf6SpaF+SKE5ec09
	 epGW4DKTL8YZEOXGLfqzEu5kHAsvNH59lKGpEOos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 458/990] drm/xe/guc_pc: Use scope-based cleanup
Date: Wed, 25 Nov 2026 15:30:25 +0100
Message-ID: <20261125143832.823177911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit e9bc4162bf39154c1eb8d5edb11a00fc30771c39 ]

Use scope-based cleanup for forcewake and runtime PM in the GuC PC code.
This allows us to eliminate to goto-based cleanup and simplifies some
other functions.

Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patch.msgid.link/20251118164338.3572146-35-matthew.d.roper@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Stable-dep-of: 557c7b434378 ("drm/xe: Sync Wa_16023105232 in xe_was to match OOB rule")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_pc.c | 62 ++++++++++------------------------
 1 file changed, 17 insertions(+), 45 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_pc.c b/drivers/gpu/drm/xe/xe_guc_pc.c
index e41d97263eb62..994675336f04c 100644
--- a/drivers/gpu/drm/xe/xe_guc_pc.c
+++ b/drivers/gpu/drm/xe/xe_guc_pc.c
@@ -523,21 +523,17 @@ u32 xe_guc_pc_get_cur_freq_fw(struct xe_guc_pc *pc)
 int xe_guc_pc_get_cur_freq(struct xe_guc_pc *pc, u32 *freq)
 {
 	struct xe_gt *gt = pc_to_gt(pc);
-	unsigned int fw_ref;
 
 	/*
 	 * GuC SLPC plays with cur freq request when GuCRC is enabled
 	 * Block RC6 for a more reliable read.
 	 */
-	fw_ref = xe_force_wake_get(gt_to_fw(gt), XE_FW_GT);
-	if (!xe_force_wake_ref_has_domain(fw_ref, XE_FW_GT)) {
-		xe_force_wake_put(gt_to_fw(gt), fw_ref);
+	CLASS(xe_force_wake, fw_ref)(gt_to_fw(gt), XE_FW_GT);
+	if (!xe_force_wake_ref_has_domain(fw_ref.domains, XE_FW_GT))
 		return -ETIMEDOUT;
-	}
 
 	*freq = get_cur_freq(gt);
 
-	xe_force_wake_put(gt_to_fw(gt), fw_ref);
 	return 0;
 }
 
@@ -1105,13 +1101,8 @@ int xe_guc_pc_gucrc_disable(struct xe_guc_pc *pc)
  */
 int xe_guc_pc_override_gucrc_mode(struct xe_guc_pc *pc, enum slpc_gucrc_mode mode)
 {
-	int ret;
-
-	xe_pm_runtime_get(pc_to_xe(pc));
-	ret = pc_action_set_param(pc, SLPC_PARAM_PWRGATE_RC_MODE, mode);
-	xe_pm_runtime_put(pc_to_xe(pc));
-
-	return ret;
+	guard(xe_pm_runtime)(pc_to_xe(pc));
+	return pc_action_set_param(pc, SLPC_PARAM_PWRGATE_RC_MODE, mode);
 }
 
 /**
@@ -1122,13 +1113,8 @@ int xe_guc_pc_override_gucrc_mode(struct xe_guc_pc *pc, enum slpc_gucrc_mode mod
  */
 int xe_guc_pc_unset_gucrc_mode(struct xe_guc_pc *pc)
 {
-	int ret;
-
-	xe_pm_runtime_get(pc_to_xe(pc));
-	ret = pc_action_unset_param(pc, SLPC_PARAM_PWRGATE_RC_MODE);
-	xe_pm_runtime_put(pc_to_xe(pc));
-
-	return ret;
+	guard(xe_pm_runtime)(pc_to_xe(pc));
+	return pc_action_unset_param(pc, SLPC_PARAM_PWRGATE_RC_MODE);
 }
 
 static void pc_init_pcode_freq(struct xe_guc_pc *pc)
@@ -1218,7 +1204,7 @@ int xe_guc_pc_set_power_profile(struct xe_guc_pc *pc, const char *buf)
 		return -EINVAL;
 
 	guard(mutex)(&pc->freq_lock);
-	xe_pm_runtime_get_noresume(pc_to_xe(pc));
+	guard(xe_pm_runtime_noresume)(pc_to_xe(pc));
 
 	ret = pc_action_set_param(pc,
 				  SLPC_PARAM_POWER_PROFILE,
@@ -1229,8 +1215,6 @@ int xe_guc_pc_set_power_profile(struct xe_guc_pc *pc, const char *buf)
 	else
 		pc->power_profile = val;
 
-	xe_pm_runtime_put(pc_to_xe(pc));
-
 	return ret;
 }
 
@@ -1273,17 +1257,14 @@ int xe_guc_pc_start(struct xe_guc_pc *pc)
 	struct xe_device *xe = pc_to_xe(pc);
 	struct xe_gt *gt = pc_to_gt(pc);
 	u32 size = PAGE_ALIGN(sizeof(struct slpc_shared_data));
-	unsigned int fw_ref;
 	ktime_t earlier;
 	int ret;
 
 	xe_gt_assert(gt, xe_device_uc_enabled(xe));
 
-	fw_ref = xe_force_wake_get(gt_to_fw(gt), XE_FW_GT);
-	if (!xe_force_wake_ref_has_domain(fw_ref, XE_FW_GT)) {
-		xe_force_wake_put(gt_to_fw(gt), fw_ref);
+	CLASS(xe_force_wake, fw_ref)(gt_to_fw(gt), XE_FW_GT);
+	if (!xe_force_wake_ref_has_domain(fw_ref.domains, XE_FW_GT))
 		return -ETIMEDOUT;
-	}
 
 	if (xe->info.skip_guc_pc) {
 		if (xe->info.platform != XE_PVC)
@@ -1291,9 +1272,7 @@ int xe_guc_pc_start(struct xe_guc_pc *pc)
 
 		/* Request max possible since dynamic freq mgmt is not enabled */
 		pc_set_cur_freq(pc, UINT_MAX);
-
-		ret = 0;
-		goto out;
+		return 0;
 	}
 
 	xe_map_memset(xe, &pc->bo->vmap, 0, 0, size);
@@ -1302,7 +1281,7 @@ int xe_guc_pc_start(struct xe_guc_pc *pc)
 	earlier = ktime_get();
 	ret = pc_action_reset(pc);
 	if (ret)
-		goto out;
+		return ret;
 
 	if (wait_for_pc_state(pc, SLPC_GLOBAL_STATE_RUNNING,
 			      SLPC_RESET_TIMEOUT_MS)) {
@@ -1313,8 +1292,7 @@ int xe_guc_pc_start(struct xe_guc_pc *pc)
 		if (wait_for_pc_state(pc, SLPC_GLOBAL_STATE_RUNNING,
 				      SLPC_RESET_EXTENDED_TIMEOUT_MS)) {
 			xe_gt_err(gt, "GuC PC Start failed: Dynamic GT frequency control and GT sleep states are now disabled.\n");
-			ret = -EIO;
-			goto out;
+			return -EIO;
 		}
 
 		xe_gt_warn(gt, "GuC PC excessive start time: %lldms",
@@ -1327,21 +1305,20 @@ int xe_guc_pc_start(struct xe_guc_pc *pc)
 
 	ret = pc_init_freqs(pc);
 	if (ret)
-		goto out;
+		return ret;
 
 	ret = pc_set_mert_freq_cap(pc);
 	if (ret)
-		goto out;
+		return ret;
 
 	if (xe->info.platform == XE_PVC) {
 		xe_guc_pc_gucrc_disable(pc);
-		ret = 0;
-		goto out;
+		return 0;
 	}
 
 	ret = pc_action_setup_gucrc(pc, GUCRC_FIRMWARE_CONTROL);
 	if (ret)
-		goto out;
+		return ret;
 
 	/* Enable SLPC Optimized Strategy for compute */
 	ret = pc_action_set_strategy(pc, SLPC_OPTIMIZED_STRATEGY_COMPUTE);
@@ -1351,8 +1328,6 @@ int xe_guc_pc_start(struct xe_guc_pc *pc)
 	if (unlikely(ret))
 		xe_gt_err(gt, "Failed to set SLPC power profile: %pe\n", ERR_PTR(ret));
 
-out:
-	xe_force_wake_put(gt_to_fw(gt), fw_ref);
 	return ret;
 }
 
@@ -1384,19 +1359,16 @@ static void xe_guc_pc_fini_hw(void *arg)
 {
 	struct xe_guc_pc *pc = arg;
 	struct xe_device *xe = pc_to_xe(pc);
-	unsigned int fw_ref;
 
 	if (xe_device_wedged(xe))
 		return;
 
-	fw_ref = xe_force_wake_get(gt_to_fw(pc_to_gt(pc)), XE_FORCEWAKE_ALL);
+	CLASS(xe_force_wake, fw_ref)(gt_to_fw(pc_to_gt(pc)), XE_FORCEWAKE_ALL);
 	xe_guc_pc_gucrc_disable(pc);
 	XE_WARN_ON(xe_guc_pc_stop(pc));
 
 	/* Bind requested freq to mert_freq_cap before unload */
 	pc_set_cur_freq(pc, min(pc_max_freq_cap(pc), xe_guc_pc_get_rpe_freq(pc)));
-
-	xe_force_wake_put(gt_to_fw(pc_to_gt(pc)), fw_ref);
 }
 
 /**
-- 
2.53.0



