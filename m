Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A4B3ACA6E;
	Tue, 17 Mar 2026 11:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747177; cv=none; b=tyOndiUHnz8EIXfMRYiZX8SGV9gBlN1s1IjsvGfBTo6u9nrAreyx2rc3Mj37tvrItfHL5SkomUgry2HCa/cdJKYXB6+5o2l7O/ng4lrWxtWz71dhpFBsOnVFiswNUJGhCIkLvEeRPTmuNhZs1RI/Bak0UoUvZim9Kjh+f9d4KJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747177; c=relaxed/simple;
	bh=JoY3wjqXlBLQwCBf5EGsT5scAUkxBv6AQ8kN3RbJJ8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lDabBCzAW+5His4gmXY37JXE40E9LhSLsEfLt/IflduphYzclyXpSI3oVsxfpAznexecsE94bnJiekTqyiVDxfW70MzilDaRuKaBq84iTKzLq7Re30U9kYgz0lExts5twi10wFmvsAusL5g7gfWVp/oI82aFaFkqupXaYVdnpts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tYMXbmV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tYMXbmV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29B7C2BCAF;
	Tue, 17 Mar 2026 11:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773747176;
	bh=JoY3wjqXlBLQwCBf5EGsT5scAUkxBv6AQ8kN3RbJJ8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYMXbmV8HvxHLC7+qMQ3A1Ff3GVmE575s7C+ZSBZyIxSsLH+NxCULciT7nG4IOX2F
	 VP6vRsGPZXD8npSXpJkPqW8diMVioKx5ir02qQjbNIKRJyWMbkjSdtfj1s/U80wFit
	 r9ksHYII8LDEySXxXURU3FTl05KmvPy7KF/S/rcS3VruWNSEjTbgLYDx8VGzD1cqWR
	 +zg2kr90kNEJvb8MxHQ6b4M8lt0jGl4UrwwU9Lha3ZV9dT8jMRmhf57EVfX1oFW6aV
	 7OHFGDkb4nlbzdjyXtW+vU556xfll/Ic7uBGP8ISAGnt3sDsEUhz611w3Lc2mXuwud
	 /RnByuH/wKwHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] nvmet: move async event work off nvmet-wq
Date: Tue, 17 Mar 2026 07:32:36 -0400
Message-ID: <20260317113249.117771-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260317113249.117771-1-sashal@kernel.org>
References: <20260317113249.117771-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chaitanya Kulkarni <kch@nvidia.com>

[ Upstream commit 2922e3507f6d5caa7f1d07f145e186fc6f317a4e ]

For target nvmet_ctrl_free() flushes ctrl->async_event_work.
If nvmet_ctrl_free() runs on nvmet-wq, the flush re-enters workqueue
completion for the same worker:-

A. Async event work queued on nvmet-wq (prior to disconnect):
  nvmet_execute_async_event()
     queue_work(nvmet_wq, &ctrl->async_event_work)

  nvmet_add_async_event()
     queue_work(nvmet_wq, &ctrl->async_event_work)

B. Full pre-work chain (RDMA CM path):
  nvmet_rdma_cm_handler()
     nvmet_rdma_queue_disconnect()
       __nvmet_rdma_queue_disconnect()
         queue_work(nvmet_wq, &queue->release_work)
           process_one_work()
             lock((wq_completion)nvmet-wq)  <--------- 1st
             nvmet_rdma_release_queue_work()

C. Recursive path (same worker):
  nvmet_rdma_release_queue_work()
     nvmet_rdma_free_queue()
       nvmet_sq_destroy()
         nvmet_ctrl_put()
           nvmet_ctrl_free()
             flush_work(&ctrl->async_event_work)
               __flush_work()
                 touch_wq_lockdep_map()
                 lock((wq_completion)nvmet-wq) <--------- 2nd

