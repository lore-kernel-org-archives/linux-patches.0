Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1905C3C6A30;
	Thu, 19 Mar 2026 11:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773918825; cv=none; b=qZCvWj43bu9PQE/AXH+knWG7cCM7kMeTour8Qjl9lPsDijzxl83pyEPJy2a2Gg3tDLNnudpto9J/5WRx6/H2e1F/0XUf/QJwGbY9FmHX7HEQg2Ie9gPSX+zdYi83nXwuTdWLD8oCIF109eAcM4ZsJNYJCKAzePwJ4LEIZ75e3A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773918825; c=relaxed/simple;
	bh=FLlfCROOW2Lhtvi8zD12iTz3IAZhYwvU5lxkaAZpXyQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=ZNaBpEvMEY8Zx0ihxXRsamZXLKtccApJhBAsRJJkEkvjfLNX/2/J0TFgBrbjCfyVbHJwBvbjb8m67v+WROom2sffMs90W+P4rRFP1ZtoowGLyi1vn4hjIZW/H2eNsAehimDeaVYzso3UXYPwbyuTJ/qPH+/mid0sQ5eWtXmB/j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17meq+Tg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17meq+Tg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF5CC2BCAF;
	Thu, 19 Mar 2026 11:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773918824;
	bh=FLlfCROOW2Lhtvi8zD12iTz3IAZhYwvU5lxkaAZpXyQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=17meq+TgoSYJLxCVSrvz8FKUo+YmxDZljUrvMW25FAMkSZj+z2BWPBJ2HpPwYoyxn
	 aSRtnYjuI0WOCYBCV18xvEleNxuRB/XI1wUZvEIpzocHyC8g0ar7DwiHy0IWiwW+Em
	 f5esTUQis4pqRH59vFkTKMOyB1AGJ2KOCNLyQvC0=
Subject: Patch "pNFS: Fix a deadlock when returning a delegation during open()" has been added to the 6.6-stable tree
To: 1468888505@139.com,anna@kernel.org,bcodding@hammerspace.com,gregkh@linuxfoundation.org,patches@lists.linux.dev,trond.myklebust@hammerspace.com,wangzhaolong@huaweicloud.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 19 Mar 2026 12:12:52 +0100
In-Reply-To: <20260224072202.2940831-1-1468888505@139.com>
Message-ID: <2026031952-reward-raft-9f4a@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    pNFS: Fix a deadlock when returning a delegation during open()

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     pnfs-fix-a-deadlock-when-returning-a-delegation-during-open.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-217868-greg=kroah.com@vger.kernel.org Tue Feb 24 08:22:45 2026
From: Li hongliang <1468888505@139.com>
Date: Tue, 24 Feb 2026 15:22:02 +0800
Subject: pNFS: Fix a deadlock when returning a delegation during open()
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, trond.myklebust@hammerspace.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, bcodding@hammerspace.com, anna@kernel.org, linux-nfs@vger.kernel.org, wangzhaolong@huaweicloud.com
Message-ID: <20260224072202.2940831-1-1468888505@139.com>

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
[ Minor conflict resolved. ]
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |    6 ++---
 fs/nfs/pnfs.c     |   58 ++++++++++++++++++++++++++++++++++++++----------------
 fs/nfs/pnfs.h     |   17 ++++++---------
 3 files changed, 51 insertions(+), 30 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3792,8 +3792,8 @@ int nfs4_do_close(struct nfs4_state *sta
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
@@ -6742,7 +6742,7 @@ static int _nfs4_proc_delegreturn(struct
 	data->inode = nfs_igrab_and_active(inode);
 	if (data->inode || issync) {
 		data->lr.roc = pnfs_roc(inode, &data->lr.arg, &data->lr.res,
-					cred);
+					cred, issync);
 		if (data->lr.roc) {
 			data->args.lr_args = &data->lr.arg;
 			data->res.lr_res = &data->lr.res;
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1427,10 +1427,9 @@ pnfs_commit_and_return_layout(struct ino
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
@@ -1454,20 +1453,14 @@ retry:
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
 
@@ -1476,12 +1469,43 @@ retry:
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
@@ -1521,7 +1545,7 @@ retry:
 out_noroc:
 	spin_unlock(&ino->i_lock);
 	rcu_read_unlock();
-	pnfs_layoutcommit_inode(ino, true);
+	pnfs_layoutcommit_inode(ino, sync);
 	if (roc) {
 		struct pnfs_layoutdriver_type *ld = NFS_SERVER(ino)->pnfs_curr_ld;
 		if (ld->prepare_layoutreturn)
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -295,10 +295,9 @@ int pnfs_mark_matching_lsegs_return(stru
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
@@ -769,12 +768,10 @@ pnfs_layoutcommit_outstanding(struct ino
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


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.6/pnfs-fix-a-deadlock-when-returning-a-delegation-during-open.patch
queue-6.6/nfs-pass-explicit-offset-count-to-trace-events.patch
queue-6.6/nfs-fix-a-deadlock-involving-nfs_release_folio.patch
