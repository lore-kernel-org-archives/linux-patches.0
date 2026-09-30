Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C47D4D6C3F;
	Wed, 30 Sep 2026 16:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786505; cv=none; b=rCwTHfp+JJuO248YHOFii4FiKnfOaAbNq03bHVXiiADaD7drDsAE4ZS/3yFWTtnVjzw0AkpseDsZp/tYrV1uHx2BFrtBZGuI91zccH01+2TnfySj8A9MjDWiqK+V5R7abFEPOqiwGmiGhb01kdtWgIVjNA67QCbLXxF4srO5zEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786505; c=relaxed/simple;
	bh=cZTc04q6v+l4OjcoVgl+FAplRPWGnT5e928vnnEKaMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dk39CF0jrSac4lYvS66uW6Trug0qPMdX8ONrJCWQVHpDHU7/NNkYxfqtSiDys4XnmacqD1wDyFt7YBNrHO7FawRtA9CeClFfPSlaZxc4bz9jUuISKj/DSUl9FXJpphrOzB9pB5feIyzB6LIokY7hpzEtVc+chfaNSJ2IW8yk/jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ccl/CrQ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ccl/CrQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63281F000FF;
	Wed, 30 Sep 2026 16:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786503;
	bh=9EM1pt4FRv43QnD6WDLgLMtt64SKh2BYUfLJzLZJlPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ccl/CrQ8tksXnnqW3BlspZQJLbZDqIy4dOheIFd4jaS0ZqxizrexOpVxyihX9YdVm
	 Xdnz0LLskSlmkuqOy9H01bKbma+vWRtl3UcSWeBv6QjEt9sv75R2ybC9j+Wf7RzQvU
	 NR93Wafb3PwasHJk6DftHKBkXqTsdPb5dOZDH4mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 878/982] nfc: llcp: Fix race condition in accept_queue lifecycle
Date: Wed, 30 Sep 2026 17:26:54 +0200
Message-ID: <20260930152435.609783371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit c3eef2f988a3db9690369d7cef9a3344dd9788d3 ]

In nfc_llcp_socket_release(), sockets and listener accept queues are
walked under the local sockets rwlock and bh_lock_sock().  However,
bh_lock_sock() does not synchronise against process-context lock_sock()
held by nfc_llcp_accept_dequeue() during accept().  Because
socket_release() does not check sock_owned_by_user(), both paths can
concurrently unlink and release the same child socket, resulting in
use-after-free or a NULL pointer dereference of child->parent in
nfc_llcp_accept_unlink().

Fix this synchronisation race by having nfc_llcp_socket_release() use
process-context lock_sock() instead of bh_lock_sock():

1. Pop sockets from the local sockets list under the write lock using
   nfc_llcp_sock_list_pop() so lock_sock() can be acquired without
   holding the rwlock.

2. Because lock_sock() can sleep, defer the final release of the
   nfc_llcp_local structure to a workqueue (release_work).  This avoids
   a sleeping-in-atomic bug when the last local reference is dropped
   from softirq context.  Additionally, hold a single device reference
   on local from registration until final destruction.

3. In nfc_llcp_local_get(), use kref_get_unless_zero() to prevent
   resurrecting a local object whose teardown has been scheduled.

4. In llcp_sock_accept(), verify that the listener socket state is still
   LLCP_LISTEN after waking from schedule_timeout() to prevent hangs if
   the listener is closed concurrently.

5. When unlinking unaccepted child sockets during listener release,
   unlink them from local->sockets, call sock_orphan(), and drop their
   initial sk_alloc creation reference via sock_put().

6. Make nfc_llcp_accept_unlink() idempotent by guarding parent access with
   a NULL check.

Fixes: 50b78b2a6500 ("NFC: Fix sleeping in atomic when releasing socket")
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://patch.msgid.link/20260902123033.1169067-1-lee@kernel.org
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp.h      |   1 +
 net/nfc/llcp_core.c | 125 +++++++++++++++++++++++++++-----------------
 net/nfc/llcp_sock.c |  49 ++++++++++++-----
 3 files changed, 116 insertions(+), 59 deletions(-)

