Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4CE2D0C94;
	Tue, 31 Mar 2026 17:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976443; cv=none; b=XoIxt7baj511Uo3b6xOTjcC5mJfVz8dNczCwlLESl31YV1ehH6ea1Ae17VIRPWMCKXUO/HqEGqFkqq+cuYzgEATosSCtZGVe52lUA9esap+JBdb6uMQrkkT1xeXhjmtwmGFgEYFo9y44UObEr2a+t5pC6fB6mac6RmA2bjCJEjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976443; c=relaxed/simple;
	bh=I32MGCO7NoUuXjbts+gzS/D5cdCeXvgoTtrUsE51alo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVGpxaS0pYqOzWGlQpCqkipx20/J6rgn2cbmjsw//gZeFg2CsNJ3shN4mnBPp0UfMsXLKHrE4PpXj2hPW3sKSrO9us8aBSZJHiljHjcZBBbH7QlsHz9kHC+q14ZGUE0sH1Cr3p+p+g6CoNj6d8QBTKEqiPOmDVmRs2IXGdRvqiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ElfENqIU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ElfENqIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E936C19423;
	Tue, 31 Mar 2026 17:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976443;
	bh=I32MGCO7NoUuXjbts+gzS/D5cdCeXvgoTtrUsE51alo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElfENqIUQ3Fn6C476d1iA7WQdfjHFCdyPNMA138Chv8I9szOFFvJGv5heaU1Em28y
	 4/O45ir3Ey4VqhCE10C1Bgj7Ny1thk3ekvh07PrVyAjS78D1KPNI0p1FNtSsH4Oz0A
	 Kq24IaZ7+G1EnhDF5xapFIDNfeKSAkaGJllIG578=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 062/309] nvmet: move async event work off nvmet-wq
Date: Tue, 31 Mar 2026 18:19:25 +0200
Message-ID: <20260331161755.770984232@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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
 drivers/nvme/target/admin-cmd.c |  2 +-
 drivers/nvme/target/core.c      | 14 ++++++++++++--
 drivers/nvme/target/nvmet.h     |  1 +
 drivers/nvme/target/rdma.c      |  1 +
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 3e378153a7817..950b7f8e8ad56 100644
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
index 5d7d483bfbe37..1c5b6bab47791 100644
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
@@ -1957,9 +1959,14 @@ static int __init nvmet_init(void)
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
@@ -1975,6 +1982,8 @@ static int __init nvmet_init(void)
 	nvmet_exit_discovery();
 out_exit_debugfs:
 	nvmet_exit_debugfs();
+out_free_nvmet_aen_work_queue:
+	destroy_workqueue(nvmet_aen_wq);
 out_free_nvmet_work_queue:
 	destroy_workqueue(nvmet_wq);
 out_free_buffered_work_queue:
@@ -1992,6 +2001,7 @@ static void __exit nvmet_exit(void)
 	nvmet_exit_discovery();
 	nvmet_exit_debugfs();
 	ida_destroy(&cntlid_ida);
+	destroy_workqueue(nvmet_aen_wq);
 	destroy_workqueue(nvmet_wq);
 	destroy_workqueue(buffered_io_wq);
 	destroy_workqueue(zbd_wq);
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index f3b09f4099f08..059fd9f356c45 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -502,6 +502,7 @@ extern struct kmem_cache *nvmet_bvec_cache;
 extern struct workqueue_struct *buffered_io_wq;
 extern struct workqueue_struct *zbd_wq;
 extern struct workqueue_struct *nvmet_wq;
+extern struct workqueue_struct *nvmet_aen_wq;
 
 static inline void nvmet_set_result(struct nvmet_req *req, u32 result)
 {
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 0485e25ab797c..284ab759bbce3 100644
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



