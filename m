Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B25843F8A1;
	Tue, 21 Jul 2026 21:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671101; cv=none; b=ASqPgWVN+K/DMvpYN1r4gb9MB/EbHeu9a9hAeX0UNmU1sqyz9ubzLKJouUdkJ8rMGlKV9bZsbKYZL5uB0Ac1ss8eMvkHOoIDEK3dy3Wzora6FuiZ2cgzZY4y2tsKGstykmo+rScd7SmZ+ZXhFNKW8jsn1pQtkEnKXwyHd6RFHPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671101; c=relaxed/simple;
	bh=s0w0eGErTS6xLLBOeIY7MGptvtVfoLhUGx/aF4RwIDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4QN50qdU6EillSlzlTq5ssKpG2/QJ3G7LuMgErRvur2IY6LCa0tAPmnVW11YAS0/bCfVNrh8ZCzSJ6kETG30PmuK7e3JmPGtTKOU7F9Fq12oNRlznvBR9xSPnQAS7KFGVUiDphp1wBds9Hlil3R6++H7QUh1ob5Ix16dLWVGWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqZhkX7x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqZhkX7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A42D1F00A3D;
	Tue, 21 Jul 2026 21:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671092;
	bh=mwkEaM3zOzC3TLFwuF57bizdOwzGhWYY0fBalQETtv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dqZhkX7xJsIFnyyzMbxDQnAtayr8lEW64eIxE6mnBw9wnM2m/hmOVlOB5ARIEh7A8
	 r/eVHrlMUJbV5Af+B69dgpDVThPmZFsnjPj6k6RoYzAdwocd2z2Y7YDw8ciEB4Qaba
	 mbwKEkKdigVtohhqXf2Oq1QEPYPC880bhK0O7zWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Philo Lu <lulie@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/843] net: Drop the lock in skb_may_tx_timestamp()
Date: Tue, 21 Jul 2026 17:15:50 +0200
Message-ID: <20260721152408.592283637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 983512f3a87fd8dc4c94dfa6b596b6e57df5aad7 upstream.

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
[ adapted sk_set_socket() in include/net/sock.h to fix the conflict from
 not having commit 5d6b58c932ec ("net: lockless sock_i_ino()") and the
 additional previous changes required by it.
 It comes down to just now having the lines of
    if (sock) {
            WRITE_ONCE(sk->sk_uid, SOCK_INODE(sock)->i_uid);
            WRITE_ONCE(sk->sk_ino, SOCK_INODE(sock)->i_ino);
    }
 below the changed line. ]
Signed-off-by: Philo Lu <lulie@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h |  2 +-
 net/core/skbuff.c  | 23 ++++++++++++++++++-----
 net/socket.c       |  2 +-
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 962acf4a644da9..2b13a41cd99a99 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2070,7 +2070,7 @@ static inline int sk_rx_queue_get(const struct sock *sk)
 
 static inline void sk_set_socket(struct sock *sk, struct socket *sock)
 {
-	sk->sk_socket = sock;
+	WRITE_ONCE(sk->sk_socket, sock);
 }
 
 static inline wait_queue_head_t *sk_sleep(struct sock *sk)
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 82add06ca935f1..6281cfed03bb29 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4953,15 +4953,28 @@ static void __skb_complete_tx_timestamp(struct sk_buff *skb,
 
 static bool skb_may_tx_timestamp(struct sock *sk, bool tsonly)
 {
-	bool ret;
+	struct socket *sock;
+	struct file *file;
+	bool ret = false;
 
 	if (likely(READ_ONCE(sysctl_tstamp_allow_data) || tsonly))
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
index 24dd5f26585aaa..0c87e99c8e69ab 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -663,7 +663,7 @@ static void __sock_release(struct socket *sock, struct inode *inode)
 		iput(SOCK_INODE(sock));
 		return;
 	}
-	sock->file = NULL;
+	WRITE_ONCE(sock->file, NULL);
 }
 
 /**
-- 
2.53.0



