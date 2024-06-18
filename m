Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603511A4F1A;
	Tue, 18 Jun 2024 13:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716464; cv=none; b=Bi8N3YBJu+pb2WN8IzpQcygqiLsZK48kqFCtigNgZHC1nhOjfGw0JEKB6WPnttA4Ez9IrJHFJ+JQa6MW5CqI8VjX4wf4iaCJw+8f3/bJ9ddS/X8zUjIW9rbwBRyQ7FZwUH/JXJ8cS356mWgia39u5bTXiIYNw0EIDZlmDwRStAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716464; c=relaxed/simple;
	bh=n2mALRKNHxI2FeWvNP82YQqk5wQShaFKp2PYB5xL170=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNTnPLFFk+pDtPFf+MPrQuW5uMsx+lLKgBmRW8G5L0M0ukBDccYKEq/RXIAJ6k99X0IJJ7rX6PepzX0Jr7nGC90WVxy/2A2DI/RMA1LjTHwzXf6kaprHAf65EbrXwBQMZrgZDwMO1mpAXsxtEVakXzwTYMF6VBiHij0Tgjr++qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDJ89S0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDJ89S0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EB6C4AF1D;
	Tue, 18 Jun 2024 13:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716464;
	bh=n2mALRKNHxI2FeWvNP82YQqk5wQShaFKp2PYB5xL170=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDJ89S0oFhMP+skl6L8bZxK2w5avKoiCVffGwjLkXaGEP1e+CX2HC5qgkPtjU7tNZ
	 WOk0hoSyTHIw2eLedF7lDEqjWJpLvmH9K284Sfdb5Lz3BsOVyVGBcUWOPgoHBON2QN
	 AAq7DLTSNuzz8VU3qTDH80dQN5jJF1z7m7U/mBO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 614/770] NFSD: add security label to struct nfsd_attrs
Date: Tue, 18 Jun 2024 14:37:47 +0200
Message-ID: <20240618123430.991282254@linuxfoundation.org>
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

[ Upstream commit d6a97d3f589a3a46a16183e03f3774daee251317 ]

nfsd_setattr() now sets a security label if provided, and nfsv4 provides
it in the 'open' and 'create' paths and the 'setattr' path.
If setting the label failed (including because the kernel doesn't
support labels), an error field in 'struct nfsd_attrs' is set, and the
caller can respond.  The open/create callers clear
FATTR4_WORD2_SECURITY_LABEL in the returned attr set in this case.
The setattr caller returns the error.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 49 +++++++++-------------------------------------
 fs/nfsd/vfs.c      | 29 +++------------------------
 fs/nfsd/vfs.h      |  5 +++--
 3 files changed, 15 insertions(+), 68 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 43387a8f10d06..cfcc463968b70 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -64,36 +64,6 @@ MODULE_PARM_DESC(nfsd4_ssc_umount_timeout,
 		"idle msecs before unmount export from source server");
 #endif
 
