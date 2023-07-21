Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1D920F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931DAC433C7;
	Fri, 21 Jul 2023 19:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967458;
	bh=V0JeYq2ioSUtT3t8+CpZOy0v5xCGhg0TrSYGr0iQbaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiVNgnSR1qpojSTDx8cACfUjBri+4Oeaui4o+ImA2MYBU+tESmK+jXBiOG5StYVt1
	 SepUBdpd6rx1nwfy/paUxdEyn7y4gPz7hS+4PtAxSKn698Ev57qK/v9K1lmE3mQMFA
	 ejdXhP9I0T5pJaleRRALn6Nf7EFWnwiSbKKzkovA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 142/223] scsi: lpfc: Fix double free in lpfc_cmpl_els_logo_acc() caused by lpfc_nlp_not_used()
Date: Fri, 21 Jul 2023 18:06:35 +0200
Message-ID: <20230721160526.925492294@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

commit 97f975823f8196d970bd795087b514271214677a upstream.

Smatch detected a double free path because lpfc_nlp_not_used() releases an
ndlp object before reaching lpfc_nlp_put() at the end of
lpfc_cmpl_els_logo_acc().

Remove the outdated lpfc_nlp_not_used() routine.  In
lpfc_mbx_cmpl_ns_reg_login(), replace the call with lpfc_nlp_put().  In
lpfc_cmpl_els_logo_acc(), replace the call with lpfc_unreg_rpi() and keep
the lpfc_nlp_put() at the end of the routine.  If ndlp's rpi was
registered, then lpfc_unreg_rpi()'s completion routine performs the final
ndlp clean up after lpfc_nlp_put() is called from lpfc_cmpl_els_logo_acc().
Otherwise if ndlp has no rpi registered, the lpfc_nlp_put() at the end of
lpfc_cmpl_els_logo_acc() is the final ndlp clean up.

Fixes: 4430f7fd09ec ("scsi: lpfc: Rework locations of ndlp reference taking")
Cc: <stable@vger.kernel.org> # v5.11+
Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/all/Y3OefhyyJNKH%2Fiaf@kili/
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20230417191558.83100-3-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_crtn.h    |    1 -
 drivers/scsi/lpfc/lpfc_els.c     |   30 +++++++-----------------------
 drivers/scsi/lpfc/lpfc_hbadisc.c |   24 +++---------------------
 3 files changed, 10 insertions(+), 45 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -134,7 +134,6 @@ void lpfc_check_nlp_post_devloss(struct
 				 struct lpfc_nodelist *ndlp);
 void lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			  struct lpfc_iocbq *rspiocb);
-int  lpfc_nlp_not_used(struct lpfc_nodelist *ndlp);
 struct lpfc_nodelist *lpfc_setup_disc_node(struct lpfc_vport *, uint32_t);
 void lpfc_disc_list_loopmap(struct lpfc_vport *);
 void lpfc_disc_start(struct lpfc_vport *);
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5150,14 +5150,9 @@ lpfc_els_free_iocb(struct lpfc_hba *phba
  *
  * This routine is the completion callback function to the Logout (LOGO)
  * Accept (ACC) Response ELS command. This routine is invoked to indicate
- * the completion of the LOGO process. It invokes the lpfc_nlp_not_used() to
- * release the ndlp if it has the last reference remaining (reference count
- * is 1). If succeeded (meaning ndlp released), it sets the iocb ndlp
- * field to NULL to inform the following lpfc_els_free_iocb() routine no
- * ndlp reference count needs to be decremented. Otherwise, the ndlp
- * reference use-count shall be decremented by the lpfc_els_free_iocb()
- * routine. Finally, the lpfc_els_free_iocb() is invoked to release the
- * IOCB data structure.
+ * the completion of the LOGO process. If the node has transitioned to NPR,
+ * this routine unregisters the RPI if it is still registered. The
+ * lpfc_els_free_iocb() is invoked to release the IOCB data structure.
  **/
 static void
 lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
@@ -5198,19 +5193,9 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *
 		    (ndlp->nlp_last_elscmd == ELS_CMD_PLOGI))
 			goto out;
 
-		/* NPort Recovery mode or node is just allocated */
-		if (!lpfc_nlp_not_used(ndlp)) {
-			/* A LOGO is completing and the node is in NPR state.
-			 * Just unregister the RPI because the node is still
-			 * required.
-			 */
+		if (ndlp->nlp_flag & NLP_RPI_REGISTERED)
 			lpfc_unreg_rpi(vport, ndlp);
-		} else {
-			/* Indicate the node has already released, should
-			 * not reference to it from within lpfc_els_free_iocb.
-			 */
-			cmdiocb->ndlp = NULL;
-		}
+
 	}
  out:
 	/*
@@ -5230,9 +5215,8 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *
  * RPI (Remote Port Index) mailbox command to the @phba. It simply releases
  * the associated lpfc Direct Memory Access (DMA) buffer back to the pool and
  * decrements the ndlp reference count held for this completion callback
- * function. After that, it invokes the lpfc_nlp_not_used() to check
- * whether there is only one reference left on the ndlp. If so, it will
- * perform one more decrement and trigger the release of the ndlp.
+ * function. After that, it invokes the lpfc_drop_node to check
+ * whether it is appropriate to release the node.
  **/
 void
 lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4332,13 +4332,14 @@ out:
 
 		/* If the node is not registered with the scsi or nvme
 		 * transport, remove the fabric node.  The failed reg_login
-		 * is terminal.
+		 * is terminal and forces the removal of the last node
+		 * reference.
 		 */
 		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
 			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
 			spin_unlock_irq(&ndlp->lock);
-			lpfc_nlp_not_used(ndlp);
+			lpfc_nlp_put(ndlp);
 		}
 
 		if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
@@ -6703,25 +6704,6 @@ lpfc_nlp_put(struct lpfc_nodelist *ndlp)
 	return ndlp ? kref_put(&ndlp->kref, lpfc_nlp_release) : 0;
 }
 
-/* This routine free's the specified nodelist if it is not in use
- * by any other discovery thread. This routine returns 1 if the
- * ndlp has been freed. A return value of 0 indicates the ndlp is
- * not yet been released.
- */
-int
-lpfc_nlp_not_used(struct lpfc_nodelist *ndlp)
-{
-	lpfc_debugfs_disc_trc(ndlp->vport, LPFC_DISC_TRC_NODE,
-		"node not used:   did:x%x flg:x%x refcnt:x%x",
-		ndlp->nlp_DID, ndlp->nlp_flag,
-		kref_read(&ndlp->kref));
-
-	if (kref_read(&ndlp->kref) == 1)
-		if (lpfc_nlp_put(ndlp))
-			return 1;
-	return 0;
-}
-
 /**
  * lpfc_fcf_inuse - Check if FCF can be unregistered.
  * @phba: Pointer to hba context object.


