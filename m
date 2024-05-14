Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326702B9AD;
	Tue, 14 May 2024 11:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685076; cv=none; b=XI5UyPwWjRSaRd20kTswm8j/B1KIgBM2Juy6O5wxb0GIpjp4HpefzeSwJlBFZqHlNYjzxWDz4qDZae+jbb0pdncnZn4j5mCa5l9vOdK2G+h1vDK+sPVpLeKp5RKK0ZTZnOCiiAHDSpja1iJvGK8GemHLGkeK5Ir+HH4zD2SlrJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685076; c=relaxed/simple;
	bh=hmyY3/7vmP497m/Ilg498ni/TksZrnrkTDyniW41NEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBSta97pk18cR8Q+08qSLVrEXjmIL4mDfnL44gp5HKZU67RSaLje4ry33Lf7Z25JiGIoEE/lh+6ljP2Ss4bEtDFBCsP1UsUYGOPcYD0mXq9tLrL0l75e684/EVioIMSyGJ/1Y6/mF5IdTkRWcCkTUm7MTm0J4rgUJ1Qo+h9qayI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LA1cR4b+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LA1cR4b+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8767BC2BD10;
	Tue, 14 May 2024 11:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685076;
	bh=hmyY3/7vmP497m/Ilg498ni/TksZrnrkTDyniW41NEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LA1cR4b+X5xvYXs25hMgwAkFXTZ5RyG9/Rk15yB/2TIsgYFwrqkU6pEE5gg0OgJy3
	 t26sOwSq2PTkPkl1WDoCOFBYy3ZFw+r1l3C+4K/m1aJKG5MJ8XPl8A8KiyTwp4MG33
	 7XgYlYc13j8k3H+cOLgQLGD66Bg8EBbPsRT/JcaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/301] scsi: lpfc: Release hbalock before calling lpfc_worker_wake_up()
Date: Tue, 14 May 2024 12:16:12 +0200
Message-ID: <20240514101036.064458432@linuxfoundation.org>
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

[ Upstream commit ded20192dff31c91cef2a04f7e20e60e9bb887d3 ]

lpfc_worker_wake_up() calls the lpfc_work_done() routine, which takes the
hbalock.  Thus, lpfc_worker_wake_up() should not be called while holding the
hbalock to avoid potential deadlock.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240305200503.57317-7-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c     | 20 ++++++++++----------
 drivers/scsi/lpfc/lpfc_hbadisc.c |  5 ++---
 drivers/scsi/lpfc/lpfc_sli.c     | 14 +++++++-------
 3 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 18b8325fd419e..44d3ada9fbbcb 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4432,23 +4432,23 @@ lpfc_els_retry_delay(struct timer_list *t)
 	unsigned long flags;
 	struct lpfc_work_evt  *evtp = &ndlp->els_retry_evt;
 
+	/* Hold a node reference for outstanding queued work */
+	if (!lpfc_nlp_get(ndlp))
+		return;
+
 	spin_lock_irqsave(&phba->hbalock, flags);
 	if (!list_empty(&evtp->evt_listp)) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
+		lpfc_nlp_put(ndlp);
 		return;
 	}
 
-	/* We need to hold the node by incrementing the reference
-	 * count until the queued work is done
-	 */
-	evtp->evt_arg1  = lpfc_nlp_get(ndlp);
-	if (evtp->evt_arg1) {
-		evtp->evt = LPFC_EVT_ELS_RETRY;
-		list_add_tail(&evtp->evt_listp, &phba->work_list);
-		lpfc_worker_wake_up(phba);
-	}
+	evtp->evt_arg1 = ndlp;
+	evtp->evt = LPFC_EVT_ELS_RETRY;
+	list_add_tail(&evtp->evt_listp, &phba->work_list);
 	spin_unlock_irqrestore(&phba->hbalock, flags);
-	return;
+
+	lpfc_worker_wake_up(phba);
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 5154eeaee0ec3..93703ab6ce037 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -257,7 +257,9 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 		if (evtp->evt_arg1) {
 			evtp->evt = LPFC_EVT_DEV_LOSS;
 			list_add_tail(&evtp->evt_listp, &phba->work_list);
+			spin_unlock_irqrestore(&phba->hbalock, iflags);
 			lpfc_worker_wake_up(phba);
+			return;
 		}
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	} else {
@@ -275,10 +277,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 			lpfc_disc_state_machine(vport, ndlp, NULL,
 						NLP_EVT_DEVICE_RM);
 		}
-
 	}
-
-	return;
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 4dfadf254a727..9dab33686a931 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1217,9 +1217,9 @@ lpfc_set_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 	empty = list_empty(&phba->active_rrq_list);
 	list_add_tail(&rrq->list, &phba->active_rrq_list);
 	phba->hba_flag |= HBA_RRQ_ACTIVE;
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	if (empty)
 		lpfc_worker_wake_up(phba);
-	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	return 0;
 out:
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
@@ -11369,18 +11369,18 @@ lpfc_sli_post_recovery_event(struct lpfc_hba *phba,
 	unsigned long iflags;
 	struct lpfc_work_evt  *evtp = &ndlp->recovery_evt;
 
+	/* Hold a node reference for outstanding queued work */
+	if (!lpfc_nlp_get(ndlp))
+		return;
+
 	spin_lock_irqsave(&phba->hbalock, iflags);
 	if (!list_empty(&evtp->evt_listp)) {
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		lpfc_nlp_put(ndlp);
 		return;
 	}
 
-	/* Incrementing the reference count until the queued work is done. */
-	evtp->evt_arg1  = lpfc_nlp_get(ndlp);
-	if (!evtp->evt_arg1) {
-		spin_unlock_irqrestore(&phba->hbalock, iflags);
-		return;
-	}
+	evtp->evt_arg1 = ndlp;
 	evtp->evt = LPFC_EVT_RECOVER_PORT;
 	list_add_tail(&evtp->evt_listp, &phba->work_list);
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
-- 
2.43.0



