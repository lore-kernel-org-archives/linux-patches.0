Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51011DF26B;
	Tue,  8 Oct 2024 12:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390272; cv=none; b=VyVgF7ZOBO2lkemA0e0NJrDBLoSi+Juyr3n4MN0uP6QbnL0eaI/vbsz7w4o2dj2Qq5iTrrAmBIwv3Ey5LMXBSas1eOBF6YSHJJgV4H9NJ2zXOCl9vNJp4gmiJa8Bcth5NU/Z3DdYhIu7r0el/OE5mM+aK3GC3zfcu0X78e0z2Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390272; c=relaxed/simple;
	bh=k5fXxwkcJuFuBnvL8GBSDoseZ8PPBupdKiARTLyKi4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+HwjdGl0EpZgV21NSWKsTgx8QtqyLpWeSH9EcgbnjQEIx3EBLu8Fb50tsv6uElX0tjy6Az8l8Nj2yGbWm/BJOtNfSqdWxAMIpSS22INEWics6X6fRMibHQVf0XG/LulhW1LFA0gi+yjPyBajpu73Ei8OCbxLgtot0/Jd/tYVfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMUeLmt0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMUeLmt0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36592C4CEC7;
	Tue,  8 Oct 2024 12:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390272;
	bh=k5fXxwkcJuFuBnvL8GBSDoseZ8PPBupdKiARTLyKi4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMUeLmt0VLGIvmU/JktYL7lXYudPbXQJfRt2NGAQIAItzwFb0+dy6Sf51pSobShV+
	 VJ6ioOtGnK4tN1wHUL/q6MWP3yDRk7b4AxYLRzhi5IYsLt0StYNO/l1gdKUMmZonF/
	 9/Mo294Fi08qKKXmbiKAxSRVQfuphYH5t0p6tikM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 224/482] scsi: lpfc: Fix unsolicited FLOGI kref imbalance when in direct attached topology
Date: Tue,  8 Oct 2024 14:04:47 +0200
Message-ID: <20241008115657.123641651@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit b5c18c9dd138733c16893613345af44deadcf05e ]

In direct attached topology, certain target vendors that are quick to issue
FLOGI followed by a cable pull for more than dev_loss_tmo may result in a
kref imbalance for the remote port ndlp object.

Add an nlp_get when the defer_flogi_acc flag is set.  This is expected to
balance the nlp_put in the defer_flogi_acc clause in the
lpfc_issue_els_flogi() routine.  Because we need to retain the ndlp ptr,
reorganize all of the defer_flogi_acc information into one
lpfc_defer_flogi_acc struct.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240726231512.92867-6-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc.h         | 12 ++++++---
 drivers/scsi/lpfc/lpfc_els.c     | 46 +++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_hbadisc.c | 11 ++++++--
 3 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 7c147d6ea8a8f..e5a9c5a323f8b 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -306,6 +306,14 @@ struct lpfc_stats {
 
 struct lpfc_hba;
 
+/* Data structure to keep withheld FLOGI_ACC information */
+struct lpfc_defer_flogi_acc {
+	bool flag;
+	u16 rx_id;
+	u16 ox_id;
+	struct lpfc_nodelist *ndlp;
+
+};
 
 #define LPFC_VMID_TIMER   300	/* timer interval in seconds */
 
@@ -1430,9 +1438,7 @@ struct lpfc_hba {
 	uint16_t vlan_id;
 	struct list_head fcf_conn_rec_list;
 
-	bool defer_flogi_acc_flag;
-	uint16_t defer_flogi_acc_rx_id;
-	uint16_t defer_flogi_acc_ox_id;
+	struct lpfc_defer_flogi_acc defer_flogi_acc;
 
 	spinlock_t ct_ev_lock; /* synchronize access to ct_ev_waiters */
 	struct list_head ct_ev_waiters;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 445cb6c2e80f5..9084976aa77e1 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1390,7 +1390,7 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	phba->link_flag &= ~LS_EXTERNAL_LOOPBACK;
 
 	/* Check for a deferred FLOGI ACC condition */
-	if (phba->defer_flogi_acc_flag) {
+	if (phba->defer_flogi_acc.flag) {
 		/* lookup ndlp for received FLOGI */
 		ndlp = lpfc_findnode_did(vport, 0);
 		if (!ndlp)
@@ -1404,34 +1404,38 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		if (phba->sli_rev == LPFC_SLI_REV4) {
 			bf_set(wqe_ctxt_tag,
 			       &defer_flogi_acc.wqe.xmit_els_rsp.wqe_com,
-			       phba->defer_flogi_acc_rx_id);
+			       phba->defer_flogi_acc.rx_id);
 			bf_set(wqe_rcvoxid,
 			       &defer_flogi_acc.wqe.xmit_els_rsp.wqe_com,
-			       phba->defer_flogi_acc_ox_id);
+			       phba->defer_flogi_acc.ox_id);
 		} else {
 			icmd = &defer_flogi_acc.iocb;
-			icmd->ulpContext = phba->defer_flogi_acc_rx_id;
+			icmd->ulpContext = phba->defer_flogi_acc.rx_id;
 			icmd->unsli3.rcvsli3.ox_id =
-				phba->defer_flogi_acc_ox_id;
+				phba->defer_flogi_acc.ox_id;
 		}
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 				 "3354 Xmit deferred FLOGI ACC: rx_id: x%x,"
 				 " ox_id: x%x, hba_flag x%lx\n",
-				 phba->defer_flogi_acc_rx_id,
-				 phba->defer_flogi_acc_ox_id, phba->hba_flag);
+				 phba->defer_flogi_acc.rx_id,
+				 phba->defer_flogi_acc.ox_id, phba->hba_flag);
 
 		/* Send deferred FLOGI ACC */
 		lpfc_els_rsp_acc(vport, ELS_CMD_FLOGI, &defer_flogi_acc,
 				 ndlp, NULL);
 
