Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E373B2FCA;
	Sat, 17 Oct 2026 17:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259070; cv=none; b=CowveEwSyEk9DnKg7dVWvQ6BSBTfyj/+EkAOpGY9vE5iSZxpP6dvEWLFY5B0Jtyqjljqj426aOEN19LmS6SDC35t6URCKckAPJMgj6Z6l6jdiZJ913vd01xaAPU4TCi4wlSPKCrt7GJJQaaw+KzCQZNJYjQCOfyOwBcM1aynwbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259070; c=relaxed/simple;
	bh=bSZ5AAVn3y56C2gL13rrK7UsAtJhDl8d0ZZFbsj+3Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C72IXEmR+2VN8ILPDlocAUir6nQDTZMfNQXxd16Wgwch/fLUP+6wUg9Dk/UrLqjYCVNL7xa9H8EsZS+T2mvqU4yrA5SFHdEZAs/loCTLo4Oz9h1XkB1AFtXTWxYHlq1E6yEhzIGZkROF9Q/g7waj/rSAUzdDemVRmlZw05dmcXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hzn6/zmb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hzn6/zmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA771F000C4;
	Sat, 17 Oct 2026 17:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259069;
	bh=1ZCw9HBepe/dEgmc89rfjZCHPq8CgbkLijE2EdvevHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hzn6/zmbDxA5drGnOlPWkKVrtVtQimtdyvdi1G+YKBDnutDRYHD2qTMJAGUZP31aZ
	 Ruw3EAjncbumGNUxPGPgKVaJ24neMA/VnDEjhyzRva1AwJ1JXjvl5DSCQWrZK/2IcP
	 Hk3Cb9m87qKqbCPG/Dr1rJ5p6lrqR/OkTrwvu1nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1091/1674] pds_core: fix use-after-free on workqueue during remove
Date: Sat, 17 Oct 2026 17:56:03 +0200
Message-ID: <20261017160459.136744531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit 0ad134881508c36b65c1a8864f8bec53adbd3327 ]

In pdsc_remove(), the workqueue is destroyed before pdsc_teardown()
is called. This ordering allows two paths to queue work on the
destroyed workqueue:

1. If pdsc_teardown() -> pdsc_devcmd_reset() times out, the error
   path in pdsc_devcmd_locked() queues health_work.

2. A NotifyQ event can trigger the ISR and queue work before free_irq()
   is called in pdsc_teardown().

Fix by moving destroy_workqueue() after pdsc_teardown() so the
workqueue outlives every queuer; destroy_workqueue() then flushes any
work still pending.

Draining the queued work also requires ordering the teardown so the
resources that work touches are freed last:

  - In pdsc_qcq_free(), after freeing the interrupt, cancel_work_sync()
    the queue's work and only then clear qcq->intx, so
    pdsc_process_adminq()'s read of qcq->intx for interrupt-credit
    return cannot race with the clear.

  - Free adminqcq before notifyqcq: the shared adminq ISR is released
    when adminqcq is freed, and the adminq work accesses notifyqcq, so
    both must be stopped before notifyqcq is freed.

Fixes: 01ba61b55b20 ("pds_core: Add adminq processing and commands")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://patchwork.kernel.org/comment/27002369/
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Link: https://patch.msgid.link/20260714180223.1642792-3-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/core.c | 14 ++++++++++----
 drivers/net/ethernet/amd/pds_core/main.c |  5 +++--
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 89e27f8b90f74..15884b4c77c3f 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -110,7 +110,6 @@ static void pdsc_qcq_intr_free(struct pdsc *pdsc, struct pdsc_qcq *qcq)
 		return;
 
 	pdsc_intr_free(pdsc, qcq->intx);
-	qcq->intx = PDS_CORE_INTR_INDEX_NOT_ASSIGNED;
 }
 
 static int pdsc_qcq_intr_alloc(struct pdsc *pdsc, struct pdsc_qcq *qcq)
@@ -145,6 +144,12 @@ void pdsc_qcq_free(struct pdsc *pdsc, struct pdsc_qcq *qcq)
 
 	pdsc_qcq_intr_free(pdsc, qcq);
 
+	/* Drain any work queued by ISR before it was freed above */
+	if (qcq->work.func)
+		cancel_work_sync(&qcq->work);
+
+	qcq->intx = PDS_CORE_INTR_INDEX_NOT_ASSIGNED;
+
 	if (qcq->q_base)
 		dma_free_coherent(dev, qcq->q_size,
 				  qcq->q_base, qcq->q_base_pa);
@@ -307,8 +312,11 @@ int pdsc_qcq_alloc(struct pdsc *pdsc, unsigned int type, unsigned int index,
 
 static void pdsc_core_uninit(struct pdsc *pdsc)
 {
-	pdsc_qcq_free(pdsc, &pdsc->notifyqcq);
+	/* Free adminqcq first: its work accesses notifyqcq, so we must
+	 * disable its IRQ and drain its work before freeing notifyqcq.
+	 */
 	pdsc_qcq_free(pdsc, &pdsc->adminqcq);
+	pdsc_qcq_free(pdsc, &pdsc->notifyqcq);
 
 	if (pdsc->kern_dbpage) {
 		iounmap(pdsc->kern_dbpage);
@@ -474,8 +482,6 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 {
 	if (!pdsc->pdev->is_virtfn)
 		pdsc_devcmd_reset(pdsc);
-	if (pdsc->adminqcq.work.func)
-		cancel_work_sync(&pdsc->adminqcq.work);
 
 	pdsc_core_uninit(pdsc);
 
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index e88230ae6349d..a5075e11f03a7 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -432,8 +432,6 @@ static void pdsc_remove(struct pci_dev *pdev)
 		pdsc_sriov_configure(pdev, 0);
 
 		timer_shutdown_sync(&pdsc->wdtimer);
-		if (pdsc->wq)
-			destroy_workqueue(pdsc->wq);
 
 		mutex_lock(&pdsc->config_lock);
 		set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
@@ -441,6 +439,9 @@ static void pdsc_remove(struct pci_dev *pdev)
 		pdsc_stop(pdsc);
 		pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
 		mutex_unlock(&pdsc->config_lock);
+
+		if (pdsc->wq)
+			destroy_workqueue(pdsc->wq);
 		mutex_destroy(&pdsc->config_lock);
 		mutex_destroy(&pdsc->devcmd_lock);
 
-- 
2.53.0



