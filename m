Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1EB1DA0E1;
	Mon, 23 Mar 2026 14:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277936; cv=none; b=LDi94101gOb2t7gu33btbOJ+5CIbFBmkrfVQ6PNKxmbrM5qTCm2COr5TpVCEs1iPDaVRvRzyX5vLEMjliTD4wU3u7hfuN0Cj+UHD6K560P69nzVCODUpX1h9G7mlbecgqC47zI9ExWo3cmR1u3TVXY5vtQ+a9r8LPKMgZ/eleyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277936; c=relaxed/simple;
	bh=EpfWRMLp9EHqlLg+wIIdfkPW/ClfQsgEenrFFNVKyMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJ4tF6ITk4RU740cSXU9rrT8N1HbXdKEd3O4L57hZYrw+fl949qOpO9eB54kxBajN2sSEL7ax3dYDC2rMdANlD9qu9EQU5ra08EPgOxxVN8Eox9lO1STwM+dvmZXCD5wrUcqv4TobsuwDGZ7XF3vSb3/H23Xr9B8lt9wkhZHbqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qx8oO2vD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qx8oO2vD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B15C2BCB4;
	Mon, 23 Mar 2026 14:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277936;
	bh=EpfWRMLp9EHqlLg+wIIdfkPW/ClfQsgEenrFFNVKyMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qx8oO2vD1Zk8GNEsHU5mEum6FM4CAnv5GfkpOx+D90aD3Xmu2KoYG8aZVB1hB3hQy
	 3uyFICW6MpGqVSIpAyRNMPq6ScMDLnkGsBYDE1ongZXsp5bUot7UUczBl3tbf2o2Q+
	 80AgtEHNk44mcf8l79MERLsWjMqvA4ShhZ3IE8ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathesh Edara <sedara@marvell.com>,
	Shinas Rasheed <srasheed@marvell.com>,
	Vimlesh Kumar <vimleshk@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 150/567] octeon_ep: avoid compiler and IQ/OQ reordering
Date: Mon, 23 Mar 2026 14:41:10 +0100
Message-ID: <20260323134537.543097171@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Vimlesh Kumar <vimleshk@marvell.com>

[ Upstream commit 43b3160cb639079a15daeb5f080120afbfbfc918 ]

Utilize READ_ONCE and WRITE_ONCE APIs for IO queue Tx/Rx
variable access to prevent compiler optimization and reordering.
Additionally, ensure IO queue OUT/IN_CNT registers are flushed
by performing a read-back after writing.

The compiler could reorder reads/writes to pkts_pending, last_pkt_count,
etc., causing stale values to be used when calculating packets to process
or register updates to send to hardware. The Octeon hardware requires a
read-back after writing to OUT_CNT/IN_CNT registers to ensure the write
has been flushed through any posted write buffers before the interrupt
resend bit is set. Without this, we have observed cases where the hardware
didn't properly update its internal state.

wmb/rmb only provides ordering guarantees but doesn't prevent the compiler
from performing optimizations like caching in registers, load tearing etc.

