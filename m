Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829101;
	b=3c0P0/vKHdQLe7jjbge1roz6N6JkfP3qQGm+conSt3M13y+sTTOrGipsVEx0gNJlD2MM
	 DhUMt43AKfreA9MqGmoIZfFaRvdeCfgWvaHF3kUKwI40mrXOzTZOCsFpf30ulD5wn/aBz
	 ykjTEMdWjubhFqOAN80yb0tuizaxdgvidr3g4cA7yY+ShUTWaW8iCktSHuGDGuTahb5ig
	 bf/iJCvVF/O5w8miyeRNc3SZlJ+BT/kbenGktxudDTT4oHYma/8L1KjAxentMA0OUMezn
	 CV5qpTCv+mWh15Ofc2Aw17j+Px3SUja9Lec9xudBTtVYjAoB+F97E0nTgZFx5UeIu6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gGJqIrLFQFurPyd9SOudP/15ulx5FI/XlbXCQh9vL4c=;
	b=rusDGgK0t42z/xHyifOkmMx3gkM5Nnh+3arleIGGD5b0CBsBsTN6OfQueeEwU7PWK4xR
	 +HAfkXIy00eSl1UR3SSGvjfs1MhTT8/iq9EjJ1uSjxaiPhEb4verHikCL5HX8UedZLZTg
	 vJ33Fh9mh3pplwhJn45rDKt8jBDZpNpQDYgi3fcBfYaSx/plCd/zc0Pm+6zOvto1gQzcd
	 GXB3rgAOYK6CvH2iLrSfurOu8MheGxSHw8uerfqChj/v8MfJOnCQSkXYxp21mDdkYNqd5
	 +dIINDBIvMp28YUAyM+3VXeotxQ5mgo9e6QyaeTgWOftesn6bLbIEMm5jo5FbmIgZJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5EoxRZb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1DE6072FB3;
	Wed,  4 Nov 2026 21:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5EoxRZb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2024A1F000C1;
	Wed,  4 Nov 2026 21:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829101;
	bh=gGJqIrLFQFurPyd9SOudP/15ulx5FI/XlbXCQh9vL4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5EoxRZbs2Re3Jqbd7d9WaG61bRcpumLQWChq0RbK8vip5PevLjFt5mO2mIDzXc0F
	 MthBATxFVyI9Tt6/YJm4vKDWO50LPlxwSoXKTIcd6vvKdlCo+6oba/C5sV7p+3hPjo
	 wz1tcR0vrgi+U+wBVt7QXNBrJCBAAvP7/zH0S18Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org
Subject: [PATCH 7.3 447/547] rxrpc: Fix lack of short-send handling in rxrpc_kernel_send_data()
Date: Wed,  4 Nov 2026 16:10:31 -0500
Message-ID: <20261104211051.048596585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit af208f36ae22440cf6011a43cb3064fd525d85b4 upstream.

Fix rxrpc_kernel_send_data() to loop around if it detects a short send.
David Laight suggested doing it here rather than wrapping all the calls in
loops.  Further, remove the len argument and use the iterator count instead
and return 0 on success, not the amount copied.

Note this is also a prerequisite for changing the way rxrpc_send_data()
works to return a short send rather than an error if some data was
buffered.

Fixes: 651350d10f93 ("[AF_RXRPC]: Add an interface to the AF_RXRPC module for the AFS filesystem to use")
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260824091645.415423-1-dhowells%40redhat.com
Suggested-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261006133011.531806-5-dhowells@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/networking/rxrpc.rst |    8 +++++---
 fs/afs/rxrpc.c                     |   32 +++++++++++++-------------------
 include/net/af_rxrpc.h             |    5 ++---
 net/rxrpc/rxperf.c                 |   25 ++++++++++---------------
 net/rxrpc/sendmsg.c                |   27 +++++++++++++++++++--------
 5 files changed, 49 insertions(+), 48 deletions(-)

--- a/Documentation/networking/rxrpc.rst
+++ b/Documentation/networking/rxrpc.rst
@@ -870,7 +870,6 @@ The kernel interface functions are as fo
 	int rxrpc_kernel_send_data(struct socket *sock,
 				   struct rxrpc_call *call,
 				   struct msghdr *msg,
-				   size_t len,
 				   rxrpc_notify_end_tx_t notify_end_rx);
 
      This is used to supply either the request part of a client call or the
