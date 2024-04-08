Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5D212E1DB;
	Mon,  8 Apr 2024 13:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583485; cv=none; b=eItjptQ2gk4y+RR4RY59vEX0GvetD0xHYaINmNlyYha4MsovKhF1Vh73cC/uXL/E9b54+WEZmW0P440tDwHicAa5SykpSVI2RGDiMR3/hUUJ2zDinGwK3CmUOCeNohuUKpR4P2+q1dgUMj7MVnA1ohGulOka9So/XrldBtIk5Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583485; c=relaxed/simple;
	bh=RfPC1jf7h55mxD0EI8/pLlfckm7Z2TNyK6TZJ659HKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsBAYvBEO+kChnVjspROUF1aiQdJ5sZ07Pc2uj8PYQpnQc2kddW9VdWn4iZI9Y51s473Eqbf1ec4lIZHj/lpPr/1V8zBz+Dni6LH05GRW7j7GJ5ipuFOpS3I4IjwGLe2/dp2Xa3b6VoHMHOzc0pY4hHv1K313a8uOaEznXY1aqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjmC/K0R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjmC/K0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD36C43390;
	Mon,  8 Apr 2024 13:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583484;
	bh=RfPC1jf7h55mxD0EI8/pLlfckm7Z2TNyK6TZJ659HKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjmC/K0RHFalHLTO81LnUp7lkwzI0beTy0OiCP3NkzcikaVXvqjYEEBTh+VXMlgxs
	 xrCoxNwaFjz4REeSXcDZtPToRfnOWXbJ7oi4LLmkA4tNjy4+Jlal2n03kOU8asGoDS
	 RSyhw7QlQGlMr5HWQ78jHl93T0Tl7J8hpKvJtIqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Averin <vvs@virtuozzo.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 252/690] nfs: block notification on fs with its own ->lock
Date: Mon,  8 Apr 2024 14:51:58 +0200
Message-ID: <20240408125408.736432878@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 40595cdc93edf4110c0f0c0b06f8d82008f23929 ]

NFSv4.1 supports an optional lock notification feature which notifies
the client when a lock comes available.  (Normally NFSv4 clients just
poll for locks if necessary.)  To make that work, we need to request a
blocking lock from the filesystem.

