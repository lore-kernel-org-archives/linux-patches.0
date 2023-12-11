Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51B85102A;
	Mon, 11 Dec 2023 18:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9yZt+lh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E56FC433C9;
	Mon, 11 Dec 2023 18:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320498;
	bh=RI80OW0DhfiMt05YshyCRFIp2AzTW+KHeBlJLidlvk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9yZt+lhQFFS2TYz8AtHIJ+43eQtfmN+po57OP/fOpK2fSceGoVR1o8m0U7zx4e1e
	 lF5qJZyRJVrQ+CvAM0Lm1EKl9XFLS6pdUqp1EU3Azv4mGrgME5ShuX4rgrmdW1VKox
	 Vb1dUjo88aBktrHM5u3qoKrclS5Qde+6M1RCL39k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonglong Liu <liuyonglong@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/194] net: hns: fix wrong head when modify the tx feature when sending packets
Date: Mon, 11 Dec 2023 19:20:35 +0100
Message-ID: <20231211182038.581526535@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit 84757d0839451b20b11e993128f0a77393ca50c1 ]

Upon changing the tx feature, the hns driver will modify the
maybe_stop_tx() and fill_desc() functions, if the modify happens
during packet sending, will cause the hardware and software
pointers do not match, and the port can not work anymore.

This patch deletes the maybe_stop_tx() and fill_desc() functions
modification when setting tx feature, and use the skb_is_gro()
to determine which functions to use in the tx path.

Fixes: 38f616da1c28 ("net:hns: Add support of ethtool TSO set option for Hip06 in HNS")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 53 +++++++++++--------
 drivers/net/ethernet/hisilicon/hns/hns_enet.h |  3 +-
 2 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 7cf10d1e2b311..85722afe21770 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -142,7 +142,8 @@ MODULE_DEVICE_TABLE(acpi, hns_enet_acpi_match);
 
 static void fill_desc(struct hnae_ring *ring, void *priv,
 		      int size, dma_addr_t dma, int frag_end,
-		      int buf_num, enum hns_desc_type type, int mtu)
+		      int buf_num, enum hns_desc_type type, int mtu,
+		      bool is_gso)
 {
 	struct hnae_desc *desc = &ring->desc[ring->next_to_use];
 	struct hnae_desc_cb *desc_cb = &ring->desc_cb[ring->next_to_use];
@@ -275,6 +276,15 @@ static int hns_nic_maybe_stop_tso(
 	return 0;
 }
 
+static int hns_nic_maybe_stop_tx_v2(struct sk_buff **out_skb, int *bnum,
+				    struct hnae_ring *ring)
+{
+	if (skb_is_gso(*out_skb))
+		return hns_nic_maybe_stop_tso(out_skb, bnum, ring);
+	else
+		return hns_nic_maybe_stop_tx(out_skb, bnum, ring);
+}
+
 static void fill_tso_desc(struct hnae_ring *ring, void *priv,
 			  int size, dma_addr_t dma, int frag_end,
 			  int buf_num, enum hns_desc_type type, int mtu)
@@ -300,6 +310,19 @@ static void fill_tso_desc(struct hnae_ring *ring, void *priv,
 				mtu);
 }
 
+static void fill_desc_v2(struct hnae_ring *ring, void *priv,
+			 int size, dma_addr_t dma, int frag_end,
+			 int buf_num, enum hns_desc_type type, int mtu,
+			 bool is_gso)
+{
+	if (is_gso)
+		fill_tso_desc(ring, priv, size, dma, frag_end, buf_num, type,
+			      mtu);
+	else
+		fill_v2_desc(ring, priv, size, dma, frag_end, buf_num, type,
+			     mtu);
+}
+
 netdev_tx_t hns_nic_net_xmit_hw(struct net_device *ndev,
 				struct sk_buff *skb,
 				struct hns_nic_ring_data *ring_data)
@@ -313,6 +336,7 @@ netdev_tx_t hns_nic_net_xmit_hw(struct net_device *ndev,
 	int seg_num;
 	dma_addr_t dma;
 	int size, next_to_use;
+	bool is_gso;
 	int i;
 
 	switch (priv->ops.maybe_stop_tx(&skb, &buf_num, ring)) {
@@ -339,8 +363,9 @@ netdev_tx_t hns_nic_net_xmit_hw(struct net_device *ndev,
 		ring->stats.sw_err_cnt++;
 		goto out_err_tx_ok;
 	}
+	is_gso = skb_is_gso(skb);
 	priv->ops.fill_desc(ring, skb, size, dma, seg_num == 1 ? 1 : 0,
-			    buf_num, DESC_TYPE_SKB, ndev->mtu);
+			    buf_num, DESC_TYPE_SKB, ndev->mtu, is_gso);
 
 	/* fill the fragments */
 	for (i = 1; i < seg_num; i++) {
@@ -354,7 +379,7 @@ netdev_tx_t hns_nic_net_xmit_hw(struct net_device *ndev,
 		}
 		priv->ops.fill_desc(ring, skb_frag_page(frag), size, dma,
 				    seg_num - 1 == i ? 1 : 0, buf_num,
-				    DESC_TYPE_PAGE, ndev->mtu);
+				    DESC_TYPE_PAGE, ndev->mtu, is_gso);
 	}
 
 	/*complete translate all packets*/
@@ -1776,15 +1801,6 @@ static int hns_nic_set_features(struct net_device *netdev,
 			netdev_info(netdev, "enet v1 do not support tso!\n");
 		break;
 	default:
-		if (features & (NETIF_F_TSO | NETIF_F_TSO6)) {
-			priv->ops.fill_desc = fill_tso_desc;
-			priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tso;
-			/* The chip only support 7*4096 */
-			netif_set_tso_max_size(netdev, 7 * 4096);
-		} else {
-			priv->ops.fill_desc = fill_v2_desc;
-			priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tx;
-		}
 		break;
 	}
 	netdev->features = features;
@@ -2159,16 +2175,9 @@ static void hns_nic_set_priv_ops(struct net_device *netdev)
 		priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tx;
 	} else {
 		priv->ops.get_rxd_bnum = get_v2rx_desc_bnum;
-		if ((netdev->features & NETIF_F_TSO) ||
-		    (netdev->features & NETIF_F_TSO6)) {
-			priv->ops.fill_desc = fill_tso_desc;
-			priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tso;
-			/* This chip only support 7*4096 */
-			netif_set_tso_max_size(netdev, 7 * 4096);
-		} else {
-			priv->ops.fill_desc = fill_v2_desc;
-			priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tx;
-		}
+		priv->ops.fill_desc = fill_desc_v2;
+		priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tx_v2;
+		netif_set_tso_max_size(netdev, 7 * 4096);
 		/* enable tso when init
 		 * control tso on/off through TSE bit in bd
 		 */
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.h b/drivers/net/ethernet/hisilicon/hns/hns_enet.h
index ffa9d6573f54b..3f3ee032f631c 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.h
@@ -44,7 +44,8 @@ struct hns_nic_ring_data {
 struct hns_nic_ops {
 	void (*fill_desc)(struct hnae_ring *ring, void *priv,
 			  int size, dma_addr_t dma, int frag_end,
-			  int buf_num, enum hns_desc_type type, int mtu);
+			  int buf_num, enum hns_desc_type type, int mtu,
+			  bool is_gso);
 	int (*maybe_stop_tx)(struct sk_buff **out_skb,
 			     int *bnum, struct hnae_ring *ring);
 	void (*get_rxd_bnum)(u32 bnum_flag, int *out_bnum);
-- 
2.42.0



