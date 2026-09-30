Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A173C7DF5;
	Wed, 30 Sep 2026 19:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795368; cv=none; b=k/U3kO/a2QFNcKGQrARmezx8YCv9gQW9zoUNB45zrx8NaBqOt/PTnEvR8T6JofcELOEmpX9nPHXKKBH208Wwi6VoVEvXx5zSizolHK0amQMzs5HmlEQRPZQjgZ5mequv1tV7YZ4WqlUtnGvIHzs0mYoREIkuNhzt7ObNU9lfEg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795368; c=relaxed/simple;
	bh=2GEb6Bk2+QGJUW1NsnQBqPLhttryoHjs1qB//2+3aVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZxvHI4jAUjnG9mSyxjUIrPlESPNJ+NL6Xqua6sA0mJ0wJHOH/hb3QbJprlzGJ2aP2FGoFFH1Cu0gkxCUfR5zWkf9nVDX7oFD5bZEyJrhtm2yNb0R7BUya6eb/tpHtwfF0RpIKSE1OfjvdreJuzERwRX+v8whTJG4Yn3GYDzGPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9Zip1Dp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9Zip1Dp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00AD31F000FF;
	Wed, 30 Sep 2026 19:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795367;
	bh=Su7pvAzS2J0iCU4gqIxDz3PdYug76UQ7/oWcpOAJZrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v9Zip1Dpt20YJD15HZujeSp/b6kl3vSYoZTR72dVQmHzV0my5fOhsxGOwkVHnvJsr
	 wGVY2ly1/iXu6sRuFh+IJhCACdAzScqzK5231rDusOtGwovd7OfVPwsJX9gmG2T0No
	 qgt6I1k5N7QlNtzxs1HzM58ZEigXcjcbpeTiIk/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0537/1193] ipv6: lockless IPV6_UNICAST_HOPS implementation
Date: Wed, 30 Sep 2026 17:20:21 +0200
Message-ID: <20260930152446.153979932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b0adfba7ee770fef20b1b6d86706c28f7fccfb07 ]

Some np->hop_limit accesses are racy, when socket lock is not held.

Add missing annotations and switch to full lockless implementation.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 0ae10b6be49b ("net: ipv6: Fix UDP length overflow with PMTU discover and big MTU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ipv6.h     |   12 +-----------
 include/net/ipv6.h       |    2 +-
 net/ipv6/ip6_output.c    |    2 +-
 net/ipv6/ipv6_sockglue.c |   20 +++++++++++---------
 net/ipv6/mcast.c         |    2 +-
 net/ipv6/ndisc.c         |    2 +-
 6 files changed, 16 insertions(+), 24 deletions(-)

--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -213,17 +213,7 @@ struct ipv6_pinfo {
 	__be32			flow_label;
 	__u32			frag_size;
 
-	/*
-	 * Packed in 16bits.
-	 * Omit one shift by putting the signed field at MSB.
-	 */
-#if defined(__BIG_ENDIAN_BITFIELD)
-	__s16			hop_limit:9;
-	__u16			__unused_1:7;
-#else
-	__u16			__unused_1:7;
-	__s16			hop_limit:9;
-#endif
+	s16			hop_limit;
 
 #if defined(__BIG_ENDIAN_BITFIELD)
 	/* Packed in 16bits. */
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -916,7 +916,7 @@ static inline int ip6_sk_dst_hoplimit(st
 	if (ipv6_addr_is_multicast(&fl6->daddr))
 		hlimit = np->mcast_hops;
 	else
-		hlimit = np->hop_limit;
+		hlimit = READ_ONCE(np->hop_limit);
 	if (hlimit < 0)
 		hlimit = ip6_dst_hoplimit(dst);
 	return hlimit;
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -328,7 +328,7 @@ int ip6_xmit(const struct sock *sk, stru
 	 *	Fill in the IPv6 header
 	 */
 	if (np)
-		hlimit = np->hop_limit;
+		hlimit = READ_ONCE(np->hop_limit);
 	if (hlimit < 0)
 		hlimit = ip6_dst_hoplimit(dst);
 
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -414,6 +414,16 @@ int do_ipv6_setsockopt(struct sock *sk,
 	if (ip6_mroute_opt(optname))
 		return ip6_mroute_setsockopt(sk, optname, optval, optlen);
 
+	/* Handle options that can be set without locking the socket. */
+	switch (optname) {
+	case IPV6_UNICAST_HOPS:
+		if (optlen < sizeof(int))
+			return -EINVAL;
+		if (val > 255 || val < -1)
+			return -EINVAL;
+		WRITE_ONCE(np->hop_limit, val);
+		return 0;
+	}
 	if (needs_rtnl)
 		rtnl_lock();
 	sockopt_lock_sock(sk);
@@ -732,14 +742,6 @@ done:
 		}
 		break;
 	}
-	case IPV6_UNICAST_HOPS:
-		if (optlen < sizeof(int))
-			goto e_inval;
-		if (val > 255 || val < -1)
-			goto e_inval;
-		np->hop_limit = val;
-		retv = 0;
-		break;
 
 	case IPV6_MULTICAST_HOPS:
 		if (sk->sk_type == SOCK_STREAM)
@@ -1346,7 +1348,7 @@ int do_ipv6_getsockopt(struct sock *sk,
 		struct dst_entry *dst;
 
 		if (optname == IPV6_UNICAST_HOPS)
-			val = np->hop_limit;
+			val = READ_ONCE(np->hop_limit);
 		else
 			val = np->mcast_hops;
 
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1743,7 +1743,7 @@ static void ip6_mc_hdr(const struct sock
 
 	hdr->payload_len = htons(len);
 	hdr->nexthdr = proto;
-	hdr->hop_limit = inet6_sk(sk)->hop_limit;
+	hdr->hop_limit = READ_ONCE(inet6_sk(sk)->hop_limit);
 
 	hdr->saddr = *saddr;
 	hdr->daddr = *daddr;
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -505,7 +505,7 @@ void ndisc_send_skb(struct sk_buff *skb,
 					      csum_partial(icmp6h,
 							   skb->len, 0));
 
-	ip6_nd_hdr(skb, saddr, daddr, inet6_sk(sk)->hop_limit, skb->len);
+	ip6_nd_hdr(skb, saddr, daddr, READ_ONCE(inet6_sk(sk)->hop_limit), skb->len);
 
 	idev = __in6_dev_get(dst->dev);
 	IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTREQUESTS);


