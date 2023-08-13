Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4C49443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8430EC433C8;
	Sun, 13 Aug 2023 21:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962218;
	bh=py3RpE0xWlnQDT4+UP6dOLqOV3EggT299KmZ7QDqmxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pc3m7URwoAi41RjPOiE9FDVrdt0TBTxGwW4jh9CqNhHjL4e1YneL7PSsaQ0j03OFj
	 nYaRp59FTjzJdWHN7zcRHdWLNd8gFslxqmkZ7OjnGtInqIUa1ENPCcIDaZGM/wuHdT
	 e1m9/cZ3xtkmJ2I/PxQmxNFsvCv+ssM0YE3+c6Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leon@kernel.org>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.4 128/206] igc: Add lock to safeguard global Qbv variables
Date: Sun, 13 Aug 2023 23:18:18 +0200
Message-ID: <20230813211728.689298890@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

commit 06b412589eef780b792e73df131d35dc43cc4a49 upstream.

Access to shared variables through hrtimer requires locking in order
to protect the variables because actions to write into these variables
(oper_gate_closed, admin_gate_closed, and qbv_transition) might potentially
occur simultaneously. This patch provides a locking mechanisms to avoid
such scenarios.

Fixes: 175c241288c0 ("igc: Fix TX Hang issue when QBV Gate is closed")
Suggested-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20230807205129.3129346-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igc/igc.h      |    4 +++
 drivers/net/ethernet/intel/igc/igc_main.c |   34 ++++++++++++++++++++++++++++--
 2 files changed, 36 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -195,6 +195,10 @@ struct igc_adapter {
 	u32 qbv_config_change_errors;
 	bool qbv_transition;
 	unsigned int qbv_count;
+	/* Access to oper_gate_closed, admin_gate_closed and qbv_transition
+	 * are protected by the qbv_tx_lock.
+	 */
+	spinlock_t qbv_tx_lock;
 
 	/* OS defined structs */
 	struct pci_dev *pdev;
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4799,6 +4799,7 @@ static int igc_sw_init(struct igc_adapte
 	adapter->nfc_rule_count = 0;
 
 	spin_lock_init(&adapter->stats64_lock);
+	spin_lock_init(&adapter->qbv_tx_lock);
 	/* Assume MSI-X interrupts, will be checked during IRQ allocation */
 	adapter->flags |= IGC_FLAG_HAS_MSIX;
 
@@ -6117,15 +6118,15 @@ static int igc_tsn_enable_launchtime(str
 	return igc_tsn_offload_apply(adapter);
 }
 
-static int igc_tsn_clear_schedule(struct igc_adapter *adapter)
+static int igc_qbv_clear_schedule(struct igc_adapter *adapter)
 {
+	unsigned long flags;
 	int i;
 
 	adapter->base_time = 0;
 	adapter->cycle_time = NSEC_PER_SEC;
 	adapter->taprio_offload_enable = false;
 	adapter->qbv_config_change_errors = 0;
-	adapter->qbv_transition = false;
 	adapter->qbv_count = 0;
 
 	for (i = 0; i < adapter->num_tx_queues; i++) {
@@ -6134,10 +6135,28 @@ static int igc_tsn_clear_schedule(struct
 		ring->start_time = 0;
 		ring->end_time = NSEC_PER_SEC;
 		ring->max_sdu = 0;
+	}
+
+	spin_lock_irqsave(&adapter->qbv_tx_lock, flags);
+
+	adapter->qbv_transition = false;
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct igc_ring *ring = adapter->tx_ring[i];
+
 		ring->oper_gate_closed = false;
 		ring->admin_gate_closed = false;
 	}
 
+	spin_unlock_irqrestore(&adapter->qbv_tx_lock, flags);
+
+	return 0;
+}
+
+static int igc_tsn_clear_schedule(struct igc_adapter *adapter)
+{
+	igc_qbv_clear_schedule(adapter);
+
 	return 0;
 }
 
@@ -6148,6 +6167,7 @@ static int igc_save_qbv_schedule(struct
 	struct igc_hw *hw = &adapter->hw;
 	u32 start_time = 0, end_time = 0;
 	struct timespec64 now;
+	unsigned long flags;
 	size_t n;
 	int i;
 
@@ -6215,6 +6235,8 @@ static int igc_save_qbv_schedule(struct
 		start_time += e->interval;
 	}
 
+	spin_lock_irqsave(&adapter->qbv_tx_lock, flags);
+
 	/* Check whether a queue gets configured.
 	 * If not, set the start and end time to be end time.
 	 */
@@ -6239,6 +6261,8 @@ static int igc_save_qbv_schedule(struct
 		}
 	}
 
+	spin_unlock_irqrestore(&adapter->qbv_tx_lock, flags);
+
 	for (i = 0; i < adapter->num_tx_queues; i++) {
 		struct igc_ring *ring = adapter->tx_ring[i];
 		struct net_device *dev = adapter->netdev;
@@ -6603,8 +6627,11 @@ static enum hrtimer_restart igc_qbv_sche
 {
 	struct igc_adapter *adapter = container_of(timer, struct igc_adapter,
 						   hrtimer);
+	unsigned long flags;
 	unsigned int i;
 
+	spin_lock_irqsave(&adapter->qbv_tx_lock, flags);
+
 	adapter->qbv_transition = true;
 	for (i = 0; i < adapter->num_tx_queues; i++) {
 		struct igc_ring *tx_ring = adapter->tx_ring[i];
@@ -6617,6 +6644,9 @@ static enum hrtimer_restart igc_qbv_sche
 		}
 	}
 	adapter->qbv_transition = false;
+
+	spin_unlock_irqrestore(&adapter->qbv_tx_lock, flags);
+
 	return HRTIMER_NORESTART;
 }
 


