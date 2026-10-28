Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209017;
	b=nHPSav9hzyWERVlCnghtieHg8HFXDqF0vthXgdHt7m9VhookhbhypDHbeuoe6gttnsSA
	 cIkhqDSu04KA4AHad9DjDUakCBXMMMYgcQCPd16rVh16qZY8d7nJxu1CzLnHaJMo22fFn
	 m5vMSs2AP7MMdZORuKyFiJkScbMjHwVQYLa/sbEju1UkYt8cpti9pAYhT1sw0Iub4aW/K
	 SQ2u61TmpyJuCtnueCZupmI8qSKMx8erGg12bAII3zCOT1DVhC8HN6P+tnK2lzuzuGv/r
	 BjId51mKMg5ZsD6rXhHkf2IOJZOkgUdOFlAHdRgrlsTTULJKJXmSic6puvNmFvifyfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VzgKo+GV9WX7C4jxuSPaRdVv6VzNu3Y/6TenS6RSMb0=;
	b=TgNav066WMSvZhTWvbGlBb4auYbQ+Hn+YIrMiymtksfcfnEOB95cb7G/rwRVzgSHqPJq
	 +Vx8NV8G6NdVR4UTitcSFw3qcprwgW/l9fuKaN3RhgAWUey1KRCbmtQg6YQIl01+dAnOF
	 /C98NDrLZyJNLQ6Ly1CW4QdTPsrs6v1jEmoNqOussTlyV24B3Y3ela/aLCOO5b3yynYBm
	 cImk8cNpfWL7Jm6jJ/wf4/BWKtv5pjWka4Kr8YdzdiEvv8VGwmKKxdF3bpon7WYpqYtja
	 lz+DjPqEClGTjenJNVPhIXJBwoupzZVbK2fFw9BkjUoe8R+kADTZElg0W+ZoixU+4CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c9sSZId3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14D5606A31A;
	Wed, 28 Oct 2026 17:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c9sSZId3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114101F01825;
	Wed, 28 Oct 2026 17:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209016;
	bh=VzgKo+GV9WX7C4jxuSPaRdVv6VzNu3Y/6TenS6RSMb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c9sSZId3EKuUVbmROyZY46zZdzsp6CYoTuUZAsg2N6zxzukr6AkL+C5Sl/XGGwJEw
	 +ExgsY2KNXJ6aYEaAk+mDmzMbimoPLpERxxoGQ7BxJ9O3x0xIgbo+HjgPl8k9w//cw
	 tcabY3JPyA4+DCbpSArxsSuOmRmvvP56Ol9m2WMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Yuqi Xu <xuyuqiabc@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 321/516] tipc: destroy topsrv workqueues before closing connections
Date: Wed, 28 Oct 2026 17:57:53 +0100
Message-ID: <20261028170011.093793165@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -54,7 +54,7 @@
 /**
  * struct tipc_topsrv - TIPC server structure
  * @conn_idr: identifier set of connection
- * @idr_lock: protect the connection identifier set
+ * @idr_lock: protect the connection identifier set and listener
  * @idr_in_use: amount of allocated identifier entry
  * @net: network namspace instance
  * @awork: accept work item
@@ -217,6 +217,10 @@ static struct tipc_conn *tipc_conn_looku
 	struct tipc_conn *con;
 
 	spin_lock_bh(&s->idr_lock);
+	if (!s->listener) {
+		spin_unlock_bh(&s->idr_lock);
+		return NULL;
+	}
 	con = idr_find(&s->conn_idr, conid);
 	if (!connected(con) || !kref_get_unless_zero(&con->kref))
 		con = NULL;
@@ -300,10 +304,20 @@ static void tipc_conn_send_to_sock(struc
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
 
@@ -333,8 +347,14 @@ void tipc_topsrv_queue_evt(struct net *n
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
@@ -345,14 +365,20 @@ err:
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
@@ -417,8 +443,17 @@ static int tipc_conn_rcv_from_sock(struc
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
@@ -429,6 +464,7 @@ static void tipc_conn_recv_work(struct w
 			count = 0;
 		}
 	}
+out:
 	conn_put(con);
 }
 
@@ -437,14 +473,20 @@ static void tipc_conn_recv_work(struct w
  */
 static void tipc_conn_data_ready(struct sock *sk)
 {
+	struct tipc_topsrv *srv;
 	struct tipc_conn *con;
 
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
@@ -498,8 +540,12 @@ static void tipc_topsrv_listener_data_re
 
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
 
@@ -696,22 +742,26 @@ static void tipc_topsrv_stop(struct net
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


