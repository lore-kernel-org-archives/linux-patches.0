Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC416FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA28C433D2;
	Tue, 10 Jan 2023 18:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374698;
	bh=np/z6Hcu+kNrdIwrDtheshYRt665T1vknYylBDuvKww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TaERSmMURv5mOf94YavXgoAZIsR7GpEzL4UfeH6ICGtxv0UkqP4/h/cEXivAvx3Wq
	 El1Ey/wSNsePsV+v0EP2TQYJhjlrHznMm9s8rWI+Ku7GgUrrlrrHRdcp+WlNtoFojb
	 mfhf8OArUn+vbuurGBqFcMofZW41ZaSQiFsVBgNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arinzon <darinzon@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/159] net: ena: Update NUMA TPH hint register upon NUMA node update
Date: Tue, 10 Jan 2023 19:03:41 +0100
Message-Id: <20230110180020.636048462@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Arinzon <darinzon@amazon.com>

[ Upstream commit a8ee104f986e720cea52133885cc822d459398c7 ]

The device supports a PCIe optimization hint, which indicates on
which NUMA the queue is currently processed. This hint is utilized
by PCIe in order to reduce its access time by accessing the
correct NUMA resources and maintaining cache coherence.

The driver calls the register update for the hint (called TPH -
TLP Processing Hint) during the NAPI loop.

Though the update is expected upon a NUMA change (when a queue
is moved from one NUMA to the other), the current logic performs
a register update when the queue is moved to a different CPU,
but the CPU is not necessarily in a different NUMA.

The changes include:
1. Performing the TPH update only when the queue has switched
a NUMA node.
2. Moving the TPH update call to be triggered only when NAPI was
scheduled from interrupt context, as opposed to a busy-polling loop.
This is due to the fact that during busy-polling, the frequency
of CPU switches for a particular queue is significantly higher,
thus, the likelihood to switch NUMA is much higher. Therefore,
providing the frequent updates to the device upon a NUMA update
are unlikely to be beneficial.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: David Arinzon <darinzon@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 27 +++++++++++++-------
 drivers/net/ethernet/amazon/ena/ena_netdev.h |  6 +++--
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index c4aff712b5d8..5ce01ac72637 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -680,6 +680,7 @@ static void ena_init_io_rings_common(struct ena_adapter *adapter,
 	ring->ena_dev = adapter->ena_dev;
 	ring->per_napi_packets = 0;
 	ring->cpu = 0;
+	ring->numa_node = 0;
 	ring->no_interrupt_event_cnt = 0;
 	u64_stats_init(&ring->syncp);
 }
@@ -783,6 +784,7 @@ static int ena_setup_tx_resources(struct ena_adapter *adapter, int qid)
 	tx_ring->next_to_use = 0;
 	tx_ring->next_to_clean = 0;
 	tx_ring->cpu = ena_irq->cpu;
+	tx_ring->numa_node = node;
 	return 0;
 
 err_push_buf_intermediate_buf:
@@ -915,6 +917,7 @@ static int ena_setup_rx_resources(struct ena_adapter *adapter,
 	rx_ring->next_to_clean = 0;
 	rx_ring->next_to_use = 0;
 	rx_ring->cpu = ena_irq->cpu;
+	rx_ring->numa_node = node;
 
 	return 0;
 }
@@ -1863,20 +1866,27 @@ static void ena_update_ring_numa_node(struct ena_ring *tx_ring,
 	if (likely(tx_ring->cpu == cpu))
 		goto out;
 
+	tx_ring->cpu = cpu;
+	if (rx_ring)
+		rx_ring->cpu = cpu;
+
 	numa_node = cpu_to_node(cpu);
+
+	if (likely(tx_ring->numa_node == numa_node))
+		goto out;
+
 	put_cpu();
 
 	if (numa_node != NUMA_NO_NODE) {
 		ena_com_update_numa_node(tx_ring->ena_com_io_cq, numa_node);
-		if (rx_ring)
+		tx_ring->numa_node = numa_node;
+		if (rx_ring) {
+			rx_ring->numa_node = numa_node;
 			ena_com_update_numa_node(rx_ring->ena_com_io_cq,
 						 numa_node);
+		}
 	}
 
-	tx_ring->cpu = cpu;
-	if (rx_ring)
-		rx_ring->cpu = cpu;
-
 	return;
 out:
 	put_cpu();
@@ -1997,11 +2007,10 @@ static int ena_io_poll(struct napi_struct *napi, int budget)
 			if (ena_com_get_adaptive_moderation_enabled(rx_ring->ena_dev))
 				ena_adjust_adaptive_rx_intr_moderation(ena_napi);
 
+			ena_update_ring_numa_node(tx_ring, rx_ring);
 			ena_unmask_interrupt(tx_ring, rx_ring);
 		}
 
-		ena_update_ring_numa_node(tx_ring, rx_ring);
-
 		ret = rx_work_done;
 	} else {
 		ret = budget;
@@ -2386,7 +2395,7 @@ static int ena_create_io_tx_queue(struct ena_adapter *adapter, int qid)
 	ctx.mem_queue_type = ena_dev->tx_mem_queue_type;
 	ctx.msix_vector = msix_vector;
 	ctx.queue_size = tx_ring->ring_size;
-	ctx.numa_node = cpu_to_node(tx_ring->cpu);
+	ctx.numa_node = tx_ring->numa_node;
 
 	rc = ena_com_create_io_queue(ena_dev, &ctx);
 	if (rc) {
@@ -2454,7 +2463,7 @@ static int ena_create_io_rx_queue(struct ena_adapter *adapter, int qid)
 	ctx.mem_queue_type = ENA_ADMIN_PLACEMENT_POLICY_HOST;
 	ctx.msix_vector = msix_vector;
 	ctx.queue_size = rx_ring->ring_size;
-	ctx.numa_node = cpu_to_node(rx_ring->cpu);
+	ctx.numa_node = rx_ring->numa_node;
 
 	rc = ena_com_create_io_queue(ena_dev, &ctx);
 	if (rc) {
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index f9d862b630fa..2cb141079474 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -262,9 +262,11 @@ struct ena_ring {
 	bool disable_meta_caching;
 	u16 no_interrupt_event_cnt;
 
-	/* cpu for TPH */
+	/* cpu and NUMA for TPH */
 	int cpu;
-	 /* number of tx/rx_buffer_info's entries */
+	int numa_node;
+
+	/* number of tx/rx_buffer_info's entries */
 	int ring_size;
 
 	enum ena_admin_placement_policy_type tx_mem_queue_type;
-- 
2.35.1



