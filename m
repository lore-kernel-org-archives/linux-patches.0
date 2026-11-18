Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040967;
	b=Ixnh5vO8dWI9TI3fBgDEp9p88ZpIjnxknkQjmceeTq4iTLMa16yTTfDzgZdAPxvYWMrW
	 Ba4ko0NVI367FNn/PeYcBQZ8O/2nYXcbHfAUI+WuxxYBf4CaiUtrYh8Z8dvNmvCaA2lvE
	 c7qVCfCB/5ggQXIf0BfuPh1nHJnuWmX/iyUWarBCpzwb8o0MYlR4VT2BdkaWraO8nFQAY
	 paJMIPEvIG3CXTXKULA78lYE9cmoyuvkOc/H45EZ9dlih1fFcC99VDv7nX/42Qwm3vPXd
	 VtgWN1z9znUkRQztsc/O2hGcxj2GLue16yXeYXZ/BwLhul986gsfwY/OU4HMq20HDxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rb2vzloLHOpxHTMcb2uhUEfJZF/u+aPIc5Ro7zFmfKw=;
	b=p5gPRQa36i8XWNQcx8mDxMECeN74R4BGO0D1CVppUrkTqMVUnOlNDIcbH1HfcPFulXTJ
	 BNNIMVLmxIk7OBHOCgT0QPI2GJPSEKsSoFloOMaA40R8PaKFPBItWm4HWncDeOrIAPpSB
	 SnmAjjmwlg+7vLWLlgDbSoOpeyQ5fx1o4kjZucFVJDeoF0dTzpuuKqjQprTOt1h1XQk9j
	 n17fGc9OUlSoRYfh2cUReTX4WieqmxxScBRz6Q/yUJc88XSjgsycP7aHcMOs8NsEmfa3X
	 J0CGUg/K01QCs+VYzquWBJMU1bDziwtNHEcQZLt7K4cs5ZIdzPELtcKIkE2J+38SzNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t0j9zT9y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0D2606A320;
	Wed, 18 Nov 2026 22:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t0j9zT9y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62581F000C4;
	Wed, 18 Nov 2026 22:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040967;
	bh=Rb2vzloLHOpxHTMcb2uhUEfJZF/u+aPIc5Ro7zFmfKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t0j9zT9ya1e0RmlWDwFf31QmUH/AQneTYOeY21Apc4aUp5scEdOdSAg3jXzRrMydg
	 YUvq1Dzkx7f3vH37xeZmdxkp7w0CZOa7GtskQnKeOjtmyUAyA3/uYJZ+BQkjH6iulg
	 slFrN7BzlLK/l2b4lVIGYRdaVig/g34oCGNhPyxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2628/3318] inet: implement lockless IP_MTU_DISCOVER
Date: Wed, 18 Nov 2026 15:54:10 +0100
Message-ID: <20261118150439.936812541@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ceaa714138a372ac63cc2c5c19ee0882d22827f9 ]

inet->pmtudisc can be read locklessly.

Implement proper lockless reads and writes to inet->pmtudisc

