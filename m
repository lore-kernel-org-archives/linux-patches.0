Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C6251032;
	Mon,  8 Jan 2024 15:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qbiBqIwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9941BC433CB;
	Mon,  8 Jan 2024 15:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728416;
	bh=SQr5f0QqScCMEMJJTZxCrUFp1FngreAIbPNLkbZZE7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbiBqIwJfFpR17BpSOoKlaobBZbib+nyRYab2ZR2hFA13QjlINc7aZsaY9eBKzVe6
	 S/0cvF3OWS6hlRPWWWF4WD/+g1HpG44tFlP73OzyIBmr8lsRDY602YOEYLjbIiOWrJ
	 iROuTYIIK2FTw6YpJfr/JO9t4tj9M9lzlvtO1WjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/150] udp: move udp->gro_enabled to udp->udp_flags
Date: Mon,  8 Jan 2024 16:35:21 +0100
Message-ID: <20240108153514.454552408@linuxfoundation.org>
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
index e6cd46e2b0831..f87e2123fe7b0 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -34,6 +34,7 @@ enum {
 	UDP_FLAGS_CORK,		/* Cork is required */
 	UDP_FLAGS_NO_CHECK6_TX, /* Send zero UDP6 checksums on TX? */
 	UDP_FLAGS_NO_CHECK6_RX, /* Allow zero UDP6 checksums on RX? */
+	UDP_FLAGS_GRO_ENABLED,	/* Request GRO aggregation */
 };
 
 struct udp_sock {
@@ -52,7 +53,6 @@ struct udp_sock {
 					   * different encapsulation layer set
 					   * this
 					   */
-			 gro_enabled:1,	/* Request GRO aggregation */
 			 accept_udp_l4:1,
 			 accept_udp_fraglist:1;
 /* indicator bits used by pcflag: */
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 01e74919885ad..28292fcf07075 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1901,7 +1901,7 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 						      (struct sockaddr *)sin);
 	}
 
-	if (udp_sk(sk)->gro_enabled)
+	if (udp_test_bit(GRO_ENABLED, sk))
 		udp_cmsg_recv(msg, sk, skb);
 
 	if (inet->cmsg_flags)
@@ -2730,7 +2730,7 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 		/* when enabling GRO, accept the related GSO packet type */
 		if (valbool)
 			udp_tunnel_encap_enable(sk->sk_socket);
-		up->gro_enabled = valbool;
+		udp_assign_bit(GRO_ENABLED, sk, valbool);
 		up->accept_udp_l4 = valbool;
 		release_sock(sk);
 		break;
@@ -2820,7 +2820,7 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case UDP_GRO:
-		val = up->gro_enabled;
+		val = udp_test_bit(GRO_ENABLED, sk);
 		break;
 
 	/* The following two cannot be changed on UDP sockets, the return is
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 6d1a4bec2614d..8096576fd9bde 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -549,10 +549,10 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
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
index ae4f7f983f951..ddd17b5ea4259 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -440,7 +440,7 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 						      (struct sockaddr *)sin6);
 	}
 
-	if (udp_sk(sk)->gro_enabled)
+	if (udp_test_bit(GRO_ENABLED, sk))
 		udp_cmsg_recv(msg, sk, skb);
 
 	if (np->rxopt.all)
-- 
2.43.0



