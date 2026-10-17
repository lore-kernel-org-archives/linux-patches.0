Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46C138AC99;
	Sat, 17 Oct 2026 17:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257746; cv=none; b=WnJbEa3sRlPL95PDBv9JXxdT0FQGr6KWNHO9CSTXbl0Qrdw4k9gjS7V14PGChlgBEG6azHdWFAMnQCAE/aOs15GTa9T69Az9iLV3M6b1Fbd3e3aAirqD+xl/mYGm1/0HxDrdfGD0xkyMEHcrUyxO0ConAWVB1i9oDiZ1Yj82vq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257746; c=relaxed/simple;
	bh=bj1jVr7XM+t9836Ml/leVY2R9Ww+ta/0/alJ/v3ZGNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmWee6j+5/xl7MMvPH0geI8806+CzLJzNCj1Mc5ZO04qElf+VxhjGm7aBlEYZ3spv6JgjAkks9G2U7qwyvoR5I4VEu7gQw5wHrjKOMp+eOyahCf9lEcg6Ya87WhbC77UeNt5U0AtanfRXduDuH6euLDnTDNFh05H4HEZ0L6FCl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqyoJ0tU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqyoJ0tU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFBE1F000C4;
	Sat, 17 Oct 2026 17:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257745;
	bh=9O+nSSJ3peqQ5TBEcnQZjACf9Qb2NHNHFivE7qoybBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BqyoJ0tUP3ClgfoRyTUs1KMvCT3lTly5YGCfqFFqA05VLnHKa/z//1FFUJmqctyux
	 UBL0QHazyuFraD3mtIgtpm6ov5mTI8byQbTTVQ15nO4PRdFfx5EgwJfNW0YOD5DbbB
	 UlhAwTGhF96ZtJ2SkbcsLet9KHiGZ0iJ0RAyyba8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0655/1674] afs: Fix lock recursion
Date: Sat, 17 Oct 2026 17:48:47 +0200
Message-ID: <20261017160447.924668431@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 610a79ffea02102899a1373fe226d949944a7ed6 ]

afs_wake_up_async_call() can incur lock recursion.  The problem is that it
is called from AF_RXRPC whilst holding the ->notify_lock, but it tries to
take a ref on the afs_call struct in order to pass it to a work queue - but
if the afs_call is already queued, we then have an extraneous ref that must
be put... calling afs_put_call() may call back down into AF_RXRPC through
rxrpc_kernel_shutdown_call(), however, which might try taking the
->notify_lock again.

