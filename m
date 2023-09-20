Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA15E23752
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56972C433C8;
	Wed, 20 Sep 2023 11:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211006;
	bh=F4+tJyna7TAj1vCab6w20NxKZEQ0soTOzk/l3JvNmTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpeu87Uj7p57ivDfu38oV99TIx20f8rHSirNOjRx0M9cbFr8RMb+JRBwNrAQOIVzQ
	 2ozgT5i0V3RnH2lLMS1xXQi2cb5R9Fz9RBB7NJb6jFT15k/eo7axYAS+fJQH9SsVex
	 /0OtAmqQN5ImHjsyBh+4ccULxhRYFGWiiGZEjlXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/139] scsi: lpfc: Abort outstanding ELS cmds when mailbox timeout error is detected
Date: Wed, 20 Sep 2023 13:30:06 +0200
Message-ID: <20230920112838.375935841@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 089ea22e374aa20043e72243c47b5867d5419d38 ]

A mailbox timeout error usually indicates something has gone wrong, and a
follow up reset of the HBA is a typical recovery mechanism.  Introduce a
MBX_TMO_ERR flag to detect such cases and have lpfc_els_flush_cmd abort ELS
commands if the MBX_TMO_ERR flag condition was set.  This ensures all of
the registered SGL resources meant for ELS traffic are not leaked after an
HBA reset.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20230712180522.112722-9-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc.h      |  1 +
 drivers/scsi/lpfc/lpfc_els.c  | 25 ++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_init.c | 20 +++++++++++++++++---
 drivers/scsi/lpfc/lpfc_sli.c  |  8 +++++++-
 4 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 9ad233b40a9e2..664ac3069c4be 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -895,6 +895,7 @@ enum lpfc_irq_chann_mode {
 enum lpfc_hba_bit_flags {
 	FABRIC_COMANDS_BLOCKED,
 	HBA_PCI_ERR,
+	MBX_TMO_ERR,
 };
 
 struct lpfc_hba {
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 43ebb41ded593..6b5ce9869e6b4 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -9410,11 +9410,13 @@ void
 lpfc_els_flush_cmd(struct lpfc_vport *vport)
 {
 	LIST_HEAD(abort_list);
+	LIST_HEAD(cancel_list);
 	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *tmp_iocb, *piocb;
 	u32 ulp_command;
 	unsigned long iflags = 0;
+	bool mbx_tmo_err;
 
 	lpfc_fabric_abort_vport(vport);
 
@@ -9436,15 +9438,16 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_lock(&pring->ring_lock);
 
+	mbx_tmo_err = test_bit(MBX_TMO_ERR, &phba->bit_flags);
 	/* First we need to issue aborts to outstanding cmds on txcmpl */
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
-		if (piocb->cmd_flag & LPFC_IO_LIBDFC)
+		if (piocb->cmd_flag & LPFC_IO_LIBDFC && !mbx_tmo_err)
 			continue;
 
 		if (piocb->vport != vport)
 			continue;
 
-		if (piocb->cmd_flag & LPFC_DRIVER_ABORTED)
+		if (piocb->cmd_flag & LPFC_DRIVER_ABORTED && !mbx_tmo_err)
 			continue;
 
 		/* On the ELS ring we can have ELS_REQUESTs or
@@ -9463,8 +9466,8 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 			 */
 			if (phba->link_state == LPFC_LINK_DOWN)
 				piocb->cmd_cmpl = lpfc_cmpl_els_link_down;
-		}
-		if (ulp_command == CMD_GEN_REQUEST64_CR)
+		} else if (ulp_command == CMD_GEN_REQUEST64_CR ||
+			   mbx_tmo_err)
 			list_add_tail(&piocb->dlist, &abort_list);
 	}
 
