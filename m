Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5781A2C04;
	Tue, 18 Jun 2024 13:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716343; cv=none; b=Vp6HiTJARImFt8U47uU+SgSNdp1TncU/ksBf6/s6Sfp3tH+SOUPeJjZHdKLOBpd61q+kgop74cHB3g8vW3oFGybrxt8LH64WISRoDo+vpo8M9pkR1zy3itmLKSL6dOD8a/yMhDnvK5yPFd9wBJwia+mPIQtEUQqX+wnO1zhn2R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716343; c=relaxed/simple;
	bh=rKQPoK+PrgUIz6PBG4I1e7wAZ/oDzV1a30oROTjEwro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHUfgq0q5LazpxFcISHIW+/6uAuDiHARcQ8OFGshFNAv813rvdiCP1/3ai43XnRDNLYyhSXxPwqEz1d61ce2QdKSChoYG68bkBjB50B/yBj1pKNQDCzTdMTHIwtBgoWuh6lxBxEHWq6DZc375ybRlc51veu/dGzt8xVo/+SlDEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AU55ZdQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AU55ZdQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4882FC3277B;
	Tue, 18 Jun 2024 13:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716343;
	bh=rKQPoK+PrgUIz6PBG4I1e7wAZ/oDzV1a30oROTjEwro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AU55ZdQFATKRR868nEGeR5CJXiPU8SkTSYqEBQB3mOwv5PuOxSuYpQcLYShommmc8
	 yvBQCR6LWIAq7iUtzW6V83VMM7ppqkJYiwkMiXg4hk1QyeghY6COdlAxn0DUFdO4jn
	 4BBf3s++ceNpTnwo8UEllEh0GbX9OE4SWbyjcij4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 613/770] NFSD: set attributes when creating symlinks
Date: Tue, 18 Jun 2024 14:37:46 +0200
Message-ID: <20240618123430.952986050@linuxfoundation.org>
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

[ Upstream commit 93adc1e391a761441d783828b93979b38093d011 ]

The NFS protocol includes attributes when creating symlinks.
Linux does store attributes for symlinks and allows them to be set,
though they are not used for permission checking.

NFSD currently doesn't set standard (struct iattr) attributes when
creating symlinks, but for NFSv4 it does set ACLs and security labels.
This is inconsistent.

To improve consistency, pass the provided attributes into nfsd_symlink()
and call nfsd_create_setattr() to set them.

NOTE: this results in a behaviour change for all NFS versions when the
client sends non-default attributes with a SYMLINK request. With the
Linux client, the only attributes are:
	attr.ia_mode = S_IFLNK | S_IRWXUGO;
	attr.ia_valid = ATTR_MODE;
so the final outcome will be unchanged. Other clients might sent
different attributes, and if they did they probably expect them to be
honoured.

We ignore any error from nfsd_create_setattr().  It isn't really clear
what should be done if a file is successfully created, but the
attributes cannot be set.  NFS doesn't allow partial success to be
reported.  Reporting failure is probably more misleading than reporting
success, so the status is ignored.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c |  5 ++++-
 fs/nfsd/nfs4proc.c |  2 +-
 fs/nfsd/nfsproc.c  |  5 ++++-
 fs/nfsd/vfs.c      | 25 ++++++++++++++++++-------
 fs/nfsd/vfs.h      |  5 +++--
 5 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 7b81d871f0d3c..394f6fb201974 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -397,6 +397,9 @@ nfsd3_proc_symlink(struct svc_rqst *rqstp)
 {
 	struct nfsd3_symlinkargs *argp = rqstp->rq_argp;
 	struct nfsd3_diropres *resp = rqstp->rq_resp;
+	struct nfsd_attrs attrs = {
+		.na_iattr	= &argp->attrs,
+	};
 
 	if (argp->tlen == 0) {
 		resp->status = nfserr_inval;
@@ -423,7 +426,7 @@ nfsd3_proc_symlink(struct svc_rqst *rqstp)
 	fh_copy(&resp->dirfh, &argp->ffh);
 	fh_init(&resp->fh, NFS3_FHSIZE);
 	resp->status = nfsd_symlink(rqstp, &resp->dirfh, argp->fname,
-				    argp->flen, argp->tname, &resp->fh);
+				    argp->flen, argp->tname, &attrs, &resp->fh);
 	kfree(argp->tname);
 out:
 	return rpc_success;
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index f8a157e4bc708..43387a8f10d06 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -813,7 +813,7 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	case NF4LNK:
 		status = nfsd_symlink(rqstp, &cstate->current_fh,
 				      create->cr_name, create->cr_namelen,
-				      create->cr_data, &resfh);
+				      create->cr_data, &attrs, &resfh);
 		break;
 
 	case NF4BLK:
diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index f061f229d5ff0..180b84b6597b0 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -478,6 +478,9 @@ nfsd_proc_symlink(struct svc_rqst *rqstp)
 {
 	struct nfsd_symlinkargs *argp = rqstp->rq_argp;
 	struct nfsd_stat *resp = rqstp->rq_resp;
+	struct nfsd_attrs attrs = {
+		.na_iattr	= &argp->attrs,
+	};
 	struct svc_fh	newfh;
 
 	if (argp->tlen > NFS_MAXPATHLEN) {
@@ -499,7 +502,7 @@ nfsd_proc_symlink(struct svc_rqst *rqstp)
 
 	fh_init(&newfh, NFS_FHSIZE);
 	resp->status = nfsd_symlink(rqstp, &argp->ffh, argp->fname, argp->flen,
-				    argp->tname, &newfh);
+				    argp->tname, &attrs, &newfh);
 
 	kfree(argp->tname);
 	fh_put(&argp->ffh);
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index c86c3a8e42329..f5a1f41cddfff 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1463,15 +1463,25 @@ nfsd_readlink(struct svc_rqst *rqstp, struct svc_fh *fhp, char *buf, int *lenp)
 	return 0;
 }
 
-/*
- * Create a symlink and look up its inode
+/**
+ * nfsd_symlink - Create a symlink and look up its inode
+ * @rqstp: RPC transaction being executed
+ * @fhp: NFS filehandle of parent directory
+ * @fname: filename of the new symlink
+ * @flen: length of @fname
+ * @path: content of the new symlink (NUL-terminated)
+ * @attrs: requested attributes of new object
+ * @resfhp: NFS filehandle of new object
+ *
  * N.B. After this call _both_ fhp and resfhp need an fh_put
+ *
+ * Returns nfs_ok on success, or an nfsstat in network byte order.
  */
 __be32
 nfsd_symlink(struct svc_rqst *rqstp, struct svc_fh *fhp,
-				char *fname, int flen,
-				char *path,
-				struct svc_fh *resfhp)
+	     char *fname, int flen,
+	     char *path, struct nfsd_attrs *attrs,
+	     struct svc_fh *resfhp)
 {
 	struct dentry	*dentry, *dnew;
 	__be32		err, cerr;
@@ -1501,13 +1511,14 @@ nfsd_symlink(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	host_err = vfs_symlink(d_inode(dentry), dnew, path);
 	err = nfserrno(host_err);
+	cerr = fh_compose(resfhp, fhp->fh_export, dnew, fhp);
+	if (!err)
+		nfsd_create_setattr(rqstp, fhp, resfhp, attrs);
 	fh_unlock(fhp);
 	if (!err)
 		err = nfserrno(commit_metadata(fhp));
-
 	fh_drop_write(fhp);
 
-	cerr = fh_compose(resfhp, fhp->fh_export, dnew, fhp);
 	dput(dnew);
 	if (err==0) err = cerr;
 out:
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index d8b1a36fca956..5047cec4c423c 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -114,8 +114,9 @@ __be32		nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
 __be32		nfsd_readlink(struct svc_rqst *, struct svc_fh *,
 				char *, int *);
 __be32		nfsd_symlink(struct svc_rqst *, struct svc_fh *,
-				char *name, int len, char *path,
-				struct svc_fh *res);
+			     char *name, int len, char *path,
+			     struct nfsd_attrs *attrs,
+			     struct svc_fh *res);
 __be32		nfsd_link(struct svc_rqst *, struct svc_fh *,
 				char *, int, struct svc_fh *);
 ssize_t		nfsd_copy_file_range(struct file *, u64,
-- 
2.43.0



