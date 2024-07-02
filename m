Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42582178381;
	Tue,  2 Jul 2024 17:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940107; cv=none; b=eHEDiHAVIzMRgr7VP80zUDJv8T7lyIQ27t4sQqlt64mkkJDGl0i+uv+f7jDhM27XEM5di5KbZcyyBny8htjaAAkvL/+JK25zle1F5WYs8jD1vJlDGsnsC23pQB2SxzhbNehzNK7g/flCg9K60WclEiTW0zsjWbxCteGoXOhtmLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940107; c=relaxed/simple;
	bh=dqXDU3Q05IB2wnN+59rZMlXW1iu6j4g+zff+2gHCnUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYM6y+dtK/LWui6E7vmNZ7toU6zabfJs+hMJfJ3cBsnv+/oMtoSadM7dE+ESgvuJ/CwSpCxJKIeHt7MeIYV1Lu5g7Il3Ttd4Skx8Gpk1LoOUfBaY6fZ3mwawUoUWMgZOkNDYTkAqerG6UsvlwayrdYsKgV85fk47boBLdukh5LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WoKViOm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WoKViOm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A42C116B1;
	Tue,  2 Jul 2024 17:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940106;
	bh=dqXDU3Q05IB2wnN+59rZMlXW1iu6j4g+zff+2gHCnUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoKViOm7bZyI5h2s1xdMUI+9GoxbkzGwuNjBKdou7E/W/K9VeNh2a05Lnzr8DvLQ1
	 +ipg6VzGjjjxbo4lJNjKM6xdXPHyajqqMIdVHjvy2fXERKfA/RZtLggUaEeeSZ/4C/
	 HA9kX3p3T/sp0AC+kJ+W5LnVDEckUi20o7PCpx1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 055/222] ionic: use dev_consume_skb_any outside of napi
Date: Tue,  2 Jul 2024 19:01:33 +0200
Message-ID: <20240702170246.087758145@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 84b767f9e34fdb143c09e66a2a20722fc2921821 ]

If we're not in a NAPI softirq context, we need to be careful
about how we call napi_consume_skb(), specifically we need to
call it with budget==0 to signal to it that we're not in a
safe context.

This was found while running some configuration stress testing
of traffic and a change queue config loop running, and this
curious note popped out:

[ 4371.402645] BUG: using smp_processor_id() in preemptible [00000000] code: ethtool/20545
[ 4371.402897] caller is napi_skb_cache_put+0x16/0x80
[ 4371.403120] CPU: 25 PID: 20545 Comm: ethtool Kdump: loaded Tainted: G           OE      6.10.0-rc3-netnext+ #8
[ 4371.403302] Hardware name: HPE ProLiant DL360 Gen10/ProLiant DL360 Gen10, BIOS U32 01/23/2021
[ 4371.403460] Call Trace:
[ 4371.403613]  <TASK>
[ 4371.403758]  dump_stack_lvl+0x4f/0x70
[ 4371.403904]  check_preemption_disabled+0xc1/0xe0
[ 4371.404051]  napi_skb_cache_put+0x16/0x80
[ 4371.404199]  ionic_tx_clean+0x18a/0x240 [ionic]
[ 4371.404354]  ionic_tx_cq_service+0xc4/0x200 [ionic]
[ 4371.404505]  ionic_tx_flush+0x15/0x70 [ionic]
[ 4371.404653]  ? ionic_lif_qcq_deinit.isra.23+0x5b/0x70 [ionic]
[ 4371.404805]  ionic_txrx_deinit+0x71/0x190 [ionic]
[ 4371.404956]  ionic_reconfigure_queues+0x5f5/0xff0 [ionic]
[ 4371.405111]  ionic_set_ringparam+0x2e8/0x3e0 [ionic]
[ 4371.405265]  ethnl_set_rings+0x1f1/0x300
[ 4371.405418]  ethnl_default_set_doit+0xbb/0x160
[ 4371.405571]  genl_family_rcv_msg_doit+0xff/0x130
	[...]

I found that ionic_tx_clean() calls napi_consume_skb() which calls
napi_skb_cache_put(), but before that last call is the note
    /* Zero budget indicate non-NAPI context called us, like netpoll */
and
    DEBUG_NET_WARN_ON_ONCE(!in_softirq());

Those are pretty big hints that we're doing it wrong.  We can pass a
context hint down through the calls to let ionic_tx_clean() know what
we're doing so it can call napi_consume_skb() correctly.

Fixes: 386e69865311 ("ionic: Make use napi_consume_skb")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Link: https://patch.msgid.link/20240624175015.4520-1-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  4 ++-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  2 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 28 +++++++++++--------
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index f30eee4a5a80e..b6c01a88098dc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -375,7 +375,9 @@ typedef void (*ionic_cq_done_cb)(void *done_arg);
 unsigned int ionic_cq_service(struct ionic_cq *cq, unsigned int work_to_do,
 			      ionic_cq_cb cb, ionic_cq_done_cb done_cb,
 			      void *done_arg);
-unsigned int ionic_tx_cq_service(struct ionic_cq *cq, unsigned int work_to_do);
+unsigned int ionic_tx_cq_service(struct ionic_cq *cq,
+				 unsigned int work_to_do,
+				 bool in_napi);
 
 int ionic_q_init(struct ionic_lif *lif, struct ionic_dev *idev,
 		 struct ionic_queue *q, unsigned int index, const char *name,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 0cd819bc4ae35..1dec4ebd708f2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1189,7 +1189,7 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 					   ionic_rx_service, NULL, NULL);
 
 	if (lif->hwstamp_txq)
