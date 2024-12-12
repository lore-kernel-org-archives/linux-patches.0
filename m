Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99363221D93;
	Thu, 12 Dec 2024 15:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018368; cv=none; b=WrJhJTW+MU7r44HDvg5xR28tbu0SskEj/aSuFcKJ1KjNhQmL1vgcveLOnBOCOF4SGfSN6KBJOi+HB7cJeuxsJfXy1cBQvIf/aJqt/72kB1jyqmsDrnDu6ScvSfEK3Yg0JBCeU5oUvZ6COlZn4cuVTa3x/Oe/KWTJHl0xGOof8WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018368; c=relaxed/simple;
	bh=iNIgssApq+5NSnYxh58Hq0Dx3YAlllx6guLtwgX3+80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBBjbKsdmcp98TIx4IS/3Mf9QlRXFNIz4jPOWMunk8ts5Kk8Uoi5zlRHEfrwtH2atMAsLSu9P32GBvgdaevmf9gMoiB4BpIEBxUcdRgzMBZuldkTKegfc88eXetmQd/Acxqg5dRI7B6xN8Q4wOV1aQi0l49nkKoBG90AOmwetLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMkH9Q/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMkH9Q/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8A5C4CECE;
	Thu, 12 Dec 2024 15:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018368;
	bh=iNIgssApq+5NSnYxh58Hq0Dx3YAlllx6guLtwgX3+80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMkH9Q/Tm4l+ZgtUoTxzDDqB+yCjtkhZSMq4gEhkgoGqyB2IkTUyDX4dVGSpy28L+
	 61Ql9gRPnnKM3Ml16IEtRWeWqrvfjoYzspqHzQWWYxLW7oPNfqEjZbt9oosl5k4gVF
	 NdwBv79Nk9kNx9bjCmnefCM4WLnc6YTqkNNUzaNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 274/356] scsi: lpfc: Call lpfc_sli4_queue_unset() in restart and rmmod paths
Date: Thu, 12 Dec 2024 15:59:53 +0100
Message-ID: <20241212144255.413692471@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

[ Upstream commit d35f7672715d1ff3e3ad9bb4ae6ac6cb484200fe ]

During initialization, the driver allocates wq->pring in lpfc_wq_create
and lpfc_sli4_queue_unset() is the only place where kfree(wq->pring) is
called.

There is a possible memory leak in lpfc_sli_brdrestart_s4() (restart)
and lpfc_pci_remove_one_s4() (rmmod) paths because there are no calls to
lpfc_sli4_queue_unset() to kfree() the wq->pring.

Fix by inserting a call to lpfc_sli4_queue_unset() in
lpfc_sli_brdrestart_s4() and lpfc_sli4_hba_unset() routines.  Also, add
a check for the SLI_ACTIVE flag before issuing the Q_DESTROY mailbox
command.  If not set, then the mailbox command will obviously fail.  In
such cases, skip issuing the mailbox command and only execute the driver
resource clean up portions of the lpfc_*q_destroy routines.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20241031223219.152342-4-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c |  2 ++
 drivers/scsi/lpfc/lpfc_sli.c  | 41 ++++++++++++++++++++++++++++++-----
 2 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 416816d74ea1c..424b39a8155cb 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13513,6 +13513,8 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
 	/* Disable FW logging to host memory */
 	lpfc_ras_stop_fwlog(phba);
 
+	lpfc_sli4_queue_unset(phba);
+
 	/* Reset SLI4 HBA FCoE function */
 	lpfc_pci_function_reset(phba);
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 9b1ffa84a0629..4a9fa00eeb798 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5285,6 +5285,8 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
 			"0296 Restart HBA Data: x%x x%x\n",
 			phba->pport->port_state, psli->sli_flag);
 
