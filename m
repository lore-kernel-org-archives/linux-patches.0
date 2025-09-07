Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35F94315A;
	Sun,  7 Sep 2025 20:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277652; cv=none; b=SaCFCQLqN9mh/iAoPiINjvLneWIaMNHS8LYGGJbeqZ7cfK+bYayMLG8t+yMPEJa0bHMKu4L/KZisP4UYFSsNn2F+lQusIEmMi/4e7Oyn7q7LaAi+3GVFaARPMSzzY8j5RPzD+lV0BfDSOSFxKIWTx34PqrwdTiSWGpvSNe4bd4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277652; c=relaxed/simple;
	bh=FWzush1vtC3QOtq71bE0DRHoZ55gOROvcJD4uM3dkXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4dK6iVn0nB5h0wVrKiXjz2hyaMyMmN56+TwiffbOiH9ZBJS9rtvpq9XL37XXHMkng5shG+dR/3J6/ABL8fj3/h0/a+533CsEmIi+HKGFGaBVThzO51FjmVHWXuvf62BMAidhAcGzBh9LUBn0DYDMhYhkkGNQoixPh3gs1tkp70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BiY1KoS/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BiY1KoS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F03C4CEF0;
	Sun,  7 Sep 2025 20:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277652;
	bh=FWzush1vtC3QOtq71bE0DRHoZ55gOROvcJD4uM3dkXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BiY1KoS/OvG44SXKhkr0clETQ1brvYZoRT0RxQP7w5/qpMMuQcUF5ofs5c3PR0D5w
	 pkn4EsJm10/d/aaKgpYk+7PW3EK1sdhYJ/UwB4+LMDVKwBgfIBvXHhzqIQdF8DajD7
	 LJujUW5NjAWVnrAHQUNLi2ryVXgoKNyiTjKaL/+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+50603c05bbdf4dfdaffa@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 082/183] net: lockless sock_i_ino()
Date: Sun,  7 Sep 2025 21:58:29 +0200
Message-ID: <20250907195617.744469478@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5d6b58c932ec451a5c41482790eb5b1ecf165a94 ]

Followup of commit c51da3f7a161 ("net: remove sock_i_uid()")

A recent syzbot report was the trigger for this change.

Over the years, we had many problems caused by the
read_lock[_bh](&sk->sk_callback_lock) in sock_i_uid().

We could fix smc_diag_dump_proto() or make a more radical move:

Instead of waiting for new syzbot reports, cache the socket
inode number in sk->sk_ino, so that we no longer
need to acquire sk->sk_callback_lock in sock_i_ino().

This makes socket dumps faster (one less cache line miss,
and two atomic ops avoided).

Prior art:

commit 25a9c8a4431c ("netlink: Add __sock_i_ino() for __netlink_diag_dump().")
commit 4f9bf2a2f5aa ("tcp: Don't acquire inet_listen_hashbucket::lock with disabled BH.")
commit efc3dbc37412 ("rds: Make rds_sock_lock BH rather than IRQ safe.")

Fixes: d2d6422f8bd1 ("x86: Allow to enable PREEMPT_RT.")
Reported-by: syzbot+50603c05bbdf4dfdaffa@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/68b73804.050a0220.3db4df.01d8.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20250902183603.740428-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h   | 17 +++++++++++++----
 net/core/sock.c      | 22 ----------------------
 net/mptcp/protocol.c |  1 -
 net/netlink/diag.c   |  2 +-
 4 files changed, 14 insertions(+), 28 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index da644ab5ae7f4..a348ae145eda4 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -285,6 +285,7 @@ struct sk_filter;
   *	@sk_ack_backlog: current listen backlog
   *	@sk_max_ack_backlog: listen backlog set in listen()
   *	@sk_uid: user id of owner
+  *	@sk_ino: inode number (zero if orphaned)
   *	@sk_prefer_busy_poll: prefer busypolling over softirq processing
   *	@sk_busy_poll_budget: napi processing budget when busypolling
   *	@sk_priority: %SO_PRIORITY setting
