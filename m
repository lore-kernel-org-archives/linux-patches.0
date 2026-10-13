Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E293B4FC8E2;
	Tue, 13 Oct 2026 12:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893392; cv=none; b=u+haATsY/VK8UUPwyIP2Os/lWFcbcFt9s2zl7n/2io++NnKM5jREyuisVAbhca4ysYsCt0f6xwtc6+NlZsV1P+IesAJVyUzhemJipapg/0/n3wdp74KmsJAeg6nb7Md97Gq4AUXErAhFKp4UtGB+Ifq92x7j+ypazSWdTBCVHNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893392; c=relaxed/simple;
	bh=BfjeuDzWQhT6eo+hwDmkb+4awTqgHkpgRFl8EaqjLeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTn2abuyOaQKkdSxHviaBP/B7iVlyOfX+SFM8llxmDOT7B2LDcSZqjdYOY4axlW0N5lHyIgI7w232aNETFrKrZW5FRC5N1A9v5gvTDpCqY9nTeT8ybeWncWp3AqZsshbAJmh2rjOVYAY4XAOW9Uf6/aL8a9oDXO76XTfIM6hX7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlRrBnsL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlRrBnsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC351F0089B;
	Tue, 13 Oct 2026 12:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893390;
	bh=lUT1lwC7EV6bk6EZ18YXWZax+eTdDaywSrFxUKKpMVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MlRrBnsLZgIkMgL/AiGzuizU1UmxMd/N54uaN1RlvhuzO9Vip3kJSAbn/vu1RSAqN
	 Xgw1Ndn8vZbmXjsdoFc+XUeEmLkzTNRLbJwTl5UHMuyM+dmwWFSsSAXMaL53z76gbk
	 7qtEfccn3Ir0x4BNX0luzAAzbJ4R/GFoULSmpbiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 211/621] ice: reshuffle and group Rx and Tx queue fields by cachelines
Date: Tue, 13 Oct 2026 13:33:26 +0200
Message-ID: <20261013112925.868199150@linuxfoundation.org>
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

From: Alexander Lobakin <aleksander.lobakin@intel.com>

[ Upstream commit 24f90786efaf1c573518706408deadcef189e6de ]

Place the fields in ice_{rx,tx}_ring used in the same pieces of
hotpath code closer to each other and use
__cacheline_group_{begin,end}_aligned() to isolate the read mostly,
read-write, and cold groups into separate cachelines similarly
to idpf.

Suggested-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Only the Tx ring layout change is carried here; the Rx ring part and the
next_to_alloc removal depend on the libeth Rx conversion that is not
present, so they are dropped.

Stable-dep-of: fa28351f970f ("ice: fix potential NULL pointer deref in error path of ice_set_ringparam()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.h | 55 ++++++++++++++---------
 1 file changed, 34 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 3c7830f787de8..5f24dc036575d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -316,43 +316,56 @@ struct ice_rx_ring {
 } ____cacheline_internodealigned_in_smp;
 
 struct ice_tx_ring {
-	/* CL1 - 1st cacheline starts here */
-	struct ice_tx_ring *next;	/* pointer to next ring in q_vector */
+	__cacheline_group_begin_aligned(read_mostly);
 	void *desc;			/* Descriptor ring memory */
 	struct device *dev;		/* Used for DMA mapping */
 	u8 __iomem *tail;
 	struct ice_tx_buf *tx_buf;
+
 	struct ice_q_vector *q_vector;	/* Backreference to associated vector */
 	struct net_device *netdev;	/* netdev ring maps to */
 	struct ice_vsi *vsi;		/* Backreference to associated VSI */
-	/* CL2 - 2nd cacheline starts here */
-	dma_addr_t dma;			/* physical address of ring */
-	struct xsk_buff_pool *xsk_pool;
-	u16 next_to_use;
-	u16 next_to_clean;
-	u16 q_handle;			/* Queue handle per TC */
-	u16 reg_idx;			/* HW register index of the ring */
+
 	u16 count;			/* Number of descriptors */
 	u16 q_index;			/* Queue number of ring */
-	u16 xdp_tx_active;
+
+	u8 flags;
+#define ICE_TX_FLAGS_RING_XDP		BIT(0)
+#define ICE_TX_FLAGS_RING_VLAN_L2TAG1	BIT(1)
+#define ICE_TX_FLAGS_RING_VLAN_L2TAG2	BIT(2)
+#define ICE_TX_FLAGS_TXTIME		BIT(3)
+
+	struct xsk_buff_pool *xsk_pool;
+
 	/* stats structs */
 	struct ice_ring_stats *ring_stats;
-	/* CL3 - 3rd cacheline starts here */
+	struct ice_tx_ring *next;	/* pointer to next ring in q_vector */
+
+	struct ice_tstamp_ring *tstamp_ring;
+	struct ice_ptp_tx *tx_tstamps;
+	__cacheline_group_end_aligned(read_mostly);
+
+	__cacheline_group_begin_aligned(read_write);
+	u16 next_to_use;
+	u16 next_to_clean;
+
+	u16 xdp_tx_active;
+	spinlock_t tx_lock;
+	__cacheline_group_end_aligned(read_write);
+
+	__cacheline_group_begin_aligned(cold);
 	struct rcu_head rcu;		/* to avoid race on free */
 	DECLARE_BITMAP(xps_state, ICE_TX_NBITS);	/* XPS Config State */
 	struct ice_channel *ch;
-	struct ice_ptp_tx *tx_tstamps;
-	spinlock_t tx_lock;
-	u32 txq_teid;			/* Added Tx queue TEID */
-	/* CL4 - 4th cacheline starts here */
-	struct ice_tstamp_ring *tstamp_ring;
-#define ICE_TX_FLAGS_RING_XDP		BIT(0)
-#define ICE_TX_FLAGS_RING_VLAN_L2TAG1	BIT(1)
-#define ICE_TX_FLAGS_RING_VLAN_L2TAG2	BIT(2)
-#define ICE_TX_FLAGS_TXTIME		BIT(3)
-	u8 flags;
+
+	dma_addr_t dma;			/* physical address of ring */
+	u16 q_handle;			/* Queue handle per TC */
+	u16 reg_idx;			/* HW register index of the ring */
 	u8 dcb_tc;			/* Traffic class of ring */
+
 	u16 quanta_prof_id;
+	u32 txq_teid;			/* Added Tx queue TEID */
+	__cacheline_group_end_aligned(cold);
 } ____cacheline_internodealigned_in_smp;
 
 static inline bool ice_ring_ch_enabled(struct ice_tx_ring *ring)
-- 
2.53.0



