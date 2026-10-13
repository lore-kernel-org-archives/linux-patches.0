Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCFB390CB7;
	Tue, 13 Oct 2026 12:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894380; cv=none; b=fcnTeMx79T6vZZwG9YZSIOFz4reOptqRZEuVZo+/6X45G/raS4u6rOiKL4QnizfgszbV+eWHbhXv/I1onHqPbFY3HSBdR8FwegVsy3ZNi6j7mbA2mea0bXZ95lSF5pgOIUa7VCPkD13Ix7JfK0BOUJkpSCuJ5Tbgofwi9zfg3zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894380; c=relaxed/simple;
	bh=uPB9+ARMJpgvGg8WRK+44BITrrua1R1opRNJDDSCx24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hi8sRPBWUkAOc+DG/20VAbU8JFyS25XnZ2UG/24gBYof4y5H/ENy0UvVgdaLBo/pXLYtPwtoypt7XjJFSaYAWpVIpTROToZSta4j90Uh4DzNKnONPRuYY4WFn9lfN6EIvUExLC1zgPSbFI8VP935bT+hxWME3lhccvCGSCs7J/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ky+JV1RX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ky+JV1RX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7DC1F000FF;
	Tue, 13 Oct 2026 12:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894379;
	bh=SeTzL+zOai9XXYBbNShTsRVpdd31Q6zXIdtinDs18Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ky+JV1RXlatim+xAFK3PzhDMupbRio3x8hFWG7l2o8DnstZ/9fKFVnizOzlZq93Rn
	 lm8Cw84bZLX9uj9NpIOw3j00H4ZylOYeRtixwgdmHdkNlJsuwrRwrjsG82uYaZIeeY
	 bHVQsOPxDgNPwLg811Rjg1DjDmug6ogiD0rWpGDs=
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
Subject: [PATCH 6.18 542/621] amt: send the relays General Query directly from the receive path
Date: Tue, 13 Oct 2026 13:38:57 +0200
Message-ID: <20261013112933.682252018@linuxfoundation.org>
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
index 01d2223fce09b..3f4e974762926 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -80,15 +80,6 @@ static struct in6_addr mld2_all_node = MLD2_ALL_NODE_INIT;
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
@@ -789,6 +780,11 @@ static void amt_send_request(struct amt_dev *amt, bool v6)
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
@@ -798,8 +794,11 @@ static void amt_send_igmp_gq(struct amt_dev *amt,
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
@@ -883,8 +882,11 @@ static void amt_send_mld_gq(struct amt_dev *amt, struct amt_tunnel_list *tunnel)
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
@@ -1183,7 +1185,6 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 #endif
 	bool report = false;
 	struct igmphdr *ih;
-	bool query = false;
 	struct iphdr *iph;
 	bool data = false;
 	bool v6 = false;
@@ -1201,9 +1202,6 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 			case IGMP_HOST_MEMBERSHIP_REPORT:
 				report = true;
 				break;
-			case IGMP_HOST_MEMBERSHIP_QUERY:
-				query = true;
-				break;
 			default:
 				goto free;
 			}
@@ -1225,9 +1223,6 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 			case ICMPV6_MLD2_REPORT:
 				report = true;
 				break;
-			case ICMPV6_MGM_QUERY:
-				query = true;
-				break;
 			default:
 				goto free;
 			}
@@ -1258,19 +1253,6 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
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



