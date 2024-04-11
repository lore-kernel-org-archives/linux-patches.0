Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0830414601D;
	Thu, 11 Apr 2024 10:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830827; cv=none; b=C56jDJbxR+d5/X9qnxqlNmhDjMt483hP5WAliwGqDh/TAkcO4dEW//UhgcpXqE8Ok7OsqgOyBDCN6y2DalomyQxxfe1kZ7EM+CzkRq4LUGg76R5Q3BM017xTq7yoHcQnqqq3F+7kN+ur8bmalJwiM9CzA89dv2oXKSw8jRGf7yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830827; c=relaxed/simple;
	bh=AybVFBT32mCXM+2eTHP020t60cAbUBiJx6Nl1d8IsHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keQg4ND5E/EQVQCXi5mc3FEuYe0xr3q4w6u55NY9Cfuy/9AbRC+o50Su8unOsu+wn1eG4HhyNJ2vpj0vJE2NTDhRIw/3JG1xuzwgrw82q73is4DzT6zKwShcCZxK6FcPt5zTH18otCtPpKLQ+F7gKC+K28csopnzj45VorlorQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1G1E17p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1G1E17p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811B5C433F1;
	Thu, 11 Apr 2024 10:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830826;
	bh=AybVFBT32mCXM+2eTHP020t60cAbUBiJx6Nl1d8IsHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1G1E17p8q/Dq62XgXb8xKk6q0sV1VYA4JFK+gw9Q327YwpoKRWVpjJz86KYilT6G
	 SKhPSA+oUHtLv5StP8NkYHsby8Cgl/9/3a6VR6clN0OjuBfw9guK5qCWZ0m8oiZVQT
	 h0Hs3maMNplFd+tRB0kkww/DlcH3cIHSEB9n9spI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Eric Dumazet <edumazet@google.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 131/215] tcp: properly terminate timers for kernel sockets
Date: Thu, 11 Apr 2024 11:55:40 +0200
Message-ID: <20240411095428.834063426@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 151c9c724d05d5b0dd8acd3e11cb69ef1f2dbada ]

We had various syzbot reports about tcp timers firing after
the corresponding netns has been dismantled.

Fortunately Josef Bacik could trigger the issue more often,
and could test a patch I wrote two years ago.

When TCP sockets are closed, we call inet_csk_clear_xmit_timers()
to 'stop' the timers.

inet_csk_clear_xmit_timers() can be called from any context,
including when socket lock is held.
This is the reason it uses sk_stop_timer(), aka del_timer().
This means that ongoing timers might finish much later.

For user sockets, this is fine because each running timer
holds a reference on the socket, and the user socket holds
a reference on the netns.

For kernel sockets, we risk that the netns is freed before
timer can complete, because kernel sockets do not hold
reference on the netns.

This patch adds inet_csk_clear_xmit_timers_sync() function
that using sk_stop_timer_sync() to make sure all timers
are terminated before the kernel socket is released.
Modules using kernel sockets close them in their netns exit()
handler.

Also add sock_not_owned_by_me() helper to get LOCKDEP
support : inet_csk_clear_xmit_timers_sync() must not be called
while socket lock is held.

It is very possible we can revert in the future commit
3a58f13a881e ("net: rds: acquire refcount on TCP sockets")
which attempted to solve the issue in rds only.
(net/smc/af_smc.c and net/mptcp/subflow.c have similar code)

We probably can remove the check_net() tests from
tcp_out_of_resources() and __tcp_close() in the future.

Reported-by: Josef Bacik <josef@toxicpanda.com>
Closes: https://lore.kernel.org/netdev/20240314210740.GA2823176@perftesting/
Fixes: 26abe14379f8 ("net: Modify sk_alloc to not reference count the netns of kernel sockets.")
Fixes: 8a68173691f0 ("net: sk_clone_lock() should only do get_net() if the parent is not a kernel socket")
Link: https://lore.kernel.org/bpf/CANn89i+484ffqb93aQm1N-tjxxvb3WDKX0EbD7318RwRgsatjw@mail.gmail.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Tested-by: Josef Bacik <josef@toxicpanda.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://lore.kernel.org/r/20240322135732.1535772-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_connection_sock.h |  1 +
 include/net/sock.h                 |  7 +++++++
 net/ipv4/inet_connection_sock.c    | 14 ++++++++++++++
 net/ipv4/tcp.c                     |  2 ++
 4 files changed, 24 insertions(+)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 13792c0ef46e3..180ff3ca823a9 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -176,6 +176,7 @@ void inet_csk_init_xmit_timers(struct sock *sk,
 			       void (*delack_handler)(struct timer_list *),
 			       void (*keepalive_handler)(struct timer_list *));
 void inet_csk_clear_xmit_timers(struct sock *sk);
+void inet_csk_clear_xmit_timers_sync(struct sock *sk);
 
 static inline void inet_csk_schedule_ack(struct sock *sk)
 {
diff --git a/include/net/sock.h b/include/net/sock.h
index 5293f2b65fb55..8d592df7251f8 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1605,6 +1605,13 @@ static inline void sock_owned_by_me(const struct sock *sk)
 #endif
 }
 
+static inline void sock_not_owned_by_me(const struct sock *sk)
+{
+#ifdef CONFIG_LOCKDEP
+	WARN_ON_ONCE(lockdep_sock_is_held(sk) && debug_locks);
+#endif
+}
+
 static inline bool sock_owned_by_user(const struct sock *sk)
 {
 	sock_owned_by_me(sk);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 374a0c3f39cc1..091999dbef335 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -560,6 +560,20 @@ void inet_csk_clear_xmit_timers(struct sock *sk)
 }
 EXPORT_SYMBOL(inet_csk_clear_xmit_timers);
 
+void inet_csk_clear_xmit_timers_sync(struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	/* ongoing timer handlers need to acquire socket lock. */
+	sock_not_owned_by_me(sk);
+
+	icsk->icsk_pending = icsk->icsk_ack.pending = 0;
+
+	sk_stop_timer_sync(sk, &icsk->icsk_retransmit_timer);
+	sk_stop_timer_sync(sk, &icsk->icsk_delack_timer);
+	sk_stop_timer_sync(sk, &sk->sk_timer);
+}
+
 void inet_csk_delete_keepalive_timer(struct sock *sk)
 {
 	sk_stop_timer(sk, &sk->sk_timer);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8ebcff40bc5ac..ca7863f722187 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2529,6 +2529,8 @@ void tcp_close(struct sock *sk, long timeout)
 	lock_sock(sk);
 	__tcp_close(sk, timeout);
 	release_sock(sk);
+	if (!sk->sk_net_refcnt)
+		inet_csk_clear_xmit_timers_sync(sk);
 	sock_put(sk);
 }
 EXPORT_SYMBOL(tcp_close);
-- 
2.43.0



