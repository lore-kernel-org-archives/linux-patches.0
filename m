Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C3814D719;
	Wed, 19 Jun 2024 13:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803678; cv=none; b=Jx6YE4l+lxamS/XuCG37k7bqbXKis51yBt2pIM0YVl9OuRUC8wDNpEOiKDxKiv+Hn3AcCpRwtUlIrb2Q0ecmLXl8TifdB3aq+e7kNzavaPmL691ngFUMN9+Vu9o4/fJTvsZLQQgiYpuJFpZNdhqSWvMiTnLDU4H/kdF3YhWppgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803678; c=relaxed/simple;
	bh=QOpjpcX/+KCvjBaFaDLTEuQ3dAjQc3uRnGpq69bNK7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjpyhWNfdEd3aNxY/lqMEOBvqaTDDz+7YKzYBz0A05x6NVI8zkna4SitR7L6RBmfhmSOJniajfaXKw9iGVBHmhcWJThM4p5Op7yMZFtFcCjGqtgr7I9JnHxs5CvBBY92I9kAFvkUrnBy7b82VwQqWshK3lFT7mLZdHkXL0MDE6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URlUGUX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URlUGUX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E524C2BBFC;
	Wed, 19 Jun 2024 13:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803678;
	bh=QOpjpcX/+KCvjBaFaDLTEuQ3dAjQc3uRnGpq69bNK7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=URlUGUX8OEEiFCmMtRBqJ791JFZB8cWgT1HT/wmBeX4pSfhy+hDo+DiBDAXVc/dqr
	 /blrqmOBPbu2dMj9ePDUrLcSE9VsShn//LKhlvzv+X+wR3ewARDxJj25A8VFAvrkGt
	 KxbfjU67xqzoIPgB4MC5KIFShX71CW22VRLwZ5vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/217] af_unix: Annodate data-races around sk->sk_state for writers.
Date: Wed, 19 Jun 2024 14:54:39 +0200
Message-ID: <20240619125558.047635385@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 942238f9735a4a4ebf8274b218d9a910158941d1 ]

sk->sk_state is changed under unix_state_lock(), but it's read locklessly
in many places.

This patch adds WRITE_ONCE() on the writer side.

We will add READ_ONCE() to the lockless readers in the following patches.

Fixes: 83301b5367a9 ("af_unix: Set TCP_ESTABLISHED for datagram sockets too")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 5d6203b6e25c3..358e80956cb7b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -604,7 +604,7 @@ static void unix_release_sock(struct sock *sk, int embrion)
 	u->path.dentry = NULL;
 	u->path.mnt = NULL;
 	state = sk->sk_state;
-	sk->sk_state = TCP_CLOSE;
+	WRITE_ONCE(sk->sk_state, TCP_CLOSE);
 
 	skpair = unix_peer(sk);
 	unix_peer(sk) = NULL;
@@ -726,7 +726,8 @@ static int unix_listen(struct socket *sock, int backlog)
 	if (backlog > sk->sk_max_ack_backlog)
 		wake_up_interruptible_all(&u->peer_wait);
 	sk->sk_max_ack_backlog	= backlog;
-	sk->sk_state		= TCP_LISTEN;
+	WRITE_ONCE(sk->sk_state, TCP_LISTEN);
+
 	/* set credentials so connect can copy them */
 	init_peercred(sk);
 	err = 0;
@@ -1389,7 +1390,8 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 		if (err)
 			goto out_unlock;
 
-		sk->sk_state = other->sk_state = TCP_ESTABLISHED;
+		WRITE_ONCE(sk->sk_state, TCP_ESTABLISHED);
+		WRITE_ONCE(other->sk_state, TCP_ESTABLISHED);
 	} else {
 		/*
 		 *	1003.1g breaking connected state with AF_UNSPEC
@@ -1406,7 +1408,7 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 
 		unix_peer(sk) = other;
 		if (!other)
-			sk->sk_state = TCP_CLOSE;
+			WRITE_ONCE(sk->sk_state, TCP_CLOSE);
 		unix_dgram_peer_wake_disconnect_wakeup(sk, old_peer);
 
 		unix_state_double_unlock(sk, other);
@@ -1620,7 +1622,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	copy_peercred(sk, other);
 
 	sock->state	= SS_CONNECTED;
-	sk->sk_state	= TCP_ESTABLISHED;
+	WRITE_ONCE(sk->sk_state, TCP_ESTABLISHED);
 	sock_hold(newsk);
 
 	smp_mb__after_atomic();	/* sock_hold() does an atomic_inc() */
@@ -2015,7 +2017,7 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 			unix_peer(sk) = NULL;
 			unix_dgram_peer_wake_disconnect_wakeup(sk, other);
 
-			sk->sk_state = TCP_CLOSE;
+			WRITE_ONCE(sk->sk_state, TCP_CLOSE);
 			unix_state_unlock(sk);
 
 			unix_dgram_disconnected(sk, other);
-- 
2.43.0



