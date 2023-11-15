Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8191731721
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yu8MHuYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F90C433C9;
	Wed, 15 Nov 2023 19:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076882;
	bh=Di1t5ziuomQN17ancCnvB30ekUL9FFR+YHcGjrCbAKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yu8MHuYnsPj+BU6nTVezdDVpFDdKaZhZI7paaR4sfV0ksz6QjyOq6pA8wVO+9vdm0
	 WJ7dYvmTPE9FWSn7URuLDxoJiVZpntx1DsXfd+YNDgFpHZJZcs+fqOFiZtmENNCHWq
	 HJPYpMaotpYebz4Vp6cuAhxv8pvxDJan6X10I2Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/603] udp: move udp->gro_enabled to udp->udp_flags
Date: Wed, 15 Nov 2023 14:10:01 -0500
Message-ID: <20231115191616.997904567@linuxfoundation.org>
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

[ Upstream commit e1dc0615c6b08ef36414f08c011965b8fb56198b ]

syzbot reported that udp->gro_enabled can be read locklessly.
Use one atomic bit from udp->udp_flags.

Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/udp.h    | 2 +-
 net/ipv4/udp.c         | 6 +++---
 net/ipv4/udp_offload.c | 4 ++--
 net/ipv6/udp.c         | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index 8d4c3835b1b21..b344bd2e41fc9 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -36,6 +36,7 @@ enum {
 	UDP_FLAGS_CORK,		/* Cork is required */
 	UDP_FLAGS_NO_CHECK6_TX, /* Send zero UDP6 checksums on TX? */
 	UDP_FLAGS_NO_CHECK6_RX, /* Allow zero UDP6 checksums on RX? */
+	UDP_FLAGS_GRO_ENABLED,	/* Request GRO aggregation */
 };
 
 struct udp_sock {
@@ -54,7 +55,6 @@ struct udp_sock {
 					   * different encapsulation layer set
 					   * this
 					   */
-			 gro_enabled:1,	/* Request GRO aggregation */
 			 accept_udp_l4:1,
 			 accept_udp_fraglist:1;
 /* indicator bits used by pcflag: */
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index cb32826a1db20..1debc10a0f029 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1868,7 +1868,7 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 						      (struct sockaddr *)sin);
 	}
 
-	if (udp_sk(sk)->gro_enabled)
+	if (udp_test_bit(GRO_ENABLED, sk))
 		udp_cmsg_recv(msg, sk, skb);
 
 	if (inet_cmsg_flags(inet))
@@ -2713,7 +2713,7 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 		/* when enabling GRO, accept the related GSO packet type */
 		if (valbool)
 			udp_tunnel_encap_enable(sk->sk_socket);
-		up->gro_enabled = valbool;
+		udp_assign_bit(GRO_ENABLED, sk, valbool);
 		up->accept_udp_l4 = valbool;
 		release_sock(sk);
 		break;
@@ -2803,7 +2803,7 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case UDP_GRO:
-		val = up->gro_enabled;
+		val = udp_test_bit(GRO_ENABLED, sk);
 		break;
 
 	/* The following two cannot be changed on UDP sockets, the return is
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 0f46b3c2e4ac5..6c95d28d0c4a7 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -557,10 +557,10 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
 	NAPI_GRO_CB(skb)->is_flist = 0;
 	if (!sk || !udp_sk(sk)->gro_receive) {
 		if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
-			NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled : 1;
+			NAPI_GRO_CB(skb)->is_flist = sk ? !udp_test_bit(GRO_ENABLED, sk) : 1;
 
 		if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
-		    (sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist)
+		    (sk && udp_test_bit(GRO_ENABLED, sk)) || NAPI_GRO_CB(skb)->is_flist)
 			return call_gro_receive(udp_gro_receive_segment, head, skb);
 
 		/* no GRO, be sure flush the current packet */
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 6e1ea3029260e..2c3281879b6df 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -413,7 +413,7 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 						      (struct sockaddr *)sin6);
 	}
 
-	if (udp_sk(sk)->gro_enabled)
+	if (udp_test_bit(GRO_ENABLED, sk))
 		udp_cmsg_recv(msg, sk, skb);
 
 	if (np->rxopt.all)
-- 
2.42.0



