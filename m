Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558ECFBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDB4C433D2;
	Mon, 15 May 2023 17:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170180;
	bh=zR/MR+9ktuNOUQ+JJs3AqTZ5R6s7XFhFQeF0gPmLkug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLhBFqcQ5P2XJWgTUaTmPUiay+0r2mhOFT7yT1WgRclfymCqO5cViDQKwpIMUr6KZ
	 ghmQGIblm4DMZSfshMh5DhKHunxXKdiA3r9oT4HGK6+SoSXluDI/9F/LdF/q6TLU37
	 voIYQ5nV2AUGXOkUAw8/fLtq2KLgA5N53fWohspw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/239] net: ipv6: fix skb hash for some RST packets
Date: Mon, 15 May 2023 18:25:12 +0200
Message-Id: <20230515161723.179474607@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
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
index c563a84d67b46..8d61efeab9c99 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1065,7 +1065,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
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



