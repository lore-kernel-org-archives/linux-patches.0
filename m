Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037118;
	b=GCRO1U/LMT7FekYBasJtQ0lsbgE3+2Lp+0bOdCRChek/QZKhs88BYxR4rlJ1I5axxAgc
	 ynNycdCVNbric2O/nLG6HJcAGwQSBhm0itC9C3V5N0ptkea0smluznne7xNDJ+mpXyTL/
	 /UM1W8MyXP++sdQ3o61QAqGVTKf9ukOXC+jLg3ir0bTJVanV1ZRliLzcdip0KspW1Ay16
	 hsUXrtcgcRzaLoCNMioQq0nKgRlHyln0uwvPajXx7OqoJHPUlPXiT2I/KMSf5WqRnL/1C
	 rPkrWiwM7NUKOw99QW74ULXmoFnxBLinqahIAREwDia1dZe3xZFyBAHtS2zirQbyX5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6q7IiaDerySk8oIxf7qncCUGlmJaWN9lNCweeVJKbac=;
	b=K+YZUCsumMqN74U1+glAntQnvFJnNl8E2LpGeAHtP5SXI9gPjThPFphquXztRIooUGjN
	 BALaayu4+a0j8asgr867h1s/yh7E91csgVez5WqB6RnZg24FQnQgdlinVvsZJkCNzxq9A
	 W8XDrQYEKP9vGQ9MMrdeUwt9j4M6s/2kd2yTnbWNuQ4OWvHvFeyna3lUPrtnI4sD5VIkM
	 cZEAUEBfv2h1UBeXvMfBYpehXRT1GCEhRPwv4LOByRxi2moFdlbKa0FiHtpDKt/6c1mcQ
	 1oGZ1eUGEsa1Gu+0acDfd3thaGNVWJmshF9fdZ60110K4Y/frqXpOcaiKHka/ZAONPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xf8IYe7F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE77760A262D;
	Wed, 18 Nov 2026 21:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xf8IYe7F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0D91F000D0;
	Wed, 18 Nov 2026 21:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037118;
	bh=6q7IiaDerySk8oIxf7qncCUGlmJaWN9lNCweeVJKbac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xf8IYe7FPwkaqLV33HdW1syyoS/zNm4WJferBgWkPf3Yi2OOGc3P+h07VO8cnpyQm
	 8QtSd7VZvqa75z8s3uk3nnbtilDuD7UPlOsl0NOOvOVMTZDMyP4hpBWn388ykOi5on
	 tl+qNdgRUDvqg5wGej6Yb1P/h9g6SLPOYF0DZQJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1301/3318] rxrpc: Fix update of call->tx_pending without holding lock
Date: Wed, 18 Nov 2026 15:32:03 +0100
Message-ID: <20261118150359.294629774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 7801c42c3bb737cfb06194a383873fcad8daacf5 ]

Currently, rxrpc_send_data() updates call->tx_pending just before it
returns - but it won't be holding the call->user_mutex when it does this if
a wait was interrupted by a signal.  This would allow a parallel sendmsg()
to race.

Further, both the callers of rxrpc_send_data() call it with the lock held,
and then it returns an indication through the parameter list to say whether
it has dropped the lock or not - after which the callers both just drop the
lock if it's still held.

Fix this by:

 (1) Moving the release of call->user_mutex down into rxrpc_send_data() and
     get rid of the indicator parameter.  This makes it easier to see where
     the lock is held.

 (2) After waiting, if the attempt to reacquire the mutex is interrupted,
     just return directly there rather than going to out_unlock

 (3) Restricting the txb variable to inside the buffering loop and leaving
     ->tx_pending set until we've queued the buffer.

Note that there's a slight change in behaviour in that wait_for_space
failure now doesn't check for completion because it doesn't hold the call
user_mutex.  The caller, however, should re-issue the send and pick up any
error at a second attempt.

Fixes: b0f571ecd794 ("rxrpc: Fix locking in rxrpc's sendmsg")
Closes: https://sashiko.dev/#/patchset/20260702144919.172295-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261006133011.531806-4-dhowells@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ sashal: adapted caller cleanup to the existing if/else dispatch instead of upstream’s switch. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/sendmsg.c | 59 +++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 32 deletions(-)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 3dc54d6d4e316..dc86edb9bd3a8 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -279,10 +279,9 @@ static void rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 static int rxrpc_send_data(struct rxrpc_sock *rx,
 			   struct rxrpc_call *call,
 			   struct msghdr *msg, size_t len,
