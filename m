Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693D52054F8;
	Thu, 12 Dec 2024 15:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017055; cv=none; b=tO3Lr4ZaDv8Sc7v46XSlmVzyR5wscDj0Dml2jr6NubY1XenWnviHkVTtZLEFTTBKkxA0Tygog3WcS8Ok73CwshLuVCtS5NaSs5PT1lOkcSB/mnC2KRo5MywZNFJW/bVIcqqcCgQuuU/n8YQtu2+R4/BS1oZzyYzgt0RPH26knNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017055; c=relaxed/simple;
	bh=5BKIWpM0xaJQnBbl76TTKNqQwRwuvK138vTt7iTsTHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQWc6SXryO2oQ8B5dZkP3ihyWV3xoE4wZ8J9ezhL98im6+5d5FSWJauSi5LYktKJLMfJ+MYLDzKb0/Jm4rO8Or4fcpQis9HqQ4Dz3EXagcTIioxVdHiI6RWGMZiHLTixGlgds7bQJA3dW8dZ2oh0y/i7aeSQNpf7v0Hp7MrASnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l7MpvXR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l7MpvXR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF831C4CECE;
	Thu, 12 Dec 2024 15:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017055;
	bh=5BKIWpM0xaJQnBbl76TTKNqQwRwuvK138vTt7iTsTHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l7MpvXR+mJ0DQ9cfxHNyUIepsvU9OQhCNok3qaC9ol9lbH7qdhG/cd0kMRKQWk0kD
	 t8vjsMlKeUgb4S9V1FTRK0CcuJp1e8yNRhORyFSVzHmkCYIs0k5KBA37wfIVpCL7U0
	 c4I9du/u95tLLxitDbSblGRfTcIccQiyLWIdImkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 370/466] scsi: lpfc: Prevent NDLP reference count underflow in dev_loss_tmo callback
Date: Thu, 12 Dec 2024 15:58:59 +0100
Message-ID: <20241212144321.392625531@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 4281f44ea8bfedd25938a0031bebba1473ece9ad ]

Current dev_loss_tmo handling checks whether there has been a previous
call to unregister with SCSI transport.  If so, the NDLP kref count is
decremented a second time in dev_loss_tmo as the final kref release.
However, this can sometimes result in a reference count underflow if
there is also a race to unregister with NVMe transport as well.  Add a
check for NVMe transport registration before decrementing the final
kref.  If NVMe transport is still registered, then the NVMe transport
unregistration is designated as the final kref decrement.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20241031223219.152342-8-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 36 +++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 9241075f72fa4..6e8d8a96c54fb 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -155,6 +155,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	struct lpfc_hba   *phba;
 	struct lpfc_work_evt *evtp;
 	unsigned long iflags;
+	bool nvme_reg = false;
 
 	ndlp = ((struct lpfc_rport_data *)rport->dd_data)->pnode;
 	if (!ndlp)
@@ -177,38 +178,49 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	/* Don't schedule a worker thread event if the vport is going down. */
 	if (test_bit(FC_UNLOADING, &vport->load_flag) ||
 	    !test_bit(HBA_SETUP, &phba->hba_flag)) {
+
 		spin_lock_irqsave(&ndlp->lock, iflags);
 		ndlp->rport = NULL;
 
+		if (ndlp->fc4_xpt_flags & NVME_XPT_REGD)
+			nvme_reg = true;
+
 		/* The scsi_transport is done with the rport so lpfc cannot
-		 * call to unregister. Remove the scsi transport reference
-		 * and clean up the SCSI transport node details.
+		 * call to unregister.
 		 */
-		if (ndlp->fc4_xpt_flags & (NLP_XPT_REGD | SCSI_XPT_REGD)) {
+		if (ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
 			ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
 
-			/* NVME transport-registered rports need the
-			 * NLP_XPT_REGD flag to complete an unregister.
+			/* If NLP_XPT_REGD was cleared in lpfc_nlp_unreg_node,
+			 * unregister calls were made to the scsi and nvme
+			 * transports and refcnt was already decremented. Clear
+			 * the NLP_XPT_REGD flag only if the NVME Rport is
+			 * confirmed unregistered.
 			 */
-			if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
+			if (!nvme_reg && ndlp->fc4_xpt_flags & NLP_XPT_REGD) {
 				ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
+				spin_unlock_irqrestore(&ndlp->lock, iflags);
+				lpfc_nlp_put(ndlp); /* may free ndlp */
+			} else {
+				spin_unlock_irqrestore(&ndlp->lock, iflags);
+			}
+		} else {
 			spin_unlock_irqrestore(&ndlp->lock, iflags);
-			lpfc_nlp_put(ndlp);
-			spin_lock_irqsave(&ndlp->lock, iflags);
 		}
 
+		spin_lock_irqsave(&ndlp->lock, iflags);
+
 		/* Only 1 thread can drop the initial node reference.  If
 		 * another thread has set NLP_DROPPED, this thread is done.
 		 */
-		if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD) &&
-		    !(ndlp->nlp_flag & NLP_DROPPED)) {
-			ndlp->nlp_flag |= NLP_DROPPED;
+		if (nvme_reg || (ndlp->nlp_flag & NLP_DROPPED)) {
 			spin_unlock_irqrestore(&ndlp->lock, iflags);
-			lpfc_nlp_put(ndlp);
 			return;
 		}
 
+		ndlp->nlp_flag |= NLP_DROPPED;
 		spin_unlock_irqrestore(&ndlp->lock, iflags);
+		lpfc_nlp_put(ndlp);
 		return;
 	}
 
-- 
2.43.0



