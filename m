Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EAE3090C5;
	Mon, 18 Aug 2025 14:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525723; cv=none; b=mq2iXWuK6yyYeQ6M/Xz7h6U9VkVFHBDJkm9w/Tr/ll93T+Q55pQhJMklVRSKom6/GomyaQkwXA/LZ4ZlhuRUhVvE3M6XQLCnd/pro36QxYrjRmJQuvAVzp2AA6VK84lEhadgNlOchOMrHODIPiYw7ieLLzokOkU72F4xgcQswpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525723; c=relaxed/simple;
	bh=V7WwxkPaz3Cl3J9Xb3dJ5La8ZCdRULfPdpLQfQK4vpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5d65MUyBekvAd1ZiIchoQJ9mzrkhxXgG50+QRbNhqsxh4OFIoK8fBLJe/WTxlZqN0RGF6xu7NSb8YoJhH1EmkB16snyt8JeIpzk1D4tMvPR+uePBu2VBkZBKS6ZR4ToFsQNMKIjbRDGWygXLky5X1LmsNZoMiiI0sNj5p0XLNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WEUOadeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WEUOadeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861C9C4CEEB;
	Mon, 18 Aug 2025 14:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525722;
	bh=V7WwxkPaz3Cl3J9Xb3dJ5La8ZCdRULfPdpLQfQK4vpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WEUOadeEY0U502TLUdpoLJvOF3Rc2wQ8pjR44Ys3v3FejqrWRS996Et+EUD9aWl6M
	 CebcGkv3Hhw9C4KvFNmoDltPjzrdRJAh+OUx4mdBBYeTaP3/W3DI92/SFphTiJmSyN
	 ThrztWHUF5hG8Hpp9H5fg3YVQRtKeZeLC1YX3sbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 340/570] drm/xe: Make dma-fences compliant with the safe access rules
Date: Mon, 18 Aug 2025 14:45:27 +0200
Message-ID: <20250818124518.952241682@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit 6bd90e700b4285e6a7541e00f969cab0d696adde ]

Xe can free some of the data pointed to by the dma-fences it exports. Most
notably the timeline name can get freed if userspace closes the associated
submit queue. At the same time the fence could have been exported to a
third party (for example a sync_fence fd) which will then cause an use-
after-free on subsequent access.

To make this safe we need to make the driver compliant with the newly
documented dma-fence rules. Driver has to ensure a RCU grace period
between signalling a fence and freeing any data pointed to by said fence.

For the timeline name we simply make the queue be freed via kfree_rcu and
for the shared lock associated with multiple queues we add a RCU grace
period before freeing the per GT structure holding the lock.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Acked-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Link: https://lore.kernel.org/r/20250610164226.10817-5-tvrtko.ursulin@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_exec_queue_types.h | 2 ++
 drivers/gpu/drm/xe/xe_guc_submit.c           | 7 ++++++-
 drivers/gpu/drm/xe/xe_hw_fence.c             | 3 +++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_exec_queue_types.h b/drivers/gpu/drm/xe/xe_guc_exec_queue_types.h
index 4c39f01e4f52..a3f421e2adc0 100644
--- a/drivers/gpu/drm/xe/xe_guc_exec_queue_types.h
+++ b/drivers/gpu/drm/xe/xe_guc_exec_queue_types.h
@@ -20,6 +20,8 @@ struct xe_exec_queue;
 struct xe_guc_exec_queue {
 	/** @q: Backpointer to parent xe_exec_queue */
 	struct xe_exec_queue *q;
+	/** @rcu: For safe freeing of exported dma fences */
+	struct rcu_head rcu;
 	/** @sched: GPU scheduler for this xe_exec_queue */
 	struct xe_gpu_scheduler sched;
 	/** @entity: Scheduler entity for this xe_exec_queue */
diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index 2ac87ff4a057..ef3e9e1588f7 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1287,7 +1287,11 @@ static void __guc_exec_queue_fini_async(struct work_struct *w)
 	xe_sched_entity_fini(&ge->entity);
 	xe_sched_fini(&ge->sched);
 
-	kfree(ge);
+	/*
+	 * RCU free due sched being exported via DRM scheduler fences
+	 * (timeline name).
+	 */
+	kfree_rcu(ge, rcu);
 	xe_exec_queue_fini(q);
 	xe_pm_runtime_put(guc_to_xe(guc));
 }
@@ -1470,6 +1474,7 @@ static int guc_exec_queue_init(struct xe_exec_queue *q)
 
 	q->guc = ge;
 	ge->q = q;
+	init_rcu_head(&ge->rcu);
 	init_waitqueue_head(&ge->suspend_wait);
 
 	for (i = 0; i < MAX_STATIC_MSG_TYPE; ++i)
diff --git a/drivers/gpu/drm/xe/xe_hw_fence.c b/drivers/gpu/drm/xe/xe_hw_fence.c
index 0b4f12be3692..6e2221b60688 100644
--- a/drivers/gpu/drm/xe/xe_hw_fence.c
+++ b/drivers/gpu/drm/xe/xe_hw_fence.c
@@ -100,6 +100,9 @@ void xe_hw_fence_irq_finish(struct xe_hw_fence_irq *irq)
 		spin_unlock_irqrestore(&irq->lock, flags);
 		dma_fence_end_signalling(tmp);
 	}
+
+	/* Safe release of the irq->lock used in dma_fence_init. */
+	synchronize_rcu();
 }
 
 void xe_hw_fence_irq_run(struct xe_hw_fence_irq *irq)
-- 
2.39.5



