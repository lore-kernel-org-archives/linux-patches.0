Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1043AE6E4;
	Tue, 21 Jul 2026 22:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673350; cv=none; b=n3zVHVeoCdCk8wr6UcGe3eCJp1ZtAm4dYTSQTSS3WKLjEWcwFPnVRGtE4AxRYqxW90NP6HqkdgZ/I2n9M5CmBCJq5m9Sew6QbP5nLiHEhp4MU7mDxaJFPFSRgKwAgRSKxfqmamhRw7C87L1m53Hm63fWohXmep2VpmGnY9BkDBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673350; c=relaxed/simple;
	bh=UG0vPRieBd+pWWuJf6599DPAS6stKbgyAviN7HE+M0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ss9kYS5PZrZdYuGPDRtPHfGzjInNrIYc5WU9X22KPSNdlc/K2u2YVmirM9LfNf0ik1JCJWHnFvjI6PoqzEoB5aRLfdct1tFrHIvkyxlgOuZIqeqaFnDZHjYSk37ZNbenYx/tJJ1EJkaaRjhCuhg/DBfD2Dn+lO5xK5t4z66qlCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5N2C5Dy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5N2C5Dy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C081F000E9;
	Tue, 21 Jul 2026 22:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673349;
	bh=q+oB8CuD8AZMkp1GblHSEyNinlLVh37hfDtLADI3YOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M5N2C5Dy3S4JHO8w/+gBHD93aoNS4SwTHe6HLpdf589vxGpXDrmmUaIeqMQhmUDb8
	 +p+5DNIc7mQA+6Xp7Y53KJWfnm6002ZQt+aFWM1XOpm/0stW2xWo30mz7l6eGA6PAM
	 e4EKQLlk1yaarJhN3m5SIJ4UuW2Ft2KPNWVvIRuE=
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
Subject: [PATCH 5.10 086/699] net: Drop the lock in skb_may_tx_timestamp()
Date: Tue, 21 Jul 2026 17:17:25 +0200
Message-ID: <20260721152357.643778459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f0e391afb511d2..b9c44e47cb7a78 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1981,7 +1981,7 @@ static inline int sk_rx_queue_get(const struct sock *sk)
 
 static inline void sk_set_socket(struct sock *sk, struct socket *sock)
 {
-	sk->sk_socket = sock;
+	WRITE_ONCE(sk->sk_socket, sock);
 }
 
 static inline wait_queue_head_t *sk_sleep(struct sock *sk)
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e4a39e0f55f242..90a63c356affb2 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4772,15 +4772,28 @@ static void __skb_complete_tx_timestamp(struct sk_buff *skb,
 
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
index de838c3b004861..eb157ea2a3efbb 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -608,7 +608,7 @@ static void __sock_release(struct socket *sock, struct inode *inode)
 		iput(SOCK_INODE(sock));
 		return;
 	}
-	sock->file = NULL;
+	WRITE_ONCE(sock->file, NULL);
 }
 
 /**
-- 
2.53.0



