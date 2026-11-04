Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831798;
	b=tN9zryi8enah3GeXqJPSaFxD5R2d1ZeL/cPEWf0EHsmixgsDg5l2V3D3f4+WSgnMuBJr
	 Jimk6tigWss7077fHk7QW+aP33BFrnUPLQfW22yv8y8yRl6tKorkZQ4wq1G3xSNb883bI
	 +RixAcLobF5lYwCkd6l5oyk7wWVYmE3Sw77nvo2p/f9LTF3MvzjHDI1xjxDCTqVQRs1B7
	 AveUc6C1osujnLZvPZFSk0LiYI9R0IAk2cFxXiJbZMGnhtZLerFZE3wMPYUtmSEhRqhlG
	 TjBtyt1LiBk2RMFnE3FIhxwmyiIiRD9eUhqu8SKfBhyjanlfA86oaAIGtom9z06k5Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zIzJsHholdqyHde0ZBmCMUU12P4oCtxx1aPnp0DUlbk=;
	b=scqK195l6/TgGheddG+rSgRp/0IRACrBCKtZqwaB3qwOf0sVWA1YR5uoOAEjxqfa4REg
	 t1D+0ftBb/PXGgWZC1HX/jGuqdZjlNIfM0DxoVMzzG+MKyO6N6PO1VojnzIjtHtt+k9og
	 5dzk4gLVEltMdQoh0rCOTX5oU8Q7TCeFaa5+NoPkVqUuhk1dnkrwlQ+ZLt0m+yKxm3ik5
	 2KvGEroUkuALBrh0l26xlxvrdsbBWUfnEfZDOWE5sTbCm1QFHe5vSjJgcEKjnc2fOn7/m
	 Qv0oGlZo9uIyo9tED4TtMsQaCAC2Pj+rR9XSd+6Z9J8lZTbzhGJskXEOjVBR8TJuoRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iIKR4Hib;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2F7606A33A;
	Wed,  4 Nov 2026 22:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iIKR4Hib
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79AC1F00919;
	Wed,  4 Nov 2026 22:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831798;
	bh=zIzJsHholdqyHde0ZBmCMUU12P4oCtxx1aPnp0DUlbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iIKR4HibAUbdaFgjplGW76Vjx0h49kaFHyekT39QT4JBHZYqJIZDdQtiG0zHrGbL6
	 Wsaa9cD3igrUI7G5STfMPK6QIDY4gduKQ9R8Gp5tq/xijAMpZ8NOCjJzvVJWYJjTIf
	 UdEgSTdq9cT3NG1GbU39P089q6dmH2ODPSSRFmH8=
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
	linux-afs@lists.infradead.org
Subject: [PATCH 6.18 0918/1005] rxrpc: Fix update of call->tx_pending without holding lock
Date: Wed,  4 Nov 2026 16:10:51 -0500
Message-ID: <20261104211108.867760214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 7801c42c3bb737cfb06194a383873fcad8daacf5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/sendmsg.c |   63 +++++++++++++++++++++++-----------------------------
 1 file changed, 29 insertions(+), 34 deletions(-)

--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -320,10 +320,9 @@ static int rxrpc_alloc_txqueue(struct so
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
@@ -334,30 +333,26 @@ static int rxrpc_send_data(struct rxrpc_
 		trace_rxrpc_abort(call->debug_id, rxrpc_sendmsg_late_send,
 				  call->cid, call->call_id, call->rx_consumed,
 				  0, -EPROTO);
-		return -EPROTO;
+		ret = -EPROTO;
+		goto out_unlock;
 	}
 
 	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 
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
@@ -386,6 +381,8 @@ reload:
 	}
 
 	do {
+		struct rxrpc_txbuf *txb = call->tx_pending;
+
 		if (!txb) {
 			size_t remain;
 
@@ -411,6 +408,9 @@ reload:
 				ret = -ENOMEM;
 				goto maybe_error;
 			}
+			call->tx_pending = txb;
+		} else {
+			rxrpc_see_txbuf(txb, rxrpc_txbuf_see_send_more);
 		}
 
 		_debug("append");
@@ -445,9 +445,9 @@ reload:
 
 			ret = call->security->secure_packet(call, txb);
 			if (ret < 0)
-				goto out;
+				goto out_unlock;
 			rxrpc_queue_packet(rx, call, txb, notify_end_tx);
-			txb = NULL;
+			call->tx_pending = NULL;
 		}
 	} while (msg_data_left(msg) > 0);
 
@@ -456,45 +456,46 @@ success:
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
@@ -660,7 +661,6 @@ rxrpc_new_client_call_for_sendmsg(struct
 int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 {
 	struct rxrpc_call *call;
-	bool dropped_lock = false;
 	int ret;
 
 	struct rxrpc_send_params p = {
@@ -769,16 +769,15 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *
 		ret = 0;
 		break;
 	case RXRPC_CMD_SEND_DATA:
-		ret = rxrpc_send_data(rx, call, msg, len, NULL, &dropped_lock);
-		break;
+		ret = rxrpc_send_data(rx, call, msg, len, NULL);
+		goto error_put;
 	default:
 		ret = -EINVAL;
 		break;
 	}
 
 out_put_unlock:
-	if (!dropped_lock)
-		mutex_unlock(&call->user_mutex);
+	mutex_unlock(&call->user_mutex);
 error_put:
 	rxrpc_put_call(call, rxrpc_call_put_sendmsg);
 	_leave(" = %d", ret);
@@ -808,7 +807,6 @@ int rxrpc_kernel_send_data(struct socket
 			   struct msghdr *msg, size_t len,
 			   rxrpc_notify_end_tx_t notify_end_tx)
 {
-	bool dropped_lock = false;
 	int ret;
 
 	_enter("{%d},", call->debug_id);
@@ -819,12 +817,9 @@ int rxrpc_kernel_send_data(struct socket
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


