Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5CD1A3BB8;
	Tue, 18 Jun 2024 13:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716455; cv=none; b=uCwF29Xd05s6M0d7aC6jFMnzIpeKcXRUQsUME0ID4BTXBmh+QQpir8nbCDlbYC8jk4NisR6iEav3IUnYzxbysJvZCc5CrgHRwmSkcQCTUQoxaoP3HzYzyp9pg00btYPQcyxuSa+mVltbvVsljT+NwJectkagujPKQAY8zN5p03E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716455; c=relaxed/simple;
	bh=DTCBkaNYgeLaT7nQNo1iFcuDwZpZ2cEMLBvhiJg/n1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2/ffGRRoG61EzypzkWpEW2GrpaMO69p7DIz3pfo/9LwrMaE3OO+Fzlffr8X8meJvC3mVJ5wZhUCyns1hjuo7z/NZkXB/mQsM2JlQsDOTRIe6j+BlxO+aqzIxKXJM64b92V/3bRYgRo+8m7VPl9equeJIT4427lclZUfSonaTv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZYtIAJmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZYtIAJmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24219C3277B;
	Tue, 18 Jun 2024 13:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716455;
	bh=DTCBkaNYgeLaT7nQNo1iFcuDwZpZ2cEMLBvhiJg/n1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZYtIAJmJFZdYg+g5nOKCaUU6kHTfIv7a6o0Voo+jaGtaWwSx8Gt0wdBayznHsqUH/
	 OcfUQSBjcA6bxuER6P8foMFpGqOQWxtojt81Iixg8PuzRNY0StzBNeSVMd21+OJJLA
	 MUHYFgpxOYWj7a4WKWcSQQdFSniQ3Zh4qHIJWK1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 621/770] NFSD: use (un)lock_inode instead of fh_(un)lock for file operations
Date: Tue, 18 Jun 2024 14:37:54 +0200
Message-ID: <20240618123431.257238215@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit bb4d53d66e4b8c8b8e5634802262e53851a2d2db ]

When locking a file to access ACLs and xattrs etc, use explicit locking
with inode_lock() instead of fh_lock().  This means that the calls to
fh_fill_pre/post_attr() are also explicit which improves readability and
allows us to place them only where they are needed.  Only the xattr
calls need pre/post information.

When locking a file we don't need I_MUTEX_PARENT as the file is not a
parent of anything, so we can use inode_lock() directly rather than the
inode_lock_nested() call that fh_lock() uses.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: NeilBrown <neilb@suse.de>
[ cel: backported to 5.10.y, prior to idmapped mounts ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c   |  6 +++---
 fs/nfsd/nfs3acl.c   |  4 ++--
 fs/nfsd/nfs4state.c |  9 +++++----
 fs/nfsd/vfs.c       | 44 +++++++++++++++++++++-----------------------
 4 files changed, 31 insertions(+), 32 deletions(-)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index 03703b22c81ef..f7d166f056afa 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -111,7 +111,7 @@ static __be32 nfsacld_proc_setacl(struct svc_rqst *rqstp)
 	if (error)
 		goto out_errno;
 
-	fh_lock(fh);
+	inode_lock(inode);
 
 	error = set_posix_acl(inode, ACL_TYPE_ACCESS, argp->acl_access);
 	if (error)
@@ -120,7 +120,7 @@ static __be32 nfsacld_proc_setacl(struct svc_rqst *rqstp)
 	if (error)
 		goto out_drop_lock;
 
-	fh_unlock(fh);
+	inode_unlock(inode);
 
 	fh_drop_write(fh);
 
@@ -134,7 +134,7 @@ static __be32 nfsacld_proc_setacl(struct svc_rqst *rqstp)
 	return rpc_success;
 
 out_drop_lock:
-	fh_unlock(fh);
+	inode_unlock(inode);
 	fh_drop_write(fh);
 out_errno:
 	resp->status = nfserrno(error);
diff --git a/fs/nfsd/nfs3acl.c b/fs/nfsd/nfs3acl.c
index 350fae92ae045..15bee0339c764 100644
--- a/fs/nfsd/nfs3acl.c
+++ b/fs/nfsd/nfs3acl.c
@@ -101,7 +101,7 @@ static __be32 nfsd3_proc_setacl(struct svc_rqst *rqstp)
 	if (error)
 		goto out_errno;
 
-	fh_lock(fh);
+	inode_lock(inode);
 
 	error = set_posix_acl(inode, ACL_TYPE_ACCESS, argp->acl_access);
 	if (error)
@@ -109,7 +109,7 @@ static __be32 nfsd3_proc_setacl(struct svc_rqst *rqstp)
 	error = set_posix_acl(inode, ACL_TYPE_DEFAULT, argp->acl_default);
 
 out_drop_lock:
-	fh_unlock(fh);
+	inode_unlock(inode);
 	fh_drop_write(fh);
 out_errno:
 	resp->status = nfserrno(error);
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index e44d9c8d5065a..7a4baa41b5362 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7429,21 +7429,22 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 static __be32 nfsd_test_lock(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file_lock *lock)
 {
 	struct nfsd_file *nf;
+	struct inode *inode;
 	__be32 err;
 
 	err = nfsd_file_acquire(rqstp, fhp, NFSD_MAY_READ, &nf);
 	if (err)
 		return err;
-	fh_lock(fhp); /* to block new leases till after test_lock: */
-	err = nfserrno(nfsd_open_break_lease(fhp->fh_dentry->d_inode,
-							NFSD_MAY_READ));
+	inode = fhp->fh_dentry->d_inode;
+	inode_lock(inode); /* to block new leases till after test_lock: */
+	err = nfserrno(nfsd_open_break_lease(inode, NFSD_MAY_READ));
 	if (err)
 		goto out;
 	lock->fl_file = nf->nf_file;
 	err = nfserrno(vfs_test_lock(nf->nf_file, lock));
 	lock->fl_file = NULL;
 out:
-	fh_unlock(fhp);
+	inode_unlock(inode);
 	nfsd_file_put(nf);
 	return err;
 }
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 3364e562b00e5..504a3ddfaf75b 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -429,7 +429,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			return err;
 	}
 
