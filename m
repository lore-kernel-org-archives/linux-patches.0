Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BBF3AE43
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6809DC433EF;
	Wed,  7 Jun 2023 20:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169444;
	bh=QvhYMA6WJHNFNUd7nEeqgVn/WVl7iAozf2QKWpQBwJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FYeVfeyC/cGBEXkZcLOHfK9jVWTiwhYScLfJt/Nv/4/iSeO9fs8s9hIKDBH4nxFu5
	 mFGPJqgVkq6JbVXm/RYI8BUECyBNh4yKVFVWT+8Dnzq8ylJ1uPQqA8PgRSPmkz5Zjd
	 r7hMLgJIXHUyotze6Zd92vTOjFjkO8UQf9UOZCcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@apple.com>,
	Mat Martineau <martineau@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 084/286] mptcp: add annotations around sk->sk_shutdown accesses
Date: Wed,  7 Jun 2023 22:13:03 +0200
Message-ID: <20230607200925.815313882@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 6b9831bfd9322b297eb6d44257808cc055fdc586 ]

Christoph reported the mptcp variant of a recently addressed plain
TCP issue. Similar to commit e14cadfd80d7 ("tcp: add annotations around
sk->sk_shutdown accesses") add READ/WRITE ONCE annotations to silence
KCSAN reports around lockless sk_shutdown access.

Fixes: 71ba088ce0aa ("mptcp: cleanup accept and poll")
Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/401
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 64d4910e337ea..17793aa733fd9 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -590,7 +590,7 @@ static bool mptcp_check_data_fin(struct sock *sk)
 		WRITE_ONCE(msk->ack_seq, msk->ack_seq + 1);
 		WRITE_ONCE(msk->rcv_data_fin, 0);
 
-		sk->sk_shutdown |= RCV_SHUTDOWN;
+		WRITE_ONCE(sk->sk_shutdown, sk->sk_shutdown | RCV_SHUTDOWN);
 		smp_mb__before_atomic(); /* SHUTDOWN must be visible first */
 
 		switch (sk->sk_state) {
@@ -897,7 +897,7 @@ static void mptcp_check_for_eof(struct mptcp_sock *msk)
 		/* hopefully temporary hack: propagate shutdown status
 		 * to msk, when all subflows agree on it
 		 */
-		sk->sk_shutdown |= RCV_SHUTDOWN;
+		WRITE_ONCE(sk->sk_shutdown, sk->sk_shutdown | RCV_SHUTDOWN);
 
 		smp_mb__before_atomic(); /* SHUTDOWN must be visible first */
 		sk->sk_data_ready(sk);
@@ -2498,7 +2498,7 @@ static void mptcp_check_fastclose(struct mptcp_sock *msk)
 	}
 
 	inet_sk_state_store(sk, TCP_CLOSE);
-	sk->sk_shutdown = SHUTDOWN_MASK;
+	WRITE_ONCE(sk->sk_shutdown, SHUTDOWN_MASK);
 	smp_mb__before_atomic(); /* SHUTDOWN must be visible first */
 	set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags);
 
@@ -2934,7 +2934,7 @@ bool __mptcp_close(struct sock *sk, long timeout)
 	bool do_cancel_work = false;
 	int subflows_alive = 0;
 
-	sk->sk_shutdown = SHUTDOWN_MASK;
+	WRITE_ONCE(sk->sk_shutdown, SHUTDOWN_MASK);
 
 	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE)) {
 		mptcp_listen_inuse_dec(sk);
@@ -3074,7 +3074,7 @@ static int mptcp_disconnect(struct sock *sk, int flags)
 	mptcp_pm_data_reset(msk);
 	mptcp_ca_reset(sk);
 
-	sk->sk_shutdown = 0;
+	WRITE_ONCE(sk->sk_shutdown, 0);
 	sk_error_report(sk);
 	return 0;
 }
@@ -3793,9 +3793,6 @@ static __poll_t mptcp_check_writeable(struct mptcp_sock *msk)
 {
 	struct sock *sk = (struct sock *)msk;
 
-	if (unlikely(sk->sk_shutdown & SEND_SHUTDOWN))
-		return EPOLLOUT | EPOLLWRNORM;
-
 	if (sk_stream_is_writeable(sk))
 		return EPOLLOUT | EPOLLWRNORM;
 
@@ -3813,6 +3810,7 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	struct sock *sk = sock->sk;
 	struct mptcp_sock *msk;
 	__poll_t mask = 0;
+	u8 shutdown;
 	int state;
 
 	msk = mptcp_sk(sk);
@@ -3829,17 +3827,22 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 		return inet_csk_listen_poll(ssock->sk);
 	}
 
+	shutdown = READ_ONCE(sk->sk_shutdown);
+	if (shutdown == SHUTDOWN_MASK || state == TCP_CLOSE)
+		mask |= EPOLLHUP;
+	if (shutdown & RCV_SHUTDOWN)
+		mask |= EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
+
 	if (state != TCP_SYN_SENT && state != TCP_SYN_RECV) {
 		mask |= mptcp_check_readable(msk);
-		mask |= mptcp_check_writeable(msk);
+		if (shutdown & SEND_SHUTDOWN)
+			mask |= EPOLLOUT | EPOLLWRNORM;
+		else
+			mask |= mptcp_check_writeable(msk);
 	} else if (state == TCP_SYN_SENT && inet_sk(sk)->defer_connect) {
 		/* cf tcp_poll() note about TFO */
 		mask |= EPOLLOUT | EPOLLWRNORM;
 	}
-	if (sk->sk_shutdown == SHUTDOWN_MASK || state == TCP_CLOSE)
-		mask |= EPOLLHUP;
-	if (sk->sk_shutdown & RCV_SHUTDOWN)
-		mask |= EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
 
 	/* This barrier is coupled with smp_wmb() in __mptcp_error_report() */
 	smp_rmb();
-- 
2.39.2



