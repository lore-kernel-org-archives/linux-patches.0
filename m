Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51F53A8746;
	Tue, 16 Jun 2026 16:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627069; cv=none; b=dIzmSAlc/NlBlp8M6ntnd/1z1X2YhYnZsPiflZC2MCrs8fnARwnTV4gZvhsXz3WGWbdAyIzHoou3EWgxjdFjz1RD51X/1TfQDICIRXTVoiGeu6bnWIoLJV1daz5we5DV9dzz9ymaJKE+bGia7wJbn2oR+69ydVL+tEPR7WKjpd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627069; c=relaxed/simple;
	bh=uO0KvMVUSYKsJ4ISK3bVyrbV0gCqicZIF79vQ4O4Kd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXYEkEMb26NgRBZV2JmWtUNXReEhS4DnBchcCy7n1oBVSXmOyqXwU56HMk+b9tVEHdupr1/3PV+L7KOChd0sstybx61SBkYKHAC8NkJmQJ0OvujE0dK34U0ERhbXmJ8hQ9v62w7fraI0sRpGq5aqDLQHu90yxtfBTatqgHGxiVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kiL0W4w8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kiL0W4w8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F420D1F000E9;
	Tue, 16 Jun 2026 16:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627067;
	bh=2GjyZCyVf7iO96XdjM8uY2uzTYZdASwpzObOeQh5J5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kiL0W4w8H9HvCHkopgHX1tBJiNDrN9d5xUeDsy/3M8+/6RCk9RaPrk19ko2dOhCK+
	 O2LqOudmEx2zI1B/hOFz8XjtF7HIOqJc6SrjoUG2JMsSGqvD4vagIZsPxR7AjvYeM/
	 Q3FJ1mA1FNSMG5BRByE/5cgwxbuoMjlnAbOggTag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/261] netfilter: revalidate bridge ports
Date: Tue, 16 Jun 2026 20:28:55 +0530
Message-ID: <20260616145049.534848482@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit ccb9fd4b87538ccf19ccff78ee26700526d94867 ]

ebt_redirect_tg() dereferences br_port_get_rcu() return without a
NULL check, causing a kernel panic when the bridge port has been
removed between the original hook invocation and an NFQUEUE
reinject.

A mere NULL check isn't sufficient, however.  As sashiko review
points out userspace can not only remove the port from the bridge,
it could also place the device in a different virtual device, e.g.
macvlan.

If this happens, we must drop the packet, there is no way for us to
reinject it into the bridge path.

Switch to _upper API, we don't need the bridge port structure.
Also, this fix keeps another bug intact:

Both nfnetlink_log and nfnetlink_queue use CONFIG_BRIDGE_NETFILTER
too aggressive, which prevents certain logging features when queueing
in bridge family: NETFILTER_FAMILY_BRIDGE can be enabled while the old
CONFIG_BRIDGE_NETFILTER cruft is off.

Fixes tag is a common ancestor, this was always broken.

Fixes: f350a0a87374 ("bridge: use rx_handler_data pointer to store net_bridge_port pointer")
Reported-by: Ji'an Zhou <eilaimemedsnaimel@gmail.com>
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebt_dnat.c     |  4 +-
 net/bridge/netfilter/ebt_redirect.c | 16 +++++---
 net/netfilter/nfnetlink_log.c       | 23 +++++++++--
 net/netfilter/nfnetlink_queue.c     | 64 +++++++++++++++++++++++++----
 4 files changed, 89 insertions(+), 18 deletions(-)

diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 3fda71a8579d13..73f185cccd63df 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -39,7 +39,9 @@ ebt_dnat_tg(struct sk_buff *skb, const struct xt_action_param *par)
 			dev = xt_in(par);
 			break;
 		case NF_BR_PRE_ROUTING:
-			dev = br_port_get_rcu(xt_in(par))->br->dev;
+			dev = netdev_master_upper_dev_get_rcu(xt_in(par));
+			if (!dev) /* bridge port removed? */
+				return EBT_DROP;
 			break;
 		default:
 			dev = NULL;
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 307790562b4929..83486cd4d564b1 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -24,12 +24,18 @@ ebt_redirect_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	if (skb_ensure_writable(skb, 0))
 		return EBT_DROP;
 
-	if (xt_hooknum(par) != NF_BR_BROUTING)
-		/* rcu_read_lock()ed by nf_hook_thresh */
-		ether_addr_copy(eth_hdr(skb)->h_dest,
-				br_port_get_rcu(xt_in(par))->br->dev->dev_addr);
-	else
+	if (xt_hooknum(par) != NF_BR_BROUTING) {
+		const struct net_device *dev;
+
+		dev = netdev_master_upper_dev_get_rcu(xt_in(par));
+		if (!dev)
+			return EBT_DROP;
+
+		ether_addr_copy(eth_hdr(skb)->h_dest, dev->dev_addr);
+	} else {
 		ether_addr_copy(eth_hdr(skb)->h_dest, xt_in(par)->dev_addr);
+	}
+
 	skb->pkt_type = PACKET_HOST;
 	return info->target;
 }
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 3da32d2f68e092..cfd68bc005d26b 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -450,6 +450,23 @@ static int nfulnl_put_bridge(struct nfulnl_instance *inst, const struct sk_buff
 	return -1;
 }
 
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+static int nflog_put_master_ifindex(struct sk_buff *nlskb, int attr,
+				    const struct net_device *dev)
+{
+	const struct net_device *upper;
+
+	if (dev && !netif_is_bridge_port(dev))
+		return 0;
+
+	upper = netdev_master_upper_dev_get_rcu((struct net_device *)dev);
+	if (upper && nla_put_be32(nlskb, attr, htonl(upper->ifindex)))
+		return -EMSGSIZE;
+
+	return 0;
+}
+#endif
+
 /* This is an inline function, we don't really care about a long
  * list of arguments */
 static inline int
