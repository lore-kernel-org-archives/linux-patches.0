Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C34D3AC1A;
	Thu, 30 Nov 2023 16:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLclcHDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED18C433C8;
	Thu, 30 Nov 2023 16:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361946;
	bh=tC7ln+L+qiHszMe1MI7jaUUC5xV4zP/QCZpmVH12KGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLclcHDT8Q45zbzAkkDecd+8jGCX0ZruiPolWHKjNjoKyAOdyYt02mMdpA4A5sd0J
	 QoqV067MoXpSH4PXE0mmgKzY35pSpUb4EaX1aMGnWJ8qkPaN3Pl80LXC5RoEKQWpYW
	 +l1FuRVsYIJBAxvI6K5hyNK8YVUw9KC6GZwtqMsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/69] wireguard: use DEV_STATS_INC()
Date: Thu, 30 Nov 2023 16:22:04 +0000
Message-ID: <20231130162133.307406592@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
References: <20231130162133.035359406@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 93da8d75a66568ba4bb5b14ad2833acd7304cd02 ]

wg_xmit() can be called concurrently, KCSAN reported [1]
some device stats updates can be lost.

Use DEV_STATS_INC() for this unlikely case.

[1]
BUG: KCSAN: data-race in wg_xmit / wg_xmit

read-write to 0xffff888104239160 of 8 bytes by task 1375 on cpu 0:
wg_xmit+0x60f/0x680 drivers/net/wireguard/device.c:231
__netdev_start_xmit include/linux/netdevice.h:4918 [inline]
netdev_start_xmit include/linux/netdevice.h:4932 [inline]
xmit_one net/core/dev.c:3543 [inline]
dev_hard_start_xmit+0x11b/0x3f0 net/core/dev.c:3559
...

read-write to 0xffff888104239160 of 8 bytes by task 1378 on cpu 1:
wg_xmit+0x60f/0x680 drivers/net/wireguard/device.c:231
__netdev_start_xmit include/linux/netdevice.h:4918 [inline]
netdev_start_xmit include/linux/netdevice.h:4932 [inline]
xmit_one net/core/dev.c:3543 [inline]
dev_hard_start_xmit+0x11b/0x3f0 net/core/dev.c:3559
...

v2: also change wg_packet_consume_data_done() (Hangbin Liu)
    and wg_packet_purge_staged_packets()

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireguard/device.c  |  4 ++--
 drivers/net/wireguard/receive.c | 12 ++++++------
 drivers/net/wireguard/send.c    |  3 ++-
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 5eaef79c06e16..e5e344af34237 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -193,7 +193,7 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
 	 */
 	while (skb_queue_len(&peer->staged_packet_queue) > MAX_STAGED_PACKETS) {
 		dev_kfree_skb(__skb_dequeue(&peer->staged_packet_queue));
-		++dev->stats.tx_dropped;
+		DEV_STATS_INC(dev, tx_dropped);
 	}
 	skb_queue_splice_tail(&packets, &peer->staged_packet_queue);
 	spin_unlock_bh(&peer->staged_packet_queue.lock);
@@ -211,7 +211,7 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
 	else if (skb->protocol == htons(ETH_P_IPV6))
 		icmpv6_ndo_send(skb, ICMPV6_DEST_UNREACH, ICMPV6_ADDR_UNREACH, 0);
 err:
-	++dev->stats.tx_errors;
+	DEV_STATS_INC(dev, tx_errors);
 	kfree_skb(skb);
 	return ret;
 }
diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index f500aaf678370..d38b24339a1f9 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -423,20 +423,20 @@ static void wg_packet_consume_data_done(struct wg_peer *peer,
 	net_dbg_skb_ratelimited("%s: Packet has unallowed src IP (%pISc) from peer %llu (%pISpfsc)\n",
 				dev->name, skb, peer->internal_id,
 				&peer->endpoint.addr);
-	++dev->stats.rx_errors;
-	++dev->stats.rx_frame_errors;
+	DEV_STATS_INC(dev, rx_errors);
+	DEV_STATS_INC(dev, rx_frame_errors);
 	goto packet_processed;
 dishonest_packet_type:
 	net_dbg_ratelimited("%s: Packet is neither ipv4 nor ipv6 from peer %llu (%pISpfsc)\n",
 			    dev->name, peer->internal_id, &peer->endpoint.addr);
-	++dev->stats.rx_errors;
-	++dev->stats.rx_frame_errors;
+	DEV_STATS_INC(dev, rx_errors);
+	DEV_STATS_INC(dev, rx_frame_errors);
 	goto packet_processed;
 dishonest_packet_size:
 	net_dbg_ratelimited("%s: Packet has incorrect size from peer %llu (%pISpfsc)\n",
 			    dev->name, peer->internal_id, &peer->endpoint.addr);
-	++dev->stats.rx_errors;
-	++dev->stats.rx_length_errors;
+	DEV_STATS_INC(dev, rx_errors);
+	DEV_STATS_INC(dev, rx_length_errors);
 	goto packet_processed;
 packet_processed:
 	dev_kfree_skb(skb);
diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
index 95c853b59e1da..0d48e0f4a1ba3 100644
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -333,7 +333,8 @@ static void wg_packet_create_data(struct wg_peer *peer, struct sk_buff *first)
 void wg_packet_purge_staged_packets(struct wg_peer *peer)
 {
 	spin_lock_bh(&peer->staged_packet_queue.lock);
-	peer->device->dev->stats.tx_dropped += peer->staged_packet_queue.qlen;
+	DEV_STATS_ADD(peer->device->dev, tx_dropped,
+		      peer->staged_packet_queue.qlen);
 	__skb_queue_purge(&peer->staged_packet_queue);
 	spin_unlock_bh(&peer->staged_packet_queue.lock);
 }
-- 
2.42.0



