Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6441F26AC7;
	Mon,  8 Apr 2024 14:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584856; cv=none; b=NMH6I9xL1zqpBo4b5I2i5h8ycnmgT456VMFmmTdp5Tp0xOZgJcPEcY2FfLqbU//AhjoufCREwx3EGVm1IvmtskC6FlR6Sjc6UDmAAmy8QDVrwi7W4y2wZGqFWpn/AUeoN8rcKeMz0eFWb8Rwt6hhgMopAOSjNLfQAbTPpN5FmXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584856; c=relaxed/simple;
	bh=ImG+49ZD2HWAVsSDg9jdf0EHlDHLdvX5DTgAYyK/+8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FH2dutA5JC4Uf6UqsX/etU/chNBttOkWabDaPL1nqvCjgBVVkDxGZ8KMcSHu0n9WntRYiUw3u02zrpDY32o0Sub+khsO37eaTIcX62dUvubj2Mq86a0/zXFsl5TqeV1gpwS4S+6R6LKZxLIUVJ4zx513EiTP7MSreeY3vU9pWsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kAuLZDTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAuLZDTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E194DC433C7;
	Mon,  8 Apr 2024 14:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584856;
	bh=ImG+49ZD2HWAVsSDg9jdf0EHlDHLdvX5DTgAYyK/+8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAuLZDTAwYCYESMprgE8lbCpG1oFJ2UgC0n5e4i6fXu/1EAvNIFHQKbVIZYxiSzJv
	 sfqxFjrDGQhLd65VaM06DDxoul/s/vicPY5L4ozBchwwUjKSJ895bgAX5w60ij/0+0
	 TwZx7pw7pD/YIBLaZH9Av52gpVFKpbgbUGMJKrvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Alexander Aring <aahringo@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 550/690] lockd: introduce safe async lock op
Date: Mon,  8 Apr 2024 14:56:56 +0200
Message-ID: <20240408125419.552639375@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 2dd10de8e6bcbacf85ad758b904543c294820c63 ]

This patch reverts mostly commit 40595cdc93ed ("nfs: block notification
on fs with its own ->lock") and introduces an EXPORT_OP_ASYNC_LOCK
export flag to signal that the "own ->lock" implementation supports
async lock requests. The only main user is DLM that is used by GFS2 and
OCFS2 filesystem. Those implement their own lock() implementation and
return FILE_LOCK_DEFERRED as return value. Since commit 40595cdc93ed
("nfs: block notification on fs with its own ->lock") the DLM
implementation were never updated. This patch should prepare for DLM
to set the EXPORT_OP_ASYNC_LOCK export flag and update the DLM
plock implementation regarding to it.

Acked-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 Documentation/filesystems/nfs/exporting.rst |  7 +++++++
 fs/lockd/svclock.c                          |  4 +---
 fs/nfsd/nfs4state.c                         | 10 +++++++---
 include/linux/exportfs.h                    | 14 ++++++++++++++
 4 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/nfs/exporting.rst b/Documentation/filesystems/nfs/exporting.rst
index 6f59a364f84cd..6a1cbd7de38df 100644
--- a/Documentation/filesystems/nfs/exporting.rst
+++ b/Documentation/filesystems/nfs/exporting.rst
@@ -241,3 +241,10 @@ following flags are defined:
     all of an inode's dirty data on last close. Exports that behave this
     way should set EXPORT_OP_FLUSH_ON_CLOSE so that NFSD knows to skip
     waiting for writeback when closing such files.
+
+  EXPORT_OP_ASYNC_LOCK - Indicates a capable filesystem to do async lock
+    requests from lockd. Only set EXPORT_OP_ASYNC_LOCK if the filesystem has
+    it's own ->lock() functionality as core posix_lock_file() implementation
+    has no async lock request handling yet. For more information about how to
+    indicate an async lock request from a ->lock() file_operations struct, see
+    fs/locks.c and comment for the function vfs_lock_file().
diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index 4e30f3c509701..55c0a03311884 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -470,9 +470,7 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file *file,
 	    struct nlm_host *host, struct nlm_lock *lock, int wait,
 	    struct nlm_cookie *cookie, int reclaim)
 {
-#if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
 	struct inode		*inode = nlmsvc_file_inode(file);
-#endif
 	struct nlm_block	*block = NULL;
 	int			error;
 	int			mode;
@@ -486,7 +484,7 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file *file,
 				(long long)lock->fl.fl_end,
 				wait);
 
-	if (nlmsvc_file_file(file)->f_op->lock) {
+	if (!exportfs_lock_op_is_async(inode->i_sb->s_export_op)) {
 		async_block = wait;
 		wait = 0;
 	}
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 69bc4622a95a4..4d95b2052c31a 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7424,6 +7424,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	struct nfsd4_blocked_lock *nbl = NULL;
 	struct file_lock *file_lock = NULL;
 	struct file_lock *conflock = NULL;
+	struct super_block *sb;
 	__be32 status = 0;
 	int lkflg;
 	int err;
@@ -7445,6 +7446,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		dprintk("NFSD: nfsd4_lock: permission denied!\n");
 		return status;
 	}
+	sb = cstate->current_fh.fh_dentry->d_sb;
 
 	if (lock->lk_is_new) {
 		if (nfsd4_has_session(cstate))
@@ -7496,7 +7498,8 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	fp = lock_stp->st_stid.sc_file;
 	switch (lock->lk_type) {
 		case NFS4_READW_LT:
-			if (nfsd4_has_session(cstate))
+			if (nfsd4_has_session(cstate) ||
+			    exportfs_lock_op_is_async(sb->s_export_op))
 				fl_flags |= FL_SLEEP;
 			fallthrough;
 		case NFS4_READ_LT:
@@ -7508,7 +7511,8 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			fl_type = F_RDLCK;
 			break;
 		case NFS4_WRITEW_LT:
-			if (nfsd4_has_session(cstate))
+			if (nfsd4_has_session(cstate) ||
+			    exportfs_lock_op_is_async(sb->s_export_op))
 				fl_flags |= FL_SLEEP;
 			fallthrough;
 		case NFS4_WRITE_LT:
@@ -7536,7 +7540,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	 * for file locks), so don't attempt blocking lock notifications
 	 * on those filesystems:
 	 */
-	if (nf->nf_file->f_op->lock)
+	if (!exportfs_lock_op_is_async(sb->s_export_op))
 		fl_flags &= ~FL_SLEEP;
 
 	nbl = find_or_allocate_block(lock_sop, &fp->fi_fhandle, nn);
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index 218fc5c54e901..6525f4b7eb97f 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -222,9 +222,23 @@ struct export_operations {
 						  atomic attribute updates
 						*/
 #define EXPORT_OP_FLUSH_ON_CLOSE	(0x20) /* fs flushes file data on close */
+#define EXPORT_OP_ASYNC_LOCK		(0x40) /* fs can do async lock request */
 	unsigned long	flags;
 };
 
+/**
+ * exportfs_lock_op_is_async() - export op supports async lock operation
+ * @export_ops:	the nfs export operations to check
+ *
+ * Returns true if the nfs export_operations structure has
+ * EXPORT_OP_ASYNC_LOCK in their flags set
+ */
+static inline bool
+exportfs_lock_op_is_async(const struct export_operations *export_ops)
+{
+	return export_ops->flags & EXPORT_OP_ASYNC_LOCK;
+}
+
 extern int exportfs_encode_inode_fh(struct inode *inode, struct fid *fid,
 				    int *max_len, struct inode *parent);
 extern int exportfs_encode_fh(struct dentry *dentry, struct fid *fid,
-- 
2.43.0



