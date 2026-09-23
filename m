Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F9E44CAD7;
	Wed, 23 Sep 2026 14:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173212; cv=none; b=adR7eapTOjcZ70b/Tnx6zrU7f/Q7wGF1EOh94SICKpBLJwTprbsntEgYZStP5cnzn/3k974gU+wHGsQHEVq1ZuVmVFL6/y8FLXB3NrSSxHL5mGo8UuCH7r/+U/m3M3cVNPN6WKIrh/7YI+O2SbDJkyIT8NPDBVODKeKUd9wnzaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173212; c=relaxed/simple;
	bh=WX16jnPgZyj3PmzsACn9QrDwL9hh3kq8iWCIh4YWAaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c/SvoqCjPtLq8WN3r2a24PJ9Sk4jngxta48JvQ4KDcxwYITi0kF6vMqAux5ynbYwKGWFPmDvu10uwFIgu+LTI4zYpiC7wzuM/lDew1n9C36nh4E2syUbqV+F6j+I7JBDg3NGzT2sHNZ9a2MPDevH/V0K2Hn30WSzQT0j12VEZ+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tkw692k+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tkw692k+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA8C1F000FF;
	Wed, 23 Sep 2026 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173211;
	bh=npCRtLJn9wiwbsV6QPF5vRtwYbr64yUj/Oi/qYmLjP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tkw692k+RIKscmUIsRIGifBMH+IxrLxkBnFgBWS1CewRFUz2OgNgTIrZsGbvhdtyf
	 CAPAy7S4oyosWJ1KqhW+yLUS7cS+V1WZMOnaTni6lcnIJjlLNN6SCSCstv3qpXfh9x
	 UhEkGS0XYts7xcY+XzT79pyMCYxX+cFjNYgmkKik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 148/438] drm/xe/shrinker: Take a runtime PM ref before shrinking non-system memory
Date: Wed, 23 Sep 2026 16:02:49 +0200
Message-ID: <20260923140648.608750561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 985862be16c7e4da808c51f393d631fb60c0be5c ]

__xe_shrinker_walk() walks the SYSTEM and TT LRUs without a runtime PM
reference.  Shrinking a bo outside system memory invalidates its GPU
mappings, which needs the device resumed, so while it is runtime
suspended the page table zap trips an assert and the TLB invalidation
returns -ENODEV:

  WARNING: drivers/gpu/drm/xe/xe_bo.c:770 at xe_bo_move_notify+0x1fc/0x450 [xe]
   xe_bo_shrink+0x20f/0x2b0 [xe]
   __xe_shrinker_walk+0x174/0x410 [xe]
   xe_shrinker_scan+0x10c/0x1e0 [xe]
   do_shrink_slab+0x176/0x7e0
   drop_caches_sysctl_handler+0x9c/0xf0

Take a reference before walking a memory type other than XE_PL_SYSTEM
and stop there if it cannot be acquired.  Reuse the shrinker's existing
acquire path, which resumes the device directly where reclaim allows
that and otherwise queues the PM worker for a later scan.  Stop the walk
once the scan target is met, so a satisfied scan does not wake the
device.  System memory is still reclaimed while the device is suspended.

Gate this on xe_device_is_l2_flush_optimized(), the same condition under
which xe_bo_trigger_rebind() issues the invalidation for a non-fault-mode
vm, so reclaim is unaffected elsewhere.  The System CCS copy already has
its own reference in xe_bo_shrink().

Only a non-fault-mode vm can reach this, since a fault-mode vm requires
LR mode and that holds a runtime PM reference for the vm's lifetime.

Reproduced with igt@xe_madvise@dontneed-before-exec while the GPU is
runtime suspended.

v2: simplify needs_rpm check. (Matt)
    retarget Fixes tag since the issue occurs with the non-fault-mode
    path added by 4e7ebff69aed.
