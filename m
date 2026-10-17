Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD70224D6;
	Sat, 17 Oct 2026 15:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252663; cv=none; b=bc7z3xNTfBhTKwmn+etp/+rCAalwsYAuwLqzMGhH9Mfxst95lc8aKnjOM8Kq0j4/IGJ+HwAGt0Eq7JawmwK9iOIq4kHlhQTvIXR33mj63eBHjrgC7/V/3yTSV3PFQLpDt1tCQW6Mc58t9y1DvowgMInhXfqAFQrvkg+O+8xVuRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252663; c=relaxed/simple;
	bh=nS3heG/01e9dvDf5m9ACdAziJ/fnrHkKSioo4N1Cksg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7Y8NtyHvDFyaq5g9xBLJXcjWtQBf2vOPSkchU7Y2aCh64Zha7ZSTMDyTDMr4+9GKnklPkdzVb2o++jUvLKYAmmCvQP4+cexNX7fKIgBojRt8sRSTvgkAsNMCrYnU5sEZVK5CDSTuvy8qeiIMFHcjIxYT82Q4JP5xbhUB4i9uYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8+xL3B0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8+xL3B0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBB51F000C4;
	Sat, 17 Oct 2026 15:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252662;
	bh=sGEZe5KLglu0u/1RwAm7htla5sHxteI1PeDfvmImcUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M8+xL3B0frkaX8KKp7gCVtLy4h29I5kFrB9BsuFLzUTDBa4vYUgGk1lvSaFO7a2t7
	 HGCXrDN5VKRRZ2x4aba+MNxPscWbh/lk0mR+zKhH5iX/YBolcesJ0QTjtL9Blh1xvV
	 CXfnc2B6kCT60ndxGTFJ1ynoUd4a7CgsuXflThb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Stanley Jhu <stanleyjhu@google.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 22/52] scsi: ufs: core: Decouple CQ sweep from request iterator in MCQ
Date: Sat, 17 Oct 2026 17:54:23 +0200
Message-ID: <20261017155105.571929121@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit 469fa055664bfd8717b087a80d59c03055789c17 ]

In MCQ mode, ufshcd_mcq_compl_pending_transfer() uses
blk_mq_tagset_busy_iter() to iterate over busy requests during error
recovery and host reset. However, both iterator callbacks perform
whole-queue operations redundantly for each visited request:

 - force_compl == true: ufshcd_mcq_force_compl_one() calls
   ufshcd_mcq_compl_all_cqes_lock() on every busy request, sweeping the
   entire completion ring (hwq->max_entries slots) once per active request
   under spin_lock_irqsave even though the first sweep already cleared all
   completion entries.

 - force_compl == false: ufshcd_mcq_compl_one() acquires cq_lock and polls
   CQTPy over MMIO via ufshcd_mcq_poll_cqe_lock() for every busy request
   without doing any per-request work.

Sweep or poll each hardware queue (hba->uhq[i]) once at the start of
ufshcd_mcq_compl_pending_transfer(). When force_compl is true, run
blk_mq_tagset_busy_iter() afterward to complete residual in-flight
requests with DID_REQUEUE, and remove the now-unused
ufshcd_mcq_compl_one() callback.

Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
Cc: stable@vger.kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Link: https://patch.msgid.link/20260928035816.1294326-3-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9d32e658ad60e..52df1df6333aa 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5743,7 +5743,17 @@ static void ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba,
 	struct ufshcd_lrb *lrbp;
 	struct scsi_cmnd *cmd;
 	unsigned long flags;
-	int tag;
+	int tag, i;
+
+	for (i = 0; i < hba->nr_hw_queues; i++) {
+		if (force_compl)
+			ufshcd_mcq_compl_all_cqes_lock(hba, &hba->uhq[i]);
+		else
+			ufshcd_mcq_poll_cqe_lock(hba, &hba->uhq[i]);
+	}
+
+	if (!force_compl)
+		return;
 
 	for (tag = 0; tag < hba->nutrs; tag++) {
 		lrbp = &hba->lrb[tag];
@@ -5756,22 +5766,17 @@ static void ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba,
 		if (!hwq)
 			continue;
 
-		if (force_compl) {
-			ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
-			/*
-			 * For those cmds of which the cqes are not present
-			 * in the cq, complete them explicitly.
-			 */
-			spin_lock_irqsave(&hwq->cq_lock, flags);
-			if (cmd && !test_bit(SCMD_STATE_COMPLETE, &cmd->state)) {
-				set_host_byte(cmd, DID_REQUEUE);
-				ufshcd_release_scsi_cmd(hba, lrbp);
-				scsi_done(cmd);
-			}
-			spin_unlock_irqrestore(&hwq->cq_lock, flags);
-		} else {
-			ufshcd_mcq_poll_cqe_lock(hba, hwq);
+		/*
+		 * For those cmds of which the cqes are not present
+		 * in the cq, complete them explicitly.
+		 */
+		spin_lock_irqsave(&hwq->cq_lock, flags);
+		if (cmd && !test_bit(SCMD_STATE_COMPLETE, &cmd->state)) {
+			set_host_byte(cmd, DID_REQUEUE);
+			ufshcd_release_scsi_cmd(hba, lrbp);
+			scsi_done(cmd);
 		}
+		spin_unlock_irqrestore(&hwq->cq_lock, flags);
 	}
 }
 
-- 
2.53.0



