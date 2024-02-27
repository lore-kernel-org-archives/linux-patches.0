Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E865013AA4C;
	Tue, 27 Feb 2024 13:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041375; cv=none; b=AJr7viodNnu/NQjqFxcEm4AXH+bHzFKaCbPJsuNXzSPh5dGLI9OwSwER+GbAbvB+sJvzPgo6YDXWepiQONOLxjNUi7xtaO3E9IY+RrAquI9yooQVJczByWSbN71xSWSThZCeZMKso3ohuF8mjv9ej7ZoNGXSeq+cwZxGfCLPccI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041375; c=relaxed/simple;
	bh=pQ+sh3a0csUHp1ZVIw7rRam+w7apIvYu2o/jbjnvZjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UY2FD3DFaphTEbXnLcPos1cwzofgj1JkCLbKK3PTPx5f33pP0tESOasCTN58OKfGGG487KkqZJ5gikwxvAJbM+euTHAlqv2NLrgX8sze68V3NsaBl2TtuYLs0mwBSBfcve74kwRZHUlMbEqsFwzp6QOlf79+DtDKxcwXXYbBAdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyrMozSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyrMozSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772EFC433F1;
	Tue, 27 Feb 2024 13:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041374;
	bh=pQ+sh3a0csUHp1ZVIw7rRam+w7apIvYu2o/jbjnvZjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uyrMozSaT6rfY4PWbz0Ch57XMPHBP+UagxwOxRqgykDgG6h0KA3ql+nD9geDzxLp7
	 el//W9oEFtcacJef+7p4/4JG5g0PJ29TCAEJUqmJr8tl862UMSkZAyH+4438LshfPz
	 LjU8dMmvBOweOvQU6ORwYdfN6wqg9k9bSq62l6do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <courmisch@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 318/334] phonet/pep: fix racy skb_queue_empty() use
Date: Tue, 27 Feb 2024 14:22:56 +0100
Message-ID: <20240227131641.356956716@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rémi Denis-Courmont <courmisch@gmail.com>

[ Upstream commit 7d2a894d7f487dcb894df023e9d3014cf5b93fe5 ]

The receive queues are protected by their respective spin-lock, not
the socket lock. This could lead to skb_peek() unexpectedly
returning NULL or a pointer to an already dequeued socket buffer.

Fixes: 9641458d3ec4 ("Phonet: Pipe End Point for Phonet Pipes protocol")
Signed-off-by: Rémi Denis-Courmont <courmisch@gmail.com>
Link: https://lore.kernel.org/r/20240218081214.4806-2-remi@remlab.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/phonet/pep.c | 41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index faba31f2eff29..3dd5f52bc1b58 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -917,6 +917,37 @@ static int pep_sock_enable(struct sock *sk, struct sockaddr *addr, int len)
 	return 0;
 }
 
+static unsigned int pep_first_packet_length(struct sock *sk)
+{
+	struct pep_sock *pn = pep_sk(sk);
+	struct sk_buff_head *q;
+	struct sk_buff *skb;
+	unsigned int len = 0;
+	bool found = false;
+
+	if (sock_flag(sk, SOCK_URGINLINE)) {
+		q = &pn->ctrlreq_queue;
+		spin_lock_bh(&q->lock);
+		skb = skb_peek(q);
+		if (skb) {
+			len = skb->len;
+			found = true;
+		}
+		spin_unlock_bh(&q->lock);
+	}
+
+	if (likely(!found)) {
+		q = &sk->sk_receive_queue;
+		spin_lock_bh(&q->lock);
+		skb = skb_peek(q);
+		if (skb)
+			len = skb->len;
+		spin_unlock_bh(&q->lock);
+	}
+
+	return len;
+}
+
 static int pep_ioctl(struct sock *sk, int cmd, int *karg)
 {
 	struct pep_sock *pn = pep_sk(sk);
@@ -929,15 +960,7 @@ static int pep_ioctl(struct sock *sk, int cmd, int *karg)
 			break;
 		}
 
-		lock_sock(sk);
-		if (sock_flag(sk, SOCK_URGINLINE) &&
-		    !skb_queue_empty(&pn->ctrlreq_queue))
-			*karg = skb_peek(&pn->ctrlreq_queue)->len;
-		else if (!skb_queue_empty(&sk->sk_receive_queue))
-			*karg = skb_peek(&sk->sk_receive_queue)->len;
-		else
-			*karg = 0;
-		release_sock(sk);
+		*karg = pep_first_packet_length(sk);
 		ret = 0;
 		break;
 
-- 
2.43.0



