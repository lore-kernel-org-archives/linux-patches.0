Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028798;
	b=PT1/jzzcQQj609G2X9qPd9t3yUfD2dCUj6QciaQawD7ztmeAei9Emi9oN/qN7AtbZs1r
	 MksufcoRioy2+w7G7G7rbNex4ktAvCTfmOFxCRlL6bxc9j6E3s2KIqe9TeSc4jQ+adBpb
	 PatlW87Nt6ZStv3pXuaXCFw7IV2L4ob+nCIp7C8QwE/d09KLkni/8rx86VHtbwxhHKDMV
	 5rdiWtNWZDPEev/Fm3lcIeKbHywebpPvTabozb++/aEC8ls1ftJrKlD6iuEsRo2WJdKnb
	 IDJ9iwyIQacV3hEl2CooEZEuDDgZXYd6Jz6j6JYAbKlfRGLYo2SHw051zt+Kr9sYLag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C3V4Fg7Jr7eZIQhH9AhGVhcRGgso61bDHS8ojxg/tcY=;
	b=gEQMPIdz0JMbJ8pI0ZM5eD4bR3RjWcnxsBW7xhKkf+qV3pikuLi81+78wtKYK1xGe4KF
	 JSc+NKBGWmmQS025rF7u0jn4QrC39eYeg3DgnnKqAXUiCYos0XAHliACuv9pGuQ6lEN2Z
	 OLZVOWJdFnsttVbZuWdih7Y4/uPYNYAfhOA1x5qaB6TzrLnBLNO4SKdPd+utqftBtqXnJ
	 QEswQuk6l0y2r3QCYZ946n21IDleOpmgLEQC4JLASgq4S6cOzI5FnBGKdkibxdUX1Qds3
	 N0BTux8rzfuC3EmqefUDikYxuS0SsrXEosNb4312MWYbV+kfyeaF6Slh+eG5tIyR8Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BdiQp+cx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CFA606A32A;
	Wed, 18 Nov 2026 19:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BdiQp+cx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A40D1F000C4;
	Wed, 18 Nov 2026 19:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028798;
	bh=C3V4Fg7Jr7eZIQhH9AhGVhcRGgso61bDHS8ojxg/tcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BdiQp+cxS+HN7+esshCF1+YbQwT8dJzVABOt/HQx8HOzZV6C6s54Q0xqopTOo2XQP
	 zQnqMFDTs9GiMzx/zVphzKSFqT8Dqn0j/hBPRXaIMKrc4lqk2qnvL36oHKn+EzJond
	 vIre9jpg71QPT7g2wRIpohrZ37fGBSWKZljvjniE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Antonio Quartulli <antonio@mandelbit.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0124/1756] netfilter: flowtable: ensure sufficient headroom in xmit path
Date: Wed, 18 Nov 2026 15:37:31 +0100
Message-ID: <20261118150013.115736498@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit ef4f741e8627512cb8c82f59a1fc7aacd854aadf upstream.

Check for headroom and call skb_expand_head() like in the IP output
path to ensure there is sufficient headroom for the mac header when
forwarding this packet as suggested by sashiko.

Fixes: b5964aac51e0 ("netfilter: flowtable: consolidate xmit path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[ aq: the upstream commit does not apply to 6.12: 6.12 predates
  b5964aac51e0, and FLOW_OFFLOAD_XMIT_NEIGH flows are still sent through
  neigh_xmit() from nf_flow_offload_ip_hook() and
  nf_flow_offload_ipv6_hook(). Do the same headroom check there, before
  skb->dev is switched to the output device, and in nf_flow_queue_xmit().

  Without it, a forwarded skb reaches the output device's
  header_ops->create() with only the headroom it was received with. A
  UDP socket behind a veth (e.g. a container) leaves 16 bytes; virtio_net
  leaves 26 for frames larger than GOOD_COPY_LEN. GRE, ip6gre and VLAN
  have since been hardened individually, 6LoWPAN has not:
  lowpan_header_create() stores struct lowpan_addr_info (32 bytes) in
  front of skb->data after a mere WARN_ON_ONCE(), i.e. an out-of-bounds
  write before the skb head. Seen on v6.12.117 with IPv6 forwarded by a
  flowtable from a veth to a 6LoWPAN interface:

    WARNING: CPU: 1 PID: 4719 at net/ieee802154/6lowpan/tx.c:21 lowpan_header_create+0x165/0x1b0 [ieee802154_6lowpan]
    Call Trace:
     neigh_connected_output+0xa3/0xf0
     neigh_xmit+0xbb/0x210
     nf_flow_offload_ipv6_hook+0x540/0x7c0
     nf_hook_slow+0x39/0xe0
     __netif_receive_skb_core.constprop.0+0xe4c/0x1010
     __netif_receive_skb_one_core+0x37/0xa0
     process_backlog+0x77/0x140

  Before e67c577d8989 ("ipv4: ip_gre: make ipgre_header() robust") the
  same path panicked with multipoint GRE (DMVPN) output devices:
  skb_under_panic in ipgre_header() via nf_flow_offload_ip_hook(). ]
Fixes: 97add9f0d66d ("netfilter: flow table support for IPv4")
Fixes: 0995210753a2 ("netfilter: flow table support for IPv6")
Fixes: 7a27f6ab4135 ("netfilter: flowtable: use dev_fill_forward_path() to obtain egress device")
Link: https://vyos.dev/T7549
Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_ip.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index e9d960a1180b8..617f3cb81af11 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -330,6 +330,22 @@ static void nf_flow_encap_pop(struct sk_buff *skb,
 	}
 }
 
+/* Make room for the link layer header of @dev, like ip_finish_output2() does.
+ * The flowtable fast path skips the IP output path, and a device with
+ * header_ops (e.g. an NBMA GRE tunnel) may need more headroom than the skb
+ * was received with. On failure the skb has been freed.
+ */
+static struct sk_buff *nf_flow_xmit_headroom(struct sk_buff *skb,
+					     struct net_device *dev)
+{
+	unsigned int hh_len = LL_RESERVED_SPACE(dev);
+
+	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops))
+		skb = skb_expand_head(skb, hh_len);
+
+	return skb;
+}
+
 static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 				       const struct flow_offload_tuple_rhash *tuplehash,
 				       unsigned short type)
@@ -340,6 +356,10 @@ static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 	if (!outdev)
 		return NF_DROP;
 
+	skb = nf_flow_xmit_headroom(skb, outdev);
+	if (!skb)
+		return NF_STOLEN;
+
 	skb->dev = outdev;
 	dev_hard_header(skb, skb->dev, type, tuplehash->tuple.out.h_dest,
 			tuplehash->tuple.out.h_source, skb->len);
@@ -452,6 +472,9 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rtable(tuplehash->tuple.dst_cache);
 		outdev = rt->dst.dev;
+		skb = nf_flow_xmit_headroom(skb, outdev);
+		if (!skb)
+			return NF_STOLEN;
 		skb->dev = outdev;
 		nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
 		skb_dst_drop(skb);
@@ -748,6 +771,9 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
 		outdev = rt->dst.dev;
+		skb = nf_flow_xmit_headroom(skb, outdev);
+		if (!skb)
+			return NF_STOLEN;
 		skb->dev = outdev;
 		nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
 		skb_dst_drop(skb);
-- 
2.53.0