-#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
-#include <linux/security.h>
-
-static inline void
-nfsd4_security_inode_setsecctx(struct svc_fh *resfh, struct xdr_netobj *label, u32 *bmval)
-{
-	struct inode *inode = d_inode(resfh->fh_dentry);
-	int status;
-
-	inode_lock(inode);
-	status = security_inode_setsecctx(resfh->fh_dentry,
-		label->data, label->len);
-	inode_unlock(inode);
-
-	if (status)
-		/*
-		 * XXX: We should really fail the whole open, but we may
-		 * already have created a new file, so it may be too
-		 * late.  For now this seems the least of evils:
-		 */
-		bmval[2] &= ~FATTR4_WORD2_SECURITY_LABEL;
-
-	return;
-}
-#else
-static inline void
-nfsd4_security_inode_setsecctx(struct svc_fh *resfh, struct xdr_netobj *label, u32 *bmval)
-{ }
-#endif
-
 #define NFSDDBG_FACILITY		NFSDDBG_PROC
 
 static u32 nfsd_attrmask[] = {
@@ -288,6 +258,7 @@ nfsd4_create_file(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	struct iattr *iap = &open->op_iattr;
 	struct nfsd_attrs attrs = {
 		.na_iattr	= iap,
+		.na_seclabel	= &open->op_label,
 	};
 	struct dentry *parent, *child;
 	__u32 v_mtime, v_atime;
@@ -409,6 +380,8 @@ nfsd4_create_file(struct svc_rqst *rqstp, struct svc_fh *fhp,
 set_attr:
 	status = nfsd_create_setattr(rqstp, fhp, resfhp, &attrs);
 
+	if (attrs.na_labelerr)
+		open->op_bmval[2] &= ~FATTR4_WORD2_SECURITY_LABEL;
 out:
 	fh_unlock(fhp);
 	if (child && !IS_ERR(child))
@@ -450,9 +423,6 @@ do_open_lookup(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate, stru
 		status = nfsd4_create_file(rqstp, current_fh, *resfh, open);
 		current->fs->umask = 0;
 
-		if (!status && open->op_label.len)
-			nfsd4_security_inode_setsecctx(*resfh, &open->op_label, open->op_bmval);
-
 		/*
 		 * Following rfc 3530 14.2.16, and rfc 5661 18.16.4
 		 * use the returned bitmask to indicate which attributes
@@ -792,6 +762,7 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	struct nfsd4_create *create = &u->create;
 	struct nfsd_attrs attrs = {
 		.na_iattr	= &create->cr_iattr,
+		.na_seclabel	= &create->cr_label,
 	};
 	struct svc_fh resfh;
 	__be32 status;
@@ -864,8 +835,8 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	if (status)
 		goto out;
 
-	if (create->cr_label.len)
-		nfsd4_security_inode_setsecctx(&resfh, &create->cr_label, create->cr_bmval);
+	if (attrs.na_labelerr)
+		create->cr_bmval[2] &= ~FATTR4_WORD2_SECURITY_LABEL;
 
 	if (create->cr_acl != NULL)
 		do_set_nfs4_acl(rqstp, &resfh, create->cr_acl,
@@ -1150,6 +1121,7 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	struct nfsd4_setattr *setattr = &u->setattr;
 	struct nfsd_attrs attrs = {
 		.na_iattr	= &setattr->sa_iattr,
+		.na_seclabel	= &setattr->sa_label,
 	};
 	__be32 status = nfs_ok;
 	int err;
@@ -1178,13 +1150,10 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 					    setattr->sa_acl);
 	if (status)
 		goto out;
-	if (setattr->sa_label.len)
-		status = nfsd4_set_nfs4_label(rqstp, &cstate->current_fh,
-				&setattr->sa_label);
-	if (status)
-		goto out;
 	status = nfsd_setattr(rqstp, &cstate->current_fh, &attrs,
 				0, (time64_t)0);
+	if (!status)
+		status = nfserrno(attrs.na_labelerr);
 out:
 	fh_drop_write(&cstate->current_fh);
 	return status;
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index f5a1f41cddfff..01c431ed90ecf 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -471,6 +471,9 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	host_err = notify_change(dentry, iap, NULL);
 
 out_unlock:
+	if (attr->na_seclabel && attr->na_seclabel->len)
+		attr->na_labelerr = security_inode_setsecctx(dentry,
+			attr->na_seclabel->data, attr->na_seclabel->len);
 	fh_unlock(fhp);
 	if (size_change)
 		put_write_access(inode);
@@ -508,32 +511,6 @@ int nfsd4_is_junction(struct dentry *dentry)
 		return 0;
 	return 1;
 }
-#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
-__be32 nfsd4_set_nfs4_label(struct svc_rqst *rqstp, struct svc_fh *fhp,
-		struct xdr_netobj *label)
-{
-	__be32 error;
-	int host_error;
-	struct dentry *dentry;
-
-	error = fh_verify(rqstp, fhp, 0 /* S_IFREG */, NFSD_MAY_SATTR);
-	if (error)
-		return error;
-
-	dentry = fhp->fh_dentry;
-
-	inode_lock(d_inode(dentry));
-	host_error = security_inode_setsecctx(dentry, label->data, label->len);
-	inode_unlock(d_inode(dentry));
-	return nfserrno(host_error);
-}
-#else
-__be32 nfsd4_set_nfs4_label(struct svc_rqst *rqstp, struct svc_fh *fhp,
-		struct xdr_netobj *label)
-{
-	return nfserr_notsupp;
-}
-#endif
 
 static struct nfsd4_compound_state *nfsd4_get_cstate(struct svc_rqst *rqstp)
 {
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index 5047cec4c423c..d5d4cfe37c933 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -44,6 +44,9 @@ typedef int (*nfsd_filldir_t)(void *, const char *, int, loff_t, u64, unsigned);
 /* nfsd/vfs.c */
 struct nfsd_attrs {
 	struct iattr		*na_iattr;	/* input */
+	struct xdr_netobj	*na_seclabel;	/* input */
+
+	int			na_labelerr;	/* output */
 };
 
 int		nfsd_cross_mnt(struct svc_rqst *rqstp, struct dentry **dpp,
@@ -57,8 +60,6 @@ __be32		nfsd_setattr(struct svc_rqst *, struct svc_fh *,
 				struct nfsd_attrs *, int, time64_t);
 int nfsd_mountpoint(struct dentry *, struct svc_export *);
 #ifdef CONFIG_NFSD_V4
-__be32          nfsd4_set_nfs4_label(struct svc_rqst *, struct svc_fh *,
-		    struct xdr_netobj *);
 __be32		nfsd4_vfs_fallocate(struct svc_rqst *, struct svc_fh *,
 				    struct file *, loff_t, loff_t, int);
 __be32		nfsd4_clone_file_range(struct svc_rqst *rqstp,
-- 
2.43.0



