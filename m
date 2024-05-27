Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC7C1078F;
	Mon, 27 May 2024 19:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836771; cv=none; b=kWVqaeFWDj0nU6WkUiS8D0b+5n9Of/k0QBamyKGUaJ5AdUjGP4jAayKx0HybPex1iOr/5tD8mx2Lpzekgi0qGPiXQWnk8uZBHwe01kNrEMS/rYUwil6ET5QAn0YXYKYQeVIno3wgq0m/alYfAKGo/zCIeGwnhutNMqXT5iXaLeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836771; c=relaxed/simple;
	bh=wVL9Ym44VWpQLXxfGd+vB2XcoOCOCnTUOkicJ08PpCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ib5BbX5cYTuKCZcJ4tdyxU8QuOntZxqkIGcZBPOup7U63nX+4EvOVuXTa3nuScZEaHcrrGUbP49oT+0G6GqmPQYjUHeb3JKD/eyjuQe1GxVXAOkp/FJqvAaxSu17dcnL7haCRV/m6PITRIHiBGhE+vJtXBNkzTXnKu4L0b3jDEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxS4JFg7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxS4JFg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5D4C2BBFC;
	Mon, 27 May 2024 19:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836770;
	bh=wVL9Ym44VWpQLXxfGd+vB2XcoOCOCnTUOkicJ08PpCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxS4JFg7XO9yXUMrpYEgRdS9ecU2C47NFDS1Tvjm8lT/o47fcRAnrFQFpBqboRINs
	 S6nvCbNv8gJ35kJE9j894sbwmefGj5nHyIVulHiGGwEpHpCFSK8a9La/DpBcSBnn9y
	 160TZYH1fgTgan0SZOrKSir4nSRF9VAas7yMoKGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 179/427] tcp: avoid premature drops in tcp_add_backlog()
Date: Mon, 27 May 2024 20:53:46 +0200
Message-ID: <20240527185618.935552157@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ec00ed472bdb7d0af840da68c8c11bff9f4d9caa ]

While testing TCP performance with latest trees,
I saw suspect SOCKET_BACKLOG drops.

tcp_add_backlog() computes its limit with :

    limit = (u32)READ_ONCE(sk->sk_rcvbuf) +
            (u32)(READ_ONCE(sk->sk_sndbuf) >> 1);
    limit += 64 * 1024;

This does not take into account that sk->sk_backlog.len
is reset only at the very end of __release_sock().

Both sk->sk_backlog.len and sk->sk_rmem_alloc could reach
sk_rcvbuf in normal conditions.

We should double sk->sk_rcvbuf contribution in the formula
to absorb bubbles in the backlog, which happen more often
for very fast flows.

This change maintains decent protection against abuses.

Fixes: c377411f2494 ("net: sk_add_backlog() take rmem_alloc into account")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240423125620.3309458-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index e0cef75f85fb9..92511b7fd5249 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2001,7 +2001,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
 		     enum skb_drop_reason *reason)
 {
-	u32 limit, tail_gso_size, tail_gso_segs;
+	u32 tail_gso_size, tail_gso_segs;
 	struct skb_shared_info *shinfo;
 	const struct tcphdr *th;
 	struct tcphdr *thtail;
@@ -2010,6 +2010,7 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
 	bool fragstolen;
 	u32 gso_segs;
 	u32 gso_size;
+	u64 limit;
 	int delta;
 
 	/* In case all data was pulled from skb frags (in __pskb_pull_tail()),
@@ -2107,7 +2108,13 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
 	__skb_push(skb, hdrlen);
 
 no_coalesce:
-	limit = (u32)READ_ONCE(sk->sk_rcvbuf) + (u32)(READ_ONCE(sk->sk_sndbuf) >> 1);
+	/* sk->sk_backlog.len is reset only at the end of __release_sock().
+	 * Both sk->sk_backlog.len and sk->sk_rmem_alloc could reach
+	 * sk_rcvbuf in normal conditions.
+	 */
+	limit = ((u64)READ_ONCE(sk->sk_rcvbuf)) << 1;
+
+	limit += ((u32)READ_ONCE(sk->sk_sndbuf)) >> 1;
 
 	/* Only socket owner can try to collapse/prune rx queues
 	 * to reduce memory overhead, so add a little headroom here.
@@ -2115,6 +2122,8 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
 	 */
 	limit += 64 * 1024;
 
+	limit = min_t(u64, limit, UINT_MAX);
+
 	if (unlikely(sk_add_backlog(sk, skb, limit))) {
 		bh_unlock_sock(sk);
 		*reason = SKB_DROP_REASON_SOCKET_BACKLOG;
-- 
2.43.0



