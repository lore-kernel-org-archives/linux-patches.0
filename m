Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C33C24DFF3;
	Tue, 29 Apr 2025 17:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949318; cv=none; b=KXPkHUAl1p6MPOkEKXxACddqUxJHp/w5uhj1N6BAy4GYieFKym30oDh0+hExpOgpbbqpMeN6Y2b5nhcECYB9EakVAGaYEMPRc7JIHSTx8jcsvbKz88QdCTjbcw2Sgr9DgcdOaviGWWxC5O7uIfD0sX9+9iiUnRu5+lVo62gtBDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949318; c=relaxed/simple;
	bh=1+RKT4ghdjOTlEiKD8IGYuGV2affvySA6WdRxL0jkPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJ4pZEFF3mKeEUNNQ2icLWn0yd2qHugLYVW4emw//C4g0hda8z8CuOPe9jdNAtNGTD+YDnLDcQimdrdQ9yl3B4X+srJhKIE0OWeNBk6eN0ZOC1VEt8sFjkOtGN2XG5LQOCiTqruyC/ybH0kKivrs1nD4lx3qgpLjqRnu5gs8VVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7SFikh9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7SFikh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EECC4CEE3;
	Tue, 29 Apr 2025 17:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949317;
	bh=1+RKT4ghdjOTlEiKD8IGYuGV2affvySA6WdRxL0jkPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7SFikh9xUqpTd/bzGiS47PMxSCcyEQVeBU6+MMgT87zTTVmx6TdGBTJsVsg6guCy
	 upBoJ9A7zugrMI0CqUubVuAZOS0xondr7Ynyd7I7fOmevIcL/59d1BlRR8/imkY56R
	 qs6eeEpCBCUjvyM2aXpMkCojmMZJx83IieLQl7ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	James Smart <jsmart2021@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 251/373] scsi: lpfc: Fix null pointer dereference after failing to issue FLOGI and PLOGI
Date: Tue, 29 Apr 2025 18:42:08 +0200
Message-ID: <20250429161133.447766370@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Smart <jsmart2021@gmail.com>

commit 577a942df3de2666f6947bdd3a5c9e8d30073424 upstream.

If lpfc_issue_els_flogi() fails and returns non-zero status, the node
reference count is decremented to trigger the release of the nodelist
structure. However, if there is a prior registration or dev-loss-evt work
pending, the node may be released prematurely.  When dev-loss-evt
completes, the released node is referenced causing a use-after-free null
pointer dereference.

Similarly, when processing non-zero ELS PLOGI completion status in
lpfc_cmpl_els_plogi(), the ndlp flags are checked for a transport
registration before triggering node removal.  If dev-loss-evt work is
pending, the node may be released prematurely and a subsequent call to
lpfc_dev_loss_tmo_handler() results in a use after free ndlp dereference.

Add test for pending dev-loss before decrementing the node reference count
for FLOGI, PLOGI, PRLI, and ADISC handling.

Link: https://lore.kernel.org/r/20220412222008.126521-9-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[Minor context change fixed.]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_els.c |   51 +++++++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 16 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1517,10 +1517,13 @@ lpfc_initial_flogi(struct lpfc_vport *vp
 	}
 
 	if (lpfc_issue_els_flogi(vport, ndlp, 0)) {
-		/* This decrement of reference count to node shall kick off
-		 * the release of the node.
+		/* A node reference should be retained while registered with a
+		 * transport or dev-loss-evt work is pending.
+		 * Otherwise, decrement node reference to trigger release.
 		 */
-		lpfc_nlp_put(ndlp);
+		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)) &&
+		    !(ndlp->nlp_flag & NLP_IN_DEV_LOSS))
+			lpfc_nlp_put(ndlp);
 		return 0;
 	}
 	return 1;
@@ -1563,10 +1566,13 @@ lpfc_initial_fdisc(struct lpfc_vport *vp
 	}
 
 	if (lpfc_issue_els_fdisc(vport, ndlp, 0)) {
-		/* decrement node reference count to trigger the release of
-		 * the node.
+		/* A node reference should be retained while registered with a
+		 * transport or dev-loss-evt work is pending.
+		 * Otherwise, decrement node reference to trigger release.
 		 */
-		lpfc_nlp_put(ndlp);
+		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)) &&
+		    !(ndlp->nlp_flag & NLP_IN_DEV_LOSS))
+			lpfc_nlp_put(ndlp);
 		return 0;
 	}
 	return 1;
@@ -1967,6 +1973,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phb
 	struct lpfc_dmabuf *prsp;
 	int disc;
 	struct serv_parm *sp = NULL;
+	bool release_node = false;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
@@ -2047,19 +2054,21 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phb
 			spin_unlock_irq(&ndlp->lock);
 			goto out;
 		}
-		spin_unlock_irq(&ndlp->lock);
 
 		/* No PLOGI collision and the node is not registered with the
 		 * scsi or nvme transport. It is no longer an active node. Just
 		 * start the device remove process.
 		 */
 		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
-			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
-			spin_unlock_irq(&ndlp->lock);
+			if (!(ndlp->nlp_flag & NLP_IN_DEV_LOSS))
+				release_node = true;
+		}
+		spin_unlock_irq(&ndlp->lock);
+
+		if (release_node)
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_DEVICE_RM);
-		}
 	} else {
 		/* Good status, call state machine */
 		prsp = list_entry(((struct lpfc_dmabuf *)
@@ -2269,6 +2278,7 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba
 	struct lpfc_nodelist *ndlp;
 	char *mode;
 	u32 loglevel;
+	bool release_node = false;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
@@ -2335,14 +2345,18 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba
 		 * it is no longer an active node.  Otherwise devloss
 		 * handles the final cleanup.
 		 */
+		spin_lock_irq(&ndlp->lock);
 		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)) &&
 		    !ndlp->fc4_prli_sent) {
-			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
-			spin_unlock_irq(&ndlp->lock);
+			if (!(ndlp->nlp_flag & NLP_IN_DEV_LOSS))
+				release_node = true;
+		}
+		spin_unlock_irq(&ndlp->lock);
+
+		if (release_node)
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_DEVICE_RM);
-		}
 	} else {
 		/* Good status, call state machine.  However, if another
 		 * PRLI is outstanding, don't call the state machine
@@ -2713,6 +2727,7 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phb
 	IOCB_t *irsp;
 	struct lpfc_nodelist *ndlp;
 	int  disc;
+	bool release_node = false;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
@@ -2771,13 +2786,17 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phb
 		 * transport, it is no longer an active node. Otherwise
 		 * devloss handles the final cleanup.
 		 */
+		spin_lock_irq(&ndlp->lock);
 		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
-			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
-			spin_unlock_irq(&ndlp->lock);
+			if (!(ndlp->nlp_flag & NLP_IN_DEV_LOSS))
+				release_node = true;
+		}
+		spin_unlock_irq(&ndlp->lock);
+
+		if (release_node)
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_DEVICE_RM);
-		}
 	} else
 		/* Good status, call state machine */
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,


