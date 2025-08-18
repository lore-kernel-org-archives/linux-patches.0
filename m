Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0374D31AF3A;
	Mon, 18 Aug 2025 13:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523922; cv=none; b=GDic1Mer77DgMQToCokf4AyUHwiiDufVCdO2siywoXcNAMvGrmeZtpdRoU/5nsQW0sIsA1ck+IU4j/NLwlFlaTO937d0IdFpu6Y/jZK2ZgSVWqO4FnqItERFxMPCkxpQcpX7owbthBIiYSsBsUtwa144F123DvqBRTdtQFLqTng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523922; c=relaxed/simple;
	bh=6iGMaJa+WDt4I2+6UEwj8APzdEzwr7cG7tgn+pbHGhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oaKzeGdppwL+eTb1TY5snLTa1CM4AzF7LIwzLO4FJYXUvDKeepV0hkS4Lufeuk8MoVEFuP/vVLRbEgOenBipb+aiS2/xrIMMJH8goUKcNtfb2k+NxBzBaqnqRLTAGUQuMWqwBTtGAiZvK/eISBON5RxNAdXM3Yoc0F51LYA0GMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hgif7Amc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgif7Amc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326DDC4CEF1;
	Mon, 18 Aug 2025 13:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523921;
	bh=6iGMaJa+WDt4I2+6UEwj8APzdEzwr7cG7tgn+pbHGhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgif7AmcnRAWmVZiEmkPgjXGEyOV77uHIeDe/lbykoKcEm0hLdq1SaF7MYmTOgOgp
	 ygiAakgIpsrCiu3T2gJtbeysXeFkahv+YMJP8wCJc8hqAzUSOTuullIpHBKnbpXsRK
	 lEMhEM5AUzBphpP2eeof24r5DT5AizhgmAXVUyxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 313/515] drm/xe: Make dma-fences compliant with the safe access rules
Date: Mon, 18 Aug 2025 14:44:59 +0200
Message-ID: <20250818124510.484911894@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 71ddd26ec30e..00ff6197e06f 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1282,7 +1282,11 @@ static void __guc_exec_queue_fini_async(struct work_struct *w)
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
@@ -1465,6 +1469,7 @@ static int guc_exec_queue_init(struct xe_exec_queue *q)
 
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



