Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72721389108;
	Tue, 10 Mar 2026 11:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141250; cv=none; b=YCOvs7tA5qKT/gdlHG88RarBmjEbea8RPz8cRuB0if1kFX6+gYdw35adlN+C1nQmjZEk2XG0xVj4jOhFoFlIy+iw4eXWP9mz+ut06HVPu+GzsWf0CHSOOCPEyIdAJ/S3tdfy6FebolslhndtfphsINP2JDiWXZdz7rQOU/oifNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141250; c=relaxed/simple;
	bh=LGpY6E/Jg8hEm+jNgLd5q5OcUzYMXnhvxsoniDfkmJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSPSQqhCmP9x49rhos/4ZEdEIDIpSBWte0LVhy/BETDlc0Jtg2h0BeSG9M2F0GFidbW7/tfuC2ko4xZyZzrVhyc7mI99Islb3OkkdFV/U+QENy3no8F5ajVemP2l0wAF6f1zhAQ5tHLs2P2pMK8bwEZu/5BU9dcwyvGbFjQyuiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mfu3+9nZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mfu3+9nZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578F5C19423;
	Tue, 10 Mar 2026 11:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141250;
	bh=LGpY6E/Jg8hEm+jNgLd5q5OcUzYMXnhvxsoniDfkmJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mfu3+9nZIzWw7Ee9K9RhDaxAiyy0nHqS1LCspl5rCAPrM22/drdSnUOZ/w6jGagtN
	 cx7y0AV4aD35x4IHTbVuvEU/VHGsI5/UHVk9r1DgX4VHpbxvPtzLXty+S+Cmex4A4W
	 wIyYI4IS0GrFYvAhZn8fvZs96taWRxwqTWgnIbAiH964exk9F6Z8Aa+ITCas6er20t
	 rsPfZ8SfXFferKXFEjZLNHAkRigWXH4mDPTBU9WjXY2YQ2dt+Hi0eMDub09TlmTSYK
	 Zbydv+ISwrjAAuVSo7VSYDrIJnIPcvQ9pG3vzlsvTXwiy6CecAZzwXwXtijQ9a86cb
	 X3eQw7uN7WsfA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vivek Behera <vivek.behera@siemens.com>,
	Jacob Keller <jacob.keller@intel.com>,
	Aleksandr loktinov <aleksandr.loktionov@intel.com>,
	Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
	Song Yoong Siang <yoong.siang.song@intel.com>,
	Avigail Dahan <avigailx.dahan@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 252/311] igc: Fix trigger of incorrect irq in igc_xsk_wakeup function
Date: Tue, 10 Mar 2026 07:04:59 -0400
Message-ID: <c3ab57c54c2405116e4eeb98de1d3cdb7f7246ee.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vivek Behera <vivek.behera@siemens.com>

[ Upstream commit 554a1c34c11a057d01819ce9bb04653a8ffc8071 ]

This patch addresses the issue where the igc_xsk_wakeup function
was triggering an incorrect IRQ for tx-0 when the i226 is configured
with only 2 combined queues or in an environment with 2 active CPU cores.
This prevented XDP Zero-copy send functionality in such split IRQ
configurations.

The fix implements the correct logic for extracting q_vectors saved
during rx and tx ring allocation and utilizes flags provided by the
ndo_xsk_wakeup API to trigger the appropriate IRQ.

Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
Fixes: 15fd021bc427 ("igc: Add Tx hardware timestamp request for AF_XDP zero-copy packet")
Signed-off-by: Vivek Behera <vivek.behera@siemens.com>
Reviewed-by: Jacob Keller <jacob.keller@intel.com>
Reviewed-by: Aleksandr loktinov <aleksandr.loktionov@intel.com>
Reviewed-by: Piotr Kwapulinski <piotr.kwapulinski@intel.com>
Reviewed-by: Song Yoong Siang <yoong.siang.song@intel.com>
Tested-by: Avigail Dahan <avigailx.dahan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 34 ++++++++++++++++-------
 drivers/net/ethernet/intel/igc/igc_ptp.c  |  3 +-
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 89a321a344d26..4439eeb378c1f 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6908,28 +6908,29 @@ static int igc_xdp_xmit(struct net_device *dev, int num_frames,
 	return nxmit;
 }
 
-static void igc_trigger_rxtxq_interrupt(struct igc_adapter *adapter,
-					struct igc_q_vector *q_vector)
+static u32 igc_sw_irq_prep(struct igc_q_vector *q_vector)
 {
-	struct igc_hw *hw = &adapter->hw;
 	u32 eics = 0;
 
-	eics |= q_vector->eims_value;
-	wr32(IGC_EICS, eics);
+	if (!napi_if_scheduled_mark_missed(&q_vector->napi))
+		eics = q_vector->eims_value;
+
+	return eics;
 }
 
 int igc_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
 {
 	struct igc_adapter *adapter = netdev_priv(dev);
-	struct igc_q_vector *q_vector;
+	struct igc_hw *hw = &adapter->hw;
 	struct igc_ring *ring;
+	u32 eics = 0;
 
 	if (test_bit(__IGC_DOWN, &adapter->state))
 		return -ENETDOWN;
 
 	if (!igc_xdp_is_enabled(adapter))
 		return -ENXIO;
-
+	/* Check if queue_id is valid. Tx and Rx queue numbers are always same */
 	if (queue_id >= adapter->num_rx_queues)
 		return -EINVAL;
 
@@ -6938,9 +6939,22 @@ int igc_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
 	if (!ring->xsk_pool)
 		return -ENXIO;
 
-	q_vector = adapter->q_vector[queue_id];
-	if (!napi_if_scheduled_mark_missed(&q_vector->napi))
-		igc_trigger_rxtxq_interrupt(adapter, q_vector);
+	if (flags & XDP_WAKEUP_RX)
+		eics |= igc_sw_irq_prep(ring->q_vector);
+
+	if (flags & XDP_WAKEUP_TX) {
+		/* If IGC_FLAG_QUEUE_PAIRS is active, the q_vector
+		 * and NAPI is shared between RX and TX.
+		 * If NAPI is already running it would be marked as missed
+		 * from the RX path, making this TX call a NOP
+		 */
+		ring = adapter->tx_ring[queue_id];
+		eics |= igc_sw_irq_prep(ring->q_vector);
+	}
+
+	if (eics)
+		/* Cause software interrupt */
+		wr32(IGC_EICS, eics);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 7aae83c108fd7..44ee193867661 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -550,7 +550,8 @@ static void igc_ptp_free_tx_buffer(struct igc_adapter *adapter,
 		tstamp->buffer_type = 0;
 
 		/* Trigger txrx interrupt for transmit completion */
-		igc_xsk_wakeup(adapter->netdev, tstamp->xsk_queue_index, 0);
+		igc_xsk_wakeup(adapter->netdev, tstamp->xsk_queue_index,
+			       XDP_WAKEUP_TX);
 
 		return;
 	}
-- 
2.51.0

