Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4C213B284;
	Tue, 14 May 2024 11:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686330; cv=none; b=eMlUBVcjTqmS6MC7mttWu51MTDyLunoVVQJvpiYfUfwu9Prtjd5dfHB09ykxTxcTt1yGUJN8Km7tRH6Gv9NhvNxBKCXbXec9aEASNSRmqAzWKjNnjaYs0NOxJ95DWtIlirXZrfz3oVCm5j+KrJFit4K7LyCYZrDZ3UulhZ57G7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686330; c=relaxed/simple;
	bh=bBVVUMqPuq9VasLlhOvV0FAejTBB0pCbYvkLcDxiwEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7AUNkz1s+LGuwdn91cP24eVOZKjvr6Di44q0F7uxBnlDmALoYGvsdPsT/qHxVouVbP6iX1e+WBPt125c2wFhNknVhV6vpzYHewmwoqttE2K9R4EXA5qangSXv2EIihZ4xXwwdIE66AIvzBz/0u/GBX/B9f6YQOJsq6eMNOhUiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYnRM1Cj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYnRM1Cj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857F2C2BD10;
	Tue, 14 May 2024 11:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686329;
	bh=bBVVUMqPuq9VasLlhOvV0FAejTBB0pCbYvkLcDxiwEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WYnRM1CjY2IukHSn0yUkjVzMjB+Bi9dOiVAmVKJadiJOqaJnHWeo4e0fibmNuLnJ+
	 /Lo5ZzrnqQ3UFFd09UcnTgx9W59hx0+DGSPlRrnf5D0wUTSWZbPcZ6S0GKSUiAdVNJ
	 hExhgW1qkw1VD0GUbn+DJLw/zsKCLqHCFZ9MzKr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linke li <lilinke99@qq.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/236] net: mark racy access on sk->sk_rcvbuf
Date: Tue, 14 May 2024 12:17:42 +0200
Message-ID: <20240514101024.166817366@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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
index 550af616f5359..48199e6e8f161 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -482,7 +482,7 @@ int __sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	unsigned long flags;
 	struct sk_buff_head *list = &sk->sk_receive_queue;
 
-	if (atomic_read(&sk->sk_rmem_alloc) >= sk->sk_rcvbuf) {
+	if (atomic_read(&sk->sk_rmem_alloc) >= READ_ONCE(sk->sk_rcvbuf)) {
 		atomic_inc(&sk->sk_drops);
 		trace_sock_rcvqueue_full(sk, skb);
 		return -ENOMEM;
@@ -552,7 +552,7 @@ int __sk_receive_skb(struct sock *sk, struct sk_buff *skb,
 
 	skb->dev = NULL;
 
-	if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
+	if (sk_rcvqueues_full(sk, READ_ONCE(sk->sk_rcvbuf))) {
 		atomic_inc(&sk->sk_drops);
 		goto discard_and_relse;
 	}
-- 
2.43.0



