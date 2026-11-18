Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033127;
	b=X1okJlOiLyX9Mm2QyO4F5KvjAcY13ozee6wSUVHayhaD9JDT1RT1f8wQOp7OA5BB+LRT
	 LqwSKOpRvkM0bviyoRiIHbE07pzQ6+1d3seKEwErFC7CbnrNhJyWArZ588vieJFAALLNi
	 vcrTeubfRgkgWWmiAbEvs4us7NI+Rd21316vokMeEY+9Uic6QjK3h6BVSaIJHsNk/GJQT
	 HalsqtYiA+Lfs1WTEVJbFi6xkrLJsTB08fEXrJmxXL3TYg1Fr0I59XNHUFlBvpIHAyxci
	 ey5XnOqbj9WmyT4vi2zqHuihb2lfG9GNhzVi08ceFPX9Lj4J2fr1HcOGwkeqSzwcvqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GqzoQBvm2H8U+j0EaKJQCxScNsNMnLEqHAS9I+Q/l/A=;
	b=2aN0Fq4/Km40dQ9PUi99T5bn7GQ4eFbKAn1TQf/OiXCNuC9KQx5UCZjwo/iWV9zF3OF2
	 +fPLAx/TFLdZNjGj+I7wqOX/rvoYDwlKtfxFBOLNxx/yKRH31pAcFyOAO4FHBNHBPYNb9
	 NtcZ5Hn49d0GrTfu5UNLzPTHWejoPoqN9zur7tuU/LMIlP1RZgE3A0HFfVZLePpSPUuB5
	 V6gtySjVnx8Dpb5aAJL3Yo1sUSHBxvTPIcO9mmgePTxNi9P00b8BpYpUghlt35czbjb+Z
	 mD2ZvEPPX6UTSU76vdE8XdFfyvcfvKQpnUZPScP6TPBzbuu/KqETM8X4wNj4E9aGoVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SdatAlB3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766F2606A320;
	Wed, 18 Nov 2026 20:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SdatAlB3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE601F000C4;
	Wed, 18 Nov 2026 20:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033127;
	bh=GqzoQBvm2H8U+j0EaKJQCxScNsNMnLEqHAS9I+Q/l/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SdatAlB3ZdHZJ5UbfZzB0JZFa63zyScrXmzUxmV3WaFX9rpBY32IIN5wvGQcyNw3v
	 rK8uYp8ldB5gCy1L6t6Thr36pPWdRUx3K5J0Vdo0N4B8C+aPSdZW3FMLcPNrfjWZx5
	 biv2ESIqyCzsFlxjQ3gfDRTY+GHVJ+0VbeL4GrVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1658/1756] net: bridge: use atomic ops to read/change p->flags (III)
Date: Wed, 18 Nov 2026 16:03:05 +0100
Message-ID: <20261118150115.723874397@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f76ae12b6ba3530590e151a18dca51d90c5d81d4 ]

