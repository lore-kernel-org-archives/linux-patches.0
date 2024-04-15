Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED7A84FB7;
	Mon, 15 Apr 2024 14:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191420; cv=none; b=NijHVuyefzPKaUpnEpxWw1AfYsCIUzXwdPyoE1YiQxZ0+qQuVoqjRu7XpJPoswxdhs8cMaRYgpPtGOry2yt/q8q/tDvIKbm2YPy3ZSmPA0fSFeA/capEEXxrzfGVxHraWhgiVknD8o2SvJwNZRPqh8H/UZ5ULfjFg5Zjcx7bqws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191420; c=relaxed/simple;
	bh=UFjW0flBCnfPcWS1hBfpSHP+UUpV0d+ZQezKwqCesQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHsxnnTqb2rFJPQwgwaEhRA67Dn81B1zlXgtULvqKejvHOr1ildKdIY7TyoQIiyjZnfvMonT0J4bq7ZpgcTHRSfDKHlmBffuU7vsWjcNP7UNwwi7fqUf1N21KOieIhjOqCe8nrAwMZvLW/H5ZLwrDpkL1g0J8svfDCy+6nGE99U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VyGdTM+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VyGdTM+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145EFC113CC;
	Mon, 15 Apr 2024 14:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191420;
	bh=UFjW0flBCnfPcWS1hBfpSHP+UUpV0d+ZQezKwqCesQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VyGdTM+2Utef5nETy3KmBktCoXIFOh3o/WQZdiXJyeerzB4H8OvE/OhDAXE7KPdsh
	 /oyIu7UAF2EvDybVrIcNtI9e8Nkpake41RyFjVcHIeUQAcY8JzS1MsAH4L6hw/kZhj
	 m2D38nJeq2GEgcv1UNsQeuehKXN6wqz20h6rsecc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Bernstein <amitbern@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 097/172] net: ena: Wrong missing IO completions check order
Date: Mon, 15 Apr 2024 16:19:56 +0200
Message-ID: <20240415142003.342387716@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Arinzon <darinzon@amazon.com>

[ Upstream commit f7e417180665234fdb7af2ebe33d89aaa434d16f ]

Missing IO completions check is called every second (HZ jiffies).
This commit fixes several issues with this check:

1. Duplicate queues check:
   Max of 4 queues are scanned on each check due to monitor budget.
   Once reaching the budget, this check exits under the assumption that
   the next check will continue to scan the remainder of the queues,
   but in practice, next check will first scan the last already scanned
   queue which is not necessary and may cause the full queue scan to
   last a couple of seconds longer.
   The fix is to start every check with the next queue to scan.
   For example, on 8 IO queues:
   Bug: [0,1,2,3], [3,4,5,6], [6,7]
   Fix: [0,1,2,3], [4,5,6,7]

2. Unbalanced queues check:
   In case the number of active IO queues is not a multiple of budget,
   there will be checks which don't utilize the full budget
   because the full scan exits when reaching the last queue id.
   The fix is to run every TX completion check with exact queue budget
   regardless of the queue id.
   For example, on 7 IO queues:
   Bug: [0,1,2,3], [4,5,6], [0,1,2,3]
   Fix: [0,1,2,3], [4,5,6,0], [1,2,3,4]
   The budget may be lowered in case the number of IO queues is less
   than the budget (4) to make sure there are no duplicate queues on
   the same check.
   For example, on 3 IO queues:
   Bug: [0,1,2,0], [1,2,0,1]
   Fix: [0,1,2], [0,1,2]

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Amit Bernstein <amitbern@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 21 +++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 5482015411f2f..1835581cd7230 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3421,10 +3421,11 @@ static void check_for_missing_completions(struct ena_adapter *adapter)
 {
 	struct ena_ring *tx_ring;
 	struct ena_ring *rx_ring;
-	int i, budget, rc;
+	int qid, budget, rc;
 	int io_queue_count;
 
 	io_queue_count = adapter->xdp_num_queues + adapter->num_io_queues;
+
 	/* Make sure the driver doesn't turn the device in other process */
 	smp_rmb();
 
@@ -3437,27 +3438,29 @@ static void check_for_missing_completions(struct ena_adapter *adapter)
 	if (adapter->missing_tx_completion_to == ENA_HW_HINTS_NO_TIMEOUT)
 		return;
 
-	budget = ENA_MONITORED_TX_QUEUES;
+	budget = min_t(u32, io_queue_count, ENA_MONITORED_TX_QUEUES);
 
-	for (i = adapter->last_monitored_tx_qid; i < io_queue_count; i++) {
-		tx_ring = &adapter->tx_ring[i];
-		rx_ring = &adapter->rx_ring[i];
+	qid = adapter->last_monitored_tx_qid;
+
+	while (budget) {
+		qid = (qid + 1) % io_queue_count;
+
+		tx_ring = &adapter->tx_ring[qid];
+		rx_ring = &adapter->rx_ring[qid];
 
 		rc = check_missing_comp_in_tx_queue(adapter, tx_ring);
 		if (unlikely(rc))
 			return;
 
-		rc =  !ENA_IS_XDP_INDEX(adapter, i) ?
+		rc =  !ENA_IS_XDP_INDEX(adapter, qid) ?
 			check_for_rx_interrupt_queue(adapter, rx_ring) : 0;
 		if (unlikely(rc))
 			return;
 
 		budget--;
-		if (!budget)
-			break;
 	}
 
-	adapter->last_monitored_tx_qid = i % io_queue_count;
+	adapter->last_monitored_tx_qid = qid;
 }
 
 /* trigger napi schedule after 2 consecutive detections */
-- 
2.43.0



