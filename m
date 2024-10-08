Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106051DE8BE;
	Tue,  8 Oct 2024 12:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391981; cv=none; b=WJiXQueyc0xYTrq5cLfySb6YXu00Dr8NsTTCPLv5M9VukU6wDp1dcMptJKVa2fulA3afbVeBtkSiezuGZN9yZFL1eBEMDdI90u3ahm2JCoCaCJa6iCNVBvDThlT96CI3fKYRGu+Dn4gfhpeVXTrWThY6DQDH3/RxeM1haCYAcoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391981; c=relaxed/simple;
	bh=0pRHOZb3S3lDGWyOr0YzBURiu7jG8MEsQLfcV5HguMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nN/CRwtWFm/UCoMrvh5GUvKjhTB86uTPcCwwIj6zwhtXP/lk67oA8J1NdWAcmKLoealEVXijq6WzUPwSv+nznNsAOzt1ArBTp2soUw+yB9e/yFXeKmyZeQZQEMSTEz/PHYm4xbvQteb2poKQWPLH7Mkk+qny0FcCcNGX2BCxf5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cC8IEAWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cC8IEAWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C5FC4CEC7;
	Tue,  8 Oct 2024 12:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391980;
	bh=0pRHOZb3S3lDGWyOr0YzBURiu7jG8MEsQLfcV5HguMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cC8IEAWfvyL8x0C1OFN4chq4T4Y4MblKYKtqOUe4nUCX0+ybghlgacwZv2B7gKbuB
	 vGj7qBGI0h0TcGIkKnE0Sx31dgL1WTeHZorH2CgnIszmP5dkvsdWEEb1bNYeTKjhrx
	 6QODMIum68cfjSBonM3ifeoUruz8z8DJMjA+sGwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 273/558] scsi: lpfc: Update PRLO handling in direct attached topology
Date: Tue,  8 Oct 2024 14:05:03 +0200
Message-ID: <20241008115713.073257278@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 1f0f7679ad8942f810b0f19ee9cf098c3502d66a ]

A kref imbalance occurs when handling an unsolicited PRLO in direct
attached topology.

Rework PRLO rcv handling when in MAPPED state.  Save the state that we were
handling a PRLO by setting nlp_last_elscmd to ELS_CMD_PRLO.  Then in the
lpfc_cmpl_els_logo_acc() completion routine, manually restart discovery.
By issuing the PLOGI, which nlp_gets, before nlp_put at the end of the
lpfc_cmpl_els_logo_acc() routine, we are saving us from a final nlp_put.
And, we are still allowing the unreg_rpi to happen.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240726231512.92867-7-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c       | 27 ++++++++++++++++-----------
 drivers/scsi/lpfc/lpfc_nportdisc.c | 22 ++++++++++++++++++++--
 2 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 8c0926ffee1bf..e27f5d955edb4 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5244,9 +5244,10 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* ACC to LOGO completes to NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0109 ACC to LOGO completes to NPort x%x refcnt %d "
-			 "Data: x%x x%x x%x\n",
-			 ndlp->nlp_DID, kref_read(&ndlp->kref), ndlp->nlp_flag,
-			 ndlp->nlp_state, ndlp->nlp_rpi);
+			 "last els x%x Data: x%x x%x x%x\n",
+			 ndlp->nlp_DID, kref_read(&ndlp->kref),
+			 ndlp->nlp_last_elscmd, ndlp->nlp_flag, ndlp->nlp_state,
+			 ndlp->nlp_rpi);
 
 	/* This clause allows the LOGO ACC to complete and free resources
 	 * for the Fabric Domain Controller.  It does deliberately skip
@@ -5258,18 +5259,22 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		goto out;
 
 	if (ndlp->nlp_state == NLP_STE_NPR_NODE) {
-		/* If PLOGI is being retried, PLOGI completion will cleanup the
-		 * node. The NLP_NPR_2B_DISC flag needs to be retained to make
-		 * progress on nodes discovered from last RSCN.
-		 */
-		if ((ndlp->nlp_flag & NLP_DELAY_TMO) &&
-		    (ndlp->nlp_last_elscmd == ELS_CMD_PLOGI))
-			goto out;
-
 		if (ndlp->nlp_flag & NLP_RPI_REGISTERED)
 			lpfc_unreg_rpi(vport, ndlp);
 
+		/* If came from PRLO, then PRLO_ACC is done.
+		 * Start rediscovery now.
+		 */
+		if (ndlp->nlp_last_elscmd == ELS_CMD_PRLO) {
+			spin_lock_irq(&ndlp->lock);
+			ndlp->nlp_flag |= NLP_NPR_2B_DISC;
+			spin_unlock_irq(&ndlp->lock);
+			ndlp->nlp_prev_state = ndlp->nlp_state;
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
+			lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
+		}
 	}
+
  out:
 	/*
 	 * The driver received a LOGO from the rport and has ACK'd it.
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index f6a53446e57f9..4574716c8764f 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -2652,8 +2652,26 @@ lpfc_rcv_prlo_mapped_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	/* flush the target */
 	lpfc_sli_abort_iocb(vport, ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 
-	/* Treat like rcv logo */
-	lpfc_rcv_logo(vport, ndlp, cmdiocb, ELS_CMD_PRLO);
+	/* Send PRLO_ACC */
+	spin_lock_irq(&ndlp->lock);
+	ndlp->nlp_flag |= NLP_LOGO_ACC;
+	spin_unlock_irq(&ndlp->lock);
+	lpfc_els_rsp_acc(vport, ELS_CMD_PRLO, cmdiocb, ndlp, NULL);
+
+	/* Save ELS_CMD_PRLO as the last elscmd and then set to NPR.
+	 * lpfc_cmpl_els_logo_acc is expected to restart discovery.
+	 */
+	ndlp->nlp_last_elscmd = ELS_CMD_PRLO;
+	ndlp->nlp_prev_state = ndlp->nlp_state;
+
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE | LOG_ELS | LOG_DISCOVERY,
+			 "3422 DID x%06x nflag x%x lastels x%x ref cnt %u\n",
+			 ndlp->nlp_DID, ndlp->nlp_flag,
+			 ndlp->nlp_last_elscmd,
+			 kref_read(&ndlp->kref));
+
+	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+
 	return ndlp->nlp_state;
 }
 
-- 
2.43.0



