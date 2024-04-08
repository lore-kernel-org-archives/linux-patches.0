Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774DE42046;
	Mon,  8 Apr 2024 13:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584345; cv=none; b=OxcQaIxsfQRO+LHllw+5uT86LYLLBZJ7F2OeGjE80bV9/xvEWaKwxRN53HQXdB0uOnznYhyPijYSj3aenpYcI3BGtKXslGlJ24P7B/LhHlb1UFQy1/gJdH3fzepfsUtfm/y8Zk5daA+x95AQbdlNpTLSaRMkS8k9L8XXqEWKRHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584345; c=relaxed/simple;
	bh=hmW7wU2LF1VNJodT4vqaZOJ1gTFxImXyEKbIkvUxzjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjZa4JRLK8B5W939HgNpc60/6YeLia+f2nsQEyACltmPWLjbNeCsw2WSQtG4qqlVH4gk6SC/xqjKUi4R7KaDSTiMMml08lR+IL5dPO+1RBLV1jFRE2MBdqBSeHe78RG0KNzFr86NoZDU++jGKFxatsog13zzlAqkNgINB0ToEXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8fYPtls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8fYPtls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14A3C433F1;
	Mon,  8 Apr 2024 13:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584345;
	bh=hmW7wU2LF1VNJodT4vqaZOJ1gTFxImXyEKbIkvUxzjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8fYPtls7wkyeTgwfCKpnjtYEMZw7lcWOskXCuCyP/dFVU/fOlJ1W2jON9VBx7GzO
	 svA67ERI8mIwrm+vyK1E4QphKjsOznfIvB2zFPwClcslYdQx/s86FDnpERUtPTWlLw
	 wf/bE8x5yT6xVuL5DUgZB80TGPlBV1BEA4uTLg5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 406/690] NFSD: add posix ACLs to struct nfsd_attrs
Date: Mon,  8 Apr 2024 14:54:32 +0200
Message-ID: <20240408125414.278686096@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit c0cbe70742f4a70893cd6e5f6b10b6e89b6db95b ]

pacl and dpacl pointers are added to struct nfsd_attrs, which requires
that we have an nfsd_attrs_free() function to free them.
Those nfsv4 functions that can set ACLs now set up these pointers
based on the passed in NFSv4 ACL.

nfsd_setattr() sets the acls as appropriate.

Errors are handled as with security labels.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/acl.h      |  6 ++++--
 fs/nfsd/nfs4acl.c  | 46 +++++++---------------------------------------
 fs/nfsd/nfs4proc.c | 46 ++++++++++++++++------------------------------
 fs/nfsd/vfs.c      |  9 +++++++++
 fs/nfsd/vfs.h      | 11 +++++++++++
 5 files changed, 47 insertions(+), 71 deletions(-)

diff --git a/fs/nfsd/acl.h b/fs/nfsd/acl.h
index ba14d2f4b64f4..4b7324458a94e 100644
--- a/fs/nfsd/acl.h
+++ b/fs/nfsd/acl.h
@@ -38,6 +38,8 @@
 struct nfs4_acl;
 struct svc_fh;
 struct svc_rqst;
+struct nfsd_attrs;
+enum nfs_ftype4;
 
 int nfs4_acl_bytes(int entries);
 int nfs4_acl_get_whotype(char *, u32);
@@ -45,7 +47,7 @@ __be32 nfs4_acl_write_who(struct xdr_stream *xdr, int who);
 
 int nfsd4_get_nfs4_acl(struct svc_rqst *rqstp, struct dentry *dentry,
 		struct nfs4_acl **acl);
-__be32 nfsd4_set_nfs4_acl(struct svc_rqst *rqstp, struct svc_fh *fhp,
-		struct nfs4_acl *acl);
+__be32 nfsd4_acl_to_attr(enum nfs_ftype4 type, struct nfs4_acl *acl,
+			 struct nfsd_attrs *attr);
 
 #endif /* LINUX_NFS4_ACL_H */
diff --git a/fs/nfsd/nfs4acl.c b/fs/nfsd/nfs4acl.c
index eaa3a0cf38f14..bb8e2f6d7d03c 100644
--- a/fs/nfsd/nfs4acl.c
+++ b/fs/nfsd/nfs4acl.c
@@ -751,58 +751,26 @@ static int nfs4_acl_nfsv4_to_posix(struct nfs4_acl *acl,
 	return ret;
 }
 
