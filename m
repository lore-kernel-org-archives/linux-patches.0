Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9511D248BAF;
	Wed, 15 Jan 2025 11:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938873; cv=none; b=F/SRSlR5QqJK41uQJyrQu3K5rIJAfUAKjlXzlxmlsiLanjyDVpygFcnkPrODnumPD3O4i3z2Itogr8gDmBvO74BI7c5lu8daZlwm2RCVaAJV26p2ObwwxJWoyql6AF9GCcgiWR9q/WMmp4MX6p/bCDpPH6mQucE3o4btZ5jy1Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938873; c=relaxed/simple;
	bh=9Q68S/ZzStzxfX+IuZvrDZyRvnRpv/MYzb7riuaJsVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wq6QxRqE/+zT6AcDHJ+wVFEJoi+EQO193vWuBarDPlk6VpBesOOqYLJZdfzjnPMm8JiTAYv6lSFl7pBifFJYnqSgsfJ5ZR38K6a7TXWNsHq5x1J6CbmGRBW7bACHHv0LJUspBDl6oACI5Thx+LZwRsCW7rJHJ3rL9PgR116YlyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H0HAnUK1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0HAnUK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05830C4CEDF;
	Wed, 15 Jan 2025 11:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938873;
	bh=9Q68S/ZzStzxfX+IuZvrDZyRvnRpv/MYzb7riuaJsVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0HAnUK1wY+waC8oAikJ9lNe0LlbFSUp7+BDgxM/cIw6smD0X/8kJwcuW8tZoxkti
	 7xNXgWu1u/YKHSDVN7WZmayidsL+Jv5bwzpz1K/Qwl/JaetSwIpnQpXKB0cXWOXgYT
	 Jhr2cueC7QMSfRD3cBY7rSGK3IfEmVuNackdxieY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/129] workqueue: Do not warn when cancelling WQ_MEM_RECLAIM work from !WQ_MEM_RECLAIM worker
Date: Wed, 15 Jan 2025 11:38:18 +0100
Message-ID: <20250115103559.256515275@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit de35994ecd2dd6148ab5a6c5050a1670a04dec77 ]

After commit
746ae46c1113 ("drm/sched: Mark scheduler work queues with WQ_MEM_RECLAIM")
amdgpu started seeing the following warning:

 [ ] workqueue: WQ_MEM_RECLAIM sdma0:drm_sched_run_job_work [gpu_sched] is flushing !WQ_MEM_RECLAIM events:amdgpu_device_delay_enable_gfx_off [amdgpu]
...
 [ ] Workqueue: sdma0 drm_sched_run_job_work [gpu_sched]
...
 [ ] Call Trace:
 [ ]  <TASK>
...
 [ ]  ? check_flush_dependency+0xf5/0x110
...
 [ ]  cancel_delayed_work_sync+0x6e/0x80
 [ ]  amdgpu_gfx_off_ctrl+0xab/0x140 [amdgpu]
 [ ]  amdgpu_ring_alloc+0x40/0x50 [amdgpu]
 [ ]  amdgpu_ib_schedule+0xf4/0x810 [amdgpu]
 [ ]  ? drm_sched_run_job_work+0x22c/0x430 [gpu_sched]
 [ ]  amdgpu_job_run+0xaa/0x1f0 [amdgpu]
 [ ]  drm_sched_run_job_work+0x257/0x430 [gpu_sched]
 [ ]  process_one_work+0x217/0x720
...
 [ ]  </TASK>

The intent of the verifcation done in check_flush_depedency is to ensure
forward progress during memory reclaim, by flagging cases when either a
memory reclaim process, or a memory reclaim work item is flushed from a
context not marked as memory reclaim safe.

This is correct when flushing, but when called from the
cancel(_delayed)_work_sync() paths it is a false positive because work is
either already running, or will not be running at all. Therefore
cancelling it is safe and we can relax the warning criteria by letting the
helper know of the calling context.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: fca839c00a12 ("workqueue: warn if memory reclaim tries to flush !WQ_MEM_RECLAIM workqueue")
References: 746ae46c1113 ("drm/sched: Mark scheduler work queues with WQ_MEM_RECLAIM")
Cc: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index da5750246a92..59b6efb2a11c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2947,23 +2947,27 @@ static int rescuer_thread(void *__rescuer)
  * check_flush_dependency - check for flush dependency sanity
  * @target_wq: workqueue being flushed
  * @target_work: work item being flushed (NULL for workqueue flushes)
+ * @from_cancel: are we called from the work cancel path
  *
  * %current is trying to flush the whole @target_wq or @target_work on it.
- * If @target_wq doesn't have %WQ_MEM_RECLAIM, verify that %current is not
- * reclaiming memory or running on a workqueue which doesn't have
- * %WQ_MEM_RECLAIM as that can break forward-progress guarantee leading to
- * a deadlock.
+ * If this is not the cancel path (which implies work being flushed is either
+ * already running, or will not be at all), check if @target_wq doesn't have
+ * %WQ_MEM_RECLAIM and verify that %current is not reclaiming memory or running
+ * on a workqueue which doesn't have %WQ_MEM_RECLAIM as that can break forward-
+ * progress guarantee leading to a deadlock.
  */
 static void check_flush_dependency(struct workqueue_struct *target_wq,
-				   struct work_struct *target_work)
+				   struct work_struct *target_work,
+				   bool from_cancel)
 {
-	work_func_t target_func = target_work ? target_work->func : NULL;
+	work_func_t target_func;
 	struct worker *worker;
 
-	if (target_wq->flags & WQ_MEM_RECLAIM)
+	if (from_cancel || target_wq->flags & WQ_MEM_RECLAIM)
 		return;
 
 	worker = current_wq_worker();
+	target_func = target_work ? target_work->func : NULL;
 
 	WARN_ONCE(current->flags & PF_MEMALLOC,
 		  "workqueue: PF_MEMALLOC task %d(%s) is flushing !WQ_MEM_RECLAIM %s:%ps",
@@ -3208,7 +3212,7 @@ void __flush_workqueue(struct workqueue_struct *wq)
 		list_add_tail(&this_flusher.list, &wq->flusher_overflow);
 	}
 
-	check_flush_dependency(wq, NULL);
+	check_flush_dependency(wq, NULL, false);
 
 	mutex_unlock(&wq->mutex);
 
@@ -3385,7 +3389,7 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
 	}
 
 	wq = pwq->wq;
-	check_flush_dependency(wq, work);
+	check_flush_dependency(wq, work, from_cancel);
 
 	insert_wq_barrier(pwq, barr, work, worker);
 	raw_spin_unlock_irq(&pool->lock);
-- 
2.39.5