Use test_bit(), clear_bit(), set_bit() in:

   net/bridge/br_multicast.c
   net/bridge/br_netlink.c
   net/bridge/br_stp.c
   net/bridge/br_stp_bpdu.c
   net/bridge/br_switchdev.c
   net/bridge/br_vlan_options.c

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260611203453.3067462-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: fcc00b15cb21 ("net: bridge: netlink: do not clear the vlan info dump error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_multicast.c    | 5 +++--
 net/bridge/br_netlink.c      | 2 +-
 net/bridge/br_stp.c          | 4 ++--
 net/bridge/br_stp_bpdu.c     | 2 +-
 net/bridge/br_switchdev.c    | 8 ++++----
 net/bridge/br_vlan_options.c | 2 +-
 6 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 7d1b64df94c92..5dfe4732bbeb0 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -285,7 +285,7 @@ static bool br_port_group_equal(struct net_bridge_port_group *p,
 	if (p->key.port != port)
 		return false;
 
-	if (!(port->flags & BR_MULTICAST_TO_UNICAST))
+	if (!test_bit(BR_MULTICAST_TO_UNICAST_BIT, &port->flags))
 		return true;
 
 	return ether_addr_equal(src, p->eth_addr);
@@ -3705,7 +3705,8 @@ br_multicast_leave_group(struct net_bridge_mcast *brmctx,
 	if (!mp)
 		goto out;
 
-	if (pmctx && (pmctx->port->flags & BR_MULTICAST_FAST_LEAVE)) {
+	if (pmctx &&
+	    test_bit(BR_MULTICAST_FAST_LEAVE_BIT, &pmctx->port->flags)) {
 		struct net_bridge_port_group __rcu **pp;
 
 		for (pp = &mp->ports;
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 6b97ae47f8552..deba331537fbe 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -534,7 +534,7 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 		else
 			err = br_fill_ifvlaninfo(skb, vg);
 
-		if (port && (port->flags & BR_VLAN_TUNNEL))
+		if (port && test_bit(BR_VLAN_TUNNEL_BIT, &port->flags))
 			err = br_fill_vlan_tunnel_info(skb, vg);
 		rcu_read_unlock();
 		if (err)
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 4cfebf5fcdf54..95484b05b6c38 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -39,7 +39,7 @@ void br_set_state(struct net_bridge_port *p, unsigned int state)
 	/* Don't change the state of the ports if they are driven by a different
 	 * protocol.
 	 */
-	if (p->flags & BR_MRP_AWARE)
+	if (test_bit(BR_MRP_AWARE_BIT, &p->flags))
 		return;
 
 	p->state = state;
@@ -173,7 +173,7 @@ static void br_root_selection(struct net_bridge *br)
 		if (!br_should_become_root_port(p, root_port))
 			continue;
 
-		if (p->flags & BR_ROOT_BLOCK)
+		if (test_bit(BR_ROOT_BLOCK_BIT, &p->flags))
 			br_root_port_block(br, p);
 		else
 			root_port = p->port_no;
diff --git a/net/bridge/br_stp_bpdu.c b/net/bridge/br_stp_bpdu.c
index e44e448b1157b..21d092f5acbb8 100644
--- a/net/bridge/br_stp_bpdu.c
+++ b/net/bridge/br_stp_bpdu.c
@@ -181,7 +181,7 @@ void br_stp_rcv(const struct stp_proto *proto, struct sk_buff *skb,
 	if (!ether_addr_equal(eth_hdr(skb)->h_dest, br->group_addr))
 		goto out;
 
-	if (p->flags & BR_BPDU_GUARD) {
+	if (test_bit(BR_BPDU_GUARD_BIT, &p->flags)) {
 		br_notice(br, "BPDU received on blocked port %u(%s)\n",
 			  (unsigned int) p->port_no, p->dev->name);
 		br_stp_disable_port(p);
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 40bb8e6989137..58ac99b08f2ec 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -20,7 +20,7 @@ static bool nbp_switchdev_can_offload_tx_fwd(const struct net_bridge_port *p,
 	if (br_multicast_igmp_type(skb))
 		return false;
 
-	return (p->flags & BR_TX_FWD_OFFLOAD) &&
+	return test_bit(BR_TX_FWD_OFFLOAD_BIT, &p->flags) &&
 	       (p->hwdom != BR_INPUT_SKB_CB(skb)->src_hwdom);
 }
 
@@ -288,7 +288,7 @@ static int nbp_switchdev_add(struct net_bridge_port *p,
 		return err;
 
 	if (tx_fwd_offload) {
-		p->flags |= BR_TX_FWD_OFFLOAD;
+		set_bit(BR_TX_FWD_OFFLOAD_BIT, &p->flags);
 		static_branch_inc(&br_switchdev_tx_fwd_offload);
 	}
 
@@ -308,8 +308,8 @@ static void nbp_switchdev_del(struct net_bridge_port *p)
 	if (p->hwdom)
 		nbp_switchdev_hwdom_put(p);
 
-	if (p->flags & BR_TX_FWD_OFFLOAD) {
-		p->flags &= ~BR_TX_FWD_OFFLOAD;
+	if (test_bit(BR_TX_FWD_OFFLOAD_BIT, &p->flags)) {
+		clear_bit(BR_TX_FWD_OFFLOAD_BIT, &p->flags);
 		static_branch_dec(&br_switchdev_tx_fwd_offload);
 	}
 }
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 4a736e005bad7..8025d421b457a 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -148,7 +148,7 @@ static int br_vlan_modify_tunnel(const struct net_bridge_port *p,
 		NL_SET_ERR_MSG_MOD(extack, "Can't modify tunnel mapping of non-port vlans");
 		return -EINVAL;
 	}
-	if (!(p->flags & BR_VLAN_TUNNEL)) {
+	if (!test_bit(BR_VLAN_TUNNEL_BIT, &p->flags)) {
 		NL_SET_ERR_MSG_MOD(extack, "Port doesn't have tunnel flag set");
 		return -EINVAL;
 	}
-- 
2.53.0



