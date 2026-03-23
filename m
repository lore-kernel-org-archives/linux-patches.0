Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20023AC0D2;
	Mon, 23 Mar 2026 14:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277363; cv=none; b=IUZLtx6eZR5+zt3lPqC30we9wH4aF87OwyyCHJd7oJssxXVW9Pr82eJTSb17XRXSEkkyoBP3gpPDw6Y0xyT0oPeJCw8ArbFY3MbYeYer6qIpC68J73LklvndNMJ5QYQgJwUQpXGX1lzWHSqkUK+bxTru46z842mzcxoQxYBjf6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277363; c=relaxed/simple;
	bh=rUhLGxEESJizd8A+wiCDRSZC2BkHHoNa60MVN8GfrVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OakcWOcDTNJvLBgvTwJUvuK0iijmau/D36nARW/FcC8KAuZWh/+t5pImneeTPOZWt7/2kwRySbsaSn9I2couTheYT+mvyVuERKYZJstv4E9QQX29SgoP+s8pYwk8VMw+bAAtiqh9dwol5E825/Uc+BIZ7W9uk4OToqrn3rh0Es4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZb/wmUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZb/wmUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CCCC2BC9E;
	Mon, 23 Mar 2026 14:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277362;
	bh=rUhLGxEESJizd8A+wiCDRSZC2BkHHoNa60MVN8GfrVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZb/wmUHFIksrjeCgoGaC4frKOlGeJfeb65j3795MG556A5bgl/awh+zqNO+RzKWa
	 lyZulvV54kMRsdIwTtOt9WjPQzR0Vwjm/bMPzaiHtIe5Kz5tyq12kAPfbZSrfGv+YP
	 mk911MO/QGidBYURVZPu4TIkeV22XRyIH/FsGPjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 410/460] net: airoha: Read completion queue data in airoha_qdma_tx_napi_poll()
Date: Mon, 23 Mar 2026 14:46:46 +0100
Message-ID: <20260323134536.627997325@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 3affa310de523d63e52ea8e2efb3c476df29e414 ]

In order to avoid any possible race, read completion queue head and
pending entry in airoha_qdma_tx_napi_poll routine instead of doing it in
airoha_irq_handler. Remove unused airoha_tx_irq_queue unused fields.
This is a preliminary patch to add Qdisc offload for airoha_eth driver.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20241029-airoha-en7581-tx-napi-work-v1-1-96ad1686b946@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: d4a533ad249e ("net: airoha: Remove airoha_dev_stop() in airoha_remove()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/airoha_eth.c | 31 +++++++++-------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/airoha_eth.c b/drivers/net/ethernet/mediatek/airoha_eth.c
index cd2e888a8c52e..1dc051749603e 100644
--- a/drivers/net/ethernet/mediatek/airoha_eth.c
+++ b/drivers/net/ethernet/mediatek/airoha_eth.c
@@ -752,11 +752,9 @@ struct airoha_tx_irq_queue {
 	struct airoha_qdma *qdma;
 
 	struct napi_struct napi;
-	u32 *q;
 
 	int size;
-	int queued;
-	u16 head;
+	u32 *q;
 };
 
 struct airoha_hw_stats {
@@ -1655,25 +1653,31 @@ static int airoha_qdma_init_rx(struct airoha_qdma *qdma)
 static int airoha_qdma_tx_napi_poll(struct napi_struct *napi, int budget)
 {
 	struct airoha_tx_irq_queue *irq_q;
+	int id, done = 0, irq_queued;
 	struct airoha_qdma *qdma;
 	struct airoha_eth *eth;
-	int id, done = 0;
+	u32 status, head;
 
 	irq_q = container_of(napi, struct airoha_tx_irq_queue, napi);
 	qdma = irq_q->qdma;
 	id = irq_q - &qdma->q_tx_irq[0];
 	eth = qdma->eth;
 
-	while (irq_q->queued > 0 && done < budget) {
-		u32 qid, last, val = irq_q->q[irq_q->head];
+	status = airoha_qdma_rr(qdma, REG_IRQ_STATUS(id));
+	head = FIELD_GET(IRQ_HEAD_IDX_MASK, status);
+	head = head % irq_q->size;
+	irq_queued = FIELD_GET(IRQ_ENTRY_LEN_MASK, status);
+
+	while (irq_queued > 0 && done < budget) {
+		u32 qid, last, val = irq_q->q[head];
 		struct airoha_queue *q;
 
 		if (val == 0xff)
 			break;
 
-		irq_q->q[irq_q->head] = 0xff; /* mark as done */
-		irq_q->head = (irq_q->head + 1) % irq_q->size;
-		irq_q->queued--;
+		irq_q->q[head] = 0xff; /* mark as done */
+		head = (head + 1) % irq_q->size;
+		irq_queued--;
 		done++;
 
 		last = FIELD_GET(IRQ_DESC_IDX_MASK, val);
@@ -2023,20 +2027,11 @@ static irqreturn_t airoha_irq_handler(int irq, void *dev_instance)
 
 	if (intr[0] & INT_TX_MASK) {
 		for (i = 0; i < ARRAY_SIZE(qdma->q_tx_irq); i++) {
-			struct airoha_tx_irq_queue *irq_q = &qdma->q_tx_irq[i];
-			u32 status, head;
-
 			if (!(intr[0] & TX_DONE_INT_MASK(i)))
 				continue;
 
 			airoha_qdma_irq_disable(qdma, QDMA_INT_REG_IDX0,
 						TX_DONE_INT_MASK(i));
-
-			status = airoha_qdma_rr(qdma, REG_IRQ_STATUS(i));
-			head = FIELD_GET(IRQ_HEAD_IDX_MASK, status);
-			irq_q->head = head % irq_q->size;
-			irq_q->queued = FIELD_GET(IRQ_ENTRY_LEN_MASK, status);
-
 			napi_schedule(&qdma->q_tx_irq[i].napi);
 		}
 	}
-- 
2.51.0