v3: handle this in xe_shrinker.c instead of xe_bo.c (Thomas)
v4: stop the walk once the scan target is met. (Sashiko)
v5: rebase on the freed page accounting fix. (Sashiko)
v6: reuse the shrinker acquire path so runtime pm can be resumed
    directly instead of always queueing a worker. (Thomas)
v7: replace xe_pm_runtime_put() with xe_shrinker_runtime_pm_put(). (Thomas)

Fixes: 4e7ebff69aed ("drm/xe/xe3p_lpg: flush shrinker bo cachelines manually")
Assisted-by: Claude:claude-opus-5
Cc: Tejas Upadhyay <tejas.upadhyay@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patch.msgid.link/20260909162102.1097006-3-shuicheng.lin@intel.com
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
(cherry picked from commit 628f92b28bf4c371c10207daf6fc4caee0c0db2e)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_shrinker.c | 78 +++++++++++++++++++++-----------
 1 file changed, 51 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_shrinker.c b/drivers/gpu/drm/xe/xe_shrinker.c
index 89445cd202380..deb4378c1ec15 100644
--- a/drivers/gpu/drm/xe/xe_shrinker.c
+++ b/drivers/gpu/drm/xe/xe_shrinker.c
@@ -54,13 +54,39 @@ xe_shrinker_mod_pages(struct xe_shrinker *shrinker, long shrinkable, long purgea
 	write_unlock(&shrinker->lock);
 }
 
