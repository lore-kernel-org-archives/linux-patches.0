Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2196B3947A4;
	Thu, 30 Jul 2026 16:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428032; cv=none; b=hbhIo1gqxd/yORm4SzaLJbdVSWWlYJE17kMRodFvSRv0Xf5/PGeTsaxXhSPgkncPknXSTIvzTPs99UnYF2HykR+LUfUkehibGcNCfetVLLae+fpiuc/WkRXZ68e1k5dB4zXYUifzA5xLYKufVZV4BzX5nsFvSMfCDhL3eUJGHYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428032; c=relaxed/simple;
	bh=ziWwdzHvD/1v7iVI4VEOqsnSagBTPtv6ZnnSb92srJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzuEFMl4foxCdPwsLLNBM7NlBRe0YPE+mjH3UXywNjqv+TQVVSAZRTiIsNwFq33+IixuDHPfasKcitKDfs19UNETs662lBTNqTEUIfVTj5GlXaK07GvibZQgBy6j2tBdfBUVfQz0Q8mWpoLRrsyg3jwL8RhlUVAlfxVLjdBSiyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1TN4XSW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1TN4XSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379551F000E9;
	Thu, 30 Jul 2026 16:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428030;
	bh=RNMwzdxHdsTtNRbBFSe2VxHwChZznhwe64dumKoMaOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x1TN4XSWA/11HzjTsxcLi+yZTQgCyqAT5gOgk6D5My03eTp2ZMT/xV2LEGzfAOxph
	 VuHUVnvA5e8e7neHXlzZRt88bg8xFbarQlf/AwGcEG+NT46SAUlQtDf04QTAu8qTVa
	 76G4kkioTtsOsojuUdIRb2qZq1ik587FB9VYJbng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 380/484] rxrpc: Pull out certain app callback funcs into an ops table
Date: Thu, 30 Jul 2026 16:14:37 +0200
Message-ID: <20260730141431.728313149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 23738cc8048322cf324f330cd697380fb3455da5 ]

A number of functions separately furnish an AF_RXRPC socket with callback
function pointers into a kernel app (such as the AFS filesystem) that is
using it.  Replace most of these with an ops table for the entire socket.
This makes it easier to add more callback functions.

