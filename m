Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFED534A3D6;
	Wed, 21 Jan 2026 18:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020242; cv=none; b=CiU5/9VJBP3+Tpw3/wSe9SCHvt+ivj7GRefJWQgZjPN+ioooH7koRj3l0UPpBeCzkbW40ABnyBvCEXIB/B0sfWG+GReB/TaNJJiEXoqLV+ZoqFccOQi/UUWQfwmRUgow+AdDsLDikDztt4tRwMRkHRPlDt+8sByralN1ZTZtD64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020242; c=relaxed/simple;
	bh=my5o5ilu0S9IEiQjgUpa91pZiq2q26L+G5vVRwJzhHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I32yz/JsxZPlE6luLqQKrZ9ZxrU3ID4avY636IocMwINdnyNk93ymk+B0/c0WjosurquLUqsRT92R5FKsZ2fsmCeYWiB7sNkk6Lzq1nQkg0Id7+EnWaBqnv/Ikzc5Uw/k6P2QQijkYYCL1utdVHu0Wx/LAxeuEJeA6eq/4Xdbgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8Zw9r1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8Zw9r1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DA9C4CEF1;
	Wed, 21 Jan 2026 18:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020241;
	bh=my5o5ilu0S9IEiQjgUpa91pZiq2q26L+G5vVRwJzhHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l8Zw9r1sWiTh4cr2pdBVlMRBW1P5JemvQG2uyJnzi4L15/smlz6S+A8kKGsOQNdjt
	 p0l6CDzmWWuznU+lwluZife5QW/DzzMKNn/zNuvarrhYO9FrQrjgTAz7m5QgYeKNWs
	 N55X/zrs6PAX/XjnBZYb+0kKFURWuc+vfJfW4lSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 068/198] NFS: Fix size read races in truncate, fallocate and copy offload
Date: Wed, 21 Jan 2026 19:14:56 +0100
Message-ID: <20260121181421.007191209@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit d5811e6297f3fd9020ac31f51fc317dfdb260cb0 ]

If the pre-operation file size is read before locking the inode and
quiescing O_DIRECT writes, then nfs_truncate_last_folio() might end up
overwriting valid file data.

