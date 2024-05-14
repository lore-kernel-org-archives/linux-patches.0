Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C5B13AD15;
	Tue, 14 May 2024 11:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684872; cv=none; b=HOocV4OTP4TnrfyDIt7rpbJ7JHAXCZiLiVpWxCnzjM9QGGbVyUscMTqpldrUpOtd5WCZGSbYzbiogizXGAMxVEt5kw8aIEaCOTtR8O41NZokqKVrBVOj2rkGGtkHYk3LWhUggIfEIqJcfW0HGnBZyMoPcQKrYQEPRyAvnnfLlxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684872; c=relaxed/simple;
	bh=o+4JxpnEAMEngq+Ddi2vj0FYVmmK2BUb4H+8IoQ0USk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2j87sAd+ukHr+8boJpCGHw3W9rnUQfgq66XUKSpaiudT2Bam/p2iht4S6OVdyiCqwAOlYWZRBe5XA4CjLHrS65Owmi7F3dt29mse9Dx5fdstx+4xGHCPtBuP46opmLWZ1m43OrT+xTQcMFi4ViP6qTPM0eqIDtjcf0UhfOxKos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sr07Yhgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sr07Yhgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7127DC2BD10;
	Tue, 14 May 2024 11:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684872;
	bh=o+4JxpnEAMEngq+Ddi2vj0FYVmmK2BUb4H+8IoQ0USk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sr07YhgiDimJTRUEYgwSIwGCHp5Qv5XpIKTf+PlL/crotHtXSM6ZRe+cDIwud+Hpa
	 yChrijbhwr3YRMarhPgdx0a8a/hlRSj9kEUAN8sjsk1NffXuUgShT2QZPojGhqixqB
	 EJbvzA+C8yDs+LqyAUs32EBNDZ7fTqLD6iCt5fT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/301] scsi: lpfc: Use a dedicated lock for ras_fwlog state
Date: Tue, 14 May 2024 12:16:13 +0200
Message-ID: <20240514101036.102301500@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

[ Upstream commit f733a76ea0a9a84aee4ac41b81fad4d610ecbd8e ]

