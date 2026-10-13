Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37B7375F88;
	Tue, 13 Oct 2026 11:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892047; cv=none; b=jQe8Ep3ytKqhysBYQeKdFro3Z2S3hRKr1EXgdkG/khu1X6uthrGo2FcC/lsL23WPaa9KpyHJUmcfYU5CiQCSumA60MTBCKKgGHZKojDCs0Nv8mIvYlHLdps7J3oaLPZpu9XYYUef2+akxvAcstwbuD7Xn7jInzmtHM2icwVwP1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892047; c=relaxed/simple;
	bh=CSW1+oV6G6N99LVIh9KrhwRNZV/89SG3W9XiDtIVoSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9pNwL/CZlYUXTCFV1ZtRHT8Go4ovuz5EyUeDFs97Zm4mo6yYKisHeWV5mMlmDtL9bsNNCycoFFsOgZr5oSoVWdjghfA7+6bU9Q0wYR7ym8QtZXi+bKtwg2/Ss0Qnvn6LtZ3lg/iWPfkePnGJ4Iz356z0W6jnUYKOPtiBZ9Xni0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rFJsI654; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rFJsI654"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60C41F000FF;
	Tue, 13 Oct 2026 11:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892045;
	bh=62K0Zpl/YmLD3zBSW2aeMgNtEp9Qe2sI/vB3lC2aEGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rFJsI654IyhM7PEbH70piB11wWkAHaMdqYvpvxpOQjoT8s5R4GNt57rx4bDS+Pn45
	 N68/TgmT3pOqOSxFNyqsab+k2iH4UJ/wtkytIpXCERtzrzpFqU6LbFQPTMpAOMWlhN
	 HE13nkySBrzohADdPCtHYqBu7PdiaadOXrhq2Kpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Yuqi Xu <xuyuqiabc@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 7.2 043/281] tipc: destroy topsrv workqueues before closing connections
Date: Tue, 13 Oct 2026 13:35:59 +0200
Message-ID: <20261013112856.098956257@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuqi Xu <xuyuqiabc@gmail.com>

commit 3acdd44385bc7e2e57605e073691ce69cc5a960d upstream.

tipc_topsrv_stop() closed subscriber connections while the topology
server's send and receive workqueues were still running. Socket
callbacks and subscription events could then queue more work, and
in-flight send/recv work could drop the last connection reference
during the conn_idr walk.

That race produced several teardown failures: refcount_t addition on
0 from conn_get() on a connection whose release was blocked on
idr_lock, a subsequent use-after-free in tipc_conn_close(),
queue_work() on an already destroyed workqueue from the listener
data-ready callback, and an RCU stall in tipc_topsrv_exit_net()
while the walk spun under idr_lock.

Clear srv->listener under idr_lock so it acts as a shutdown flag,
skip queue_work() once it is NULL, destroy the workqueues to flush
in-flight work, and only then close the remaining connections.
Refuse tipc_conn_lookup() after that flag is cleared, and drop
idr_lock when the teardown walk finds no connection, so an
in-flight subscription event cannot pin idr_in_use while the
walk holds the lock.

v3 supersedes the narrower in-thread diff Tung Quang Nguyen
posted on 2026-09-23. It keeps his teardown order and adds the
lookup refusal and the empty-idr unlock.

Fixes: c5fa7b3cf3cb ("tipc: introduce new TIPC server infrastructure")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
Reviewed-by: Ren Wei <weir@nebusec.ai>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/topsrv.c |   80 +++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 65 insertions(+), 15 deletions(-)

--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -55,7 +55,7 @@
 /**
  * struct tipc_topsrv - TIPC server structure
  * @conn_idr: identifier set of connection
- * @idr_lock: protect the connection identifier set
+ * @idr_lock: protect the connection identifier set and listener
  * @idr_in_use: amount of allocated identifier entry
  * @net: network namespace instance
  * @awork: accept work item
@@ -218,6 +218,10 @@ static struct tipc_conn *tipc_conn_looku
 	struct tipc_conn *con;
 
 	spin_lock_bh(&s->idr_lock);
+	if (!s->listener) {
+		spin_unlock_bh(&s->idr_lock);
+		return NULL;
+	}
 	con = idr_find(&s->conn_idr, conid);
 	if (!connected(con) || !kref_get_unless_zero(&con->kref))
 		con = NULL;
@@ -301,10 +305,20 @@ static void tipc_conn_send_to_sock(struc
 static void tipc_conn_send_work(struct work_struct *work)
 {
 	struct tipc_conn *con = container_of(work, struct tipc_conn, swork);
+	struct tipc_topsrv *srv;
+
+	srv = con->server;
+	spin_lock_bh(&srv->idr_lock);
+	if (!srv->listener) {
+		spin_unlock_bh(&srv->idr_lock);
+		goto out;
+	}
+	spin_unlock_bh(&srv->idr_lock);
 
 	if (connected(con))
 		tipc_conn_send_to_sock(con);
 
+out:
 	conn_put(con);
 }
 
@@ -334,8 +348,14 @@ void tipc_topsrv_queue_evt(struct net *n
 	list_add_tail(&e->list, &con->outqueue);
 	spin_unlock_bh(&con->outqueue_lock);
 
-	if (queue_work(srv->send_wq, &con->swork))
-		return;
+	spin_lock_bh(&srv->idr_lock);
+	if (srv->listener) {
+		if (queue_work(srv->send_wq, &con->swork)) {
+			spin_unlock_bh(&srv->idr_lock);
+			return;
+		}
+	}
+	spin_unlock_bh(&srv->idr_lock);
 err:
 	conn_put(con);
 }
@@ -346,14 +366,20 @@ err:
  */
 static void tipc_conn_write_space(struct sock *sk)
 {
+	struct tipc_topsrv *srv;
 	struct tipc_conn *con;
 
 	read_lock_bh(&sk->sk_callback_lock);
 	con = sk->sk_user_data;
 	if (connected(con)) {
-		conn_get(con);
-		if (!queue_work(con->server->send_wq, &con->swork))
-			conn_put(con);
+		srv = con->server;
+		spin_lock_bh(&srv->idr_lock);
+		if (srv->listener) {
+			conn_get(con);
+			if (!queue_work(srv->send_wq, &con->swork))
+				conn_put(con);
+		}
+		spin_unlock_bh(&srv->idr_lock);
 	}
 	read_unlock_bh(&sk->sk_callback_lock);
 }