This case isn't very common, however, so defer it to a workqueue.  The oops
looks something like:

  BUG: spinlock recursion on CPU#0, krxrpcio/7001/1646
   lock: 0xffff888141399b30, .magic: dead4ead, .owner: krxrpcio/7001/1646, .owner_cpu: 0
  CPU: 0 UID: 0 PID: 1646 Comm: krxrpcio/7001 Not tainted 6.12.0-rc2-build3+ #4351
  Hardware name: ASUS All Series/H97-PLUS, BIOS 2306 10/09/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x47/0x70
   do_raw_spin_lock+0x3c/0x90
   rxrpc_kernel_shutdown_call+0x83/0xb0
   afs_put_call+0xd7/0x180
   rxrpc_notify_socket+0xa0/0x190
   rxrpc_input_split_jumbo+0x198/0x1d0
   rxrpc_input_data+0x14b/0x1e0
   ? rxrpc_input_call_packet+0xc2/0x1f0
   rxrpc_input_call_event+0xad/0x6b0
   rxrpc_input_packet_on_conn+0x1e1/0x210
   rxrpc_input_packet+0x3f2/0x4d0
   rxrpc_io_thread+0x243/0x410
   ? __pfx_rxrpc_io_thread+0x10/0x10
   kthread+0xcf/0xe0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x24/0x40
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>

Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/1394602.1729162732@warthog.procyon.org.uk
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/internal.h |  2 ++
 fs/afs/rxrpc.c    | 81 +++++++++++++++++++++++++++++++++--------------
 2 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index d1287cc3d9381..85059a453b6a6 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -102,6 +102,7 @@ struct afs_call {
 	wait_queue_head_t	waitq;		/* processes awaiting completion */
 	struct work_struct	async_work;	/* async I/O processor */
 	struct work_struct	work;		/* actual work processor */
+	struct work_struct	free_work;	/* Deferred free processor */
 	struct rxrpc_call	*rxcall;	/* RxRPC call handle */
 	struct key		*key;		/* security for this call */
 	struct afs_net		*net;		/* The network namespace */
@@ -1282,6 +1283,7 @@ extern int __net_init afs_open_socket(struct afs_net *);
 extern void __net_exit afs_close_socket(struct afs_net *);
 extern void afs_charge_preallocation(struct work_struct *);
 extern void afs_put_call(struct afs_call *);
+void afs_deferred_put_call(struct afs_call *call);
 extern void afs_make_call(struct afs_addr_cursor *, struct afs_call *, gfp_t);
 extern long afs_wait_for_call_to_complete(struct afs_call *, struct afs_addr_cursor *);
 extern struct afs_call *afs_alloc_flat_call(struct afs_net *,
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 3aa0d26864206..523272b86ad46 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -18,6 +18,7 @@
 
 struct workqueue_struct *afs_async_calls;
 
+static void afs_deferred_free_worker(struct work_struct *work);
 static void afs_wake_up_call_waiter(struct sock *, struct rxrpc_call *, unsigned long);
 static void afs_wake_up_async_call(struct sock *, struct rxrpc_call *, unsigned long);
 static void afs_process_async_call(struct work_struct *);
@@ -161,6 +162,7 @@ static struct afs_call *afs_alloc_call(struct afs_net *net,
 	call->debug_id = atomic_inc_return(&rxrpc_debug_id);
 	refcount_set(&call->ref, 1);
 	INIT_WORK(&call->async_work, afs_process_async_call);
+	INIT_WORK(&call->free_work, afs_deferred_free_worker);
 	init_waitqueue_head(&call->waitq);
 	spin_lock_init(&call->state_lock);
 	call->iter = &call->def_iter;
@@ -171,6 +173,35 @@ static struct afs_call *afs_alloc_call(struct afs_net *net,
 	return call;
 }
 
+static void afs_free_call(struct afs_call *call)
+{
+	struct afs_net *net = call->net;
+	int o;
+
+	ASSERT(!work_pending(&call->async_work));
+
+	if (call->rxcall) {
+		rxrpc_kernel_shutdown_call(net->socket, call->rxcall);
+		rxrpc_kernel_put_call(net->socket, call->rxcall);
+		call->rxcall = NULL;
+	}
+	if (call->type->destructor)
+		call->type->destructor(call);
+
+	afs_unuse_server_notime(call->net, call->server, afs_server_trace_put_call);
+	afs_put_addrlist(call->alist);
+	kfree(call->request);
+
+	o = atomic_read(&net->nr_outstanding_calls);
+	trace_afs_call(call->debug_id, afs_call_trace_free, 0, o,
+		       __builtin_return_address(0));
+	kfree(call);
+
+	o = atomic_dec_return(&net->nr_outstanding_calls);
+	if (o == 0)
+		wake_up_var(&net->nr_outstanding_calls);
+}
+
 /*
  * Dispose of a reference on a call.
  */
@@ -185,31 +216,34 @@ void afs_put_call(struct afs_call *call)
 	o = atomic_read(&net->nr_outstanding_calls);
 	trace_afs_call(debug_id, afs_call_trace_put, r - 1, o,
 		       __builtin_return_address(0));
+	if (zero)
+		afs_free_call(call);
+}
 
-	if (zero) {
-		ASSERT(!work_pending(&call->async_work));
-		ASSERT(call->type->name != NULL);
-
-		if (call->rxcall) {
-			rxrpc_kernel_shutdown_call(net->socket, call->rxcall);
-			rxrpc_kernel_put_call(net->socket, call->rxcall);
-			call->rxcall = NULL;
-		}
-		if (call->type->destructor)
-			call->type->destructor(call);
+static void afs_deferred_free_worker(struct work_struct *work)
+{
+	struct afs_call *call = container_of(work, struct afs_call, free_work);
 
-		afs_unuse_server_notime(call->net, call->server, afs_server_trace_put_call);
-		afs_put_addrlist(call->alist);
-		kfree(call->request);
+	afs_free_call(call);
+}
 
-		trace_afs_call(call->debug_id, afs_call_trace_free, 0, o,
-			       __builtin_return_address(0));
-		kfree(call);
+/*
+ * Dispose of a reference on a call, deferring the cleanup to a workqueue
+ * to avoid lock recursion.
+ */
+void afs_deferred_put_call(struct afs_call *call)
+{
+	struct afs_net *net = call->net;
+	unsigned int debug_id = call->debug_id;
+	bool zero;
+	int r, o;
 
-		o = atomic_dec_return(&net->nr_outstanding_calls);
-		if (o == 0)
-			wake_up_var(&net->nr_outstanding_calls);
-	}
+	zero = __refcount_dec_and_test(&call->ref, &r);
+	o = atomic_read(&net->nr_outstanding_calls);
+	trace_afs_call(debug_id, afs_call_trace_put, r - 1, o,
+		       __builtin_return_address(0));
+	if (zero)
+		schedule_work(&call->free_work);
 }
 
 static struct afs_call *afs_get_call(struct afs_call *call,
@@ -683,7 +717,8 @@ static void afs_wake_up_call_waiter(struct sock *sk, struct rxrpc_call *rxcall,
 }
 
 /*
- * wake up an asynchronous call
+ * Wake up an asynchronous call.  The caller is holding the call notify
+ * spinlock around this, so we can't call afs_put_call().
  */
 static void afs_wake_up_async_call(struct sock *sk, struct rxrpc_call *rxcall,
 				   unsigned long call_user_ID)
@@ -700,7 +735,7 @@ static void afs_wake_up_async_call(struct sock *sk, struct rxrpc_call *rxcall,
 			       __builtin_return_address(0));
 
 		if (!queue_work(afs_async_calls, &call->async_work))
-			afs_put_call(call);
+			afs_deferred_put_call(call);
 	}
 }
 
-- 
2.53.0