+	lpfc_sli4_queue_unset(phba);
+
 	rc = lpfc_sli4_brdreset(phba);
 	if (rc) {
 		phba->link_state = LPFC_HBA_ERROR;
@@ -17630,6 +17632,9 @@ lpfc_eq_destroy(struct lpfc_hba *phba, struct lpfc_queue *eq)
 	if (!eq)
 		return -ENODEV;
 
+	if (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE))
+		goto list_remove;
+
 	mbox = mempool_alloc(eq->phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
@@ -17656,10 +17661,12 @@ lpfc_eq_destroy(struct lpfc_hba *phba, struct lpfc_queue *eq)
 				shdr_status, shdr_add_status, rc);
 		status = -ENXIO;
 	}
+	mempool_free(mbox, eq->phba->mbox_mem_pool);
 
+list_remove:
 	/* Remove eq from any list */
 	list_del_init(&eq->list);
-	mempool_free(mbox, eq->phba->mbox_mem_pool);
+
 	return status;
 }
 
@@ -17687,6 +17694,10 @@ lpfc_cq_destroy(struct lpfc_hba *phba, struct lpfc_queue *cq)
 	/* sanity check on queue memory */
 	if (!cq)
 		return -ENODEV;
+
+	if (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE))
+		goto list_remove;
+
 	mbox = mempool_alloc(cq->phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
@@ -17712,9 +17723,11 @@ lpfc_cq_destroy(struct lpfc_hba *phba, struct lpfc_queue *cq)
 				shdr_status, shdr_add_status, rc);
 		status = -ENXIO;
 	}
+	mempool_free(mbox, cq->phba->mbox_mem_pool);
+
+list_remove:
 	/* Remove cq from any list */
 	list_del_init(&cq->list);
-	mempool_free(mbox, cq->phba->mbox_mem_pool);
 	return status;
 }
 
@@ -17742,6 +17755,10 @@ lpfc_mq_destroy(struct lpfc_hba *phba, struct lpfc_queue *mq)
 	/* sanity check on queue memory */
 	if (!mq)
 		return -ENODEV;
+
+	if (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE))
+		goto list_remove;
+
 	mbox = mempool_alloc(mq->phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
@@ -17767,9 +17784,11 @@ lpfc_mq_destroy(struct lpfc_hba *phba, struct lpfc_queue *mq)
 				shdr_status, shdr_add_status, rc);
 		status = -ENXIO;
 	}
+	mempool_free(mbox, mq->phba->mbox_mem_pool);
+
+list_remove:
 	/* Remove mq from any list */
 	list_del_init(&mq->list);
-	mempool_free(mbox, mq->phba->mbox_mem_pool);
 	return status;
 }
 
@@ -17797,6 +17816,10 @@ lpfc_wq_destroy(struct lpfc_hba *phba, struct lpfc_queue *wq)
 	/* sanity check on queue memory */
 	if (!wq)
 		return -ENODEV;
+
+	if (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE))
+		goto list_remove;
+
 	mbox = mempool_alloc(wq->phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
@@ -17821,11 +17844,13 @@ lpfc_wq_destroy(struct lpfc_hba *phba, struct lpfc_queue *wq)
 				shdr_status, shdr_add_status, rc);
 		status = -ENXIO;
 	}
+	mempool_free(mbox, wq->phba->mbox_mem_pool);
+
+list_remove:
 	/* Remove wq from any list */
 	list_del_init(&wq->list);
 	kfree(wq->pring);
 	wq->pring = NULL;
-	mempool_free(mbox, wq->phba->mbox_mem_pool);
 	return status;
 }
 
@@ -17855,6 +17880,10 @@ lpfc_rq_destroy(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 	/* sanity check on queue memory */
 	if (!hrq || !drq)
 		return -ENODEV;
+
+	if (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE))
+		goto list_remove;
+
 	mbox = mempool_alloc(hrq->phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
@@ -17895,9 +17924,11 @@ lpfc_rq_destroy(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 				shdr_status, shdr_add_status, rc);
 		status = -ENXIO;
 	}
+	mempool_free(mbox, hrq->phba->mbox_mem_pool);
+
+list_remove:
 	list_del_init(&hrq->list);
 	list_del_init(&drq->list);
-	mempool_free(mbox, hrq->phba->mbox_mem_pool);
 	return status;
 }
 
-- 
2.43.0



