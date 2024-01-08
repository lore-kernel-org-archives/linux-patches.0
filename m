Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7584153E3C;
	Mon,  8 Jan 2024 15:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2JCtydT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90680C433C7;
	Mon,  8 Jan 2024 15:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728423;
	bh=v+HuSb7ZVkCPFQ5gXlwqH0pTgTwna2tNT2YVzAAhkyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2JCtydT+mYTWNI+SWqUo4U8KKjmFDIT8rBG9e2ZAZmqQ8rZSwIkSFWKEMW3JVFVW
	 PREFa6IyITWyrqfUOKxRgf82CrC/z3o/AZFRCysZS2xCxcuJO7/R86qtyJIPdXsX79
	 TubNf0myCmp0q13OJlaFJ6i4mOL/xAHbM6BwsaQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/150] udp: lockless UDP_ENCAP_L2TPINUDP / UDP_GRO
Date: Mon,  8 Jan 2024 16:35:23 +0100
Message-ID: <20240108153514.532709551@linuxfoundation.org>
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

[ Upstream commit ac9a7f4ce5dda1472e8f44096f33066c6ec1a3b4 ]

Move udp->encap_enabled to udp->udp_flags.

Add udp_test_and_set_bit() helper to allow lockless
udp_tunnel_encap_enable() implementation.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 70a36f571362 ("udp: annotate data-races around udp->encap_type")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/udp.h        |  9 ++++-----
 include/net/udp_tunnel.h   |  9 +++------
 net/ipv4/udp.c             | 10 +++-------
 net/ipv4/udp_tunnel_core.c |  2 +-
 net/ipv6/udp.c             |  2 +-
 5 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index 0e6880856246a..efd9ab6df3797 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -37,6 +37,7 @@ enum {
 	UDP_FLAGS_GRO_ENABLED,	/* Request GRO aggregation */
 	UDP_FLAGS_ACCEPT_FRAGLIST,
 	UDP_FLAGS_ACCEPT_L4,
+	UDP_FLAGS_ENCAP_ENABLED, /* This socket enabled encap */
 };
 
 struct udp_sock {
@@ -50,11 +51,7 @@ struct udp_sock {
 
 	int		 pending;	/* Any pending frames ? */
 	__u8		 encap_type;	/* Is this an Encapsulation socket? */
-	unsigned char	 encap_enabled:1; /* This socket enabled encap
-					   * processing; UDP tunnels and
-					   * different encapsulation layer set
-					   * this
-					   */
+
 /* indicator bits used by pcflag: */
 #define UDPLITE_BIT      0x1  		/* set by udplite proto init function */
 #define UDPLITE_SEND_CC  0x2  		/* set via udplite setsockopt         */
@@ -98,6 +95,8 @@ struct udp_sock {
 	test_bit(UDP_FLAGS_##nr, &udp_sk(sk)->udp_flags)
 #define udp_set_bit(nr, sk)			\
 	set_bit(UDP_FLAGS_##nr, &udp_sk(sk)->udp_flags)
+#define udp_test_and_set_bit(nr, sk)		\
+	test_and_set_bit(UDP_FLAGS_##nr, &udp_sk(sk)->udp_flags)
 #define udp_clear_bit(nr, sk)			\
 	clear_bit(UDP_FLAGS_##nr, &udp_sk(sk)->udp_flags)
 #define udp_assign_bit(nr, sk, val)		\
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index 72394f441dad8..e5f81710b18f4 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -174,16 +174,13 @@ static inline int udp_tunnel_handle_offloads(struct sk_buff *skb, bool udp_csum)
 }
 #endif
 
-static inline void udp_tunnel_encap_enable(struct socket *sock)
+static inline void udp_tunnel_encap_enable(struct sock *sk)
 {
-	struct udp_sock *up = udp_sk(sock->sk);
-
-	if (up->encap_enabled)
+	if (udp_test_and_set_bit(ENCAP_ENABLED, sk))
 		return;
 
-	up->encap_enabled = 1;
 #if IS_ENABLED(CONFIG_IPV6)
-	if (sock->sk->sk_family == PF_INET6)
+	if (READ_ONCE(sk->sk_family) == PF_INET6)
 		ipv6_stub->udpv6_encap_enable();
 #endif
 	udp_encap_enable();
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index df0ea45b8b8f2..267f77633a8f3 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2645,7 +2645,7 @@ void udp_destroy_sock(struct sock *sk)
 			if (encap_destroy)
 				encap_destroy(sk);
 		}
-		if (up->encap_enabled)
+		if (udp_test_bit(ENCAP_ENABLED, sk))
 			static_branch_dec(&udp_encap_needed_key);
 	}
 }
@@ -2700,9 +2700,7 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 			fallthrough;
 		case UDP_ENCAP_L2TPINUDP:
 			up->encap_type = val;
-			lock_sock(sk);
-			udp_tunnel_encap_enable(sk->sk_socket);
-			release_sock(sk);
+			udp_tunnel_encap_enable(sk);
 			break;
 		default:
 			err = -ENOPROTOOPT;
@@ -2725,14 +2723,12 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case UDP_GRO:
-		lock_sock(sk);
 
 		/* when enabling GRO, accept the related GSO packet type */
 		if (valbool)
-			udp_tunnel_encap_enable(sk->sk_socket);
+			udp_tunnel_encap_enable(sk);
 		udp_assign_bit(GRO_ENABLED, sk, valbool);
 		udp_assign_bit(ACCEPT_L4, sk, valbool);
-		release_sock(sk);
 		break;
 
 	/*
diff --git a/net/ipv4/udp_tunnel_core.c b/net/ipv4/udp_tunnel_core.c
index 5f8104cf082d0..732e21b75ba28 100644
--- a/net/ipv4/udp_tunnel_core.c
+++ b/net/ipv4/udp_tunnel_core.c
@@ -78,7 +78,7 @@ void setup_udp_tunnel_sock(struct net *net, struct socket *sock,
 	udp_sk(sk)->gro_receive = cfg->gro_receive;
 	udp_sk(sk)->gro_complete = cfg->gro_complete;
 
-	udp_tunnel_encap_enable(sock);
+	udp_tunnel_encap_enable(sk);
 }
 EXPORT_SYMBOL_GPL(setup_udp_tunnel_sock);
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index ddd17b5ea4259..5b7c4f8e2ed03 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1688,7 +1688,7 @@ void udpv6_destroy_sock(struct sock *sk)
 			if (encap_destroy)
 				encap_destroy(sk);
 		}
-		if (up->encap_enabled) {
+		if (udp_test_bit(ENCAP_ENABLED, sk)) {
 			static_branch_dec(&udpv6_encap_needed_key);
 			udp_encap_disable();
 		}
-- 
2.43.0



