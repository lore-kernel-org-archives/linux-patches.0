Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515CA38B14C;
	Tue, 21 Jul 2026 18:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657198; cv=none; b=Yi+wx+cJGYVJDGdpmR4xl8p4IBc1DCGb6RekSFSiVhfexRKMP144teUA2UdR6sC50QzZskW5Uay7wYjxk2umy/O+v6xDMG38nw9PxWgaMIRYMTzMwrUW77VlV5JU0sLwUec2BVEyEABzwc9Jza/2oXWJEmaR55RtcfbOAQs3Otc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657198; c=relaxed/simple;
	bh=2txLembLVemMHVT/s/+u+Rqf48rJgHM+StvVGaElufk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXhS8E7IK0+hJWh7J0GJ4f7awp9U0vhxujBxvHsKp4fcU44kQA1ux15UtMvA8ydoR8uY6bm7c7JNQClKZbjJhe8UbRNnWyRSbiz++pMI7ceNimc799/3vZCVBN1zgolNUgkfPeyKctAEuIhzkHaoxG9/u6GaVvtfrn7rTbmiu5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ujC4B05G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ujC4B05G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C101F000E9;
	Tue, 21 Jul 2026 18:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657197;
	bh=OjtC/GdHx1JjojhYtIeQPBGaYMqC+KLrWRgCqJn3IYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ujC4B05GyfCotnNx01NmzDnD6EQTHcij+2XGLzhibYckgohVtS1hp9VOw22iU+8EN
	 bLhZ48+FcY7y4IgazT409nmAv31azvfDMVaFvnuirFH513cXxfHlWoGri0Qhe8U0rp
	 9FGNeGdfynoFb9X+zVPxjrADVL6gFwy34AkFMyOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Yang Erkun <yangerkun@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0674/1611] nfs: use nfsi->rwsem to protect traversal of the file lock list
Date: Tue, 21 Jul 2026 17:13:10 +0200
Message-ID: <20260721152530.542329074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Erkun <yangerkun@huawei.com>

[ Upstream commit 4837fb36219e6c08b666bc31a86841bad8526358 ]

Lingfeng identified a bug and suggested two solutions, but both appear
to have issues.

Generally, we cannot release flc_lock while iterating over the file lock
list to avoid use-after-free (UAF) problems with file locks. However,
functions like nfs_delegation_claim_locks and nfs4_reclaim_locks cannot
adhere to this rule because recover_lock or nfs4_lock_delegation_recall
may take a long time. To resolve this, NFS switches to using nfsi->rwsem
for the same protection, and nfs_reclaim_locks follows this approach.
Although nfs_delegation_claim_locks uses so_delegreturn_mutex instead,
this is inadequate since a single inode can have multiple nfs4_state
instances. Therefore, the fix is to also use nfsi->rwsem in this case.

