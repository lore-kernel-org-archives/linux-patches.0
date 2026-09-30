Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AFB3B3BE1;
	Wed, 30 Sep 2026 19:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795372; cv=none; b=A64ogrlsLFpBV7ZKrN03md4whphgCoNyNluo2M15NSdnpCXUINmw+kLnsKysz5Z6MEzVIVs6lvB0mddByMKPZprlm8CEAebspyW0715rwAoN3/ErMzKzCZPpGzfB3eXnRsPFnUEvxZIy2IlpxeS5o5tHzp1NpHPU3BcKFMekbME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795372; c=relaxed/simple;
	bh=Wd3SBSmLQuCmHelumjRSlPiXOloAYrOUdgRn67i4IZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWg1qzeN8eHaE+ickl/iGFHwsa2jCjXVR+j33yNVUVc3EbejG0w7mBSK/HWet8U1Mp5Rz2bk4qVF7NeNyklBPxZOYOlB5a7hYbw5Ykvsoyi+bO9Uy/feVRiEH3lr/Yw+XqHtpXyQw2C4UYk2FxdlW9QiDCFhTi4+wWaFy3eWpnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VlREfhx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VlREfhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDD11F000FF;
	Wed, 30 Sep 2026 19:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795370;
	bh=fkOUJMfWlv5mnyE4zXChv6TgXPuIQ8i+uy9TkJjQm4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2VlREfhxmtD2b57evxdqT7dSqLrESbu9d2qibLVmMGW9FnccecqHM5MT9dY9inTNu
	 WmO9tJyUmLHo1ShlYY6tmAO1eLSgYdGykBPFnOcEnK/Oj3caekmnRVepTUjoIYiU6+
	 30adae86opNFcFttNIuLTLRmqXso2TlzF70O5G/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0538/1193] ipv6: lockless IPV6_MULTICAST_LOOP implementation
Date: Wed, 30 Sep 2026 17:20:22 +0200
Message-ID: <20260930152446.178977742@linuxfoundation.org>
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

[ Upstream commit d986f52124e062753e33b6fe303be5904a997eac ]

Add inet6_{test|set|clear|assign}_bit() helpers.

Note that I am using bits from inet->inet_flags,
this might change in the future if we need more flags.

While solving data-races accessing np->mc_loop,
this patch also allows to implement lockless accesses
to np->mcast_hops in the following patch.

