Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B998838E5C5;
	Thu, 17 Sep 2026 17:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667996; cv=none; b=BbUbrqabvlHTvr4E9kj1wa/EVMUuRhYW7hbY7jL1HR+qDFF+fDzRhPelCsWFp9t6CL/Hw+Y7/x9bFbO2MJNwr7RzJ+/TkBv+gVOYfxcvdxSTTm0oimPPGevPs0hHen1Q+Gt31/0RkyROXlR7SNi8vDWlIYHi0vuj9kbqQcsca0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667996; c=relaxed/simple;
	bh=pmcI+zbXjhKQ/kW2ZwrhXXHXtrWnHp2ABq7NdD69LkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSpu7HuhUR3IDGeY2PlhAmmD6168b4HD+l5mhrhp8nR51KUwYxpW7B9eANgYixHjnnPhGzzC5CYWRuU85bRM6JP21AQhIAaQ6nAeMlFlCd6yQ3G6SSzPA5WwPGuN80y6IKynDWI6b9gGude/kGzz6bF2CzHT1//8zy6jJfy9qUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wuVKuoPc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wuVKuoPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64651F000FF;
	Thu, 17 Sep 2026 17:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667994;
	bh=+h1yjOxkUFYPERxOAl2UHXWJhgAkPmPTSewBOzQWpcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wuVKuoPcv8QFFAMrEKBszr9lQxyK4t43yLj0o+8o8QHBgX6ntlNSPv4Aw2ZaHZbKl
	 jPdWOUCi93/omgYQYcQEpRxuOtSoUBhj7uQdVo0CbWbapAb1rnaziAxi8BOEZvRoce
	 mH1gaYop4u3z79Cwuy+XVDLs0msFMTDAO4rWWzas=
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
Subject: [PATCH 6.12 0277/1102] nvme-fc: Do not cancel requests in io target before it is initialized
Date: Thu, 17 Sep 2026 16:03:40 +0100
Message-ID: <20260917151546.563910822@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fd0d99c0f97d9..8f2c785d1f62a 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2465,7 +2465,7 @@ __nvme_fc_abort_outstanding_ios(struct nvme_fc_ctrl *ctrl, bool start_queues)
 	 * io requests back to the block layer as part of normal completions
 	 * (but with error status).
 	 */
-	if (ctrl->ctrl.queue_count > 1) {
+	if (ctrl->ctrl.queue_count > 1 && ctrl->ctrl.tagset) {
 		nvme_quiesce_io_queues(&ctrl->ctrl);
 		nvme_sync_io_queues(&ctrl->ctrl);
 		blk_mq_tagset_busy_iter(&ctrl->tag_set,
@@ -2904,6 +2904,11 @@ nvme_fc_create_io_queues(struct nvme_fc_ctrl *ctrl)
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



