Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8C023DEAD;
	Thu, 12 Dec 2024 16:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019955; cv=none; b=WQxO4KO7M3xhqjIiwoJ6COHV2kYk3nMZKQxLv5z05wdYM1EoaNIBMe9efYU7K6jQhjVxHWapI4+mhOHNYGAMhIc8+KTUBsQOg2lHnResHboFGscI0lahzGUGOBSVqOsCxrdwwvH8YBBN3P2cJXF3FG3qVfuIT6R1dPVcFE11K+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019955; c=relaxed/simple;
	bh=YcFN0MkYsEJ2AFOU5yVGluXvP6WJet90/ezVlCAgWKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQJYwQUQL8anhCYhgFM8qTnPqbI3llmcZw05KW+TtQI1XBStEt+TIAbbV+T+LpwLNcQ1RumHEKC0UxiHYF7veZgjfd7732NJuFSREQkwsnj0n9cGymuP21RgrusZ0627BHS5YBmC+fQjgkoZIj+YabGTnSXQAwGGV4hQVsv/6CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tod4y3oL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tod4y3oL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F91C4CECE;
	Thu, 12 Dec 2024 16:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019954;
	bh=YcFN0MkYsEJ2AFOU5yVGluXvP6WJet90/ezVlCAgWKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tod4y3oLfw/aym6WEYf9/VXDC6nYlqdxc+TteFZA7hOyHFxlTkDsp1/zsIM4VtKN/
	 zWX5Eio3w1+683u3EY3ECeeh2i5hG7ccjYyb6tavE9JOJhiOtzGsfujJeKvsWAtpB1
	 XrUp3V/X30I/qYmj4dL7Gqu3KpqTBNpQR80V6SEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 340/772] scsi: lpfc: Validate hdwq pointers before dereferencing in reset/errata paths
Date: Thu, 12 Dec 2024 15:54:45 +0100
Message-ID: <20241212144403.963829216@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
@@ -177,7 +177,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport
 	/* Don't schedule a worker thread event if the vport is going down.
 	 * The teardown process cleans up the node via lpfc_drop_node.
 	 */
-	if (vport->load_flag & FC_UNLOADING) {
+	if ((vport->load_flag & FC_UNLOADING) ||
+	    !(phba->hba_flag & HBA_SETUP)) {
 		((struct lpfc_rport_data *)rport->dd_data)->pnode = NULL;
 		ndlp->rport = NULL;
 
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5554,11 +5554,20 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 
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
@@ -4668,6 +4668,17 @@ lpfc_sli_flush_io_rings(struct lpfc_hba
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


