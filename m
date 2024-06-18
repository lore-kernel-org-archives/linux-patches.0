Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFCE15747D;
	Tue, 18 Jun 2024 13:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715865; cv=none; b=cRl5Yyc9sMe1jce83QLhwuWH9aC7Qb4+P/ESnk/a0PWJ67hzE8kBRuwQ21GomHwRXWZtBP+UpaK2T0UWE5EdYB18PVgEbz9DUm+ajtybNnw+zWX7a3p/KeIlS3iCOu4XLnC6evhJUBtsvCcKUcMmkPu/4srt26Gm22SsOc8rnPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715865; c=relaxed/simple;
	bh=zi7w7ZVu5zlYmZHSaEDjsUIXXdLvdZXKWkoezBYB4EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTCRsyZIGKw8VhDUq4EpvZpE+qmRYxJ4Kzbw5hQngeK7LTsXgaqlbsJ3hjRBb0y+31G6aZZOyoxEfy0Bsvm6b4FwxTeDF/EGvGDyatJE2DrF5dWSVqv4C4Jm/eGB+riETqt8hWlkK8DoHKa31MDX6sso5xpmXs05VByu1J6wrC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WEeMI79I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WEeMI79I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D0AC3277B;
	Tue, 18 Jun 2024 13:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715864;
	bh=zi7w7ZVu5zlYmZHSaEDjsUIXXdLvdZXKWkoezBYB4EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WEeMI79I9CGaRq/S4b27ByvVEr/tTL6PbEnv+4jt8q7UK9OKAO3Aov1ENxdL7QpJw
	 TFiEoD5ll9FYpPQFX7phlGdDvi0/gcT9ukOrq93o3q6RFqg/oOO8EPY70O+THVtexG
	 iJF1RXtvWpeFu8DNMNlR1XJiT3TADiZlv/kn2hyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Averin <vvs@virtuozzo.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 445/770] nfs: block notification on fs with its own ->lock
Date: Tue, 18 Jun 2024 14:34:58 +0200
Message-ID: <20240618123424.467052942@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index 40beac65d1355..b347e3ce0cc8e 100644
--- a/fs/nfs/export.c
+++ b/fs/nfs/export.c
@@ -184,5 +184,5 @@ const struct export_operations nfs_export_ops = {
 	.fetch_iversion = nfs_fetch_iversion,
 	.flags = EXPORT_OP_NOWCC|EXPORT_OP_NOSUBTREECHK|
 		EXPORT_OP_CLOSE_BEFORE_UNLINK|EXPORT_OP_REMOTE_FS|
-		EXPORT_OP_NOATOMIC_ATTR|EXPORT_OP_SYNC_LOCKS,
+		EXPORT_OP_NOATOMIC_ATTR,
 };
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 3b8c5f2283975..36ae55fbfbc67 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6884,7 +6884,6 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	struct nfsd4_blocked_lock *nbl = NULL;
 	struct file_lock *file_lock = NULL;
 	struct file_lock *conflock = NULL;
-	struct super_block *sb;
 	__be32 status = 0;
 	int lkflg;
 	int err;
@@ -6906,7 +6905,6 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		dprintk("NFSD: nfsd4_lock: permission denied!\n");
 		return status;
 	}
-	sb = cstate->current_fh.fh_dentry->d_sb;
 
 	if (lock->lk_is_new) {
 		if (nfsd4_has_session(cstate))
@@ -6958,8 +6956,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	fp = lock_stp->st_stid.sc_file;
 	switch (lock->lk_type) {
 		case NFS4_READW_LT:
-			if (nfsd4_has_session(cstate) &&
-			    !(sb->s_export_op->flags & EXPORT_OP_SYNC_LOCKS))
+			if (nfsd4_has_session(cstate))
 				fl_flags |= FL_SLEEP;
 			fallthrough;
 		case NFS4_READ_LT:
@@ -6971,8 +6968,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			fl_type = F_RDLCK;
 			break;
 		case NFS4_WRITEW_LT:
-			if (nfsd4_has_session(cstate) &&
-			    !(sb->s_export_op->flags & EXPORT_OP_SYNC_LOCKS))
+			if (nfsd4_has_session(cstate))
 				fl_flags |= FL_SLEEP;
 			fallthrough;
 		case NFS4_WRITE_LT:
@@ -6993,6 +6989,16 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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



