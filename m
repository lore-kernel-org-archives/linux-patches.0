Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076623BB38
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlJryVjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A808BC433CB;
	Wed, 15 Nov 2023 19:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076110;
	bh=DCGcYQga3gVpR/ZL9yFL6xUbmJgkiabcYpch+NjfPvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WlJryVjzhjLVcUIUxIiKa/9b2LAk0FNv3N4rq5YRA84FFKw+WddHzTgkQlYnRULh5
	 OMPgPIDZZYVBLdBPcDHENfZyQl0QJAToaYjdNDDiQsRa8ba3M5jgH3bv4VY7MxePlm
	 0aQEFW3xG+l22q2bIKERlgJMwIsfRb0rFZq45ISs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 058/550] udp: move udp->no_check6_rx to udp->udp_flags
Date: Wed, 15 Nov 2023 14:10:42 -0500
Message-ID: <20231115191604.701440014@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit bcbc1b1de884647aa0318bf74eb7f293d72a1e40 ]

syzbot reported that udp->no_check6_rx can be read locklessly.
Use one atomic bit from udp->udp_flags.

Fixes: 1c19448c9ba6 ("net: Make enabling of zero UDP6 csums more restrictive")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/udp.h | 10 +++++-----
 net/ipv4/udp.c      |  4 ++--
 net/ipv6/udp.c      |  6 +++---
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index e3f2a6c7ac1d1..8d4c3835b1b21 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -35,6 +35,7 @@ static inline u32 udp_hashfn(const struct net *net, u32 num, u32 mask)
 enum {
 	UDP_FLAGS_CORK,		/* Cork is required */
 	UDP_FLAGS_NO_CHECK6_TX, /* Send zero UDP6 checksums on TX? */
+	UDP_FLAGS_NO_CHECK6_RX, /* Allow zero UDP6 checksums on RX? */
 };
 
 struct udp_sock {
@@ -48,8 +49,7 @@ struct udp_sock {
 
 	int		 pending;	/* Any pending frames ? */
 	__u8		 encap_type;	/* Is this an Encapsulation socket? */
-	unsigned char	 no_check6_rx:1,/* Allow zero UDP6 checksums on RX? */
-			 encap_enabled:1, /* This socket enabled encap
+	unsigned char	 encap_enabled:1, /* This socket enabled encap
 					   * processing; UDP tunnels and
 					   * different encapsulation layer set
 					   * this
@@ -120,7 +120,7 @@ static inline void udp_set_no_check6_tx(struct sock *sk, bool val)
 
 static inline void udp_set_no_check6_rx(struct sock *sk, bool val)
 {
-	udp_sk(sk)->no_check6_rx = val;
+	udp_assign_bit(NO_CHECK6_RX, sk, val);
 }
 
 static inline bool udp_get_no_check6_tx(const struct sock *sk)
@@ -128,9 +128,9 @@ static inline bool udp_get_no_check6_tx(const struct sock *sk)
 	return udp_test_bit(NO_CHECK6_TX, sk);
 }
 
-static inline bool udp_get_no_check6_rx(struct sock *sk)
+static inline bool udp_get_no_check6_rx(const struct sock *sk)
 {
-	return udp_sk(sk)->no_check6_rx;
+	return udp_test_bit(NO_CHECK6_RX, sk);
 }
 
 static inline void udp_cmsg_recv(struct msghdr *msg, struct sock *sk,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 716eaddc7bdd0..6b1754704acd1 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2723,7 +2723,7 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case UDP_NO_CHECK6_RX:
-		up->no_check6_rx = valbool;
+		udp_set_no_check6_rx(sk, valbool);
 		break;
 
 	case UDP_SEGMENT:
@@ -2820,7 +2820,7 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case UDP_NO_CHECK6_RX:
-		val = up->no_check6_rx;
+		val = udp_get_no_check6_rx(sk);
 		break;
 
 	case UDP_SEGMENT:
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index c4f82dfa533fe..1df116951f5eb 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -891,7 +891,7 @@ static int __udp6_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 		/* If zero checksum and no_check is not on for
 		 * the socket then skip it.
 		 */
-		if (!uh->check && !udp_sk(sk)->no_check6_rx)
+		if (!uh->check && !udp_get_no_check6_rx(sk))
 			continue;
 		if (!first) {
 			first = sk;
@@ -1009,7 +1009,7 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 		if (unlikely(rcu_dereference(sk->sk_rx_dst) != dst))
 			udp6_sk_rx_dst_set(sk, dst);
 
-		if (!uh->check && !udp_sk(sk)->no_check6_rx) {
+		if (!uh->check && !udp_get_no_check6_rx(sk)) {
 			if (refcounted)
 				sock_put(sk);
 			goto report_csum_error;
@@ -1031,7 +1031,7 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	/* Unicast */
 	sk = __udp6_lib_lookup_skb(skb, uh->source, uh->dest, udptable);
 	if (sk) {
-		if (!uh->check && !udp_sk(sk)->no_check6_rx)
+		if (!uh->check && !udp_get_no_check6_rx(sk))
 			goto report_csum_error;
 		return udp6_unicast_rcv_skb(sk, skb, uh);
 	}
-- 
2.42.0



