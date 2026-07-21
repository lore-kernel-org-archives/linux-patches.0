Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FE0415F0E;
	Tue, 21 Jul 2026 19:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662303; cv=none; b=RlHDMpwJuvU5mPybXxqcKxTUqNNcN5+3Db8tPgssWrDduU6JVmDDAXbkGaju5B5b5V5MnjRhf860/ozKbE1YllcDPP8EC8Kip9Vqgjh6sOnCHSIZnd5Uoa1V8Jp+sRGaE+qLT85yZhtD7/n194FaiUimxbDTu+7FRDci5bysrao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662303; c=relaxed/simple;
	bh=dqkGqMr/i6uBx2WSpENOhY8GfqQpACgPeJQkVlE5fnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0V3NcLJEOZgBQY93KKnqz4AqPllFActsrcbVWJPNUacujvNeYwPvxJjr50K9XlBY2ZAAm7qij6hT+zHm3YIVRzoMKB+uKEQGQvWjx13Wq8OMD+czX1j58EGPIfhEpGBDQAe49YWlvVimjVNoGf5erq2kctvb6sa9UXH+N0AA50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNYBwZ8n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNYBwZ8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8E91F000E9;
	Tue, 21 Jul 2026 19:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662301;
	bh=gplwU+bLnDOL70Ejqe+k/wzDlLKQ37fTvAkVqcpRgsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VNYBwZ8ngU/GT9+i2VIS5BrhjTlxgA2sFRqP3V0/+xEGjuJ6JJIGjfSr0Dj4FU+a+
	 I/XgnL7lHyh/74Bmhjf0NGhV7aypj+hAVMKdOdRsNUXyKwXxyFn90/WR40sbKTFKPe
	 PDfKvAE0AfkrN8EZjGGIIfU6XsVJuOL5X34k0nc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0393/1276] net: airoha: Introduce ndo_select_queue callback
Date: Tue, 21 Jul 2026 17:13:56 +0200
Message-ID: <20260721152454.900777406@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 2b288b81560b94958cd68bbe54673e55a1730c95 ]

Airoha EN7581 SoC supports 32 Tx DMA rings used to feed packets to QoS
channels. Each channels supports 8 QoS queues where the user can apply
QoS scheduling policies. In a similar way, the user can configure hw
rate shaping for each QoS channel.
Introduce ndo_select_queue callback in order to select the tx queue
based on QoS channel and QoS queue. In particular, for dsa device select
QoS channel according to the dsa user port index, rely on port id
otherwise. Select QoS queue based on the skb priority.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: c66f8511a810 ("net: airoha: Fix always-true condition in PPE1 queue reservation loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/airoha_eth.c | 30 ++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/airoha_eth.c b/drivers/net/ethernet/mediatek/airoha_eth.c
index 7b929b20fe64bf..b6d36217ff6e73 100644
--- a/drivers/net/ethernet/mediatek/airoha_eth.c
+++ b/drivers/net/ethernet/mediatek/airoha_eth.c
@@ -23,6 +23,8 @@
 #define AIROHA_MAX_NUM_XSI_RSTS		5
 #define AIROHA_MAX_MTU			2000
 #define AIROHA_MAX_PACKET_SIZE		2048
+#define AIROHA_NUM_QOS_CHANNELS		4
+#define AIROHA_NUM_QOS_QUEUES		8
 #define AIROHA_NUM_TX_RING		32
 #define AIROHA_NUM_RX_RING		32
 #define AIROHA_FE_MC_MAX_VLAN_TABLE	64
@@ -2428,21 +2430,44 @@ static void airoha_dev_get_stats64(struct net_device *dev,
 	} while (u64_stats_fetch_retry(&port->stats.syncp, start));
 }
 
+static u16 airoha_dev_select_queue(struct net_device *dev, struct sk_buff *skb,
+				   struct net_device *sb_dev)
+{
+	struct airoha_gdm_port *port = netdev_priv(dev);
+	int queue, channel;
+
+	/* For dsa device select QoS channel according to the dsa user port
+	 * index, rely on port id otherwise. Select QoS queue based on the
+	 * skb priority.
+	 */
+	channel = netdev_uses_dsa(dev) ? skb_get_queue_mapping(skb) : port->id;
+	channel = channel % AIROHA_NUM_QOS_CHANNELS;
+	queue = (skb->priority - 1) % AIROHA_NUM_QOS_QUEUES; /* QoS queue */
+	queue = channel * AIROHA_NUM_QOS_QUEUES + queue;
+
+	return queue < dev->num_tx_queues ? queue : 0;
+}
+
 static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 				   struct net_device *dev)
 {
 	struct skb_shared_info *sinfo = skb_shinfo(skb);
 	struct airoha_gdm_port *port = netdev_priv(dev);
-	u32 msg0 = 0, msg1, len = skb_headlen(skb);
-	int i, qid = skb_get_queue_mapping(skb);
+	u32 msg0, msg1, len = skb_headlen(skb);
 	struct airoha_qdma *qdma = port->qdma;
 	u32 nr_frags = 1 + sinfo->nr_frags;
 	struct netdev_queue *txq;
 	struct airoha_queue *q;
 	void *data = skb->data;
+	int i, qid;
 	u16 index;
 	u8 fport;
 
+	qid = skb_get_queue_mapping(skb) % ARRAY_SIZE(qdma->q_tx);
+	msg0 = FIELD_PREP(QDMA_ETH_TXMSG_CHAN_MASK,
+			  qid / AIROHA_NUM_QOS_QUEUES) |
+	       FIELD_PREP(QDMA_ETH_TXMSG_QUEUE_MASK,
+			  qid % AIROHA_NUM_QOS_QUEUES);
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
 		msg0 |= FIELD_PREP(QDMA_ETH_TXMSG_TCO_MASK, 1) |
 			FIELD_PREP(QDMA_ETH_TXMSG_UCO_MASK, 1) |
@@ -2616,6 +2641,7 @@ static const struct net_device_ops airoha_netdev_ops = {
 	.ndo_init		= airoha_dev_init,
 	.ndo_open		= airoha_dev_open,
 	.ndo_stop		= airoha_dev_stop,
+	.ndo_select_queue	= airoha_dev_select_queue,
 	.ndo_start_xmit		= airoha_dev_xmit,
 	.ndo_get_stats64        = airoha_dev_get_stats64,
 	.ndo_set_mac_address	= airoha_dev_set_macaddr,
-- 
2.53.0



