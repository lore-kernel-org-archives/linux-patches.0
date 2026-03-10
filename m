Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95DB37B413;
	Tue, 10 Mar 2026 11:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142164; cv=none; b=LeD79BipGSMVJqT5OrAlG7vYxLz3jkE+KmhKncZFCivMrX2gxOU6jxrpCe5yEchSJ6905HSx9q5Q+LobsHLEiThIZoiPIzZ12To0wxcVxf0xmi12yosfq0foWdmFabblzAWSiZEHtyGlw4tawjwQrbt3tZc5GOZ7qdX2JYqG+9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142164; c=relaxed/simple;
	bh=tdiWZyGv/5PKeixwhrT1iLcnhhIgczkse6q/DXQVE/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxRq2eH5R52rppHPsBOeCIwCs20t2RmOON7lJlt18wTrXRlMHaVSAtz/ic2rU4+mGQubpwP828NCTeqx6h5KBN1LfMcYJEuIjB6tAX+ASbXJbh8mttCaBBlB7vdioegG33HOGhSuk+BUQgSy+1EboUVlOljUaWZ7P5p/8eV07NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nfS+otcg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nfS+otcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC01C2BC9E;
	Tue, 10 Mar 2026 11:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142164;
	bh=tdiWZyGv/5PKeixwhrT1iLcnhhIgczkse6q/DXQVE/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nfS+otcgmaL/n22svrYOAxPVqOevg8SIk5OimXJMlvBkn0/3aw9OfGEXBD62gM11N
	 LWeV4+n0yYIF6f4t+S5SlR+1JEMrlnFzVM8pmohyi6dCFJ2Ij5bKxHYGhhT1yeJoEO
	 JZqtfHSpy1xaMmhzAmSAWqqVXdrOIaOhkzX1NlX2vzVYn9r3ODZmvQ93ARpzZDIZI/
	 I45XAAhaEISkOo0pq09XvDPK/94n9UfhsFMQ3Cins+14/dTX79lNgp22JK4e3mrZu5
	 4H02b/VHDw2Pa0b35HJG1QzW6c2RHeoGRLJs7qgM2PfL8Bu3bw5CGuHyjUNTA4YHM/
	 UBNn5vR8uuloQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vimlesh Kumar <vimleshk@marvell.com>,
	Sathesh Edara <sedara@marvell.com>,
	Shinas Rasheed <srasheed@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 252/314] octeon_ep_vf: avoid compiler and IQ/OQ reordering
Date: Tue, 10 Mar 2026 07:18:31 -0400
Message-ID: <a6d5fdd5268999980bcb31383d730284d8830589.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vimlesh Kumar <vimleshk@marvell.com>

[ Upstream commit 6c73126ecd1080351b468fe43353b2f705487f44 ]

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

Fixes: 1cd3b407977c3 ("octeon_ep_vf: add Tx/Rx processing and interrupt support")
Signed-off-by: Sathesh Edara <sedara@marvell.com>
Signed-off-by: Shinas Rasheed <srasheed@marvell.com>
Signed-off-by: Vimlesh Kumar <vimleshk@marvell.com>
Link: https://patch.msgid.link/20260227091402.1773833-5-vimleshk@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeon_ep_vf/octep_vf_main.c      | 21 ++++++++------
 .../marvell/octeon_ep_vf/octep_vf_rx.c        | 28 +++++++++++++------
 2 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
index 17efc8eab4cfb..a3c359124887e 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
@@ -294,17 +294,22 @@ static void octep_vf_clean_irqs(struct octep_vf_device *oct)
 
 static void octep_vf_update_pkt(struct octep_vf_iq *iq, struct octep_vf_oq *oq)
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
diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.c
index 6f865dbbba6c6..b579d5b545c46 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.c
@@ -325,9 +325,16 @@ static int octep_vf_oq_check_hw_for_pkts(struct octep_vf_device *oct,
 					 struct octep_vf_oq *oq)
 {
 	u32 pkt_count, new_pkts;
+	u32 last_pkt_count, pkts_pending;
 
 	pkt_count = readl(oq->pkts_sent_reg);
-	new_pkts = pkt_count - oq->last_pkt_count;
+	last_pkt_count = READ_ONCE(oq->last_pkt_count);
+	new_pkts = pkt_count - last_pkt_count;
+
+	if (pkt_count < last_pkt_count) {
+		dev_err(oq->dev, "OQ-%u pkt_count(%u) < oq->last_pkt_count(%u)\n",
+			oq->q_no, pkt_count, last_pkt_count);
+	}
 
 	/* Clear the hardware packets counter register if the rx queue is
 	 * being processed continuously with-in a single interrupt and
@@ -339,8 +346,9 @@ static int octep_vf_oq_check_hw_for_pkts(struct octep_vf_device *oct,
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
 
@@ -369,7 +377,7 @@ static int __octep_vf_oq_process_rx(struct octep_vf_device *oct,
 	struct sk_buff *skb;
 	u32 read_idx;
 
-	read_idx = oq->host_read_idx;
+	read_idx = READ_ONCE(oq->host_read_idx);
 	rx_bytes = 0;
 	desc_used = 0;
 	for (pkt = 0; pkt < pkts_to_process; pkt++) {
@@ -463,7 +471,7 @@ static int __octep_vf_oq_process_rx(struct octep_vf_device *oct,
 		napi_gro_receive(oq->napi, skb);
 	}
 
-	oq->host_read_idx = read_idx;
+	WRITE_ONCE(oq->host_read_idx, read_idx);
 	oq->refill_count += desc_used;
 	oq->stats->packets += pkt;
 	oq->stats->bytes += rx_bytes;
@@ -486,22 +494,26 @@ int octep_vf_oq_process_rx(struct octep_vf_oq *oq, int budget)
 {
 	u32 pkts_available, pkts_processed, total_pkts_processed;
 	struct octep_vf_device *oct = oq->octep_vf_dev;
+	u32 pkts_pending;
 
 	pkts_available = 0;
 	pkts_processed = 0;
 	total_pkts_processed = 0;
 	while (total_pkts_processed < budget) {
 		 /* update pending count only when current one exhausted */
-		if (oq->pkts_pending == 0)
+		pkts_pending = READ_ONCE(oq->pkts_pending);
+		if (pkts_pending == 0)
 			octep_vf_oq_check_hw_for_pkts(oct, oq);
+		pkts_pending = READ_ONCE(oq->pkts_pending);
 		pkts_available = min(budget - total_pkts_processed,
-				     oq->pkts_pending);
+				     pkts_pending);
 		if (!pkts_available)
 			break;
 
 		pkts_processed = __octep_vf_oq_process_rx(oct, oq,
 							  pkts_available);
-		oq->pkts_pending -= pkts_processed;
+		pkts_pending = READ_ONCE(oq->pkts_pending);
+		WRITE_ONCE(oq->pkts_pending, (pkts_pending - pkts_processed));
 		total_pkts_processed += pkts_processed;
 	}
 
-- 
2.51.0