diff --git a/net/nfc/llcp.h b/net/nfc/llcp.h
index d8345ed57c954..23ae7a0112d37 100644
--- a/net/nfc/llcp.h
+++ b/net/nfc/llcp.h
@@ -91,6 +91,7 @@ struct nfc_llcp_local {
 	struct hlist_head pending_sdreqs;
 	struct timer_list sdreq_timer;
 	struct work_struct sdreq_timeout_work;
+	struct work_struct release_work;
 	u8 sdreq_next_tid;
 
 	/* sockets array */
diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index 9ae9b4fde311e..a4d7b2eaebd43 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -20,6 +20,8 @@ static LIST_HEAD(llcp_devices);
 /* Protects llcp_devices list */
 static DEFINE_SPINLOCK(llcp_devices_lock);
 
+static struct workqueue_struct *llcp_wq;
+
 static void nfc_llcp_rx_skb(struct nfc_llcp_local *local, struct sk_buff *skb);
 
 void nfc_llcp_sock_link(struct llcp_sock_list *l, struct sock *sk)
@@ -63,21 +65,33 @@ static void nfc_llcp_socket_purge(struct nfc_llcp_sock *sock)
 	}
 }
 
+static struct sock *nfc_llcp_sock_list_pop(struct llcp_sock_list *l)
+{
+	struct sock *sk;
+
+	write_lock(&l->lock);
+	sk = sk_head(&l->head);
+	if (sk) {
+		sock_hold(sk);
+		sk_del_node_init(sk);
+	}
+	write_unlock(&l->lock);
+
+	return sk;
+}
+
 static void nfc_llcp_socket_release(struct nfc_llcp_local *local, bool device,
 				    int err)
 {
 	struct sock *sk;
-	struct hlist_node *tmp;
 	struct nfc_llcp_sock *llcp_sock;
 
 	skb_queue_purge(&local->tx_queue);
 
-	write_lock(&local->sockets.lock);
-
-	sk_for_each_safe(sk, tmp, &local->sockets.head) {
+	while ((sk = nfc_llcp_sock_list_pop(&local->sockets))) {
 		llcp_sock = nfc_llcp_sock(sk);
 
-		bh_lock_sock(sk);
+		lock_sock(sk);
 
 		nfc_llcp_socket_purge(llcp_sock);
 
@@ -91,17 +105,27 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local, bool device,
 			list_for_each_entry_safe(lsk, n,
 						 &llcp_sock->accept_queue,
 						 accept_queue) {
-				accept_sk = &lsk->sk;
-				bh_lock_sock(accept_sk);
-
-				nfc_llcp_accept_unlink(accept_sk);
+				bool put_creation = false;
 
-				if (err)
-					accept_sk->sk_err = err;
-				accept_sk->sk_state = LLCP_CLOSED;
-				accept_sk->sk_state_change(sk);
+				accept_sk = &lsk->sk;
+				lock_sock_nested(accept_sk,
+						 SINGLE_DEPTH_NESTING);
+
+				if (nfc_llcp_sock(accept_sk)->parent == sk) {
+					nfc_llcp_accept_unlink(accept_sk);
+					nfc_llcp_sock_unlink(&local->sockets, accept_sk);
+
+					if (err)
+						accept_sk->sk_err = err;
+					accept_sk->sk_state = LLCP_CLOSED;
+					accept_sk->sk_state_change(accept_sk);
+					sock_orphan(accept_sk);
+					put_creation = true;
+				}
 
-				bh_unlock_sock(accept_sk);
+				release_sock(accept_sk);
+				if (put_creation)
+					sock_put(accept_sk); /* creation ref */
 			}
 		}
 
@@ -110,23 +134,18 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local, bool device,
 		sk->sk_state = LLCP_CLOSED;
 		sk->sk_state_change(sk);
 
-		bh_unlock_sock(sk);
-
-		sk_del_node_init(sk);
+		release_sock(sk);
+		sock_put(sk);
 	}
 
-	write_unlock(&local->sockets.lock);
-
 	/* If we still have a device, we keep the RAW sockets alive */
 	if (device == true)
 		return;
 
-	write_lock(&local->raw_sockets.lock);
-
-	sk_for_each_safe(sk, tmp, &local->raw_sockets.head) {
+	while ((sk = nfc_llcp_sock_list_pop(&local->raw_sockets))) {
 		llcp_sock = nfc_llcp_sock(sk);
 
-		bh_lock_sock(sk);
+		lock_sock(sk);
 
 		nfc_llcp_socket_purge(llcp_sock);
 
@@ -135,26 +154,20 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local, bool device,
 		sk->sk_state = LLCP_CLOSED;
 		sk->sk_state_change(sk);
 
-		bh_unlock_sock(sk);
-
-		sk_del_node_init(sk);
+		release_sock(sk);
+		sock_put(sk);
 	}
-
-	write_unlock(&local->raw_sockets.lock);
 }
 
 static struct nfc_llcp_local *nfc_llcp_local_get(struct nfc_llcp_local *local)
 {
-	/* Since using nfc_llcp_local may result in usage of nfc_dev, whenever
-	 * we hold a reference to local, we also need to hold a reference to
-	 * the device to avoid UAF.
-	 */
-	if (!nfc_get_device(local->dev->idx))
+	if (!local)
 		return NULL;
 
-	kref_get(&local->ref);
+	if (kref_get_unless_zero(&local->ref))
+		return local;
 
-	return local;
+	return NULL;
 }
 
 static void local_cleanup(struct nfc_llcp_local *local)
@@ -172,30 +185,34 @@ static void local_cleanup(struct nfc_llcp_local *local)
 	nfc_llcp_free_sdp_tlv_list(&local->pending_sdreqs);
 }
 
