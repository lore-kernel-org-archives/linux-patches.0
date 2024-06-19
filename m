Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A254C74;
	Wed, 19 Jun 2024 13:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802025; cv=none; b=AzmAccanDZyPv9TJ0x6opQG+ZW3WcjzO2shzQE9lt21GTTn+qJSEGGpBU20Jo65acczQIBKhL0XVvTyN0cQ2f+Nrrj628S4kBOg80hLBGrhf8P7e7mr0hYF4ohlfAkTxazy5QBLeofcbDEDH5MW7M5wvVjTMAb2LiE7mevi7q4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802025; c=relaxed/simple;
	bh=65E4s1ehXyhg/mTmaKmQ0U4GUTGpf17aNF+tzciQDE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZh96sn5Ggd/YRxcvwntB/a5qsFnffv/EqQxfKaypep0m7kkPuP419XkUchisxX2IZJ0snePKTAfAWlXnVlVw95sJyWvo9A1lHYhN+Dn953IR5tsaKpHj/8S/77tESoWpg3gcaa+7BLYj1oUl2SjI9Riy/tfAElCtL+pp/d3pHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWt29hxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWt29hxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FD8C2BBFC;
	Wed, 19 Jun 2024 13:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802025;
	bh=65E4s1ehXyhg/mTmaKmQ0U4GUTGpf17aNF+tzciQDE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWt29hxWcdEJ6Y+sqe90opWhqFxlgNW6BJovjI8AUa0PkvdWCwfm6KtJHz3Ht3mV+
	 lfMFPFZrLxH5MwJlMw9y9hYsSZAIioVyldvfd4d77WuVEq6BV10sV7Xn5GjEqK3wTB
	 a9hSlZSVk57/9UTVGmOUlEuvJc/s63I0swBZK2yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/267] af_unix: Annodate data-races around sk->sk_state for writers.
Date: Wed, 19 Jun 2024 14:53:20 +0200
Message-ID: <20240619125608.246847030@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 348f9e34f6696..bd2af62f58605 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -617,7 +617,7 @@ static void unix_release_sock(struct sock *sk, int embrion)
 	u->path.dentry = NULL;
 	u->path.mnt = NULL;
 	state = sk->sk_state;
-	sk->sk_state = TCP_CLOSE;
+	WRITE_ONCE(sk->sk_state, TCP_CLOSE);
 
 	skpair = unix_peer(sk);
 	unix_peer(sk) = NULL;
@@ -739,7 +739,8 @@ static int unix_listen(struct socket *sock, int backlog)
 	if (backlog > sk->sk_max_ack_backlog)
 		wake_up_interruptible_all(&u->peer_wait);
 	sk->sk_max_ack_backlog	= backlog;
-	sk->sk_state		= TCP_LISTEN;
+	WRITE_ONCE(sk->sk_state, TCP_LISTEN);
+
 	/* set credentials so connect can copy them */
 	init_peercred(sk);
 	err = 0;
@@ -1411,7 +1412,8 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 		if (err)
 			goto out_unlock;
 
-		sk->sk_state = other->sk_state = TCP_ESTABLISHED;
+		WRITE_ONCE(sk->sk_state, TCP_ESTABLISHED);
+		WRITE_ONCE(other->sk_state, TCP_ESTABLISHED);
 	} else {
 		/*
 		 *	1003.1g breaking connected state with AF_UNSPEC
@@ -1428,7 +1430,7 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 
 		unix_peer(sk) = other;
 		if (!other)
-			sk->sk_state = TCP_CLOSE;
+			WRITE_ONCE(sk->sk_state, TCP_CLOSE);
 		unix_dgram_peer_wake_disconnect_wakeup(sk, old_peer);
 
 		unix_state_double_unlock(sk, other);
@@ -1644,7 +1646,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	copy_peercred(sk, other);
 
 	sock->state	= SS_CONNECTED;
-	sk->sk_state	= TCP_ESTABLISHED;
+	WRITE_ONCE(sk->sk_state, TCP_ESTABLISHED);
 	sock_hold(newsk);
 
 	smp_mb__after_atomic();	/* sock_hold() does an atomic_inc() */
@@ -2027,7 +2029,7 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 			unix_peer(sk) = NULL;
 			unix_dgram_peer_wake_disconnect_wakeup(sk, other);
 
-			sk->sk_state = TCP_CLOSE;
+			WRITE_ONCE(sk->sk_state, TCP_CLOSE);
 			unix_state_unlock(sk);
 
 			unix_dgram_disconnected(sk, other);
-- 
2.43.0



