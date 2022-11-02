Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBD37E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73012C433C1;
	Wed,  2 Nov 2022 03:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359001;
	bh=dF7YYbiPXqZBY1j3GEfIX9sfKnZtmHo6YRhVvpe1BH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBRwUZ0JHH2++E1uWejhLVy32kiokg7BFZUORMcJxXua0NtWUh3A2wQ8JFduTra5q
	 q5Cr9ckzI28Amy5Go4XKYSgGRJx/u/1SrZtKwrvpLR95k77+NZtINhY28BU21OQ/xH
	 aFbAZwlGg38x4IVinSq/cLd65cWc3Y64EKaKyyzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Wei <luwei32@huawei.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 59/91] tcp: fix a signed-integer-overflow bug in tcp_add_backlog()
Date: Wed,  2 Nov 2022 03:33:42 +0100
Message-Id: <20221102022056.706569113@linuxfoundation.org>
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

From: Lu Wei <luwei32@huawei.com>

[ Upstream commit ec791d8149ff60c40ad2074af3b92a39c916a03f ]

The type of sk_rcvbuf and sk_sndbuf in struct sock is int, and
in tcp_add_backlog(), the variable limit is caculated by adding
sk_rcvbuf, sk_sndbuf and 64 * 1024, it may exceed the max value
of int and overflow. This patch reduces the limit budget by
halving the sndbuf to solve this issue since ACK packets are much
smaller than the payload.

Fixes: c9c3321257e1 ("tcp: add tcp_add_backlog()")
Signed-off-by: Lu Wei <luwei32@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 78cef6930484..31a8009f74ee 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1873,11 +1873,13 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 	__skb_push(skb, hdrlen);
 
 no_coalesce:
+	limit = (u32)READ_ONCE(sk->sk_rcvbuf) + (u32)(READ_ONCE(sk->sk_sndbuf) >> 1);
+
 	/* Only socket owner can try to collapse/prune rx queues
 	 * to reduce memory overhead, so add a little headroom here.
 	 * Few sockets backlog are possibly concurrently non empty.
 	 */
-	limit = READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf) + 64*1024;
+	limit += 64 * 1024;
 
 	if (unlikely(sk_add_backlog(sk, skb, limit))) {
 		bh_unlock_sock(sk);
-- 
2.35.1



