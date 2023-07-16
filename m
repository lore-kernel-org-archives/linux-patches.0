Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D358F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6B3C433C7;
	Sun, 16 Jul 2023 20:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539767;
	bh=GtigEP8H5UW/9/fEAPGRkG2Gz0Op+9YgyiSke1BiqpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJWqpd+X46waRsVhEwCnSGXz5s7XBx5Qku7O+WghnyyxMaa/wT+NhgSJbHevruzZH
	 fR2h/clzWBjYHyQG1F10QQrtrPWgbKg0Ma5WjhCjznbE0voidvv6GvEL6GCEpqX/jj
	 HuxK6j6QS6aNzh/bj/6KQIqiDBpve0RibUH25jr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Assarsson <extja@kvaser.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 124/591] can: kvaser_pciefd: Add function to set skb hwtstamps
Date: Sun, 16 Jul 2023 21:44:23 +0200
Message-ID: <20230716194927.083565258@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jimmy Assarsson <extja@kvaser.com>

[ Upstream commit 2d55e9f9b4427e1ad59b974f2267767aac3788d3 ]

Add new function, kvaser_pciefd_set_skb_timestamp(), to set skb hwtstamps.

Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20230529134248.752036-4-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: ec681b91befa ("can: kvaser_pciefd: Set hardware timestamp on transmitted packets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/kvaser_pciefd.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 956a4a57396f9..0b537292c7b19 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -538,6 +538,13 @@ static int kvaser_pciefd_set_tx_irq(struct kvaser_pciefd_can *can)
 	return 0;
 }
 
+static inline void kvaser_pciefd_set_skb_timestamp(const struct kvaser_pciefd *pcie,
+						   struct sk_buff *skb, u64 timestamp)
+{
+	skb_hwtstamps(skb)->hwtstamp =
+		ns_to_ktime(div_u64(timestamp * 1000, pcie->freq_to_ticks_div));
+}
+
 static void kvaser_pciefd_setup_controller(struct kvaser_pciefd_can *can)
 {
 	u32 mode;
@@ -1171,7 +1178,6 @@ static int kvaser_pciefd_handle_data_packet(struct kvaser_pciefd *pcie,
 	struct canfd_frame *cf;
 	struct can_priv *priv;
 	struct net_device_stats *stats;
-	struct skb_shared_hwtstamps *shhwtstamps;
 	u8 ch_id = (p->header[1] >> KVASER_PCIEFD_PACKET_CHID_SHIFT) & 0x7;
 
 	if (ch_id >= pcie->nr_channels)
@@ -1214,12 +1220,7 @@ static int kvaser_pciefd_handle_data_packet(struct kvaser_pciefd *pcie,
 		stats->rx_bytes += cf->len;
 	}
 	stats->rx_packets++;
-
-	shhwtstamps = skb_hwtstamps(skb);
-
-	shhwtstamps->hwtstamp =
-		ns_to_ktime(div_u64(p->timestamp * 1000,
-				    pcie->freq_to_ticks_div));
+	kvaser_pciefd_set_skb_timestamp(pcie, skb, p->timestamp);
 
 	return netif_rx(skb);
 }
@@ -1282,7 +1283,6 @@ static int kvaser_pciefd_rx_error_frame(struct kvaser_pciefd_can *can,
 	struct net_device *ndev = can->can.dev;
 	struct sk_buff *skb;
 	struct can_frame *cf = NULL;
-	struct skb_shared_hwtstamps *shhwtstamps;
 	struct net_device_stats *stats = &ndev->stats;
 
 	old_state = can->can.state;
@@ -1323,10 +1323,7 @@ static int kvaser_pciefd_rx_error_frame(struct kvaser_pciefd_can *can,
 		return -ENOMEM;
 	}
 
-	shhwtstamps = skb_hwtstamps(skb);
-	shhwtstamps->hwtstamp =
-		ns_to_ktime(div_u64(p->timestamp * 1000,
-				    can->kv_pcie->freq_to_ticks_div));
+	kvaser_pciefd_set_skb_timestamp(can->kv_pcie, skb, p->timestamp);
 	cf->can_id |= CAN_ERR_BUSERROR | CAN_ERR_CNT;
 
 	cf->data[6] = bec.txerr;
@@ -1374,7 +1371,6 @@ static int kvaser_pciefd_handle_status_resp(struct kvaser_pciefd_can *can,
 		struct net_device *ndev = can->can.dev;
 		struct sk_buff *skb;
 		struct can_frame *cf;
-		struct skb_shared_hwtstamps *shhwtstamps;
 
 		skb = alloc_can_err_skb(ndev, &cf);
 		if (!skb) {
@@ -1394,10 +1390,7 @@ static int kvaser_pciefd_handle_status_resp(struct kvaser_pciefd_can *can,
 			cf->can_id |= CAN_ERR_RESTARTED;
 		}
 
-		shhwtstamps = skb_hwtstamps(skb);
-		shhwtstamps->hwtstamp =
-			ns_to_ktime(div_u64(p->timestamp * 1000,
-					    can->kv_pcie->freq_to_ticks_div));
+		kvaser_pciefd_set_skb_timestamp(can->kv_pcie, skb, p->timestamp);
 
 		cf->data[6] = bec.txerr;
 		cf->data[7] = bec.rxerr;
-- 
2.39.2



