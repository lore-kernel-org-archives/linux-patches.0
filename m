Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DA21C68C;
	Sun,  1 Sep 2024 16:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208326; cv=none; b=QTYbfusqQYP0lXCg3YoAgavr1ukphoCRsEgRxQ9yxtXxOBO7UIrK87x60IRyoM880ouKVH2+3g1i/eQTf4dKKm8N6mjT6asoILsi/jggCaBMTyEysOj1tOXp0UnLiOqRjngAutmmIHgAL2tLd+pnZGuA4AitjtyuEMubPeztCQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208326; c=relaxed/simple;
	bh=UQQ4SoBpBVQVEIw2VQqsk7Ze04yuhmyuIaRJhuRQoZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbIgmxsYePO0bz7syMmS8MfQMpoDPTgi6n5zaXAiw3JJ3UPsPaOeqEd/JmoeaB0il9wZRVBXGcUFNjo5hgLMCCmA4zTnpURdEnhWgy+yrJdXcmKTFW2W3HQkrRDghnGlRlhWtfMvuJzGCNFxYMS73LCvijKHfPvFkygssHOvdZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x9K6CRKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x9K6CRKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE59BC4CEC3;
	Sun,  1 Sep 2024 16:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208326;
	bh=UQQ4SoBpBVQVEIw2VQqsk7Ze04yuhmyuIaRJhuRQoZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x9K6CRKX+A7gVwv+yVBW/+A6vfIg5EKiAx7og73gesVapxCimVo4AxCSxS+dseTJh
	 SBqRgx4y3iOH49M55m16Js2qyPAq98Zt8lbZ0iJTxKNxbY1szrGDDo8qqJ699u8ccR
	 tfcXeO/sJo4o3NHVuFQ8TYx6aBfcBRhJ+UzzPXGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 048/149] drm/xe: prevent UAF around preempt fence
Date: Sun,  1 Sep 2024 18:15:59 +0200
Message-ID: <20240901160819.273641944@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 730b72480e29f63fd644f5fa57c9d46109428953 ]

The fence lock is part of the queue, therefore in the current design
anything locking the fence should then also hold a ref to the queue to
prevent the queue from being freed.

However, currently it looks like we signal the fence and then drop the
queue ref, but if something is waiting on the fence, the waiter is
kicked to wake up at some later point, where upon waking up it first
grabs the lock before checking the fence state. But if we have already
dropped the queue ref, then the lock might already be freed as part of
the queue, leading to uaf.

To prevent this, move the fence lock into the fence itself so we don't
run into lifetime issues. Alternative might be to have device level
lock, or only release the queue in the fence release callback, however
that might require pushing to another worker to avoid locking issues.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
References: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/2454
References: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/2342
References: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/2020
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240814110129.825847-2-matthew.auld@intel.com
(cherry picked from commit 7116c35aacedc38be6d15bd21b2fc936eed0008b)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_exec_queue.c          | 1 -
 drivers/gpu/drm/xe/xe_exec_queue_types.h    | 2 --
 drivers/gpu/drm/xe/xe_preempt_fence.c       | 3 ++-
 drivers/gpu/drm/xe/xe_preempt_fence_types.h | 2 ++
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_exec_queue.c b/drivers/gpu/drm/xe/xe_exec_queue.c
index 316731c5cce6d..ba7013f82c8b6 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue.c
+++ b/drivers/gpu/drm/xe/xe_exec_queue.c
@@ -632,7 +632,6 @@ int xe_exec_queue_create_ioctl(struct drm_device *dev, void *data,
 
 		if (xe_vm_in_preempt_fence_mode(vm)) {
 			q->lr.context = dma_fence_context_alloc(1);
-			spin_lock_init(&q->lr.lock);
 
 			err = xe_vm_add_compute_exec_queue(vm, q);
 			if (XE_IOCTL_DBG(xe, err))
diff --git a/drivers/gpu/drm/xe/xe_exec_queue_types.h b/drivers/gpu/drm/xe/xe_exec_queue_types.h
index 52a1965d91375..a5aa43942d8cf 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue_types.h
+++ b/drivers/gpu/drm/xe/xe_exec_queue_types.h
@@ -125,8 +125,6 @@ struct xe_exec_queue {
 		u32 seqno;
 		/** @lr.link: link into VM's list of exec queues */
 		struct list_head link;
-		/** @lr.lock: preemption fences lock */
-		spinlock_t lock;
 	} lr;
 
 	/** @ops: submission backend exec queue operations */
diff --git a/drivers/gpu/drm/xe/xe_preempt_fence.c b/drivers/gpu/drm/xe/xe_preempt_fence.c
index e8b8ae5c6485e..c453f45328b1c 100644
--- a/drivers/gpu/drm/xe/xe_preempt_fence.c
+++ b/drivers/gpu/drm/xe/xe_preempt_fence.c
@@ -128,8 +128,9 @@ xe_preempt_fence_arm(struct xe_preempt_fence *pfence, struct xe_exec_queue *q,
 {
 	list_del_init(&pfence->link);
 	pfence->q = xe_exec_queue_get(q);
+	spin_lock_init(&pfence->lock);
 	dma_fence_init(&pfence->base, &preempt_fence_ops,
-		      &q->lr.lock, context, seqno);
+		      &pfence->lock, context, seqno);
 
 	return &pfence->base;
 }
diff --git a/drivers/gpu/drm/xe/xe_preempt_fence_types.h b/drivers/gpu/drm/xe/xe_preempt_fence_types.h
index b54b5c29b5331..312c3372a49f9 100644
--- a/drivers/gpu/drm/xe/xe_preempt_fence_types.h
+++ b/drivers/gpu/drm/xe/xe_preempt_fence_types.h
@@ -25,6 +25,8 @@ struct xe_preempt_fence {
 	struct xe_exec_queue *q;
 	/** @preempt_work: work struct which issues preemption */
 	struct work_struct preempt_work;
+	/** @lock: dma-fence fence lock */
+	spinlock_t lock;
 	/** @error: preempt fence is in error state */
 	int error;
 };
-- 
2.43.0