-__be32
-nfsd4_set_nfs4_acl(struct svc_rqst *rqstp, struct svc_fh *fhp,
-		struct nfs4_acl *acl)
+__be32 nfsd4_acl_to_attr(enum nfs_ftype4 type, struct nfs4_acl *acl,
+			 struct nfsd_attrs *attr)
 {
-	__be32 error;
 	int host_error;
-	struct dentry *dentry;
-	struct inode *inode;
-	struct posix_acl *pacl = NULL, *dpacl = NULL;
 	unsigned int flags = 0;
 
-	/* Get inode */
-	error = fh_verify(rqstp, fhp, 0, NFSD_MAY_SATTR);
-	if (error)
-		return error;
-
-	dentry = fhp->fh_dentry;
-	inode = d_inode(dentry);
+	if (!acl)
+		return nfs_ok;
 
-	if (S_ISDIR(inode->i_mode))
+	if (type == NF4DIR)
 		flags = NFS4_ACL_DIR;
 
-	host_error = nfs4_acl_nfsv4_to_posix(acl, &pacl, &dpacl, flags);
+	host_error = nfs4_acl_nfsv4_to_posix(acl, &attr->na_pacl,
+					     &attr->na_dpacl, flags);
 	if (host_error == -EINVAL)
 		return nfserr_attrnotsupp;
-	if (host_error < 0)
-		goto out_nfserr;
-
-	fh_lock(fhp);
-
-	host_error = set_posix_acl(&init_user_ns, inode, ACL_TYPE_ACCESS, pacl);
-	if (host_error < 0)
-		goto out_drop_lock;
-
-	if (S_ISDIR(inode->i_mode)) {
-		host_error = set_posix_acl(&init_user_ns, inode,
-					   ACL_TYPE_DEFAULT, dpacl);
-	}
-
-out_drop_lock:
-	fh_unlock(fhp);
-
-	posix_acl_release(pacl);
-	posix_acl_release(dpacl);
-out_nfserr:
-	if (host_error == -EOPNOTSUPP)
-		return nfserr_attrnotsupp;
 	else
 		return nfserrno(host_error);
 }
 
-
 static short
 ace2type(struct nfs4_ace *ace)
 {
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 7ebf807f33d98..ffa2806fd5d3b 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -128,26 +128,6 @@ is_create_with_attrs(struct nfsd4_open *open)
 		    || open->op_createmode == NFS4_CREATE_EXCLUSIVE4_1);
 }
 