@@ -9476,11 +9479,19 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	list_for_each_entry_safe(piocb, tmp_iocb, &abort_list, dlist) {
 		spin_lock_irqsave(&phba->hbalock, iflags);
 		list_del_init(&piocb->dlist);
-		lpfc_sli_issue_abort_iotag(phba, pring, piocb, NULL);
+		if (mbx_tmo_err)
+			list_move_tail(&piocb->list, &cancel_list);
+		else
+			lpfc_sli_issue_abort_iotag(phba, pring, piocb, NULL);
+
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	}
-	/* Make sure HBA is alive */
-	lpfc_issue_hb_tmo(phba);
+	if (!list_empty(&cancel_list))
+		lpfc_sli_cancel_iocbs(phba, &cancel_list, IOSTAT_LOCAL_REJECT,
+				      IOERR_SLI_ABORTED);
+	else
+		/* Make sure HBA is alive */
+		lpfc_issue_hb_tmo(phba);
 
 	if (!list_empty(&abort_list))
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index d54fd153cb115..f59de61803dc8 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7563,6 +7563,8 @@ lpfc_disable_pci_dev(struct lpfc_hba *phba)
 void
 lpfc_reset_hba(struct lpfc_hba *phba)
 {
+	int rc = 0;
+
 	/* If resets are disabled then set error state and return. */
 	if (!phba->cfg_enable_hba_reset) {
 		phba->link_state = LPFC_HBA_ERROR;
@@ -7573,13 +7575,25 @@ lpfc_reset_hba(struct lpfc_hba *phba)
 	if (phba->sli.sli_flag & LPFC_SLI_ACTIVE) {
 		lpfc_offline_prep(phba, LPFC_MBX_WAIT);
 	} else {
+		if (test_bit(MBX_TMO_ERR, &phba->bit_flags)) {
+			/* Perform a PCI function reset to start from clean */
+			rc = lpfc_pci_function_reset(phba);
+			lpfc_els_flush_all_cmd(phba);
+		}
 		lpfc_offline_prep(phba, LPFC_MBX_NO_WAIT);
 		lpfc_sli_flush_io_rings(phba);
 	}
 	lpfc_offline(phba);
-	lpfc_sli_brdrestart(phba);
-	lpfc_online(phba);
-	lpfc_unblock_mgmt_io(phba);
+	clear_bit(MBX_TMO_ERR, &phba->bit_flags);
+	if (unlikely(rc)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"8888 PCI function reset failed rc %x\n",
+				rc);
+	} else {
+		lpfc_sli_brdrestart(phba);
+		lpfc_online(phba);
+		lpfc_unblock_mgmt_io(phba);
+	}
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index b44bb3ae22ad9..427a6ac803e50 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3919,6 +3919,8 @@ void lpfc_poll_eratt(struct timer_list *t)
 	uint64_t sli_intr, cnt;
 
 	phba = from_timer(phba, t, eratt_poll);
+	if (!(phba->hba_flag & HBA_SETUP))
+		return;
 
 	/* Here we will also keep track of interrupts per sec of the hba */
 	sli_intr = phba->sli.slistat.sli_intr;
@@ -7712,7 +7714,9 @@ lpfc_sli4_repost_sgl_list(struct lpfc_hba *phba,
 		spin_unlock_irq(&phba->hbalock);
 	} else {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"3161 Failure to post sgl to port.\n");
+				"3161 Failure to post sgl to port,status %x "
+				"blkcnt %d totalcnt %d postcnt %d\n",
+				status, block_cnt, total_cnt, post_cnt);
 		return -EIO;
 	}
 
@@ -8495,6 +8499,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 			spin_unlock_irq(&phba->hbalock);
 		}
 	}
+	phba->hba_flag &= ~HBA_SETUP;
 
 	lpfc_sli4_dip(phba);
 
@@ -9317,6 +9322,7 @@ lpfc_mbox_timeout_handler(struct lpfc_hba *phba)
 	 * would get IOCB_ERROR from lpfc_sli_issue_iocb, allowing
 	 * it to fail all outstanding SCSI IO.
 	 */
+	set_bit(MBX_TMO_ERR, &phba->bit_flags);
 	spin_lock_irq(&phba->pport->work_port_lock);
 	phba->pport->work_port_events &= ~WORKER_MBOX_TMO;
 	spin_unlock_irq(&phba->pport->work_port_lock);
-- 
2.40.1