To reduce usage of and contention for hbalock, a separate dedicated lock is
used to protect ras_fwlog state.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240305200503.57317-8-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc.h         |  1 +
 drivers/scsi/lpfc/lpfc_attr.c    |  4 ++--
 drivers/scsi/lpfc/lpfc_bsg.c     | 20 ++++++++++----------
 drivers/scsi/lpfc/lpfc_debugfs.c | 12 ++++++------
 drivers/scsi/lpfc/lpfc_init.c    |  3 +++
 drivers/scsi/lpfc/lpfc_sli.c     | 20 ++++++++++----------
 6 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index be016732ab2ea..9670cb2bf198e 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1429,6 +1429,7 @@ struct lpfc_hba {
 	struct timer_list inactive_vmid_poll;
 
 	/* RAS Support */
+	spinlock_t ras_fwlog_lock; /* do not take while holding another lock */
 	struct lpfc_ras_fwlog ras_fwlog;
 
 	uint32_t iocb_cnt;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index b1c9107d34083..79b45ea5fdb5e 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5864,9 +5864,9 @@ lpfc_ras_fwlog_buffsize_set(struct lpfc_hba  *phba, uint val)
 	if (phba->cfg_ras_fwlog_func != PCI_FUNC(phba->pcidev->devfn))
 		return -EINVAL;
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	state = phba->ras_fwlog.state;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 
 	if (state == REG_INPROGRESS) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI, "6147 RAS Logging "
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 2919579fa0846..c305d16cfae9a 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -5070,12 +5070,12 @@ lpfc_bsg_get_ras_config(struct bsg_job *job)
 		bsg_reply->reply_data.vendor_reply.vendor_rsp;
 
 	/* Current logging state */
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	if (ras_fwlog->state == ACTIVE)
 		ras_reply->state = LPFC_RASLOG_STATE_RUNNING;
 	else
 		ras_reply->state = LPFC_RASLOG_STATE_STOPPED;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 
 	ras_reply->log_level = phba->ras_fwlog.fw_loglevel;
 	ras_reply->log_buff_sz = phba->cfg_ras_fwlog_buffsize;
@@ -5132,13 +5132,13 @@ lpfc_bsg_set_ras_config(struct bsg_job *job)
 
 	if (action == LPFC_RASACTION_STOP_LOGGING) {
 		/* Check if already disabled */
-		spin_lock_irq(&phba->hbalock);
+		spin_lock_irq(&phba->ras_fwlog_lock);
 		if (ras_fwlog->state != ACTIVE) {
-			spin_unlock_irq(&phba->hbalock);
+			spin_unlock_irq(&phba->ras_fwlog_lock);
 			rc = -ESRCH;
 			goto ras_job_error;
 		}
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irq(&phba->ras_fwlog_lock);
 
 		/* Disable logging */
 		lpfc_ras_stop_fwlog(phba);
@@ -5149,10 +5149,10 @@ lpfc_bsg_set_ras_config(struct bsg_job *job)
 		 * FW-logging with new log-level. Return status
 		 * "Logging already Running" to caller.
 		 **/
-		spin_lock_irq(&phba->hbalock);
+		spin_lock_irq(&phba->ras_fwlog_lock);
 		if (ras_fwlog->state != INACTIVE)
 			action_status = -EINPROGRESS;
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irq(&phba->ras_fwlog_lock);
 
 		/* Enable logging */
 		rc = lpfc_sli4_ras_fwlog_init(phba, log_level,
@@ -5268,13 +5268,13 @@ lpfc_bsg_get_ras_fwlog(struct bsg_job *job)
 		goto ras_job_error;
 
 	/* Logging to be stopped before reading */
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	if (ras_fwlog->state == ACTIVE) {
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irq(&phba->ras_fwlog_lock);
 		rc = -EINPROGRESS;
 		goto ras_job_error;
 	}
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 
 	if (job->request_len <
 	    sizeof(struct fc_bsg_request) +
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index ea9b42225e629..20662b4f339eb 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2196,12 +2196,12 @@ static int lpfc_debugfs_ras_log_data(struct lpfc_hba *phba,
 
 	memset(buffer, 0, size);
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	if (phba->ras_fwlog.state != ACTIVE) {
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irq(&phba->ras_fwlog_lock);
 		return -EINVAL;
 	}
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 
 	list_for_each_entry_safe(dmabuf, next,
 				 &phba->ras_fwlog.fwlog_buff_list, list) {
@@ -2252,13 +2252,13 @@ lpfc_debugfs_ras_log_open(struct inode *inode, struct file *file)
 	int size;
 	int rc = -ENOMEM;
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	if (phba->ras_fwlog.state != ACTIVE) {
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irq(&phba->ras_fwlog_lock);
 		rc = -EINVAL;
 		goto out;
 	}
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 
 	if (check_mul_overflow(LPFC_RAS_MIN_BUFF_POST_SIZE,
 			       phba->cfg_ras_fwlog_buffsize, &size))
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 76c883cc66ed6..416816d74ea1c 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7698,6 +7698,9 @@ lpfc_setup_driver_resource_phase1(struct lpfc_hba *phba)
 				"NVME" : " "),
 			(phba->nvmet_support ? "NVMET" : " "));
 
+	/* ras_fwlog state */
+	spin_lock_init(&phba->ras_fwlog_lock);
+
 	/* Initialize the IO buffer list used by driver for SLI3 SCSI */
 	spin_lock_init(&phba->scsi_buf_list_get_lock);
 	INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_get);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 9dab33686a931..5af669b930193 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6844,9 +6844,9 @@ lpfc_ras_stop_fwlog(struct lpfc_hba *phba)
 {
 	struct lpfc_ras_fwlog *ras_fwlog = &phba->ras_fwlog;
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	ras_fwlog->state = INACTIVE;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 
 	/* Disable FW logging to host memory */
 	writel(LPFC_CTL_PDEV_CTL_DDL_RAS,
@@ -6889,9 +6889,9 @@ lpfc_sli4_ras_dma_free(struct lpfc_hba *phba)
 		ras_fwlog->lwpd.virt = NULL;
 	}
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	ras_fwlog->state = INACTIVE;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 }
 
 /**
@@ -6993,9 +6993,9 @@ lpfc_sli4_ras_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		goto disable_ras;
 	}
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	ras_fwlog->state = ACTIVE;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 	mempool_free(pmb, phba->mbox_mem_pool);
 
 	return;
@@ -7027,9 +7027,9 @@ lpfc_sli4_ras_fwlog_init(struct lpfc_hba *phba,
 	uint32_t len = 0, fwlog_buffsize, fwlog_entry_count;
 	int rc = 0;
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	ras_fwlog->state = INACTIVE;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 
 	fwlog_buffsize = (LPFC_RAS_MIN_BUFF_POST_SIZE *
 			  phba->cfg_ras_fwlog_buffsize);
@@ -7090,9 +7090,9 @@ lpfc_sli4_ras_fwlog_init(struct lpfc_hba *phba,
 	mbx_fwlog->u.request.lwpd.addr_lo = putPaddrLow(ras_fwlog->lwpd.phys);
 	mbx_fwlog->u.request.lwpd.addr_hi = putPaddrHigh(ras_fwlog->lwpd.phys);
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irq(&phba->ras_fwlog_lock);
 	ras_fwlog->state = REG_INPROGRESS;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irq(&phba->ras_fwlog_lock);
 	mbox->vport = phba->pport;
 	mbox->mbox_cmpl = lpfc_sli4_ras_mbox_cmpl;
 
-- 
2.43.0



