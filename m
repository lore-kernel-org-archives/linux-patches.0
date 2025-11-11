Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86132C2357;
	Tue, 11 Nov 2025 01:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824059; cv=none; b=nyUYWuem0ly3GEyLX0m192Fs//q08tfy7cqV8GItu9vUnSJLUROwHQVriP5lxsGRvKFZKIzhw+3kc0EHt0lKmrsq5wprepTXbSpLjyeWP2ys3YtF6q+IPuswuGpeFOY2ggCCbIeqXTgbuFDYWixUBwXi5J03vMhwaV0ruMmmV9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824059; c=relaxed/simple;
	bh=4h5RlWvDPeysFeJBXzGBOZEx+wzBkCcQ6X2UsqLWlxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/4FVYrD86yJhxaJo1FkNI1UEguXuWYu+KOk7bnqWh8qvfGBYzLqcJIhbLnKJkBkGnvw0cquxsax72afPw7vxK8wO1iKRMwVGwukGXuaGY1WA5T/CeVUiBtd9ehJgH4WUpkLfVQsNZgNiXR0nbFycAaehMySE3PvKikrf0CCnrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYxQNg/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYxQNg/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DBFC113D0;
	Tue, 11 Nov 2025 01:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824059;
	bh=4h5RlWvDPeysFeJBXzGBOZEx+wzBkCcQ6X2UsqLWlxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYxQNg/AxMxjbqMZkOkjsf1L0b/+2k73F6S371urqc9H9QR1PbF+wcK43KOk+uL/C
	 G6R6NljU8LAAFT/erscKrzClnsBhrRn73SNkb/aQqH4PLwyaeWbfT5YL4Blat+2SW3
	 yVuVE8E+Jx5iGRoZHm4wYsfTdZ7WVKbL24NK2q1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 379/565] scsi: lpfc: Ensure PLOGI_ACC is sent prior to PRLI in Point to Point topology
Date: Tue, 11 Nov 2025 09:43:55 +0900
Message-ID: <20251111004535.398131304@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 2bf81856a403c92a4ce375288f33fba82ca2ccc6 ]

There is a timing race condition when a PRLI may be sent on the wire
before PLOGI_ACC in Point to Point topology.  Fix by deferring REG_RPI
mbox completion handling to after PLOGI_ACC's CQE completion.  Because
the discovery state machine only sends PRLI after REG_RPI mbox
completion, PRLI is now guaranteed to be sent after PLOGI_ACC.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Message-ID: <20250915180811.137530-8-justintee8345@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c       | 10 +++++++---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 23 ++++++++++++++++++-----
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 9309c42487ca8..36ee9f51a8fa2 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5329,12 +5329,12 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		ulp_status, ulp_word4, did);
 	/* ELS response tag <ulpIoTag> completes */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "0110 ELS response tag x%x completes "
+			 "0110 ELS response tag x%x completes fc_flag x%lx"
 			 "Data: x%x x%x x%x x%x x%lx x%x x%x x%x %p %p\n",
-			 iotag, ulp_status, ulp_word4, tmo,
+			 iotag, vport->fc_flag, ulp_status, ulp_word4, tmo,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi, kref_read(&ndlp->kref), mbox, ndlp);
-	if (mbox) {
+	if (mbox && !test_bit(FC_PT2PT, &vport->fc_flag)) {
 		if (ulp_status == 0 &&
 		    test_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag)) {
 			if (!lpfc_unreg_rpi(vport, ndlp) &&
@@ -5393,6 +5393,10 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		}
 out_free_mbox:
 		lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
+	} else if (mbox && test_bit(FC_PT2PT, &vport->fc_flag) &&
+		   test_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag)) {
+		lpfc_mbx_cmpl_reg_login(phba, mbox);
+		clear_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag);
 	}
 out:
 	if (ndlp && shost) {
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 4d88cfe71caed..2897674b78d4c 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -329,8 +329,14 @@ lpfc_defer_plogi_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *login_mbox)
 		/* Now that REG_RPI completed successfully,
 		 * we can now proceed with sending the PLOGI ACC.
 		 */
-		rc = lpfc_els_rsp_acc(login_mbox->vport, ELS_CMD_PLOGI,
-				      save_iocb, ndlp, NULL);
+		if (test_bit(FC_PT2PT, &ndlp->vport->fc_flag)) {
+			rc = lpfc_els_rsp_acc(login_mbox->vport, ELS_CMD_PLOGI,
+					      save_iocb, ndlp, login_mbox);
+		} else {
+			rc = lpfc_els_rsp_acc(login_mbox->vport, ELS_CMD_PLOGI,
+					      save_iocb, ndlp, NULL);
+		}
+
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 					"4576 PLOGI ACC fails pt2pt discovery: "
@@ -338,9 +344,16 @@ lpfc_defer_plogi_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *login_mbox)
 		}
 	}
 
-	/* Now process the REG_RPI cmpl */
-	lpfc_mbx_cmpl_reg_login(phba, login_mbox);
-	clear_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag);
+	/* If this is a fabric topology, complete the reg_rpi and prli now.
+	 * For Pt2Pt, the reg_rpi and PRLI are deferred until after the LS_ACC
+	 * completes.  This ensures, in Pt2Pt, that the PLOGI LS_ACC is sent
+	 * before the PRLI.
+	 */
+	if (!test_bit(FC_PT2PT, &ndlp->vport->fc_flag)) {
+		/* Now process the REG_RPI cmpl */
+		lpfc_mbx_cmpl_reg_login(phba, login_mbox);
+		clear_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag);
+	}
 	kfree(save_iocb);
 }
 
-- 
2.51.0