-	fh_lock(fhp);
+	inode_lock(inode);
 	if (size_change) {
 		/*
 		 * RFC5661, Section 18.30.4:
@@ -475,7 +475,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	    !attr->na_aclerr && attr->na_dpacl && S_ISDIR(inode->i_mode))
 		attr->na_aclerr = set_posix_acl(inode, ACL_TYPE_DEFAULT,
 						attr->na_dpacl);
-	fh_unlock(fhp);
+	inode_unlock(inode);
 	if (size_change)
 		put_write_access(inode);
 out:
@@ -1565,18 +1565,10 @@ nfsd_link(struct svc_rqst *rqstp, struct svc_fh *ffhp,
 	err = nfserr_noent;
 	if (d_really_is_negative(dold))
 		goto out_dput;
-<<<<<<< current
-	host_err = vfs_link(dold, dirp, dnew, NULL);
-	fh_unlock(ffhp);
-||||||| constructed merge base
-	host_err = vfs_link(dold, &init_user_ns, dirp, dnew, NULL);
-	fh_unlock(ffhp);
-=======
 	fh_fill_pre_attrs(ffhp);
-	host_err = vfs_link(dold, &init_user_ns, dirp, dnew, NULL);
+	host_err = vfs_link(dold, dirp, dnew, NULL);
 	fh_fill_post_attrs(ffhp);
 	inode_unlock(dirp);
->>>>>>> patched
 	if (!host_err) {
 		err = nfserrno(commit_metadata(ffhp));
 		if (!err)
@@ -2177,13 +2169,16 @@ nfsd_listxattr(struct svc_rqst *rqstp, struct svc_fh *fhp, char **bufp,
 	return err;
 }
 
-/*
- * Removexattr and setxattr need to call fh_lock to both lock the inode
- * and set the change attribute. Since the top-level vfs_removexattr
- * and vfs_setxattr calls already do their own inode_lock calls, call
- * the _locked variant. Pass in a NULL pointer for delegated_inode,
- * and let the client deal with NFS4ERR_DELAY (same as with e.g.
- * setattr and remove).
+/**
+ * nfsd_removexattr - Remove an extended attribute
+ * @rqstp: RPC transaction being executed
+ * @fhp: NFS filehandle of object with xattr to remove
+ * @name: name of xattr to remove (NUL-terminate)
+ *
+ * Pass in a NULL pointer for delegated_inode, and let the client deal
+ * with NFS4ERR_DELAY (same as with e.g. setattr and remove).
+ *
+ * Returns nfs_ok on success, or an nfsstat in network byte order.
  */
 __be32
 nfsd_removexattr(struct svc_rqst *rqstp, struct svc_fh *fhp, char *name)
@@ -2199,11 +2194,13 @@ nfsd_removexattr(struct svc_rqst *rqstp, struct svc_fh *fhp, char *name)
 	if (ret)
 		return nfserrno(ret);
 
-	fh_lock(fhp);
+	inode_lock(fhp->fh_dentry->d_inode);
+	fh_fill_pre_attrs(fhp);
 
 	ret = __vfs_removexattr_locked(fhp->fh_dentry, name, NULL);
 
-	fh_unlock(fhp);
+	fh_fill_post_attrs(fhp);
+	inode_unlock(fhp->fh_dentry->d_inode);
 	fh_drop_write(fhp);
 
 	return nfsd_xattr_errno(ret);
@@ -2223,12 +2220,13 @@ nfsd_setxattr(struct svc_rqst *rqstp, struct svc_fh *fhp, char *name,
 	ret = fh_want_write(fhp);
 	if (ret)
 		return nfserrno(ret);
-	fh_lock(fhp);
+	inode_lock(fhp->fh_dentry->d_inode);
+	fh_fill_pre_attrs(fhp);
 
 	ret = __vfs_setxattr_locked(fhp->fh_dentry, name, buf, len, flags,
 				    NULL);
-
-	fh_unlock(fhp);
+	fh_fill_post_attrs(fhp);
+	inode_unlock(fhp->fh_dentry->d_inode);
 	fh_drop_write(fhp);
 
 	return nfsd_xattr_errno(ret);
-- 
2.43.0