Furthermore, after commit c69899a17ca4 ("NFSv4: Update of VFS byte range
lock must be atomic with the stateid update"), the functions
nfs4_locku_done and nfs4_lock_done also break this rule because they
call locks_lock_inode_wait without holding nfsi->rwsem. Simply adding
this protection could cause many deadlocks, so instead, the call to
locks_lock_inode_wait is moved into _nfs4_proc_setlk. Regarding the bug
fixed by commit c69899a17ca4 ("NFSv4: Update of VFS byte range
lock must be atomic with the stateid update"), it has been resolved
after commit 0460253913e5 ("NFSv4: nfs4_do_open() is incorrectly triggering
state recovery") because all slots are drained before calling
nfs4_do_reclaim, which prevents concurrent stateid changes along this path.
Also, nfs_delegation_claim_locks does not cause this concurrency either
since when _nfs4_proc_setlk is called with NFS_DELEGATED_STATE, no RPC is
sent, so nfs4_lock_done is not called. Therefore,
nfs4_lock_delegation_recall from nfs_delegation_claim_locks is the first
time the stateid is set.

Reported-by: Li Lingfeng <lilingfeng3@huawei.com>
Closes: https://lore.kernel.org/all/20250419085709.1452492-1-lilingfeng3@huawei.com/
Closes: https://lore.kernel.org/all/20250715030559.2906634-1-lilingfeng3@huawei.com/
Fixes: c69899a17ca4 ("NFSv4: Update of VFS byte range lock must be atomic with the stateid update")
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c     |  9 ++++++++-
 fs/nfs/nfs4proc.c       | 22 +++++++++++-----------
 include/linux/nfs_xdr.h |  1 -
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 9d3a5f29f17fdc..f95707fc0edff7 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -158,6 +158,7 @@ int nfs4_check_delegation(struct inode *inode, fmode_t type)
 static int nfs_delegation_claim_locks(struct nfs4_state *state, const nfs4_stateid *stateid)
 {
 	struct inode *inode = state->inode;
+	struct nfs_inode *nfsi = NFS_I(inode);
 	struct file_lock *fl;
 	struct file_lock_context *flctx = locks_inode_context(inode);
 	struct list_head *list;
@@ -167,6 +168,9 @@ static int nfs_delegation_claim_locks(struct nfs4_state *state, const nfs4_state
 		goto out;
 
 	list = &flctx->flc_posix;
+
+	/* Guard against reclaim and new lock/unlock calls */
+	down_write(&nfsi->rwsem);
 	spin_lock(&flctx->flc_lock);
 restart:
 	for_each_file_lock(fl, list) {
@@ -174,8 +178,10 @@ static int nfs_delegation_claim_locks(struct nfs4_state *state, const nfs4_state
 			continue;
 		spin_unlock(&flctx->flc_lock);
 		status = nfs4_lock_delegation_recall(fl, state, stateid);
-		if (status < 0)
+		if (status < 0) {
+			up_write(&nfsi->rwsem);
 			goto out;
+		}
 		spin_lock(&flctx->flc_lock);
 	}
 	if (list == &flctx->flc_posix) {
@@ -183,6 +189,7 @@ static int nfs_delegation_claim_locks(struct nfs4_state *state, const nfs4_state
 		goto restart;
 	}
 	spin_unlock(&flctx->flc_lock);
+	up_write(&nfsi->rwsem);
 out:
 	return status;
 }
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index fc858b5c3f66d4..403f7f8dfea2b9 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7178,7 +7178,6 @@ static void nfs4_locku_done(struct rpc_task *task, void *data)
 	switch (task->tk_status) {
 		case 0:
 			renew_lease(calldata->server, calldata->timestamp);
-			locks_lock_inode_wait(calldata->lsp->ls_state->inode, &calldata->fl);
 			if (nfs4_update_lock_stateid(calldata->lsp,
 					&calldata->res.stateid))
 				break;
@@ -7445,11 +7444,6 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 	case 0:
 		renew_lease(NFS_SERVER(d_inode(data->ctx->dentry)),
 				data->timestamp);
-		if (data->arg.new_lock && !data->cancelled) {
-			data->fl.c.flc_flags &= ~(FL_SLEEP | FL_ACCESS);
-			if (locks_lock_inode_wait(lsp->ls_state->inode, &data->fl) < 0)
-				goto out_restart;
-		}
 		if (data->arg.new_lock_owner != 0) {
 			nfs_confirm_seqid(&lsp->ls_seqid, 0);
 			nfs4_stateid_copy(&lsp->ls_stateid, &data->res.stateid);
@@ -7559,11 +7553,10 @@ static int _nfs4_do_setlk(struct nfs4_state *state, int cmd, struct file_lock *f
 	msg.rpc_argp = &data->arg;
 	msg.rpc_resp = &data->res;
 	task_setup_data.callback_data = data;
-	if (recovery_type > NFS_LOCK_NEW) {
-		if (recovery_type == NFS_LOCK_RECLAIM)
-			data->arg.reclaim = NFS_LOCK_RECLAIM;
-	} else
-		data->arg.new_lock = 1;
+
+	if (recovery_type == NFS_LOCK_RECLAIM)
+		data->arg.reclaim = NFS_LOCK_RECLAIM;
+
 	task = rpc_run_task(&task_setup_data);
 	if (IS_ERR(task))
 		return PTR_ERR(task);
@@ -7675,6 +7668,13 @@ static int _nfs4_proc_setlk(struct nfs4_state *state, int cmd, struct file_lock
 	up_read(&nfsi->rwsem);
 	mutex_unlock(&sp->so_delegreturn_mutex);
 	status = _nfs4_do_setlk(state, cmd, request, NFS_LOCK_NEW);
+	if (status)
+		goto out;
+
+	down_read(&nfsi->rwsem);
+	request->c.flc_flags &= ~(FL_SLEEP | FL_ACCESS);
+	status = locks_lock_inode_wait(state->inode, request);
+	up_read(&nfsi->rwsem);
 out:
 	request->c.flc_flags = flags;
 	return status;
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 31463286402fd2..972059a016c9a5 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -579,7 +579,6 @@ struct nfs_lock_args {
 	struct nfs_lowner	lock_owner;
 	unsigned char		block : 1;
 	unsigned char		reclaim : 1;
-	unsigned char		new_lock : 1;
 	unsigned char		new_lock_owner : 1;
 };
 
-- 
2.53.0



