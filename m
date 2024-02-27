Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FB813EFE4;
	Tue, 27 Feb 2024 13:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041940; cv=none; b=H+mnmVZWuc1SooF83KQ8oBzzFJfILeDCaO68rBheCRigEvDStzTHl/F2Bw8PtpR+VeWNk6EmB6E1Xrv/vDyZduuz5IfBQ7kES9qX+zpiqBqOGLzvBvjWWgN/uaHUQ/7DvopRJTYdWQ8aHjSXFeK0kknO7l4YAS1MKQaMVkCb1h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041940; c=relaxed/simple;
	bh=4hDNFE9Z0f7mVHHfCvouIzrHor32ewqEkYk/uDQ5wAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3g/l5+whyb5cwhdpkwpgIcs1arP+REpED2fuBrlpWBgAW17kc+lmXOialDbjIq4RYz+Kx/FeC/7a98LprHbM8QpU8aqR5ApygDTzHKCKSUVKnll2edd4eFS4g3z05Ag9+z+JL2qufrIrExgz1IFrfZKqIWNe7kixjHFlBe0toI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqWO7/oi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqWO7/oi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C249C433F1;
	Tue, 27 Feb 2024 13:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041939;
	bh=4hDNFE9Z0f7mVHHfCvouIzrHor32ewqEkYk/uDQ5wAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xqWO7/oiLD9Dgia8hEw7AgKa/AYJztfh7PmVWOdIYzYzC31GVioX6JkyrZKdBeULU
	 v4xlmj8fFdC9yJ/2K/LDB8ZUoAhUwAGk6tKScaaITgZkiED/pOy8oDu7K1i3E2vps3
	 zR0rPzYMwlqo7y7A59SDUBelida3Dw3BxMQK0p/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang.tang@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/299] mptcp: use mptcp_set_state
Date: Tue, 27 Feb 2024 14:23:52 +0100
Message-ID: <20240227131629.761757563@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Geliang Tang <geliang.tang@linux.dev>

[ Upstream commit c693a8516429908da3ea111b0caa3c042ab1e6e9 ]

This patch replaces all the 'inet_sk_state_store()' calls under net/mptcp
with the new helper mptcp_set_state().

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/460
Signed-off-by: Geliang Tang <geliang.tang@linux.dev>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e4a0fa47e816 ("mptcp: corner case locking for rx path fields initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c |  5 +++++
 net/mptcp/protocol.c   | 38 +++++++++++++++++++-------------------
 net/mptcp/subflow.c    |  2 +-
 3 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 3011bc378462b..44c0e96210a46 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1048,6 +1048,11 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	if (err)
 		return err;
 
+	/* We don't use mptcp_set_state() here because it needs to be called
+	 * under the msk socket lock. For the moment, that will not bring
+	 * anything more than only calling inet_sk_state_store(), because the
+	 * old status is known (TCP_CLOSE).
+	 */
 	inet_sk_state_store(newsk, TCP_LISTEN);
 	lock_sock(ssk);
 	err = __inet_listen_sk(ssk, backlog);
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 7765514451ded..2f794924ae5d4 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -445,11 +445,11 @@ static void mptcp_check_data_fin_ack(struct sock *sk)
 
 		switch (sk->sk_state) {
 		case TCP_FIN_WAIT1:
-			inet_sk_state_store(sk, TCP_FIN_WAIT2);
+			mptcp_set_state(sk, TCP_FIN_WAIT2);
 			break;
 		case TCP_CLOSING:
 		case TCP_LAST_ACK:
-			inet_sk_state_store(sk, TCP_CLOSE);
+			mptcp_set_state(sk, TCP_CLOSE);
 			break;
 		}
 
@@ -610,13 +610,13 @@ static bool mptcp_check_data_fin(struct sock *sk)
 
 		switch (sk->sk_state) {
 		case TCP_ESTABLISHED:
-			inet_sk_state_store(sk, TCP_CLOSE_WAIT);
+			mptcp_set_state(sk, TCP_CLOSE_WAIT);
 			break;
 		case TCP_FIN_WAIT1:
-			inet_sk_state_store(sk, TCP_CLOSING);
+			mptcp_set_state(sk, TCP_CLOSING);
 			break;
 		case TCP_FIN_WAIT2:
-			inet_sk_state_store(sk, TCP_CLOSE);
+			mptcp_set_state(sk, TCP_CLOSE);
 			break;
 		default:
 			/* Other states not expected */
@@ -791,7 +791,7 @@ static bool __mptcp_subflow_error_report(struct sock *sk, struct sock *ssk)
 	 */
 	ssk_state = inet_sk_state_load(ssk);
 	if (ssk_state == TCP_CLOSE && !sock_flag(sk, SOCK_DEAD))
-		inet_sk_state_store(sk, ssk_state);
+		mptcp_set_state(sk, ssk_state);
 	WRITE_ONCE(sk->sk_err, -err);
 
 	/* This barrier is coupled with smp_rmb() in mptcp_poll() */
@@ -2470,7 +2470,7 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	    inet_sk_state_load(msk->first) == TCP_CLOSE) {
 		if (sk->sk_state != TCP_ESTABLISHED ||
 		    msk->in_accept_queue || sock_flag(sk, SOCK_DEAD)) {
-			inet_sk_state_store(sk, TCP_CLOSE);
+			mptcp_set_state(sk, TCP_CLOSE);
 			mptcp_close_wake_up(sk);
 		} else {
 			mptcp_start_tout_timer(sk);
@@ -2565,7 +2565,7 @@ static void mptcp_check_fastclose(struct mptcp_sock *msk)
 		WRITE_ONCE(sk->sk_err, ECONNRESET);
 	}
 
-	inet_sk_state_store(sk, TCP_CLOSE);
+	mptcp_set_state(sk, TCP_CLOSE);
 	WRITE_ONCE(sk->sk_shutdown, SHUTDOWN_MASK);
 	smp_mb__before_atomic(); /* SHUTDOWN must be visible first */
 	set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags);
@@ -2700,7 +2700,7 @@ static void mptcp_do_fastclose(struct sock *sk)
 	struct mptcp_subflow_context *subflow, *tmp;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	inet_sk_state_store(sk, TCP_CLOSE);
+	mptcp_set_state(sk, TCP_CLOSE);
 	mptcp_for_each_subflow_safe(msk, subflow, tmp)
 		__mptcp_close_ssk(sk, mptcp_subflow_tcp_sock(subflow),
 				  subflow, MPTCP_CF_FASTCLOSE);
@@ -2917,7 +2917,7 @@ static int mptcp_close_state(struct sock *sk)
 	int next = (int)new_state[sk->sk_state];
 	int ns = next & TCP_STATE_MASK;
 
-	inet_sk_state_store(sk, ns);
+	mptcp_set_state(sk, ns);
 
 	return next & TCP_ACTION_FIN;
 }
