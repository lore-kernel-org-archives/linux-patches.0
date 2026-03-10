Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50E238737C;
	Tue, 10 Mar 2026 11:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141209; cv=none; b=OqvdIDDuY+firr4fBY6F1LPdJjl52zxhCiH1WW1gGoqsBLi9GHMTF78fku1lae1uAWdzzVeJBXUDAjP5Zp87RvIV1IMsk3eJXQnKfIMjLghQxfaFZsxlsrvvB6uyOZmbtB+kZGJJEmFHwAING4dZTCjhO/WT3TyWjBvLF2HX5Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141209; c=relaxed/simple;
	bh=y6n96sPJDZ2I8gUj/9scgkBbfc9iO/oVRW/ZW7INqUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpESXgzgT9YpsBHWI7wRnCY/axHSUnC10OqsPk8+QNCSvRWUQJtk9W8wL3K9VRVRgUNApuZjzWGXUKYJBeaBzyuhJyUfcCwHtYq6O2+58vsB0MdCe/0fzrlSM0wsO/ZnmJbTuuQfPmkgJqKT55bLcuM5MRRK4FURA3M9fd/DjdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EAyt1QYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EAyt1QYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E27C2BC86;
	Tue, 10 Mar 2026 11:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141209;
	bh=y6n96sPJDZ2I8gUj/9scgkBbfc9iO/oVRW/ZW7INqUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EAyt1QYEuzYmhTNK/ULuVRoGBHMcW8mv7j58rKpEMYgOsySZ8AoAhzU+1X01Z6rl8
	 wu3XzEt10xBZ9FFeT+gY6Ikn/mRZzHJMeZan3MmucX4Tmr5PcVt1CY8UIW9l15SYtB
	 KtdyInpqF8cPbHocQo3SIqznZSyZdi/zAkkmHW41Jkl6iP4589DoxniDhqz4g/rjgm
	 VUm9gJoHueMe3w7pGQB+6KEEjH8M6qZgL946Ds6vp+XiFnAHjCiae10i5214oneQa5
	 5diEvu4oiZgaIFNDHqmqC/5hGj7UvRx6oXqR12MRCwiDOYgf58MebcEuig3hDM2C7w
	 9v7D40ORHVj+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 210/311] tcp: give up on stronger sk_rcvbuf checks (for now)
Date: Tue, 10 Mar 2026 07:04:17 -0400
Message-ID: <c9c6ffc3a954eb305ad8f82b28ee546c7d55e778.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 026dfef287c07f37d4d4eef7a0b5a4bfdb29b32d ]

We hit another corner case which leads to TcpExtTCPRcvQDrop

Connections which send RPCs in the 20-80kB range over loopback
experience spurious drops. The exact conditions for most of
the drops I investigated are that:
 - socket exchanged >1MB of data so its not completely fresh
 - rcvbuf is around 128kB (default, hasn't grown)
 - there is ~60kB of data in rcvq
 - skb > 64kB arrives

The sum of skb->len (!) of both of the skbs (the one already
in rcvq and the arriving one) is larger than rwnd.
My suspicion is that this happens because __tcp_select_window()
rounds the rwnd up to (1 << wscale) if less than half of
the rwnd has been consumed.

Eric suggests that given the number of Fixes we already have
pointing to 1d2fbaad7cd8 it's probably time to give up on it,
until a bigger revamp of rmem management.

Also while we could risk tweaking the rwnd math, there are other
drops on workloads I investigated, after the commit in question,
not explained by this phenomenon.

Suggested-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/20260225122355.585fd57b@kernel.org
Fixes: 1d2fbaad7cd8 ("tcp: stronger sk_rcvbuf checks")
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260227003359.2391017-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index adec44313772b..1c9db9a246f71 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5116,25 +5116,11 @@ static void tcp_ofo_queue(struct sock *sk)
 static bool tcp_prune_ofo_queue(struct sock *sk, const struct sk_buff *in_skb);
 static int tcp_prune_queue(struct sock *sk, const struct sk_buff *in_skb);
 
-/* Check if this incoming skb can be added to socket receive queues
- * while satisfying sk->sk_rcvbuf limit.
- *
- * In theory we should use skb->truesize, but this can cause problems
- * when applications use too small SO_RCVBUF values.
- * When LRO / hw gro is used, the socket might have a high tp->scaling_ratio,
- * allowing RWIN to be close to available space.
- * Whenever the receive queue gets full, we can receive a small packet
- * filling RWIN, but with a high skb->truesize, because most NIC use 4K page
- * plus sk_buff metadata even when receiving less than 1500 bytes of payload.
- *
- * Note that we use skb->len to decide to accept or drop this packet,
- * but sk->sk_rmem_alloc is the sum of all skb->truesize.
- */
 static bool tcp_can_ingest(const struct sock *sk, const struct sk_buff *skb)
 {
 	unsigned int rmem = atomic_read(&sk->sk_rmem_alloc);
 
-	return rmem + skb->len <= sk->sk_rcvbuf;
+	return rmem <= sk->sk_rcvbuf;
 }
 
 static int tcp_try_rmem_schedule(struct sock *sk, const struct sk_buff *skb,
-- 
2.51.0

