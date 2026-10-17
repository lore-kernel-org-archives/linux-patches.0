Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2296B39EF01;
	Sat, 17 Oct 2026 17:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258420; cv=none; b=rb7wLt8fyJO/Hk32xwkWKuAp59mYABGX+76mZp/EisV6pwkA+2Lbqy+iP8VyK+hpIgxtSAgeD/TcWV0i0NZvhkLlFgvc54LEoYQ6KJIidYkaebBu7DIBoBLNGwX77NE9zotUG83OGV2QU6PL9WCMxq5wHWXPseP+mfrl7isLbkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258420; c=relaxed/simple;
	bh=c6avqllWR6+hZa1JO1sMYnqsBcMcSu1clr/0zYjyMt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqqOaCPmbhXkhi4Z4Yfz1rDqUphhuPViMfd+UqrzlQ0lrOqQNekH6j+NLp75koktmfkzzWWi8kjWRdtSn5LTx6FGQqmyhkY76T8muTq7bob7CXL9hXxgFvulIx8HCByzNEwGHWtKkbJP443dQxsbWLRorx1Rqrc88hgdcXdh6vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/ngHyUY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/ngHyUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306D51F000C4;
	Sat, 17 Oct 2026 17:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258418;
	bh=1TpqXT5hVuNDKk02zEX0bPfm9G08BECQ3NB3/XAmCkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w/ngHyUYbjsH+nAbTz37HZy269jd7WvdiVLZoItk9kqJlLHy1Y4pdRYXGyJEPB0XR
	 cSKd374XcssnaI+cNysDZA4Dmwyex02LKdehpVFaQ9G899AmikvqSUSKNfEirOOul5
	 9/Ej1ScmTuplE7pnQKOFLAicXY0X73PNLRnZkZro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0877/1674] nvmet: move async event work off nvmet-wq
Date: Sat, 17 Oct 2026 17:52:29 +0200
Message-ID: <20261017160453.625845598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e79b5fb91d59f..e9f81b3a07875 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -975,7 +975,7 @@ void nvmet_execute_async_event(struct nvmet_req *req)
 	ctrl->async_event_cmds[ctrl->nr_async_event_cmds++] = req;
 	mutex_unlock(&ctrl->lock);
 
-	queue_work(nvmet_wq, &ctrl->async_event_work);
+	queue_work(nvmet_aen_wq, &ctrl->async_event_work);
 }
 
 void nvmet_execute_keep_alive(struct nvmet_req *req)
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 1b7d0d185eb79..27ea842f6f1e3 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -25,6 +25,8 @@ static DEFINE_IDA(cntlid_ida);
 
 struct workqueue_struct *nvmet_wq;
 EXPORT_SYMBOL_GPL(nvmet_wq);
+struct workqueue_struct *nvmet_aen_wq;
+EXPORT_SYMBOL_GPL(nvmet_aen_wq);
 
 /*
  * This read/write semaphore is used to synchronize access to configuration
@@ -211,7 +213,7 @@ void nvmet_add_async_event(struct nvmet_ctrl *ctrl, u8 event_type,
 	list_add_tail(&aen->entry, &ctrl->async_events);
 	mutex_unlock(&ctrl->lock);
 
-	queue_work(nvmet_wq, &ctrl->async_event_work);
+	queue_work(nvmet_aen_wq, &ctrl->async_event_work);
 }
 
 static void nvmet_add_to_changed_ns_log(struct nvmet_ctrl *ctrl, __le32 nsid)
@@ -1682,9 +1684,14 @@ static int __init nvmet_init(void)
 	if (!nvmet_wq)
 		goto out_free_buffered_work_queue;
 
+	nvmet_aen_wq = alloc_workqueue("nvmet-aen-wq",
+			WQ_MEM_RECLAIM | WQ_UNBOUND, 0);
+	if (!nvmet_aen_wq)
+		goto out_free_nvmet_work_queue;
+
 	error = nvmet_init_discovery();
 	if (error)
-		goto out_free_nvmet_work_queue;
+		goto out_free_nvmet_aen_work_queue;
 
 	error = nvmet_init_configfs();
 	if (error)
@@ -1693,6 +1700,8 @@ static int __init nvmet_init(void)
 
 out_exit_discovery:
 	nvmet_exit_discovery();
+out_free_nvmet_aen_work_queue:
+	destroy_workqueue(nvmet_aen_wq);
 out_free_nvmet_work_queue:
 	destroy_workqueue(nvmet_wq);
 out_free_buffered_work_queue:
@@ -1709,6 +1718,7 @@ static void __exit nvmet_exit(void)
 	nvmet_exit_configfs();
 	nvmet_exit_discovery();
 	ida_destroy(&cntlid_ida);
+	destroy_workqueue(nvmet_aen_wq);
 	destroy_workqueue(nvmet_wq);
 	destroy_workqueue(buffered_io_wq);
 	destroy_workqueue(zbd_wq);
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index c037d1daf94d1..0a197b79f1326 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -400,6 +400,7 @@ extern struct kmem_cache *nvmet_bvec_cache;
 extern struct workqueue_struct *buffered_io_wq;
 extern struct workqueue_struct *zbd_wq;
 extern struct workqueue_struct *nvmet_wq;
+extern struct workqueue_struct *nvmet_aen_wq;
 
 static inline void nvmet_set_result(struct nvmet_req *req, u32 result)
 {
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 0dfe264968ff1..380c0aea840df 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -2098,6 +2098,7 @@ static void nvmet_rdma_remove_one(struct ib_device *ib_device, void *client_data
 	mutex_unlock(&nvmet_rdma_queue_mutex);
 
 	flush_workqueue(nvmet_wq);
+	flush_workqueue(nvmet_aen_wq);
 }
 
 static struct ib_client nvmet_rdma_ib_client = {
-- 
2.53.0



