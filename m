Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0AD158DC4;
	Tue, 18 Jun 2024 13:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716452; cv=none; b=TBG/XkepPzMNSJ8qCPzZjyu55CV0ccdb/KnCaxNOKdhEnjJyk/JaDiu2/1fYuMe1eDyvxstaN+HHb0UZMyabXsW/4dn4IFX4Sxv+JcnmaMpMM1Iq9ul9HHd/hWpPT0xzzIqarILiW/c12a6fEtNKzrbCLimJIYzZQme1To9Mi5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716452; c=relaxed/simple;
	bh=D0lzhbmD3kAdlO1BunfvuTaft4yuZd0wNF3VUf5CNhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HU97eZZwZziX8w8G2ajL8DqYSS8ow+4G6izie0CYnsqI8woEqcP5iTfjJ6+LhxXpG1OM3wkdgzOY0sgWO0R/R1LsUQfhGSmM809ERNVeHZNxYHwBg3/humtRR55vrBWmCKyEsEXodRZKxizDg+SuywTu27reYQ+C+ki2J1OXTHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBbAoABp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBbAoABp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B73C4AF4D;
	Tue, 18 Jun 2024 13:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716452;
	bh=D0lzhbmD3kAdlO1BunfvuTaft4yuZd0wNF3VUf5CNhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBbAoABpuaazW8B93LmTW1vuBqHL8neSO077iVOst2JwEKoY4kC89TCQtJdn/CnrJ
	 MAk8LRj03BRevHHTSYF/qOtxsCXa4BNHyB2DxRec9oDaV6G1z39X2mmybZuBe77Izs
	 WbCTVYf7ixuX/oAETwZtMXkmLIwdWATx3DfCQzrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 620/770] NFSD: use explicit lock/unlock for directory ops
Date: Tue, 18 Jun 2024 14:37:53 +0200
Message-ID: <20240618123431.219690616@linuxfoundation.org>
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

[ Upstream commit debf16f0c671cb8db154a9ebcd6014cfff683b80 ]

When creating or unlinking a name in a directory use explicit
inode_lock_nested() instead of fh_lock(), and explicit calls to
fh_fill_pre_attrs() and fh_fill_post_attrs().  This is already done
for renames, with lock_rename() as the explicit locking.

Also move the 'fill' calls closer to the operation that might change the
attributes.  This way they are avoided on some error paths.

For the v2-only code in nfsproc.c, the fill calls are not replaced as
they aren't needed.

