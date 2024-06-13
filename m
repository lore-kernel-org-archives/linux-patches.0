Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370F4EC4;
	Thu, 13 Jun 2024 12:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281971; cv=none; b=e4VPonfqoyzlNM5qS44ASwiwg9UdVu3SMi+Tz53cFdIvNZf4rPbYoj0oXWnehJ2wNWSM2+xsRLiCzk1gTgdqtj1b4flu7g4mCrcxs1pg9IbIuC/Xg185DoMX3yJSYw3Audt4YHQU1iS4rHtAFP5bg7CysU+skdckT6ddxgzqH/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281971; c=relaxed/simple;
	bh=HkgnaXPSnHM0PeDE5RWxB2P1yggoiegIoQLVwm3k5i4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFZKJJrycLlqdLZuuHL87fSzzFT4MNJd45oa/zZbG8+gw0ykTsbqjLJ2QyeS/rN2nZvh50RvSZioM0p2/dCslSdu9ZTde/WJt3o22NK8pLjs2iJvcINStIwUScX0T5aexTDLrUgTyCELFIbPwZTnR68MlO17f6ScrfXEBFsvS+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qVJMYI3H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qVJMYI3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B255FC2BBFC;
	Thu, 13 Jun 2024 12:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281971;
	bh=HkgnaXPSnHM0PeDE5RWxB2P1yggoiegIoQLVwm3k5i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVJMYI3HzkMuOd49J/nmYglJ1/st9beOjLE3Y+vwIgcfjomu7wGmKnSZglSG82YCN
	 3P0tSbAUDwxHF6BVq29Y1fVifK1QaeY4HRTsqrngBy5vEVW4quQTDYrNdPt37wt6dI
	 yJyaoXIMzYpJqvF+jfHzgwcQr1yHC8W0Vbu0GGnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/402] tcp: avoid premature drops in tcp_add_backlog()
Date: Thu, 13 Jun 2024 13:30:45 +0200
Message-ID: <20240613113305.569507785@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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
index e162bed1916ae..e9b1dcf2d463a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1817,7 +1817,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 
 bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 {
-	u32 limit, tail_gso_size, tail_gso_segs;
+	u32 tail_gso_size, tail_gso_segs;
 	struct skb_shared_info *shinfo;
 	const struct tcphdr *th;
 	struct tcphdr *thtail;
@@ -1826,6 +1826,7 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 	bool fragstolen;
 	u32 gso_segs;
 	u32 gso_size;
+	u64 limit;
 	int delta;
 
 	/* In case all data was pulled from skb frags (in __pskb_pull_tail()),
@@ -1922,7 +1923,13 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
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
@@ -1930,6 +1937,8 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 	 */
 	limit += 64 * 1024;
 
+	limit = min_t(u64, limit, UINT_MAX);
+
 	if (unlikely(sk_add_backlog(sk, skb, limit))) {
 		bh_unlock_sock(sk);
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPBACKLOGDROP);
-- 
2.43.0



