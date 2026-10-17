Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBCB356A12;
	Sat, 17 Oct 2026 17:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257379; cv=none; b=SmdJ5vSVBs1iBl8VQaEoqzRLfxhbna/tu3JZ+FHMc80aTYMMoeN++PIjZ/4Tk68dIZ9rgttkX5aRStx1Rj8uRX81m644nGZqFKQpIAFOTDiR4Q/AgRT6E/fcf82YUeOPQQIN65AFm2eZDbSLCgaWRoGwyvh8MT2oogPqag9q3u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257379; c=relaxed/simple;
	bh=KNZmgmSSoOI/NWyS7AHozfILEDQfcxIdS5I1U27Xk4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPmTy12caV6juXIP3JZIzKY0eulI4wczh+xBR2ktTI/LKLCphB5wijEB3SU4eeSwNZqtX2j9JPc9OzQ5M468iAMoqQpFsVfXp4nUlUhX41WqozHM1LgxiKv0y8VARC0h4jyDK1t1OzhpnxBRrX0HmKSpFC/N6Ls4P3gKylkv0a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mA8PTB4B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mA8PTB4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725091F000C4;
	Sat, 17 Oct 2026 17:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257377;
	bh=VTkNxyZcrW7HF+j+p1erHOKefr/HGle4edIf8EYK9z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mA8PTB4B8KO1zlQ3/5X4WyQr+zhMkzWCPY48GfxT+Zoqtut/nQxnNkyfHyXguEAsD
	 kz+6y8RpbkdvwORpcvV7tXpLtzi1YSkcmzqw8k4jhF7hXg5z0qv+A8/YTQKdAM77sU
	 2d3ugBU2tGUa4waslhmYWS1jmUkAyH9InuQU+loo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	"Cen Zhang (Microsoft Security FORGE Labs)" <cenzhang@linux.microsoft.com>,
	Omar Ramadan <omar@blockcast.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0541/1674] amt: send the relays General Query directly from the receive path
Date: Sat, 17 Oct 2026 17:46:53 +0200
Message-ID: <20261017160444.987300722@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Omar Ramadan <omar@blockcast.net>

[ Upstream commit afae89de73dd693cfa329580ba0fba63bd3f0a11 ]

An skb queued in a qdisc can outlive the tunnel it references
through a raw pointer in skb->cb. For example, with igmp_qrv set
to 1 on the relay a tunnel lives for 135s, so a netem delay of
180s on the amt device outlives it; when the tunnel expires and is
freed, the subsequent dequeue triggers a use-after-free in
amt_dev_xmit().

  BUG: KASAN: slab-use-after-free in amt_dev_xmit+0x2763/0x2e20
  Call Trace:
   amt_dev_xmit+0x2763/0x2e20 [drivers/net/amt.c:1262]
   dev_hard_start_xmit+0x22f/0x620
   sch_direct_xmit+0x12e/0xac0
   netem_dequeue+0x333/0xc50
   net_tx_action+0x35c/0xa60

amt_send_igmp_gq() and amt_send_mld_gq() are only called from
amt_request_handler(), inside the rcu_read_lock_bh() section of
amt_rcv(). amt_request_handler() already has the tunnel the query is
for: it found or created it inside that section. Queuing the query with
dev_queue_xmit() only leads back into amt_dev_xmit(), which strips the
Ethernet header and calls amt_send_membership_query() for that tunnel.

Make that call directly from the two senders instead, the same way
amt_send_advertisement() transmits from the receive path. The query
never waits in a qdisc, the tunnel is only dereferenced inside the
RCU section that found or created it, and nothing is stored in
skb->cb, so no lookup or refcount is needed. Remove the query branch
of amt_dev_xmit(), amt_skb_cb() and struct amt_skb_cb, which have no
users left.

Behaviour changes:
 - The relay's own General Queries no longer pass through the amt
   device's egress path: its qdisc, tc egress (clsact/tcx), the
   netfilter egress hook and packet taps. They are still visible as
   UDP on the underlay.
 - A query that is sent successfully is no longer counted as
   tx_dropped. The old query branch left through the unlock label,
   which counted every sent query as dropped.
 - A query that reaches amt_dev_xmit() on a relay from elsewhere,
   such as a userspace querier, is now dropped at the IGMP/MLD type
   switch. Before, it trusted whatever skb->cb held, and a NULL
   tunnel hit the WARN_ON(1).

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Reported-by: AutonomousCodeSecurity@microsoft.com
Reported-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Reported-by: Cen Zhang (Microsoft Security FORGE Labs) <cenzhang@linux.microsoft.com>
Signed-off-by: Omar Ramadan <omar@blockcast.net>
Link: https://patch.msgid.link/20260928202312.74574-2-omar@blockcast.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 48 +++++++++++++++--------------------------------
 include/net/amt.h |  4 ----
 2 files changed, 15 insertions(+), 37 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 4799f8fd03c45..33614c802be1c 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -78,15 +78,6 @@ static struct in6_addr mld2_all_node = MLD2_ALL_NODE_INIT;
 static struct mld2_grec mldv2_zero_grec;
 #endif
 