Making the locking explicit will simplify proposed future changes to
locking for directories.  It also makes it easily visible exactly where
pre/post attributes are used - not all callers of fh_lock() actually
need the pre/post attributes.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: NeilBrown <neilb@suse.de>
[ cel: backported to 5.10.y, prior to idmapped mounts ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c |  6 ++++--
 fs/nfsd/nfs4proc.c |  6 ++++--
 fs/nfsd/nfsproc.c  |  5 ++---
 fs/nfsd/vfs.c      | 36 ++++++++++++++++++++++++++----------
 4 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index d78dbb214c5c3..1a52f0b06ec32 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -260,7 +260,7 @@ nfsd3_create_file(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (host_err)
 		return nfserrno(host_err);
 
-	fh_lock_nested(fhp, I_MUTEX_PARENT);
+	inode_lock_nested(inode, I_MUTEX_PARENT);
 
 	child = lookup_one_len(argp->name, parent, argp->len);
 	if (IS_ERR(child)) {
@@ -318,11 +318,13 @@ nfsd3_create_file(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (!IS_POSIXACL(inode))
 		iap->ia_mode &= ~current_umask();
 
+	fh_fill_pre_attrs(fhp);
 	host_err = vfs_create(inode, child, iap->ia_mode, true);
 	if (host_err < 0) {
 		status = nfserrno(host_err);
 		goto out;
 	}
+	fh_fill_post_attrs(fhp);
 
 	/* A newly created file already has a file size of zero. */
 	if ((iap->ia_valid & ATTR_SIZE) && (iap->ia_size == 0))
@@ -340,7 +342,7 @@ nfsd3_create_file(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	status = nfsd_create_setattr(rqstp, fhp, resfhp, &attrs);
 
 out:
-	fh_unlock(fhp);
+	inode_unlock(inode);
 	if (child && !IS_ERR(child))
 		dput(child);
 	fh_drop_write(fhp);
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 9cf4298817c4b..193b84a0f3a59 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -264,7 +264,7 @@ nfsd4_create_file(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (is_create_with_attrs(open))
 		nfsd4_acl_to_attr(NF4REG, open->op_acl, &attrs);
 
-	fh_lock_nested(fhp, I_MUTEX_PARENT);
+	inode_lock_nested(inode, I_MUTEX_PARENT);
 
 	child = lookup_one_len(open->op_fname, parent, open->op_fnamelen);
 	if (IS_ERR(child)) {
@@ -348,10 +348,12 @@ nfsd4_create_file(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (!IS_POSIXACL(inode))
 		iap->ia_mode &= ~current_umask();
 
+	fh_fill_pre_attrs(fhp);
 	status = nfsd4_vfs_create(fhp, child, open);
 	if (status != nfs_ok)
 		goto out;
 	open->op_created = true;
+	fh_fill_post_attrs(fhp);
 
 	/* A newly created file already has a file size of zero. */
 	if ((iap->ia_valid & ATTR_SIZE) && (iap->ia_size == 0))
@@ -373,7 +375,7 @@ nfsd4_create_file(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (attrs.na_aclerr)
 		open->op_bmval[0] &= ~FATTR4_WORD0_ACL;
 out:
-	fh_unlock(fhp);
+	inode_unlock(inode);
 	nfsd_attrs_free(&attrs);
 	if (child && !IS_ERR(child))
 		dput(child);
diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 180b84b6597b0..e533550a26db5 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -291,7 +291,7 @@ nfsd_proc_create(struct svc_rqst *rqstp)
 		goto done;
 	}
 
-	fh_lock_nested(dirfhp, I_MUTEX_PARENT);
+	inode_lock_nested(dirfhp->fh_dentry->d_inode, I_MUTEX_PARENT);
 	dchild = lookup_one_len(argp->name, dirfhp->fh_dentry, argp->len);
 	if (IS_ERR(dchild)) {
 		resp->status = nfserrno(PTR_ERR(dchild));
@@ -407,8 +407,7 @@ nfsd_proc_create(struct svc_rqst *rqstp)
 	}
 
 out_unlock:
-	/* We don't really need to unlock, as fh_put does it. */
-	fh_unlock(dirfhp);
+	inode_unlock(dirfhp->fh_dentry->d_inode);
 	fh_drop_write(dirfhp);
 done:
 	fh_put(dirfhp);
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 03f6dd2ec653b..3364e562b00e5 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1386,7 +1386,7 @@ nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (host_err)
 		return nfserrno(host_err);
 
-	fh_lock_nested(fhp, I_MUTEX_PARENT);
+	inode_lock_nested(dentry->d_inode, I_MUTEX_PARENT);
 	dchild = lookup_one_len(fname, dentry, flen);
 	host_err = PTR_ERR(dchild);
 	if (IS_ERR(dchild)) {
@@ -1401,10 +1401,12 @@ nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	dput(dchild);
 	if (err)
 		goto out_unlock;
+	fh_fill_pre_attrs(fhp);
 	err = nfsd_create_locked(rqstp, fhp, fname, flen, attrs, type,
 				 rdev, resfhp);
+	fh_fill_post_attrs(fhp);
 out_unlock:
-	fh_unlock(fhp);
+	inode_unlock(dentry->d_inode);
 	return err;
 }
 
@@ -1487,20 +1489,22 @@ nfsd_symlink(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		goto out;
 	}
 
-	fh_lock(fhp);
 	dentry = fhp->fh_dentry;
+	inode_lock_nested(dentry->d_inode, I_MUTEX_PARENT);
 	dnew = lookup_one_len(fname, dentry, flen);
 	if (IS_ERR(dnew)) {
 		err = nfserrno(PTR_ERR(dnew));
-		fh_unlock(fhp);
+		inode_unlock(dentry->d_inode);
 		goto out_drop_write;
 	}
+	fh_fill_pre_attrs(fhp);
 	host_err = vfs_symlink(d_inode(dentry), dnew, path);
 	err = nfserrno(host_err);
 	cerr = fh_compose(resfhp, fhp->fh_export, dnew, fhp);
 	if (!err)
 		nfsd_create_setattr(rqstp, fhp, resfhp, attrs);
-	fh_unlock(fhp);
+	fh_fill_post_attrs(fhp);
+	inode_unlock(dentry->d_inode);
 	if (!err)
 		err = nfserrno(commit_metadata(fhp));
 	dput(dnew);
@@ -1546,9 +1550,9 @@ nfsd_link(struct svc_rqst *rqstp, struct svc_fh *ffhp,
 		goto out;
 	}
 
-	fh_lock_nested(ffhp, I_MUTEX_PARENT);
 	ddir = ffhp->fh_dentry;
 	dirp = d_inode(ddir);
+	inode_lock_nested(dirp, I_MUTEX_PARENT);
 
 	dnew = lookup_one_len(name, ddir, len);
 	if (IS_ERR(dnew)) {
@@ -1561,8 +1565,18 @@ nfsd_link(struct svc_rqst *rqstp, struct svc_fh *ffhp,
 	err = nfserr_noent;
 	if (d_really_is_negative(dold))
 		goto out_dput;
+<<<<<<< current
 	host_err = vfs_link(dold, dirp, dnew, NULL);
 	fh_unlock(ffhp);
+||||||| constructed merge base
+	host_err = vfs_link(dold, &init_user_ns, dirp, dnew, NULL);
+	fh_unlock(ffhp);
+=======
+	fh_fill_pre_attrs(ffhp);
+	host_err = vfs_link(dold, &init_user_ns, dirp, dnew, NULL);
+	fh_fill_post_attrs(ffhp);
+	inode_unlock(dirp);
+>>>>>>> patched
 	if (!host_err) {
 		err = nfserrno(commit_metadata(ffhp));
 		if (!err)
@@ -1582,7 +1596,7 @@ nfsd_link(struct svc_rqst *rqstp, struct svc_fh *ffhp,
 out_dput:
 	dput(dnew);
 out_unlock:
-	fh_unlock(ffhp);
+	inode_unlock(dirp);
 	goto out_drop_write;
 }
 
@@ -1755,9 +1769,9 @@ nfsd_unlink(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 	if (host_err)
 		goto out_nfserr;
 
-	fh_lock_nested(fhp, I_MUTEX_PARENT);
 	dentry = fhp->fh_dentry;
 	dirp = d_inode(dentry);
+	inode_lock_nested(dirp, I_MUTEX_PARENT);
 
 	rdentry = lookup_one_len(fname, dentry, flen);
 	host_err = PTR_ERR(rdentry);
@@ -1775,6 +1789,7 @@ nfsd_unlink(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 	if (!type)
 		type = d_inode(rdentry)->i_mode & S_IFMT;
 
+	fh_fill_pre_attrs(fhp);
 	if (type != S_IFDIR) {
 		if (rdentry->d_sb->s_export_op->flags & EXPORT_OP_CLOSE_BEFORE_UNLINK)
 			nfsd_close_cached_files(rdentry);
@@ -1782,8 +1797,9 @@ nfsd_unlink(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 	} else {
 		host_err = vfs_rmdir(dirp, rdentry);
 	}
+	fh_fill_post_attrs(fhp);
 
-	fh_unlock(fhp);
+	inode_unlock(dirp);
 	if (!host_err)
 		host_err = commit_metadata(fhp);
 	dput(rdentry);
@@ -1806,7 +1822,7 @@ nfsd_unlink(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 out:
 	return err;
 out_unlock:
-	fh_unlock(fhp);
+	inode_unlock(dirp);
 	goto out_drop_write;
 }
 
-- 
2.43.0



