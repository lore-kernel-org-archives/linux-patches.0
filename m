Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F35938910E;
	Tue, 10 Mar 2026 11:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142176; cv=none; b=uUFcgLrIkcIHoF4wATmB+KJb3Wvb6LvSJZeMex4zbx5yI+gEpQyftR8cDxWjbGYjK9FSxi1BI7qMsm/rFSiX/RNNG046GzjF7Kt9f0jEX/ovLIhZuOcOTE2INsuZXQniRY4oEB59LSx81DJC0gkVVPNfUN8xn9VVguX954Wuq/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142176; c=relaxed/simple;
	bh=64S2yWuK24xY6fH+j5RONgS8TV1Jk+Jm4CVdAbLPUeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFVfuK9uysj3fK59j/LJhb+I+nmkOHYfLs9U7gbJ1b81YSHbxl5vQPbFNupO+Np873hEMFlbcePVH81vQbwUikO+DWGDd3btwsNYUV2C5vSdmbN1A0I4CvReIEl7J4YiG+z5daws7LoPDpUiRhpdDsHueLQrLLtvtGoI9MosBvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GN2pBKTV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GN2pBKTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37334C2BC9E;
	Tue, 10 Mar 2026 11:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142176;
	bh=64S2yWuK24xY6fH+j5RONgS8TV1Jk+Jm4CVdAbLPUeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GN2pBKTVyZK0YiCL6e4b+WUgNL9njOtT9ECUoZzOSCIFiYllbNMs0CmZO2+H8tvy2
	 nNj/azdL0kQ0+ztAe1tbkex+TwFyab17TgqNmJZ1IJmgHQjezRoz8FYdHnrdXo9Ueq
	 jQJ+Dpe9os9XSIV1f8IrTN5xb/NibCEEwm/BYbVUF24RPLA9648POgDWkbD0QoehKp
	 4Bv3k2QP/BTac8GInscO5seu31yuCEczT4jXc5MK6WMwWzXYo0os5MNIdQuq/f/I0O
	 1SPk/AOOvPiZaIlCjz0hLXFO05vpZlhm8eNEzADFez+eSCBKWTvPNZLfJk9QEECe9a
	 GVMuR7jjkyh5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vivek Behera <vivek.behera@siemens.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Saritha Sanigani <sarithax.sanigani@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 264/314] igb: Fix trigger of incorrect irq in igb_xsk_wakeup
Date: Tue, 10 Mar 2026 07:18:43 -0400
Message-ID: <78cd77df1851479183a4e9130bd8425c23e770c1.1773141555.git.sashal@kernel.org>
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

From: Vivek Behera <vivek.behera@siemens.com>

[ Upstream commit d4c13ab36273a8c318ba06799793cc1f5d9c6fa1 ]

The current implementation in the igb_xsk_wakeup expects
the Rx and Tx queues to share the same irq. This would lead
to triggering of incorrect irq in split irq configuration.
This patch addresses this issue which could impact environments
with 2 active cpu cores
or when the number of queues is reduced to 2 or less

cat /proc/interrupts | grep eno2
 167:          0          0          0          0 IR-PCI-MSIX-0000:08:00.0
 0-edge      eno2
 168:          0          0          0          0 IR-PCI-MSIX-0000:08:00.0
 1-edge      eno2-rx-0
 169:          0          0          0          0 IR-PCI-MSIX-0000:08:00.0
 2-edge      eno2-rx-1
 170:          0          0          0          0 IR-PCI-MSIX-0000:08:00.0
 3-edge      eno2-tx-0
 171:          0          0          0          0 IR-PCI-MSIX-0000:08:00.0
 4-edge      eno2-tx-1

Furthermore it uses the flags input argument to trigger either rx, tx or
both rx and tx irqs as specified in the ndo_xsk_wakeup api documentation

Fixes: 80f6ccf9f116 ("igb: Introduce XSK data structures and helpers")
Signed-off-by: Vivek Behera <vivek.behera@siemens.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Saritha Sanigani <sarithax.sanigani@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_xsk.c | 38 +++++++++++++++++++-----
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_xsk.c b/drivers/net/ethernet/intel/igb/igb_xsk.c
index 30ce5fbb5b776..ce4a7b58cad2f 100644
--- a/drivers/net/ethernet/intel/igb/igb_xsk.c
+++ b/drivers/net/ethernet/intel/igb/igb_xsk.c
@@ -524,6 +524,16 @@ bool igb_xmit_zc(struct igb_ring *tx_ring, struct xsk_buff_pool *xsk_pool)
 	return nb_pkts < budget;
 }
 
+static u32 igb_sw_irq_prep(struct igb_q_vector *q_vector)
+{
+	u32 eics = 0;
+
+	if (!napi_if_scheduled_mark_missed(&q_vector->napi))
+		eics = q_vector->eims_value;
+
+	return eics;
+}
+
 int igb_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 {
 	struct igb_adapter *adapter = netdev_priv(dev);
@@ -542,20 +552,32 @@ int igb_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 
 	ring = adapter->tx_ring[qid];
 
-	if (test_bit(IGB_RING_FLAG_TX_DISABLED, &ring->flags))
-		return -ENETDOWN;
-
 	if (!READ_ONCE(ring->xsk_pool))
 		return -EINVAL;
 
-	if (!napi_if_scheduled_mark_missed(&ring->q_vector->napi)) {
+	if (flags & XDP_WAKEUP_TX) {
+		if (test_bit(IGB_RING_FLAG_TX_DISABLED, &ring->flags))
+			return -ENETDOWN;
+
+		eics |= igb_sw_irq_prep(ring->q_vector);
+	}
+
+	if (flags & XDP_WAKEUP_RX) {
+		/* If IGB_FLAG_QUEUE_PAIRS is active, the q_vector
+		 * and NAPI is shared between RX and TX.
+		 * If NAPI is already running it would be marked as missed
+		 * from the TX path, making this RX call a NOP
+		 */
+		ring = adapter->rx_ring[qid];
+		eics |= igb_sw_irq_prep(ring->q_vector);
+	}
+
+	if (eics) {
 		/* Cause software interrupt */
-		if (adapter->flags & IGB_FLAG_HAS_MSIX) {
-			eics |= ring->q_vector->eims_value;
+		if (adapter->flags & IGB_FLAG_HAS_MSIX)
 			wr32(E1000_EICS, eics);
-		} else {
+		else
 			wr32(E1000_ICS, E1000_ICS_RXDMT0);
-		}
 	}
 
 	return 0;
-- 
2.51.0

