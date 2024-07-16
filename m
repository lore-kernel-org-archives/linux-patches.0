Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC1C19E7D0;
	Tue, 16 Jul 2024 15:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145591; cv=none; b=gqxG4uduVJ0rrGj2f5LHo+5z78oJZUatdlUuJXOPbOFd74Guda8qIDrryeqAx2pYtU0DMa7nBw0Q72fSB0hj828ug3SAEgfO/NGMjlhWLildgaZnFWPI8p/VkiEN1EK77eKC1Ah5E0b94qtq8qW9GtqsioBn60e5mxuuyFUIq/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145591; c=relaxed/simple;
	bh=lfJ4Og3ne9TVrwKJceqTlaLQpVq5yTRKAoN5sK4JctI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZHq0Vm+h0NOaMUwRlbOC6NzfJQG2mNnwxdfSOwSu0V+LOsLav1zqcKhOyBPTqQBYJUO3LsK7gXeHk0++v6h0ma0MkFR00fHOoSEk3J8rBAGp7fMC5eUNiSzxZagqaFuEwj2tVEH/X2qulAFoVzQo6fwYbN2vqkq+x14q26iEo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnc66QNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnc66QNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984DEC4AF11;
	Tue, 16 Jul 2024 15:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145591;
	bh=lfJ4Og3ne9TVrwKJceqTlaLQpVq5yTRKAoN5sK4JctI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnc66QNNjJ3HH43fZCxwWG74ech/tQ/manAGiGkq0LWbeL4Jd5R2FPcJiVxfIdWd5
	 Xh82luZy8QoGwBs3EGD9dweCEI1iVVfE9fCQdzJtaozdrrsls73epxYKRofs0GVkss
	 vB7LYdjb4/nut1s8zp6MhQ1R0xMtShLdw+gcS8S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/121] scsi: ufs: core: Fix ufshcd_clear_cmd racing issue
Date: Tue, 16 Jul 2024 17:31:04 +0200
Message-ID: <20240716152751.410330965@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 9307a998cb9846a2557fdca286997430bee36a2a ]

When ufshcd_clear_cmd is racing with the completion ISR, the completed tag
of the request's mq_hctx pointer will be set to NULL by the ISR.  And
ufshcd_clear_cmd's call to ufshcd_mcq_req_to_hwq will get NULL pointer KE.
Return success when the request is completed by ISR because sq does not
need cleanup.

The racing flow is:

Thread A
ufshcd_err_handler					step 1
	ufshcd_try_to_abort_task
		ufshcd_cmd_inflight(true)		step 3
		ufshcd_clear_cmd
			...
			ufshcd_mcq_req_to_hwq
			blk_mq_unique_tag
				rq->mq_hctx->queue_num	step 5

Thread B
ufs_mtk_mcq_intr(cq complete ISR)			step 2
	scsi_done
		...
		__blk_mq_free_request
			rq->mq_hctx = NULL;		step 4

Below is KE back trace:

  ufshcd_try_to_abort_task: cmd pending in the device. tag = 6
  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000194
   pc : [0xffffffd589679bf8] blk_mq_unique_tag+0x8/0x14
   lr : [0xffffffd5862f95b4] ufshcd_mcq_sq_cleanup+0x6c/0x1cc [ufs_mediatek_mod_ise]
   Workqueue: ufs_eh_wq_0 ufshcd_err_handler [ufs_mediatek_mod_ise]
   Call trace:
    dump_backtrace+0xf8/0x148
    show_stack+0x18/0x24
    dump_stack_lvl+0x60/0x7c
    dump_stack+0x18/0x3c
    mrdump_common_die+0x24c/0x398 [mrdump]
    ipanic_die+0x20/0x34 [mrdump]
    notify_die+0x80/0xd8
    die+0x94/0x2b8
    __do_kernel_fault+0x264/0x298
    do_page_fault+0xa4/0x4b8
    do_translation_fault+0x38/0x54
    do_mem_abort+0x58/0x118
    el1_abort+0x3c/0x5c
    el1h_64_sync_handler+0x54/0x90
    el1h_64_sync+0x68/0x6c
    blk_mq_unique_tag+0x8/0x14
    ufshcd_clear_cmd+0x34/0x118 [ufs_mediatek_mod_ise]
    ufshcd_try_to_abort_task+0x2c8/0x5b4 [ufs_mediatek_mod_ise]
    ufshcd_err_handler+0xa7c/0xfa8 [ufs_mediatek_mod_ise]
    process_one_work+0x208/0x4fc
    worker_thread+0x228/0x438
    kthread+0x104/0x1d4
    ret_from_fork+0x10/0x20

Fixes: 8d7290348992 ("scsi: ufs: mcq: Add supporting functions for MCQ abort")
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20240628070030.30929-2-peter.wang@mediatek.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 4e84ee6564d4b..a10fc7a697109 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -105,16 +105,15 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_config_mac);
  * @hba: per adapter instance
  * @req: pointer to the request to be issued
  *
- * Return: the hardware queue instance on which the request would
- * be queued.
+ * Return: the hardware queue instance on which the request will be or has
+ * been queued. %NULL if the request has already been freed.
  */
 struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
 					 struct request *req)
 {
-	u32 utag = blk_mq_unique_tag(req);
-	u32 hwq = blk_mq_unique_tag_to_hwq(utag);
+	struct blk_mq_hw_ctx *hctx = READ_ONCE(req->mq_hctx);
 
-	return &hba->uhq[hwq];
+	return hctx ? &hba->uhq[hctx->queue_num] : NULL;
 }
 
 /**
@@ -511,6 +510,8 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
 		if (!cmd)
 			return -EINVAL;
 		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
+		if (!hwq)
+			return 0;
 	} else {
 		hwq = hba->dev_cmd_queue;
 	}
-- 
2.43.0



