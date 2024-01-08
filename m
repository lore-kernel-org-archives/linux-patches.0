Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4187E51C29;
	Mon,  8 Jan 2024 15:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1ibFmTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F4EC433C7;
	Mon,  8 Jan 2024 15:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728406;
	bh=U3MBtuZrtJAFxmL3uxJShMbjzdKeRN6WxiTXj2ECELM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1ibFmTLhgmKLVMDumunNkXC/dPl6dwhEkYXxFkJkEJalB8B0lpELOvZHk/kLVgUm
	 yJSe23Cmr6gPPgqnQg+BWIfflIAFWaNyurfpYUYEWtQCLip/ihHZR/bM5quD3Jnjfe
	 P/r+5B9o8z3+JBmA185+faGbwfFKOYhkONtDzGKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/150] udp: introduce udp->udp_flags
Date: Mon,  8 Jan 2024 16:35:18 +0100
Message-ID: <20240108153514.318130115@linuxfoundation.org>
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

[ Upstream commit 81b36803ac139827538ac5ce4028e750a3c53f53 ]

According to syzbot, it is time to use proper atomic flags
for various UDP flags.

Add udp_flags field, and convert udp->corkflag to first
bit in it.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: a0002127cd74 ("udp: move udp->no_check6_tx to udp->udp_flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/udp.h | 28 +++++++++++++++++++++-------
 net/ipv4/udp.c      | 12 ++++++------
 net/ipv6/udp.c      |  6 +++---
 3 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index e96da4157d04d..10b56b8231e3c 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -30,14 +30,20 @@ static inline u32 udp_hashfn(const struct net *net, u32 num, u32 mask)
 	return (num + net_hash_mix(net)) & mask;
 }
 
+enum {
+	UDP_FLAGS_CORK,		/* Cork is required */
+};
+
 struct udp_sock {
 	/* inet_sock has to be the first member */
 	struct inet_sock inet;
 #define udp_port_hash		inet.sk.__sk_common.skc_u16hashes[0]
 #define udp_portaddr_hash	inet.sk.__sk_common.skc_u16hashes[1]
 #define udp_portaddr_node	inet.sk.__sk_common.skc_portaddr_node
+
+	unsigned long	 udp_flags;
+
 	int		 pending;	/* Any pending frames ? */
-	unsigned int	 corkflag;	/* Cork is required */
 	__u8		 encap_type;	/* Is this an Encapsulation socket? */
 	unsigned char	 no_check6_tx:1,/* Send zero UDP6 checksums on TX? */
 			 no_check6_rx:1,/* Allow zero UDP6 checksums on RX? */
@@ -49,6 +55,11 @@ struct udp_sock {
 			 gro_enabled:1,	/* Request GRO aggregation */
 			 accept_udp_l4:1,
 			 accept_udp_fraglist:1;
+/* indicator bits used by pcflag: */
+#define UDPLITE_BIT      0x1  		/* set by udplite proto init function */
+#define UDPLITE_SEND_CC  0x2  		/* set via udplite setsockopt         */
+#define UDPLITE_RECV_CC  0x4		/* set via udplite setsocktopt        */
+	__u8		 pcflag;        /* marks socket as UDP-Lite if > 0    */
 	/*
 	 * Following member retains the information to create a UDP header
 	 * when the socket is uncorked.
@@ -60,12 +71,6 @@ struct udp_sock {
 	 */
 	__u16		 pcslen;
 	__u16		 pcrlen;
-/* indicator bits used by pcflag: */
-#define UDPLITE_BIT      0x1  		/* set by udplite proto init function */
-#define UDPLITE_SEND_CC  0x2  		/* set via udplite setsockopt         */
-#define UDPLITE_RECV_CC  0x4		/* set via udplite setsocktopt        */
-	__u8		 pcflag;        /* marks socket as UDP-Lite if > 0    */
-	__u8		 unused[3];
 	/*
 	 * For encapsulation sockets.
 	 */
@@ -89,6 +94,15 @@ struct udp_sock {
 	int		forward_deficit;
 };
 
+#define udp_test_bit(nr, sk)			\
+	test_bit(UDP_FLAGS_##nr, &udp_sk(sk)->udp_flags)
+#define udp_set_bit(nr, sk)			\
+	set_bit(UDP_FLAGS_##nr, &udp_sk(sk)->udp_flags)
+#define udp_clear_bit(nr, sk)			\
+	clear_bit(UDP_FLAGS_##nr, &udp_sk(sk)->udp_flags)
+#define udp_assign_bit(nr, sk, val)		\
+	assign_bit(UDP_FLAGS_##nr, &udp_sk(sk)->udp_flags, val)
+
 #define UDP_MAX_SEGMENTS	(1 << 6UL)
 
 static inline struct udp_sock *udp_sk(const struct sock *sk)
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index e8dd2880ac9aa..60a754477efb2 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1068,7 +1068,7 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	__be16 dport;
 	u8  tos;
 	int err, is_udplite = IS_UDPLITE(sk);
-	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
+	int corkreq = udp_test_bit(CORK, sk) || msg->msg_flags & MSG_MORE;
 	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
 	struct sk_buff *skb;
 	struct ip_options_data opt_copy;
@@ -1337,11 +1337,11 @@ void udp_splice_eof(struct socket *sock)
 	struct sock *sk = sock->sk;
 	struct udp_sock *up = udp_sk(sk);
 
-	if (!up->pending || READ_ONCE(up->corkflag))
+	if (!up->pending || udp_test_bit(CORK, sk))
 		return;
 
 	lock_sock(sk);
-	if (up->pending && !READ_ONCE(up->corkflag))
+	if (up->pending && !udp_test_bit(CORK, sk))
 		udp_push_pending_frames(sk);
 	release_sock(sk);
 }
@@ -2673,9 +2673,9 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 	switch (optname) {
 	case UDP_CORK:
 		if (val != 0) {
-			WRITE_ONCE(up->corkflag, 1);
+			udp_set_bit(CORK, sk);
 		} else {
-			WRITE_ONCE(up->corkflag, 0);
+			udp_clear_bit(CORK, sk);
 			lock_sock(sk);
 			push_pending_frames(sk);
 			release_sock(sk);
@@ -2800,7 +2800,7 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 
 	switch (optname) {
 	case UDP_CORK:
-		val = READ_ONCE(up->corkflag);
+		val = udp_test_bit(CORK, sk);
 		break;
 
 	case UDP_ENCAP:
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 2a65136dca773..85653e3a04fe8 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1351,7 +1351,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	int addr_len = msg->msg_namelen;
 	bool connected = false;
 	int ulen = len;
-	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
+	int corkreq = udp_test_bit(CORK, sk) || msg->msg_flags & MSG_MORE;
 	int err;
 	int is_udplite = IS_UDPLITE(sk);
 	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
@@ -1662,11 +1662,11 @@ static void udpv6_splice_eof(struct socket *sock)
 	struct sock *sk = sock->sk;
 	struct udp_sock *up = udp_sk(sk);
 
-	if (!up->pending || READ_ONCE(up->corkflag))
+	if (!up->pending || udp_test_bit(CORK, sk))
 		return;
 
 	lock_sock(sk);
-	if (up->pending && !READ_ONCE(up->corkflag))
+	if (up->pending && !udp_test_bit(CORK, sk))
 		udp_v6_push_pending_frames(sk);
 	release_sock(sk);
 }
-- 
2.43.0



