Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEBC53A8A3;
	Wed, 23 Sep 2026 14:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174557; cv=none; b=FsbCDThXKyxryOojA1rUudnzBm1S7/K+jSlNEoklKUOXWj4ZO/aW/YYjXtuq547lRfzSRmSG7jJgCsowIvQi9mG6k/252nrmNHRT4jg2I+oSm1Uz/kJJxVf+HSZsKAlOfo7Pv8wC1/xtmBVxUYmDaHXUnPW/IcGqdkhgUagSiRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174557; c=relaxed/simple;
	bh=p7Sp4yGZa6/RO7+w1ZfZvkx12dsg7LFbsjP3qMpnLjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZjOCXBQvBBxmuaIAL6UkoCmrse0biRnX9jm8Zu4wU9VxY8lD6FtLyZEJOYAcr4L/cISL8FooFRcoD4WsrNQswref5e+grpRE3jzQD+kxj92EXieVrrMRMkAOBa38V5/XspcGDje9Eglq7FdK7efZOMi9qveDYUgpHDxb5shRLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8rLMw1M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8rLMw1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E291F000FF;
	Wed, 23 Sep 2026 14:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174555;
	bh=6hniRNhTyjFyxuiUCHs18weU+GZpJ/x0NqPqyaRHK4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8rLMw1MombdSV9BMUgEcY33JRNbQCbtty5XuZiqjk0qDzJzpnVu33NXlEPCWV70U
	 KxzkeodBF3+8dKupD2YNGzAEfVz8foW/kqUyvM5KHETkAgSLfVXpJT3Zat2RYUkyLC
	 2fewhF6wnJpBNOZNx+3bfHvQzs52wMYDOjYGYRCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0cece8fa7d83523f47a3@syzkaller.appspotmail.com,
	Juan Perdomo <jcperdomo100@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 153/398] Bluetooth: RFCOMM: avoid socket lock inversion in listener cleanup
Date: Wed, 23 Sep 2026 16:03:47 +0200
Message-ID: <20260923140647.395484319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juan Perdomo <jcperdomo100@gmail.com>

[ Upstream commit 801fb950cae7048eb7d83b18857d1ca37b8cd5a4 ]

rfcomm_sock_cleanup_listen() closes unaccepted child sockets through
rfcomm_sock_close(), which takes the child socket lock before
rfcomm_dlc_close() acquires rfcomm_mutex. The RFCOMM worker takes these
locks in reverse order while handling connections and DLC state changes,
so lockdep reports a possible deadlock.

Close dequeued children without taking their socket lock. The accept queue
owns a reference to each child, and bt_accept_dequeue() locks the child
while unlinking it and clearing its parent pointer.

Dropping the child lock makes it important to prevent a concurrent
rfcomm_connect_ind() from enqueueing a new child after cleanup observes an
empty queue. Set a listening socket to BT_CLOSED while its lock is still
held, before dropping the lock and draining the queue. The state check in
rfcomm_connect_ind() then rejects new children once cleanup starts.

Reported-by: syzbot+0cece8fa7d83523f47a3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0cece8fa7d83523f47a3
Fixes: b7ce436a5d79 ("Bluetooth: switch to lock_sock in RFCOMM")
Signed-off-by: Juan Perdomo <jcperdomo100@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/rfcomm/sock.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 2286efef62f5b..037a7fcab3023 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -243,9 +243,7 @@ static void __rfcomm_sock_close(struct sock *sk)
  */
 static void rfcomm_sock_close(struct sock *sk)
 {
-	lock_sock(sk);
 	__rfcomm_sock_close(sk);
-	release_sock(sk);
 }
 
 static void rfcomm_sock_init(struct sock *sk, struct sock *parent)
@@ -902,6 +900,7 @@ static int rfcomm_sock_compat_ioctl(struct socket *sock, unsigned int cmd, unsig
 static int rfcomm_sock_shutdown(struct socket *sock, int how)
 {
 	struct sock *sk = sock->sk;
+	bool cleanup_listen = false;
 	int err = 0;
 
 	BT_DBG("sock %p, sk %p", sock, sk);
@@ -912,9 +911,17 @@ static int rfcomm_sock_shutdown(struct socket *sock, int how)
 	lock_sock(sk);
 	if (!sk->sk_shutdown) {
 		sk->sk_shutdown = SHUTDOWN_MASK;
+		if (sk->sk_state == BT_LISTEN) {
+			/* Block new children before cleaning up without sk lock. */
+			sk->sk_state = BT_CLOSED;
+			cleanup_listen = true;
+		}
 
 		release_sock(sk);
-		__rfcomm_sock_close(sk);
+		if (cleanup_listen)
+			rfcomm_sock_cleanup_listen(sk);
+		else
+			__rfcomm_sock_close(sk);
 		lock_sock(sk);
 
 		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
-- 
2.53.0