@@ -418,8 +444,17 @@ static int tipc_conn_rcv_from_sock(struc
 static void tipc_conn_recv_work(struct work_struct *work)
 {
 	struct tipc_conn *con = container_of(work, struct tipc_conn, rwork);
+	struct tipc_topsrv *srv;
 	int count = 0;
 
+	srv = con->server;
+	spin_lock_bh(&srv->idr_lock);
+	if (!srv->listener) {
+		spin_unlock_bh(&srv->idr_lock);
+		goto out;
+	}
+	spin_unlock_bh(&srv->idr_lock);
+
 	while (connected(con)) {
 		if (tipc_conn_rcv_from_sock(con))
 			break;
@@ -430,6 +465,7 @@ static void tipc_conn_recv_work(struct w
 			count = 0;
 		}
 	}
+out:
 	conn_put(con);
 }
 
@@ -438,6 +474,7 @@ static void tipc_conn_recv_work(struct w
  */
 static void tipc_conn_data_ready(struct sock *sk)
 {
+	struct tipc_topsrv *srv;
 	struct tipc_conn *con;
 
 	trace_sk_data_ready(sk);
@@ -445,9 +482,14 @@ static void tipc_conn_data_ready(struct
 	read_lock_bh(&sk->sk_callback_lock);
 	con = sk->sk_user_data;
 	if (connected(con)) {
-		conn_get(con);
-		if (!queue_work(con->server->rcv_wq, &con->rwork))
-			conn_put(con);
+		srv = con->server;
+		spin_lock_bh(&srv->idr_lock);
+		if (srv->listener) {
+			conn_get(con);
+			if (!queue_work(srv->rcv_wq, &con->rwork))
+				conn_put(con);
+		}
+		spin_unlock_bh(&srv->idr_lock);
 	}
 	read_unlock_bh(&sk->sk_callback_lock);
 }
@@ -503,8 +545,12 @@ static void tipc_topsrv_listener_data_re
 
 	read_lock_bh(&sk->sk_callback_lock);
 	srv = sk->sk_user_data;
-	if (srv)
-		queue_work(srv->rcv_wq, &srv->awork);
+	if (srv) {
+		spin_lock_bh(&srv->idr_lock);
+		if (srv->listener)
+			queue_work(srv->rcv_wq, &srv->awork);
+		spin_unlock_bh(&srv->idr_lock);
+	}
 	read_unlock_bh(&sk->sk_callback_lock);
 }
 
@@ -701,22 +747,26 @@ static void tipc_topsrv_stop(struct net
 	int id;
 
 	spin_lock_bh(&srv->idr_lock);
+	srv->listener = NULL;
+	spin_unlock_bh(&srv->idr_lock);
+	tipc_topsrv_work_stop(srv);
+
+	spin_lock_bh(&srv->idr_lock);
 	for (id = 0; srv->idr_in_use; id++) {
 		con = idr_find(&srv->conn_idr, id);
 		if (con) {
-			conn_get(con);
 			spin_unlock_bh(&srv->idr_lock);
 			tipc_conn_close(con);
-			conn_put(con);
 			spin_lock_bh(&srv->idr_lock);
+			continue;
 		}
+		spin_unlock_bh(&srv->idr_lock);
+		spin_lock_bh(&srv->idr_lock);
 	}
 	__module_get(lsock->ops->owner);
 	__module_get(lsock->sk->sk_prot_creator->owner);
-	srv->listener = NULL;
 	spin_unlock_bh(&srv->idr_lock);
 
-	tipc_topsrv_work_stop(srv);
 	sock_release(lsock);
 	idr_destroy(&srv->conn_idr);
 	kfree(srv);