-static void local_release(struct kref *ref)
+static void local_release_work(struct work_struct *work)
 {
 	struct nfc_llcp_local *local;
+	struct nfc_dev *dev;
 
-	local = container_of(ref, struct nfc_llcp_local, ref);
+	local = container_of(work, struct nfc_llcp_local, release_work);
+	dev = local->dev;
 
 	local_cleanup(local);
 	kfree(local);
+	nfc_put_device(dev);
 }
 
-int nfc_llcp_local_put(struct nfc_llcp_local *local)
+static void local_release(struct kref *ref)
 {
-	struct nfc_dev *dev;
-	int ret;
+	struct nfc_llcp_local *local;
 
-	if (local == NULL)
-		return 0;
+	local = container_of(ref, struct nfc_llcp_local, ref);
 
-	dev = local->dev;
+	queue_work(llcp_wq, &local->release_work);
+}
 
-	ret = kref_put(&local->ref, local_release);
-	nfc_put_device(dev);
+int nfc_llcp_local_put(struct nfc_llcp_local *local)
+{
+	if (!local)
+		return 0;
 
-	return ret;
+	return kref_put(&local->ref, local_release);
 }
 
 static struct nfc_llcp_sock *nfc_llcp_sock_get(struct nfc_llcp_local *local,
@@ -1703,6 +1720,7 @@ int nfc_llcp_register_device(struct nfc_dev *ndev)
 	INIT_WORK(&local->rx_work, nfc_llcp_rx_work);
 
 	INIT_WORK(&local->timeout_work, nfc_llcp_timeout_work);
+	INIT_WORK(&local->release_work, local_release_work);
 
 	rwlock_init(&local->sockets.lock);
 	rwlock_init(&local->connecting_sockets.lock);
@@ -1746,10 +1764,23 @@ void nfc_llcp_unregister_device(struct nfc_dev *dev)
 
 int __init nfc_llcp_init(void)
 {
-	return nfc_llcp_sock_init();
+	int ret;
+
+	llcp_wq = alloc_workqueue("nfc_llcp_wq", WQ_UNBOUND, 0);
+	if (!llcp_wq)
+		return -ENOMEM;
+
+	ret = nfc_llcp_sock_init();
+	if (ret) {
+		destroy_workqueue(llcp_wq);
+		return ret;
+	}
+
+	return 0;
 }
 
 void nfc_llcp_exit(void)
 {
 	nfc_llcp_sock_exit();
+	destroy_workqueue(llcp_wq);
 }
diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 0cb1688bcbba7..8764b6d82a97d 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -392,11 +392,12 @@ void nfc_llcp_accept_unlink(struct sock *sk)
 
 	pr_debug("state %d\n", sk->sk_state);
 
-	list_del_init(&llcp_sock->accept_queue);
-	sk_acceptq_removed(llcp_sock->parent);
-	llcp_sock->parent = NULL;
-
-	sock_put(sk);
+	if (llcp_sock->parent) {
+		list_del_init(&llcp_sock->accept_queue);
+		sk_acceptq_removed(llcp_sock->parent);
+		llcp_sock->parent = NULL;
+		sock_put(sk);
+	}
 }
 
 void nfc_llcp_accept_enqueue(struct sock *parent, struct sock *sk)