Lockdep splat:

  ============================================
  WARNING: possible recursive locking detected
  6.19.0-rc3nvme+ #14 Tainted: G                 N
  --------------------------------------------
  kworker/u192:42/44933 is trying to acquire lock:
  ffff888118a00948 ((wq_completion)nvmet-wq){+.+.}-{0:0}, at: touch_wq_lockdep_map+0x26/0x90

  but task is already holding lock:
  ffff888118a00948 ((wq_completion)nvmet-wq){+.+.}-{0:0}, at: process_one_work+0x53e/0x660

  3 locks held by kworker/u192:42/44933:
   #0: ffff888118a00948 ((wq_completion)nvmet-wq){+.+.}-{0:0}, at: process_one_work+0x53e/0x660
   #1: ffffc9000e6cbe28 ((work_completion)(&queue->release_work)){+.+.}-{0:0}, at: process_one_work+0x1c5/0x660
   #2: ffffffff82d4db60 (rcu_read_lock){....}-{1:3}, at: __flush_work+0x62/0x530

  Workqueue: nvmet-wq nvmet_rdma_release_queue_work [nvmet_rdma]
  Call Trace:
   __flush_work+0x268/0x530
   nvmet_ctrl_free+0x140/0x310 [nvmet]
   nvmet_cq_put+0x74/0x90 [nvmet]
   nvmet_rdma_free_queue+0x23/0xe0 [nvmet_rdma]
   nvmet_rdma_release_queue_work+0x19/0x50 [nvmet_rdma]
   process_one_work+0x206/0x660
   worker_thread+0x184/0x320
   kthread+0x10c/0x240
   ret_from_fork+0x319/0x390

Move async event work to a dedicated nvmet-aen-wq to avoid reentrant
flush on nvmet-wq.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Problem Description
This commit fixes a **recursive workqueue locking deadlock** in the NVMe
target subsystem. When `nvmet_ctrl_free()` is called from a work item
running on `nvmet-wq` (e.g., via the RDMA CM disconnect path), it calls
`flush_work(&ctrl->async_event_work)`. Since `async_event_work` is also
queued on the same `nvmet-wq`, this causes a recursive acquisition of
the workqueue completion lock, triggering a lockdep warning and
potentially a real deadlock.

The call chain is clearly documented in the commit message:
1. RDMA CM handler queues `release_work` on `nvmet-wq`
2. `nvmet_rdma_release_queue_work()` → `nvmet_rdma_free_queue()` →
   `nvmet_sq_destroy()` → `nvmet_ctrl_put()` → `nvmet_ctrl_free()`
3. `nvmet_ctrl_free()` calls `flush_work(&ctrl->async_event_work)` — but
   `async_event_work` is on the same `nvmet-wq`

### Fix Description
The fix creates a new dedicated workqueue `nvmet-aen-wq` and moves the
two `queue_work()` calls for `async_event_work` from `nvmet_wq` to
`nvmet_aen_wq`. It also adds `flush_workqueue(nvmet_aen_wq)` in
`nvmet_rdma_remove_one()` alongside the existing
`flush_workqueue(nvmet_wq)`.

### Stable Kernel Criteria Assessment

1. **Fixes a real bug**: YES — This fixes a deadlock/recursive locking
   issue with a concrete lockdep splat included in the commit message.
   The RDMA disconnect path can trigger this in production.

2. **Obviously correct and tested**: YES — The fix is straightforward:
   move work to a separate workqueue so flushing it from the original
   workqueue doesn't deadlock. Reviewed by Christoph Hellwig (NVMe
   subsystem expert). This follows the same pattern as prior fixes
   (commit `710c69dbaccda` "nvmet-fc: avoid deadlock on delete
   association path").

3. **Small and contained**: YES — Changes are minimal:
   - Add a new workqueue variable declaration and initialization
   - Change two `queue_work()` calls from `nvmet_wq` to `nvmet_aen_wq`
   - Add one `flush_workqueue()` call in RDMA cleanup
   - Proper init/cleanup in module init/exit

4. **No new features**: Correct — This only fixes a deadlock by
   separating workqueues.

5. **Severity**: HIGH — Deadlocks can hang the system. NVMe target users
   (storage servers, NVMe-oF deployments) would hit this during
   disconnect/reconnect scenarios.

### Risk Assessment
- **Risk**: LOW — The change is purely mechanical: moving work items
  from one workqueue to another. The work function itself is unchanged.
  The new workqueue has the same flags minus `WQ_SYSFS`.
- **Dependencies**: The bug has existed since commit `8832cf922151`
  (2022) which introduced `nvmet_wq`. This fix is self-contained and
  should apply to any stable tree that has `nvmet_wq`.
- **Regression potential**: Very low — the async event work is isolated
  and doesn't interact with other work items on `nvmet_wq` in any
  ordering-dependent way.

### Verification
- Verified `flush_work(&ctrl->async_event_work)` exists at
  `drivers/nvme/target/core.c:1746` in `nvmet_ctrl_free()`
- Verified `nvmet_wq` was introduced in commit `8832cf922151`
  (2022-03-21), confirming the bug has existed for ~4 years
- Verified there are exactly two callers of `queue_work(nvmet_wq,
  &ctrl->async_event_work)` — both changed by this patch
- Verified similar deadlock fixes have been merged before (commit
  `710c69dbaccda` for nvmet-fc)
- Verified the commit is reviewed by Christoph Hellwig and signed off by
  Keith Busch (NVMe maintainer)
- Verified the lockdep splat in the commit message matches the described
  call chain
- Could not verify if this commit is already in any stable queue (not in
  current 6.19.8 tree)

This is a clear, well-documented deadlock fix with low risk, small
scope, expert review, and high user impact for NVMe-oF deployments. It
meets all stable kernel criteria.

**YES**

 drivers/nvme/target/admin-cmd.c |  2 +-
 drivers/nvme/target/core.c      | 14 ++++++++++++--
 drivers/nvme/target/nvmet.h     |  1 +
 drivers/nvme/target/rdma.c      |  1 +
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 3da31bb1183eb..100d1466ff841 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -1586,7 +1586,7 @@ void nvmet_execute_async_event(struct nvmet_req *req)
 	ctrl->async_event_cmds[ctrl->nr_async_event_cmds++] = req;
 	mutex_unlock(&ctrl->lock);
 
-	queue_work(nvmet_wq, &ctrl->async_event_work);
+	queue_work(nvmet_aen_wq, &ctrl->async_event_work);
 }
 
 void nvmet_execute_keep_alive(struct nvmet_req *req)
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index cc88e5a28c8a9..5075f7123358a 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -26,6 +26,8 @@ static DEFINE_IDA(cntlid_ida);
 
 struct workqueue_struct *nvmet_wq;
 EXPORT_SYMBOL_GPL(nvmet_wq);
