Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DC14EE85E;
	Tue, 13 Oct 2026 12:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893395; cv=none; b=NDshOLWO73/IutcD0ZZBRFXGE+dV2BlD7F5J390suCyrJ8Nvv0KqxEV2LSirdKj5PMyr8BGRrtGDiEVg6D/AhVPb32yPBHxfFu14+6BZMy5MDYiHASH1uIXTJ563qhEog7/F1o7zLaQSxEtry78WuH+FqbPajUjVnMEKgGDQ28o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893395; c=relaxed/simple;
	bh=v5rT4+K1QsL5yGatxs/tnOO/E6QvMCz636JhRWICbjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNukl7HEKbRbe067ugm+eK1MINEG4UtnzabH8iJcx5jfVMijjdRGNYRrIFsVkbEHc8S8sD1YshNaN6V+PCJTA21A7vRMNuitow53asdtf//+19RxqOSfm7/Y/Er7ZYjK0EyPywTaMGhEIK40KPdGsCOAotHA0Z7gMoz+q9QN/7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=po+5gBeK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="po+5gBeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B191F000FF;
	Tue, 13 Oct 2026 12:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893393;
	bh=TvOi7bNr8jjYSJuUpaCuEZ0ZILPfk1d8gbVb29mGrYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=po+5gBeKY7djeyfKNgfAiftget9FOnuFTx49Hvm2cl1+3SC0J6y6AZyrnL2YOISK0
	 29hVS8cB3NmWJ5zbkG8jpgmzrj8KYrsgjRgxS1VM3rqxS9exOyQb1SbERE0H/uvXDm
	 losiypNlUbGQ7fnUdmoXUXQxSV5G3a8cpC0T0SO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keita Morisaki <kmta1236@gmail.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Rinitha S <sx.rinitha@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 212/621] ice: fix race condition in TX timestamp ring cleanup
Date: Tue, 13 Oct 2026 13:33:27 +0200
Message-ID: <20261013112925.892179741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keita Morisaki <kmta1236@gmail.com>

[ Upstream commit 7c72ec18c2a4111204c2e915f8e4f6d849ce9398 ]

Fix a race condition between ice_free_tx_tstamp_ring() and ice_tx_map()
that can cause a NULL pointer dereference.

ice_free_tx_tstamp_ring currently clears the ICE_TX_FLAGS_TXTIME flag
after NULLing the tstamp_ring. This could allow a concurrent ice_tx_map
call on another CPU to dereference the tstamp_ring, which could lead to
a NULL pointer dereference.

  CPU A:ice_free_tx_tstamp_ring() | CPU B:ice_tx_map()
  --------------------------------|---------------------------------
  tx_ring->tstamp_ring = NULL     |
                                  | ice_is_txtime_cfg() -> true
                                  | tstamp_ring = tx_ring->tstamp_ring
                                  | tstamp_ring->count  // NULL deref!
  flags &= ~ICE_TX_FLAGS_TXTIME   |

Fix by:
1. Reordering ice_free_tx_tstamp_ring() to clear the flag before
   NULLing the pointer, with smp_wmb() to ensure proper ordering.
2. Adding smp_rmb() in ice_tx_map() after the flag check to order the
   flag read before the pointer read, using READ_ONCE() for the
   pointer, and adding a NULL check as a safety net.
3. Converting tx_ring->flags from u8 to DECLARE_BITMAP() and using
   atomic bitops (set_bit(), clear_bit(), test_bit()) for all flag
   operations throughout the driver:
   - ICE_TX_RING_FLAGS_XDP
   - ICE_TX_RING_FLAGS_VLAN_L2TAG1
   - ICE_TX_RING_FLAGS_VLAN_L2TAG2
   - ICE_TX_RING_FLAGS_TXTIME

