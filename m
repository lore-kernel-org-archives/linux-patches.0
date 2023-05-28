Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927BD569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA53C433EF;
	Sun, 28 May 2023 19:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301937;
	bh=kydTmsUAvpE2upcYaSrLty7leZxh86J7+A3BqIpLRjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvhFXtBtlhdgmnKa+ARZBw1k+786JUizMM5gkUMhqvTZHreqk0Kr3JvNKxS1IoGKo
	 CkS5PphKp0O/qG1QiQ12HLlRZV8o3KLV+opQlxJtN/LMMVLcmyicVcHcKkCg7Bpi9G
	 wPq3mILj9xTC2sWw/Bzja2g5hDSJvD18DMcjN+zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Peilin Ye <peilin.ye@bytedance.com>,
	William Tu <u9012063@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/161] ip_gre, ip6_gre: Fix race condition on o_seqno in collect_md mode
Date: Sun, 28 May 2023 20:09:52 +0100
Message-Id: <20230528190839.329618193@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peilin Ye <peilin.ye@bytedance.com>

[ Upstream commit 31c417c948d7f6909cb63f0ac3298f3c38f8ce20 ]

As pointed out by Jakub Kicinski, currently using TUNNEL_SEQ in
collect_md mode is racy for [IP6]GRE[TAP] devices.  Consider the
following sequence of events:

1. An [IP6]GRE[TAP] device is created in collect_md mode using "ip link
   add ... external".  "ip" ignores "[o]seq" if "external" is specified,
   so TUNNEL_SEQ is off, and the device is marked as NETIF_F_LLTX (i.e.
   it uses lockless TX);
2. Someone sets TUNNEL_SEQ on outgoing skb's, using e.g.
   bpf_skb_set_tunnel_key() in an eBPF program attached to this device;
3. gre_fb_xmit() or __gre6_xmit() processes these skb's:

	gre_build_header(skb, tun_hlen,
			 flags, protocol,
			 tunnel_id_to_key32(tun_info->key.tun_id),
			 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++)
					      : 0);   ^^^^^^^^^^^^^^^^^

Since we are not using the TX lock (&txq->_xmit_lock), multiple CPUs may
try to do this tunnel->o_seqno++ in parallel, which is racy.  Fix it by
making o_seqno atomic_t.

As mentioned by Eric Dumazet in commit b790e01aee74 ("ip_gre: lockless
xmit"), making o_seqno atomic_t increases "chance for packets being out
of order at receiver" when NETIF_F_LLTX is on.

Maybe a better fix would be:

1. Do not ignore "oseq" in external mode.  Users MUST specify "oseq" if
   they want the kernel to allow sequencing of outgoing packets;
2. Reject all outgoing TUNNEL_SEQ packets if the device was not created
   with "oseq".

Unfortunately, that would break userspace.

We could now make [IP6]GRE[TAP] devices always NETIF_F_LLTX, but let us
do it in separate patches to keep this fix minimal.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Fixes: 77a5196a804e ("gre: add sequence number for collect md mode.")
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
Acked-by: William Tu <u9012063@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: d80fc101d2eb ("erspan: get the proto with the md version for collect_md")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip6_tunnel.h | 2 +-
 include/net/ip_tunnels.h | 2 +-
 net/ipv4/ip_gre.c        | 6 +++---
 net/ipv6/ip6_gre.c       | 7 ++++---
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
index 028eaea1c8544..42d50856fcf24 100644
--- a/include/net/ip6_tunnel.h
+++ b/include/net/ip6_tunnel.h
@@ -57,7 +57,7 @@ struct ip6_tnl {
 
 	/* These fields used only by GRE */
 	__u32 i_seqno;	/* The last seen seqno	*/
-	__u32 o_seqno;	/* The last output seqno */
+	atomic_t o_seqno;	/* The last output seqno */
 	int hlen;       /* tun_hlen + encap_hlen */
 	int tun_hlen;	/* Precalculated header length */
 	int encap_hlen; /* Encap header length (FOU,GUE) */
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 56deb2501e962..6f75a84b47de5 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -113,7 +113,7 @@ struct ip_tunnel {
 
 	/* These four fields used only by GRE */
 	u32		i_seqno;	/* The last seen seqno	*/
-	u32		o_seqno;	/* The last output seqno */
+	atomic_t	o_seqno;	/* The last output seqno */
 	int		tun_hlen;	/* Precalculated header length */
 
 	/* These four fields used only by ERSPAN */
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 317fdb9f47e88..f8f008344273e 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -437,7 +437,7 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 	/* Push GRE header. */
 	gre_build_header(skb, tunnel->tun_hlen,
 			 flags, proto, tunnel->parms.o_key,
-			 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++) : 0);
+			 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno)) : 0);
 
 	ip_tunnel_xmit(skb, dev, tnl_params, tnl_params->protocol);
 }
@@ -475,7 +475,7 @@ static void gre_fb_xmit(struct sk_buff *skb, struct net_device *dev,
 		(TUNNEL_CSUM | TUNNEL_KEY | TUNNEL_SEQ);
 	gre_build_header(skb, tunnel_hlen, flags, proto,
 			 tunnel_id_to_key32(tun_info->key.tun_id),
-			 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++) : 0);
+			 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno)) : 0);
 
 	ip_md_tunnel_xmit(skb, dev, IPPROTO_GRE, tunnel_hlen);
 
@@ -557,7 +557,7 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	gre_build_header(skb, 8, TUNNEL_SEQ,
-			 proto, 0, htonl(tunnel->o_seqno++));
+			 proto, 0, htonl(atomic_fetch_inc(&tunnel->o_seqno)));
 
 	ip_md_tunnel_xmit(skb, dev, IPPROTO_GRE, tunnel_hlen);
 
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index e3c65e7681ad4..63b5fd3742f2c 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -754,7 +754,7 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		gre_build_header(skb, tun_hlen,
 				 flags, protocol,
 				 tunnel_id_to_key32(tun_info->key.tun_id),
-				 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++)
+				 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno))
 						      : 0);
 
 	} else {
@@ -765,7 +765,8 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 
 		gre_build_header(skb, tunnel->tun_hlen, flags,
 				 protocol, tunnel->parms.o_key,
-				 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++) : 0);
+				 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno))
+						      : 0);
 	}
 
 	return ip6_tnl_xmit(skb, dev, dsfield, fl6, encap_limit, pmtu,
@@ -1048,7 +1049,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	/* Push GRE header. */
 	proto = (t->parms.erspan_ver == 1) ? htons(ETH_P_ERSPAN)
 					   : htons(ETH_P_ERSPAN2);
-	gre_build_header(skb, 8, TUNNEL_SEQ, proto, 0, htonl(t->o_seqno++));
+	gre_build_header(skb, 8, TUNNEL_SEQ, proto, 0, htonl(atomic_fetch_inc(&t->o_seqno)));
 
 	/* TooBig packet may have updated dst->dev's mtu */
 	if (!t->parms.collect_md && dst && dst_mtu(dst) > dst->dev->mtu)
-- 
2.39.2