-/*
- * if error occurs when setting the acl, just clear the acl bit
- * in the returned attr bitmap.
- */
-static void
-do_set_nfs4_acl(struct svc_rqst *rqstp, struct svc_fh *fhp,
-		struct nfs4_acl *acl, u32 *bmval)
-{
-	__be32 status;
-
-	status = nfsd4_set_nfs4_acl(rqstp, fhp, acl);
-	if (status)
-		/*
-		 * We should probably fail the whole open at this point,
-		 * but we've already created the file, so it's too late;
-		 * So this seems the least of evils:
-		 */
-		bmval[0] &= ~FATTR4_WORD0_ACL;
-}
-
 static inline void
 fh_dup2(struct svc_fh *dst, struct svc_fh *src)
 {
@@ -281,6 +261,9 @@ nfsd4_create_file(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (host_err)
 		return nfserrno(host_err);
 
+	if (is_create_with_attrs(open))
+		nfsd4_acl_to_attr(NF4REG, open->op_acl, &attrs);
+
 	fh_lock_nested(fhp, I_MUTEX_PARENT);
 
 	child = lookup_one_len(open->op_fname, parent, open->op_fnamelen);
@@ -382,8 +365,11 @@ nfsd4_create_file(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	if (attrs.na_labelerr)
 		open->op_bmval[2] &= ~FATTR4_WORD2_SECURITY_LABEL;
+	if (attrs.na_aclerr)
+		open->op_bmval[0] &= ~FATTR4_WORD0_ACL;
 out:
 	fh_unlock(fhp);
+	nfsd_attrs_free(&attrs);
 	if (child && !IS_ERR(child))
 		dput(child);
 	fh_drop_write(fhp);
@@ -446,9 +432,6 @@ do_open_lookup(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate, stru
 	if (status)
 		goto out;
 
-	if (is_create_with_attrs(open) && open->op_acl != NULL)
-		do_set_nfs4_acl(rqstp, *resfh, open->op_acl, open->op_bmval);
-
 	nfsd4_set_open_owner_reply_cache(cstate, open, *resfh);
 	accmode = NFSD_MAY_NOP;
 	if (open->op_created ||
@@ -779,6 +762,7 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	if (status)
 		return status;
 
+	status = nfsd4_acl_to_attr(create->cr_type, create->cr_acl, &attrs);
 	current->fs->umask = create->cr_umask;
 	switch (create->cr_type) {
 	case NF4LNK:
@@ -837,10 +821,8 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 
 	if (attrs.na_labelerr)
 		create->cr_bmval[2] &= ~FATTR4_WORD2_SECURITY_LABEL;
-
-	if (create->cr_acl != NULL)
-		do_set_nfs4_acl(rqstp, &resfh, create->cr_acl,
-				create->cr_bmval);
+	if (attrs.na_aclerr)
+		create->cr_bmval[0] &= ~FATTR4_WORD0_ACL;
 
 	fh_unlock(&cstate->current_fh);
 	set_change_info(&create->cr_cinfo, &cstate->current_fh);
@@ -849,6 +831,7 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	fh_put(&resfh);
 out_umask:
 	current->fs->umask = 0;
+	nfsd_attrs_free(&attrs);
 	return status;
 }
 
@@ -1123,6 +1106,7 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		.na_iattr	= &setattr->sa_iattr,
 		.na_seclabel	= &setattr->sa_label,
 	};
+	struct inode *inode;
 	__be32 status = nfs_ok;
 	int err;
 
@@ -1145,9 +1129,10 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	if (status)
 		goto out;
 
-	if (setattr->sa_acl != NULL)
-		status = nfsd4_set_nfs4_acl(rqstp, &cstate->current_fh,
-					    setattr->sa_acl);
+	inode = cstate->current_fh.fh_dentry->d_inode;
+	status = nfsd4_acl_to_attr(S_ISDIR(inode->i_mode) ? NF4DIR : NF4REG,
+				   setattr->sa_acl, &attrs);
+
 	if (status)
 		goto out;
 	status = nfsd_setattr(rqstp, &cstate->current_fh, &attrs,
@@ -1155,6 +1140,7 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	if (!status)
 		status = nfserrno(attrs.na_labelerr);
 out:
+	nfsd_attrs_free(&attrs);
 	fh_drop_write(&cstate->current_fh);
 	return status;
 }
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index f9f62282d91f8..e91ac3bc68764 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -462,6 +462,15 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (attr->na_seclabel && attr->na_seclabel->len)
 		attr->na_labelerr = security_inode_setsecctx(dentry,
 			attr->na_seclabel->data, attr->na_seclabel->len);
+	if (IS_ENABLED(CONFIG_FS_POSIX_ACL) && attr->na_pacl)
+		attr->na_aclerr = set_posix_acl(&init_user_ns,
+						inode, ACL_TYPE_ACCESS,
+						attr->na_pacl);
+	if (IS_ENABLED(CONFIG_FS_POSIX_ACL) &&
+	    !attr->na_aclerr && attr->na_dpacl && S_ISDIR(inode->i_mode))
+		attr->na_aclerr = set_posix_acl(&init_user_ns,
+						inode, ACL_TYPE_DEFAULT,
+						attr->na_dpacl);
 	fh_unlock(fhp);
 	if (size_change)
 		put_write_access(inode);
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index d5d4cfe37c933..c95cd414b4bb0 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -6,6 +6,8 @@
 #ifndef LINUX_NFSD_VFS_H
 #define LINUX_NFSD_VFS_H
 
+#include <linux/fs.h>
+#include <linux/posix_acl.h>
 #include "nfsfh.h"
 #include "nfsd.h"
 
@@ -45,10 +47,19 @@ typedef int (*nfsd_filldir_t)(void *, const char *, int, loff_t, u64, unsigned);
 struct nfsd_attrs {
 	struct iattr		*na_iattr;	/* input */
 	struct xdr_netobj	*na_seclabel;	/* input */
+	struct posix_acl	*na_pacl;	/* input */
+	struct posix_acl	*na_dpacl;	/* input */
 
 	int			na_labelerr;	/* output */
+	int			na_aclerr;	/* output */
 };
 
+static inline void nfsd_attrs_free(struct nfsd_attrs *attrs)
+{
+	posix_acl_release(attrs->na_pacl);
+	posix_acl_release(attrs->na_dpacl);
+}
+
 int		nfsd_cross_mnt(struct svc_rqst *rqstp, struct dentry **dpp,
 		                struct svc_export **expp);
 __be32		nfsd_lookup(struct svc_rqst *, struct svc_fh *,
-- 
2.43.0