@@ -504,8 +521,7 @@ __build_packet_message(struct nfnl_log_net *log,
 			/* rcu_read_lock()ed by nf_hook_thresh or
 			 * nf_log_packet.
 			 */
-			    nla_put_be32(inst->skb, NFULA_IFINDEX_INDEV,
-					 htonl(br_port_get_rcu(indev)->br->dev->ifindex)))
+			    nflog_put_master_ifindex(inst->skb, NFULA_IFINDEX_INDEV, indev))
 				goto nla_put_failure;
 		} else {
 			int physinif;
@@ -541,8 +557,7 @@ __build_packet_message(struct nfnl_log_net *log,
 			/* rcu_read_lock()ed by nf_hook_thresh or
 			 * nf_log_packet.
 			 */
-			    nla_put_be32(inst->skb, NFULA_IFINDEX_OUTDEV,
-					 htonl(br_port_get_rcu(outdev)->br->dev->ifindex)))
+			    nflog_put_master_ifindex(inst->skb, NFULA_IFINDEX_OUTDEV, outdev))
 				goto nla_put_failure;
 		} else {
 			struct net_device *physoutdev;
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 8518b620ae50ed..1b517cd2bb58cc 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -426,10 +426,47 @@ static bool nf_ct_drop_unconfirmed(const struct nf_queue_entry *entry, bool *is_
 	return false;
 }
 
+static bool nf_bridge_port_valid(const struct net_device *dev)
+{
+	if (!dev)
+		return true;
+
+	return netif_is_bridge_port(dev);
+}
+
+/* queued skbs leave rcu protection.  We bump device refcount so that
+ * the device cannot go away.  However, while packet was out the port
+ * could have been removed from the bridge.
+ *
+ * Ensure in+outdev are still part of a bridge at reinject time.
+ *
+ * The device rx_handler_data could even be pointing at data that is
+ * not a net_bridge_port structure.
+ */
+static bool nf_bridge_ports_valid(const struct nf_queue_entry *entry)
+{
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	if (!nf_bridge_port_valid(entry->physin) ||
+	    !nf_bridge_port_valid(entry->physout))
+		return false;
+#endif
+	if (entry->state.pf != PF_BRIDGE)
+		return true;
+
+	if (!nf_bridge_port_valid(entry->state.in) ||
+	    !nf_bridge_port_valid(entry->state.out))
+		return false;
+
+	return true;
+}
+
 static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 {
 	const struct nf_ct_hook *ct_hook;
 
+	if (!nf_bridge_ports_valid(entry))
+		verdict = NF_DROP;
+
 	if (verdict == NF_ACCEPT ||
 	    verdict == NF_REPEAT ||
 	    verdict == NF_STOP) {
@@ -622,6 +659,23 @@ static int nf_queue_checksum_help(struct sk_buff *entskb)
 	return skb_checksum_help(entskb);
 }
 
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+static int nfqnl_put_master_ifindex(struct sk_buff *nlskb, int attr,
+				    const struct net_device *dev)
+{
+	const struct net_device *upper;
+
+	if (dev && !netif_is_bridge_port(dev))
+		return 0;
+
+	upper = netdev_master_upper_dev_get_rcu((struct net_device *)dev);
+	if (upper && nla_put_be32(nlskb, attr, htonl(upper->ifindex)))
+		return -EMSGSIZE;
+
+	return 0;
+}
+#endif
+
 static struct sk_buff *
 nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 			   struct nf_queue_entry *entry,
@@ -755,10 +809,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 			 * netfilter_bridge) */
 			if (nla_put_be32(skb, NFQA_IFINDEX_PHYSINDEV,
 					 htonl(indev->ifindex)) ||
-			/* this is the bridge group "brX" */
-			/* rcu_read_lock()ed by __nf_queue */
-			    nla_put_be32(skb, NFQA_IFINDEX_INDEV,
-					 htonl(br_port_get_rcu(indev)->br->dev->ifindex)))
+			    nfqnl_put_master_ifindex(skb, NFQA_IFINDEX_INDEV, indev))
 				goto nla_put_failure;
 		} else {
 			int physinif;
@@ -789,10 +840,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 			 * netfilter_bridge) */
 			if (nla_put_be32(skb, NFQA_IFINDEX_PHYSOUTDEV,
 					 htonl(outdev->ifindex)) ||
-			/* this is the bridge group "brX" */
-			/* rcu_read_lock()ed by __nf_queue */
-			    nla_put_be32(skb, NFQA_IFINDEX_OUTDEV,
-					 htonl(br_port_get_rcu(outdev)->br->dev->ifindex)))
+			    nfqnl_put_master_ifindex(skb, NFQA_IFINDEX_OUTDEV, outdev))
 				goto nla_put_failure;
 		} else {
 			int physoutif;
-- 
2.53.0