@@ -518,6 +519,7 @@ struct sock {
 	u32			sk_ack_backlog;
 	u32			sk_max_ack_backlog;
 	kuid_t			sk_uid;
+	unsigned long		sk_ino;
 	spinlock_t		sk_peer_lock;
 	int			sk_bind_phc;
 	struct pid		*sk_peer_pid;
@@ -2056,6 +2058,10 @@ static inline int sk_rx_queue_get(const struct sock *sk)
 static inline void sk_set_socket(struct sock *sk, struct socket *sock)
 {
 	sk->sk_socket = sock;
+	if (sock) {
+		WRITE_ONCE(sk->sk_uid, SOCK_INODE(sock)->i_uid);
+		WRITE_ONCE(sk->sk_ino, SOCK_INODE(sock)->i_ino);
+	}
 }
 
 static inline wait_queue_head_t *sk_sleep(struct sock *sk)
@@ -2077,6 +2083,7 @@ static inline void sock_orphan(struct sock *sk)
 	sk_set_socket(sk, NULL);
 	sk->sk_wq  = NULL;
 	/* Note: sk_uid is unchanged. */
+	WRITE_ONCE(sk->sk_ino, 0);
 	write_unlock_bh(&sk->sk_callback_lock);
 }
 
@@ -2087,20 +2094,22 @@ static inline void sock_graft(struct sock *sk, struct socket *parent)
 	rcu_assign_pointer(sk->sk_wq, &parent->wq);
 	parent->sk = sk;
 	sk_set_socket(sk, parent);
-	WRITE_ONCE(sk->sk_uid, SOCK_INODE(parent)->i_uid);
 	security_sock_graft(sk, parent);
 	write_unlock_bh(&sk->sk_callback_lock);
 }
 
+static inline unsigned long sock_i_ino(const struct sock *sk)
+{
+	/* Paired with WRITE_ONCE() in sock_graft() and sock_orphan() */
+	return READ_ONCE(sk->sk_ino);
+}
+
 static inline kuid_t sk_uid(const struct sock *sk)
 {
 	/* Paired with WRITE_ONCE() in sockfs_setattr() */
 	return READ_ONCE(sk->sk_uid);
 }
 
-unsigned long __sock_i_ino(struct sock *sk);
-unsigned long sock_i_ino(struct sock *sk);
-
 static inline kuid_t sock_net_uid(const struct net *net, const struct sock *sk)
 {
 	return sk ? sk_uid(sk) : make_kuid(net->user_ns, 0);
diff --git a/net/core/sock.c b/net/core/sock.c
index 1689eaf42f25b..10c1df62338be 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2788,28 +2788,6 @@ void sock_pfree(struct sk_buff *skb)
 EXPORT_SYMBOL(sock_pfree);
 #endif /* CONFIG_INET */
 
-unsigned long __sock_i_ino(struct sock *sk)
-{
-	unsigned long ino;
-
-	read_lock(&sk->sk_callback_lock);
-	ino = sk->sk_socket ? SOCK_INODE(sk->sk_socket)->i_ino : 0;
-	read_unlock(&sk->sk_callback_lock);
-	return ino;
-}
-EXPORT_SYMBOL(__sock_i_ino);
-
-unsigned long sock_i_ino(struct sock *sk)
-{
-	unsigned long ino;
-
-	local_bh_disable();
-	ino = __sock_i_ino(sk);
-	local_bh_enable();
-	return ino;
-}
-EXPORT_SYMBOL(sock_i_ino);
-
 /*
  * Allocate a skb from the socket's send buffer.
  */
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 76cb699885b38..1063c53850c05 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3537,7 +3537,6 @@ void mptcp_sock_graft(struct sock *sk, struct socket *parent)
 	write_lock_bh(&sk->sk_callback_lock);
 	rcu_assign_pointer(sk->sk_wq, &parent->wq);
 	sk_set_socket(sk, parent);
-	WRITE_ONCE(sk->sk_uid, SOCK_INODE(parent)->i_uid);
 	write_unlock_bh(&sk->sk_callback_lock);
 }
 
diff --git a/net/netlink/diag.c b/net/netlink/diag.c
index 61981e01fd6ff..b8e58132e8af1 100644
--- a/net/netlink/diag.c
+++ b/net/netlink/diag.c
@@ -168,7 +168,7 @@ static int __netlink_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 				 NETLINK_CB(cb->skb).portid,
 				 cb->nlh->nlmsg_seq,
 				 NLM_F_MULTI,
-				 __sock_i_ino(sk)) < 0) {
+				 sock_i_ino(sk)) < 0) {
 			ret = 1;
 			break;
 		}
-- 
2.50.1