-		phba->defer_flogi_acc_flag = false;
-		vport->fc_myDID = did;
+		phba->defer_flogi_acc.flag = false;
 
-		/* Decrement ndlp reference count to indicate the node can be
-		 * released when other references are removed.
+		/* Decrement the held ndlp that was incremented when the
+		 * deferred flogi acc flag was set.
 		 */
-		lpfc_nlp_put(ndlp);
+		if (phba->defer_flogi_acc.ndlp) {
+			lpfc_nlp_put(phba->defer_flogi_acc.ndlp);
+			phba->defer_flogi_acc.ndlp = NULL;
+		}
+
+		vport->fc_myDID = did;
 	}
 
 	return 0;
@@ -8454,9 +8458,9 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 
 	/* Defer ACC response until AFTER we issue a FLOGI */
 	if (!test_bit(HBA_FLOGI_ISSUED, &phba->hba_flag)) {
-		phba->defer_flogi_acc_rx_id = bf_get(wqe_ctxt_tag,
+		phba->defer_flogi_acc.rx_id = bf_get(wqe_ctxt_tag,
 						     &wqe->xmit_els_rsp.wqe_com);
-		phba->defer_flogi_acc_ox_id = bf_get(wqe_rcvoxid,
+		phba->defer_flogi_acc.ox_id = bf_get(wqe_rcvoxid,
 						     &wqe->xmit_els_rsp.wqe_com);
 
 		vport->fc_myDID = did;
@@ -8464,11 +8468,17 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 				 "3344 Deferring FLOGI ACC: rx_id: x%x,"
 				 " ox_id: x%x, hba_flag x%lx\n",
-				 phba->defer_flogi_acc_rx_id,
-				 phba->defer_flogi_acc_ox_id, phba->hba_flag);
+				 phba->defer_flogi_acc.rx_id,
+				 phba->defer_flogi_acc.ox_id, phba->hba_flag);
 
-		phba->defer_flogi_acc_flag = true;
+		phba->defer_flogi_acc.flag = true;
 
+		/* This nlp_get is paired with nlp_puts that reset the
+		 * defer_flogi_acc.flag back to false.  We need to retain
+		 * a kref on the ndlp until the deferred FLOGI ACC is
+		 * processed or cancelled.
+		 */
+		phba->defer_flogi_acc.ndlp = lpfc_nlp_get(ndlp);
 		return 0;
 	}
 
@@ -10504,7 +10514,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 		lpfc_els_rcv_flogi(vport, elsiocb, ndlp);
 		/* retain node if our response is deferred */
-		if (phba->defer_flogi_acc_flag)
+		if (phba->defer_flogi_acc.flag)
 			break;
 		if (newnode)
 			lpfc_disc_state_machine(vport, ndlp, NULL,
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index e74a676b6e153..e553fab869de9 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1247,7 +1247,14 @@ lpfc_linkdown(struct lpfc_hba *phba)
 	lpfc_scsi_dev_block(phba);
 	offline = pci_channel_offline(phba->pcidev);
 
-	phba->defer_flogi_acc_flag = false;
+	/* Decrement the held ndlp if there is a deferred flogi acc */
+	if (phba->defer_flogi_acc.flag) {
+		if (phba->defer_flogi_acc.ndlp) {
+			lpfc_nlp_put(phba->defer_flogi_acc.ndlp);
+			phba->defer_flogi_acc.ndlp = NULL;
+		}
+	}
+	phba->defer_flogi_acc.flag = false;
 
 	/* Clear external loopback plug detected flag */
 	phba->link_flag &= ~LS_EXTERNAL_LOOPBACK;
@@ -1369,7 +1376,7 @@ lpfc_linkup_port(struct lpfc_vport *vport)
 		(vport != phba->pport))
 		return;
 
-	if (phba->defer_flogi_acc_flag) {
+	if (phba->defer_flogi_acc.flag) {
 		clear_bit(FC_ABORT_DISCOVERY, &vport->fc_flag);
 		clear_bit(FC_RSCN_MODE, &vport->fc_flag);
 		clear_bit(FC_NLP_MORE, &vport->fc_flag);
-- 
2.43.0



