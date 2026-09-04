Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53422264A3;
	Fri,  4 Sep 2026 05:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500585; cv=none; b=ujE+YZvzAfDidUGbFVAVDvXSjjwULvI4e/h2dlpXizaSiz+fa1nUu/4lGX10Eku9FY6KymdT4en+YOwNqjEUEzid5eztnORs4MW5S7CwMVkZX8gEIGs4URdGFMw3gdEVmjEcffj8Z4TyULAKnBXubk2AWwhVv69YCxI34QOyxfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500585; c=relaxed/simple;
	bh=cFYT5cWB8b0yqX+r8WdAVqagBorOdSm9g6VukddHBNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ewIwrxOy+9upyTaW3ZLuNh44wtLARfUxMNtevGbHD2tE45HChXqC2C5fsSCS/ZOb/bZZ2wZWsB4YKWy8H9fNCzqRwJu809I/jvcjUzALVstv+FboPA1Fa/F2w+/GPQ2BEzFh/Tx2ZtffNPZmACzeB5WT7GOAVyuZh+hcASv39Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ue/E+WeA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ue/E+WeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3461F00A3D;
	Fri,  4 Sep 2026 05:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500583;
	bh=c94vPcT5qRbjicEMQ9lxxrRWC9P5iKuJ6xYa1/ZcHBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ue/E+WeAf+Z/5+p130LHROSlCsphkrtASfKigKgn0ooM8FE+dDiU/S4w4X2RLRHA9
	 5I0frw6y0WSbbzIiHcTSUWNzNzeHfqwFrPUAmqaFYkkL/6DzSNtSoZ52SWSK3DbhBZ
	 T5XyzvXcc5b4NLAwqKFEjHrVzlF6r7QSsz0mV8tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 107/552] nfsd: RCU-protect cl_cb_session to fix use-after-free on session teardown
Date: Fri,  4 Sep 2026 06:54:24 +0200
Message-ID: <20260904045750.333255076@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 01c5d5f58a5db9b0ee5afba2e49d3157788687b2 upstream.

After a DESTROY_SESSION the per-session teardown path can free a
session while rpciod still holds an inflight callback rpc_task that
dereferences clp->cl_cb_session.  nfsd4_probe_callback_sync() flushes
cl_callback_wq, but once nfsd4_run_cb_work() has called
rpc_call_async() the rpc_task lives on rpciod; flushing the workqueue
does not wait for it.  rpc_shutdown_client() does drain rpciod tasks,
but uses a 1-second wait_event_timeout — tasks stuck in rpc_delay()
(e.g. 2-second NFS4ERR_DELAY retries) can outlive the drain.

    destroy path                       rpciod
    ------------                       ------
    unhash_session(ses)
    nfsd4_probe_callback_sync(clp)
      flush_workqueue(cl_callback_wq)
      /* returns; rpc_task still live */
    nfsd4_put_session_locked(ses)
    free_session(ses) -> kfree(ses)
                                       nfsd4_cb_sequence_done()
                                         reads cb_clp->cl_cb_session
                                         /* freed slab */

A second window exists in nfsd4_process_cb_update().  When
__nfsd4_find_backchannel() returns NULL because unhash_session() has
already removed the destroyed session from cl_sessions,
setup_callback_client() takes the v4.1 early return so
clp->cl_cb_session = ses never fires and the field retains a pointer
to the about-to-be-freed session.

Fix both by converting cl_cb_session to an RCU-protected pointer:

  - Move the cl_cb_session = ses assignment in setup_callback_client()
    to after rpc_create() succeeds, so it is only published when a
    working backchannel exists.  Clear cl_cb_session on the error
    return in nfsd4_process_cb_update().  Both stores use
    rcu_assign_pointer().

  - Annotate cl_cb_session with __rcu.  All rpciod-side readers use
    rcu_read_lock()/rcu_dereference() and check for NULL, bailing to
    the appropriate error or requeue path:
    encode_cb_sequence4args(), decode_cb_sequence4resok(),
    nfsd41_cb_get_slot(), nfsd41_cb_release_slot(),
    nfsd4_cb_prepare(), and nfsd4_cb_sequence_done().

  - Switch __free_session() from kfree() to kfree_rcu() so the
    session slab is not reclaimed until after an RCU grace period,
    guaranteeing that rpciod readers inside rcu_read_lock() never
    dereference freed memory.

  - Pass the session pointer to the nfsd_cb_seq_status and
    nfsd_cb_free_slot tracepoints instead of having them re-read
    cl_cb_session.

  - nfsd4_cb_prepare() calls rpc_exit() when the session is NULL,
    routing through the done/release path to requeue the callback.

