Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DD4348465;
	Thu,  2 Jul 2026 16:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010373; cv=none; b=jvIvVh0WnM+sAS0qh36d7P/65KMSYvYmEZ6Zzk/Jcf1Piqrq3wuvG4y+iL/fbBrLG3sdMtorVvN9B/E+Tg3LDNy8RoYGw4P2aK+q0alvMaqWU1N3kNAv++P6m/U69ioBRzUTM48iQ69CWiwpdllESKQNCFsdF0HsZWS6Tm+W90U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010373; c=relaxed/simple;
	bh=B9otvjrTB/VQf/oHHisirRahsqnA9n6uF6ieckPflGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVJnmo7kguvIswZF/IQ7zkWhbReGA5/Bp2fJVyR85sesshRqDr/847Z0Y6H5YzLrmPyA8bgrvvw+hknjKV+zFV6hAYoyZRflsPQ/UA1ScA42vgRAHUDzBwKHX/fG8vjwDan8sB3bBRiuzroBVdB+LKcwhhG9sLZNCAeRyM9t6tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePVtANPB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePVtANPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0281F000E9;
	Thu,  2 Jul 2026 16:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010371;
	bh=iK0J4n05rgOUtZbakFyhf12lnAjuEAtMGIU6Oq+jUQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ePVtANPB1P+h9MYvZXsOj+ZYOonBx8v24Eso9Jw4mrLGbSuoItYN4fDHotKyN07UQ
	 N2H+m4OencScXkzP5h4l27KAbFg2M9fJp4bPMBjVuS5CRpxmL5BLn3EgUVaVrnzVPE
	 xhzPJGFARQ/wLxlIr4jTsslQ+tDtneGQLjnClWwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Alexander Martyniuk <alexevgmart@gmail.com>
Subject: [PATCH 6.12 084/204] net: ipv6: Make udp_tunnel6_xmit_skb() void
Date: Thu,  2 Jul 2026 18:19:01 +0200
Message-ID: <20260702155120.424530431@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Petr Machata <petrm@nvidia.com>

commit 6a7d88ca15f73c5c570c372238f71d63da1fda55 upstream.

The function always returns zero, thus the return value does not carry any
signal. Just make it void.

Most callers already ignore the return value. However:

- Refold arguments of the call from sctp_v6_xmit() so that they fit into
  the 80-column limit.

- tipc_udp_xmit() initializes err from the return value, but that should
  already be always zero at that point. So there's no practical change, but
  elision of the assignment prompts a couple more tweaks to clean up the
  function.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/7facacf9d8ca3ca9391a4aee88160913671b868d.1750113335.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/udp_tunnel.h  |   14 +++++++-------
 net/ipv6/ip6_udp_tunnel.c |   15 +++++++--------
 net/sctp/ipv6.c           |    7 ++++---
 net/tipc/udp_media.c      |   10 +++++-----
 4 files changed, 23 insertions(+), 23 deletions(-)

--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -152,13 +152,13 @@ void udp_tunnel_xmit_skb(struct rtable *
 			 __be16 df, __be16 src_port, __be16 dst_port,
 			 bool xnet, bool nocheck);
 
-int udp_tunnel6_xmit_skb(struct dst_entry *dst, struct sock *sk,
-			 struct sk_buff *skb,
-			 struct net_device *dev,
-			 const struct in6_addr *saddr,
-			 const struct in6_addr *daddr,
-			 __u8 prio, __u8 ttl, __be32 label,
-			 __be16 src_port, __be16 dst_port, bool nocheck);
+void udp_tunnel6_xmit_skb(struct dst_entry *dst, struct sock *sk,
+			  struct sk_buff *skb,
+			  struct net_device *dev,
+			  const struct in6_addr *saddr,
+			  const struct in6_addr *daddr,
+			  __u8 prio, __u8 ttl, __be32 label,
+			  __be16 src_port, __be16 dst_port, bool nocheck);
 
 void udp_tunnel_sock_release(struct socket *sock);
 
--- a/net/ipv6/ip6_udp_tunnel.c
+++ b/net/ipv6/ip6_udp_tunnel.c
@@ -74,13 +74,13 @@ error:
 }
 EXPORT_SYMBOL_GPL(udp_sock_create6);
 
-int udp_tunnel6_xmit_skb(struct dst_entry *dst, struct sock *sk,
-			 struct sk_buff *skb,
-			 struct net_device *dev,
-			 const struct in6_addr *saddr,
-			 const struct in6_addr *daddr,
-			 __u8 prio, __u8 ttl, __be32 label,
-			 __be16 src_port, __be16 dst_port, bool nocheck)
+void udp_tunnel6_xmit_skb(struct dst_entry *dst, struct sock *sk,
+			  struct sk_buff *skb,
+			  struct net_device *dev,
+			  const struct in6_addr *saddr,
+			  const struct in6_addr *daddr,
+			  __u8 prio, __u8 ttl, __be32 label,
+			  __be16 src_port, __be16 dst_port, bool nocheck)
 {
 	struct udphdr *uh;
 	struct ipv6hdr *ip6h;
@@ -109,7 +109,6 @@ int udp_tunnel6_xmit_skb(struct dst_entr
 	ip6h->saddr	  = *saddr;
 
 	ip6tunnel_xmit(sk, skb, dev);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(udp_tunnel6_xmit_skb);
 
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -261,9 +261,10 @@ static int sctp_v6_xmit(struct sk_buff *
 	skb_set_inner_ipproto(skb, IPPROTO_SCTP);
 	label = ip6_make_flowlabel(sock_net(sk), skb, fl6->flowlabel, true, fl6);
 
-	return udp_tunnel6_xmit_skb(dst, sk, skb, NULL, &fl6->saddr,
-				    &fl6->daddr, tclass, ip6_dst_hoplimit(dst),
-				    label, sctp_sk(sk)->udp_port, t->encap_port, false);
+	udp_tunnel6_xmit_skb(dst, sk, skb, NULL, &fl6->saddr, &fl6->daddr,
+			     tclass, ip6_dst_hoplimit(dst), label,
+			     sctp_sk(sk)->udp_port, t->encap_port, false);
+	return 0;
 }
 
 /* Returns the dst cache entry for the given source and destination ip
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -172,7 +172,7 @@ static int tipc_udp_xmit(struct net *net
 			 struct udp_media_addr *dst, struct dst_cache *cache)
 {
 	struct dst_entry *ndst;
-	int ttl, err = 0;
+	int ttl, err;
 
 	local_bh_disable();
 	ndst = dst_cache_get(cache);
@@ -217,13 +217,13 @@ static int tipc_udp_xmit(struct net *net
 			dst_cache_set_ip6(cache, ndst, &fl6.saddr);
 		}
 		ttl = ip6_dst_hoplimit(ndst);
-		err = udp_tunnel6_xmit_skb(ndst, ub->ubsock->sk, skb, NULL,
-					   &src->ipv6, &dst->ipv6, 0, ttl, 0,
-					   src->port, dst->port, false);
+		udp_tunnel6_xmit_skb(ndst, ub->ubsock->sk, skb, NULL,
+				     &src->ipv6, &dst->ipv6, 0, ttl, 0,
+				     src->port, dst->port, false);
 #endif
 	}
 	local_bh_enable();
-	return err;
+	return 0;
 
 tx_error:
 	local_bh_enable();


