Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A03351032;
	Mon,  8 Jan 2024 15:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtZp4Vdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E34C433C9;
	Mon,  8 Jan 2024 15:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728409;
	bh=G1mF/vu03goSmKkb4WZqSADh897sLQHwbCM3GC9Jm0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtZp4VdxsJG0UskwYL2K+gDRwfLo2Y1Muv0ollAanpljAy0j2H2X8lWHmWxw0vPnu
	 dqW5nekGEONj9t9VgzWLyBSy4GrDJ+LYdUxnfxE/smRs4zPnmMa9od9GrvMWzrGK6K
	 Z0ySGFI+xpIc8w8nl2o0yBHtHIvLjFbHzN7t7ivU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/150] udp: move udp->no_check6_tx to udp->udp_flags
Date: Mon,  8 Jan 2024 16:35:19 +0100
Message-ID: <20240108153514.367252253@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a0002127cd746fcaa182ad3386ef6931c37f3bda ]

syzbot reported that udp->no_check6_tx can be read locklessly.
Use one atomic bit from udp->udp_flags

Fixes: 1c19448c9ba6 ("net: Make enabling of zero UDP6 csums more restrictive")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/udp.h | 10 +++++-----
 net/ipv4/udp.c      |  4 ++--
 net/ipv6/udp.c      |  4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index 10b56b8231e3c..b5ca5760ae34b 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -32,6 +32,7 @@ static inline u32 udp_hashfn(const struct net *net, u32 num, u32 mask)
 
 enum {
 	UDP_FLAGS_CORK,		/* Cork is required */
+	UDP_FLAGS_NO_CHECK6_TX, /* Send zero UDP6 checksums on TX? */
 };
 
 struct udp_sock {
@@ -45,8 +46,7 @@ struct udp_sock {
 
 	int		 pending;	/* Any pending frames ? */
 	__u8		 encap_type;	/* Is this an Encapsulation socket? */
-	unsigned char	 no_check6_tx:1,/* Send zero UDP6 checksums on TX? */
-			 no_check6_rx:1,/* Allow zero UDP6 checksums on RX? */
+	unsigned char	 no_check6_rx:1,/* Allow zero UDP6 checksums on RX? */
 			 encap_enabled:1, /* This socket enabled encap
 					   * processing; UDP tunnels and
 					   * different encapsulation layer set
@@ -112,7 +112,7 @@ static inline struct udp_sock *udp_sk(const struct sock *sk)
 
 static inline void udp_set_no_check6_tx(struct sock *sk, bool val)
 {
-	udp_sk(sk)->no_check6_tx = val;
+	udp_assign_bit(NO_CHECK6_TX, sk, val);
 }
 
 static inline void udp_set_no_check6_rx(struct sock *sk, bool val)
@@ -120,9 +120,9 @@ static inline void udp_set_no_check6_rx(struct sock *sk, bool val)
 	udp_sk(sk)->no_check6_rx = val;
 }
 
-static inline bool udp_get_no_check6_tx(struct sock *sk)
+static inline bool udp_get_no_check6_tx(const struct sock *sk)
 {
-	return udp_sk(sk)->no_check6_tx;
+	return udp_test_bit(NO_CHECK6_TX, sk);
 }
 
 static inline bool udp_get_no_check6_rx(struct sock *sk)
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 60a754477efb2..513035e83a820 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2711,7 +2711,7 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case UDP_NO_CHECK6_TX:
-		up->no_check6_tx = valbool;
+		udp_set_no_check6_tx(sk, valbool);
 		break;
 
 	case UDP_NO_CHECK6_RX:
@@ -2808,7 +2808,7 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case UDP_NO_CHECK6_TX:
-		val = up->no_check6_tx;
+		val = udp_get_no_check6_tx(sk);
 		break;
 
 	case UDP_NO_CHECK6_RX:
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 85653e3a04fe8..c6e20293c521f 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1260,7 +1260,7 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 			kfree_skb(skb);
 			return -EINVAL;
 		}
-		if (udp_sk(sk)->no_check6_tx) {
+		if (udp_get_no_check6_tx(sk)) {
 			kfree_skb(skb);
 			return -EINVAL;
 		}
@@ -1281,7 +1281,7 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 
 	if (is_udplite)
 		csum = udplite_csum(skb);
-	else if (udp_sk(sk)->no_check6_tx) {   /* UDP csum disabled */
+	else if (udp_get_no_check6_tx(sk)) {   /* UDP csum disabled */
 		skb->ip_summed = CHECKSUM_NONE;
 		goto send;
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) { /* UDP hardware csum */
-- 
2.43.0



