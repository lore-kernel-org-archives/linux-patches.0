Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34A323D2B2;
	Mon, 29 Dec 2025 16:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025349; cv=none; b=TPCNCxyOc4nlprxBrWrTWzNN08fNNTkKXzs6qvzllmU1POh8p3qgE+2KUkUSvM7ebKK+dVdk87Nv/xB4GpfaIUVVRDQjUrxCLFz5cE3TfyKsVpOZbeCyYpWhmY74rUoJrgiBrbHYBe9UnSnLYR6Tj/s1rxPynEQ5M6p1bDfJHzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025349; c=relaxed/simple;
	bh=S2oJUhmgbvvrQdV3EIzy6CQS/PCl8e3K9ohPKlyap3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYVmn8ixe5X82kpXQy9Pq6p6d/ykeZz/EjaqB7TQ7aZ3O3/Vy8KfrFpicgBN2Wgus6frnU5Zc4eTW7mbz4aqgLGw1HZV/Xx9+0a2jfI0+7dwB60EJ2QuSuSgeiFUz2wd9+Jd9q267rY8fekAiPfUcF4rIgxGDasjWmLa/NZ3fDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHNFiamZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHNFiamZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE94C4CEF7;
	Mon, 29 Dec 2025 16:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025349;
	bh=S2oJUhmgbvvrQdV3EIzy6CQS/PCl8e3K9ohPKlyap3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IHNFiamZCIoPLkoy4+0T4nWFUZCJM/YO11WeuJxlqJIzKCfcjvyWAyuhxK3Lbsano
	 wyJMuSEA1iKJy4B0tz7ZoxLT8/IpXh/N9sEfamubB8gqjSmlVt4Dl5EKpEwL6wSFQe
	 PwKE6d6ncIgEGo/lmukCXG3FyRp/lk1PkRoq3ku8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 183/430] scsi: lpfc: Fix reusing an ndlp that is marked NLP_DROPPED during FLOGI
Date: Mon, 29 Dec 2025 17:09:45 +0100
Message-ID: <20251229160731.092642247@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 07caedc6a3887938813727beafea40f07c497705 ]

It's possible for an unstable link to repeatedly bounce allowing a FLOGI
retry, but then bounce again forcing an abort of the FLOGI.  Ensure that
the initial reference count on the FLOGI ndlp is restored in this faulty
link scenario.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://patch.msgid.link/20251106224639.139176-8-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c     | 36 +++++++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_hbadisc.c |  4 +++-
 2 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b71db7d7d747..c08237f04bce 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -934,10 +934,15 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(vport)) {
 		/* One additional decrement on node reference count to
-		 * trigger the release of the node
+		 * trigger the release of the node.  Make sure the ndlp
+		 * is marked NLP_DROPPED.
 		 */
-		if (!(ndlp->fc4_xpt_flags & SCSI_XPT_REGD))
+		if (!test_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag) &&
+		    !test_bit(NLP_DROPPED, &ndlp->nlp_flag) &&
+		    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD)) {
+			set_bit(NLP_DROPPED, &ndlp->nlp_flag);
 			lpfc_nlp_put(ndlp);
+		}
 		goto out;
 	}
 
@@ -995,9 +1000,10 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					IOERR_LOOP_OPEN_FAILURE)))
 			lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
 				      "2858 FLOGI Status:x%x/x%x TMO"
-				      ":x%x Data x%lx x%x\n",
+				      ":x%x Data x%lx x%x x%lx x%x\n",
 				      ulp_status, ulp_word4, tmo,
-				      phba->hba_flag, phba->fcf.fcf_flag);
+				      phba->hba_flag, phba->fcf.fcf_flag,
+				      ndlp->nlp_flag, ndlp->fc4_xpt_flags);
 
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
@@ -1015,14 +1021,17 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		 * reference to trigger node release.
 		 */
 		if (!test_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag) &&
-		    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD))
+		    !test_bit(NLP_DROPPED, &ndlp->nlp_flag) &&
+		    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD)) {
+			set_bit(NLP_DROPPED, &ndlp->nlp_flag);
 			lpfc_nlp_put(ndlp);
+		}
 
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
 				 "0150 FLOGI Status:x%x/x%x "
-				 "xri x%x TMO:x%x refcnt %d\n",
+				 "xri x%x iotag x%x TMO:x%x refcnt %d\n",
 				 ulp_status, ulp_word4, cmdiocb->sli4_xritag,
-				 tmo, kref_read(&ndlp->kref));
+				 cmdiocb->iotag, tmo, kref_read(&ndlp->kref));
 
 		/* If this is not a loop open failure, bail out */
 		if (!(ulp_status == IOSTAT_LOCAL_REJECT &&
@@ -1279,6 +1288,19 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	uint32_t tmo, did;
 	int rc;
 
+	/* It's possible for lpfc to reissue a FLOGI on an ndlp that is marked
+	 * NLP_DROPPED.  This happens when the FLOGI completed with the XB bit
+	 * set causing lpfc to reference the ndlp until the XRI_ABORTED CQE is
+	 * issued. The time window for the XRI_ABORTED CQE can be as much as
+	 * 2*2*RA_TOV allowing for ndlp reuse of this type when the link is
+	 * cycling quickly.  When true, restore the initial reference and remove
+	 * the NLP_DROPPED flag as lpfc is retrying.
+	 */
+	if (test_and_clear_bit(NLP_DROPPED, &ndlp->nlp_flag)) {
+		if (!lpfc_nlp_get(ndlp))
+			return 1;
+	}
+
 	cmdsize = (sizeof(uint32_t) + sizeof(struct serv_parm));
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_FLOGI);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 43d246c5c049..717ae56c8e4b 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -424,6 +424,7 @@ lpfc_check_nlp_post_devloss(struct lpfc_vport *vport,
 			    struct lpfc_nodelist *ndlp)
 {
 	if (test_and_clear_bit(NLP_IN_RECOV_POST_DEV_LOSS, &ndlp->save_flags)) {
+		clear_bit(NLP_DROPPED, &ndlp->nlp_flag);
 		lpfc_nlp_get(ndlp);
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY | LOG_NODE,
 				 "8438 Devloss timeout reversed on DID x%x "
@@ -566,7 +567,8 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 			return fcf_inuse;
 		}
 
-		lpfc_nlp_put(ndlp);
+		if (!test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
+			lpfc_nlp_put(ndlp);
 		return fcf_inuse;
 	}
 
-- 
2.51.0



