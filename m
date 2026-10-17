Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC16F2DF126;
	Sat, 17 Oct 2026 17:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257573; cv=none; b=aR2cfV79tNV35cOsJhxbsmqzV0d3JJqbgKlXHOMvEjeZrdaFlwDnmRdRW1b3Zkw3qEtwxd4Kd6NRKoZzLfExcXQL148HSJARL3qcML9AT/533E4qR22N5Q29R586jaMkKD+vf2DuH291bZQFk6MNiSBm0+G35pVVStGjf3ua3BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257573; c=relaxed/simple;
	bh=sDYSddajA06GNVXMZdiOn6XGpew1haq6SlaNoNxizn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzQlYoF6C6T0eMwTClH4Yiv78n5lCAc4JfKWOT0YsErE6c+DWII+op10t55XXn8k1yKm0dYwpIlgZYSFtSAmM6bImfZuLLuVmIkeJ+pCgtMJdZbP11d/SinTTEQ5amJdkPmuWb3IteT442m60veRIZWPiTdkZkesCUhvMlx92Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yu68m6Pg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yu68m6Pg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0ADE1F000C4;
	Sat, 17 Oct 2026 17:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257572;
	bh=FMRnPDhQjvpGYJyAAvoWknzBEPVEaMx982me/T07PW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yu68m6PgTx4Ng52rqGFX9nlJEsCC+xLyi2NNUi+V5fSCp24GIAv4r9u6LtOd1eFZL
	 BedYAvvtNXKNp2jlfyDsGxbOrxU0f5lcicOMEfprrlDnahSbTzMTDXNsRqH73Bt1u3
	 Ybqy4gfGE9AOx2Nte5fYjopMeabMhBnD2IyFf3S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Stanley Jhu <stanleyjhu@google.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0601/1674] scsi: ufs: core: Decouple CQ sweep from request iterator in MCQ
Date: Sat, 17 Oct 2026 17:47:53 +0200
Message-ID: <20261017160446.510245078@linuxfoundation.org>
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
index 368459dd8b3ff..5e42772095ce1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5639,7 +5639,17 @@ static void ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba,
 	struct scsi_cmnd *cmd;
 	unsigned long flags;
 	u32 hwq_num, utag;
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
@@ -5652,21 +5662,16 @@ static void ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba,
 		hwq_num = blk_mq_unique_tag_to_hwq(utag);
 		hwq = &hba->uhq[hwq_num];
 
-		if (force_compl) {
-			ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
-			/*
-			 * For those cmds of which the cqes are not present
-			 * in the cq, complete them explicitly.
-			 */
-			if (cmd && !test_bit(SCMD_STATE_COMPLETE, &cmd->state)) {
-				spin_lock_irqsave(&hwq->cq_lock, flags);
-				set_host_byte(cmd, DID_REQUEUE);
-				ufshcd_release_scsi_cmd(hba, lrbp);
-				scsi_done(cmd);
-				spin_unlock_irqrestore(&hwq->cq_lock, flags);
-			}
-		} else {
-			ufshcd_mcq_poll_cqe_lock(hba, hwq);
+		/*
+		 * For those cmds of which the cqes are not present
+		 * in the cq, complete them explicitly.
+		 */
+		if (cmd && !test_bit(SCMD_STATE_COMPLETE, &cmd->state)) {
+			spin_lock_irqsave(&hwq->cq_lock, flags);
+			set_host_byte(cmd, DID_REQUEUE);
+			ufshcd_release_scsi_cmd(hba, lrbp);
+			scsi_done(cmd);
+			spin_unlock_irqrestore(&hwq->cq_lock, flags);
 		}
 	}
 }
-- 
2.53.0