Fixes: 37d79d0596062 ("octeon_ep: add Tx/Rx processing and interrupt support")
Signed-off-by: Sathesh Edara <sedara@marvell.com>
Signed-off-by: Shinas Rasheed <srasheed@marvell.com>
Signed-off-by: Vimlesh Kumar <vimleshk@marvell.com>
Link: https://patch.msgid.link/20260227091402.1773833-3-vimleshk@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeon_ep/octep_main.c   | 21 +++++++++------
 .../net/ethernet/marvell/octeon_ep/octep_rx.c | 27 +++++++++++++------
 2 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 111caa5ce12fa..e4a78d5e73495 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -541,17 +541,22 @@ static void octep_clean_irqs(struct octep_device *oct)
  */
 static void octep_update_pkt(struct octep_iq *iq, struct octep_oq *oq)
 {
-	u32 pkts_pend = oq->pkts_pending;
+	u32 pkts_pend = READ_ONCE(oq->pkts_pending);
+	u32 last_pkt_count = READ_ONCE(oq->last_pkt_count);
+	u32 pkts_processed = READ_ONCE(iq->pkts_processed);
+	u32 pkt_in_done = READ_ONCE(iq->pkt_in_done);
 
 	netdev_dbg(iq->netdev, "enabling intr for Q-%u\n", iq->q_no);
-	if (iq->pkts_processed) {
-		writel(iq->pkts_processed, iq->inst_cnt_reg);
-		iq->pkt_in_done -= iq->pkts_processed;
-		iq->pkts_processed = 0;
+	if (pkts_processed) {
+		writel(pkts_processed, iq->inst_cnt_reg);
+		readl(iq->inst_cnt_reg);
+		WRITE_ONCE(iq->pkt_in_done, (pkt_in_done - pkts_processed));
+		WRITE_ONCE(iq->pkts_processed, 0);
 	}
-	if (oq->last_pkt_count - pkts_pend) {
-		writel(oq->last_pkt_count - pkts_pend, oq->pkts_sent_reg);
-		oq->last_pkt_count = pkts_pend;
+	if (last_pkt_count - pkts_pend) {
+		writel(last_pkt_count - pkts_pend, oq->pkts_sent_reg);
+		readl(oq->pkts_sent_reg);
+		WRITE_ONCE(oq->last_pkt_count, pkts_pend);
 	}
 
 	/* Flush the previous wrties before writing to RESEND bit */
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
index 60afb6bf2f679..e0c1e13e48c02 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
@@ -323,10 +323,16 @@ static int octep_oq_check_hw_for_pkts(struct octep_device *oct,
 				      struct octep_oq *oq)
 {
 	u32 pkt_count, new_pkts;
+	u32 last_pkt_count, pkts_pending;
 
 	pkt_count = readl(oq->pkts_sent_reg);
-	new_pkts = pkt_count - oq->last_pkt_count;
+	last_pkt_count = READ_ONCE(oq->last_pkt_count);
+	new_pkts = pkt_count - last_pkt_count;
 
+	if (pkt_count < last_pkt_count) {
+		dev_err(oq->dev, "OQ-%u pkt_count(%u) < oq->last_pkt_count(%u)\n",
+			oq->q_no, pkt_count, last_pkt_count);
+	}
 	/* Clear the hardware packets counter register if the rx queue is
 	 * being processed continuously with-in a single interrupt and
 	 * reached half its max value.
@@ -337,8 +343,9 @@ static int octep_oq_check_hw_for_pkts(struct octep_device *oct,
 		pkt_count = readl(oq->pkts_sent_reg);
 		new_pkts += pkt_count;
 	}
-	oq->last_pkt_count = pkt_count;
-	oq->pkts_pending += new_pkts;
+	WRITE_ONCE(oq->last_pkt_count, pkt_count);
+	pkts_pending = READ_ONCE(oq->pkts_pending);
+	WRITE_ONCE(oq->pkts_pending, (pkts_pending + new_pkts));
 	return new_pkts;
 }
 
@@ -411,7 +418,7 @@ static int __octep_oq_process_rx(struct octep_device *oct,
 	u16 data_offset;
 	u32 read_idx;
 
-	read_idx = oq->host_read_idx;
+	read_idx = READ_ONCE(oq->host_read_idx);
 	rx_bytes = 0;
 	desc_used = 0;
 	for (pkt = 0; pkt < pkts_to_process; pkt++) {
@@ -494,7 +501,7 @@ static int __octep_oq_process_rx(struct octep_device *oct,
 		napi_gro_receive(oq->napi, skb);
 	}
 
-	oq->host_read_idx = read_idx;
+	WRITE_ONCE(oq->host_read_idx, read_idx);
 	oq->refill_count += desc_used;
 	oq->stats.packets += pkt;
 	oq->stats.bytes += rx_bytes;
@@ -517,22 +524,26 @@ int octep_oq_process_rx(struct octep_oq *oq, int budget)
 {
 	u32 pkts_available, pkts_processed, total_pkts_processed;
 	struct octep_device *oct = oq->octep_dev;
+	u32 pkts_pending;
 
 	pkts_available = 0;
 	pkts_processed = 0;
 	total_pkts_processed = 0;
 	while (total_pkts_processed < budget) {
 		 /* update pending count only when current one exhausted */
-		if (oq->pkts_pending == 0)
+		pkts_pending = READ_ONCE(oq->pkts_pending);
+		if (pkts_pending == 0)
 			octep_oq_check_hw_for_pkts(oct, oq);
+		pkts_pending = READ_ONCE(oq->pkts_pending);
 		pkts_available = min(budget - total_pkts_processed,
-				     oq->pkts_pending);
+				     pkts_pending);
 		if (!pkts_available)
 			break;
 
 		pkts_processed = __octep_oq_process_rx(oct, oq,
 						       pkts_available);
-		oq->pkts_pending -= pkts_processed;
+		pkts_pending = READ_ONCE(oq->pkts_pending);
+		WRITE_ONCE(oq->pkts_pending, (pkts_pending - pkts_processed));
 		total_pkts_processed += pkts_processed;
 	}
 
-- 
2.51.0



