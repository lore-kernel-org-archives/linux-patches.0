Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19FB199EBD;
	Thu,  6 Jun 2024 14:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683261; cv=none; b=hVhFZLFUYgxDuWhcq4rr4Md4U718DjeNlLSQtKl75ZwSRRPx1uLRBU65kY7lYso2DPj38qC2lM+g2/G3CIGTug4vEouhXzTJ6zVlIYh+IYP0TNYckHnacz1E5sY+X2qwrghgyruvcmAEU/fVOHz9gvYJXfYh8z9H+EZLqqr2RVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683261; c=relaxed/simple;
	bh=yaeSxjjoN6CVE3uFIEG2/n7wIpSVPX56J8+e9cxEjRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4CxJ0Pa0FiHvB/b/h16gEl8W4vIbaKeVZ6ZIN8tRerjSQjjqUjyBUdsCGj6GwdY5XpeNo8H4VBvJZz4jl/NGr5K7nFAm9OvkVnH/CzjJNOdBepkpozTmO4XgA7bVaL/U0XFCQdbFCNy3xRxAxt6PHL/SUCZwq3a9zneNBOPyag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHIH+hci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHIH+hci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9A4C32781;
	Thu,  6 Jun 2024 14:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683261;
	bh=yaeSxjjoN6CVE3uFIEG2/n7wIpSVPX56J8+e9cxEjRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHIH+hcisOO63TLeSsotDkA6xar302AhtZfVvC5P0t6Qp1Hs/GcckE/d6pz3MtuyO
	 ubYOUBjbX9UMs9KmMrfhilxYQm6+VYZk84T0PxgCFd1bRQWvAZLBPIt9M+alGsC1sP
	 qec4BABPl5nEfk2AhrkMxARpV04g2bMqJ5ryvRLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/473] tcp: avoid premature drops in tcp_add_backlog()
Date: Thu,  6 Jun 2024 16:01:06 +0200
Message-ID: <20240606131704.458524233@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index 5dcb969cb5e9c..befa848fb820c 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1771,7 +1771,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
 		     enum skb_drop_reason *reason)
 {
-	u32 limit, tail_gso_size, tail_gso_segs;
+	u32 tail_gso_size, tail_gso_segs;
 	struct skb_shared_info *shinfo;
 	const struct tcphdr *th;
 	struct tcphdr *thtail;
@@ -1780,6 +1780,7 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
 	bool fragstolen;
 	u32 gso_segs;
 	u32 gso_size;
+	u64 limit;
 	int delta;
 
 	/* In case all data was pulled from skb frags (in __pskb_pull_tail()),
@@ -1877,7 +1878,13 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
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
@@ -1885,6 +1892,8 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
 	 */
 	limit += 64 * 1024;
 
+	limit = min_t(u64, limit, UINT_MAX);
+
 	if (unlikely(sk_add_backlog(sk, skb, limit))) {
 		bh_unlock_sock(sk);
 		*reason = SKB_DROP_REASON_SOCKET_BACKLOG;
-- 
2.43.0



