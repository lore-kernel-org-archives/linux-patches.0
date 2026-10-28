Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215532;
	b=UUUKUtjqLwCM5KC72Fz68XPHyp0r8/yeeVV2H87TMStPVWAoe5505FFNn9YItxswg9af
	 ag2SDr0oJOT9A4heML6iSvc2ohamdL6nhbv5tIXOCOuRBSU4CQwx5DUQaH0HydjaRZmR1
	 OGfuhXCy9+ZWZw9lPGMH0vYiB+kQ2PjuHth9a5E+20hBsdg59snu8M9US3dy9pzgXa956
	 7ZZlRJdSbK+S9r4n/TdYZeh9nU0bn3k6tvohPgREL5XdRKRx3HnXKpE4KFhDN0aQFPKiw
	 py/tHfG7lh6SCdxf7sI6Dr/75VX+a4qWZ6HZO3fT7hBthdtZvRDycqmrLydj3Xi0jxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BzqOo9E8UpqUeTY32+fVl2Tbs2OjylRwNsLcYNXmBwE=;
	b=2TGLhb/lPwG/5WE57r9OeeqnNtEix2DzVpu4cPI82R2JkjtCeDavXzJaVaFZbB+XANIv
	 uSyk01X+u8uHsmwIJBgshdRXoTDjLZIMNYB6sO6PbEpYgB6YCf3S0jxPVzgzD+V2J3/k7
	 EjVb5HwqlabXyq0W2Zj40aP2l4xva6vi12MZ3/3R556ufajsq1gwc4dLS1nfyD5xRBsjv
	 KZ+a54dxPaBo+sPkDfNyAV8N21n3nnc7iBY11BsyqzLlQd/munRc+gV9uDcT/Ub4mDhnK
	 HoJWnoDhX6gJjfkFF6niqm2PgKl+BY0wz2tRefzXREY0FuZenTwhmSdG0PLUrEg8LAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yto7MOCl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447C7606A31A;
	Wed, 28 Oct 2026 19:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yto7MOCl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934761F01825;
	Wed, 28 Oct 2026 19:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215532;
	bh=BzqOo9E8UpqUeTY32+fVl2Tbs2OjylRwNsLcYNXmBwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yto7MOClQCOsK78CJetjU91y7UjSYRWvp7Wmp5mhymj3QOfslZvsAT2O5ivTZOtIM
	 JfZymcUajrintt+mgdEHh1+z1rwnvqyLSI7E1tr8QCIPNoVhlNQcmBq5RNENua6xZ1
	 3JVVTG+p7jRKEKQ8sfX5gVVsy3fy3K5uwIB+vD3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Yang Erkun <yangerkun@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1244/1887] nfs: use nfsi->rwsem to protect traversal of the file lock list
Date: Wed, 28 Oct 2026 17:55:40 +0100
Message-ID: <20261028170527.733450634@linuxfoundation.org>
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
index 17b38da17288b..9002b479a125b 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -145,6 +145,7 @@ int nfs4_check_delegation(struct inode *inode, fmode_t flags)
 static int nfs_delegation_claim_locks(struct nfs4_state *state, const nfs4_stateid *stateid)
 {
 	struct inode *inode = state->inode;
+	struct nfs_inode *nfsi = NFS_I(inode);
 	struct file_lock *fl;
 	struct file_lock_context *flctx = inode->i_flctx;
 	struct list_head *list;
@@ -154,6 +155,9 @@ static int nfs_delegation_claim_locks(struct nfs4_state *state, const nfs4_state
 		goto out;
 
 	list = &flctx->flc_posix;
+
+	/* Guard against reclaim and new lock/unlock calls */
+	down_write(&nfsi->rwsem);
 	spin_lock(&flctx->flc_lock);
 restart:
 	list_for_each_entry(fl, list, fl_list) {
@@ -161,8 +165,10 @@ static int nfs_delegation_claim_locks(struct nfs4_state *state, const nfs4_state
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
@@ -170,6 +176,7 @@ static int nfs_delegation_claim_locks(struct nfs4_state *state, const nfs4_state
 		goto restart;
 	}
 	spin_unlock(&flctx->flc_lock);
+	up_write(&nfsi->rwsem);
 out:
 	return status;
 }
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 333ed7e8d4c68..bde81060f833e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6961,7 +6961,6 @@ static void nfs4_locku_done(struct rpc_task *task, void *data)
 	switch (task->tk_status) {
 		case 0:
 			renew_lease(calldata->server, calldata->timestamp);
-			locks_lock_inode_wait(calldata->lsp->ls_state->inode, &calldata->fl);
 			if (nfs4_update_lock_stateid(calldata->lsp,
 					&calldata->res.stateid))
 				break;
@@ -7224,11 +7223,6 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 	case 0:
 		renew_lease(NFS_SERVER(d_inode(data->ctx->dentry)),
 				data->timestamp);
-		if (data->arg.new_lock && !data->cancelled) {
-			data->fl.fl_flags &= ~(FL_SLEEP | FL_ACCESS);
-			if (locks_lock_inode_wait(lsp->ls_state->inode, &data->fl) < 0)
-				goto out_restart;
-		}
 		if (data->arg.new_lock_owner != 0) {
 			nfs_confirm_seqid(&lsp->ls_seqid, 0);
 			nfs4_stateid_copy(&lsp->ls_stateid, &data->res.stateid);
@@ -7337,11 +7331,10 @@ static int _nfs4_do_setlk(struct nfs4_state *state, int cmd, struct file_lock *f
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
@@ -7453,6 +7446,13 @@ static int _nfs4_proc_setlk(struct nfs4_state *state, int cmd, struct file_lock
 	up_read(&nfsi->rwsem);
 	mutex_unlock(&sp->so_delegreturn_mutex);
 	status = _nfs4_do_setlk(state, cmd, request, NFS_LOCK_NEW);
+	if (status)
+		goto out;
+
+	down_read(&nfsi->rwsem);
+	request->fl_flags &= ~(FL_SLEEP | FL_ACCESS);
+	status = locks_lock_inode_wait(state->inode, request);
+	up_read(&nfsi->rwsem);
 out:
 	request->fl_flags = fl_flags;
 	return status;
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index ec796b85938e3..31d77c029bc33 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -563,7 +563,6 @@ struct nfs_lock_args {
 	struct nfs_lowner	lock_owner;
 	unsigned char		block : 1;
 	unsigned char		reclaim : 1;
-	unsigned char		new_lock : 1;
 	unsigned char		new_lock_owner : 1;
 };
 
-- 
2.53.0



