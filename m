Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EB826463A;
	Wed, 25 Feb 2026 01:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983526; cv=none; b=rgeefRkonSsVhgpAp7AJy4jSo/3HDFDOwc/YUXKGsrMdDnpH4yAlD6dO7D6Ex4x+bkFDJ6IcHb68iKeiB16I7DBK12srOtmmbUri01A6EMoqtAzFcXsTPy5mmw+bOEdbjW7fOUgcTLhZ8lLZj8bBFRSFv5+MM/14/ngBEveIarw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983526; c=relaxed/simple;
	bh=QT/ogJrDLn45WyZAsRCngGVs35gNiPZsGnUC997ZkrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWa54O08/KhUbJ2/cPr1ZR9TQVcg03SPginu4EcsppA6xtB0g1eD9ZdeYDG3qutLvTpl80GBbFobz9fgJ0jXiD4PSGUddq0hYmCSgP7cWrRxy6gphvJ0gjrU+67siQgIfwe36XCoeFM8UiDPs+Cnt0wXnIYgv1Z1hdKRtkjjCno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGRaakEX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGRaakEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BDEC116D0;
	Wed, 25 Feb 2026 01:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983525;
	bh=QT/ogJrDLn45WyZAsRCngGVs35gNiPZsGnUC997ZkrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oGRaakEXUO2BJCNyKnLWZBywv86jiuiaYZAY7IMf6f8gyf8TrzuPJttHWtPyYHmXN
	 C9mWvCBCi9KNOg7O5XVCEaE8zdybzWUOo2n1KZhMKikCQCTBM9FEw2qYCyAvAJGLaW
	 TKyeMlZrUXrQ78qB3p8VcoYyNDtFsQJb4MYMbFB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 633/781] ovpn: fix possible use-after-free in ovpn_net_xmit
Date: Tue, 24 Feb 2026 17:22:22 -0800
Message-ID: <20260225012415.334318524@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Lici <ralf@mandelbit.com>

[ Upstream commit a5ec7baa44ea3a1d6aa0ca31c0ad82edf9affe41 ]

When building the skb_list in ovpn_net_xmit, skb_share_check will free
the original skb if it is shared. The current implementation continues
to use the stale skb pointer for subsequent operations:
- peer lookup,
- skb_dst_drop (even though all segments produced by skb_gso_segment
  will have a dst attached),
- ovpn_peer_stats_increment_tx.

Fix this by moving the peer lookup and skb_dst_drop before segmentation
so that the original skb is still valid when used. Return early if all
segments fail skb_share_check and the list ends up empty.
Also switch ovpn_peer_stats_increment_tx to use skb_list.next; the next
patch fixes the stats logic.

Fixes: 08857b5ec5d9 ("ovpn: implement basic TX path (UDP)")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/io.c | 52 ++++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ovpn/io.c b/drivers/net/ovpn/io.c
index 3e9e7f8444b34..f70c58b10599b 100644
--- a/drivers/net/ovpn/io.c
+++ b/drivers/net/ovpn/io.c
@@ -365,7 +365,27 @@ netdev_tx_t ovpn_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* verify IP header size in network packet */
 	proto = ovpn_ip_check_protocol(skb);
 	if (unlikely(!proto || skb->protocol != proto))
-		goto drop;
+		goto drop_no_peer;
+
+	/* retrieve peer serving the destination IP of this packet */
+	peer = ovpn_peer_get_by_dst(ovpn, skb);
+	if (unlikely(!peer)) {
+		switch (skb->protocol) {
+		case htons(ETH_P_IP):
+			net_dbg_ratelimited("%s: no peer to send data to dst=%pI4\n",
+					    netdev_name(ovpn->dev),
+					    &ip_hdr(skb)->daddr);
+			break;
+		case htons(ETH_P_IPV6):
+			net_dbg_ratelimited("%s: no peer to send data to dst=%pI6c\n",
+					    netdev_name(ovpn->dev),
+					    &ipv6_hdr(skb)->daddr);
+			break;
+		}
+		goto drop_no_peer;
+	}
+	/* dst was needed for peer selection - it can now be dropped */
+	skb_dst_drop(skb);
 
 	if (skb_is_gso(skb)) {
 		segments = skb_gso_segment(skb, 0);
@@ -396,34 +416,24 @@ netdev_tx_t ovpn_net_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		__skb_queue_tail(&skb_list, curr);
 	}
-	skb_list.prev->next = NULL;
 
-	/* retrieve peer serving the destination IP of this packet */
-	peer = ovpn_peer_get_by_dst(ovpn, skb);
-	if (unlikely(!peer)) {
-		switch (skb->protocol) {
-		case htons(ETH_P_IP):
-			net_dbg_ratelimited("%s: no peer to send data to dst=%pI4\n",
-					    netdev_name(ovpn->dev),
-					    &ip_hdr(skb)->daddr);
-			break;
-		case htons(ETH_P_IPV6):
-			net_dbg_ratelimited("%s: no peer to send data to dst=%pI6c\n",
-					    netdev_name(ovpn->dev),
-					    &ipv6_hdr(skb)->daddr);
-			break;
-		}
-		goto drop;
+	/* no segments survived: don't jump to 'drop' because we already
+	 * incremented the counter for each failure in the loop
+	 */
+	if (unlikely(skb_queue_empty(&skb_list))) {
+		ovpn_peer_put(peer);
+		return NETDEV_TX_OK;
 	}
-	/* dst was needed for peer selection - it can now be dropped */
-	skb_dst_drop(skb);
+	skb_list.prev->next = NULL;
 
-	ovpn_peer_stats_increment_tx(&peer->vpn_stats, skb->len);
+	ovpn_peer_stats_increment_tx(&peer->vpn_stats, skb_list.next->len);
 	ovpn_send(ovpn, skb_list.next, peer);
 
 	return NETDEV_TX_OK;
 
 drop:
+	ovpn_peer_put(peer);
+drop_no_peer:
 	dev_dstats_tx_dropped(ovpn->dev);
 	skb_tx_error(skb);
 	kfree_skb_list(skb);
-- 
2.51.0