We turned that off for NFS in commit f657f8eef3ff ("nfs: don't atempt
blocking locks on nfs reexports") [sic] because it actually blocks the
nfsd thread while waiting for the lock.

Thanks to Vasily Averin for pointing out that NFS isn't the only
filesystem with that problem.

Any filesystem that leaves ->lock NULL will use posix_lock_file(), which
does the right thing.  Simplest is just to assume that any filesystem
that defines its own ->lock is not safe to request a blocking lock from.

So, this patch mostly reverts commit f657f8eef3ff ("nfs: don't atempt
blocking locks on nfs reexports") [sic] and commit b840be2f00c0 ("lockd:
don't attempt blocking locks on nfs reexports"), and instead uses a
check of ->lock (Vasily's suggestion) to decide whether to support
blocking lock notifications on a given filesystem.  Also add a little
documentation.

Perhaps someday we could add back an export flag later to allow
filesystems with "good" ->lock methods to support blocking lock
notifications.

Reported-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[ cel: Description rewritten to address checkpatch nits ]
[ cel: Fixed warning when SUNRPC debugging is disabled ]
[ cel: Fixed NULL check ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/lockd/svclock.c          |  6 ++++--
 fs/nfs/export.c             |  2 +-
 fs/nfsd/nfs4state.c         | 18 ++++++++++++------
 include/linux/exportfs.h    |  2 --
 include/linux/lockd/lockd.h |  9 +++++++--
 5 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index e9b85d8fd5fe7..cb3658ab9b7ae 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -470,8 +470,10 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file *file,
 	    struct nlm_host *host, struct nlm_lock *lock, int wait,
 	    struct nlm_cookie *cookie, int reclaim)
 {
-	struct nlm_block	*block = NULL;
+#if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
 	struct inode		*inode = nlmsvc_file_inode(file);
+#endif
+	struct nlm_block	*block = NULL;
 	int			error;
 	int			mode;
 	int			async_block = 0;
@@ -484,7 +486,7 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file *file,
 				(long long)lock->fl.fl_end,
 				wait);
 
-	if (inode->i_sb->s_export_op->flags & EXPORT_OP_SYNC_LOCKS) {
+	if (nlmsvc_file_file(file)->f_op->lock) {
 		async_block = wait;
 		wait = 0;
 	}
diff --git a/fs/nfs/export.c b/fs/nfs/export.c
index d772c20bbfd15..37a1a88df7717 100644
--- a/fs/nfs/export.c
+++ b/fs/nfs/export.c
@@ -180,5 +180,5 @@ const struct export_operations nfs_export_ops = {
 	.fetch_iversion = nfs_fetch_iversion,
 	.flags = EXPORT_OP_NOWCC|EXPORT_OP_NOSUBTREECHK|
 		EXPORT_OP_CLOSE_BEFORE_UNLINK|EXPORT_OP_REMOTE_FS|
-		EXPORT_OP_NOATOMIC_ATTR|EXPORT_OP_SYNC_LOCKS,
+		EXPORT_OP_NOATOMIC_ATTR,
 };
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index f7e2beded6d7f..5ee11f0e24d3b 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6874,7 +6874,6 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	struct nfsd4_blocked_lock *nbl = NULL;
 	struct file_lock *file_lock = NULL;
 	struct file_lock *conflock = NULL;
-	struct super_block *sb;
 	__be32 status = 0;
 	int lkflg;
 	int err;
@@ -6896,7 +6895,6 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		dprintk("NFSD: nfsd4_lock: permission denied!\n");
 		return status;
 	}
-	sb = cstate->current_fh.fh_dentry->d_sb;
 
 	if (lock->lk_is_new) {
 		if (nfsd4_has_session(cstate))
@@ -6948,8 +6946,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	fp = lock_stp->st_stid.sc_file;
 	switch (lock->lk_type) {
 		case NFS4_READW_LT:
-			if (nfsd4_has_session(cstate) &&
-			    !(sb->s_export_op->flags & EXPORT_OP_SYNC_LOCKS))
+			if (nfsd4_has_session(cstate))
 				fl_flags |= FL_SLEEP;
 			fallthrough;
 		case NFS4_READ_LT:
@@ -6961,8 +6958,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			fl_type = F_RDLCK;
 			break;
 		case NFS4_WRITEW_LT:
-			if (nfsd4_has_session(cstate) &&
-			    !(sb->s_export_op->flags & EXPORT_OP_SYNC_LOCKS))
+			if (nfsd4_has_session(cstate))
 				fl_flags |= FL_SLEEP;
 			fallthrough;
 		case NFS4_WRITE_LT:
@@ -6983,6 +6979,16 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		goto out;
 	}
 
+	/*
+	 * Most filesystems with their own ->lock operations will block
+	 * the nfsd thread waiting to acquire the lock.  That leads to
+	 * deadlocks (we don't want every nfsd thread tied up waiting
+	 * for file locks), so don't attempt blocking lock notifications
+	 * on those filesystems:
+	 */
+	if (nf->nf_file->f_op->lock)
+		fl_flags &= ~FL_SLEEP;
+
 	nbl = find_or_allocate_block(lock_sop, &fp->fi_fhandle, nn);
 	if (!nbl) {
 		dprintk("NFSD: %s: unable to allocate block!\n", __func__);
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index 3260fe7148462..fe848901fcc3a 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -221,8 +221,6 @@ struct export_operations {
 #define EXPORT_OP_NOATOMIC_ATTR		(0x10) /* Filesystem cannot supply
 						  atomic attribute updates
 						*/
-#define EXPORT_OP_SYNC_LOCKS		(0x20) /* Filesystem can't do
-						  asychronous blocking locks */
 	unsigned long	flags;
 };
 
diff --git a/include/linux/lockd/lockd.h b/include/linux/lockd/lockd.h
index c4ae6506b8b36..fcef192e5e45e 100644
--- a/include/linux/lockd/lockd.h
+++ b/include/linux/lockd/lockd.h
@@ -303,10 +303,15 @@ void		  nlmsvc_invalidate_all(void);
 int           nlmsvc_unlock_all_by_sb(struct super_block *sb);
 int           nlmsvc_unlock_all_by_ip(struct sockaddr *server_addr);
 
+static inline struct file *nlmsvc_file_file(struct nlm_file *file)
+{
+	return file->f_file[O_RDONLY] ?
+	       file->f_file[O_RDONLY] : file->f_file[O_WRONLY];
+}
+
 static inline struct inode *nlmsvc_file_inode(struct nlm_file *file)
 {
-	return locks_inode(file->f_file[O_RDONLY] ?
-			   file->f_file[O_RDONLY] : file->f_file[O_WRONLY]);
+	return locks_inode(nlmsvc_file_file(file));
 }
 
 static inline int __nlm_privileged_request4(const struct sockaddr *sap)
-- 
2.43.0



