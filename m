Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2503B47D449;
	Thu, 20 Aug 2026 16:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243508; cv=none; b=eZ/zKPV29DxURxQRSyAV3tiQyky4lrMLSQ4z5+eHKA63YN87ry07wQ4g0HI7avHT9wxR5GPP8afpi9IRWw6C6DUM+UD4dE7amxt8/dqJuYh16ZtghT0FrKxhMH5OVqb6xWUOuUhgoIKdBinUah+jrgb2QsgzhEm0pgV3FD7Y6PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243508; c=relaxed/simple;
	bh=tG+NYGL2WQbqp5SpSAYRTFc2+83wZ19HlB07d4lDhnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRl1OrBrUgQz629WXo76uvX1i7DQ13mQO1LnsZ2275mhAWzxylckhS72H/76pT4Y2QRiLu7aj7Hx2s3NcMUUIQqZzxZ3y2znBV0K5pF9SOv916V9scGoPRxit8pa613ef6dr0XvLauZo+7cxxH/xS650cEQMseP2P2hnrsqVQ9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNXB7gCj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNXB7gCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800C81F000E9;
	Thu, 20 Aug 2026 16:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243507;
	bh=BJ4mcC8f6SXjWCCpKcq1aLdMx+JKVvaHpo2hxiEUxyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XNXB7gCjMzT4frbsho2d+q4rOkca127pJLOpJ3l3hRDqlae7mYx0zYgpqqAgVUPto
	 DoyC63Fy6jJuTPuL6c5MU7ijsQ9LtAybs3N5MrBh0IutBP3BqLPK54KTx4ZJYIiA6+
	 jyLYU6BZnDDBe6RZ42gJK63vMqW1y82l+FGBDWos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/272] tcp: convert to dev_net_rcu()
Date: Thu, 20 Aug 2026 16:54:23 +0200
Message-ID: <20260820145233.649541676@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e7b9ecce562ca6a1de32c56c597fa45e08c44ec0 ]

TCP uses of dev_net() are under RCU protection, change them
to dev_net_rcu() to get LOCKDEP support.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250301201424.2046477-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c9c9b37f8c55 ("netfilter: nf_queue: pin bridge device while NFQUEUE holds fake dst")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/inet6_hashtables.h |    2 +-
 include/net/inet_hashtables.h  |    2 +-
 net/ipv4/tcp_ipv4.c            |    8 ++++----
 net/ipv4/tcp_metrics.c         |    6 +++---
 net/ipv6/tcp_ipv6.c            |   10 +++++-----
 5 files changed, 14 insertions(+), 14 deletions(-)

--- a/include/net/inet6_hashtables.h
+++ b/include/net/inet6_hashtables.h
@@ -106,7 +106,7 @@ static inline struct sock *__inet6_looku
 	if (sk)
 		return sk;
 