ip_sock_set_mtu_discover() can now be called from arbitrary
contexts.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 852c08d6a991 ("ipv4: reserve one IP ID per segment for UDP GSO packets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h                | 13 ++++++++-----
 net/ipv4/ip_output.c            |  7 ++++---
 net/ipv4/ip_sockglue.c          | 17 ++++++-----------
 net/ipv4/ping.c                 |  2 +-
 net/ipv4/raw.c                  |  2 +-
 net/ipv4/udp.c                  |  2 +-
 net/netfilter/ipvs/ip_vs_sync.c |  2 +-
 7 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 4bfa2b1fc4850..33243bf5c46ff 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -446,19 +446,22 @@ int ip_dont_fragment(const struct sock *sk, const struct dst_entry *dst)
 
 static inline bool ip_sk_accept_pmtu(const struct sock *sk)
 {
-	return inet_sk(sk)->pmtudisc != IP_PMTUDISC_INTERFACE &&
-	       inet_sk(sk)->pmtudisc != IP_PMTUDISC_OMIT;
+	u8 pmtudisc = READ_ONCE(inet_sk(sk)->pmtudisc);
+
+	return pmtudisc != IP_PMTUDISC_INTERFACE &&
+	       pmtudisc != IP_PMTUDISC_OMIT;
 }
 
 static inline bool ip_sk_use_pmtu(const struct sock *sk)
 {
-	return inet_sk(sk)->pmtudisc < IP_PMTUDISC_PROBE;
+	return READ_ONCE(inet_sk(sk)->pmtudisc) < IP_PMTUDISC_PROBE;
 }
 
 static inline bool ip_sk_ignore_df(const struct sock *sk)
 {
-	return inet_sk(sk)->pmtudisc < IP_PMTUDISC_DO ||
-	       inet_sk(sk)->pmtudisc == IP_PMTUDISC_OMIT;
+	u8 pmtudisc = READ_ONCE(inet_sk(sk)->pmtudisc);
+
+	return pmtudisc < IP_PMTUDISC_DO || pmtudisc == IP_PMTUDISC_OMIT;
 }
 
 static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 6b29d1caa9223..edf92678ba043 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1409,8 +1409,8 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	struct ip_options *opt = NULL;
 	struct rtable *rt = (struct rtable *)cork->dst;
 	struct iphdr *iph;
+	u8 pmtudisc, ttl;
 	__be16 df = 0;
-	__u8 ttl;
 
 	skb = __skb_dequeue(queue);
 	if (!skb)
@@ -1440,8 +1440,9 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	/* DF bit is set when we want to see DF on outgoing frames.
 	 * If ignore_df is set too, we still allow to fragment this frame
 	 * locally. */
-	if (inet->pmtudisc == IP_PMTUDISC_DO ||
-	    inet->pmtudisc == IP_PMTUDISC_PROBE ||
+	pmtudisc = READ_ONCE(inet->pmtudisc);
+	if (pmtudisc == IP_PMTUDISC_DO ||
+	    pmtudisc == IP_PMTUDISC_PROBE ||
 	    (skb->len <= dst_mtu(&rt->dst) &&
 	     ip_dont_fragment(sk, &rt->dst)))
 		df = htons(IP_DF);
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 86ea9cee33af5..52fed3cdc127b 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -622,9 +622,7 @@ int ip_sock_set_mtu_discover(struct sock *sk, int val)
 {
 	if (val < IP_PMTUDISC_DONT || val > IP_PMTUDISC_OMIT)
 		return -EINVAL;
-	lock_sock(sk);
-	inet_sk(sk)->pmtudisc = val;
-	release_sock(sk);
+	WRITE_ONCE(inet_sk(sk)->pmtudisc, val);
 	return 0;
 }
 EXPORT_SYMBOL(ip_sock_set_mtu_discover);
@@ -1050,6 +1048,8 @@ int do_ip_setsockopt(struct sock *sk, int level, int optname,
 			return -EINVAL;
 		WRITE_ONCE(inet->mc_ttl, val);
 		return 0;
+	case IP_MTU_DISCOVER:
+		return ip_sock_set_mtu_discover(sk, val);
 	}
 
 	err = 0;
@@ -1107,11 +1107,6 @@ int do_ip_setsockopt(struct sock *sk, int level, int optname,
 	case IP_TOS:	/* This sets both TOS and Precedence */
 		__ip_sock_set_tos(sk, val);
 		break;
-	case IP_MTU_DISCOVER:
-		if (val < IP_PMTUDISC_DONT || val > IP_PMTUDISC_OMIT)
-			goto e_inval;
-		inet->pmtudisc = val;
-		break;
 	case IP_UNICAST_IF:
 	{
 		struct net_device *dev = NULL;
@@ -1597,6 +1592,9 @@ int do_ip_getsockopt(struct sock *sk, int level, int optname,
 	case IP_MULTICAST_TTL:
 		val = READ_ONCE(inet->mc_ttl);
 		goto copyval;
+	case IP_MTU_DISCOVER:
+		val = READ_ONCE(inet->pmtudisc);
+		goto copyval;
 	}
 
 	if (needs_rtnl)
@@ -1636,9 +1634,6 @@ int do_ip_getsockopt(struct sock *sk, int level, int optname,
 	case IP_TOS:
 		val = inet->tos;
 		break;
-	case IP_MTU_DISCOVER:
-		val = inet->pmtudisc;
-		break;
 	case IP_MTU:
 	{
 		struct dst_entry *dst;
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index fa13cfa2fa00f..6c5a692195e83 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -563,7 +563,7 @@ void ping_err(struct sk_buff *skb, int offset, u32 info)
 		case ICMP_DEST_UNREACH:
 			if (code == ICMP_FRAG_NEEDED) { /* Path MTU discovery */
 				ipv4_sk_update_pmtu(skb, sk, info);
-				if (inet_sock->pmtudisc != IP_PMTUDISC_DONT) {
+				if (READ_ONCE(inet_sock->pmtudisc) != IP_PMTUDISC_DONT) {
 					err = EMSGSIZE;
 					harderr = 1;
 					break;
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index ac49dac9b4fdb..d5ef8f64c9c50 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -239,7 +239,7 @@ static void raw_err(struct sock *sk, struct sk_buff *skb, u32 info)
 		if (code > NR_ICMP_UNREACH)
 			break;
 		if (code == ICMP_FRAG_NEEDED) {
-			harderr = inet->pmtudisc != IP_PMTUDISC_DONT;
+			harderr = READ_ONCE(inet->pmtudisc) != IP_PMTUDISC_DONT;
 			err = EMSGSIZE;
 		} else {
 			err = icmp_err_convert[code].errno;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 8ceaeef5c184c..025ff82addd68 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -827,7 +827,7 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
 	case ICMP_DEST_UNREACH:
 		if (code == ICMP_FRAG_NEEDED) { /* Path MTU discovery */
 			ipv4_sk_update_pmtu(skb, sk, info);
-			if (inet->pmtudisc != IP_PMTUDISC_DONT) {
+			if (READ_ONCE(inet->pmtudisc) != IP_PMTUDISC_DONT) {
 				err = EMSGSIZE;
 				harderr = 1;
 				break;
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 5a626841b07a3..c6c712180c612 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1359,7 +1359,7 @@ static void set_mcast_pmtudisc(struct sock *sk, int val)
 
 	/* setsockopt(sock, SOL_IP, IP_MTU_DISCOVER, &val, sizeof(val)); */
 	lock_sock(sk);
-	inet->pmtudisc = val;
+	WRITE_ONCE(inet->pmtudisc, val);
 #ifdef CONFIG_IP_VS_IPV6
 	if (sk->sk_family == AF_INET6) {
 		struct ipv6_pinfo *np = inet6_sk(sk);
-- 
2.53.0



