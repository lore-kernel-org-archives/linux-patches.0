Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0BA3314C3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301254; cv=none; b=mOxUHRtzGNuZ0FiQMD0XTeY8HLhttigWVhmAPx/0jtxbKkJLjTUfvka6wPCrGU7BM+5pr/Yh53bQeifGnXs3kW6qHjLJkEXLzSHlEpbAUlPHS60bgg51wlYfCZ1Fpg+iEG4cZQhFl2T4CDLk1/xa7QRVzzqd9oUEglKdqH52mb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301254; c=relaxed/simple;
	bh=OGZD48fu6PNpH83xspNXa6wPfYshq6XiyBcTM2qUohA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFncnioQXl+iqiS3uuVkVbQ9Iw+G6GnT2qafjvAQa28WnB7/IekqiAShczDWxmSePm9IC8X9SvT7r9VwrWCz5llLClLkxCak612XPmyshkxoacKt0YZC/MTgfuvTXdrlfhyULreA6cm0ONQGzIQ/HI3aPa0dWXt503b7RKlOSPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gp9WuMWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gp9WuMWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF231C19423;
	Sat, 28 Feb 2026 17:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301254;
	bh=OGZD48fu6PNpH83xspNXa6wPfYshq6XiyBcTM2qUohA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gp9WuMWFA0QmWR0CSBJjKw9K5jgPaqbMlNDXPYfNp2uAHQri/GSKUoYLTireXJk/6
	 30kLN0sNhZavlrbDkkmtUnE4IXrI21++Ztq3SEhg6swrj+b2H4wzKhWP5HQNg9YISm
	 wZssb0MbC5emor/yvz1LaY2jrm8/YaObGE5jLRMyxE+QOKKQ5eSCPp/Jp80hF4pSf/
	 ANjHv+zINbc9Tmh9cY6gFsJbmCm1kRzK6czAqOc6Sa6wtHV8TVPTU6uaMbBv0CMsDZ
	 b6fJHLhZtE0yGPfc0ZRKaw9ClshsLEsgNVqDdoT0g+BovQAHCp0z7ZrFJExry5tSzo
	 am9EGW3qkJIyg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 437/752] net: Drop the lock in skb_may_tx_timestamp()
Date: Sat, 28 Feb 2026 12:42:28 -0500
Message-ID: <20260228174750.1542406-437-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 983512f3a87fd8dc4c94dfa6b596b6e57df5aad7 ]

skb_may_tx_timestamp() may acquire sock::sk_callback_lock. The lock must
not be taken in IRQ context, only softirq is okay. A few drivers receive
the timestamp via a dedicated interrupt and complete the TX timestamp
from that handler. This will lead to a deadlock if the lock is already
write-locked on the same CPU.

Taking the lock can be avoided. The socket (pointed by the skb) will
remain valid until the skb is released. The ->sk_socket and ->file
member will be set to NULL once the user closes the socket which may
happen before the timestamp arrives.
If we happen to observe the pointer while the socket is closing but
before the pointer is set to NULL then we may use it because both
pointer (and the file's cred member) are RCU freed.

Drop the lock. Use READ_ONCE() to obtain the individual pointer. Add a
matching WRITE_ONCE() where the pointer are cleared.

Link: https://lore.kernel.org/all/20260205145104.iWinkXHv@linutronix.de
Fixes: b245be1f4db1a ("net-timestamp: no-payload only sysctl")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260220183858.N4ERjFW6@linutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h |  2 +-
 net/core/skbuff.c  | 23 ++++++++++++++++++-----
 net/socket.c       |  2 +-
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 60bcb13f045c3..9540dcc5a0c01 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2067,7 +2067,7 @@ static inline int sk_rx_queue_get(const struct sock *sk)
 
 static inline void sk_set_socket(struct sock *sk, struct socket *sock)
 {
-	sk->sk_socket = sock;
+	WRITE_ONCE(sk->sk_socket, sock);
 	if (sock) {
 		WRITE_ONCE(sk->sk_uid, SOCK_INODE(sock)->i_uid);
 		WRITE_ONCE(sk->sk_ino, SOCK_INODE(sock)->i_ino);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9a763d120925a..60d89899fdb9b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5513,15 +5513,28 @@ static void __skb_complete_tx_timestamp(struct sk_buff *skb,
 
 static bool skb_may_tx_timestamp(struct sock *sk, bool tsonly)
 {
-	bool ret;
+	struct socket *sock;
+	struct file *file;
+	bool ret = false;
 
 	if (likely(tsonly || READ_ONCE(sock_net(sk)->core.sysctl_tstamp_allow_data)))
 		return true;
 
-	read_lock_bh(&sk->sk_callback_lock);
-	ret = sk->sk_socket && sk->sk_socket->file &&
-	      file_ns_capable(sk->sk_socket->file, &init_user_ns, CAP_NET_RAW);
-	read_unlock_bh(&sk->sk_callback_lock);
+	/* The sk pointer remains valid as long as the skb is. The sk_socket and
+	 * file pointer may become NULL if the socket is closed. Both structures
+	 * (including file->cred) are RCU freed which means they can be accessed
+	 * within a RCU read section.
+	 */
+	rcu_read_lock();
+	sock = READ_ONCE(sk->sk_socket);
+	if (!sock)
+		goto out;
+	file = READ_ONCE(sock->file);
+	if (!file)
+		goto out;
+	ret = file_ns_capable(file, &init_user_ns, CAP_NET_RAW);
+out:
+	rcu_read_unlock();
 	return ret;
 }
 
diff --git a/net/socket.c b/net/socket.c
index e8892b2187087..2b6e11b085ebd 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -674,7 +674,7 @@ static void __sock_release(struct socket *sock, struct inode *inode)
 		iput(SOCK_INODE(sock));
 		return;
 	}
-	sock->file = NULL;
+	WRITE_ONCE(sock->file, NULL);
 }
 
 /**
-- 
2.51.0

