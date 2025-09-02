Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B22531AF39;
	Tue,  2 Sep 2025 13:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819503; cv=none; b=Uv/9BEXiT3VeKHkkVLyYIAoAYOcz9MRs6VZFhYaANeboA17IDKFgAfjYlXaywjiSk6GXrOR0SkFz6IdE/hGp0WEPzP2sid/iB3Qym2SVu0hnrbCyszUx0g6z70r50+fZKTbNhVXmYGaS/RKB94WUADZNyL1F8C/joOAP2kKhp0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819503; c=relaxed/simple;
	bh=YmqnVzTnu8KK/O7rE1WNVP9hc+3FuF71FmANT8i+pMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlXdMCtNc6Xd/kr7u+vHZrq6jR+E+7MDjRpIW+uAkC9LmOSAMXizOXqOwahuIMEZ+S0pjlmcTjwV66lkKTSALhcVcz09K4u0lMdT32FYPHRTLYPKFb+MDzV4nk7A0m7WxsWfhGXvwsgAPI20cah07vJOK/9vwyttGIq058hDZr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfGXf+cm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfGXf+cm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A5EC4CEF5;
	Tue,  2 Sep 2025 13:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819503;
	bh=YmqnVzTnu8KK/O7rE1WNVP9hc+3FuF71FmANT8i+pMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PfGXf+cmQ5kGYBgnvcN/8hb1G+/qcD+1QRdXc3kAc+1jKzwCKUgOIMGebyMGEOHF6
	 KSqHir76T7sfpbQOAHitTlluU3bocXWPVDGtL1Y9wUewJCjVE5wWGxIHL+bFDc3JBq
	 MnOduM6LcZ1GxMn8WPqauwIGcvcoV2y2FClJhneM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 053/142] Octeontx2-vf: Fix max packet length errors
Date: Tue,  2 Sep 2025 15:19:15 +0200
Message-ID: <20250902131950.285665013@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit a64494aafc56939564e3e9e57f99df5c27204e04 ]

Once driver submits the packets to the hardware, each packet
traverse through multiple transmit levels in the following
order:
	SMQ -> TL4 -> TL3 -> TL2 -> TL1

The SMQ supports configurable minimum and maximum packet sizes.
It enters to a hang state, if driver submits packets with
out of bound lengths.

To avoid the same, implement packet length validation before
submitting packets to the hardware. Increment tx_dropped counter
on failure.

Fixes: 3184fb5ba96e ("octeontx2-vf: Virtual function driver support")
Fixes: 22f858796758 ("octeontx2-pf: Add basic net_device_ops")
Fixes: 3ca6c4c882a7 ("octeontx2-pf: Add packet transmission support")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://patch.msgid.link/20250821062528.1697992-1-hkelam@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c    |  4 +++-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h    |  1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c    |  3 +++
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c    | 10 ++++++++++
 drivers/net/ethernet/marvell/octeontx2/nic/rep.c    | 13 ++++++++++++-
 drivers/net/ethernet/marvell/octeontx2/nic/rep.h    |  1 +
 6 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 6b5c9536d26d3..6f7b608261d9c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -124,7 +124,9 @@ void otx2_get_dev_stats(struct otx2_nic *pfvf)
 			       dev_stats->rx_ucast_frames;
 
 	dev_stats->tx_bytes = OTX2_GET_TX_STATS(TX_OCTS);
-	dev_stats->tx_drops = OTX2_GET_TX_STATS(TX_DROP);
+	dev_stats->tx_drops = OTX2_GET_TX_STATS(TX_DROP) +
+			       (unsigned long)atomic_long_read(&dev_stats->tx_discards);
+
 	dev_stats->tx_bcast_frames = OTX2_GET_TX_STATS(TX_BCAST);
 	dev_stats->tx_mcast_frames = OTX2_GET_TX_STATS(TX_MCAST);
 	dev_stats->tx_ucast_frames = OTX2_GET_TX_STATS(TX_UCAST);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index ca0e6ab12cebe..5a6739d3a0688 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -149,6 +149,7 @@ struct otx2_dev_stats {
 	u64 tx_bcast_frames;
 	u64 tx_mcast_frames;
 	u64 tx_drops;
+	atomic_long_t tx_discards;
 };
 
 /* Driver counted stats */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index db7c466fdc39e..74d0b6bac600a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2153,6 +2153,7 @@ static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
 	int qidx = skb_get_queue_mapping(skb);
+	struct otx2_dev_stats *dev_stats;
 	struct otx2_snd_queue *sq;
 	struct netdev_queue *txq;
 	int sq_idx;
@@ -2165,6 +2166,8 @@ static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
 	/* Check for minimum and maximum packet length */
 	if (skb->len <= ETH_HLEN ||
 	    (!skb_shinfo(skb)->gso_size && skb->len > pf->tx_max_pktlen)) {
+		dev_stats = &pf->hw.dev_stats;
+		atomic_long_inc(&dev_stats->tx_discards);
 		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 8a8b598bd389b..76dd2e965cf03 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -391,9 +391,19 @@ static netdev_tx_t otx2vf_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct otx2_nic *vf = netdev_priv(netdev);
 	int qidx = skb_get_queue_mapping(skb);
+	struct otx2_dev_stats *dev_stats;
 	struct otx2_snd_queue *sq;
 	struct netdev_queue *txq;
 
+	/* Check for minimum and maximum packet length */
+	if (skb->len <= ETH_HLEN ||
+	    (!skb_shinfo(skb)->gso_size && skb->len > vf->tx_max_pktlen)) {
+		dev_stats = &vf->hw.dev_stats;
+		atomic_long_inc(&dev_stats->tx_discards);
+		dev_kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
 	sq = &vf->qset.sq[qidx];
 	txq = netdev_get_tx_queue(netdev, qidx);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/rep.c b/drivers/net/ethernet/marvell/octeontx2/nic/rep.c
index 2cd3da3b68432..d97be15d80561 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/rep.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/rep.c
@@ -371,7 +371,8 @@ static void rvu_rep_get_stats(struct work_struct *work)
 	stats->rx_mcast_frames = rsp->rx.mcast;
 	stats->tx_bytes = rsp->tx.octs;
 	stats->tx_frames = rsp->tx.ucast + rsp->tx.bcast + rsp->tx.mcast;
-	stats->tx_drops = rsp->tx.drop;
+	stats->tx_drops = rsp->tx.drop +
+			  (unsigned long)atomic_long_read(&stats->tx_discards);
 exit:
 	mutex_unlock(&priv->mbox.lock);
 }
@@ -418,6 +419,16 @@ static netdev_tx_t rvu_rep_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct otx2_nic *pf = rep->mdev;
 	struct otx2_snd_queue *sq;
 	struct netdev_queue *txq;
+	struct rep_stats *stats;
+
+	/* Check for minimum and maximum packet length */
+	if (skb->len <= ETH_HLEN ||
+	    (!skb_shinfo(skb)->gso_size && skb->len > pf->tx_max_pktlen)) {
+		stats = &rep->stats;
+		atomic_long_inc(&stats->tx_discards);
+		dev_kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
 
 	sq = &pf->qset.sq[rep->rep_id];
 	txq = netdev_get_tx_queue(dev, 0);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/rep.h b/drivers/net/ethernet/marvell/octeontx2/nic/rep.h
index 38446b3e4f13c..5bc9e2c7d800b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/rep.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/rep.h
@@ -27,6 +27,7 @@ struct rep_stats {
 	u64 tx_bytes;
 	u64 tx_frames;
 	u64 tx_drops;
+	atomic_long_t tx_discards;
 };
 
 struct rep_dev {
-- 
2.50.1



