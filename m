Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE9C2C11F9;
	Thu, 28 May 2026 20:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999606; cv=none; b=DcekJDemZixvSrNjF5h3C5EvwOjDLGHpra9wOQiCouRnCFPO6k0GMiiDoBhSW/fxVqffLDnbUccIEihKUoen3dnFByxclP/jQ34AfUgiwne/phRHTxgWokVB0QRgeGxMRzmfEJPTcPpYI+1LtqOhB16uGYIzZ76WGZAP/LReNQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999606; c=relaxed/simple;
	bh=8P4+ztg4zUxmN1dRBOCU+mxHtbh/WQQUxvR8NnzVcM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3NudUQCRt63kM7PxqMKVHHXEgwislr9vYLBSiZecUbGxgnjbePzv1n3dsH8oNEAKCQmABP6ps8yHJT0YtmmjivB3ErpfypMXNaBR+5plPB0qbnDjijupEIlcMqeiIwALS0KFKKaTZIXo4H7Kc2xxVWPKgBVmZjaa/TnLq8NVOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QiSZkT9j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QiSZkT9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9341F00A3A;
	Thu, 28 May 2026 20:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999605;
	bh=4+AcF2ebEKQ3RxiPDAUHKXcnS3sOPEaIGjCC/joda5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QiSZkT9jXmUme9S3DBhQX75Z1wwyUuAAhEzOHOXN+nauqYipwM+8wE9npxl/IF1m7
	 aftGctfKB6D/bHIDYlAEchAOUDgxSvey1nkArCEfJZk3nCTDM2y3soRV2HomAcp5lc
	 oG9ticdzkbadJiv3ljQo9NTGF599VPC0EfZh2D/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel J Blueman <daniel@quora.org>,
	Rob Clark <robin.clark@oss.qualcomm.com>
Subject: [PATCH 6.18 127/377] drm/msm: Fix shrinker deadlock
Date: Thu, 28 May 2026 21:46:05 +0200
Message-ID: <20260528194642.033052783@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel J Blueman <daniel@quora.org>

commit 3392291fc509d8ad6e4ad90f15b0a193f721cbc9 upstream.