-		tx_work = ionic_tx_cq_service(&lif->hwstamp_txq->cq, budget);
+		tx_work = ionic_tx_cq_service(&lif->hwstamp_txq->cq, budget, !!budget);
 
 	work_done = max(max(n_work, a_work), max(rx_work, tx_work));
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index aed7d9cbce038..9fdd7cd3ef19d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -23,7 +23,8 @@ static void ionic_tx_desc_unmap_bufs(struct ionic_queue *q,
 
 static void ionic_tx_clean(struct ionic_queue *q,
 			   struct ionic_tx_desc_info *desc_info,
-			   struct ionic_txq_comp *comp);
+			   struct ionic_txq_comp *comp,
+			   bool in_napi);
 
 static inline void ionic_txq_post(struct ionic_queue *q, bool ring_dbell)
 {
@@ -944,7 +945,7 @@ int ionic_tx_napi(struct napi_struct *napi, int budget)
 	u32 work_done = 0;
 	u32 flags = 0;
 
-	work_done = ionic_tx_cq_service(cq, budget);
+	work_done = ionic_tx_cq_service(cq, budget, !!budget);
 
 	if (unlikely(!budget))
 		return budget;
@@ -1028,7 +1029,7 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 	txqcq = lif->txqcqs[qi];
 	txcq = &lif->txqcqs[qi]->cq;
 
-	tx_work_done = ionic_tx_cq_service(txcq, IONIC_TX_BUDGET_DEFAULT);
+	tx_work_done = ionic_tx_cq_service(txcq, IONIC_TX_BUDGET_DEFAULT, !!budget);
 
 	if (unlikely(!budget))
 		return budget;
@@ -1161,7 +1162,8 @@ static void ionic_tx_desc_unmap_bufs(struct ionic_queue *q,
 
 static void ionic_tx_clean(struct ionic_queue *q,
 			   struct ionic_tx_desc_info *desc_info,
-			   struct ionic_txq_comp *comp)
+			   struct ionic_txq_comp *comp,
+			   bool in_napi)
 {
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
 	struct ionic_qcq *qcq = q_to_qcq(q);
@@ -1213,11 +1215,13 @@ static void ionic_tx_clean(struct ionic_queue *q,
 	desc_info->bytes = skb->len;
 	stats->clean++;
 
-	napi_consume_skb(skb, 1);
+	napi_consume_skb(skb, likely(in_napi) ? 1 : 0);
 }
 
 static bool ionic_tx_service(struct ionic_cq *cq,
-			     unsigned int *total_pkts, unsigned int *total_bytes)
+			     unsigned int *total_pkts,
+			     unsigned int *total_bytes,
+			     bool in_napi)
 {
 	struct ionic_tx_desc_info *desc_info;
 	struct ionic_queue *q = cq->bound_q;
@@ -1239,7 +1243,7 @@ static bool ionic_tx_service(struct ionic_cq *cq,
 		desc_info->bytes = 0;
 		index = q->tail_idx;
 		q->tail_idx = (q->tail_idx + 1) & (q->num_descs - 1);
-		ionic_tx_clean(q, desc_info, comp);
+		ionic_tx_clean(q, desc_info, comp, in_napi);
 		if (desc_info->skb) {
 			pkts++;
 			bytes += desc_info->bytes;
@@ -1253,7 +1257,9 @@ static bool ionic_tx_service(struct ionic_cq *cq,
 	return true;
 }
 
-unsigned int ionic_tx_cq_service(struct ionic_cq *cq, unsigned int work_to_do)
+unsigned int ionic_tx_cq_service(struct ionic_cq *cq,
+				 unsigned int work_to_do,
+				 bool in_napi)
 {
 	unsigned int work_done = 0;
 	unsigned int bytes = 0;
@@ -1262,7 +1268,7 @@ unsigned int ionic_tx_cq_service(struct ionic_cq *cq, unsigned int work_to_do)
 	if (work_to_do == 0)
 		return 0;
 
-	while (ionic_tx_service(cq, &pkts, &bytes)) {
+	while (ionic_tx_service(cq, &pkts, &bytes, in_napi)) {
 		if (cq->tail_idx == cq->num_descs - 1)
 			cq->done_color = !cq->done_color;
 		cq->tail_idx = (cq->tail_idx + 1) & (cq->num_descs - 1);
@@ -1288,7 +1294,7 @@ void ionic_tx_flush(struct ionic_cq *cq)
 {
 	u32 work_done;
 
-	work_done = ionic_tx_cq_service(cq, cq->num_descs);
+	work_done = ionic_tx_cq_service(cq, cq->num_descs, false);
 	if (work_done)
 		ionic_intr_credits(cq->idev->intr_ctrl, cq->bound_intr->index,
 				   work_done, IONIC_INTR_CRED_RESET_COALESCE);
@@ -1305,7 +1311,7 @@ void ionic_tx_empty(struct ionic_queue *q)
 		desc_info = &q->tx_info[q->tail_idx];
 		desc_info->bytes = 0;
 		q->tail_idx = (q->tail_idx + 1) & (q->num_descs - 1);
-		ionic_tx_clean(q, desc_info, NULL);
+		ionic_tx_clean(q, desc_info, NULL, false);
 		if (desc_info->skb) {
 			pkts++;
 			bytes += desc_info->bytes;
-- 
2.43.0



