Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16CB23ABBE;
	Wed, 30 Sep 2026 18:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794419; cv=none; b=XtdyKP9tD1MSW7zEw605nhyTsO6UswS5pSd3iYcfcWa2n15qRuaenngJR2rNI2pjsTzTglnOhi7YnVkvbAUh13TipGZGqMO/nrxFtBcz8wMW66iQuOEmFxb3WFjyoE+Ia/0AkwzgbkkJfNt6vAVa/+nzDgWlr7W8SIrbQZOZn9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794419; c=relaxed/simple;
	bh=5ltpK8JQCPRrkfK3Y/5sAQPFWE9xSVgO9bcVAUrW85c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLNUyIH805ksvdpUuQGggkug/CMtmY23aJ65T/UzcmoJ0JnW0vE4DcUgJQIC+jG8cWptfgWjuWoTnGI17jmHUeqGoZHYm+QMfCXChYiQClXbZ5DcxCsu0EgCaFR81LFKoiHMV8lasGLR/kJT/OQJRzjYeOnSCPDmQERb3kSvqUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTKLGgMY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTKLGgMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD981F00898;
	Wed, 30 Sep 2026 18:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794418;
	bh=Xdzqej8XGQ+ayyRogJIedegzAlHRyyf4PtMj4B1Nmrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LTKLGgMYA5BhQtX9SpM/OW1E0JWfZBTSc2tb3+z8wUEwARKuaTJt0ioyUWp+895d7
	 yp7hQ7JuCDfsg0ZvjqVyRTIev0UrVTduuB7OE1IugwNTaTs+wO06tOMCcluNG2nrrD
	 xMLFm3jYT5hFiDysaJB1SH8RJB7G7E+JcU+dtQ7Y=
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
Subject: [PATCH 6.6 0205/1193] nvme-fc: Do not cancel requests in io target before it is initialized
Date: Wed, 30 Sep 2026 17:14:49 +0200
Message-ID: <20260930152438.761999764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 3d3cf79d92496..75a7a372ffd83 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2459,7 +2459,7 @@ __nvme_fc_abort_outstanding_ios(struct nvme_fc_ctrl *ctrl, bool start_queues)
 	 * io requests back to the block layer as part of normal completions
 	 * (but with error status).
 	 */
-	if (ctrl->ctrl.queue_count > 1) {
+	if (ctrl->ctrl.queue_count > 1 && ctrl->ctrl.tagset) {
 		nvme_quiesce_io_queues(&ctrl->ctrl);
 		nvme_sync_io_queues(&ctrl->ctrl);
 		blk_mq_tagset_busy_iter(&ctrl->tag_set,
@@ -2896,6 +2896,11 @@ nvme_fc_create_io_queues(struct nvme_fc_ctrl *ctrl)
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



