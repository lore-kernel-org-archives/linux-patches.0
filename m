Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36603B9D96;
	Sat, 17 Oct 2026 17:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257275; cv=none; b=b0oNG6qUiskiR7847GLu1LIjlNTea633NiROTNHUye/qonKoPeIPe5ZOE9N4VhqGxgf0Lok8cyewza+s1pSI49zsdJVZKsgSBfHHNgkE/vn8qm/PMvFJELn6yl/QDfa5TK0M97WT0selQfzjX7RX22DRlfqKQsk4vfd+ceMA7do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257275; c=relaxed/simple;
	bh=jDtUBSUe0DB0HnVGpo7SdbD+PHfj3y2WPc4zhljeF0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REqn6XA1Z7ZQgUBi2ROsu8M1ConOXbiTqTZBsqy/TlEnV00V/cZNPLNZGHeMf/e5YIZkG/XZsfwcMthR580FBZ6VQISiNwnmZ8IKGLwBjV9f6gBQrTNzhuSiZuWMs8kNozWkHyT4b1rlCbfXz3qgN6OiV3TkQ62WwMjOPcGBosw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ku32PmKd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ku32PmKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA081F000C4;
	Sat, 17 Oct 2026 17:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257273;
	bh=B3b17ux8Jb8+HkqjZoDn4Fmb+mJMFFDKego5HFnZMsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ku32PmKdmMHZ258aDMS0C019JsQue9aAEC6CdkuqYpc2v6A7bUWvdVmo5A2Aac5ud
	 C59owvP1YGYxQIYKDPyuyouvTmbwZ8pB2D7JRjtyVfRTmbsppPCGxYhMK0ufg/ag25
	 rm/d/HRE4tcPaW1KDN/IaKBk2KldBNTpIsSp+pkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Yuqi Xu <xuyuqiabc@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 0480/1674] tipc: destroy topsrv workqueues before closing connections
Date: Sat, 17 Oct 2026 17:45:52 +0200
Message-ID: <20261017160443.434511690@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
  * @net: network namspace instance
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


