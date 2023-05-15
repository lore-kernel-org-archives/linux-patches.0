Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4DCFC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381F8C433EF;
	Mon, 15 May 2023 17:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171024;
	bh=H1FWlXP83lMIzC6FlGmja1MxJ6GgUcXSQL9G4k2Axs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EcZ1Rl3ERrP3twqYktGDCEsXrk5JeoAtZGY8JL0NtW0Wo52gUbDUONRcD/qXJO0mZ
	 SLu7DVVVR2yK+/qaGFAEU3FL7kv1imW5XXBhGGqgVu/lI6JNV1EeCEMJLehXx0TLNK
	 1ch5aPBnnMdoYVjymyi1HkRpyTYtLJaObvIPnIWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 047/242] net: ipv6: fix skb hash for some RST packets
Date: Mon, 15 May 2023 18:26:13 +0200
Message-Id: <20230515161723.327672864@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit dc6456e938e938d64ffb6383a286b2ac9790a37f ]

The skb hash comes from sk->sk_txhash when using TCP, except for some
IPv6 RST packets. This is because in tcp_v6_send_reset when not in
TIME_WAIT the hash is taken from sk->sk_hash, while it should come from
sk->sk_txhash as those two hashes are not computed the same way.

Packetdrill script to test the above,

   0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
  +0 fcntl(3, F_SETFL, O_RDWR|O_NONBLOCK) = 0
  +0 connect(3, ..., ...) = -1 EINPROGRESS (Operation now in progress)

  +0 > (flowlabel 0x1) S 0:0(0) <...>

  // Wrong ack seq, trigger a rst.
  +0 < S. 0:0(0) ack 0 win 4000

  // Check the flowlabel matches prior one from SYN.
  +0 > (flowlabel 0x1) R 0:0(0) <...>

Fixes: 9258b8b1be2e ("ipv6: tcp: send consistent autoflowlabel in RST packets")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/tcp_ipv6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index e4da7267ed4bd..e0706c33e5472 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1064,7 +1064,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 			if (np->repflow)
 				label = ip6_flowlabel(ipv6h);
 			priority = sk->sk_priority;
-			txhash = sk->sk_hash;
+			txhash = sk->sk_txhash;
 		}
 		if (sk->sk_state == TCP_TIME_WAIT) {
 			label = cpu_to_be32(inet_twsk(sk)->tw_flowlabel);
-- 
2.39.2