@@ -879,14 +878,17 @@ The kernel interface functions are as fo
      exclusively to in-kernel virtual addresses.  msg.msg_flags may be given
      MSG_MORE if there will be subsequent data sends for this call.
 
-     The msg must not specify a destination address, control data or any flags
-     other than MSG_MORE.  len is the total amount of data to transmit.
+     msg must not specify a destination address, control data or any flags
+     other than MSG_MORE or MSG_WAITALL.
 
      notify_end_rx can be NULL or it can be used to specify a function to be
      called when the call changes state to end the Tx phase.  This function is
      called with a spinlock held to prevent the last DATA packet from being
      transmitted until the function returns.
 
+     It returns 0 if all the provided data has been buffered and a negative
+     error code on failure.
+
  (#) Receive data from a call::
 
 	int rxrpc_kernel_recv_data(struct socket *sock,
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -412,8 +412,7 @@ void afs_make_call(struct afs_call *call
 	msg.msg_controllen	= 0;
 	msg.msg_flags		= MSG_WAITALL | (call->write_iter ? MSG_MORE : 0);
 
-	ret = rxrpc_kernel_send_data(call->net->socket, rxcall,
-				     &msg, call->request_size,
+	ret = rxrpc_kernel_send_data(call->net->socket, rxcall, &msg,
 				     afs_notify_end_request_tx);
 	if (ret < 0)
 		goto error_do_abort;
@@ -425,7 +424,6 @@ void afs_make_call(struct afs_call *call
 
 		ret = rxrpc_kernel_send_data(call->net->socket,
 					     call->rxcall, &msg,
-					     iov_iter_count(&msg.msg_iter),
 					     afs_notify_end_request_tx);
 		*call->write_iter = msg.msg_iter;
 
@@ -871,7 +869,7 @@ void afs_send_empty_reply(struct afs_cal
 	msg.msg_controllen	= 0;
 	msg.msg_flags		= 0;
 
-	switch (rxrpc_kernel_send_data(net->socket, call->rxcall, &msg, 0,
+	switch (rxrpc_kernel_send_data(net->socket, call->rxcall, &msg,
 				       afs_notify_end_reply_tx)) {
 	case 0:
 		_leave(" [replied]");
@@ -897,7 +895,7 @@ void afs_send_simple_reply(struct afs_ca
 	struct afs_net *net = call->net;
 	struct msghdr msg;
 	struct kvec iov[1];
-	int n;
+	int ret;
 
 	_enter("");
 
@@ -912,21 +910,17 @@ void afs_send_simple_reply(struct afs_ca
 	msg.msg_controllen	= 0;
 	msg.msg_flags		= 0;
 
-	n = rxrpc_kernel_send_data(net->socket, call->rxcall, &msg, len,
-				   afs_notify_end_reply_tx);
-	if (n >= 0) {
-		/* Success */
-		_leave(" [replied]");
-		return;
-	}
-
-	if (n == -ENOMEM) {
-		_debug("oom");
-		rxrpc_kernel_abort_call(net->socket, call->rxcall,
-					RXGEN_SS_MARSHAL, -ENOMEM,
-					afs_abort_oom);
+	ret = rxrpc_kernel_send_data(net->socket, call->rxcall, &msg,
+				     afs_notify_end_reply_tx);
+	if (ret < 0) {
+		if (ret == -ENOMEM) {
+			_debug("oom");
+			rxrpc_kernel_abort_call(net->socket, call->rxcall,
+						RXGEN_SS_MARSHAL, -ENOMEM,
+						afs_abort_oom);
+		}
+		_leave(" [error]");
 	}
-	_leave(" [error]");
 }
 
 /*
--- a/include/net/af_rxrpc.h
+++ b/include/net/af_rxrpc.h
@@ -64,9 +64,8 @@ struct rxrpc_call *rxrpc_kernel_begin_ca
 					   bool upgrade,
 					   enum rxrpc_interruptibility interruptibility,
 					   unsigned int debug_id);
-int rxrpc_kernel_send_data(struct socket *, struct rxrpc_call *,
-			   struct msghdr *, size_t,
-			   rxrpc_notify_end_tx_t);
+int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
+			   struct msghdr *msg, rxrpc_notify_end_tx_t notify_end_tx);
 int rxrpc_kernel_recv_data(struct socket *, struct rxrpc_call *,
 			   struct iov_iter *, size_t *, bool, u32 *, u16 *);
 bool rxrpc_kernel_abort_call(struct socket *, struct rxrpc_call *,
--- a/net/rxrpc/rxperf.c
+++ b/net/rxrpc/rxperf.c
@@ -513,8 +513,8 @@ static int rxperf_process_call(struct rx
 	struct msghdr msg = {};
 	struct bio_vec bv;
 	struct kvec iov[1];
-	ssize_t n;
 	size_t reply_len = call->reply_len, len;
+	int ret;
 
 	rxrpc_kernel_set_tx_length(rxperf_socket, call->rxcall,
 				   reply_len + sizeof(rxperf_magic_cookie));
@@ -524,13 +524,11 @@ static int rxperf_process_call(struct rx
 		bvec_set_page(&bv, ZERO_PAGE(0), len, 0);
 		iov_iter_bvec(&msg.msg_iter, WRITE, &bv, 1, len);
 		msg.msg_flags = MSG_MORE;
-		n = rxrpc_kernel_send_data(rxperf_socket, call->rxcall, &msg,
-					   len, rxperf_notify_end_reply_tx);
-		if (n < 0)
-			return n;
-		if (n == 0)
-			return -EIO;
-		reply_len -= n;
+		ret = rxrpc_kernel_send_data(rxperf_socket, call->rxcall, &msg,
+					     rxperf_notify_end_reply_tx);
+		if (ret < 0)
+			return ret;
+		reply_len -= len;
 	}
 
 	len = sizeof(rxperf_magic_cookie);
@@ -538,16 +536,13 @@ static int rxperf_process_call(struct rx
 	iov[0].iov_len	= len;
 	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 1, len);
 	msg.msg_flags = 0;
-	n = rxrpc_kernel_send_data(rxperf_socket, call->rxcall, &msg, len,
-				   rxperf_notify_end_reply_tx);
-	if (n >= 0)
-		return 0; /* Success */
-
-	if (n == -ENOMEM)
+	ret = rxrpc_kernel_send_data(rxperf_socket, call->rxcall, &msg,
+				     rxperf_notify_end_reply_tx);
+	if (ret == -ENOMEM)
 		rxrpc_kernel_abort_call(rxperf_socket, call->rxcall,
 					RXGEN_SS_MARSHAL, -ENOMEM,
 					rxperf_abort_oom);
-	return n;
+	return ret;
 }
 
 /*
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -793,7 +793,6 @@ error_release_sock:
  * @sock: The socket the call is on
  * @call: The call to send data through
  * @msg: The data to send
- * @len: The amount of data to send
  * @notify_end_tx: Notification that the last packet is queued.
  *
  * Allow a kernel service to send data on a call.  The call must be in an state
@@ -804,8 +803,7 @@ error_release_sock:
  * Return: %0 if successful and a negative error code otherwise.
  */
 int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
-			   struct msghdr *msg, size_t len,
-			   rxrpc_notify_end_tx_t notify_end_tx)
+			   struct msghdr *msg, rxrpc_notify_end_tx_t notify_end_tx)
 {
 	int ret;
 
@@ -814,12 +812,25 @@ int rxrpc_kernel_send_data(struct socket
 	ASSERTCMP(msg->msg_name, ==, NULL);
 	ASSERTCMP(msg->msg_control, ==, NULL);
 
-	mutex_lock(&call->user_mutex);
+	for (;;) {
+		mutex_lock(&call->user_mutex);
+
+		ret = rxrpc_send_data(rxrpc_sk(sock->sk), call, msg,
+				      msg_data_left(msg), notify_end_tx);
+		if (ret == -ESHUTDOWN)
+			ret = call->error;
+		if (ret < 0)
+			break;
+		if (msg_data_left(msg) == 0) {
+			ret = 0;
+			break;
+		}
+		if (ret == 0) {
+			ret = -EIO;
+			break;
+		}
+	}
 
-	ret = rxrpc_send_data(rxrpc_sk(sock->sk), call, msg, len,
-			      notify_end_tx);
-	if (ret == -ESHUTDOWN)
-		ret = call->error;
 	_leave(" = %d", ret);
 	return ret;
 }