@@ -3035,7 +3035,7 @@ bool __mptcp_close(struct sock *sk, long timeout)
 
 	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE)) {
 		mptcp_check_listen_stop(sk);
-		inet_sk_state_store(sk, TCP_CLOSE);
+		mptcp_set_state(sk, TCP_CLOSE);
 		goto cleanup;
 	}
 
@@ -3078,7 +3078,7 @@ bool __mptcp_close(struct sock *sk, long timeout)
 	 * state, let's not keep resources busy for no reasons
 	 */
 	if (subflows_alive == 0)
-		inet_sk_state_store(sk, TCP_CLOSE);
+		mptcp_set_state(sk, TCP_CLOSE);
 
 	sock_hold(sk);
 	pr_debug("msk=%p state=%d", sk, sk->sk_state);
@@ -3144,7 +3144,7 @@ static int mptcp_disconnect(struct sock *sk, int flags)
 		return -EBUSY;
 
 	mptcp_check_listen_stop(sk);
-	inet_sk_state_store(sk, TCP_CLOSE);
+	mptcp_set_state(sk, TCP_CLOSE);
 
 	mptcp_stop_rtx_timer(sk);
 	mptcp_stop_tout_timer(sk);
@@ -3231,7 +3231,7 @@ struct sock *mptcp_sk_clone_init(const struct sock *sk,
 	/* this can't race with mptcp_close(), as the msk is
 	 * not yet exposted to user-space
 	 */
-	inet_sk_state_store(nsk, TCP_ESTABLISHED);
+	mptcp_set_state(nsk, TCP_ESTABLISHED);
 
 	/* The msk maintain a ref to each subflow in the connections list */
 	WRITE_ONCE(msk->first, ssk);
@@ -3686,7 +3686,7 @@ static int mptcp_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	if (IS_ERR(ssk))
 		return PTR_ERR(ssk);
 
-	inet_sk_state_store(sk, TCP_SYN_SENT);
+	mptcp_set_state(sk, TCP_SYN_SENT);
 	subflow = mptcp_subflow_ctx(ssk);
 #ifdef CONFIG_TCP_MD5SIG
 	/* no MPTCP if MD5SIG is enabled on this socket or we may run out of
@@ -3736,7 +3736,7 @@ static int mptcp_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	if (unlikely(err)) {
 		/* avoid leaving a dangling token in an unconnected socket */
 		mptcp_token_destroy(msk);
-		inet_sk_state_store(sk, TCP_CLOSE);
+		mptcp_set_state(sk, TCP_CLOSE);
 		return err;
 	}
 
@@ -3826,13 +3826,13 @@ static int mptcp_listen(struct socket *sock, int backlog)
 		goto unlock;
 	}
 
-	inet_sk_state_store(sk, TCP_LISTEN);
+	mptcp_set_state(sk, TCP_LISTEN);
 	sock_set_flag(sk, SOCK_RCU_FREE);
 
 	lock_sock(ssk);
 	err = __inet_listen_sk(ssk, backlog);
 	release_sock(ssk);
-	inet_sk_state_store(sk, inet_sk_state_load(ssk));
+	mptcp_set_state(sk, inet_sk_state_load(ssk));
 
 	if (!err) {
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
@@ -3892,7 +3892,7 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 			__mptcp_close_ssk(newsk, msk->first,
 					  mptcp_subflow_ctx(msk->first), 0);
 			if (unlikely(list_is_singular(&msk->conn_list)))
-				inet_sk_state_store(newsk, TCP_CLOSE);
+				mptcp_set_state(newsk, TCP_CLOSE);
 		}
 	}
 	release_sock(newsk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 8c7e22a9a37bd..15f456fb28977 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -427,7 +427,7 @@ void __mptcp_sync_state(struct sock *sk, int state)
 	if (!msk->rcvspace_init)
 		mptcp_rcv_space_init(msk, msk->first);
 	if (sk->sk_state == TCP_SYN_SENT) {
-		inet_sk_state_store(sk, state);
+		mptcp_set_state(sk, state);
 		sk->sk_state_change(sk);
 	}
 }
-- 
2.43.0



