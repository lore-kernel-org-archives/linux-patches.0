Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB1B1E495;
	Tue, 14 May 2024 11:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684924; cv=none; b=RsPuZuKABNXmmDk0Xv/lfRgV7k4a2g1i1E6PwRouYj8XYvaJPoAS8iUVjR8GQRnQfYQvzA/ieaDXy5tFQe9grH2TCf2H7KeYF4ZHj/S+VC8BfOq+jKl47r6N1XZAYyvQIFjYYHheJtkhXCDetQlEAfQReGvuqfiYiLjuZmUykDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684924; c=relaxed/simple;
	bh=3xsdb9kKlSFjxddmgORKVwPL+1f3rzd5OnMMZvOe+b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=queRW0FBYlYmYCzgPC7eEQCQssHyc1xiS6NWzk6eKxlP9+wRu10hV12zDkgzJDURI+CfCJD7x5JDckOs5oR7NaDMoMS7k1VxOIBbOU/7wztRGO7JWpNRbPw6gOOQELjlrCGqlNl16JwObxEnC70fhVt+B5d4P0jJE6WIsnrCpKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=egeMoTgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="egeMoTgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5927C2BD10;
	Tue, 14 May 2024 11:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684924;
	bh=3xsdb9kKlSFjxddmgORKVwPL+1f3rzd5OnMMZvOe+b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=egeMoTgbHvcVRmu5r/oMwjAozjVC0LI52rsd3CevuAIbrqZ19ns10n/ZQvYznDCUx
	 cF3EI6Xg5mGh35hd2YHfQRHl8bZFlnzcqf47dSV/yZ6eHusWnRLx9Ax9vxE5pTfq1i
	 T6HfZdR3ZAStmatMvVhlgHeZzm74GKFvYo4VfPV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linke li <lilinke99@qq.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/301] net: mark racy access on sk->sk_rcvbuf
Date: Tue, 14 May 2024 12:16:20 +0200
Message-ID: <20240514101036.366546637@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1471c0a862b36..7f64a7b95cfb2 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -486,7 +486,7 @@ int __sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	unsigned long flags;
 	struct sk_buff_head *list = &sk->sk_receive_queue;
 
-	if (atomic_read(&sk->sk_rmem_alloc) >= sk->sk_rcvbuf) {
+	if (atomic_read(&sk->sk_rmem_alloc) >= READ_ONCE(sk->sk_rcvbuf)) {
 		atomic_inc(&sk->sk_drops);
 		trace_sock_rcvqueue_full(sk, skb);
 		return -ENOMEM;
@@ -556,7 +556,7 @@ int __sk_receive_skb(struct sock *sk, struct sk_buff *skb,
 
 	skb->dev = NULL;
 
-	if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
+	if (sk_rcvqueues_full(sk, READ_ONCE(sk->sk_rcvbuf))) {
 		atomic_inc(&sk->sk_drops);
 		goto discard_and_relse;
 	}
-- 
2.43.0



