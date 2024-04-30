Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB3212C461;
	Tue, 30 Apr 2024 10:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473719; cv=none; b=jiDwqmrN5Uz6j+jo1546XccAyNWWuTia8bSxh7aYHDk3m5rWFa39YPzPTZb0q4Jq03YI4utz0CXEbzPeYcIfZ7ukDWi963j5HzcR6cl7JsyrlRc8XbuRtcYLj/yGyVA12g8vJe7p2K9ZGHNmIek/Nm7vZrh+tZls3TuFb5bK71U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473719; c=relaxed/simple;
	bh=xQrmP4PA57/0H7Md8nkzWWGWtcMpqawG/BO9VEPjcc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/WyT1UfvBgpPrjMd8q44Rm7Z6bpR7WuFq4B4lHxSDmZonkqXsJHG6HooEgjWrkBF+MhQ0kAeGgLYGyikA6OVqADObUR9roOKoIRTFAJM9y5VGSK72E4Wk0Iik8PqukVQw5jWaN4XHEZk5TJEJOH/Zvyx6Pvb+97k3rnmyBuB5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A00XqGZ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A00XqGZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1427DC2BBFC;
	Tue, 30 Apr 2024 10:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473719;
	bh=xQrmP4PA57/0H7Md8nkzWWGWtcMpqawG/BO9VEPjcc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A00XqGZ9e6qqm9XeQpLbPh9QNNm0T75rXws7k/VIaCty93u1cdRuHYhYItRv8qcBH
	 9WiUpCERpjtpbkA+5WHYyklvqjow34VPyZL4P6UNB9WOWZvgyPwe8X8q0jhMU/5/ot
	 rUSKihyP6T69CQeLgfgQiS58Cw56v+njQURPxbZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9ee20ec1de7b3168db09@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Phillip Potter <phil@philpotter.co.uk>,
	Sabrina Dubroca <sd@queasysnail.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/77] geneve: fix header validation in geneve[6]_xmit_skb
Date: Tue, 30 Apr 2024 12:38:43 +0200
Message-ID: <20240430103041.247832358@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d8a6213d70accb403b82924a1c229e733433a5ef ]

syzbot is able to trigger an uninit-value in geneve_xmit() [1]

Problem : While most ip tunnel helpers (like ip_tunnel_get_dsfield())
uses skb_protocol(skb, true), pskb_inet_may_pull() is only using
skb->protocol.

If anything else than ETH_P_IPV6 or ETH_P_IP is found in skb->protocol,
pskb_inet_may_pull() does nothing at all.

If a vlan tag was provided by the caller (af_packet in the syzbot case),
the network header might not point to the correct location, and skb
linear part could be smaller than expected.

Add skb_vlan_inet_prepare() to perform a complete mac validation.

Use this in geneve for the moment, I suspect we need to adopt this
more broadly.

v4 - Jakub reported v3 broke l2_tos_ttl_inherit.sh selftest
   - Only call __vlan_get_protocol() for vlan types.
Link: https://lore.kernel.org/netdev/20240404100035.3270a7d5@kernel.org/

v2,v3 - Addressed Sabrina comments on v1 and v2
Link: https://lore.kernel.org/netdev/Zg1l9L2BNoZWZDZG@hog/

[1]

BUG: KMSAN: uninit-value in geneve_xmit_skb drivers/net/geneve.c:910 [inline]
 BUG: KMSAN: uninit-value in geneve_xmit+0x302d/0x5420 drivers/net/geneve.c:1030
  geneve_xmit_skb drivers/net/geneve.c:910 [inline]
  geneve_xmit+0x302d/0x5420 drivers/net/geneve.c:1030
  __netdev_start_xmit include/linux/netdevice.h:4903 [inline]
  netdev_start_xmit include/linux/netdevice.h:4917 [inline]
  xmit_one net/core/dev.c:3531 [inline]
  dev_hard_start_xmit+0x247/0xa20 net/core/dev.c:3547
  __dev_queue_xmit+0x348d/0x52c0 net/core/dev.c:4335
  dev_queue_xmit include/linux/netdevice.h:3091 [inline]
  packet_xmit+0x9c/0x6c0 net/packet/af_packet.c:276
  packet_snd net/packet/af_packet.c:3081 [inline]
  packet_sendmsg+0x8bb0/0x9ef0 net/packet/af_packet.c:3113
  sock_sendmsg_nosec net/socket.c:730 [inline]
  __sock_sendmsg+0x30f/0x380 net/socket.c:745
  __sys_sendto+0x685/0x830 net/socket.c:2191
  __do_sys_sendto net/socket.c:2203 [inline]
  __se_sys_sendto net/socket.c:2199 [inline]
  __x64_sys_sendto+0x125/0x1d0 net/socket.c:2199
 do_syscall_64+0xd5/0x1f0
 entry_SYSCALL_64_after_hwframe+0x6d/0x75

