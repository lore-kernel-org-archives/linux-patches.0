Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625037;
	b=PGDem1S8ZHc/Schzf5CxfH+tCG/O3lDnyXAwRXqvFneUapQyFY4Jk/ntOE8B/eFOucWU
	 4lAQeyxzR7G/KS8Jr7v8iyTmEddmRUSHGqwxdcTilKBmJ23x2qtjudtliPoC93E/GKWxu
	 BPrBbvYo1i2Z5wnTKdIARbjwanIppRHCnWJHmESk3WLzDrAC//m5buh7imnZXbtRn3vNA
	 BQ0b5Rqg/2d6inbTNm+pAxujhO/wA/tAZP8F5IILc5vwXXnQUVu07T4psbN/S8C8bnc+R
	 IUdgs8+9gPTyhcJncCTrB92gXOiZMwEdbWWL2B5DktM4MGEG+W8T0XcI0MOo8h6fiIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WhA4lZ6FFn1Ah9lHLTbj1uWOkxYDVUunZUBaGKdWRyE=;
	b=vIrHqhCu/dZp9EBP48LLA5sNvIZXhXPD/WxkadGqXhCZFVr40szdO62nYNGLBp3KIqI/
	 eNUJAI9l5+/MapDg8iUHlgyHY5gheH7kSXIX8TM0Jhc9pjRpeMac1LyQG++Gac/4sw6qk
	 UmNmEhfhztmuRfAfISAfXV1TQ6slQNbwpYSQbHhgcj8NqVZnmkDiS5iSZ/4V+7oJ4F9pE
	 EZZ+wnXv3/74VUPNKJrTycDDNJvZVJz278qgnXeoHpMOU/as8ZDFZ+Xj5K895IFhDIW/6
	 7sN3PpKaCR3RrGZikZApv04HEE7U+wHwAN1zhrTFmObycs6eAFF6yw45BRrvO/wAMAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z3NDBZwJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50C5606A31E;
	Wed, 25 Nov 2026 16:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z3NDBZwJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014971F000C4;
	Wed, 25 Nov 2026 16:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625037;
	bh=WhA4lZ6FFn1Ah9lHLTbj1uWOkxYDVUunZUBaGKdWRyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z3NDBZwJwEK3PExvwwb9MBTuvwvZgmxcbcH1xeGWfM1sRGUqVovApF8JEJ67ju31y
	 g5RLp7zqSSciGNUqDmtfcqtxoV0j7CnmDZT+eK9qjxlHv6nDdNAnzsp36hz6O+L4/y
	 FVoI76jNYjk8SfZUpqBv+Zv5mVDNhlzxx8+hAnCs=
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
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 369/816] rxrpc: Fix lack of short-send handling in rxrpc_kernel_send_data()
Date: Wed, 25 Nov 2026 15:31:57 +0100
Message-ID: <20261125143857.738776303@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit af208f36ae22440cf6011a43cb3064fd525d85b4 ]

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
[ sashal: Dropped the len argument from the rxrpc_kernel_send_data() calls in afs_send_empty_reply() and afs_send_simple_reply() while keeping the branch's existing abort-on-send-error handling instead of upstream's rewritten switch/-ENOMEM logic. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/rxrpc.rst |  8 +++++---
 fs/afs/rxrpc.c                     |  8 +++-----
 include/net/af_rxrpc.h             |  5 ++---
 net/rxrpc/rxperf.c                 | 25 ++++++++++---------------
 net/rxrpc/sendmsg.c                | 27 +++++++++++++++++++--------
 5 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/Documentation/networking/rxrpc.rst b/Documentation/networking/rxrpc.rst
index bb699ff4fe942..282b4933deb3b 100644
--- a/Documentation/networking/rxrpc.rst
+++ b/Documentation/networking/rxrpc.rst
@@ -873,7 +873,6 @@ The kernel interface functions are as follows:
 	int rxrpc_kernel_send_data(struct socket *sock,
 				   struct rxrpc_call *call,
 				   struct msghdr *msg,
-				   size_t len,
 				   rxrpc_notify_end_tx_t notify_end_rx);
 
      This is used to supply either the request part of a client call or the
@@ -882,14 +881,17 @@ The kernel interface functions are as follows:
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
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 934667e547dc2..2d13a9060ceaf 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -411,8 +411,7 @@ void afs_make_call(struct afs_call *call, gfp_t gfp)
 	msg.msg_controllen	= 0;
 	msg.msg_flags		= MSG_WAITALL | (call->write_iter ? MSG_MORE : 0);
 
-	ret = rxrpc_kernel_send_data(call->net->socket, rxcall,
-				     &msg, call->request_size,
+	ret = rxrpc_kernel_send_data(call->net->socket, rxcall, &msg,
 				     afs_notify_end_request_tx);
 	if (ret < 0)
 		goto error_do_abort;
@@ -424,7 +423,6 @@ void afs_make_call(struct afs_call *call, gfp_t gfp)
 
 		ret = rxrpc_kernel_send_data(call->net->socket,
 					     call->rxcall, &msg,
-					     iov_iter_count(&msg.msg_iter),
 					     afs_notify_end_request_tx);
 		*call->write_iter = msg.msg_iter;
 
@@ -864,7 +862,7 @@ void afs_send_empty_reply(struct afs_call *call)
 	msg.msg_controllen	= 0;
 	msg.msg_flags		= 0;
 
-	ret = rxrpc_kernel_send_data(net->socket, call->rxcall, &msg, 0,
+	ret = rxrpc_kernel_send_data(net->socket, call->rxcall, &msg,
 				     afs_notify_end_reply_tx);
 	if (ret < 0) {
 		rxrpc_kernel_abort_call(net->socket, call->rxcall,
@@ -897,7 +895,7 @@ void afs_send_simple_reply(struct afs_call *call, const void *buf, size_t len)
 	msg.msg_controllen	= 0;
 	msg.msg_flags		= 0;
 
-	ret = rxrpc_kernel_send_data(net->socket, call->rxcall, &msg, len,
+	ret = rxrpc_kernel_send_data(net->socket, call->rxcall, &msg,
 				     afs_notify_end_reply_tx);
 	if (ret < 0) {
 		rxrpc_kernel_abort_call(net->socket, call->rxcall,
diff --git a/include/net/af_rxrpc.h b/include/net/af_rxrpc.h
index ebb6092c488b5..e1c3f1f3c2ab0 100644
--- a/include/net/af_rxrpc.h
+++ b/include/net/af_rxrpc.h
@@ -58,9 +58,8 @@ struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *sock,
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
diff --git a/net/rxrpc/rxperf.c b/net/rxrpc/rxperf.c
index 25903cd294637..c16afe540d09c 100644
--- a/net/rxrpc/rxperf.c
+++ b/net/rxrpc/rxperf.c
@@ -512,8 +512,8 @@ static int rxperf_process_call(struct rxperf_call *call)
 	struct msghdr msg = {};
 	struct bio_vec bv;
 	struct kvec iov[1];
-	ssize_t n;
 	size_t reply_len = call->reply_len, len;
+	int ret;
 
 	rxrpc_kernel_set_tx_length(rxperf_socket, call->rxcall,
 				   reply_len + sizeof(rxperf_magic_cookie));
@@ -523,13 +523,11 @@ static int rxperf_process_call(struct rxperf_call *call)
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
@@ -537,16 +535,13 @@ static int rxperf_process_call(struct rxperf_call *call)
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
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 9d68e58dace9c..ea649144c49f0 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -737,7 +737,6 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
  * @sock: The socket the call is on
  * @call: The call to send data through
  * @msg: The data to send
- * @len: The amount of data to send
  * @notify_end_tx: Notification that the last packet is queued.
  *
  * Allow a kernel service to send data on a call.  The call must be in an state
@@ -748,8 +747,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
  * Return: %0 if successful and a negative error code otherwise.
  */
 int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
-			   struct msghdr *msg, size_t len,
-			   rxrpc_notify_end_tx_t notify_end_tx)
+			   struct msghdr *msg, rxrpc_notify_end_tx_t notify_end_tx)
 {
 	int ret;
 
@@ -758,12 +756,25 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
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
-- 
2.53.0



