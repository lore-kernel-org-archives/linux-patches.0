Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A651212FAD;
	Sat, 12 Sep 2026 09:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204780; cv=none; b=nScpIoOJmI4ff5rou1JdAYmulyn2UQ6FIsrOWyw9FpsKSP71k4gvduuu2ERsXnDoI5afBvxq48tBDC0pcq8GGwV3ZutWKGs186n4Wtyirww1d7sf3RmoexnDZ9qzuWLW80wHCkHgch990sQxOuRzQyegkWI7iByjwEtwh9v9P0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204780; c=relaxed/simple;
	bh=1HaB2p/w5k7Ku/FOT0dxJhzTSTYtBfLTDp7t+KHkIMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgXT9RxajLQep5TFO66D4rAdW3FMf7YKmHevLmXiLYPEq3aKtQd+IIvi18bpj8i3FQJBjEAf3OOUQPF6t+hnWmGPPlPurhZRZt5KX0bpk1uwtR9CjPg8aBPOF3k7Fu+g00F5qz0eeNrMxr3DFKhrp4bV2LZXxA0kXTPxwC7IgyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvZohJ6k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvZohJ6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631071F000FF;
	Sat, 12 Sep 2026 09:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204779;
	bh=WsN/IPSQ4TARyI89Li460myGM0OMIgcP+5PGXM36lE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RvZohJ6kx9ejYDb/cXodWDiK3S6ivRvFt/FEDogw9vx7PJlsYy0yrst+KrYdWsXZV
	 oKnvnhopujwY75pZ+0X8Ke1UQRHeVGbk3NaGBPo/czMYVt6a0U86fjK9GbzHfLAd4k
	 iHdyqMce7zKhr/8MSormKKwuhQpuSDDiwkm7dmQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Bobby Eshleman <bobbyeshleman@gmail.com>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1682/1815] net: tcp: block mixing readable and unreadable frags
Date: Sat, 12 Sep 2026 08:57:12 +0200
Message-ID: <20260912065728.470501504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mina Almasry <almasrymina@google.com>

[ Upstream commit d9c56501c72fdac937e8b770f31655c46832f1a5 ]

Protect tcp_sendmsg_locked() from mistakenly mixing readable and
unreadable page fragments in the same SKB.

Check that the devmem binding matches the existing SKB's readability.
If a mismatch is detected, avoid collapsing and create a new segment.

Fixes: bd61848900bff ("net: devmem: Implement TX path")
Suggested-by: Eric Dumazet <edumazet@google.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Bobby Eshleman <bobbyeshleman@gmail.com>
Signed-off-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20260814191336.187243-2-almasrymina@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 455441f1b6949..b4237d0e994d6 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1240,7 +1240,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 		trace_tcp_sendmsg_locked(sk, msg, skb, size_goal);
 
-		if (copy <= 0 || !tcp_skb_can_collapse_to(skb)) {
+		if (copy <= 0 || !tcp_skb_can_collapse_to(skb) ||
+		    unlikely(skb_frags_readable(skb) != !binding)) {
 			bool first_skb;
 
 new_segment:
-- 
2.53.0