+struct workqueue_struct *nvmet_aen_wq;
+EXPORT_SYMBOL_GPL(nvmet_aen_wq);
 
 /*
  * This read/write semaphore is used to synchronize access to configuration
@@ -205,7 +207,7 @@ void nvmet_add_async_event(struct nvmet_ctrl *ctrl, u8 event_type,
 	list_add_tail(&aen->entry, &ctrl->async_events);
 	mutex_unlock(&ctrl->lock);
 
-	queue_work(nvmet_wq, &ctrl->async_event_work);
+	queue_work(nvmet_aen_wq, &ctrl->async_event_work);
 }
 
 static void nvmet_add_to_changed_ns_log(struct nvmet_ctrl *ctrl, __le32 nsid)
@@ -1958,9 +1960,14 @@ static int __init nvmet_init(void)
 	if (!nvmet_wq)
 		goto out_free_buffered_work_queue;
 
+	nvmet_aen_wq = alloc_workqueue("nvmet-aen-wq",
+			WQ_MEM_RECLAIM | WQ_UNBOUND, 0);
+	if (!nvmet_aen_wq)
+		goto out_free_nvmet_work_queue;
+
 	error = nvmet_init_debugfs();
 	if (error)
-		goto out_free_nvmet_work_queue;
+		goto out_free_nvmet_aen_work_queue;
 
 	error = nvmet_init_discovery();
 	if (error)
@@ -1976,6 +1983,8 @@ static int __init nvmet_init(void)
 	nvmet_exit_discovery();
 out_exit_debugfs:
 	nvmet_exit_debugfs();
+out_free_nvmet_aen_work_queue:
+	destroy_workqueue(nvmet_aen_wq);
 out_free_nvmet_work_queue:
 	destroy_workqueue(nvmet_wq);
 out_free_buffered_work_queue:
@@ -1993,6 +2002,7 @@ static void __exit nvmet_exit(void)
 	nvmet_exit_discovery();
 	nvmet_exit_debugfs();
 	ida_destroy(&cntlid_ida);
+	destroy_workqueue(nvmet_aen_wq);
 	destroy_workqueue(nvmet_wq);
 	destroy_workqueue(buffered_io_wq);
 	destroy_workqueue(zbd_wq);
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index b664b584fdc8e..319d6a5e9cf05 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -501,6 +501,7 @@ extern struct kmem_cache *nvmet_bvec_cache;
 extern struct workqueue_struct *buffered_io_wq;
 extern struct workqueue_struct *zbd_wq;
 extern struct workqueue_struct *nvmet_wq;
+extern struct workqueue_struct *nvmet_aen_wq;
 
 static inline void nvmet_set_result(struct nvmet_req *req, u32 result)
 {
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 9c12b2361a6d7..0384323649671 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -2088,6 +2088,7 @@ static void nvmet_rdma_remove_one(struct ib_device *ib_device, void *client_data
 	mutex_unlock(&nvmet_rdma_queue_mutex);
 
 	flush_workqueue(nvmet_wq);
+	flush_workqueue(nvmet_aen_wq);
 }
 
 static struct ib_client nvmet_rdma_ib_client = {
-- 
2.51.0