Fixes: ccde82e909467 ("ice: add E830 Earliest TxTime First Offload support")
Signed-off-by: Keita Morisaki <kmta1236@gmail.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260416-iwl-net-submission-2026-04-14-v2-7-686c33c9828d@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: fa28351f970f ("ice: fix potential NULL pointer deref in error path of ice_set_ringparam()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h         |  4 ++--
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c     |  4 ++--
 drivers/net/ethernet/intel/ice/ice_txrx.c    | 23 ++++++++++++++------
 drivers/net/ethernet/intel/ice/ice_txrx.h    | 16 +++++++++-----
 5 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index e5ba5bc23065a..c2332a7a8c87e 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -752,7 +752,7 @@ static inline bool ice_is_xdp_ena_vsi(struct ice_vsi *vsi)
 
 static inline void ice_set_ring_xdp(struct ice_tx_ring *ring)
 {
-	ring->flags |= ICE_TX_FLAGS_RING_XDP;
+	set_bit(ICE_TX_RING_FLAGS_XDP, ring->flags);
 }
 
 /**
@@ -780,7 +780,7 @@ static inline bool ice_is_txtime_ena(const struct ice_tx_ring *ring)
  */
 static inline bool ice_is_txtime_cfg(const struct ice_tx_ring *ring)
 {
-	return !!(ring->flags & ICE_TX_FLAGS_TXTIME);
+	return test_bit(ICE_TX_RING_FLAGS_TXTIME, ring->flags);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 270f5a00ece3a..3d0332026c0db 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -943,7 +943,7 @@ ice_tx_prepare_vlan_flags_dcb(struct ice_tx_ring *tx_ring,
 		/* if this is not already set it means a VLAN 0 + priority needs
 		 * to be offloaded
 		 */
-		if (tx_ring->flags & ICE_TX_FLAGS_RING_VLAN_L2TAG2)
+		if (test_bit(ICE_TX_RING_FLAGS_VLAN_L2TAG2, tx_ring->flags))
 			first->tx_flags |= ICE_TX_FLAGS_HW_OUTER_SINGLE_VLAN;
 		else
 			first->tx_flags |= ICE_TX_FLAGS_HW_VLAN;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 6fabc02ba118c..1795b935636ec 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1410,9 +1410,9 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 		ring->count = vsi->num_tx_desc;
 		ring->txq_teid = ICE_INVAL_TEID;
 		if (dvm_ena)
-			ring->flags |= ICE_TX_FLAGS_RING_VLAN_L2TAG2;
+			set_bit(ICE_TX_RING_FLAGS_VLAN_L2TAG2, ring->flags);
 		else
-			ring->flags |= ICE_TX_FLAGS_RING_VLAN_L2TAG1;
+			set_bit(ICE_TX_RING_FLAGS_VLAN_L2TAG1, ring->flags);
 		WRITE_ONCE(vsi->tx_rings[i], ring);
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 9830d5dfb98bf..0ed93fc3bf84e 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -188,9 +188,10 @@ void ice_free_tstamp_ring(struct ice_tx_ring *tx_ring)
 void ice_free_tx_tstamp_ring(struct ice_tx_ring *tx_ring)
 {
 	ice_free_tstamp_ring(tx_ring);
+	clear_bit(ICE_TX_RING_FLAGS_TXTIME, tx_ring->flags);
+	smp_wmb();	/* order flag clear before pointer NULL */
 	kfree_rcu(tx_ring->tstamp_ring, rcu);
-	tx_ring->tstamp_ring = NULL;
-	tx_ring->flags &= ~ICE_TX_FLAGS_TXTIME;
+	WRITE_ONCE(tx_ring->tstamp_ring, NULL);
 }
 
 /**
@@ -403,7 +404,7 @@ static int ice_alloc_tstamp_ring(struct ice_tx_ring *tx_ring)
 	tx_ring->tstamp_ring = tstamp_ring;
 	tstamp_ring->desc = NULL;
 	tstamp_ring->count = ice_calc_ts_ring_count(tx_ring);
-	tx_ring->flags |= ICE_TX_FLAGS_TXTIME;
+	set_bit(ICE_TX_RING_FLAGS_TXTIME, tx_ring->flags);
 	return 0;
 }
 
@@ -1760,13 +1761,20 @@ ice_tx_map(struct ice_tx_ring *tx_ring, struct ice_tx_buf *first,
 		return;
 
 	if (ice_is_txtime_cfg(tx_ring)) {
-		struct ice_tstamp_ring *tstamp_ring = tx_ring->tstamp_ring;
-		u32 tstamp_count = tstamp_ring->count;
-		u32 j = tstamp_ring->next_to_use;
+		struct ice_tstamp_ring *tstamp_ring;
+		u32 tstamp_count, j;
 		struct ice_ts_desc *ts_desc;
 		struct timespec64 ts;
 		u32 tstamp;
 
+		smp_rmb();	/* order flag read before pointer read */
+		tstamp_ring = READ_ONCE(tx_ring->tstamp_ring);
+		if (unlikely(!tstamp_ring))
+			goto ring_kick;
+
+		tstamp_count = tstamp_ring->count;
+		j = tstamp_ring->next_to_use;
+
 		ts = ktime_to_timespec64(first->skb->tstamp);
 		tstamp = ts.tv_nsec >> ICE_TXTIME_CTX_RESOLUTION_128NS;
 
@@ -1794,6 +1802,7 @@ ice_tx_map(struct ice_tx_ring *tx_ring, struct ice_tx_buf *first,
 		tstamp_ring->next_to_use = j;
 		writel_relaxed(j, tstamp_ring->tail);
 	} else {
+ring_kick:
 		writel_relaxed(i, tx_ring->tail);
 	}
 	return;
@@ -2051,7 +2060,7 @@ ice_tx_prepare_vlan_flags(struct ice_tx_ring *tx_ring, struct ice_tx_buf *first)
 	 */
 	if (skb_vlan_tag_present(skb)) {
 		first->vid = skb_vlan_tag_get(skb);
-		if (tx_ring->flags & ICE_TX_FLAGS_RING_VLAN_L2TAG2)
+		if (test_bit(ICE_TX_RING_FLAGS_VLAN_L2TAG2, tx_ring->flags))
 			first->tx_flags |= ICE_TX_FLAGS_HW_OUTER_SINGLE_VLAN;
 		else
 			first->tx_flags |= ICE_TX_FLAGS_HW_VLAN;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 5f24dc036575d..0a3961535e407 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -192,6 +192,14 @@ enum ice_rx_dtype {
 	ICE_RX_DTYPE_SPLIT_ALWAYS	= 2,
 };
 
+enum ice_tx_ring_flags {
+	ICE_TX_RING_FLAGS_XDP,
+	ICE_TX_RING_FLAGS_VLAN_L2TAG1,
+	ICE_TX_RING_FLAGS_VLAN_L2TAG2,
+	ICE_TX_RING_FLAGS_TXTIME,
+	ICE_TX_RING_FLAGS_NBITS,
+};
+
 struct ice_pkt_ctx {
 	u64 cached_phctime;
 	__be16 vlan_proto;
@@ -329,11 +337,7 @@ struct ice_tx_ring {
 	u16 count;			/* Number of descriptors */
 	u16 q_index;			/* Queue number of ring */
 
-	u8 flags;
-#define ICE_TX_FLAGS_RING_XDP		BIT(0)
-#define ICE_TX_FLAGS_RING_VLAN_L2TAG1	BIT(1)
-#define ICE_TX_FLAGS_RING_VLAN_L2TAG2	BIT(2)
-#define ICE_TX_FLAGS_TXTIME		BIT(3)
+	DECLARE_BITMAP(flags, ICE_TX_RING_FLAGS_NBITS);
 
 	struct xsk_buff_pool *xsk_pool;
 
@@ -375,7 +379,7 @@ static inline bool ice_ring_ch_enabled(struct ice_tx_ring *ring)
 
 static inline bool ice_ring_is_xdp(struct ice_tx_ring *ring)
 {
-	return !!(ring->flags & ICE_TX_FLAGS_RING_XDP);
+	return test_bit(ICE_TX_RING_FLAGS_XDP, ring->flags);
 }
 
 enum ice_container_type {
-- 
2.53.0



