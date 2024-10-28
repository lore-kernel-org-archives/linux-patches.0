Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15368837;
	Mon, 28 Oct 2024 06:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098131; cv=none; b=sefLP/D0qGBreRbOaTmAqXfjXvZstZoHd/rOIN+IkPAZJxE9FkH7KezELAB/rEiZP6vFSC3Bg4aewxHV2/blbIg32ftXnz0CxLcHzzhEzdEX1beLBtSNwS1t704vNJd5wPtuMjnNKVqAklvRa+nKHIL+uH5sCIt0/2q1Mpam2xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098131; c=relaxed/simple;
	bh=nlH2y0uCQwTVXf5+l0wF3VORVvThDYMf+gMNrY9zBg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMIvM7tn1Wf9+MV+yN0tWrgV0MpRDeZtdK1YJAOFs81q55Gi4He1CF2V7ryIw9McnOt7qoJk4CGeRV1lE4fZWWxfwkUE8gOawjKZz/GjYFcaAfsf0aNQKMC3T3YX4oeQ65VQmoNSiLkcL97k4XfTyngfnvdtDPnH0eOWDiy/a04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WvhN6BaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WvhN6BaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C48FC4CEC3;
	Mon, 28 Oct 2024 06:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098130;
	bh=nlH2y0uCQwTVXf5+l0wF3VORVvThDYMf+gMNrY9zBg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvhN6BaAgqkjYy+0qJmQkDTkYCt2Vo8GRGoZTLnMy2yomqKTcpvrtjfptKcLq4Tkc
	 CRUhoMquwIZkPH86jMopCa/5w3ypkOrrOL9VIbtOepF2CRli+cIxy10zQCi+OqLIpx
	 dprXp6LaBfR7quHf28t/rPmUZE6FECe7gJPWkC9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 089/261] drm/xe: fix unbalanced rpm put() with fence_fini()
Date: Mon, 28 Oct 2024 07:23:51 +0100
Message-ID: <20241028062314.263588100@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 03a86c24aea0920a1ca20a0d7771d5e176db538d ]

Currently we can call fence_fini() twice if something goes wrong when
sending the GuC CT for the tlb request, since we signal the fence and
return an error, leading to the caller also calling fini() on the error
path in the case of stack version of the flow, which leads to an extra
rpm put() which might later cause device to enter suspend when it
shouldn't. It looks like we can just drop the fini() call since the
fence signaller side will already call this for us.

There are known mysterious splats with device going to sleep even with
an rpm ref, and this could be one candidate.

v2 (Matt B):
  - Prefer warning if we detect double fini()

Fixes: f002702290fc ("drm/xe: Hold a PM ref when GT TLB invalidations are inflight")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241009084808.204432-3-matthew.auld@intel.com
(cherry picked from commit cfcbc0520d5055825f0647ab922b655688605183)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c | 29 +++++++++------------
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h |  1 -
 drivers/gpu/drm/xe/xe_vm.c                  |  8 ++----
 3 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c
index 87cb76a8718c9..82795133e129e 100644
--- a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c
+++ b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c
@@ -36,6 +36,15 @@ static long tlb_timeout_jiffies(struct xe_gt *gt)
 	return hw_tlb_timeout + 2 * delay;
 }
 
+static void xe_gt_tlb_invalidation_fence_fini(struct xe_gt_tlb_invalidation_fence *fence)
+{
+	if (WARN_ON_ONCE(!fence->gt))
+		return;
+
+	xe_pm_runtime_put(gt_to_xe(fence->gt));
+	fence->gt = NULL; /* fini() should be called once */
+}
+
 static void
 __invalidation_fence_signal(struct xe_device *xe, struct xe_gt_tlb_invalidation_fence *fence)
 {
@@ -203,7 +212,7 @@ static int send_tlb_invalidation(struct xe_guc *guc,
 						   tlb_timeout_jiffies(gt));
 		}
 		spin_unlock_irq(&gt->tlb_invalidation.pending_lock);
-	} else if (ret < 0) {
+	} else {
 		__invalidation_fence_signal(xe, fence);
 	}
 	if (!ret) {
@@ -265,10 +274,8 @@ int xe_gt_tlb_invalidation_ggtt(struct xe_gt *gt)
 
 		xe_gt_tlb_invalidation_fence_init(gt, &fence, true);
 		ret = xe_gt_tlb_invalidation_guc(gt, &fence);
-		if (ret < 0) {
-			xe_gt_tlb_invalidation_fence_fini(&fence);
+		if (ret)
 			return ret;
-		}
 
 		xe_gt_tlb_invalidation_fence_wait(&fence);
 	} else if (xe_device_uc_enabled(xe) && !xe_device_wedged(xe)) {
@@ -494,7 +501,8 @@ static const struct dma_fence_ops invalidation_fence_ops = {
  * @stack: fence is stack variable
  *
  * Initialize TLB invalidation fence for use. xe_gt_tlb_invalidation_fence_fini
- * must be called if fence is not signaled.
+ * will be automatically called when fence is signalled (all fences must signal),
+ * even on error.
  */
 void xe_gt_tlb_invalidation_fence_init(struct xe_gt *gt,
 				       struct xe_gt_tlb_invalidation_fence *fence,
@@ -514,14 +522,3 @@ void xe_gt_tlb_invalidation_fence_init(struct xe_gt *gt,
 		dma_fence_get(&fence->base);
 	fence->gt = gt;
 }
-
-/**
- * xe_gt_tlb_invalidation_fence_fini - Finalize TLB invalidation fence
- * @fence: TLB invalidation fence to finalize
- *
- * Drop PM ref which fence took durinig init.
- */
-void xe_gt_tlb_invalidation_fence_fini(struct xe_gt_tlb_invalidation_fence *fence)
-{
-	xe_pm_runtime_put(gt_to_xe(fence->gt));
-}
diff --git a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h
index a84065fa324c7..f430d5797af70 100644
--- a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h
+++ b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h
@@ -28,7 +28,6 @@ int xe_guc_tlb_invalidation_done_handler(struct xe_guc *guc, u32 *msg, u32 len);
 void xe_gt_tlb_invalidation_fence_init(struct xe_gt *gt,
 				       struct xe_gt_tlb_invalidation_fence *fence,
 				       bool stack);
-void xe_gt_tlb_invalidation_fence_fini(struct xe_gt_tlb_invalidation_fence *fence);
 
 static inline void
 xe_gt_tlb_invalidation_fence_wait(struct xe_gt_tlb_invalidation_fence *fence)
diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 49ba9a1e375f4..3ac41f70ea6b1 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -3377,10 +3377,8 @@ int xe_vm_invalidate_vma(struct xe_vma *vma)
 
 			ret = xe_gt_tlb_invalidation_vma(tile->primary_gt,
 							 &fence[fence_id], vma);
-			if (ret < 0) {
-				xe_gt_tlb_invalidation_fence_fini(&fence[fence_id]);
+			if (ret)
 				goto wait;
-			}
 			++fence_id;
 
 			if (!tile->media_gt)
@@ -3392,10 +3390,8 @@ int xe_vm_invalidate_vma(struct xe_vma *vma)
 
 			ret = xe_gt_tlb_invalidation_vma(tile->media_gt,
 							 &fence[fence_id], vma);
-			if (ret < 0) {
-				xe_gt_tlb_invalidation_fence_fini(&fence[fence_id]);
+			if (ret)
 				goto wait;
-			}
 			++fence_id;
 		}
 	}
-- 
2.43.0



