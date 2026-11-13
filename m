Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590823;
	b=TJsFCFPbWpdcQN+icL7+TGJpk1D1poyJgw34rukeYu+GpIbHB5xXmhQQHpezNvH9aIy2
	 MTaZ09lbq2AcV2lbu2QwChV3MIPNw2Va/AlhtMmsYPxItVuKTtOXUma2bb5DhhN3+AmVq
	 uso0I+WtqEGw2h98t5P4ucBpfsMYMwSFdLAXSSDXBE+sM1GYjb/iVrCgbcxvKsbz/Gyqa
	 N7LwYlEAmH9HtlSKgegu7BTnZ9CtiE1fAUUu26xNgdMxhQ950lkitogqnQqVztxb8v4I5
	 P05+uOaNdkDy0fb6ePHjwsqeFj+1bKQulhZkavRAqJiOMLqKO21claQ9T5+Sfg5mi7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZaqAOvMpMmvqtXWeZX1xdNoU9q0sp1s7fKxehZWITW0=;
	b=XuS/quExEpbg3mwXG66s7IETdhmbcPEBr2DIAugUKqERl375RNu+uCD95+IgN2pvWwfC
	 woSIFoCnCyLGsfjy8uszX6ZEa465+FtoHBCUkMEC/QyivFKNBll1oGgVVh8WtKE2gHYQ2
	 /Lre2Kv6aCzcCpZDR0GPk/S320HJgh7WZ/plIYzUHvVDbsRYV7CuL10Ya7314dQ+bJcWf
	 TZnICnQdCNqv7dPp5BTHu6WkyDdkENFh79sR6B8gjzWYPoI4cMIe8lSMcNjnTjEul35eY
	 kRnYreWdEmfIZfZbklHXAWptmdhc6OL45zXDCdjgi1cNn9illhDSQ9QJOfHtXX9Pn+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Rrv/MKgj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82296607E059;
	Fri, 13 Nov 2026 17:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rrv/MKgj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3DD1F000C4;
	Fri, 13 Nov 2026 17:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590823;
	bh=ZaqAOvMpMmvqtXWeZX1xdNoU9q0sp1s7fKxehZWITW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rrv/MKgjUPziXx88W/7PFF1bsZiFTtbAIDJ/Czi9oqSywnuR70dYNDOCKK+0Oy6hs
	 8Lsvd/6yaIlLO2atyYvWQUJQOi3ZhCIGqdiEvnm3/tho+ssrgZPK68xWhmokmmBFj7
	 j+vOkM7W/JmHwPyID1gw9E+w3ydHky6bIvMFMbjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/670] nfsd: prevent callback tasks running concurrently
Date: Fri, 13 Nov 2026 10:43:13 -0500
Message-ID: <20261113153812.161528114@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 1054e8ffc5c492f341bdf1888b882f1d163dd3d8 ]

The nfsd4_callback workqueue jobs exist to queue backchannel RPCs to
rpciod. Because they run in different workqueue contexts, the rpc_task
can run concurrently with the workqueue job itself, should it become
requeued. This is problematic as there is no locking when accessing the
fields in the nfsd4_callback.

Add a new unsigned long to nfsd4_callback and declare a new
NFSD4_CALLBACK_RUNNING flag to be set in it. When attempting to run a
workqueue job, do a test_and_set_bit() on that flag first, and don't
queue the workqueue job if it returns true. Clear NFSD4_CALLBACK_RUNNING
in nfsd41_destroy_cb().

This also gives us a more reliable mechanism for handling queueing
failures in codepaths where we have to take references under spinlocks.
We can now do the test_and_set_bit on NFSD4_CALLBACK_RUNNING first, and
only take references to the objects if that returns false.

Most of the nfsd4_run_cb() callers are converted to use this new flag or
the nfsd4_try_run_cb() wrapper. The main exception is the callback
channel probe, which has its own synchronization.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 9af39c0773ef ("NFSD: Send a meaningful CB_RECALL_ANY keep count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c |  2 ++
 fs/nfsd/nfs4layouts.c  |  7 ++++---
 fs/nfsd/nfs4proc.c     |  2 +-
 fs/nfsd/nfs4state.c    | 14 ++++++++++----
 fs/nfsd/state.h        |  9 +++++++++
 5 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 798fcc9c40926..47cfd4bd4ecc4 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -1227,6 +1227,7 @@ static void nfsd41_destroy_cb(struct nfsd4_callback *cb)
 
 	trace_nfsd_cb_destroy(clp, cb);
 	nfsd41_cb_release_slot(cb);
+	clear_bit(NFSD4_CALLBACK_RUNNING, &cb->cb_flags);
 	if (cb->cb_ops && cb->cb_ops->release)
 		cb->cb_ops->release(cb);
 	nfsd41_cb_inflight_end(clp);
@@ -1575,6 +1576,7 @@ void nfsd4_init_cb(struct nfsd4_callback *cb, struct nfs4_client *clp,
 	cb->cb_msg.rpc_proc = &nfs4_cb_procedures[op];
 	cb->cb_msg.rpc_argp = cb;
 	cb->cb_msg.rpc_resp = cb;
+	cb->cb_flags = 0;
 	cb->cb_ops = ops;
 	INIT_WORK(&cb->cb_work, nfsd4_run_cb_work);
 	cb->cb_status = 0;
diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index a78e0bfdc9363..1f37044db59f3 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -348,9 +348,10 @@ nfsd4_recall_file_layout(struct nfs4_layout_stateid *ls)
 	atomic_inc(&ls->ls_stid.sc_file->fi_lo_recalls);
 	trace_nfsd_layout_recall(&ls->ls_stid.sc_stateid);
 
-	refcount_inc(&ls->ls_stid.sc_count);
-	nfsd4_run_cb(&ls->ls_recall);
-
+	if (!test_and_set_bit(NFSD4_CALLBACK_RUNNING, &ls->ls_recall.cb_flags)) {
+		refcount_inc(&ls->ls_stid.sc_count);
+		nfsd4_run_cb(&ls->ls_recall);
+	}
 out_unlock:
 	spin_unlock(&ls->ls_lock);
 }
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 53ded5de593a8..4825be4dc6467 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1769,7 +1769,7 @@ static void nfsd4_send_cb_offload(struct nfsd4_copy *copy)
 		      NFSPROC4_CLNT_CB_OFFLOAD);
 	trace_nfsd_cb_offload(copy->cp_clp, &cbo->co_res.cb_stateid,
 			      &cbo->co_fh, copy->cp_count, copy->nfserr);
