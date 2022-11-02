Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782B87E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C97FC433D6;
	Wed,  2 Nov 2022 03:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358995;
	bh=94MnjSlwLSxtCna29xDvcbdO9jAWPlUqLMvPUqKIX28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jsxXhLhKuhnntY/seL/uTMpY72zIxEWb8w5l2vEb9/8ZM8FMwZI2e9ZUURBiIOfKr
	 ZV7DUx/JnDQ3A9TY+glij4Aa8JRQhmP27VIdOkJvJAmDPny3+bv0TsyAoC7YhIID7g
	 K7YzKVJqxroy5uxuN5Vo9NLTbJQzOcVGzpq0p5i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 58/91] tcp: minor optimization in tcp_add_backlog()
Date: Wed,  2 Nov 2022 03:33:41 +0100
Message-Id: <20221102022056.677367806@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d519f350967a60b85a574ad8aeac43f2b4384746 ]

If packet is going to be coalesced, sk_sndbuf/sk_rcvbuf values
are not used. Defer their access to the point we need them.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ec791d8149ff ("tcp: fix a signed-integer-overflow bug in tcp_add_backlog()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 5c1e6b0687e2..78cef6930484 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1770,8 +1770,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 
 bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 {
-	u32 limit = READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf);
-	u32 tail_gso_size, tail_gso_segs;
+	u32 limit, tail_gso_size, tail_gso_segs;
 	struct skb_shared_info *shinfo;
 	const struct tcphdr *th;
 	struct tcphdr *thtail;
@@ -1878,7 +1877,7 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 	 * to reduce memory overhead, so add a little headroom here.
 	 * Few sockets backlog are possibly concurrently non empty.
 	 */
-	limit += 64*1024;
+	limit = READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf) + 64*1024;
 
 	if (unlikely(sk_add_backlog(sk, skb, limit))) {
 		bh_unlock_sock(sk);
-- 
2.35.1