Note that the call incoming data processing callback is retaind as that
gets set to different things, depending on the type of op.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20250411095303.2316168-3-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: dc175389b18c ("rxrpc: serialize kernel accept preallocation with socket teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/rxrpc.c          |   11 ++++++++---
 include/net/af_rxrpc.h  |   25 +++++++++++++++----------
 net/rxrpc/af_rxrpc.c    |   20 ++++++++------------
 net/rxrpc/ar-internal.h |    3 +--
 net/rxrpc/call_accept.c |   34 ++++++++++++++++------------------
 net/rxrpc/rxperf.c      |   10 +++++++---
 6 files changed, 55 insertions(+), 48 deletions(-)

--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -23,8 +23,15 @@ static void afs_wake_up_async_call(struc
 static void afs_process_async_call(struct work_struct *);
 static void afs_rx_new_call(struct sock *, struct rxrpc_call *, unsigned long);
 static void afs_rx_discard_new_call(struct rxrpc_call *, unsigned long);
+static void afs_rx_attach(struct rxrpc_call *rxcall, unsigned long user_call_ID);
 static int afs_deliver_cm_op_id(struct afs_call *);
 
+static const struct rxrpc_kernel_ops afs_rxrpc_callback_ops = {
+	.notify_new_call	= afs_rx_new_call,
+	.discard_new_call	= afs_rx_discard_new_call,
+	.user_attach_call	= afs_rx_attach,
+};
+
 /* asynchronous incoming call initial processing */
 static const struct afs_call_type afs_RXCMxxxx = {
 	.name		= "CB.xxxx",
@@ -83,8 +90,7 @@ int afs_open_socket(struct afs_net *net)
 	 * it sends back to us.
 	 */
 
-	rxrpc_kernel_new_call_notification(socket, afs_rx_new_call,
-					   afs_rx_discard_new_call);
+	rxrpc_kernel_set_notifications(socket, &afs_rxrpc_callback_ops);
 
 	ret = kernel_listen(socket, INT_MAX);
 	if (ret < 0)
@@ -748,7 +754,6 @@ void afs_charge_preallocation(struct wor
 
 		if (rxrpc_kernel_charge_accept(net->socket,
 					       afs_wake_up_async_call,
-					       afs_rx_attach,
 					       (unsigned long)call,
 					       GFP_KERNEL,
 					       call->debug_id) < 0)
--- a/include/net/af_rxrpc.h
+++ b/include/net/af_rxrpc.h
@@ -28,18 +28,23 @@ enum rxrpc_interruptibility {
  */
 extern atomic_t rxrpc_debug_id;
 
+/*
+ * Operations table for rxrpc to call out to a kernel application (e.g. kAFS).
+ */
+struct rxrpc_kernel_ops {
+	void (*notify_new_call)(struct sock *sk, struct rxrpc_call *call,
+				unsigned long user_call_ID);
+	void (*discard_new_call)(struct rxrpc_call *call, unsigned long user_call_ID);
+	void (*user_attach_call)(struct rxrpc_call *call, unsigned long user_call_ID);
+};
+
 typedef void (*rxrpc_notify_rx_t)(struct sock *, struct rxrpc_call *,
 				  unsigned long);
 typedef void (*rxrpc_notify_end_tx_t)(struct sock *, struct rxrpc_call *,
 				      unsigned long);
-typedef void (*rxrpc_notify_new_call_t)(struct sock *, struct rxrpc_call *,
-					unsigned long);
-typedef void (*rxrpc_discard_new_call_t)(struct rxrpc_call *, unsigned long);
-typedef void (*rxrpc_user_attach_call_t)(struct rxrpc_call *, unsigned long);
 
-void rxrpc_kernel_new_call_notification(struct socket *,
-					rxrpc_notify_new_call_t,
-					rxrpc_discard_new_call_t);
+void rxrpc_kernel_set_notifications(struct socket *sock,
+				    const struct rxrpc_kernel_ops *app_ops);
 struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *sock,
 					   struct sockaddr_rxrpc *srx,
 					   struct key *key,
@@ -63,9 +68,9 @@ void rxrpc_kernel_put_call(struct socket
 void rxrpc_kernel_get_peer(struct socket *, struct rxrpc_call *,
 			   struct sockaddr_rxrpc *);
 bool rxrpc_kernel_get_srtt(struct socket *, struct rxrpc_call *, u32 *);
-int rxrpc_kernel_charge_accept(struct socket *, rxrpc_notify_rx_t,
-			       rxrpc_user_attach_call_t, unsigned long, gfp_t,
-			       unsigned int);
+int rxrpc_kernel_charge_accept(struct socket *sock, rxrpc_notify_rx_t notify_rx,
+			       unsigned long user_call_ID, gfp_t gfp,
+			       unsigned int debug_id);
 void rxrpc_kernel_set_tx_length(struct socket *, struct rxrpc_call *, s64);
 bool rxrpc_kernel_check_life(const struct socket *, const struct rxrpc_call *);
 u32 rxrpc_kernel_get_epoch(struct socket *, struct rxrpc_call *);
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -418,24 +418,20 @@ u32 rxrpc_kernel_get_epoch(struct socket
 EXPORT_SYMBOL(rxrpc_kernel_get_epoch);
 
 /**
- * rxrpc_kernel_new_call_notification - Get notifications of new calls
- * @sock: The socket to intercept received messages on
- * @notify_new_call: Function to be called when new calls appear
- * @discard_new_call: Function to discard preallocated calls
+ * rxrpc_kernel_set_notifications - Set table of callback operations
+ * @sock: The socket to install table upon
+ * @app_ops: Callback operation table to set
  *
- * Allow a kernel service to be given notifications about new calls.
+ * Allow a kernel service to set a table of event notifications on a socket.
  */
-void rxrpc_kernel_new_call_notification(
-	struct socket *sock,
-	rxrpc_notify_new_call_t notify_new_call,
-	rxrpc_discard_new_call_t discard_new_call)
+void rxrpc_kernel_set_notifications(struct socket *sock,
+				    const struct rxrpc_kernel_ops *app_ops)
 {
 	struct rxrpc_sock *rx = rxrpc_sk(sock->sk);
 
-	rx->notify_new_call = notify_new_call;
-	rx->discard_new_call = discard_new_call;
+	rx->app_ops = app_ops;
 }
-EXPORT_SYMBOL(rxrpc_kernel_new_call_notification);
+EXPORT_SYMBOL(rxrpc_kernel_set_notifications);
 
 /**
  * rxrpc_kernel_set_max_life - Set maximum lifespan on a call
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -141,8 +141,7 @@ struct rxrpc_backlog {
 struct rxrpc_sock {
 	/* WARNING: sk has to be the first member */
 	struct sock		sk;
-	rxrpc_notify_new_call_t	notify_new_call; /* Func to notify of new call */
-	rxrpc_discard_new_call_t discard_new_call; /* Func to discard a new call */
+	const struct rxrpc_kernel_ops *app_ops;	/* Table of kernel app notification funcs */
 	struct rxrpc_local	*local;		/* local endpoint */
 	struct rxrpc_backlog	*backlog;	/* Preallocation for services */
 	spinlock_t		incoming_lock;	/* Incoming call vs service shutdown lock */
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -34,7 +34,6 @@ static void rxrpc_dummy_notify(struct so
 static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 				      struct rxrpc_backlog *b,
 				      rxrpc_notify_rx_t notify_rx,
-				      rxrpc_user_attach_call_t user_attach_call,
 				      unsigned long user_call_ID, gfp_t gfp,
 				      unsigned int debug_id)
 {
@@ -123,9 +122,10 @@ static int rxrpc_service_prealloc_one(st
 
 	call->user_call_ID = user_call_ID;
 	call->notify_rx = notify_rx;
-	if (user_attach_call) {
+	if (rx->app_ops &&
+	    rx->app_ops->user_attach_call) {
 		rxrpc_get_call(call, rxrpc_call_get_kernel_service);
-		user_attach_call(call, user_call_ID);
+		rx->app_ops->user_attach_call(call, user_call_ID);
 	}
 
 	rxrpc_get_call(call, rxrpc_call_get_userid);
@@ -221,9 +221,10 @@ void rxrpc_discard_prealloc(struct rxrpc
 		struct rxrpc_call *call = b->call_backlog[tail];
 		rxrpc_see_call(call, rxrpc_call_see_discard);
 		rcu_assign_pointer(call->socket, rx);
-		if (rx->discard_new_call) {
+		if (rx->app_ops &&
+		    rx->app_ops->discard_new_call) {
 			_debug("discard %lx", call->user_call_ID);
-			rx->discard_new_call(call, call->user_call_ID);
+			rx->app_ops->discard_new_call(call, call->user_call_ID);
 			if (call->notify_rx)
 				call->notify_rx = rxrpc_dummy_notify;
 			rxrpc_put_call(call, rxrpc_call_put_kernel);
@@ -392,8 +393,9 @@ bool rxrpc_new_incoming_call(struct rxrp
 	rxrpc_incoming_call(rx, call, skb);
 	conn = call->conn;
 
-	if (rx->notify_new_call)
-		rx->notify_new_call(&rx->sk, call, call->user_call_ID);
+	if (rx->app_ops &&
+	    rx->app_ops->notify_new_call)
+		rx->app_ops->notify_new_call(&rx->sk, call, call->user_call_ID);
 
 	spin_lock(&conn->state_lock);
 	if (conn->state == RXRPC_CONN_SERVICE_UNSECURED) {
@@ -445,8 +447,7 @@ int rxrpc_user_charge_accept(struct rxrp
 	if (rx->sk.sk_state == RXRPC_CLOSE)
 		return -ESHUTDOWN;
 
-	return rxrpc_service_prealloc_one(rx, b, NULL, NULL, user_call_ID,
-					  GFP_KERNEL,
+	return rxrpc_service_prealloc_one(rx, b, NULL, user_call_ID, GFP_KERNEL,
 					  atomic_inc_return(&rxrpc_debug_id));
 }
 
@@ -454,20 +455,18 @@ int rxrpc_user_charge_accept(struct rxrp
  * rxrpc_kernel_charge_accept - Charge up socket with preallocated calls
  * @sock: The socket on which to preallocate
  * @notify_rx: Event notification function for the call
- * @user_attach_call: Func to attach call to user_call_ID
  * @user_call_ID: The tag to attach to the preallocated call
  * @gfp: The allocation conditions.
  * @debug_id: The tracing debug ID.
  *
- * Charge up the socket with preallocated calls, each with a user ID.  A
- * function should be provided to effect the attachment from the user's side.
- * The user is given a ref to hold on the call.
+ * Charge up the socket with preallocated calls, each with a user ID.  The
+ * ->user_attach_call() callback function should be provided to effect the
+ * attachment from the user's side.  The user is given a ref to hold on the
+ * call.
  *
  * Note that the call may be come connected before this function returns.
  */
-int rxrpc_kernel_charge_accept(struct socket *sock,
-			       rxrpc_notify_rx_t notify_rx,
-			       rxrpc_user_attach_call_t user_attach_call,
+int rxrpc_kernel_charge_accept(struct socket *sock, rxrpc_notify_rx_t notify_rx,
 			       unsigned long user_call_ID, gfp_t gfp,
 			       unsigned int debug_id)
 {
@@ -477,8 +476,7 @@ int rxrpc_kernel_charge_accept(struct so
 	if (sock->sk->sk_state == RXRPC_CLOSE)
 		return -ESHUTDOWN;
 
-	return rxrpc_service_prealloc_one(rx, b, notify_rx,
-					  user_attach_call, user_call_ID,
+	return rxrpc_service_prealloc_one(rx, b, notify_rx, user_call_ID,
 					  gfp, debug_id);
 }
 EXPORT_SYMBOL(rxrpc_kernel_charge_accept);
--- a/net/rxrpc/rxperf.c
+++ b/net/rxrpc/rxperf.c
@@ -136,6 +136,12 @@ static void rxperf_notify_end_reply_tx(s
 			      RXPERF_CALL_SV_AWAIT_ACK);
 }
 
+static const struct rxrpc_kernel_ops rxperf_rxrpc_callback_ops = {
+	.notify_new_call	= rxperf_rx_new_call,
+	.discard_new_call	= rxperf_rx_discard_new_call,
+	.user_attach_call	= rxperf_rx_attach,
+};
+
 /*
  * Charge the incoming call preallocation.
  */
@@ -161,7 +167,6 @@ static void rxperf_charge_preallocation(
 
 		if (rxrpc_kernel_charge_accept(rxperf_socket,
 					       rxperf_notify_rx,
-					       rxperf_rx_attach,
 					       (unsigned long)call,
 					       GFP_KERNEL,
 					       call->debug_id) < 0)
@@ -209,8 +214,7 @@ static int rxperf_open_socket(void)
 	if (ret < 0)
 		goto error_2;
 
-	rxrpc_kernel_new_call_notification(socket, rxperf_rx_new_call,
-					   rxperf_rx_discard_new_call);
+	rxrpc_kernel_set_notifications(socket, &rxperf_rxrpc_callback_ops);
 
 	ret = kernel_listen(socket, INT_MAX);
 	if (ret < 0)


