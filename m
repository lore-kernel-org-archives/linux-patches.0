Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61173B27C4;
	Mon, 23 Mar 2026 14:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277381; cv=none; b=TNA5J/KnhE9LPfXmNuGCwndGkUzjVEJqdpANhf7BJDq/dYb4dryHRQUprUuceFbIMX/9NlSRJ+4j2tj3WHWXQROk9wJUpi2svFoty6pt77B8xa9NRL/1ieDPkj+dmdoF1NHP1OAeckcFxqnNIQX90fG++d78oy/Buw1C8H4gvto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277381; c=relaxed/simple;
	bh=/aNVcp2IGGpOy/g16jy4JebEr9Grg5XN7OJHvkjuiEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmBaIRXWuroaCPwiTma1fjZLhFB3KCbBnbXxXTEpKI6QNDcAJa9f1HyILjfwwFTehAmm/LpBHa+AtD5NVWeBQLyPxL0PO74ORi65cGk9Kh8mhHjoG713TcL3ufpbwcbBOSUnyd1TxsgRn2CcbGiHOLR9uJKcqbg29a5twF39sl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FBKwk3qb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FBKwk3qb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827E3C2BCB3;
	Mon, 23 Mar 2026 14:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277380;
	bh=/aNVcp2IGGpOy/g16jy4JebEr9Grg5XN7OJHvkjuiEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FBKwk3qblVofA3HEVnHCeegf6a9Hy61DT6QD78jMxfddq8thLNrRqYVx/bZnBwWX2
	 FGRQSLe3UaBf7yVL8W0CUQyCwMQ9XRml4DO/ALz8vPBto6G7pp7dfPHr97iRQ6Gzo3
	 AQ4Wao+QE/VQtX+0xs1sVExqu5uqueiPSZrR7gsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zdenek Bouska <zdenek.bouska@siemens.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Florian Bezdeka <florian.bezdeka@siemens.com>,
	Avigail Dahan <avigailx.dahan@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 417/460] igc: fix page fault in XDP TX timestamps handling
Date: Mon, 23 Mar 2026 14:46:53 +0100
Message-ID: <20260323134536.795785636@linuxfoundation.org>
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

From: Zdenek Bouska <zdenek.bouska@siemens.com>

[ Upstream commit 45b33e805bd39f615d9353a7194b2da5281332df ]

If an XDP application that requested TX timestamping is shutting down
while the link of the interface in use is still up the following kernel
splat is reported:

[  883.803618] [   T1554] BUG: unable to handle page fault for address: ffffcfb6200fd008
...
[  883.803650] [   T1554] Call Trace:
[  883.803652] [   T1554]  <TASK>
[  883.803654] [   T1554]  igc_ptp_tx_tstamp_event+0xdf/0x160 [igc]
[  883.803660] [   T1554]  igc_tsync_interrupt+0x2d5/0x300 [igc]
...

During shutdown of the TX ring the xsk_meta pointers are left behind, so
that the IRQ handler is trying to touch them.

This issue is now being fixed by cleaning up the stale xsk meta data on
TX shutdown. TX timestamps on other queues remain unaffected.

Fixes: 15fd021bc427 ("igc: Add Tx hardware timestamp request for AF_XDP zero-copy packet")
Signed-off-by: Zdenek Bouska <zdenek.bouska@siemens.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Florian Bezdeka <florian.bezdeka@siemens.com>
Tested-by: Avigail Dahan <avigailx.dahan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc.h      |  2 ++
 drivers/net/ethernet/intel/igc/igc_main.c |  7 +++++
 drivers/net/ethernet/intel/igc/igc_ptp.c  | 33 +++++++++++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 79d5fc5ac4fce..24949a50037ef 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -745,6 +745,8 @@ ktime_t igc_ptp_rx_pktstamp(struct igc_adapter *adapter, __le32 *buf);
 int igc_ptp_set_ts_config(struct net_device *netdev, struct ifreq *ifr);
 int igc_ptp_get_ts_config(struct net_device *netdev, struct ifreq *ifr);
 void igc_ptp_tx_hang(struct igc_adapter *adapter);
+void igc_ptp_clear_xsk_tx_tstamp_queue(struct igc_adapter *adapter,
+				       u16 queue_id);
 void igc_ptp_read(struct igc_adapter *adapter, struct timespec64 *ts);
 void igc_ptp_tx_tstamp_event(struct igc_adapter *adapter);
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 65134be59754f..6fcf4fd7ee194 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -264,6 +264,13 @@ static void igc_clean_tx_ring(struct igc_ring *tx_ring)
 	/* reset next_to_use and next_to_clean */
 	tx_ring->next_to_use = 0;
 	tx_ring->next_to_clean = 0;
+
+	/* Clear any lingering XSK TX timestamp requests */
+	if (test_bit(IGC_RING_FLAG_TX_HWTSTAMP, &tx_ring->flags)) {
+		struct igc_adapter *adapter = netdev_priv(tx_ring->netdev);
+
+		igc_ptp_clear_xsk_tx_tstamp_queue(adapter, tx_ring->queue_index);
+	}
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index a272d1a29eadb..9ff73e7532e5e 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -587,6 +587,39 @@ static void igc_ptp_clear_tx_tstamp(struct igc_adapter *adapter)
 	spin_unlock_irqrestore(&adapter->ptp_tx_lock, flags);
 }
 
+/**
+ * igc_ptp_clear_xsk_tx_tstamp_queue - Clear pending XSK TX timestamps for a queue
+ * @adapter: Board private structure
+ * @queue_id: TX queue index to clear timestamps for
+ *
+ * Iterates over all TX timestamp registers and releases any pending
+ * timestamp requests associated with the given TX queue. This is
+ * called when an XDP pool is being disabled to ensure no stale
+ * timestamp references remain.
+ */
+void igc_ptp_clear_xsk_tx_tstamp_queue(struct igc_adapter *adapter, u16 queue_id)
+{
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&adapter->ptp_tx_lock, flags);
+
+	for (i = 0; i < IGC_MAX_TX_TSTAMP_REGS; i++) {
+		struct igc_tx_timestamp_request *tstamp = &adapter->tx_tstamp[i];
+
+		if (tstamp->buffer_type != IGC_TX_BUFFER_TYPE_XSK)
+			continue;
+		if (tstamp->xsk_queue_index != queue_id)
+			continue;
+		if (!tstamp->xsk_tx_buffer)
+			continue;
+
+		igc_ptp_free_tx_buffer(adapter, tstamp);
+	}
+
+	spin_unlock_irqrestore(&adapter->ptp_tx_lock, flags);
+}
+
 static void igc_ptp_disable_tx_timestamp(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
-- 
2.51.0