-static int __xe_shrinker_walk(struct xe_device *xe,
+static bool __xe_shrinker_runtime_pm_get(struct xe_shrinker *shrinker)
+{
+	struct xe_device *xe = shrinker->xe;
+
+	if (xe_pm_runtime_get_if_active(xe))
+		return true;
+
+	if (xe_rpm_reclaim_safe(xe) && !ttm_bo_shrink_avoid_wait()) {
+		xe_pm_runtime_get(xe);
+		return true;
+	}
+
+	queue_work(xe->unordered_wq, &shrinker->pm_worker);
+
+	return false;
+}
+
+static void xe_shrinker_runtime_pm_put(struct xe_shrinker *shrinker, bool runtime_pm)
+{
+	if (runtime_pm)
+		xe_pm_runtime_put(shrinker->xe);
+}
+
+static int __xe_shrinker_walk(struct xe_shrinker *shrinker,
 			      struct ttm_operation_ctx *ctx,
 			      const struct xe_bo_shrink_flags flags,
 			      unsigned long to_scan, unsigned long *scanned,
 			      unsigned long *freed)
 {
+	struct xe_device *xe = shrinker->xe;
 	unsigned int mem_type;
+	bool rpm = false;
+	int ret = 0;
 	s64 lret;
 
 	for (mem_type = XE_PL_SYSTEM; mem_type <= XE_PL_TT; ++mem_type) {
@@ -75,23 +101,35 @@ static int __xe_shrinker_walk(struct xe_device *xe,
 		if (!man || !man->use_tt)
 			continue;
 
+		if (mem_type != XE_PL_SYSTEM && !rpm &&
+		    xe_device_is_l2_flush_optimized(xe)) {
+			if (!__xe_shrinker_runtime_pm_get(shrinker))
+				break;
+			rpm = true;
+		}
+
 		ttm_bo_lru_for_each_reserved_guarded(&curs, man, &arg, ttm_bo) {
 			if (!ttm_bo_shrink_suitable(ttm_bo, ctx))
 				continue;
 
 			lret = xe_bo_shrink(ctx, ttm_bo, flags, scanned);
-			if (lret < 0)
-				return lret;
+			if (lret < 0) {
+				ret = lret;
+				goto out;
+			}
 
 			*freed += lret;
 			if (*scanned >= to_scan)
-				break;
+				goto out;
 		}
 		/* Trylocks should never error, just fail. */
 		xe_assert(xe, !IS_ERR(ttm_bo));
 	}
 
-	return 0;
+out:
+	xe_shrinker_runtime_pm_put(shrinker, rpm);
+
+	return ret;
 }
 
 /*
@@ -100,7 +138,7 @@ static int __xe_shrinker_walk(struct xe_device *xe,
  * add writeback. This avoids stalls and explicit writebacks with light or
  * moderate memory pressure.
  */
-static int xe_shrinker_walk(struct xe_device *xe,
+static int xe_shrinker_walk(struct xe_shrinker *shrinker,
 			    struct ttm_operation_ctx *ctx,
 			    const struct xe_bo_shrink_flags flags,
 			    unsigned long to_scan, unsigned long *scanned,
@@ -112,20 +150,21 @@ static int xe_shrinker_walk(struct xe_device *xe,
 
 	swap(no_wait_gpu, ctx->no_wait_gpu);
 	save_flags.writeback = false;
-	ret = __xe_shrinker_walk(xe, ctx, save_flags, to_scan, scanned, freed);
+	ret = __xe_shrinker_walk(shrinker, ctx, save_flags, to_scan, scanned,
+				 freed);
 	swap(no_wait_gpu, ctx->no_wait_gpu);
 	if (ret || *scanned >= to_scan)
 		return ret;
 
 	if (!ctx->no_wait_gpu) {
-		ret = __xe_shrinker_walk(xe, ctx, save_flags, to_scan, scanned,
+		ret = __xe_shrinker_walk(shrinker, ctx, save_flags, to_scan, scanned,
 					 freed);
 		if (ret || *scanned >= to_scan)
 			return ret;
 	}
 
 	if (flags.writeback)
-		ret = __xe_shrinker_walk(xe, ctx, flags, to_scan, scanned,
+		ret = __xe_shrinker_walk(shrinker, ctx, flags, to_scan, scanned,
 					 freed);
 
 	return ret;
@@ -176,22 +215,7 @@ static bool xe_shrinker_runtime_pm_get(struct xe_shrinker *shrinker, bool force,
 			return false;
 	}
 
-	if (!xe_pm_runtime_get_if_active(xe)) {
-		if (xe_rpm_reclaim_safe(xe) && !ttm_bo_shrink_avoid_wait()) {
-			xe_pm_runtime_get(xe);
-			return true;
-		}
-		queue_work(xe->unordered_wq, &shrinker->pm_worker);
-		return false;
-	}
-
-	return true;
-}
-
-static void xe_shrinker_runtime_pm_put(struct xe_shrinker *shrinker, bool runtime_pm)
-{
-	if (runtime_pm)
-		xe_pm_runtime_put(shrinker->xe);
+	return __xe_shrinker_runtime_pm_get(shrinker);
 }
 
 static unsigned long xe_shrinker_scan(struct shrinker *shrink, struct shrink_control *sc)
@@ -221,7 +245,7 @@ static unsigned long xe_shrinker_scan(struct shrinker *shrink, struct shrink_con
 	runtime_pm = xe_shrinker_runtime_pm_get(shrinker, false, nr_to_scan, can_backup);
 
 	if (purgeable && nr_scanned < nr_to_scan)
-		xe_shrinker_walk(shrinker->xe, &ctx, shrink_flags,
+		xe_shrinker_walk(shrinker, &ctx, shrink_flags,
 				 nr_to_scan, &nr_scanned, &freed);
 
 	sc->nr_scanned = nr_scanned;
@@ -234,7 +258,7 @@ static unsigned long xe_shrinker_scan(struct shrinker *shrink, struct shrink_con
 
 	shrink_flags.purge = false;
 
-	xe_shrinker_walk(shrinker->xe, &ctx, shrink_flags,
+	xe_shrinker_walk(shrinker, &ctx, shrink_flags,
 			 nr_to_scan, &nr_scanned, &freed);
 
 	sc->nr_scanned = nr_scanned;
-- 
2.53.0



