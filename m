Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F92E1A6815;
	Mon, 23 Mar 2026 13:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274255; cv=none; b=IRtaaDrp5bi4Ib5D1p4TiXVABqIIl9h/UVTJew8wWlAQGSSeXVSgE/I+CwoMxiFaXzsDIgjqrZqcwnj6VBN0qNgHrQh/r64gwvwpOZ78PNvzbNmbbucJSiInKLfSfKyfsKxvAPewlrHc/ZdgVaplo3OZQswvsPP3sVDEU4XPEMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274255; c=relaxed/simple;
	bh=GsRe/SJ3+PqFZQeGwc1UHr1gcvij8FRQ1CPx52/TCtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qX/8V/JV6yPIBlBpGSeaRGf7GJ/yA15FKHiUG9mdzD1b48iU+CDpRtn0RTudT7YoRenWttd7JXgcA+/zT2C2a7T2lsmN90b7gLg63/UkS629JlriNPzDp2553r7nBrlwPgwGbpinZ+vp4PMzJ0KemN9kgq8gLaEYEpVY5CXtuhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npt3BdMe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npt3BdMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4231C4CEF7;
	Mon, 23 Mar 2026 13:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274255;
	bh=GsRe/SJ3+PqFZQeGwc1UHr1gcvij8FRQ1CPx52/TCtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npt3BdMeRm3JHsH2CJQBe6rin0vkMJ0uWDT++KNoKgQzKc+yJbo6QDvhzy+nZxWTc
	 8Ce36vwUC0RF0otonLaXkUR1k1RusxvwLCJcMb93dTBt7/9jAEWOV7gzjUN2lzxgFz
	 n54n4WRF2nVg7hQaysxLnMD6mTaYmrXK/3f8wT+M=
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
Subject: [PATCH 6.19 158/220] igc: fix page fault in XDP TX timestamps handling
Date: Mon, 23 Mar 2026 14:45:35 +0100
Message-ID: <20260323134509.559837356@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index a427f05814c1a..17236813965d3 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -781,6 +781,8 @@ int igc_ptp_hwtstamp_set(struct net_device *netdev,
 			 struct kernel_hwtstamp_config *config,
 			 struct netlink_ext_ack *extack);
 void igc_ptp_tx_hang(struct igc_adapter *adapter);
+void igc_ptp_clear_xsk_tx_tstamp_queue(struct igc_adapter *adapter,
+				       u16 queue_id);
 void igc_ptp_read(struct igc_adapter *adapter, struct timespec64 *ts);
 void igc_ptp_tx_tstamp_event(struct igc_adapter *adapter);
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 6a174d46929e2..b1ca2079e5cf3 100644
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
index 44ee193867661..3d6b2264164af 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -577,6 +577,39 @@ static void igc_ptp_clear_tx_tstamp(struct igc_adapter *adapter)
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