@@ -423,12 +424,20 @@ struct sock *nfc_llcp_accept_dequeue(struct sock *parent,
 
 	list_for_each_entry_safe(lsk, n, &llcp_parent->accept_queue,
 				 accept_queue) {
+		struct nfc_llcp_local *local;
+
 		sk = &lsk->sk;
-		lock_sock(sk);
+		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 
 		if (sk->sk_state == LLCP_CLOSED) {
-			release_sock(sk);
+			local = nfc_llcp_sock(sk)->local;
+
 			nfc_llcp_accept_unlink(sk);
+			if (local)
+				nfc_llcp_sock_unlink(&local->sockets, sk);
+			sock_orphan(sk);
+			release_sock(sk);
+			sock_put(sk);
 			continue;
 		}
 
@@ -464,7 +473,7 @@ static int llcp_sock_accept(struct socket *sock, struct socket *newsock,
 
 	pr_debug("parent %p\n", sk);
 
-	lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
+	lock_sock(sk);
 
 	if (sk->sk_state != LLCP_LISTEN) {
 		ret = -EBADFD;
@@ -490,7 +499,12 @@ static int llcp_sock_accept(struct socket *sock, struct socket *newsock,
 
 		release_sock(sk);
 		timeo = schedule_timeout(timeo);
-		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
+		lock_sock(sk);
+
+		if (sk->sk_state != LLCP_LISTEN) {
+			ret = -EBADFD;
+			break;
+		}
 	}
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(sk_sleep(sk), &wait);
@@ -629,13 +643,24 @@ static int llcp_sock_release(struct socket *sock)
 
 		list_for_each_entry_safe(lsk, n, &llcp_sock->accept_queue,
 					 accept_queue) {
+			bool put_creation = false;
+
 			accept_sk = &lsk->sk;
-			lock_sock(accept_sk);
+			lock_sock_nested(accept_sk, SINGLE_DEPTH_NESTING);
 
-			nfc_llcp_send_disconnect(lsk);
-			nfc_llcp_accept_unlink(accept_sk);
+			if (nfc_llcp_sock(accept_sk)->parent == sk) {
+				nfc_llcp_send_disconnect(lsk);
+				nfc_llcp_accept_unlink(accept_sk);
+				nfc_llcp_sock_unlink(&local->sockets, accept_sk);
+
+				accept_sk->sk_state = LLCP_CLOSED;
+				sock_orphan(accept_sk);
+				put_creation = true;
+			}
 
 			release_sock(accept_sk);
+			if (put_creation)
+				sock_put(accept_sk); /* creation ref */
 		}
 	}
 
-- 
2.53.0



