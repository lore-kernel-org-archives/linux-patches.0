Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5608F13A27E;
	Wed,  3 Jul 2024 10:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003320; cv=none; b=EG6D1cc5L/DCXsKjWzkn1D1p9O8KALS23YkY2qEjgIjI7C+LMUcWdhOCzk8zyabGXW9gRmvWWea0y6KANVjmP/0uGYTwWYYnZ9jlr0yMWmw2Z8BwULyOnGCd+KcquWQ2Zy/XZ7pbzTd6Oj6+u3Ci9W03zwVSdXTAQr56wHvejMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003320; c=relaxed/simple;
	bh=kRocdW16zqNHR7246yFwvh9pHA70SEpkB+sRmvkPN80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpLZtAsDchF6FZLKy7gVXQzJqWpDC6A+uQheJrvjAfFmg3QQw4zTpfwmuDHqT8SGz+k2iku9YX374ujUk3o1va1KUL82tZ2Is18rwknlmxVy0l+VuFy8Hqo/tOhr28EAKcn3XBTAWeW1JeqhX+xlyRI8gA6A6V0KbLbWoR+xnaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uXG0lYiO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uXG0lYiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E78BC2BD10;
	Wed,  3 Jul 2024 10:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003319;
	bh=kRocdW16zqNHR7246yFwvh9pHA70SEpkB+sRmvkPN80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uXG0lYiOQ3ssH19MSAxXOzS4lbUIgLFnMZFeaEmIWT9IDLyGHNDTvQB5wvOhZ8PBb
	 Uf3w7DiZgS9U7WnnabQCVx9So25R1D5M6oI2uny8bx9zP20NT6UK4mNAmBOgtXNnd/
	 6/agM3Vdq/sbXsBBkWxXr0F7zONUg0RYWkri35iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 010/139] af_unix: Annotate data-races around sk->sk_state in unix_write_space() and poll().
Date: Wed,  3 Jul 2024 12:38:27 +0200
Message-ID: <20240703102830.827749927@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit eb0718fb3e97ad0d6f4529b810103451c90adf94 ]

unix_poll() and unix_dgram_poll() read sk->sk_state locklessly and
calls unix_writable() which also reads sk->sk_state without holding
unix_state_lock().

Let's use READ_ONCE() in unix_poll() and unix_dgram_poll() and pass
it to unix_writable().

While at it, we remove TCP_SYN_SENT check in unix_dgram_poll() as
that state does not exist for AF_UNIX socket since the code was added.

Fixes: 1586a5877db9 ("af_unix: do not report POLLOUT on listeners")
Fixes: 3c73419c09a5 ("af_unix: fix 'poll for write'/ connected DGRAM sockets")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index d363a268f272e..5266908c65ec4 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -454,9 +454,9 @@ static int unix_dgram_peer_wake_me(struct sock *sk, struct sock *other)
 	return 0;
 }
 
-static int unix_writable(const struct sock *sk)
+static int unix_writable(const struct sock *sk, unsigned char state)
 {
-	return sk->sk_state != TCP_LISTEN &&
+	return state != TCP_LISTEN &&
 	       (refcount_read(&sk->sk_wmem_alloc) << 2) <= sk->sk_sndbuf;
 }
 
@@ -465,7 +465,7 @@ static void unix_write_space(struct sock *sk)
 	struct socket_wq *wq;
 
 	rcu_read_lock();
-	if (unix_writable(sk)) {
+	if (unix_writable(sk, READ_ONCE(sk->sk_state))) {
 		wq = rcu_dereference(sk->sk_wq);
 		if (skwq_has_sleeper(wq))
 			wake_up_interruptible_sync_poll(&wq->wait,
@@ -2683,12 +2683,14 @@ static int unix_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned lon
 static __poll_t unix_poll(struct file *file, struct socket *sock, poll_table *wait)
 {
 	struct sock *sk = sock->sk;
+	unsigned char state;
 	__poll_t mask;
 	u8 shutdown;
 
 	sock_poll_wait(file, sock, wait);
 	mask = 0;
 	shutdown = READ_ONCE(sk->sk_shutdown);
+	state = READ_ONCE(sk->sk_state);
 
 	/* exceptional events? */
 	if (sk->sk_err)
@@ -2704,14 +2706,14 @@ static __poll_t unix_poll(struct file *file, struct socket *sock, poll_table *wa
 
 	/* Connection-based need to check for termination and startup */
 	if ((sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET) &&
-	    sk->sk_state == TCP_CLOSE)
+	    state == TCP_CLOSE)
 		mask |= EPOLLHUP;
 
 	/*
 	 * we set writable also when the other side has shut down the
 	 * connection. This prevents stuck sockets.
 	 */
-	if (unix_writable(sk))
+	if (unix_writable(sk, state))
 		mask |= EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND;
 
 	return mask;
@@ -2722,12 +2724,14 @@ static __poll_t unix_dgram_poll(struct file *file, struct socket *sock,
 {
 	struct sock *sk = sock->sk, *other;
 	unsigned int writable;
+	unsigned char state;
 	__poll_t mask;
 	u8 shutdown;
 
 	sock_poll_wait(file, sock, wait);
 	mask = 0;
 	shutdown = READ_ONCE(sk->sk_shutdown);
+	state = READ_ONCE(sk->sk_state);
 
 	/* exceptional events? */
 	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
@@ -2744,19 +2748,14 @@ static __poll_t unix_dgram_poll(struct file *file, struct socket *sock,
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* Connection-based need to check for termination and startup */
-	if (sk->sk_type == SOCK_SEQPACKET) {
-		if (sk->sk_state == TCP_CLOSE)
-			mask |= EPOLLHUP;
-		/* connection hasn't started yet? */
-		if (sk->sk_state == TCP_SYN_SENT)
-			return mask;
-	}
+	if (sk->sk_type == SOCK_SEQPACKET && state == TCP_CLOSE)
+		mask |= EPOLLHUP;
 
 	/* No write status requested, avoid expensive OUT tests. */
 	if (!(poll_requested_events(wait) & (EPOLLWRBAND|EPOLLWRNORM|EPOLLOUT)))
 		return mask;
 
-	writable = unix_writable(sk);
+	writable = unix_writable(sk, state);
 	if (writable) {
 		unix_state_lock(sk);
 
-- 
2.43.0