With PROVE_LOCKING on an Snapdragon X1 and VM reclaim pressure, we see:

   ======================================================
   WARNING: possible circular locking dependency detected
   7.0.0-debug+ #43 Tainted: G        W
   ------------------------------------------------------
   kswapd0/82 is trying to acquire lock:
   ffff800080ec3870 (reservation_ww_class_acquire){+.+.}-{0:0}, at: msm_gem_shrinker_scan+0x17c/0x400 [msm]

   but task is already holding lock:
   ffffc31709b263b8 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x88/0x988

   which lock already depends on the new lock.

   the existing dependency chain (in reverse order) is:

   -> #2 (fs_reclaim){+.+.}-{0:0}:
          __lock_acquire+0x4d0/0xad0
          lock_acquire.part.0+0xc4/0x248
          lock_acquire+0x8c/0x248
          fs_reclaim_acquire+0xd0/0xf0
          dma_resv_lockdep+0x224/0x348
          do_one_initcall+0x84/0x5d0
          do_initcalls+0x194/0x1d8
          kernel_init_freeable+0x128/0x180
          kernel_init+0x2c/0x160
          ret_from_fork+0x10/0x20

   -> #1 (reservation_ww_class_mutex){+.+.}-{4:4}:
          __lock_acquire+0x4d0/0xad0
          lock_acquire.part.0+0xc4/0x248
          lock_acquire+0x8c/0x248
          dma_resv_lockdep+0x1a8/0x348
          do_one_initcall+0x84/0x5d0
          do_initcalls+0x194/0x1d8
          kernel_init_freeable+0x128/0x180
          kernel_init+0x2c/0x160
          ret_from_fork+0x10/0x20

   -> #0 (reservation_ww_class_acquire){+.+.}-{0:0}:
          check_prev_add+0x114/0x790
          validate_chain+0x594/0x6f0
          __lock_acquire+0x4d0/0xad0
          lock_acquire.part.0+0xc4/0x248
          lock_acquire+0x8c/0x248
          drm_gem_lru_scan+0x1ac/0x440
          msm_gem_shrinker_scan+0x17c/0x400 [msm]
          do_shrink_slab+0x150/0x4a0
          shrink_slab+0x144/0x460
          shrink_one+0x9c/0x1b0
          shrink_many+0x27c/0x5c0
          shrink_node+0x344/0x550
          balance_pgdat+0x2c0/0x988
          kswapd+0x11c/0x318
          kthread+0x10c/0x128
          ret_from_fork+0x10/0x20

   other info that might help us debug this:
   Chain exists of:
     reservation_ww_class_acquire --> reservation_ww_class_mutex --> fs_reclaim
    Possible unsafe locking scenario:
          CPU0                    CPU1
          ----                    ----
     lock(fs_reclaim);
                                  lock(reservation_ww_class_mutex);
                                  lock(fs_reclaim);
     lock(reservation_ww_class_acquire);

    *** DEADLOCK ***
   1 lock held by kswapd0/82:
    #0: ffffc31709b263b8 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x88/0x988

   stack backtrace:
   CPU: 4 UID: 0 PID: 82 Comm: kswapd0 Tainted: G        W           7.0.0-debug+ #43 PREEMPT(full)
   Tainted: [W]=WARN
   Hardware name: LENOVO 21BX0016US/21BX0016US, BIOS N3HET94W (1.66 ) 09/15/2025
   Call trace:
    show_stack+0x20/0x40 (C)
    dump_stack_lvl+0x9c/0xd0
    dump_stack+0x18/0x30
    print_circular_bug+0x114/0x120
    check_noncircular+0x178/0x198
    check_prev_add+0x114/0x790
    validate_chain+0x594/0x6f0
    __lock_acquire+0x4d0/0xad0
    lock_acquire.part.0+0xc4/0x248
    lock_acquire+0x8c/0x248
    drm_gem_lru_scan+0x1ac/0x440
    msm_gem_shrinker_scan+0x17c/0x400 [msm]
    do_shrink_slab+0x150/0x4a0
    shrink_slab+0x144/0x460
    shrink_one+0x9c/0x1b0
    shrink_many+0x27c/0x5c0
    shrink_node+0x344/0x550
    balance_pgdat+0x2c0/0x988
    kswapd+0x11c/0x318
    kthread+0x10c/0x128
    ret_from_fork+0x10/0x20

kswapd0 holding fs_reclaim calls the MSM shrinker, which calls
dma_resv_lock. This in turn acquires fs_reclaim.

Fix this deadlock by using dma_resv_trylock() instead, dropping the
subsequently unused passed wait-wound lock 'ticket'.

Cc: stable@vger.kernel.org
Signed-off-by: Daniel J Blueman <daniel@quora.org>
Fixes: fe4952b5f27c ("drm/msm: Convert vm locking")
Patchwork: https://patchwork.freedesktop.org/patch/723564/
Message-ID: <20260508065722.18785-1-daniel@quora.org>
[rob: fixup compile errors, replace lockdep splat with something legible]
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_gem_shrinker.c | 40 +++++++++++---------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_shrinker.c b/drivers/gpu/drm/msm/msm_gem_shrinker.c
index 31fa51a44f86..6e39e4e578bb 100644
--- a/drivers/gpu/drm/msm/msm_gem_shrinker.c
+++ b/drivers/gpu/drm/msm/msm_gem_shrinker.c
@@ -43,8 +43,7 @@ msm_gem_shrinker_count(struct shrinker *shrinker, struct shrink_control *sc)
 }
 
 static bool
