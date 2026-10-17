Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AF43A7F4D;
	Sat, 17 Oct 2026 18:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260507; cv=none; b=MgIGvqk3uWV2oniv+FVwqblzXDvjKntab6h7qbugzEhXLs9jxoN1UOSVkQxggV2Hh5tbbUlpw+hvgrFJ+a/vzCyhtlPMOcOFM2Ougl0jtdt/+eZAU2aJtuj13T2QeM8wAptu2OULOSK/yzlHK+xGEJRV3lnDNWAhz5Ky/pkTTOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260507; c=relaxed/simple;
	bh=a5dqQuJ10ULsQ+tllw0AlFvM4Cify/+dnoWnborgBSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXQc+XwUTDnJ5P1HQMAcb+PY9XXFdLC0F09TXS9AiHJcXLPF4anPe5vEfz4jReJIiGs2IgsODljCastQf3uYFt6wwYKRlhi3LO7cOWVtNYuqAbVLgSbFnQymsaZay7Zqg2VNkx8L8Ph0lsSHcz/tcKbBjuH0oC+kadScV1OZaLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B7n3LfiW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7n3LfiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACC71F000C4;
	Sat, 17 Oct 2026 18:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260505;
	bh=Mb7i8ExHY6nf648ES4Rye1CPZ9JdQjYnL3hWCHg6SUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B7n3LfiW4Uynk2RX10icVg9itVg1Veb1vWHgemLNubeTY3EF6ZN24wb+XXm+OZFr3
	 C6dVjnLUZuprX2IME2mMeXUQZIvpBG2Qz/eG8CvA5Vs3N09fXxSYFbARSO2fAeO51Z
	 YMQNyGI81L9EdvZ3Tazw4x39XLSqSYpGxxvuwbU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1567/1674] netfilter: revalidate bridge ports
Date: Sat, 17 Oct 2026 18:03:59 +0200
Message-ID: <20261017160511.323735742@linuxfoundation.org>
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
index 3fda71a8579d1..73f185cccd63d 100644
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
index 307790562b492..83486cd4d564b 100644
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
index abae76685a048..c0c8935dbcbb6 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -455,6 +455,23 @@ static int nfulnl_put_bridge(struct nfulnl_instance *inst, const struct sk_buff
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
@@ -509,8 +526,7 @@ __build_packet_message(struct nfnl_log_net *log,
 			/* rcu_read_lock()ed by nf_hook_thresh or
 			 * nf_log_packet.
 			 */
-			    nla_put_be32(inst->skb, NFULA_IFINDEX_INDEV,
-					 htonl(br_port_get_rcu(indev)->br->dev->ifindex)))
+			    nflog_put_master_ifindex(inst->skb, NFULA_IFINDEX_INDEV, indev))
 				goto nla_put_failure;
 		} else {
 			int physinif;
@@ -546,8 +562,7 @@ __build_packet_message(struct nfnl_log_net *log,
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
index 56c16fa0ba227..719f7b009a68a 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -253,11 +253,48 @@ static bool nf_ct_drop_unconfirmed(const struct nf_queue_entry *entry, bool *is_
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
 	int err;
 
+	if (!nf_bridge_ports_valid(entry))
+		verdict = NF_DROP;
+
 	if (verdict == NF_ACCEPT ||
 	    verdict == NF_REPEAT ||
 	    verdict == NF_STOP) {
@@ -446,6 +483,23 @@ static int nf_queue_checksum_help(struct sk_buff *entskb)
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
@@ -579,10 +633,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
@@ -613,10 +664,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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



