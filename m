Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036DB31721
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGOU3lWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90EBC433CB;
	Wed, 15 Nov 2023 19:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076875;
	bh=KVkd7GqzUV5E+ZXDseWzMdjNjmcGRfiOueSrYwJTB24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGOU3lWnyhZECq5PzeY5Te0LwJzZV90MDFijLdc6edmpvMKArrDVTXqcOGjLndCWP
	 z79IfnXWF48Hx9e7M9jc7exGta6opvNum2a5heD/9tj1V88biz23Os/mvXIF7aaKeM
	 ticBS1xZniZiB0MkfCus42Yik5GoM93roLGJBggs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/603] udp: move udp->no_check6_tx to udp->udp_flags
Date: Wed, 15 Nov 2023 14:09:59 -0500
Message-ID: <20231115191616.857216367@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 23f0693e0d9cc..e3f2a6c7ac1d1 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -34,6 +34,7 @@ static inline u32 udp_hashfn(const struct net *net, u32 num, u32 mask)
 
 enum {
 	UDP_FLAGS_CORK,		/* Cork is required */
+	UDP_FLAGS_NO_CHECK6_TX, /* Send zero UDP6 checksums on TX? */
 };
 
 struct udp_sock {
@@ -47,8 +48,7 @@ struct udp_sock {
 
 	int		 pending;	/* Any pending frames ? */
 	__u8		 encap_type;	/* Is this an Encapsulation socket? */
-	unsigned char	 no_check6_tx:1,/* Send zero UDP6 checksums on TX? */
-			 no_check6_rx:1,/* Allow zero UDP6 checksums on RX? */
+	unsigned char	 no_check6_rx:1,/* Allow zero UDP6 checksums on RX? */
 			 encap_enabled:1, /* This socket enabled encap
 					   * processing; UDP tunnels and
 					   * different encapsulation layer set
@@ -115,7 +115,7 @@ struct udp_sock {
 
 static inline void udp_set_no_check6_tx(struct sock *sk, bool val)
 {
-	udp_sk(sk)->no_check6_tx = val;
+	udp_assign_bit(NO_CHECK6_TX, sk, val);
 }
 
 static inline void udp_set_no_check6_rx(struct sock *sk, bool val)
@@ -123,9 +123,9 @@ static inline void udp_set_no_check6_rx(struct sock *sk, bool val)
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
index 9709f8a532dc3..0c6998291c99d 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2694,7 +2694,7 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case UDP_NO_CHECK6_TX:
-		up->no_check6_tx = valbool;
+		udp_set_no_check6_tx(sk, valbool);
 		break;
 
 	case UDP_NO_CHECK6_RX:
@@ -2791,7 +2791,7 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case UDP_NO_CHECK6_TX:
-		val = up->no_check6_tx;
+		val = udp_get_no_check6_tx(sk);
 		break;
 
 	case UDP_NO_CHECK6_RX:
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 0c6973cd22ce4..469df0ca561f7 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1241,7 +1241,7 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 			kfree_skb(skb);
 			return -EINVAL;
 		}
-		if (udp_sk(sk)->no_check6_tx) {
+		if (udp_get_no_check6_tx(sk)) {
 			kfree_skb(skb);
 			return -EINVAL;
 		}
@@ -1262,7 +1262,7 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 
 	if (is_udplite)
 		csum = udplite_csum(skb);
-	else if (udp_sk(sk)->no_check6_tx) {   /* UDP csum disabled */
+	else if (udp_get_no_check6_tx(sk)) {   /* UDP csum disabled */
 		skb->ip_summed = CHECKSUM_NONE;
 		goto send;
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) { /* UDP hardware csum */
-- 
2.42.0



