Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E627914601E;
	Wed, 19 Jun 2024 13:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803684; cv=none; b=B77Nv4gRXFFKVzl0lYADEbKQ48mIG9Zm7q5ZBIfhsDbP8vauEGMG8lon22TvyrUuBd9KeLHj12RLer05FgiYUFdrvcdoqLYctvOS3S7x8EvT++KWJIlXfiUWyeaZ8pBoaAkrUyI0CfF6oBbXzWejf21D5yToqZt33P8Tcd7DCmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803684; c=relaxed/simple;
	bh=nNGtQYkSiDNBhmzrRDxfIOmhwiysDuLncl6xssSt6AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfgQYWW3YRuRIpoUPDpy192++oAzmYHf0HgqZTVZRHu4j0V9AjOXjYxX+lKyTBg3kmjKxbJl3HN06u9LvGkV1rsl+tpEhIU3waKE/SxxOl+OKCfcExsoJbtQfKh2dYazIJQV3MjA+XBE6bcTjw9wRGRVeCsc2rFaiXfdoibOACM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+Omz+6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+Omz+6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2AFC2BBFC;
	Wed, 19 Jun 2024 13:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803683;
	bh=nNGtQYkSiDNBhmzrRDxfIOmhwiysDuLncl6xssSt6AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+Omz+6GJR+05pIcm989mWcd4LxHQPHa3iDEjrKA6XviJHe3pU1J/FdRdhK1+7ZA6
	 L9I0sR7TwAOS544EUyP+Vm2YH+gDpv7kHpTLbpiP09B4bJySnlUzsV0v07uVtL90W7
	 7ME2T3RvlPkJQQ67RR4TfcRCbB5lEF/qMQ8m5nEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/217] af_unix: Annotate data-races around sk->sk_state in unix_write_space() and poll().
Date: Wed, 19 Jun 2024 14:54:41 +0200
Message-ID: <20240619125558.125854665@linuxfoundation.org>
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
index 6d7e1cd97c52e..67a2a0e842e4f 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -518,9 +518,9 @@ static int unix_dgram_peer_wake_me(struct sock *sk, struct sock *other)
 	return 0;
 }
 
-static int unix_writable(const struct sock *sk)
+static int unix_writable(const struct sock *sk, unsigned char state)
 {
-	return sk->sk_state != TCP_LISTEN &&
+	return state != TCP_LISTEN &&
 	       (refcount_read(&sk->sk_wmem_alloc) << 2) <= sk->sk_sndbuf;
 }
 
@@ -529,7 +529,7 @@ static void unix_write_space(struct sock *sk)
 	struct socket_wq *wq;
 
 	rcu_read_lock();
-	if (unix_writable(sk)) {
+	if (unix_writable(sk, READ_ONCE(sk->sk_state))) {
 		wq = rcu_dereference(sk->sk_wq);
 		if (skwq_has_sleeper(wq))
 			wake_up_interruptible_sync_poll(&wq->wait,
@@ -3180,12 +3180,14 @@ static int unix_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned lon
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
@@ -3207,14 +3209,14 @@ static __poll_t unix_poll(struct file *file, struct socket *sock, poll_table *wa
 
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
@@ -3225,12 +3227,14 @@ static __poll_t unix_dgram_poll(struct file *file, struct socket *sock,
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
@@ -3249,19 +3253,14 @@ static __poll_t unix_dgram_poll(struct file *file, struct socket *sock,
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



