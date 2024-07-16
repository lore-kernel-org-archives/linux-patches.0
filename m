Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1562312B72;
	Tue, 16 Jul 2024 15:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144875; cv=none; b=riHKEJCRekTj0nfwXSpiLEV/Pu5POYK3SNuzKDoQm3Pl/g+jAWK/80Haq9Yf2XcPGij4Ls9XlrB9iYLNw/WVKHBSIz03IXbcBrY3tbIcYXj5dAMh6YA7L4qEM5za/xlNFiMHodEQq0NjHvV1h9f9fPvcNSK9gnq/UFdT1qN1bbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144875; c=relaxed/simple;
	bh=o1uvc4Conqyp2PogYX9QGdN6t52uNX2ai2nxceuMYTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYWguEasNcvPMMGvoNr3yE9+oq3hQL1iihPfiwDDXTOFLBrFAIEM0eD6gO+/vGRC0RSUAy5LOFxAkTuA6x3Uq1K8TQ+Egu0cIx0ZRJT1ne/LKnn1kFlfyuDnqjbbas2sIldbwW0D53BC0SiVIOa2VXEQQcpiQLakEnivgEI2tuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3EV45Nv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3EV45Nv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D09C116B1;
	Tue, 16 Jul 2024 15:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144875;
	bh=o1uvc4Conqyp2PogYX9QGdN6t52uNX2ai2nxceuMYTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3EV45NvihiycTdc/yokOkG1i1L6KKUuxBV+2xfzAVNLhbvBUzzAN56melEQjnFr2
	 kD1Af9caWmjAksU0ogkNnlFHc28c2gwmrfPztmnu+XNjYWW33ueyT8WuiBibpgReOp
	 +DR4mSise/r1x24JaMDni6kkVH4vmRpkasWCf2hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 003/143] scsi: ufs: core: Fix ufshcd_abort_one racing issue
Date: Tue, 16 Jul 2024 17:29:59 +0200
Message-ID: <20240716152756.116214451@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 74736103fb4123c71bf11fb7a6abe7c884c5269e ]

When ufshcd_abort_one is racing with the completion ISR, the completed tag
of the request's mq_hctx pointer will be set to NULL by ISR.  Return
success when request is completed by ISR because ufshcd_abort_one does not
need to do anything.

The racing flow is:

Thread A
ufshcd_err_handler					step 1
	...
	ufshcd_abort_one
		ufshcd_try_to_abort_task
			ufshcd_cmd_inflight(true)	step 3
		ufshcd_mcq_req_to_hwq
			blk_mq_unique_tag
				rq->mq_hctx->queue_num	step 5

Thread B
ufs_mtk_mcq_intr(cq complete ISR)			step 2
	scsi_done
		...
		__blk_mq_free_request
			rq->mq_hctx = NULL;		step 4

Below is KE back trace.
  ufshcd_try_to_abort_task: cmd at tag 41 not pending in the device.
  ufshcd_try_to_abort_task: cmd at tag=41 is cleared.
  Aborting tag 41 / CDB 0x28 succeeded
  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000194
  pc : [0xffffffddd7a79bf8] blk_mq_unique_tag+0x8/0x14
  lr : [0xffffffddd6155b84] ufshcd_mcq_req_to_hwq+0x1c/0x40 [ufs_mediatek_mod_ise]
   do_mem_abort+0x58/0x118
   el1_abort+0x3c/0x5c
   el1h_64_sync_handler+0x54/0x90
   el1h_64_sync+0x68/0x6c
   blk_mq_unique_tag+0x8/0x14
   ufshcd_err_handler+0xae4/0xfa8 [ufs_mediatek_mod_ise]
   process_one_work+0x208/0x4fc
   worker_thread+0x228/0x438
   kthread+0x104/0x1d4
   ret_from_fork+0x10/0x20

Fixes: 93e6c0e19d5b ("scsi: ufs: core: Clear cmd if abort succeeds in MCQ mode")
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20240628070030.30929-3-peter.wang@mediatek.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f7d04f7c0017d..ad192b74536a2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6506,6 +6506,8 @@ static bool ufshcd_abort_one(struct request *rq, void *priv)
 	/* Release cmd in MCQ mode if abort succeeds */
 	if (is_mcq_enabled(hba) && (*ret == 0)) {
 		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(lrbp->cmd));
+		if (!hwq)
+			return 0;
 		spin_lock_irqsave(&hwq->cq_lock, flags);
 		if (ufshcd_cmd_inflight(lrbp->cmd))
 			ufshcd_release_scsi_cmd(hba, lrbp);
-- 
2.43.0



