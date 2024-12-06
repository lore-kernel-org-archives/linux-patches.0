Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D131527AC;
	Fri,  6 Dec 2024 15:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497970; cv=none; b=IDW+vZ52ZrGRC2a3QjIVfH77S9QoNAapeSSNHAQBcDBNltGKn3Fn5/TO2jUfJkwVeV+s+leUWqlRuD3TclgMTgJbD9c2/LI2aE5cAcRo6YfFTHcNPdJOY1PfNgP1Ty1cnw4/wjEMBAFII7y2hqwyJFbGWddJe1/WBMA8vwjeecI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497970; c=relaxed/simple;
	bh=C3jVoX8ILyroaYxFQuI+A5A5grRL12DW/boFkIPFW0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LuNUdH25T/qgN5Uedw8mP/1+hgUTS2jRX3TcJ2glbrd7dtN+uIxQw9nvq8SFPSCMUNd2oVWYOUMasqHN3pL5lGhazEFNIeSkFBHwYL75H1ndrXpzOU7nS/OmVorKU7GZt7i7yTMVp8KoQ2z+OGgF8OoKnlwIBe0XKjhIad6siDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NX5OrI3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NX5OrI3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E20EC4CED1;
	Fri,  6 Dec 2024 15:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497970;
	bh=C3jVoX8ILyroaYxFQuI+A5A5grRL12DW/boFkIPFW0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NX5OrI3XTmyHe8oNxkNvNkMX+YIreN9BRyI053s8z7fjGG9/Iy8W5u1xsfAobYQKk
	 jza4hPqJuKEM1q4E4HceaU8hd94O1an+U9xk1ZFeZILUfMgzkF46sDC8wc9PSbzQVj
	 aiIN1KDRc0xXJtqCrb1mUiAAM7vuhLH/mUE1Cz7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.6 446/676] scsi: lpfc: Validate hdwq pointers before dereferencing in reset/errata paths
Date: Fri,  6 Dec 2024 15:34:25 +0100
Message-ID: <20241206143710.787292717@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Justin Tee <justin.tee@broadcom.com>

commit 2be1d4f11944cd6283cb97268b3e17c4424945ca upstream.

When the HBA is undergoing a reset or is handling an errata event, NULL ptr
dereference crashes may occur in routines such as
lpfc_sli_flush_io_rings(), lpfc_dev_loss_tmo_callbk(), or
lpfc_abort_handler().

Add NULL ptr checks before dereferencing hdwq pointers that may have been
freed due to operations colliding with a reset or errata event handler.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240726231512.92867-4-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[Xiangyu: BP to fix CVE: CVE-2024-49891, no test_bit() conflict resolution]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c |    3 ++-
 drivers/scsi/lpfc/lpfc_scsi.c    |   13 +++++++++++--
 drivers/scsi/lpfc/lpfc_sli.c     |   11 +++++++++++
 3 files changed, 24 insertions(+), 3 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -175,7 +175,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport
 			 ndlp->nlp_state, ndlp->fc4_xpt_flags);
 
 	/* Don't schedule a worker thread event if the vport is going down. */
-	if (vport->load_flag & FC_UNLOADING) {
+	if ((vport->load_flag & FC_UNLOADING) ||
+	    !(phba->hba_flag & HBA_SETUP)) {
 		spin_lock_irqsave(&ndlp->lock, iflags);
 		ndlp->rport = NULL;
 
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5546,11 +5546,20 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 
 	iocb = &lpfc_cmd->cur_iocbq;
 	if (phba->sli_rev == LPFC_SLI_REV4) {
-		pring_s4 = phba->sli4_hba.hdwq[iocb->hba_wqidx].io_wq->pring;
-		if (!pring_s4) {
+		/* if the io_wq & pring are gone, the port was reset. */
+		if (!phba->sli4_hba.hdwq[iocb->hba_wqidx].io_wq ||
+		    !phba->sli4_hba.hdwq[iocb->hba_wqidx].io_wq->pring) {
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
+					 "2877 SCSI Layer I/O Abort Request "
+					 "IO CMPL Status x%x ID %d LUN %llu "
+					 "HBA_SETUP %d\n", FAILED,
+					 cmnd->device->id,
+					 (u64)cmnd->device->lun,
+					 (HBA_SETUP & phba->hba_flag));
 			ret = FAILED;
 			goto out_unlock_hba;
 		}
+		pring_s4 = phba->sli4_hba.hdwq[iocb->hba_wqidx].io_wq->pring;
 		spin_lock(&pring_s4->ring_lock);
 	}
 	/* the command is in process of being cancelled */
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4684,6 +4684,17 @@ lpfc_sli_flush_io_rings(struct lpfc_hba
 	/* Look on all the FCP Rings for the iotag */
 	if (phba->sli_rev >= LPFC_SLI_REV4) {
 		for (i = 0; i < phba->cfg_hdw_queue; i++) {
+			if (!phba->sli4_hba.hdwq ||
+			    !phba->sli4_hba.hdwq[i].io_wq) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+						"7777 hdwq's deleted %lx "
+						"%lx %x %x\n",
+						(unsigned long)phba->pport->load_flag,
+						(unsigned long)phba->hba_flag,
+						phba->link_state,
+						phba->sli.sli_flag);
+				return;
+			}
 			pring = phba->sli4_hba.hdwq[i].io_wq->pring;
 
 			spin_lock_irq(&pring->ring_lock);


