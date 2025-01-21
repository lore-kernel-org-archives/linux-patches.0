Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C26C1F238E;
	Tue, 21 Jan 2025 17:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482306; cv=none; b=KHMLNK4w9kmMXXBS1vmKJB5QSX/YAJ7VMh3c52E3G2Yvuj/HxMB6EnLAA6WA95b0tiskDcouWiQdcVuFVqghSw4KE0uH7U5sZA7XMyUrnIjl4A1Z+g7pHv5H9AizvwHuAtqY89EZtLqShDWvSY315LzcId8pkhGvNO9+s5vt5Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482306; c=relaxed/simple;
	bh=JXwaSMHb0vjvFBNrh63PpIwA6DaeOtWe5Oghd0peb5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDgnGeQign9G1D3IRYxvR0u6GnRilBVJK09yXhPDFCQJwv+r5kVWA8k5kHUuF17vSVLA6lMStjn4fJ4N3ItTV6ohPNxuIQ3xvFBI6gwmbGofBu6fVVvK2Ix/ptQGeTY3MrNjDJNHCfVgkcmxmAVTYNJqI0r3jNKiziN6jO/7hOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRzlUe/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRzlUe/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C220BC4CEDF;
	Tue, 21 Jan 2025 17:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482306;
	bh=JXwaSMHb0vjvFBNrh63PpIwA6DaeOtWe5Oghd0peb5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZRzlUe/n21O1XA1oQn+FeoTXh0XFkg3hugsMMdtz8XWdkuCOaPFVYK04BHRB7XhHZ
	 v4tYyXm/590TdB3C3I6RlPvKmiUdo6LnLjkZ9hZu7H6Vcr7x3U7NASWNbBk4Hlj62E
	 RFHeWV/FrKry0ldPo/DUnFuo9MZaL4uVa8TUpn+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/122] eth: bnxt: always recalculate features after XDP clearing, fix null-deref
Date: Tue, 21 Jan 2025 18:50:52 +0100
Message-ID: <20250121174533.164096676@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit f0aa6a37a3dbb40b272df5fc6db93c114688adcd ]

Recalculate features when XDP is detached.

Before:
  # ip li set dev eth0 xdp obj xdp_dummy.bpf.o sec xdp
  # ip li set dev eth0 xdp off
  # ethtool -k eth0 | grep gro
  rx-gro-hw: off [requested on]

After:
  # ip li set dev eth0 xdp obj xdp_dummy.bpf.o sec xdp
  # ip li set dev eth0 xdp off
  # ethtool -k eth0 | grep gro
  rx-gro-hw: on

The fact that HW-GRO doesn't get re-enabled automatically is just
a minor annoyance. The real issue is that the features will randomly
come back during another reconfiguration which just happens to invoke
netdev_update_features(). The driver doesn't handle reconfiguring
two things at a time very robustly.