-			   rxrpc_notify_end_tx_t notify_end_tx,
-			   bool *_dropped_lock)
+			   rxrpc_notify_end_tx_t notify_end_tx)
+	__releases(&call->user_mutex)
 {
-	struct rxrpc_txbuf *txb;
 	struct sock *sk = &rx->sk;
 	enum rxrpc_call_state state;
 	long timeo;
@@ -293,23 +292,18 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 	ret = rxrpc_wait_to_be_connected(call, &timeo);
 	if (ret < 0)
-		return ret;
+		goto out_unlock;
 
 	if (call->conn->state == RXRPC_CONN_CLIENT_UNSECURED) {
 		ret = rxrpc_init_client_conn_security(call->conn);
 		if (ret < 0)
-			return ret;
+			goto out_unlock;
 	}
 
 	/* this should be in poll */
 	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
 
 reload:
-	txb = call->tx_pending;
-	call->tx_pending = NULL;
-	if (txb)
-		rxrpc_see_txbuf(txb, rxrpc_txbuf_see_send_more);
-
 	ret = -EPIPE;
 	if (sk->sk_shutdown & SEND_SHUTDOWN)
 		goto maybe_error;
@@ -337,6 +331,8 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 	}
 
 	do {
+		struct rxrpc_txbuf *txb = call->tx_pending;
+
 		if (!txb) {
 			size_t remain, bufsize, chunk, offset;
 
@@ -367,6 +363,9 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			txb->offset = offset;
 			txb->space -= offset;
 			txb->space = min_t(size_t, chunk, txb->space);
+			call->tx_pending = txb;
+		} else {
+			rxrpc_see_txbuf(txb, rxrpc_txbuf_see_send_more);
 		}
 
 		_debug("append");
@@ -406,10 +405,10 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 			ret = call->security->secure_packet(call, txb);
 			if (ret < 0)
-				goto out;
+				goto out_unlock;
 
 			rxrpc_queue_packet(rx, call, txb, notify_end_tx);
-			txb = NULL;
+			call->tx_pending = NULL;
 		}
 	} while (msg_data_left(msg) > 0);
 
@@ -418,45 +417,46 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 	if (rxrpc_call_is_complete(call) &&
 	    call->error < 0)
 		ret = call->error;
-out:
-	call->tx_pending = txb;
+out_unlock:
+	mutex_unlock(&call->user_mutex);
 	_leave(" = %d", ret);
 	return ret;
 
 call_terminated:
-	rxrpc_put_txbuf(txb, rxrpc_txbuf_put_send_aborted);
-	_leave(" = %d", call->error);
-	return call->error;
+	ret = call->error;
+	goto out_unlock;
 
 maybe_error:
 	if (copied)
 		goto success;
-	goto out;
+	goto out_unlock;
 
 efault:
 	ret = -EFAULT;
-	goto out;
+	goto out_unlock;
 
 wait_for_space:
 	ret = -EAGAIN;
 	if (msg->msg_flags & MSG_DONTWAIT)
 		goto maybe_error;
 	mutex_unlock(&call->user_mutex);
-	*_dropped_lock = true;
+
 	ret = rxrpc_wait_for_tx_window(rx, call, &timeo,
 				       msg->msg_flags & MSG_WAITALL);
 	if (ret < 0)
-		goto maybe_error;
+		goto out_nolock;
 	if (call->interruptibility == RXRPC_INTERRUPTIBLE) {
 		if (mutex_lock_interruptible(&call->user_mutex) < 0) {
 			ret = sock_intr_errno(timeo);
-			goto maybe_error;
+			goto out_nolock;
 		}
 	} else {
 		mutex_lock(&call->user_mutex);
 	}
-	*_dropped_lock = false;
 	goto reload;
+out_nolock:
+	_leave(" = %d [intr]", ret);
+	return copied ?: ret;
 }
 
 /*
@@ -615,7 +615,6 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 {
 	struct rxrpc_call *call;
 	unsigned long now, j;
-	bool dropped_lock = false;
 	int ret;
 
 	struct rxrpc_send_params p = {
@@ -725,12 +724,12 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 	} else if (p.command != RXRPC_CMD_SEND_DATA) {
 		ret = -EINVAL;
 	} else {
-		ret = rxrpc_send_data(rx, call, msg, len, NULL, &dropped_lock);
+		ret = rxrpc_send_data(rx, call, msg, len, NULL);
+		goto error_put;
 	}
 
 out_put_unlock:
-	if (!dropped_lock)
-		mutex_unlock(&call->user_mutex);
+	mutex_unlock(&call->user_mutex);
 error_put:
 	rxrpc_put_call(call, rxrpc_call_put_sendmsg);
 	_leave(" = %d", ret);
@@ -758,7 +757,6 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 			   struct msghdr *msg, size_t len,
 			   rxrpc_notify_end_tx_t notify_end_tx)
 {
-	bool dropped_lock = false;
 	int ret;
 
 	_enter("{%d},", call->debug_id);
@@ -769,12 +767,9 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 	mutex_lock(&call->user_mutex);
 
 	ret = rxrpc_send_data(rxrpc_sk(sock->sk), call, msg, len,
-			      notify_end_tx, &dropped_lock);
+			      notify_end_tx);
 	if (ret == -ESHUTDOWN)
 		ret = call->error;
-
-	if (!dropped_lock)
-		mutex_unlock(&call->user_mutex);
 	_leave(" = %d", ret);
 	return ret;
 }
-- 
2.53.0



