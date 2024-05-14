Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6493B79C;
	Tue, 14 May 2024 11:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687682; cv=none; b=rY/S4jJW30Se4VN8cGZM9wuKmgh1mUTfZDqdjsDypng0XCPRFeYL1/Ydrz8LHISTPt/mAFjT+SS7P8pWCZHyT0tMBJPEw2nP+j0Yacz0ekddcbVmTfoG+p9yHP2c9V+wCSv01J9GkDQquoUrxMcYt9TySrq37TqnlJi+xEr0Rz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687682; c=relaxed/simple;
	bh=rsVz9xRZXKbqw+BECzsz/MBZm8HSElLaXXqkoB6Jv8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dF5xJ2xlAEui9FV8vCFxg3gaM8E9PeHGITl+DktupzSmsqTYZ33NnUj1Hry9simVr+173SxNJg/PQJypC1N+VcDlAB9uNPc3xIv6JefoQNZEuI0VoXNm8KxVdjJql+2UEtzEvjgmCet0JuvouBalr4r+ZgNwR3Szn0q/Yz+B1VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rP+DXzBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rP+DXzBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7939CC2BD10;
	Tue, 14 May 2024 11:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687681;
	bh=rsVz9xRZXKbqw+BECzsz/MBZm8HSElLaXXqkoB6Jv8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rP+DXzBN7qGxcEu9LAxWeP8SqvEOp9nCFikUmJBBervTN7BM2C06JB1aNmGBlVN2o
	 K7MEFr9uKVLceLOWWqwrIbVRD3V3ydISZO1ydgrQpm8r2b310LETISOkd5DD7lrzUc
	 JTaG8/29vuO9F6C+Y5yQlv/rqtjc7D7vsXBfdwfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linke li <lilinke99@qq.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/168] net: mark racy access on sk->sk_rcvbuf
Date: Tue, 14 May 2024 12:19:26 +0200
Message-ID: <20240514101009.263410087@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: linke li <lilinke99@qq.com>

[ Upstream commit c2deb2e971f5d9aca941ef13ee05566979e337a4 ]

sk->sk_rcvbuf in __sock_queue_rcv_skb() and __sk_receive_skb() can be
changed by other threads. Mark this as benign using READ_ONCE().

This patch is aimed at reducing the number of benign races reported by
KCSAN in order to focus future debugging effort on harmful races.

Signed-off-by: linke li <lilinke99@qq.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 6f761f3c272aa..62e376f09f957 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -459,7 +459,7 @@ int __sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	unsigned long flags;
 	struct sk_buff_head *list = &sk->sk_receive_queue;
 
-	if (atomic_read(&sk->sk_rmem_alloc) >= sk->sk_rcvbuf) {
+	if (atomic_read(&sk->sk_rmem_alloc) >= READ_ONCE(sk->sk_rcvbuf)) {
 		atomic_inc(&sk->sk_drops);
 		trace_sock_rcvqueue_full(sk, skb);
 		return -ENOMEM;
@@ -511,7 +511,7 @@ int __sk_receive_skb(struct sock *sk, struct sk_buff *skb,
 
 	skb->dev = NULL;
 
-	if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
+	if (sk_rcvqueues_full(sk, READ_ONCE(sk->sk_rcvbuf))) {
 		atomic_inc(&sk->sk_drops);
 		goto discard_and_relse;
 	}
-- 
2.43.0