Also constify sk_mc_loop() argument.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 0ae10b6be49b ("net: ipv6: Fix UDP length overflow with PMTU discover and big MTU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ipv6.h            |   18 ++++++++++++++----
 include/net/inet_sock.h         |    1 +
 include/net/sock.h              |    2 +-
 net/core/sock.c                 |    4 ++--
 net/ipv6/af_inet6.c             |    2 +-
 net/ipv6/ipv6_sockglue.c        |   18 ++++++++----------
 net/ipv6/ndisc.c                |    2 +-
 net/netfilter/ipvs/ip_vs_sync.c |    8 ++------
 8 files changed, 30 insertions(+), 25 deletions(-)

--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -218,11 +218,9 @@ struct ipv6_pinfo {
 #if defined(__BIG_ENDIAN_BITFIELD)
 	/* Packed in 16bits. */
 	__s16			mcast_hops:9;
-	__u16			__unused_2:6,
-				mc_loop:1;
+	__u16			__unused_2:7,
 #else
-	__u16			mc_loop:1,
-				__unused_2:6;
+	__u16			__unused_2:7;
 	__s16			mcast_hops:9;
 #endif
 	int			ucast_oif;
@@ -283,6 +281,18 @@ struct ipv6_pinfo {
 	struct inet6_cork	cork;
 };
 
+/* We currently use available bits from inet_sk(sk)->inet_flags,
+ * this could change in the future.
+ */
+#define inet6_test_bit(nr, sk)			\
+	test_bit(INET_FLAGS_##nr, &inet_sk(sk)->inet_flags)
+#define inet6_set_bit(nr, sk)			\
+	set_bit(INET_FLAGS_##nr, &inet_sk(sk)->inet_flags)
+#define inet6_clear_bit(nr, sk)			\
+	clear_bit(INET_FLAGS_##nr, &inet_sk(sk)->inet_flags)
+#define inet6_assign_bit(nr, sk, val)		\
+	assign_bit(INET_FLAGS_##nr, &inet_sk(sk)->inet_flags, val)
+
 /* WARNING: don't change the layout of the members in {raw,udp,tcp}6_sock! */
 struct raw6_sock {
 	/* inet_sock has to be the first member of raw6_sock */
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -268,6 +268,7 @@ enum {
 	INET_FLAGS_NODEFRAG	= 17,
 	INET_FLAGS_BIND_ADDRESS_NO_PORT = 18,
 	INET_FLAGS_DEFER_CONNECT = 19,
+	INET_FLAGS_MC6_LOOP	= 20,
 };
 
 /* cmsg flags for inet */
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2313,7 +2313,7 @@ static inline void sock_confirm_neigh(st
 	}
 }
 
-bool sk_mc_loop(struct sock *sk);
+bool sk_mc_loop(const struct sock *sk);
 
 static inline bool sk_can_gso(const struct sock *sk)
 {
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -761,7 +761,7 @@ out:
 	return ret;
 }
 
-bool sk_mc_loop(struct sock *sk)
+bool sk_mc_loop(const struct sock *sk)
 {
 	if (dev_recursion_level())
 		return false;
@@ -773,7 +773,7 @@ bool sk_mc_loop(struct sock *sk)
 		return inet_test_bit(MC_LOOP, sk);
 #if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
-		return inet6_sk(sk)->mc_loop;
+		return inet6_test_bit(MC6_LOOP, sk);
 #endif
 	}
 	return true;
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -220,7 +220,7 @@ lookup_protocol:
 	inet_sk(sk)->pinet6 = np = inet6_sk_generic(sk);
 	np->hop_limit	= -1;
 	np->mcast_hops	= IPV6_DEFAULT_MCASTHOPS;
-	np->mc_loop	= 1;
+	inet6_set_bit(MC6_LOOP, sk);
 	np->mc_all	= 1;
 	np->pmtudisc	= IPV6_PMTUDISC_WANT;
 	np->repflow	= net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_ESTABLISHED;
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -423,6 +423,13 @@ int do_ipv6_setsockopt(struct sock *sk,
 			return -EINVAL;
 		WRITE_ONCE(np->hop_limit, val);
 		return 0;
+	case IPV6_MULTICAST_LOOP:
+		if (optlen < sizeof(int))
+			return -EINVAL;
+		if (val != valbool)
+			return -EINVAL;
+		inet6_assign_bit(MC6_LOOP, sk, valbool);
+		return 0;
 	}
 	if (needs_rtnl)
 		rtnl_lock();
@@ -754,15 +761,6 @@ done:
 		retv = 0;
 		break;
 
-	case IPV6_MULTICAST_LOOP:
-		if (optlen < sizeof(int))
-			goto e_inval;
-		if (val != valbool)
-			goto e_inval;
-		np->mc_loop = valbool;
-		retv = 0;
-		break;
-
 	case IPV6_UNICAST_IF:
 	{
 		struct net_device *dev = NULL;
@@ -1366,7 +1364,7 @@ int do_ipv6_getsockopt(struct sock *sk,
 	}
 
 	case IPV6_MULTICAST_LOOP:
-		val = np->mc_loop;
+		val = inet6_test_bit(MC6_LOOP, sk);
 		break;
 
 	case IPV6_MULTICAST_IF:
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -2011,7 +2011,7 @@ static int __net_init ndisc_net_init(str
 	np = inet6_sk(sk);
 	np->hop_limit = 255;
 	/* Do not loopback ndisc messages */
-	np->mc_loop = 0;
+	inet6_clear_bit(MC6_LOOP, sk);
 
 	return 0;
 }
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1295,17 +1295,13 @@ static void set_sock_size(struct sock *s
 static void set_mcast_loop(struct sock *sk, u_char loop)
 {
 	/* setsockopt(sock, SOL_IP, IP_MULTICAST_LOOP, &loop, sizeof(loop)); */
-	lock_sock(sk);
 	inet_assign_bit(MC_LOOP, sk, loop);
 #ifdef CONFIG_IP_VS_IPV6
-	if (sk->sk_family == AF_INET6) {
-		struct ipv6_pinfo *np = inet6_sk(sk);
-
+	if (READ_ONCE(sk->sk_family) == AF_INET6) {
 		/* IPV6_MULTICAST_LOOP */
-		np->mc_loop = loop ? 1 : 0;
+		inet6_assign_bit(MC6_LOOP, sk, loop);
 	}
 #endif
-	release_sock(sk);
 }
 
 /*


