Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAF143C7D7;
	Thu, 30 Jul 2026 14:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422091; cv=none; b=FcyT8I4trcB3zfjoaOSqK8I05b/l/CX0DZghnNvgqv5YlUPJBOeGHmiSpShwqrhzMLdow+B18znUAClBC/KSn+FBTfYXHPqjbK0tXoetBzHmbabgdcHsVoW/TVSnanMNYCYYSKMOhEEvxH/o5P2FMd1G66Cl8RNWLcu+jUiZaOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422091; c=relaxed/simple;
	bh=yWQeO6mvBDTivl0FgXo2cHhf5fIU4RisOeWi8HpcYzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRnBlG8Kcimg1aylOeF0/iOfL8b3qAWPUwvrUKB3dqs5KL+eJ4lx8E4DC8BuMWZkokMD9jXI8CHb8M6Z2t/V3A54fn+uh+4JC8ucK/TU04yBe7xtPYeF5di1YD+diioN9LkMolP5Hhg/cwV8H/lpi7fXRWFBpvgBqay5RFyDVKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPQGaxQq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPQGaxQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5971F000E9;
	Thu, 30 Jul 2026 14:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422089;
	bh=7tYzxr4Yx4KEuxj8Eu0kALPWgqJmGZqqCgFHxsrd/0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xPQGaxQqroMJ4OJXeiZ8IYMToE02NjBvc+gbYJXbySS7RM2Cv5rf84h6HX3UFx6m7
	 emxRiIJ1Kekjzcx1QWXOnvhb05/KS5w0zat05l3l5OiVHHgq6J8Mxdrgbvh2uXRDiF
	 F1BRUndgbJ5mNNhv+APjfNjvYK0MPkjS+LgZL4Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 267/744] pds_core: fix use-after-free on workqueue during remove
Date: Thu, 30 Jul 2026 16:09:00 +0200
Message-ID: <20260730141449.969105432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index b6d4b30147232a..a73a2ab9060e62 100644
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
@@ -304,8 +309,11 @@ int pdsc_qcq_alloc(struct pdsc *pdsc, unsigned int type, unsigned int index,
 
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
@@ -477,8 +485,6 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 {
 	if (!pdsc->pdev->is_virtfn)
 		pdsc_devcmd_reset(pdsc);
-	if (pdsc->adminqcq.work.func)
-		cancel_work_sync(&pdsc->adminqcq.work);
 
 	pdsc_core_uninit(pdsc);
 
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 22db78343eb075..638b9c7a509d9d 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -435,8 +435,6 @@ static void pdsc_remove(struct pci_dev *pdev)
 		pdsc_auxbus_dev_del(pdsc, pdsc, &pdsc->padev);
 
 		timer_shutdown_sync(&pdsc->wdtimer);
-		if (pdsc->wq)
-			destroy_workqueue(pdsc->wq);
 
 		mutex_lock(&pdsc->config_lock);
 		set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
@@ -444,6 +442,9 @@ static void pdsc_remove(struct pci_dev *pdev)
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



