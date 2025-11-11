Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CE71C28E;
	Tue, 11 Nov 2025 01:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824825; cv=none; b=klvgvHd6ncCZXS2X/atXwvJcjy3QqYh+X/Kgyt3Is1Ie0O7pKkc1xPbIp8QwXADRglL+hZob7TG7f1A2+XTDT6j5rMiKUdF4PVbJwtixeihGmce7mCuYjBIXQ1TPBGmxzPOWbuSslAgarewlmg16NwcOvNPBq5xhPr3GlpsT//E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824825; c=relaxed/simple;
	bh=AiC4JYgYdcCYUQ2bID9dORijhyOxATXoJ+kb5mec1kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ys9VvLsXWnnNRqn70qflkXf8hnnnyZnNRhiH8BEBj4WtFsKTwsDqDvEf2q9pLqk96mo8tsA4yWcTtIr9bg5xRm4Ei5Xjkh/l3gBKXbEha0/LAv1+dXjbgfbY2QnhW24TkYUQeVYRFNMx66tUQ4cx9BE6uvHyD753ep9k7D1mQzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McxAqf79; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McxAqf79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559C4C116B1;
	Tue, 11 Nov 2025 01:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824825;
	bh=AiC4JYgYdcCYUQ2bID9dORijhyOxATXoJ+kb5mec1kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=McxAqf79yGCaE7UdhbuoNI4uZQWMWob+rok7/E6jgMZ9+H5QkvnBVPJflO2tw8JFw
	 /SNi6VcfoxOrSj132PDT7b4MvMx0xznQDwfYlFYlWUetoBvgukAugsjZoYIA3ycA8O
	 3ZMXOKm1sBoP+D1J+g8N9rkwERjgZmwMCMvae5Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 577/849] scsi: lpfc: Ensure PLOGI_ACC is sent prior to PRLI in Point to Point topology
Date: Tue, 11 Nov 2025 09:42:27 +0900
Message-ID: <20251111004550.369172543@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 2bf81856a403c92a4ce375288f33fba82ca2ccc6 ]

There is a timing race condition when a PRLI may be sent on the wire
before PLOGI_ACC in Point to Point topology.  Fix by deferring REG_RPI
mbox completion handling to after PLOGI_ACC's CQE completion.  Because
the discovery state machine only sends PRLI after REG_RPI mbox
completion, PRLI is now guaranteed to be sent after PLOGI_ACC.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Message-ID: <20250915180811.137530-8-justintee8345@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c       | 10 +++++++---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 23 ++++++++++++++++++-----
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 3f703932b2f07..8762fb84f14f1 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5339,12 +5339,12 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		ulp_status, ulp_word4, did);
 	/* ELS response tag <ulpIoTag> completes */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "0110 ELS response tag x%x completes "
+			 "0110 ELS response tag x%x completes fc_flag x%lx"
 			 "Data: x%x x%x x%x x%x x%lx x%x x%x x%x %p %p\n",
-			 iotag, ulp_status, ulp_word4, tmo,
+			 iotag, vport->fc_flag, ulp_status, ulp_word4, tmo,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi, kref_read(&ndlp->kref), mbox, ndlp);
-	if (mbox) {
+	if (mbox && !test_bit(FC_PT2PT, &vport->fc_flag)) {
 		if (ulp_status == 0 &&
 		    test_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag)) {
 			if (!lpfc_unreg_rpi(vport, ndlp) &&
@@ -5403,6 +5403,10 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		}
 out_free_mbox:
 		lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
+	} else if (mbox && test_bit(FC_PT2PT, &vport->fc_flag) &&
+		   test_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag)) {
+		lpfc_mbx_cmpl_reg_login(phba, mbox);
+		clear_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag);
 	}
 out:
 	if (ndlp && shost) {
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index a596b80d03d4d..3799bdf2f1b88 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -326,8 +326,14 @@ lpfc_defer_plogi_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *login_mbox)
 		/* Now that REG_RPI completed successfully,
 		 * we can now proceed with sending the PLOGI ACC.
 		 */
-		rc = lpfc_els_rsp_acc(login_mbox->vport, ELS_CMD_PLOGI,
-				      save_iocb, ndlp, NULL);
+		if (test_bit(FC_PT2PT, &ndlp->vport->fc_flag)) {
+			rc = lpfc_els_rsp_acc(login_mbox->vport, ELS_CMD_PLOGI,
+					      save_iocb, ndlp, login_mbox);
+		} else {
+			rc = lpfc_els_rsp_acc(login_mbox->vport, ELS_CMD_PLOGI,
+					      save_iocb, ndlp, NULL);
+		}
+
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 					"4576 PLOGI ACC fails pt2pt discovery: "
@@ -335,9 +341,16 @@ lpfc_defer_plogi_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *login_mbox)
 		}
 	}
 
-	/* Now process the REG_RPI cmpl */
-	lpfc_mbx_cmpl_reg_login(phba, login_mbox);
-	clear_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag);
+	/* If this is a fabric topology, complete the reg_rpi and prli now.
+	 * For Pt2Pt, the reg_rpi and PRLI are deferred until after the LS_ACC
+	 * completes.  This ensures, in Pt2Pt, that the PLOGI LS_ACC is sent
+	 * before the PRLI.
+	 */
+	if (!test_bit(FC_PT2PT, &ndlp->vport->fc_flag)) {
+		/* Now process the REG_RPI cmpl */
+		lpfc_mbx_cmpl_reg_login(phba, login_mbox);
+		clear_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag);
+	}
 	kfree(save_iocb);
 }
 
-- 
2.51.0



