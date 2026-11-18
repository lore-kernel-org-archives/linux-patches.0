Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039086;
	b=deGTnGPYd6yatk5SL3VllOn+CXgjN1iYPrQRyJ1UehRCSZee1Ug4jyrG6AdcZjJMq7tr
	 hlvPloLeC+t+Y2RwrUy1+nmTQyJKRDBS8nmQab5pdLHVl3rkWliOiuZcQAsAsV0qT2yIW
	 d+fTYyHXecXwmLyrKxe7SWfenVDrNdFj5+l638Q6wvsaWVfG+w9M0k7E+fyEjCSu48wio
	 /d/mwk1LGroDXcPiknSxTbLVLbTbDjbsT5WuzHw6z/HQk45TACsDd2rx8Veh/KSQhcxaM
	 c1G7icZvKClUlzq9JG3eypNr4e6gaZ4kPlKy4BxScvTKkOCsdPtdK3rREfDYTrHLGcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z9oNzdxotbbX3l6Bn85bexdYBbKMDV+LvpkJBk4x4wM=;
	b=wGLfjkqP4cpCmAfCQ1RPXpunLgosR5Gn/939MFr4gahd/rVMYxwsxEUOQSrRPRZXBgD4
	 A3bdnB21XRe0mi4Rx0CaCpTLXYXu2zCAiUdkgHEVTC6BEHnyDHNFJgOZFSGg/JJCn8qdL
	 K2apFp4RMesXXiHawhcQXJJHiUujteon4WA0KexSwGdS5Cvjatz8F5k2DwsbwRd4ZPbae
	 rYZOHKRcRq05PrDaGq2sRy4zHdczRFXCFLffos0Vvpx+dDPRwlUi3F2umDYlPvC3uX9px
	 /BJ/S/PR9fVf0IHRaCqy7xme8+QT/Ba89tIlnNEjnTm/QjWlw4iLbLI5rrIDg3Qn1+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZlwGOi0Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73F5606A331;
	Wed, 18 Nov 2026 21:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZlwGOi0Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8051F000C5;
	Wed, 18 Nov 2026 21:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039086;
	bh=z9oNzdxotbbX3l6Bn85bexdYBbKMDV+LvpkJBk4x4wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZlwGOi0Y6+Wpt4p9shQAcYqWrXKlRvn/KqyJU7CCyWSiwfqCcinWRZdb9+zaXIZOJ
	 H0lSGmUkVvRKOmzIicb5KDiAyXTahxwFx3n2qusb7YWtzaSLSNlEeHihiKLSc/BBrZ
	 FxhNnjpnQsTAyKWjX8VrLAHm9ogzHQzEyM+pTvmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Antonio Quartulli <antonio@mandelbit.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1975/3318] netfilter: flowtable: ensure sufficient headroom in xmit path
Date: Wed, 18 Nov 2026 15:43:17 +0100
Message-ID: <20261118150421.332378725@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit ef4f741e8627512cb8c82f59a1fc7aacd854aadf upstream.

Check for headroom and call skb_expand_head() like in the IP output
path to ensure there is sufficient headroom for the mac header when
forwarding this packet as suggested by sashiko.

Fixes: b5964aac51e0 ("netfilter: flowtable: consolidate xmit path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[ aq: the upstream commit does not apply to 6.6: 6.6 predates
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
  write before the skb head. Seen on v6.6.162 with IPv6 forwarded by a
  flowtable from a veth to a 6LoWPAN interface:

    WARNING: CPU: 1 PID: 3974 at net/ieee802154/6lowpan/tx.c:21 lowpan_header_create+0x165/0x1b0 [ieee802154_6lowpan]
    Call Trace:
     neigh_connected_output+0xa6/0xf0
     neigh_xmit+0xb4/0x1e0
     nf_flow_offload_ipv6_hook+0x544/0x7c0
     nf_hook_slow+0x39/0xe0
     __netif_receive_skb_core.constprop.0+0xd8a/0xf40
     __netif_receive_skb_one_core+0x37/0xa0
     process_backlog+0x75/0x130

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
index 6e6d036fe1391..24f1e6917d4ac 100644
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
 		rt = (struct rtable *)tuplehash->tuple.dst_cache;
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