Starting with commit 98ba1d931f61 ("bnxt_en: Fix RSS logic in
__bnxt_reserve_rings()") we only reconfigure the RSS hash table
if the "effective" number of Rx rings has changed. If HW-GRO is
enabled "effective" number of rings is 2x what user sees.
So if we are in the bad state, with HW-GRO re-enablement "pending"
after XDP off, and we lower the rings by / 2 - the HW-GRO rings
doing 2x and the ethtool -L doing / 2 may cancel each other out,
and the:

  if (old_rx_rings != bp->hw_resc.resv_rx_rings &&

condition in __bnxt_reserve_rings() will be false.
The RSS map won't get updated, and we'll crash with:

  BUG: kernel NULL pointer dereference, address: 0000000000000168
  RIP: 0010:__bnxt_hwrm_vnic_set_rss+0x13a/0x1a0
    bnxt_hwrm_vnic_rss_cfg_p5+0x47/0x180
    __bnxt_setup_vnic_p5+0x58/0x110
    bnxt_init_nic+0xb72/0xf50
    __bnxt_open_nic+0x40d/0xab0
    bnxt_open_nic+0x2b/0x60
    ethtool_set_channels+0x18c/0x1d0

As we try to access a freed ring.

The issue is present since XDP support was added, really, but
prior to commit 98ba1d931f61 ("bnxt_en: Fix RSS logic in
__bnxt_reserve_rings()") it wasn't causing major issues.

Fixes: 1054aee82321 ("bnxt_en: Use NETIF_F_GRO_HW.")
Fixes: 98ba1d931f61 ("bnxt_en: Fix RSS logic in __bnxt_reserve_rings()")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Link: https://patch.msgid.link/20250109043057.2888953-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 25 +++++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  7 ------
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c255445e97f3c..603e9c968c44b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4558,7 +4558,7 @@ void bnxt_set_ring_params(struct bnxt *bp)
 /* Changing allocation mode of RX rings.
  * TODO: Update when extending xdp_rxq_info to support allocation modes.
  */
-int bnxt_set_rx_skb_mode(struct bnxt *bp, bool page_mode)
+static void __bnxt_set_rx_skb_mode(struct bnxt *bp, bool page_mode)
 {
 	struct net_device *dev = bp->dev;
 
@@ -4579,15 +4579,30 @@ int bnxt_set_rx_skb_mode(struct bnxt *bp, bool page_mode)
 			bp->rx_skb_func = bnxt_rx_page_skb;
 		}
 		bp->rx_dir = DMA_BIDIRECTIONAL;
-		/* Disable LRO or GRO_HW */
-		netdev_update_features(dev);
 	} else {
 		dev->max_mtu = bp->max_mtu;
 		bp->flags &= ~BNXT_FLAG_RX_PAGE_MODE;
 		bp->rx_dir = DMA_FROM_DEVICE;
 		bp->rx_skb_func = bnxt_rx_skb;
 	}
-	return 0;
+}
+
+void bnxt_set_rx_skb_mode(struct bnxt *bp, bool page_mode)
+{
+	__bnxt_set_rx_skb_mode(bp, page_mode);
+
+	if (!page_mode) {
+		int rx, tx;
+
+		bnxt_get_max_rings(bp, &rx, &tx, true);
+		if (rx > 1) {
+			bp->flags &= ~BNXT_FLAG_NO_AGG_RINGS;
+			bp->dev->hw_features |= NETIF_F_LRO;
+		}
+	}
+
+	/* Update LRO and GRO_HW availability */
+	netdev_update_features(bp->dev);
 }
 
 static void bnxt_free_vnic_attributes(struct bnxt *bp)
@@ -15909,7 +15924,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (bp->max_fltr < BNXT_MAX_FLTR)
 		bp->max_fltr = BNXT_MAX_FLTR;
 	bnxt_init_l2_fltr_tbl(bp);
-	bnxt_set_rx_skb_mode(bp, false);
+	__bnxt_set_rx_skb_mode(bp, false);
 	bnxt_set_tpa_flags(bp);
 	bnxt_set_ring_params(bp);
 	bnxt_rdma_aux_device_init(bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 9e05704d94450..bee645f58d0bd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2796,7 +2796,7 @@ void bnxt_reuse_rx_data(struct bnxt_rx_ring_info *rxr, u16 cons, void *data);
 u32 bnxt_fw_health_readl(struct bnxt *bp, int reg_idx);
 void bnxt_set_tpa_flags(struct bnxt *bp);
 void bnxt_set_ring_params(struct bnxt *);
-int bnxt_set_rx_skb_mode(struct bnxt *bp, bool page_mode);
+void bnxt_set_rx_skb_mode(struct bnxt *bp, bool page_mode);
 void bnxt_insert_usr_fltr(struct bnxt *bp, struct bnxt_filter_base *fltr);
 void bnxt_del_one_usr_fltr(struct bnxt *bp, struct bnxt_filter_base *fltr);
 int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp, unsigned long *bmap,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index f88b641533fcc..dc51dce209d5f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -422,15 +422,8 @@ static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
 		bnxt_set_rx_skb_mode(bp, true);
 		xdp_features_set_redirect_target(dev, true);
 	} else {
-		int rx, tx;
-
 		xdp_features_clear_redirect_target(dev);
 		bnxt_set_rx_skb_mode(bp, false);
-		bnxt_get_max_rings(bp, &rx, &tx, true);
-		if (rx > 1) {
-			bp->flags &= ~BNXT_FLAG_NO_AGG_RINGS;
-			bp->dev->hw_features |= NETIF_F_LRO;
-		}
 	}
 	bp->tx_nr_rings_xdp = tx_xdp;
 	bp->tx_nr_rings = bp->tx_nr_rings_per_tc * tc + tx_xdp;
-- 
2.39.5



