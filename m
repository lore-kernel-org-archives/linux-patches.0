Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214627;
	b=5P4cEPutFEYegRz3PQ1ZLpo6j+grwuV4wk6w3oaxLOPWEooYo6DUClS23TANvodOej8T
	 1geIS/+L3dzYAzynDrs9/VuOtfSv+a5mgRzX0lvL6nDYThSGJSPs4oOd7aKptneolfOxc
	 Nld1NeUu9oO0fIQBmSE/+VXQWNF/65A2uEZTDXrBQvcyf5Zq1Hi8VgxmUzhzkD+SGqsQ4
	 WOxP/AY7RP877WK5nNrtgHqMgua7rYMmSP3GcOXQHj0dybewfjLYxVuRbarXbf/9YAHEP
	 9TXKa+iHCHVbrdDiGjyiroSQ3MPzUqAFHtHvqZiIFrvrvyxfrPXa7rmq6MpL/JWfbgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KIAo1HZv7m5geVVJpxqW2uAKr+Th7T7xfykRLn+jfMo=;
	b=3AckNsP0J8xPUEy/GVjasmF3LMlzYBZOmHm/OSGjdUo9ZBzKkoppSxEXsgf3pn2Q4Are
	 7u1j/gcMkXUqylgm3xQwOhfYtXRhliysOAEWQ5WRHhfOvgVs4ZMwM1fJ8szRHoNFrW+dy
	 kFLZPGuk50fcmKO52R5kchx/YuJzP7HBLGc+tbjqeP5h63tkXwL9F5xo0Cfi2NoY7Q3ij
	 /UdZ6n4xElI1uyB4qoMeQpA8mGNP/975cVuls/tPtDhdHyYoTKA0i4GCi6N4yC4Wf+zfr
	 Xz96lMzXRAH4MMOSGl/KHWjmL8w/AYGI7ynInCYoxgr6kOWp2LEmGDqsJLmAxA+SnEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gjkWZx5I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF29606AB25;
	Wed, 28 Oct 2026 19:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gjkWZx5I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC9D1F031E1;
	Wed, 28 Oct 2026 19:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214626;
	bh=KIAo1HZv7m5geVVJpxqW2uAKr+Th7T7xfykRLn+jfMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gjkWZx5INDFORD7OXR8U9rYxvP+dMoQ+uRE36twLR6YS28J7pmq3jMy3fGe6OSIjr
	 8XlFvPCVTRqMgD6t+7qYTf6KRR1Hp1ZI+lrciPRp2XcILvIYiHlhp09mVsvD4Xuchi
	 mr4xBntqHrdcHug1Nbj2o4un/pn+Yr+Weskvwcco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0925/1887] pNFS: Fix a deadlock when returning a delegation during open()
Date: Wed, 28 Oct 2026 17:50:21 +0100
Message-ID: <20261028170520.465713758@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 857bf9056291a16785ae3be1d291026b2437fc48 ]

Ben Coddington reports seeing a hang in the following stack trace:
  0 [ffffd0b50e1774e0] __schedule at ffffffff9ca05415
  1 [ffffd0b50e177548] schedule at ffffffff9ca05717
  2 [ffffd0b50e177558] bit_wait at ffffffff9ca061e1
  3 [ffffd0b50e177568] __wait_on_bit at ffffffff9ca05cfb
  4 [ffffd0b50e1775c8] out_of_line_wait_on_bit at ffffffff9ca05ea5
  5 [ffffd0b50e177618] pnfs_roc at ffffffffc154207b [nfsv4]
  6 [ffffd0b50e1776b8] _nfs4_proc_delegreturn at ffffffffc1506586 [nfsv4]
  7 [ffffd0b50e177788] nfs4_proc_delegreturn at ffffffffc1507480 [nfsv4]
  8 [ffffd0b50e1777f8] nfs_do_return_delegation at ffffffffc1523e41 [nfsv4]
  9 [ffffd0b50e177838] nfs_inode_set_delegation at ffffffffc1524a75 [nfsv4]
 10 [ffffd0b50e177888] nfs4_process_delegation at ffffffffc14f41dd [nfsv4]
 11 [ffffd0b50e1778a0] _nfs4_opendata_to_nfs4_state at ffffffffc1503edf [nfsv4]
 12 [ffffd0b50e1778c0] _nfs4_open_and_get_state at ffffffffc1504e56 [nfsv4]
 13 [ffffd0b50e177978] _nfs4_do_open at ffffffffc15051b8 [nfsv4]
 14 [ffffd0b50e1779f8] nfs4_do_open at ffffffffc150559c [nfsv4]
 15 [ffffd0b50e177a80] nfs4_atomic_open at ffffffffc15057fb [nfsv4]
 16 [ffffd0b50e177ad0] nfs4_file_open at ffffffffc15219be [nfsv4]
 17 [ffffd0b50e177b78] do_dentry_open at ffffffff9c09e6ea
 18 [ffffd0b50e177ba8] vfs_open at ffffffff9c0a082e
 19 [ffffd0b50e177bd0] dentry_open at ffffffff9c0a0935

