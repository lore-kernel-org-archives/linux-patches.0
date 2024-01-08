Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E63B53E1C;
	Mon,  8 Jan 2024 15:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXIx5xsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE89C433C7;
	Mon,  8 Jan 2024 15:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728419;
	bh=8tDiDeN13//ZW1OjdYgR0K5DdUeqhzyb5C3ZZU/RbEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXIx5xsqC4fU9huOdXTQ3TU7F++TICcLkaXlu57b5RbT7n20rTGlLiZK+1tlq+Q5E
	 zVZRaRzcuCSGkJHCeDcKlc6EKDOtR1Y15i4U4fW6Vhoh50sS1rT3k0RCOO/Am3Ca/G
	 B/sIQN12LCNi/E8y5gxjh7PCo3auJwosqD/gsRjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/150] udp: move udp->accept_udp_{l4|fraglist} to udp->udp_flags
Date: Mon,  8 Jan 2024 16:35:22 +0100
Message-ID: <20240108153514.490699426@linuxfoundation.org>
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

[ Upstream commit f5f52f0884a595ff99ab1a608643fe4025fca2d5 ]

These are read locklessly, move them to udp_flags to fix data-races.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 70a36f571362 ("udp: annotate data-races around udp->encap_type")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/udp.h | 16 +++++++++-------
 net/ipv4/udp.c      |  2 +-
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index f87e2123fe7b0..0e6880856246a 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -35,6 +35,8 @@ enum {
 	UDP_FLAGS_NO_CHECK6_TX, /* Send zero UDP6 checksums on TX? */
 	UDP_FLAGS_NO_CHECK6_RX, /* Allow zero UDP6 checksums on RX? */
 	UDP_FLAGS_GRO_ENABLED,	/* Request GRO aggregation */
+	UDP_FLAGS_ACCEPT_FRAGLIST,
+	UDP_FLAGS_ACCEPT_L4,
 };
 
 struct udp_sock {
@@ -48,13 +50,11 @@ struct udp_sock {
 
 	int		 pending;	/* Any pending frames ? */
 	__u8		 encap_type;	/* Is this an Encapsulation socket? */
-	unsigned char	 encap_enabled:1, /* This socket enabled encap
+	unsigned char	 encap_enabled:1; /* This socket enabled encap
 					   * processing; UDP tunnels and
 					   * different encapsulation layer set
 					   * this
 					   */
-			 accept_udp_l4:1,
-			 accept_udp_fraglist:1;
 /* indicator bits used by pcflag: */
 #define UDPLITE_BIT      0x1  		/* set by udplite proto init function */
 #define UDPLITE_SEND_CC  0x2  		/* set via udplite setsockopt         */
@@ -146,10 +146,12 @@ static inline bool udp_unexpected_gso(struct sock *sk, struct sk_buff *skb)
 	if (!skb_is_gso(skb))
 		return false;
 
-	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 && !udp_sk(sk)->accept_udp_l4)
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 &&
+	    !udp_test_bit(ACCEPT_L4, sk))
 		return true;
 
-	if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST && !udp_sk(sk)->accept_udp_fraglist)
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST &&
+	    !udp_test_bit(ACCEPT_FRAGLIST, sk))
 		return true;
 
 	return false;
@@ -157,8 +159,8 @@ static inline bool udp_unexpected_gso(struct sock *sk, struct sk_buff *skb)
 
 static inline void udp_allow_gso(struct sock *sk)
 {
-	udp_sk(sk)->accept_udp_l4 = 1;
-	udp_sk(sk)->accept_udp_fraglist = 1;
+	udp_set_bit(ACCEPT_L4, sk);
+	udp_set_bit(ACCEPT_FRAGLIST, sk);
 }
 
 #define udp_portaddr_for_each_entry(__sk, list) \
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 28292fcf07075..df0ea45b8b8f2 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2731,7 +2731,7 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 		if (valbool)
 			udp_tunnel_encap_enable(sk->sk_socket);
 		udp_assign_bit(GRO_ENABLED, sk, valbool);
-		up->accept_udp_l4 = valbool;
+		udp_assign_bit(ACCEPT_L4, sk, valbool);
 		release_sock(sk);
 		break;
 
-- 
2.43.0



