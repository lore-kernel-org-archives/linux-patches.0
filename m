Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045954;
	b=dtpbhRPz+6/2jLllAERKCmPBz5ZjjsRxE8yJ/f/zruIdCrSJLLxecQuSkCc/f13Q1RcG
	 Ss2KeVHfSsiuHYe0uWP/1igDmsz9nKPyjE4FS6OYQWeM5LIMmvUhkuZGgow3xoM8LJjsZ
	 8QK5Jq/dshWEM8S8VawF9sz0MWPfNw9pq7n66oysf75Dfv3pShTfhTjUyXzVDQ0EO9J+i
	 FlYl/ubwGsbc7lLOpCy7Oc/Wmba2okB2PQF8pi2TbiTzSxtwBI9cKHYPueCXU5+nW1uP6
	 kcOAA6qPkHpdW7PU9mLIRouXkowsbOYQKxx885UZ5/l500fUCmiw6J0oXMa+JEIxA6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cxYI4JYVD5y9HRPPILH7lMnAHCV/L/cqNuLd0gSaQcE=;
	b=K2kxBDOwdUcGC3rqGgOzCxXhC+U6ddanlekt+Lp3kWJh4g3NyhhdUxSGhlIoZHYSaHcE
	 EJwUoA7NALpFqWuz6jcHhumQEIF6b4ML9vDRbPSpMYEtmOmpiqlR1XbUaWx5kI5Txed6e
	 LJjrD3hBeZKnRXTZ37xX0sfieXsqSwUTJX4LS8SEGl0lbGqClwKF85tLvB3+u1fUdNVxK
	 6Y/tAxnddOnAkjpGW/D2nfs+14+R0GIKLetG8tZOmo6C3oenAqO4geH8aSsp3sXt0pk9/
	 qlQ1M9cZjs7Mp74hnALXI8YtoL17uthyTimPB0fGfb1eQvfiv5PyQTcfxQ4FYfMCC/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i0aYshjX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3D0606A320;
	Wed, 18 Nov 2026 23:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i0aYshjX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389041F000C4;
	Wed, 18 Nov 2026 23:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045953;
	bh=cxYI4JYVD5y9HRPPILH7lMnAHCV/L/cqNuLd0gSaQcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i0aYshjX+FrQZAdQoi/zZV5AqHXL2btcbaO6IUfCPhzopSAzWSgEUFvsahd19IoJV
	 4IkX+D2Q8FX2oaSztflhnlMVotl5vSKwcq4uwl7Zu9DQyxCPvwVVfG1q8LJWw8kfcU
	 aApEN5D7TTOmdv3rJFkyn6zjaAVllVhmce+dOkjM=
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
Subject: [PATCH 6.1 1107/2857] rxrpc: Fix update of call->tx_pending without holding lock
Date: Wed, 18 Nov 2026 15:35:41 +0100
Message-ID: <20261118150241.492725740@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted rxrpc_txbuf handling to sk_buff buffers within the existing caller control flow ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/sendmsg.c | 57 ++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 29 deletions(-)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index b03d93d8b69d0..28cd9fe93844e 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -287,11 +287,10 @@ static int rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 static int rxrpc_send_data(struct rxrpc_sock *rx,
 			   struct rxrpc_call *call,
 			   struct msghdr *msg, size_t len,
-			   rxrpc_notify_end_tx_t notify_end_tx,
-			   bool *_dropped_lock)
+			   rxrpc_notify_end_tx_t notify_end_tx)
+	__releases(&call->user_mutex)
 {
 	struct rxrpc_skb_priv *sp;
-	struct sk_buff *skb;
 	struct sock *sk = &rx->sk;
 	enum rxrpc_call_state state;
 	long timeo;
@@ -325,11 +324,9 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			goto maybe_error;
 	}
 
-	skb = call->tx_pending;
-	call->tx_pending = NULL;
-	rxrpc_see_skb(skb, rxrpc_skb_seen);
-
 	do {
+		struct sk_buff *skb = call->tx_pending;
+
 		/* Check to see if there's a ping ACK to reply to. */
 		if (call->ackr_reason == RXRPC_ACK_PING_RESPONSE)
 			rxrpc_send_ack_packet(call, false, NULL);
@@ -381,6 +378,9 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			       sp->remain);
 
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			call->tx_pending = skb;
+		} else {
+			rxrpc_see_skb(skb, rxrpc_skb_seen);
 		}
 
 		_debug("append");
@@ -432,13 +432,13 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 			ret = call->security->secure_packet(call, skb, skb->mark);
 			if (ret < 0)
-				goto out;
+				goto out_unlock;
 
 			ret = rxrpc_queue_packet(rx, call, skb,
 						 !msg_data_left(msg) && !more,
 						 notify_end_tx);
 			/* Should check for failure here */
-			skb = NULL;
+			call->tx_pending = NULL;
 		}
 	} while (msg_data_left(msg) > 0);
 
@@ -450,45 +450,46 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			ret = call->error;
 		read_unlock_bh(&call->state_lock);
 	}
-out:
-	call->tx_pending = skb;
+out_unlock:
+	mutex_unlock(&call->user_mutex);
 	_leave(" = %d", ret);
 	return ret;
 
 call_terminated:
-	rxrpc_free_skb(skb, rxrpc_skb_freed);
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
@@ -650,7 +651,6 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 	enum rxrpc_call_state state;
 	struct rxrpc_call *call;
 	unsigned long now, j;
-	bool dropped_lock = false;
 	int ret;
 
 	struct rxrpc_send_params p = {
@@ -760,12 +760,12 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
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
 	rxrpc_put_call(call, rxrpc_call_put);
 	_leave(" = %d", ret);
@@ -793,7 +793,6 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 			   struct msghdr *msg, size_t len,
 			   rxrpc_notify_end_tx_t notify_end_tx)
 {
-	bool dropped_lock = false;
 	int ret;
 
 	_enter("{%d,%s},", call->debug_id, rxrpc_call_states[call->state]);
@@ -811,8 +810,8 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 	case RXRPC_CALL_SERVER_ACK_REQUEST:
 	case RXRPC_CALL_SERVER_SEND_REPLY:
 		ret = rxrpc_send_data(rxrpc_sk(sock->sk), call, msg, len,
-				      notify_end_tx, &dropped_lock);
-		break;
+				      notify_end_tx);
+		goto out;
 	case RXRPC_CALL_COMPLETE:
 		read_lock_bh(&call->state_lock);
 		ret = call->error;
@@ -825,8 +824,8 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 		break;
 	}
 
-	if (!dropped_lock)
-		mutex_unlock(&call->user_mutex);
+	mutex_unlock(&call->user_mutex);
+out:
 	_leave(" = %d", ret);
 	return ret;
 }
-- 
2.53.0