The issue is that the delegreturn is being asked to wait for a layout
return that cannot complete because a state recovery was initiated. The
state recovery cannot complete until the open() finishes processing the
delegations it was given.

The solution is to propagate the existing flags that indicate a
non-blocking call to the function pnfs_roc(), so that it knows not to
wait in this situation.

Reported-by: Benjamin Coddington <bcodding@hammerspace.com>
Fixes: 29ade5db1293 ("pNFS: Wait on outstanding layoutreturns to complete in pnfs_roc()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c |  6 ++---
 fs/nfs/pnfs.c     | 58 +++++++++++++++++++++++++++++++++--------------
 fs/nfs/pnfs.h     | 17 ++++++--------
 3 files changed, 51 insertions(+), 30 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 9f352f1a6eb1e..333ed7e8d4c68 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3798,8 +3798,8 @@ int nfs4_do_close(struct nfs4_state *state, gfp_t gfp_mask, int wait)
 	calldata->res.seqid = calldata->arg.seqid;
 	calldata->res.server = server;
 	calldata->res.lr_ret = -NFS4ERR_NOMATCHING_LAYOUT;
-	calldata->lr.roc = pnfs_roc(state->inode,
-			&calldata->lr.arg, &calldata->lr.res, msg.rpc_cred);
+	calldata->lr.roc = pnfs_roc(state->inode, &calldata->lr.arg,
+				    &calldata->lr.res, msg.rpc_cred, wait);
 	if (calldata->lr.roc) {
 		calldata->arg.lr_args = &calldata->lr.arg;
 		calldata->res.lr_res = &calldata->lr.res;
@@ -6748,7 +6748,7 @@ static int _nfs4_proc_delegreturn(struct inode *inode, const struct cred *cred,
 	data->inode = nfs_igrab_and_active(inode);
 	if (data->inode || issync) {
 		data->lr.roc = pnfs_roc(inode, &data->lr.arg, &data->lr.res,
-					cred);
+					cred, issync);
 		if (data->lr.roc) {
 			data->args.lr_args = &data->lr.arg;
 			data->res.lr_res = &data->lr.res;
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 99a93c63708df..26d509b6ebd10 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1427,10 +1427,9 @@ pnfs_commit_and_return_layout(struct inode *inode)
 	return ret;
 }
 
-bool pnfs_roc(struct inode *ino,
-		struct nfs4_layoutreturn_args *args,
-		struct nfs4_layoutreturn_res *res,
-		const struct cred *cred)
+bool pnfs_roc(struct inode *ino, struct nfs4_layoutreturn_args *args,
+	      struct nfs4_layoutreturn_res *res, const struct cred *cred,
+	      bool sync)
 {
 	struct nfs_inode *nfsi = NFS_I(ino);
 	struct nfs_open_context *ctx;
@@ -1441,7 +1440,7 @@ bool pnfs_roc(struct inode *ino,
 	nfs4_stateid stateid;
 	enum pnfs_iomode iomode = 0;
 	bool layoutreturn = false, roc = false;
-	bool skip_read = false;
+	bool skip_read;
 
 	if (!nfs_have_layout(ino))
 		return false;
@@ -1454,20 +1453,14 @@ bool pnfs_roc(struct inode *ino,
 		lo = NULL;
 		goto out_noroc;
 	}
-	pnfs_get_layout_hdr(lo);
-	if (test_bit(NFS_LAYOUT_RETURN_LOCK, &lo->plh_flags)) {
-		spin_unlock(&ino->i_lock);
-		rcu_read_unlock();
-		wait_on_bit(&lo->plh_flags, NFS_LAYOUT_RETURN,
-				TASK_UNINTERRUPTIBLE);
-		pnfs_put_layout_hdr(lo);
-		goto retry;
-	}
 
 	/* no roc if we hold a delegation */
+	skip_read = false;
 	if (nfs4_check_delegation(ino, FMODE_READ)) {
-		if (nfs4_check_delegation(ino, FMODE_WRITE))
+		if (nfs4_check_delegation(ino, FMODE_WRITE)) {
+			lo = NULL;
 			goto out_noroc;
+		}
 		skip_read = true;
 	}
 
@@ -1476,12 +1469,43 @@ bool pnfs_roc(struct inode *ino,
 		if (state == NULL)
 			continue;
 		/* Don't return layout if there is open file state */
-		if (state->state & FMODE_WRITE)
+		if (state->state & FMODE_WRITE) {
+			lo = NULL;
 			goto out_noroc;
+		}
 		if (state->state & FMODE_READ)
 			skip_read = true;
 	}
 
+	if (skip_read) {
+		bool writes = false;
+
+		list_for_each_entry(lseg, &lo->plh_segs, pls_list) {
+			if (lseg->pls_range.iomode != IOMODE_READ) {
+				writes = true;
+				break;
+			}
+		}
+		if (!writes) {
+			lo = NULL;
+			goto out_noroc;
+		}
+	}
+
+	pnfs_get_layout_hdr(lo);
+	if (test_bit(NFS_LAYOUT_RETURN_LOCK, &lo->plh_flags)) {
+		if (!sync) {
+			pnfs_set_plh_return_info(
+				lo, skip_read ? IOMODE_RW : IOMODE_ANY, 0);
+			goto out_noroc;
+		}
+		spin_unlock(&ino->i_lock);
+		rcu_read_unlock();
+		wait_on_bit(&lo->plh_flags, NFS_LAYOUT_RETURN,
+			    TASK_UNINTERRUPTIBLE);
+		pnfs_put_layout_hdr(lo);
+		goto retry;
+	}
 
 	list_for_each_entry_safe(lseg, next, &lo->plh_segs, pls_list) {
 		if (skip_read && lseg->pls_range.iomode == IOMODE_READ)
@@ -1521,7 +1545,7 @@ bool pnfs_roc(struct inode *ino,
 out_noroc:
 	spin_unlock(&ino->i_lock);
 	rcu_read_unlock();
-	pnfs_layoutcommit_inode(ino, true);
+	pnfs_layoutcommit_inode(ino, sync);
 	if (roc) {
 		struct pnfs_layoutdriver_type *ld = NFS_SERVER(ino)->pnfs_curr_ld;
 		if (ld->prepare_layoutreturn)
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index c95f8a26ee1b4..0cc6f9a295f2c 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -296,10 +296,9 @@ int pnfs_mark_matching_lsegs_return(struct pnfs_layout_hdr *lo,
 				u32 seq);
 int pnfs_mark_layout_stateid_invalid(struct pnfs_layout_hdr *lo,
 		struct list_head *lseg_list);
-bool pnfs_roc(struct inode *ino,
-		struct nfs4_layoutreturn_args *args,
-		struct nfs4_layoutreturn_res *res,
-		const struct cred *cred);
+bool pnfs_roc(struct inode *ino, struct nfs4_layoutreturn_args *args,
+	      struct nfs4_layoutreturn_res *res, const struct cred *cred,
+	      bool sync);
 int pnfs_roc_done(struct rpc_task *task, struct nfs4_layoutreturn_args **argpp,
 		  struct nfs4_layoutreturn_res **respp, int *ret);
 void pnfs_roc_release(struct nfs4_layoutreturn_args *args,
@@ -770,12 +769,10 @@ pnfs_layoutcommit_outstanding(struct inode *inode)
 	return false;
 }
 
-
-static inline bool
-pnfs_roc(struct inode *ino,
-		struct nfs4_layoutreturn_args *args,
-		struct nfs4_layoutreturn_res *res,
-		const struct cred *cred)
+static inline bool pnfs_roc(struct inode *ino,
+			    struct nfs4_layoutreturn_args *args,
+			    struct nfs4_layoutreturn_res *res,
+			    const struct cred *cred, bool sync)
 {
 	return false;
 }
-- 
2.53.0



