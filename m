Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02ABB5304CC;
	Thu, 17 Sep 2026 17:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664475; cv=none; b=bmMIh23wLOOB/Rjc6NT7KmxhTuWqFQhDX/Y52zOS5jj8sInMg0rWitojhQCUKVsb1JoHqldz9PY8zAU8yvdQQtrLmctsCIpVh3CL6VSZCKqEIVwYLfRsH3wXcx2fkgOxGiw95jI6VHjMfbI6b9vZSsx63xIcZoTzWFy5f0zDIp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664475; c=relaxed/simple;
	bh=8ZW28uxA9OPDSG7tgqf15zcbSjEOA7eHxnvYtejMdYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAZtooY8QR0py6OlbXgY2Nq90eIqeNSTQG+ZQPl8oXtbqFKAgxVN8B/SIpjJKR4b9a/Ns21iJsSwYmSEPiFhaZPINmv9KkCuZxbeaBwlH4yUX/5xfFoG34XKI1nwMKnJ2onIdSloH9pfZoIXDnXTGgWt1nTCy0q6EO6GgK7IVnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBz8lLgy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBz8lLgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2037B1F000FF;
	Thu, 17 Sep 2026 17:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664473;
	bh=Yoe1atDQ6ZlXK1K26kGJI/S1F7b5vqS2UmShkkEv1MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HBz8lLgykN2tCqCnMEMoXFvmF7IMk8eOURbcsJX3fprJwkBmLRWpthPqvocsSNZ+Q
	 LND7OXRVEFF+3SCeLxEvfEZV8IT4s4cO7uwUBDe0wXS+9cKG4Y1fhlg6ROucaKKVcT
	 3kY68Ng97MSIdKQuBBEiGCeAmj09EvGq92y06nmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Jennings <randyj@purestorage.com>,
	Hannes Reinecke <hare@kernel.org>,
	Daniel Wagner <dwagner@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Mohamed Khalfella <mkhalfella@purestorage.com>,
	James Smart <jsmart833426@gmail.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0383/1250] nvme-fc: Do not cancel requests in io target before it is initialized
Date: Thu, 17 Sep 2026 16:02:58 +0100
Message-ID: <20260917151602.426856090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Mohamed Khalfella <mkhalfella@purestorage.com>

[ Upstream commit ee38469f88492df99e1d97f03aa40ecfd218934f ]

A new nvme-fc controller in CONNECTING state sees admin request timeout
schedules ctrl->ioerr_work to abort inflight requests. This ends up
calling __nvme_fc_abort_outstanding_ios() which aborts requests in both
admin and io tagsets. In case fc_ctrl->tag_set was not initialized we
see the warning below. This is because ctrl.queue_count is initialized
early in nvme_fc_alloc_ctrl().

nvme nvme0: NVME-FC{0}: starting error recovery Connectivity Loss
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
lpfc 0000:ab:00.0: queue 0 connect admin queue failed (-6).
you didn't initialize this object before use?
turning off the locking correctness validator.
Workqueue: nvme-reset-wq nvme_fc_ctrl_ioerr_work [nvme_fc]
Call Trace:
 <TASK>
 dump_stack_lvl+0x57/0x80
 register_lock_class+0x567/0x580
 __lock_acquire+0x330/0xb90
 lock_acquire.part.0+0xad/0x210
 blk_mq_tagset_busy_iter+0xf9/0xc00
 __nvme_fc_abort_outstanding_ios+0x23f/0x320 [nvme_fc]
 nvme_fc_ctrl_ioerr_work+0x172/0x210 [nvme_fc]
 process_one_work+0x82c/0x1450
 worker_thread+0x5ee/0xfd0
 kthread+0x3a0/0x750
 ret_from_fork+0x439/0x670
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Update the check in __nvme_fc_abort_outstanding_ios() confirm that io
tagset was created before iterating over busy requests. Also make sure
to cancel ctrl->ioerr_work before removing io tagset.

Reviewed-by: Randy Jennings <randyj@purestorage.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Signed-off-by: James Smart <jsmart833426@gmail.com>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 0c4df5bc78314..fc7aa3fc6c2b5 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2471,7 +2471,7 @@ __nvme_fc_abort_outstanding_ios(struct nvme_fc_ctrl *ctrl, bool start_queues)
 	 * io requests back to the block layer as part of normal completions
 	 * (but with error status).
 	 */
-	if (ctrl->ctrl.queue_count > 1) {
+	if (ctrl->ctrl.queue_count > 1 && ctrl->ctrl.tagset) {
 		nvme_quiesce_io_queues(&ctrl->ctrl);
 		nvme_sync_io_queues(&ctrl->ctrl);
 		blk_mq_tagset_busy_iter(&ctrl->tag_set,
@@ -2910,6 +2910,11 @@ nvme_fc_create_io_queues(struct nvme_fc_ctrl *ctrl)
 out_delete_hw_queues:
 	nvme_fc_delete_hw_io_queues(ctrl);
 out_cleanup_tagset:
+	/*
+	 * In CONNECTING state ctrl->ioerr_work will abort both admin
+	 * and io tagsets. Cancel it first before removing io tagset.
+	 */
+	cancel_work_sync(&ctrl->ioerr_work);
 	nvme_remove_io_tag_set(&ctrl->ctrl);
 	nvme_fc_free_io_queues(ctrl);
 
-- 
2.53.0