-	return __inet6_lookup(dev_net(skb_dst(skb)->dev), hashinfo, skb,
+	return __inet6_lookup(dev_net_rcu(skb_dst(skb)->dev), hashinfo, skb,
 			      doff, &ipv6_hdr(skb)->saddr, sport,
 			      &ipv6_hdr(skb)->daddr, ntohs(dport),
 			      iif, sdif, refcounted);
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -356,7 +356,7 @@ static inline struct sock *__inet_lookup
 	if (sk)
 		return sk;
 
-	return __inet_lookup(dev_net(skb_dst(skb)->dev), hashinfo, skb,
+	return __inet_lookup(dev_net_rcu(skb_dst(skb)->dev), hashinfo, skb,
 			     doff, iph->saddr, sport,
 			     iph->daddr, dport, inet_iif(skb), sdif,
 			     refcounted);
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -486,7 +486,7 @@ int tcp_v4_err(struct sk_buff *skb, u32
 	struct request_sock *fastopen;
 	u32 seq, snd_una;
 	int err;
-	struct net *net = dev_net(skb->dev);
+	struct net *net = dev_net_rcu(skb->dev);
 
 	sk = __inet_lookup_established(net, &tcp_hashinfo, iph->daddr,
 				       th->dest, iph->saddr, ntohs(th->source),
@@ -718,7 +718,7 @@ static void tcp_v4_send_reset(const stru
 	arg.iov[0].iov_base = (unsigned char *)&rep;
 	arg.iov[0].iov_len  = sizeof(rep.th);
 
-	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
+	net = sk ? sock_net(sk) : dev_net_rcu(skb_dst(skb)->dev);
 #ifdef CONFIG_TCP_MD5SIG
 	rcu_read_lock();
 	hash_location = tcp_parse_md5sig_option(th);
@@ -1794,7 +1794,7 @@ int tcp_v4_early_demux(struct sk_buff *s
 	if (th->doff < sizeof(struct tcphdr) / 4)
 		return 0;
 
-	sk = __inet_lookup_established(dev_net(skb->dev), &tcp_hashinfo,
+	sk = __inet_lookup_established(dev_net_rcu(skb->dev), &tcp_hashinfo,
 				       iph->saddr, th->source,
 				       iph->daddr, ntohs(th->dest),
 				       skb->skb_iif, inet_sdif(skb));
@@ -1989,7 +1989,7 @@ static void tcp_v4_fill_cb(struct sk_buf
 
 int tcp_v4_rcv(struct sk_buff *skb)
 {
-	struct net *net = dev_net(skb->dev);
+	struct net *net = dev_net_rcu(skb->dev);
 	struct sk_buff *skb_to_free;
 	int sdif = inet_sdif(skb);
 	int dif = inet_iif(skb);
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -170,7 +170,7 @@ static struct tcp_metrics_block *tcpm_ne
 	bool reclaim = false;
 
 	spin_lock_bh(&tcp_metrics_lock);
-	net = dev_net(dst->dev);
+	net = dev_net_rcu(dst->dev);
 
 	/* While waiting for the spin-lock the cache might have been populated
 	 * with this entry and so we have to check again.
@@ -273,7 +273,7 @@ static struct tcp_metrics_block *__tcp_g
 		return NULL;
 	}
 
-	net = dev_net(dst->dev);
+	net = dev_net_rcu(dst->dev);
 	hash ^= net_hash_mix(net);
 	hash = hash_32(hash, tcp_metrics_hash_log);
 
@@ -318,7 +318,7 @@ static struct tcp_metrics_block *tcp_get
 	else
 		return NULL;
 
-	net = dev_net(dst->dev);
+	net = dev_net_rcu(dst->dev);
 	hash ^= net_hash_mix(net);
 	hash = hash_32(hash, tcp_metrics_hash_log);
 
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -382,7 +382,7 @@ static int tcp_v6_err(struct sk_buff *sk
 {
 	const struct ipv6hdr *hdr = (const struct ipv6hdr *)skb->data;
 	const struct tcphdr *th = (struct tcphdr *)(skb->data+offset);
-	struct net *net = dev_net(skb->dev);
+	struct net *net = dev_net_rcu(skb->dev);
 	struct request_sock *fastopen;
 	struct ipv6_pinfo *np;
 	struct tcp_sock *tp;
@@ -897,7 +897,7 @@ static void tcp_v6_send_response(const s
 	struct tcphdr *t1;
 	struct sk_buff *buff;
 	struct flowi6 fl6;
-	struct net *net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
+	struct net *net = sk ? sock_net(sk) : dev_net_rcu(skb_dst(skb)->dev);
 	struct sock *ctl_sk = net->ipv6.tcp_sk;
 	unsigned int tot_len = sizeof(struct tcphdr);
 	__be32 mrst = 0, *topt;
@@ -1047,7 +1047,7 @@ static void tcp_v6_send_reset(const stru
 	if (!sk && !ipv6_unicast_destination(skb))
 		return;
 
-	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
+	net = sk ? sock_net(sk) : dev_net_rcu(skb_dst(skb)->dev);
 #ifdef CONFIG_TCP_MD5SIG
 	rcu_read_lock();
 	hash_location = tcp_parse_md5sig_option(th);
@@ -1633,7 +1633,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(s
 	bool refcounted;
 	struct sock *sk;
 	int ret;
-	struct net *net = dev_net(skb->dev);
+	struct net *net = dev_net_rcu(skb->dev);
 
 	if (skb->pkt_type != PACKET_HOST)
 		goto discard_it;
@@ -1871,7 +1871,7 @@ void tcp_v6_early_demux(struct sk_buff *
 		return;
 
 	/* Note : We use inet6_iif() here, not tcp_v6_iif() */
-	sk = __inet6_lookup_established(dev_net(skb->dev), &tcp_hashinfo,
+	sk = __inet6_lookup_established(dev_net_rcu(skb->dev), &tcp_hashinfo,
 					&hdr->saddr, th->source,
 					&hdr->daddr, ntohs(th->dest),
 					inet6_iif(skb), inet6_sdif(skb));