-with_vm_locks(struct ww_acquire_ctx *ticket,
-	      void (*fn)(struct drm_gem_object *obj),
+with_vm_locks(void (*fn)(struct drm_gem_object *obj),
 	      struct drm_gem_object *obj)
 {
 	/*
@@ -52,7 +51,7 @@ with_vm_locks(struct ww_acquire_ctx *ticket,
 	 * success paths
 	 */
 	struct drm_gpuvm_bo *vm_bo, *last_locked = NULL;
-	int ret = 0;
+	bool locked = true;
 
 	drm_gem_for_each_gpuvm_bo (vm_bo, obj) {
 		struct dma_resv *resv = drm_gpuvm_resv(vm_bo->vm);
@@ -60,23 +59,14 @@ with_vm_locks(struct ww_acquire_ctx *ticket,
 		if (resv == obj->resv)
 			continue;
 
-		ret = dma_resv_lock(resv, ticket);
-
 		/*
-		 * Since we already skip the case when the VM and obj
-		 * share a resv (ie. _NO_SHARE objs), we don't expect
-		 * to hit a double-locking scenario... which the lock
-		 * unwinding cannot really cope with.
+		 * dma_resv_lock can't be used due to acquiring 'ticket' before the
+		 * fs_reclaim lock, which is held in shrinker context
 		 */
-		WARN_ON(ret == -EALREADY);
-
-		/*
-		 * Don't bother with slow-lock / backoff / retry sequence,
-		 * if we can't get the lock just give up and move on to
-		 * the next object.
-		 */
-		if (ret)
+		if (!dma_resv_trylock(resv)) {
+			locked = false;
 			goto out_unlock;
+		}
 
 		/*
 		 * Hold a ref to prevent the vm_bo from being freed
@@ -108,11 +98,11 @@ with_vm_locks(struct ww_acquire_ctx *ticket,
 		}
 	}
 
-	return ret == 0;
+	return locked;
 }
 
 static bool
-purge(struct drm_gem_object *obj, struct ww_acquire_ctx *ticket)
+purge(struct drm_gem_object *obj, struct ww_acquire_ctx *)
 {
 	if (!is_purgeable(to_msm_bo(obj)))
 		return false;
@@ -120,11 +110,11 @@ purge(struct drm_gem_object *obj, struct ww_acquire_ctx *ticket)
 	if (msm_gem_active(obj))
 		return false;
 
-	return with_vm_locks(ticket, msm_gem_purge, obj);
+	return with_vm_locks(msm_gem_purge, obj);
 }
 
 static bool
-evict(struct drm_gem_object *obj, struct ww_acquire_ctx *ticket)
+evict(struct drm_gem_object *obj, struct ww_acquire_ctx *)
 {
 	if (is_unevictable(to_msm_bo(obj)))
 		return false;
@@ -132,7 +122,7 @@ evict(struct drm_gem_object *obj, struct ww_acquire_ctx *ticket)
 	if (msm_gem_active(obj))
 		return false;
 
-	return with_vm_locks(ticket, msm_gem_evict, obj);
+	return with_vm_locks(msm_gem_evict, obj);
 }
 
 static bool
@@ -164,7 +154,6 @@ static unsigned long
 msm_gem_shrinker_scan(struct shrinker *shrinker, struct shrink_control *sc)
 {
 	struct msm_drm_private *priv = shrinker->private_data;
-	struct ww_acquire_ctx ticket;
 	struct {
 		struct drm_gem_lru *lru;
 		bool (*shrink)(struct drm_gem_object *obj, struct ww_acquire_ctx *ticket);
@@ -185,11 +174,14 @@ msm_gem_shrinker_scan(struct shrinker *shrinker, struct shrink_control *sc)
 	for (unsigned i = 0; (nr > 0) && (i < ARRAY_SIZE(stages)); i++) {
 		if (!stages[i].cond)
 			continue;
+		/*
+		 * 'ticket' not needed on trylock paths
+		 */
 		stages[i].freed =
 			drm_gem_lru_scan(stages[i].lru, nr,
 					 &stages[i].remaining,
 					 stages[i].shrink,
-					 &ticket);
+					 NULL);
 		nr -= stages[i].freed;
 		freed += stages[i].freed;
 		remaining += stages[i].remaining;
-- 
2.54.0