-static struct amt_skb_cb *amt_skb_cb(struct sk_buff *skb)
-{
-	BUILD_BUG_ON(sizeof(struct amt_skb_cb) + sizeof(struct tc_skb_cb) >
-		     sizeof_field(struct sk_buff, cb));
-
-	return (struct amt_skb_cb *)((void *)skb->cb +
-		sizeof(struct tc_skb_cb));
-}
-
 static void __amt_source_gc_work(void)
 {
 	struct amt_source_node *snode;
@@ -787,6 +778,11 @@ static void amt_send_request(struct amt_dev *amt, bool v6)
 	rcu_read_unlock();
 }
 
+static bool amt_send_membership_query(struct amt_dev *amt,
+				      struct sk_buff *skb,
+				      struct amt_tunnel_list *tunnel,
+				      bool v6);
+
 static void amt_send_igmp_gq(struct amt_dev *amt,
 			     struct amt_tunnel_list *tunnel)
 {
@@ -796,8 +792,11 @@ static void amt_send_igmp_gq(struct amt_dev *amt,
 	if (!skb)
 		return;
 
-	amt_skb_cb(skb)->tunnel = tunnel;
-	dev_queue_xmit(skb);
+	skb_pull(skb, sizeof(struct ethhdr));
+	if (amt_send_membership_query(amt, skb, tunnel, false)) {
+		amt->dev->stats.tx_dropped++;
+		kfree_skb(skb);
+	}
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -881,8 +880,11 @@ static void amt_send_mld_gq(struct amt_dev *amt, struct amt_tunnel_list *tunnel)
 	if (!skb)
 		return;
 
-	amt_skb_cb(skb)->tunnel = tunnel;
-	dev_queue_xmit(skb);
+	skb_pull(skb, sizeof(struct ethhdr));
+	if (amt_send_membership_query(amt, skb, tunnel, true)) {
+		amt->dev->stats.tx_dropped++;
+		kfree_skb(skb);
+	}
 }
 #else
 static void amt_send_mld_gq(struct amt_dev *amt, struct amt_tunnel_list *tunnel)
@@ -1178,7 +1180,6 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 #endif
 	bool report = false;
 	struct igmphdr *ih;
-	bool query = false;
 	struct iphdr *iph;
 	bool data = false;
 	bool v6 = false;
@@ -1196,9 +1197,6 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 			case IGMP_HOST_MEMBERSHIP_REPORT:
 				report = true;
 				break;
-			case IGMP_HOST_MEMBERSHIP_QUERY:
-				query = true;
-				break;
 			default:
 				goto free;
 			}
@@ -1220,9 +1218,6 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 			case ICMPV6_MLD2_REPORT:
 				report = true;
 				break;
-			case ICMPV6_MGM_QUERY:
-				query = true;
-				break;
 			default:
 				goto free;
 			}
@@ -1253,19 +1248,6 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 			goto free;
 		goto unlock;
 	} else if (amt->mode == AMT_MODE_RELAY) {
-		if (query) {
-			tunnel = amt_skb_cb(skb)->tunnel;
-			if (!tunnel) {
-				WARN_ON(1);
-				goto free;
-			}
-
-			/* Do not forward unexpected query */
-			if (amt_send_membership_query(amt, skb, tunnel, v6))
-				goto free;
-			goto unlock;
-		}
-
 		if (!data)
 			goto free;
 		list_for_each_entry_rcu(tunnel, &amt->tunnel_list, list) {
diff --git a/include/net/amt.h b/include/net/amt.h
index c881bc8b673b3..ad844d65a64d4 100644
--- a/include/net/amt.h
+++ b/include/net/amt.h
@@ -231,10 +231,6 @@ struct amt_relay_headers {
 	};
 } __packed;
 
-struct amt_skb_cb {
-	struct amt_tunnel_list *tunnel;
-};
-
 struct amt_tunnel_list {
 	struct list_head	list;
 	/* Protect All resources under an amt_tunne_list */
-- 
2.53.0



