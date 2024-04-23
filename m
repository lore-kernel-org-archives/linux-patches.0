Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411E9143C5F;
	Tue, 23 Apr 2024 21:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908771; cv=none; b=nMnarLIsRz0T/YWZVh1ZOibkwbV5dLGBr0SF4hMeUC6wEtlvmMcSFPIi12m4wVbNcDaxm6XfPh68Z5GOcN8sxlxeyQXsWQpoj404rRvx4plnbQUCkRwtMO+0R6e66eK8W7Kg57P/n2pEF8/udxcJ9JwJ694DvB/RFjrLpxicDH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908771; c=relaxed/simple;
	bh=fynO7DWlZL0R67QWeqB+0uCbpAUK+yKrqXOij8Kv5qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnuOgfeUawjSUvSujzQT8BJbUQsWB7ihekzKrd0VZ71zHNMUvFwXNXPQXA6o5KylwIAzrK38cpisfcFpu0/0pKQyA5gVBhFdwaFZcHiggviIIeKUeCE8NRRViXttznXXjmKV5CpjrIXe+E4SXAqLquGg7j1xaT+BGFFG3XBiUgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=daY3AsVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="daY3AsVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6F2C32782;
	Tue, 23 Apr 2024 21:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908771;
	bh=fynO7DWlZL0R67QWeqB+0uCbpAUK+yKrqXOij8Kv5qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=daY3AsVJSvuyf1sZtzPg0m0q8/zaPjtDnC1tRLImKehGa5ARumLBpl0eM3WQQlPZU
	 tipw2JMaDKDCUc4naxgfOURiFJmlttWknNOr4H5kLfsP5QBZY1YohffVDx4pEZOVc6
	 jw9gmxWXbGL+UB7nx5FDT5G3liE1j+cOoyVgVUUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 14/71] Revert "lockd: introduce safe async lock op"
Date: Tue, 23 Apr 2024 14:39:27 -0700
Message-ID: <20240423213844.611210465@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

This reverts commit 2267b2e84593bd3d61a1188e68fba06307fa9dab.

ltp test fcntl17 fails on v5.15.154. This was bisected to commit
2267b2e84593 ("lockd: introduce safe async lock op").

Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/filesystems/nfs/exporting.rst |    7 -------
 fs/lockd/svclock.c                          |    4 +++-
 fs/nfsd/nfs4state.c                         |   10 +++-------
 include/linux/exportfs.h                    |   14 --------------
 4 files changed, 6 insertions(+), 29 deletions(-)

--- a/Documentation/filesystems/nfs/exporting.rst
+++ b/Documentation/filesystems/nfs/exporting.rst
@@ -241,10 +241,3 @@ following flags are defined:
     all of an inode's dirty data on last close. Exports that behave this
     way should set EXPORT_OP_FLUSH_ON_CLOSE so that NFSD knows to skip
     waiting for writeback when closing such files.
-
-  EXPORT_OP_ASYNC_LOCK - Indicates a capable filesystem to do async lock
-    requests from lockd. Only set EXPORT_OP_ASYNC_LOCK if the filesystem has
-    it's own ->lock() functionality as core posix_lock_file() implementation
-    has no async lock request handling yet. For more information about how to
-    indicate an async lock request from a ->lock() file_operations struct, see
-    fs/locks.c and comment for the function vfs_lock_file().
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -470,7 +470,9 @@ nlmsvc_lock(struct svc_rqst *rqstp, stru
 	    struct nlm_host *host, struct nlm_lock *lock, int wait,
 	    struct nlm_cookie *cookie, int reclaim)
 {
+#if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
 	struct inode		*inode = nlmsvc_file_inode(file);
+#endif
 	struct nlm_block	*block = NULL;
 	int			error;
 	int			mode;
@@ -484,7 +486,7 @@ nlmsvc_lock(struct svc_rqst *rqstp, stru
 				(long long)lock->fl.fl_end,
 				wait);
 
-	if (!exportfs_lock_op_is_async(inode->i_sb->s_export_op)) {
+	if (nlmsvc_file_file(file)->f_op->lock) {
 		async_block = wait;
 		wait = 0;
 	}
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7420,7 +7420,6 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 	struct nfsd4_blocked_lock *nbl = NULL;
 	struct file_lock *file_lock = NULL;
 	struct file_lock *conflock = NULL;
-	struct super_block *sb;
 	__be32 status = 0;
 	int lkflg;
 	int err;
@@ -7442,7 +7441,6 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 		dprintk("NFSD: nfsd4_lock: permission denied!\n");
 		return status;
 	}
-	sb = cstate->current_fh.fh_dentry->d_sb;
 
 	if (lock->lk_is_new) {
 		if (nfsd4_has_session(cstate))
@@ -7494,8 +7492,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 	fp = lock_stp->st_stid.sc_file;
 	switch (lock->lk_type) {
 		case NFS4_READW_LT:
-			if (nfsd4_has_session(cstate) ||
-			    exportfs_lock_op_is_async(sb->s_export_op))
+			if (nfsd4_has_session(cstate))
 				fl_flags |= FL_SLEEP;
 			fallthrough;
 		case NFS4_READ_LT:
@@ -7507,8 +7504,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 			fl_type = F_RDLCK;
 			break;
 		case NFS4_WRITEW_LT:
-			if (nfsd4_has_session(cstate) ||
-			    exportfs_lock_op_is_async(sb->s_export_op))
+			if (nfsd4_has_session(cstate))
 				fl_flags |= FL_SLEEP;
 			fallthrough;
 		case NFS4_WRITE_LT:
@@ -7536,7 +7532,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 	 * for file locks), so don't attempt blocking lock notifications
 	 * on those filesystems:
 	 */
-	if (!exportfs_lock_op_is_async(sb->s_export_op))
+	if (nf->nf_file->f_op->lock)
 		fl_flags &= ~FL_SLEEP;
 
 	nbl = find_or_allocate_block(lock_sop, &fp->fi_fhandle, nn);
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -222,23 +222,9 @@ struct export_operations {
 						  atomic attribute updates
 						*/
 #define EXPORT_OP_FLUSH_ON_CLOSE	(0x20) /* fs flushes file data on close */
-#define EXPORT_OP_ASYNC_LOCK		(0x40) /* fs can do async lock request */
 	unsigned long	flags;
 };
 
-/**
- * exportfs_lock_op_is_async() - export op supports async lock operation
- * @export_ops:	the nfs export operations to check
- *
- * Returns true if the nfs export_operations structure has
- * EXPORT_OP_ASYNC_LOCK in their flags set
- */
-static inline bool
-exportfs_lock_op_is_async(const struct export_operations *export_ops)
-{
-	return export_ops->flags & EXPORT_OP_ASYNC_LOCK;
-}
-
 extern int exportfs_encode_inode_fh(struct inode *inode, struct fid *fid,
 				    int *max_len, struct inode *parent);
 extern int exportfs_encode_fh(struct dentry *dentry, struct fid *fid,


