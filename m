Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72BD1A701;
	Sat,  3 Feb 2024 04:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933701; cv=none; b=p/MT0CGM2P+jtv6HEhiPno+amMqOTkS2jznLHE5at2N+J5lFeA6QhSFS5VO6ctVr4qMQ27vmmBIFwoCLJyVV1Xb5MxtTCw/Ts0dEVU15gqQ4Z+eCLG1Y7w/epdle4ZLPVDHeTWoWvCrVAJ8T5nIIVs5M3Sztq/SbXPipT7vrW9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933701; c=relaxed/simple;
	bh=ITv+jCklGQoRJfW9LWkd93/8HB4LF1eeL9YOa+lE4Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUMdmbOiCuIdD1Mk8hieBN1jS7X97gPxpxy/7QgqNMJx6NIBHoiPC+VMbCDOxTbwIBcma2A1dpLFENneeRrxgNjk0nvnORXhNDyljpND6Cyw3QcDGnSTZvfvqScY1LCeOzeruYYiULL0fnwX4+/FzpOC8JRKygNs2bA+GRGyUvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCtHPlKh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCtHPlKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAB2C433F1;
	Sat,  3 Feb 2024 04:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933700;
	bh=ITv+jCklGQoRJfW9LWkd93/8HB4LF1eeL9YOa+lE4Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCtHPlKhb6udMGcCZyJnEG3xpM6Dn7jFd+mjItrKkL7kXGTmzIU679Ydl1VqLJsKo
	 2KxR2gZoFdIAdTxHH6F4U3l5jAAjWFqb8nVLXYd0uiMKzV92T+IEFUA1NcEw1T2+Ph
	 UK7POMsf+JibbAxUHYLEfMxr2cltaMcpM94qs81A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 301/322] pds_core: Use struct pdsc for the pdsc_adminq_isr private data
Date: Fri,  2 Feb 2024 20:06:38 -0800
Message-ID: <20240203035408.785330520@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit 951705151e50f9022bc96ec8b3fd5697380b1df6 ]

The initial design for the adminq interrupt was done based
on client drivers having their own adminq and adminq
interrupt. So, each client driver's adminq isr would use
their specific adminqcq for the private data struct. For the
time being the design has changed to only use a single
adminq for all clients. So, instead use the struct pdsc for
the private data to simplify things a bit.

This also has the benefit of not dereferencing the adminqcq
to access the pdsc struct when the PDSC_S_STOPPING_DRIVER bit
is set and the adminqcq has actually been cleared/freed.

Fixes: 01ba61b55b20 ("pds_core: Add adminq processing and commands")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://lore.kernel.org/r/20240129234035.69802-4-brett.creeley@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/adminq.c | 5 +++--
 drivers/net/ethernet/amd/pds_core/core.c   | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/adminq.c b/drivers/net/ethernet/amd/pds_core/adminq.c
index 5beadabc2136..68be5ea251fc 100644
--- a/drivers/net/ethernet/amd/pds_core/adminq.c
+++ b/drivers/net/ethernet/amd/pds_core/adminq.c
@@ -135,8 +135,8 @@ void pdsc_work_thread(struct work_struct *work)
 
 irqreturn_t pdsc_adminq_isr(int irq, void *data)
 {
-	struct pdsc_qcq *qcq = data;
-	struct pdsc *pdsc = qcq->pdsc;
+	struct pdsc *pdsc = data;
+	struct pdsc_qcq *qcq;
 
 	/* Don't process AdminQ when shutting down */
 	if (pdsc->state & BIT_ULL(PDSC_S_STOPPING_DRIVER)) {
@@ -145,6 +145,7 @@ irqreturn_t pdsc_adminq_isr(int irq, void *data)
 		return IRQ_HANDLED;
 	}
 
+	qcq = &pdsc->adminqcq;
 	queue_work(pdsc->wq, &qcq->work);
 	pds_core_intr_mask(&pdsc->intr_ctrl[qcq->intx], PDS_CORE_INTR_MASK_CLEAR);
 
diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index b58c166d438d..dfb43ed60e27 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -125,7 +125,7 @@ static int pdsc_qcq_intr_alloc(struct pdsc *pdsc, struct pdsc_qcq *qcq)
 
 	snprintf(name, sizeof(name), "%s-%d-%s",
 		 PDS_CORE_DRV_NAME, pdsc->pdev->bus->number, qcq->q.name);
-	index = pdsc_intr_alloc(pdsc, name, pdsc_adminq_isr, qcq);
+	index = pdsc_intr_alloc(pdsc, name, pdsc_adminq_isr, pdsc);
 	if (index < 0)
 		return index;
 	qcq->intx = index;
-- 
2.43.0



