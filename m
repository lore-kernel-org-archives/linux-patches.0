Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F531D5CD1;
	Tue,  8 Jul 2025 16:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993031; cv=none; b=lBKE3Xx94bO+awcRXFeXYmHP93kykN15WSursgqdsbJnml3T2af0ZouqVfJo7C/gXKr8P5PXkmJQnUzBity9OWkVe2hYEtqB3UlPkL8VkmuArsoz4i/yg+jPTdyKiVXls9h5NKSaHJJ39qzP1yWKvTvNKZP9A19+qU4vlowHB5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993031; c=relaxed/simple;
	bh=CbAcxCfslEg0qUyZBE+y5VlT1DDvfid3g9F+ZuZ8MVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcwOyXC40SlcZu/wII+1bwh5e3FcG22Gv8iYlmmL7inZu2kvx4UEc8sCQ+yL4u8SW3zPz4wIYSiv0t9c6d4o2AmC+8iQO40kVo6jM0AW8j6WOZUUkKXGE9LKOBquLpx+RjPaLMNaw+iyF/+Ewx04K1Nze5fbYcTmIBVxMje0Afs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVDn7ewr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVDn7ewr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C6AC4CEED;
	Tue,  8 Jul 2025 16:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993030;
	bh=CbAcxCfslEg0qUyZBE+y5VlT1DDvfid3g9F+ZuZ8MVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVDn7ewrfAwP4EyXsFNO7zNsFHecdSUPYNI2Ox+4QbG9VSUpimM6JRxVBWIkueP3b
	 llj0fJWrz8iwVEzjgo54ePj7iJbZiiSGqFNbJ35SuI5Cju9TYADVKznTlraI/P6O4i
	 aId+61cb0tAsHqjC2XdtwjUZCvV815mVkTKUaPaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 133/232] scsi: lpfc: Avoid potential ndlp use-after-free in dev_loss_tmo_callbk
Date: Tue,  8 Jul 2025 18:22:09 +0200
Message-ID: <20250708162244.924792734@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit b5162bb6aa1ec04dff4509b025883524b6d7e7ca ]

Smatch detected a potential use-after-free of an ndlp oject in
dev_loss_tmo_callbk during driver unload or fatal error handling.

Fix by reordering code to avoid potential use-after-free if initial
nodelist reference has been previously removed.

Fixes: 4281f44ea8bf ("scsi: lpfc: Prevent NDLP reference count underflow in dev_loss_tmo callback")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-scsi/41c1d855-9eb5-416f-ac12-8b61929201a3@stanley.mountain/
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20250425194806.3585-6-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 5297122f89fc8..b5dd17eecf82d 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -155,7 +155,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	struct lpfc_hba   *phba;
 	struct lpfc_work_evt *evtp;
 	unsigned long iflags;
-	bool nvme_reg = false;
+	bool drop_initial_node_ref = false;
 
 	ndlp = ((struct lpfc_rport_data *)rport->dd_data)->pnode;
 	if (!ndlp)
@@ -182,8 +182,13 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 		spin_lock_irqsave(&ndlp->lock, iflags);
 		ndlp->rport = NULL;
 
-		if (ndlp->fc4_xpt_flags & NVME_XPT_REGD)
-			nvme_reg = true;
+		/* Only 1 thread can drop the initial node reference.
+		 * If not registered for NVME and NLP_DROPPED flag is
+		 * clear, remove the initial reference.
+		 */
+		if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
+			if (!test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
+				drop_initial_node_ref = true;
 
 		/* The scsi_transport is done with the rport so lpfc cannot
 		 * call to unregister.
@@ -194,13 +199,16 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 			/* If NLP_XPT_REGD was cleared in lpfc_nlp_unreg_node,
 			 * unregister calls were made to the scsi and nvme
 			 * transports and refcnt was already decremented. Clear
-			 * the NLP_XPT_REGD flag only if the NVME Rport is
+			 * the NLP_XPT_REGD flag only if the NVME nrport is
 			 * confirmed unregistered.
 			 */
-			if (!nvme_reg && ndlp->fc4_xpt_flags & NLP_XPT_REGD) {
-				ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
+			if (ndlp->fc4_xpt_flags & NLP_XPT_REGD) {
+				if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
+					ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
 				spin_unlock_irqrestore(&ndlp->lock, iflags);
-				lpfc_nlp_put(ndlp); /* may free ndlp */
+
+				/* Release scsi transport reference */
+				lpfc_nlp_put(ndlp);
 			} else {
 				spin_unlock_irqrestore(&ndlp->lock, iflags);
 			}
@@ -208,14 +216,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 			spin_unlock_irqrestore(&ndlp->lock, iflags);
 		}
 
-		/* Only 1 thread can drop the initial node reference.  If
-		 * another thread has set NLP_DROPPED, this thread is done.
-		 */
-		if (nvme_reg || test_bit(NLP_DROPPED, &ndlp->nlp_flag))
-			return;
-
-		set_bit(NLP_DROPPED, &ndlp->nlp_flag);
-		lpfc_nlp_put(ndlp);
+		if (drop_initial_node_ref)
+			lpfc_nlp_put(ndlp);
 		return;
 	}
 
-- 
2.39.5