-	nfsd4_run_cb(&cbo->co_cb);
+	nfsd4_try_run_cb(&cbo->co_cb);
 }
 
 /**
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 723a1ae688366..2188c15d3ec6c 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3303,8 +3303,10 @@ static void nfs4_cb_getattr(struct nfs4_cb_fattr *ncf)
 	/* set to proper status when nfsd4_cb_getattr_done runs */
 	ncf->ncf_cb_status = NFS4ERR_IO;
 
-	refcount_inc(&dp->dl_stid.sc_count);
-	nfsd4_run_cb(&ncf->ncf_getattr);
+	if (!test_and_set_bit(NFSD4_CALLBACK_RUNNING, &ncf->ncf_getattr.cb_flags)) {
+		refcount_inc(&dp->dl_stid.sc_count);
+		nfsd4_run_cb(&ncf->ncf_getattr);
+	}
 }
 
 static struct nfs4_client *create_client(struct xdr_netobj name,
@@ -5477,6 +5479,10 @@ static const struct nfsd4_callback_ops nfsd4_cb_recall_ops = {
 static void nfsd_break_one_deleg(struct nfs4_delegation *dp)
 {
 	bool queued;
+
+	if (test_and_set_bit(NFSD4_CALLBACK_RUNNING, &dp->dl_recall.cb_flags))
+		return;
+
 	/*
 	 * We're assuming the state code never drops its reference
 	 * without first removing the lease.  Since we're in this lease
@@ -7036,7 +7042,7 @@ deleg_reaper(struct nfsd_net *nn)
 		clp->cl_ra->ra_bmval[0] = BIT(RCA4_TYPE_MASK_RDATA_DLG) |
 						BIT(RCA4_TYPE_MASK_WDATA_DLG);
 		trace_nfsd_cb_recall_any(clp->cl_ra);
-		nfsd4_run_cb(&clp->cl_ra->ra_cb);
+		nfsd4_try_run_cb(&clp->cl_ra->ra_cb);
 	}
 }
 
@@ -7977,7 +7983,7 @@ nfsd4_lm_notify(struct file_lock *fl)
 
 	if (queue) {
 		trace_nfsd_cb_notify_lock(lo, nbl);
-		nfsd4_run_cb(&nbl->nbl_cb);
+		nfsd4_try_run_cb(&nbl->nbl_cb);
 	}
 }
 
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index f39a425639b07..e4c3e5907db15 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -67,6 +67,8 @@ typedef struct {
 struct nfsd4_callback {
 	struct nfs4_client *cb_clp;
 	struct rpc_message cb_msg;
+#define NFSD4_CALLBACK_RUNNING		(0)
+	unsigned long cb_flags;
 	const struct nfsd4_callback_ops *cb_ops;
 	struct work_struct cb_work;
 	int cb_seq_status;
@@ -748,6 +750,13 @@ extern void nfsd4_change_callback(struct nfs4_client *clp, struct nfs4_cb_conn *
 extern void nfsd4_init_cb(struct nfsd4_callback *cb, struct nfs4_client *clp,
 		const struct nfsd4_callback_ops *ops, enum nfsd4_cb_op op);
 extern bool nfsd4_run_cb(struct nfsd4_callback *cb);
+
+static inline void nfsd4_try_run_cb(struct nfsd4_callback *cb)
+{
+	if (!test_and_set_bit(NFSD4_CALLBACK_RUNNING, &cb->cb_flags))
+		WARN_ON_ONCE(!nfsd4_run_cb(cb));
+}
+
 extern void nfsd4_shutdown_callback(struct nfs4_client *);
 extern void nfsd4_shutdown_copy(struct nfs4_client *clp);
 extern struct nfs4_client_reclaim *nfs4_client_to_reclaim(struct xdr_netobj name,
-- 
2.53.0