Fixes: b1817b18ff20 ("NFS: Protect against 'eof page pollution'")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c     | 10 ++++++----
 fs/nfs/io.c        |  2 ++
 fs/nfs/nfs42proc.c | 29 +++++++++++++++++++----------
 3 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 13ad70fc00d84..8c2bfcc323e02 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -716,7 +716,7 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 {
 	struct inode *inode = d_inode(dentry);
 	struct nfs_fattr *fattr;
-	loff_t oldsize = i_size_read(inode);
+	loff_t oldsize;
 	int error = 0;
 	kuid_t task_uid = current_fsuid();
 	kuid_t owner_uid = inode->i_uid;
@@ -727,6 +727,10 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (attr->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
 		attr->ia_valid &= ~ATTR_MODE;
 
+	if (S_ISREG(inode->i_mode))
+		nfs_file_block_o_direct(NFS_I(inode));
+
+	oldsize = i_size_read(inode);
 	if (attr->ia_valid & ATTR_SIZE) {
 		BUG_ON(!S_ISREG(inode->i_mode));
 
@@ -774,10 +778,8 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	trace_nfs_setattr_enter(inode);
 
 	/* Write all dirty data */
-	if (S_ISREG(inode->i_mode)) {
-		nfs_file_block_o_direct(NFS_I(inode));
+	if (S_ISREG(inode->i_mode))
 		nfs_sync_inode(inode);
-	}
 
 	fattr = nfs_alloc_fattr_with_label(NFS_SERVER(inode));
 	if (fattr == NULL) {
diff --git a/fs/nfs/io.c b/fs/nfs/io.c
index d275b0a250bf3..8337f0ae852d4 100644
--- a/fs/nfs/io.c
+++ b/fs/nfs/io.c
@@ -84,6 +84,7 @@ nfs_start_io_write(struct inode *inode)
 		nfs_file_block_o_direct(NFS_I(inode));
 	return err;
 }
+EXPORT_SYMBOL_GPL(nfs_start_io_write);
 
 /**
  * nfs_end_io_write - declare that the buffered write operation is done
@@ -97,6 +98,7 @@ nfs_end_io_write(struct inode *inode)
 {
 	up_write(&inode->i_rwsem);
 }
+EXPORT_SYMBOL_GPL(nfs_end_io_write);
 
 /* Call with exclusively locked inode->i_rwsem */
 static void nfs_block_buffered(struct nfs_inode *nfsi, struct inode *inode)
diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index d537fb0c230e8..c08520828708b 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -114,7 +114,6 @@ static int nfs42_proc_fallocate(struct rpc_message *msg, struct file *filep,
 	exception.inode = inode;
 	exception.state = lock->open_context->state;
 
-	nfs_file_block_o_direct(NFS_I(inode));
 	err = nfs_sync_inode(inode);
 	if (err)
 		goto out;
@@ -138,13 +137,17 @@ int nfs42_proc_allocate(struct file *filep, loff_t offset, loff_t len)
 		.rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_ALLOCATE],
 	};
 	struct inode *inode = file_inode(filep);
-	loff_t oldsize = i_size_read(inode);
+	loff_t oldsize;
 	int err;
 
 	if (!nfs_server_capable(inode, NFS_CAP_ALLOCATE))
 		return -EOPNOTSUPP;
 
-	inode_lock(inode);
+	err = nfs_start_io_write(inode);
+	if (err)
+		return err;
+
+	oldsize = i_size_read(inode);
 
 	err = nfs42_proc_fallocate(&msg, filep, offset, len);
 
@@ -155,7 +158,7 @@ int nfs42_proc_allocate(struct file *filep, loff_t offset, loff_t len)
 		NFS_SERVER(inode)->caps &= ~(NFS_CAP_ALLOCATE |
 					     NFS_CAP_ZERO_RANGE);
 
-	inode_unlock(inode);
+	nfs_end_io_write(inode);
 	return err;
 }
 
@@ -170,7 +173,9 @@ int nfs42_proc_deallocate(struct file *filep, loff_t offset, loff_t len)
 	if (!nfs_server_capable(inode, NFS_CAP_DEALLOCATE))
 		return -EOPNOTSUPP;
 
-	inode_lock(inode);
+	err = nfs_start_io_write(inode);
+	if (err)
+		return err;
 
 	err = nfs42_proc_fallocate(&msg, filep, offset, len);
 	if (err == 0)
@@ -179,7 +184,7 @@ int nfs42_proc_deallocate(struct file *filep, loff_t offset, loff_t len)
 		NFS_SERVER(inode)->caps &= ~(NFS_CAP_DEALLOCATE |
 					     NFS_CAP_ZERO_RANGE);
 
-	inode_unlock(inode);
+	nfs_end_io_write(inode);
 	return err;
 }
 
@@ -189,14 +194,17 @@ int nfs42_proc_zero_range(struct file *filep, loff_t offset, loff_t len)
 		.rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_ZERO_RANGE],
 	};
 	struct inode *inode = file_inode(filep);
-	loff_t oldsize = i_size_read(inode);
+	loff_t oldsize;
 	int err;
 
 	if (!nfs_server_capable(inode, NFS_CAP_ZERO_RANGE))
 		return -EOPNOTSUPP;
 
-	inode_lock(inode);
+	err = nfs_start_io_write(inode);
+	if (err)
+		return err;
 
+	oldsize = i_size_read(inode);
 	err = nfs42_proc_fallocate(&msg, filep, offset, len);
 	if (err == 0) {
 		nfs_truncate_last_folio(inode->i_mapping, oldsize,
@@ -205,7 +213,7 @@ int nfs42_proc_zero_range(struct file *filep, loff_t offset, loff_t len)
 	} else if (err == -EOPNOTSUPP)
 		NFS_SERVER(inode)->caps &= ~NFS_CAP_ZERO_RANGE;
 
-	inode_unlock(inode);
+	nfs_end_io_write(inode);
 	return err;
 }
 
@@ -416,7 +424,7 @@ static ssize_t _nfs42_proc_copy(struct file *src,
 	struct nfs_server *src_server = NFS_SERVER(src_inode);
 	loff_t pos_src = args->src_pos;
 	loff_t pos_dst = args->dst_pos;
-	loff_t oldsize_dst = i_size_read(dst_inode);
+	loff_t oldsize_dst;
 	size_t count = args->count;
 	ssize_t status;
 
@@ -461,6 +469,7 @@ static ssize_t _nfs42_proc_copy(struct file *src,
 		&src_lock->open_context->state->flags);
 	set_bit(NFS_CLNT_DST_SSC_COPY_STATE,
 		&dst_lock->open_context->state->flags);
+	oldsize_dst = i_size_read(dst_inode);
 
 	status = nfs4_call_sync(dst_server->client, dst_server, &msg,
 				&args->seq_args, &res->seq_res, 0);
-- 
2.51.0



