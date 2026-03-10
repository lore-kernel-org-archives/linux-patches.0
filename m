Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B50F37B413;
	Tue, 10 Mar 2026 11:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142162; cv=none; b=laYlPwA6Kn/Q5u5ETSYc4sDL/4FOGdbMyi8TbX3qRj6ZowocFa1+j0ecw6VQdFwF6rskEgAPLW/r4Kj75uo2bLSoawqaUryaKLj4BVLgRtVj8kSzvcmxCD5L4cSFIu2uFAIHDBgE4keJ9eJtC95tCu0VYAqpqMIcZigRtZ4kirA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142162; c=relaxed/simple;
	bh=mk10/7xLiwqTE/254pk/IoXlm8tj8qVX7CHQqIz7VfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYgg9wUQvSp95WYSfLgTeqdG9iQEYZRlQw0nhzs6ibqAjK/IMH6L6HQIXZfA5e7uP2yp6ZrY189ie2vD/tjtZaO4qSuRZRtC8xpMRZykW2idc2PBM9oJHrxNTAYn1Ffg4sX/5C+OH1LA+t/8rFJiP2oWeuiZ1DZmwTStYJpfG2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j/YbpRUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/YbpRUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB078C2BC86;
	Tue, 10 Mar 2026 11:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142162;
	bh=mk10/7xLiwqTE/254pk/IoXlm8tj8qVX7CHQqIz7VfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/YbpRUpt/pxQ4S9ICYQOaM5m8KdqRuvHYw8wcy6xoeTW+Zf8kRlXViZT7KrcB75l
	 0H8qyDflHa1wvIPRmjFrVenSNklZtkXh0riVhb3Rrr2ngQkYuhimAK+PVPjW1Ops1M
	 ukUA1NJWjNE672Qn3t3mqJjvHNvOdudI/dLgzRqIxxpGWAKHIdeB2mqpevr4qEQGDB
	 yqj8gDtK3Os1CSfQAZoaChCJJzcGdPFMEktzMkJ71uiCj8kWsy0j7FTI2GPePSmVWj
	 pCTKUFSNURDxwpC79T6ENgw6vf5fn951FFAo1KJRQ2c+TAinsoQN1A28DPYfONXw7e
	 wVuud5M60D5pA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vimlesh Kumar <vimleshk@marvell.com>,
	Sathesh Edara <sedara@marvell.com>,
	Shinas Rasheed <srasheed@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 250/314] octeon_ep: avoid compiler and IQ/OQ reordering
Date: Tue, 10 Mar 2026 07:18:29 -0400
Message-ID: <1b693bfd17e4f586d018f99210512604949e47f9.1773141555.git.sashal@kernel.org>
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
index 7f8ed8f0ade49..16f52d4b11e91 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -562,17 +562,22 @@ static void octep_clean_irqs(struct octep_device *oct)
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
index f2a7c6a76c742..74de19166488f 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
@@ -324,10 +324,16 @@ static int octep_oq_check_hw_for_pkts(struct octep_device *oct,
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
@@ -338,8 +344,9 @@ static int octep_oq_check_hw_for_pkts(struct octep_device *oct,
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
 
@@ -414,7 +421,7 @@ static int __octep_oq_process_rx(struct octep_device *oct,
 	u16 rx_ol_flags;
 	u32 read_idx;
 
-	read_idx = oq->host_read_idx;
+	read_idx = READ_ONCE(oq->host_read_idx);
 	rx_bytes = 0;
 	desc_used = 0;
 	for (pkt = 0; pkt < pkts_to_process; pkt++) {
@@ -499,7 +506,7 @@ static int __octep_oq_process_rx(struct octep_device *oct,
 		napi_gro_receive(oq->napi, skb);
 	}
 
-	oq->host_read_idx = read_idx;
+	WRITE_ONCE(oq->host_read_idx, read_idx);
 	oq->refill_count += desc_used;
 	oq->stats->packets += pkt;
 	oq->stats->bytes += rx_bytes;
@@ -522,22 +529,26 @@ int octep_oq_process_rx(struct octep_oq *oq, int budget)
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

