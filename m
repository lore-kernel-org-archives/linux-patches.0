Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70AC7F48C;
	Tue, 14 May 2024 11:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686795; cv=none; b=c8ijuDcu2kBWiiL+1ZxxQkVsO3gZx4E0w+oh8bMkcB8rd7gaQIs/EPWsbacp/Bi7UrXxZ0Bs6zVfjRxS+75g6wFW/uBseBnujZw9kueK3elBn9w2v6RwAFekiz2S7RS8mbKDzjSNBQ2/Tg7xgaFmM/qJ8/PNpSG6Cvby46Zg618=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686795; c=relaxed/simple;
	bh=QwlrryOvmTknbgjW87pv9+cBuQqYazLq7yQw+s3cga0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqawOvXIst7wQkejHx1N0kB11SFfI/ia1TRRZR4rX/1vtoey433AQlXV6Ry29j0b1jL2hyOSS+XvB+5QCllRZj/lr32Srq68z1kD9Zh0mvklanVceH/ZYlwcU29916Z6VDcjGo8NPGQScILNjveQ2vkmHkb/LHUAw+7UmDNZ2GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dt1RYj5a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dt1RYj5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBB1C2BD10;
	Tue, 14 May 2024 11:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686794;
	bh=QwlrryOvmTknbgjW87pv9+cBuQqYazLq7yQw+s3cga0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dt1RYj5abUqo3EjRS8XOjCWPjSgATME51eFLY2X6GpaIROPcoJI2B7UHA17GK0Ev/
	 o71xHgBFVJ0nY9L/0rfuD3rrlq2QLapQmyjz1Pm7vSP+NquU1/U+kC3wnWeWa50U01
	 hH9xXuqLDNRpwbGGk2BieuFKMvz02A153Y70061U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linke li <lilinke99@qq.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/63] net: mark racy access on sk->sk_rcvbuf
Date: Tue, 14 May 2024 12:19:46 +0200
Message-ID: <20240514100948.968013605@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index eaa6f1ca414d0..c1d60df487fc0 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -404,7 +404,7 @@ int __sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	unsigned long flags;
 	struct sk_buff_head *list = &sk->sk_receive_queue;
 
-	if (atomic_read(&sk->sk_rmem_alloc) >= sk->sk_rcvbuf) {
+	if (atomic_read(&sk->sk_rmem_alloc) >= READ_ONCE(sk->sk_rcvbuf)) {
 		atomic_inc(&sk->sk_drops);
 		trace_sock_rcvqueue_full(sk, skb);
 		return -ENOMEM;
@@ -456,7 +456,7 @@ int __sk_receive_skb(struct sock *sk, struct sk_buff *skb,
 
 	skb->dev = NULL;
 
-	if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
+	if (sk_rcvqueues_full(sk, READ_ONCE(sk->sk_rcvbuf))) {
 		atomic_inc(&sk->sk_drops);
 		goto discard_and_relse;
 	}
-- 
2.43.0