Uninit was created at:
  slab_post_alloc_hook mm/slub.c:3804 [inline]
  slab_alloc_node mm/slub.c:3845 [inline]
  kmem_cache_alloc_node+0x613/0xc50 mm/slub.c:3888
  kmalloc_reserve+0x13d/0x4a0 net/core/skbuff.c:577
  __alloc_skb+0x35b/0x7a0 net/core/skbuff.c:668
  alloc_skb include/linux/skbuff.h:1318 [inline]
  alloc_skb_with_frags+0xc8/0xbf0 net/core/skbuff.c:6504
  sock_alloc_send_pskb+0xa81/0xbf0 net/core/sock.c:2795
  packet_alloc_skb net/packet/af_packet.c:2930 [inline]
  packet_snd net/packet/af_packet.c:3024 [inline]
  packet_sendmsg+0x722d/0x9ef0 net/packet/af_packet.c:3113
  sock_sendmsg_nosec net/socket.c:730 [inline]
  __sock_sendmsg+0x30f/0x380 net/socket.c:745
  __sys_sendto+0x685/0x830 net/socket.c:2191
  __do_sys_sendto net/socket.c:2203 [inline]
  __se_sys_sendto net/socket.c:2199 [inline]
  __x64_sys_sendto+0x125/0x1d0 net/socket.c:2199
 do_syscall_64+0xd5/0x1f0
 entry_SYSCALL_64_after_hwframe+0x6d/0x75

CPU: 0 PID: 5033 Comm: syz-executor346 Not tainted 6.9.0-rc1-syzkaller-00005-g928a87efa423 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/29/2024

Fixes: d13f048dd40e ("net: geneve: modify IP header check in geneve6_xmit_skb and geneve_xmit_skb")
Reported-by: syzbot+9ee20ec1de7b3168db09@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/000000000000d19c3a06152f9ee4@google.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Phillip Potter <phil@philpotter.co.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c     |  4 ++--
 include/net/ip_tunnels.h | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 8aa04b37c5fe0..d25879c1657d0 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -852,7 +852,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 df;
 	int err;
 
-	if (!pskb_inet_may_pull(skb))
+	if (!skb_vlan_inet_prepare(skb))
 		return -EINVAL;
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
@@ -898,7 +898,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
-	if (!pskb_inet_may_pull(skb))
+	if (!skb_vlan_inet_prepare(skb))
 		return -EINVAL;
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index bc2ae8ce5bd45..570287d3564bb 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -346,6 +346,39 @@ static inline bool pskb_inet_may_pull(struct sk_buff *skb)
 	return pskb_network_may_pull(skb, nhlen);
 }
 
+/* Variant of pskb_inet_may_pull().
+ */
+static inline bool skb_vlan_inet_prepare(struct sk_buff *skb)
+{
+	int nhlen = 0, maclen = ETH_HLEN;
+	__be16 type = skb->protocol;
+
+	/* Essentially this is skb_protocol(skb, true)
+	 * And we get MAC len.
+	 */
+	if (eth_type_vlan(type))
+		type = __vlan_get_protocol(skb, type, &maclen);
+
+	switch (type) {
+#if IS_ENABLED(CONFIG_IPV6)
+	case htons(ETH_P_IPV6):
+		nhlen = sizeof(struct ipv6hdr);
+		break;
+#endif
+	case htons(ETH_P_IP):
+		nhlen = sizeof(struct iphdr);
+		break;
+	}
+	/* For ETH_P_IPV6/ETH_P_IP we make sure to pull
+	 * a base network header in skb->head.
+	 */
+	if (!pskb_may_pull(skb, maclen + nhlen))
+		return false;
+
+	skb_set_network_header(skb, maclen);
+	return true;
+}
+
 static inline int ip_encap_hlen(struct ip_tunnel_encap *e)
 {
 	const struct ip_tunnel_encap_ops *ops;
-- 
2.43.0