Fixes: dcbeaa68dbbd ("nfsd4: allow backchannel recovery")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Chris Mason <clm@meta.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260530-nfsd-fixes-v2-2-f27e8eb4d974@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4callback.c |  109 ++++++++++++++++++++++++++++++++++++++++---------
 fs/nfsd/nfs4state.c    |    4 -
 fs/nfsd/state.h        |    3 -
 fs/nfsd/trace.h        |   14 ++----
 4 files changed, 100 insertions(+), 30 deletions(-)

--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -456,13 +456,20 @@ static void encode_cb_sequence4args(stru
 				    const struct nfsd4_callback *cb,
 				    struct nfs4_cb_compound_hdr *hdr)
 {
-	struct nfsd4_session *session = cb->cb_clp->cl_cb_session;
+	struct nfsd4_session *session;
 	struct nfsd4_referring_call_list *rcl;
 	__be32 *p;
 
 	if (hdr->minorversion == 0)
 		return;
 
+	rcu_read_lock();
+	session = rcu_dereference(cb->cb_clp->cl_cb_session);
+	if (!session) {
+		rcu_read_unlock();
+		return;
+	}
+
 	encode_nfs_cb_opnum4(xdr, OP_CB_SEQUENCE);
 	encode_sessionid4(xdr, session);
 
@@ -478,6 +485,7 @@ static void encode_cb_sequence4args(stru
 		encode_referring_call_list4(xdr, rcl);
 
 	hdr->nops++;
+	rcu_read_unlock();
 }
 
 static void update_cb_slot_table(struct nfsd4_session *ses, u32 target)
@@ -529,21 +537,32 @@ static void update_cb_slot_table(struct
 static int decode_cb_sequence4resok(struct xdr_stream *xdr,
 				    struct nfsd4_callback *cb)
 {
-	struct nfsd4_session *session = cb->cb_clp->cl_cb_session;
+	struct nfsd4_session *session;
 	int status = -ESERVERFAULT;
 	__be32 *p;
 	u32 seqid, slotid, target;
 
+	rcu_read_lock();
+	session = rcu_dereference(cb->cb_clp->cl_cb_session);
+	if (!session) {
+		rcu_read_unlock();
+		cb->cb_seq_status = -NFS4ERR_BADSESSION;
+		return -NFS4ERR_BADSESSION;
+	}
+
 	/*
 	 * If the server returns different values for sessionID, slotID or
 	 * sequence number, the server is looney tunes.
 	 */
 	p = xdr_inline_decode(xdr, NFS4_MAX_SESSIONID_LEN + 4 + 4 + 4 + 4);
-	if (unlikely(p == NULL))
+	if (unlikely(p == NULL)) {
+		rcu_read_unlock();
 		goto out_overflow;
+	}
 
 	if (memcmp(p, session->se_sessionid.data, NFS4_MAX_SESSIONID_LEN)) {
 		dprintk("NFS: %s Invalid session id\n", __func__);
+		rcu_read_unlock();
 		goto out;
 	}
 	p += XDR_QUADLEN(NFS4_MAX_SESSIONID_LEN);
@@ -551,12 +570,14 @@ static int decode_cb_sequence4resok(stru
 	seqid = be32_to_cpup(p++);
 	if (seqid != session->se_cb_seq_nr[cb->cb_held_slot]) {
 		dprintk("NFS: %s Invalid sequence number\n", __func__);
+		rcu_read_unlock();
 		goto out;
 	}
 
 	slotid = be32_to_cpup(p++);
 	if (slotid != cb->cb_held_slot) {
 		dprintk("NFS: %s Invalid slotid\n", __func__);
+		rcu_read_unlock();
 		goto out;
 	}
 
@@ -564,6 +585,7 @@ static int decode_cb_sequence4resok(stru
 
 	target = be32_to_cpup(p++);
 	update_cb_slot_table(session, target);
+	rcu_read_unlock();
 	status = 0;
 out:
 	cb->cb_seq_status = status;
@@ -1174,9 +1196,8 @@ static int setup_callback_client(struct
 	} else {
 		if (!conn->cb_xprt || !ses)
 			return -EINVAL;
-		clp->cl_cb_session = ses;
 		args.bc_xprt = conn->cb_xprt;
-		args.prognumber = clp->cl_cb_session->se_cb_prog;
+		args.prognumber = ses->se_cb_prog;
 		args.protocol = conn->cb_xprt->xpt_class->xcl_ident |
 				XPRT_TRANSPORT_BC;
 		args.authflavor = ses->se_cb_sec.flavor;
@@ -1194,8 +1215,10 @@ static int setup_callback_client(struct
 		return -ENOMEM;
 	}
 
-	if (clp->cl_minorversion != 0)
+	if (clp->cl_minorversion != 0) {
 		clp->cl_cb_conn.cb_xprt = conn->cb_xprt;
+		rcu_assign_pointer(clp->cl_cb_session, ses);
+	}
 	clp->cl_cb_client = client;
 	clp->cl_cb_cred = cred;
 	rcu_read_lock();
@@ -1302,18 +1325,33 @@ static int grab_slot(struct nfsd4_sessio
 static bool nfsd41_cb_get_slot(struct nfsd4_callback *cb, struct rpc_task *task)
 {
 	struct nfs4_client *clp = cb->cb_clp;
-	struct nfsd4_session *ses = clp->cl_cb_session;
+	struct nfsd4_session *ses;
 
 	if (cb->cb_held_slot >= 0)
 		return true;
+
+	rcu_read_lock();
+	ses = rcu_dereference(clp->cl_cb_session);
+	if (!ses) {
+		rcu_read_unlock();
+		rpc_sleep_on(&clp->cl_cb_waitq, task, NULL);
+		return false;
+	}
 	cb->cb_held_slot = grab_slot(ses);
 	if (cb->cb_held_slot < 0) {
+		rcu_read_unlock();
 		rpc_sleep_on(&clp->cl_cb_waitq, task, NULL);
 		/* Race breaker */
-		cb->cb_held_slot = grab_slot(ses);
+		rcu_read_lock();
+		ses = rcu_dereference(clp->cl_cb_session);
+		if (ses)
+			cb->cb_held_slot = grab_slot(ses);
+		rcu_read_unlock();
 		if (cb->cb_held_slot < 0)
 			return false;
 		rpc_wake_up_queued_task(&clp->cl_cb_waitq, task);
+	} else {
+		rcu_read_unlock();
 	}
 	return true;
 }
@@ -1321,12 +1359,17 @@ static bool nfsd41_cb_get_slot(struct nf
 static void nfsd41_cb_release_slot(struct nfsd4_callback *cb)
 {
 	struct nfs4_client *clp = cb->cb_clp;
-	struct nfsd4_session *ses = clp->cl_cb_session;
+	struct nfsd4_session *ses;
 
 	if (cb->cb_held_slot >= 0) {
-		spin_lock(&ses->se_lock);
-		ses->se_cb_slot_avail |= BIT(cb->cb_held_slot);
-		spin_unlock(&ses->se_lock);
+		rcu_read_lock();
+		ses = rcu_dereference(clp->cl_cb_session);
+		if (ses) {
+			spin_lock(&ses->se_lock);
+			ses->se_cb_slot_avail |= BIT(cb->cb_held_slot);
+			spin_unlock(&ses->se_lock);
+		}
+		rcu_read_unlock();
 		cb->cb_held_slot = -1;
 		rpc_wake_up_next(&clp->cl_cb_waitq);
 	}
@@ -1458,22 +1501,35 @@ static void nfsd4_cb_prepare(struct rpc_
 	trace_nfsd_cb_rpc_prepare(clp);
 	cb->cb_seq_status = 1;
 	cb->cb_status = 0;
-	if (minorversion && !nfsd41_cb_get_slot(cb, task))
-		return;
+	if (minorversion) {
+		if (!rcu_access_pointer(clp->cl_cb_session)) {
+			rpc_exit(task, -EIO);
+			return;
+		}
+		if (!nfsd41_cb_get_slot(cb, task))
+			return;
+	}
 	rpc_call_start(task);
 }
 
 /* Returns true if CB_COMPOUND processing should continue */
 static bool nfsd4_cb_sequence_done(struct rpc_task *task, struct nfsd4_callback *cb)
 {
-	struct nfsd4_session *session = cb->cb_clp->cl_cb_session;
+	struct nfsd4_session *session;
 	bool ret = false;
 
 	if (cb->cb_held_slot < 0)
 		goto requeue;
 
+	rcu_read_lock();
+	session = rcu_dereference(cb->cb_clp->cl_cb_session);
+	if (!session) {
+		rcu_read_unlock();
+		goto requeue;
+	}
+
 	/* This is the operation status code for CB_SEQUENCE */
-	trace_nfsd_cb_seq_status(task, cb);
+	trace_nfsd_cb_seq_status(task, cb, session);
 	switch (cb->cb_seq_status) {
 	case 0:
 		/*
@@ -1505,12 +1561,16 @@ static bool nfsd4_cb_sequence_done(struc
 		fallthrough;
 	case -NFS4ERR_BADSESSION:
 		nfsd4_mark_cb_fault(cb->cb_clp);
+		rcu_read_unlock();
 		goto requeue;
 	case -NFS4ERR_DELAY:
 		cb->cb_seq_status = 1;
-		if (RPC_SIGNALLED(task) || !rpc_restart_call(task))
+		if (RPC_SIGNALLED(task) || !rpc_restart_call(task)) {
+			rcu_read_unlock();
 			goto requeue;
+		}
 		rpc_delay(task, 2 * HZ);
+		rcu_read_unlock();
 		return false;
 	case -NFS4ERR_SEQ_MISORDERED:
 	case -NFS4ERR_BADSLOT:
@@ -1522,11 +1582,13 @@ static bool nfsd4_cb_sequence_done(struc
 		 */
 		nfsd4_mark_cb_fault(cb->cb_clp);
 		cb->cb_held_slot = -1;
+		rcu_read_unlock();
 		goto retry_nowait;
 	default:
 		nfsd4_mark_cb_fault(cb->cb_clp);
 	}
-	trace_nfsd_cb_free_slot(task, cb);
+	trace_nfsd_cb_free_slot(task, cb, session);
+	rcu_read_unlock();
 	nfsd41_cb_release_slot(cb);
 	return ret;
 retry_nowait:
@@ -1648,7 +1710,15 @@ static struct nfsd4_conn * __nfsd4_find_
  * Note there isn't a lot of locking in this code; instead we depend on
  * the fact that it is run from clp->cl_callback_wq, which won't run two
  * work items at once.  So, for example, clp->cl_callback_wq handles all
- * access of cl_cb_client and all calls to rpc_create or rpc_shutdown_client.
+ * access of cl_cb_client, and all calls to rpc_create or
+ * rpc_shutdown_client.
+ *
+ * cl_cb_session is written only from cl_callback_wq (via
+ * rcu_assign_pointer) and read from rpciod under rcu_read_lock (via
+ * rcu_dereference) by encode_cb_sequence4args(), decode_cb_sequence4resok(),
+ * nfsd4_cb_sequence_done(), and the cb-slot helpers.  Sessions are freed
+ * with kfree_rcu() so that rpciod readers in an RCU read-side critical
+ * section never dereference a freed session.
  */
 static void nfsd4_process_cb_update(struct nfsd4_callback *cb)
 {
@@ -1700,6 +1770,7 @@ static void nfsd4_process_cb_update(stru
 		nfsd4_mark_cb_down(clp);
 		if (c)
 			svc_xprt_put(c->cn_xprt);
+		rcu_assign_pointer(clp->cl_cb_session, ses);
 		return;
 	}
 }
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2185,7 +2185,7 @@ static void __free_session(struct nfsd4_
 {
 	free_session_slots(ses, 0);
 	xa_destroy(&ses->se_slots);
-	kfree(ses);
+	kfree_rcu(ses, rcu_head);
 }
 
 static void free_session(struct nfsd4_session *ses)
@@ -3292,7 +3292,7 @@ static struct nfs4_client *create_client
 	clp->cl_time = ktime_get_boottime_seconds();
 	copy_verf(clp, verf);
 	memcpy(&clp->cl_addr, sa, sizeof(struct sockaddr_storage));
-	clp->cl_cb_session = NULL;
+	RCU_INIT_POINTER(clp->cl_cb_session, NULL);
 	clp->net = net;
 	clp->cl_nfsd_dentry = nfsd_client_mkdir(
 		nn, &clp->cl_nfsdfs,
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -383,6 +383,7 @@ struct nfsd4_session {
 	u16			se_slot_gen;
 	bool			se_dead;
 	u32			se_target_maxslots;
+	struct rcu_head		rcu_head;
 };
 
 /* formatted contents of nfs4_sessionid */
@@ -494,7 +495,7 @@ struct nfs4_client {
 #define NFSD4_CB_FAULT		3
 	int			cl_cb_state;
 	struct nfsd4_callback	cl_cb_null;
-	struct nfsd4_session	*cl_cb_session;
+	struct nfsd4_session	__rcu *cl_cb_session;
 
 	/* for all client information that callback code might need: */
 	spinlock_t		cl_lock;
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -1688,9 +1688,10 @@ DEFINE_NFSD_CB_LIFETIME_EVENT(bc_shutdow
 TRACE_EVENT(nfsd_cb_seq_status,
 	TP_PROTO(
 		const struct rpc_task *task,
-		const struct nfsd4_callback *cb
+		const struct nfsd4_callback *cb,
+		const struct nfsd4_session *session
 	),
-	TP_ARGS(task, cb),
+	TP_ARGS(task, cb, session),
 	TP_STRUCT__entry(
 		__field(unsigned int, task_id)
 		__field(unsigned int, client_id)
@@ -1702,8 +1703,6 @@ TRACE_EVENT(nfsd_cb_seq_status,
 		__field(int, seq_status)
 	),
 	TP_fast_assign(
-		const struct nfs4_client *clp = cb->cb_clp;
-		const struct nfsd4_session *session = clp->cl_cb_session;
 		const struct nfsd4_sessionid *sid =
 			(struct nfsd4_sessionid *)&session->se_sessionid;
 
@@ -1729,9 +1728,10 @@ TRACE_EVENT(nfsd_cb_seq_status,
 TRACE_EVENT(nfsd_cb_free_slot,
 	TP_PROTO(
 		const struct rpc_task *task,
-		const struct nfsd4_callback *cb
+		const struct nfsd4_callback *cb,
+		const struct nfsd4_session *session
 	),
-	TP_ARGS(task, cb),
+	TP_ARGS(task, cb, session),
 	TP_STRUCT__entry(
 		__field(unsigned int, task_id)
 		__field(unsigned int, client_id)
@@ -1742,8 +1742,6 @@ TRACE_EVENT(nfsd_cb_free_slot,
 		__field(u32, slot_seqno)
 	),
 	TP_fast_assign(
-		const struct nfs4_client *clp = cb->cb_clp;
-		const struct nfsd4_session *session = clp->cl_cb_session;
 		const struct nfsd4_sessionid *sid =
 			(struct nfsd4_sessionid *)&session->se_sessionid;
 


