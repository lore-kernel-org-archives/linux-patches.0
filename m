Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAC61885B3;
	Fri, 15 Nov 2024 06:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653600; cv=none; b=PMuha6nW7DjxpjjNqzxxGiH4kbyM7b4bGTorF2Hbtm+hCGmzT/BhlxRgNddr1qh1+25oVUG9lv/5rcgHOkElMuAe+5tjnkyNWXvxeIzjWk8Axy7Hv8/KOfzgascGjtJgcC0SiXXgrzRD8yeO7otz1hLkBwwG7AQGpHbxVEajhoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653600; c=relaxed/simple;
	bh=KqrWPGWZmgL9KpoNxPzkeP7Bbg0z3kCUrNvwXW01/NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IC/aTRALWl6Q48C8M5cOfMGsH42CuCgtsJnliLJs1R6SaJHjz24TMGDinZaZQxXbmtSpDOvn8uoBV9RDUMWYmA7ITmh5pKU+Mrh2e1+N9hjnuALFE76bYgjQ9HMiEv93TL6dpKthbL26b2+tqXhFtFe6kqNsc4/w6R2UhCT04JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9tMF4c/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9tMF4c/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3193C4CECF;
	Fri, 15 Nov 2024 06:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653600;
	bh=KqrWPGWZmgL9KpoNxPzkeP7Bbg0z3kCUrNvwXW01/NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9tMF4c/liXw0E4xft7XAgcLwRby2PdK5sDgTOxLa4U1+pJtC/BosBlNqHdEsQdUm
	 I7z8pZ+eg7lgKjVmfT78INxKvNDx6ZcfOydyJgz34w/TzgMXwkDnTG8fudB988hPUf
	 f6FOlaSr54hreZ0CZ4BJczwtu7HJxCX1KlZQe/Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 21/39] nvme: make keep-alive synchronous operation
Date: Fri, 15 Nov 2024 07:38:31 +0100
Message-ID: <20241115063723.375244706@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit d06923670b5a5f609603d4a9fee4dec02d38de9c ]

The nvme keep-alive operation, which executes at a periodic interval,
could potentially sneak in while shutting down a fabric controller.
This may lead to a race between the fabric controller admin queue
destroy code path (invoked while shutting down controller) and hw/hctx
queue dispatcher called from the nvme keep-alive async request queuing
operation. This race could lead to the kernel crash shown below:

Call Trace:
    autoremove_wake_function+0x0/0xbc (unreliable)
    __blk_mq_sched_dispatch_requests+0x114/0x24c
    blk_mq_sched_dispatch_requests+0x44/0x84
    blk_mq_run_hw_queue+0x140/0x220
    nvme_keep_alive_work+0xc8/0x19c [nvme_core]
    process_one_work+0x200/0x4e0
    worker_thread+0x340/0x504
    kthread+0x138/0x140
    start_kernel_thread+0x14/0x18

While shutting down fabric controller, if nvme keep-alive request sneaks
in then it would be flushed off. The nvme_keep_alive_end_io function is
then invoked to handle the end of the keep-alive operation which
decrements the admin->q_usage_counter and assuming this is the last/only
request in the admin queue then the admin->q_usage_counter becomes zero.
If that happens then blk-mq destroy queue operation (blk_mq_destroy_
queue()) which could be potentially running simultaneously on another
cpu (as this is the controller shutdown code path) would forward
progress and deletes the admin queue. So, now from this point onward
we are not supposed to access the admin queue resources. However the
issue here's that the nvme keep-alive thread running hw/hctx queue
dispatch operation hasn't yet finished its work and so it could still
potentially access the admin queue resource while the admin queue had
been already deleted and that causes the above crash.

This fix helps avoid the observed crash by implementing keep-alive as a
synchronous operation so that we decrement admin->q_usage_counter only
after keep-alive command finished its execution and returns the command
status back up to its caller (blk_execute_rq()). This would ensure that
fabric shutdown code path doesn't destroy the fabric admin queue until
keep-alive request finished execution and also keep-alive thread is not
running hw/hctx queue dispatch operation.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index dc25d91891327..92ffeb6605618 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1231,10 +1231,9 @@ static void nvme_queue_keep_alive_work(struct nvme_ctrl *ctrl)
 			   nvme_keep_alive_work_period(ctrl));
 }
 
-static enum rq_end_io_ret nvme_keep_alive_end_io(struct request *rq,
-						 blk_status_t status)
+static void nvme_keep_alive_finish(struct request *rq,
+		blk_status_t status, struct nvme_ctrl *ctrl)
 {
-	struct nvme_ctrl *ctrl = rq->end_io_data;
 	unsigned long flags;
 	bool startka = false;
 	unsigned long rtt = jiffies - (rq->deadline - rq->timeout);
@@ -1252,13 +1251,11 @@ static enum rq_end_io_ret nvme_keep_alive_end_io(struct request *rq,
 		delay = 0;
 	}
 
-	blk_mq_free_request(rq);
-
 	if (status) {
 		dev_err(ctrl->device,
 			"failed nvme_keep_alive_end_io error=%d\n",
 				status);
-		return RQ_END_IO_NONE;
+		return;
 	}
 
 	ctrl->ka_last_check_time = jiffies;
@@ -1270,7 +1267,6 @@ static enum rq_end_io_ret nvme_keep_alive_end_io(struct request *rq,
 	spin_unlock_irqrestore(&ctrl->lock, flags);
 	if (startka)
 		queue_delayed_work(nvme_wq, &ctrl->ka_work, delay);
-	return RQ_END_IO_NONE;
 }
 
 static void nvme_keep_alive_work(struct work_struct *work)
@@ -1279,6 +1275,7 @@ static void nvme_keep_alive_work(struct work_struct *work)
 			struct nvme_ctrl, ka_work);
 	bool comp_seen = ctrl->comp_seen;
 	struct request *rq;
+	blk_status_t status;
 
 	ctrl->ka_last_check_time = jiffies;
 
@@ -1301,9 +1298,9 @@ static void nvme_keep_alive_work(struct work_struct *work)
 	nvme_init_request(rq, &ctrl->ka_cmd);
 
 	rq->timeout = ctrl->kato * HZ;
-	rq->end_io = nvme_keep_alive_end_io;
-	rq->end_io_data = ctrl;
-	blk_execute_rq_nowait(rq, false);
+	status = blk_execute_rq(rq, false);
+	nvme_keep_alive_finish(rq, status, ctrl);
+	blk_mq_free_request(rq);
 }
 
 static void nvme_start_keep_alive(struct nvme_ctrl *ctrl)
-- 
2.43.0



