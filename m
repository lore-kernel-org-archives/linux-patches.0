Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6361586D5;
	Tue, 18 Jun 2024 13:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716156; cv=none; b=YZGGq1qU0C+LPn+Ml+LKnzI1JQQR2kPsyH0omRYF2Evw774Xbwze3+Xx1ImhDE0Xd9YXnEg0U/CEv8SnDphbnmHK2HN4y01dVccp2rUQYwmNRBZ0Tc+9oqXTBmyQ5PfLV2yN6mj9xm9vIr6l+DSasdwPVokK0dY/HjI5/ZtAps0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716156; c=relaxed/simple;
	bh=LzXaqPBz2WuH4FJjgihZ6bFikcwjpR0ht6OHnE8/m4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e116Qvjo0ZpwUBgD2sTyVAFEUB7FJnMwzdZqZjmYReW0DfQxTy8GSHc9Q+BMcLB2vS0lYnBf5uAAJJ3TZPoeXC6mEGrUcHuZwVUfw/nbfPA9WeC2Sbv84JwOq3VZnZINjruYvsch20Obf4Ju67UCvwfyzQZoYvKJpmcMHa6sdC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yas8s5PW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yas8s5PW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0BAC3277B;
	Tue, 18 Jun 2024 13:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716156;
	bh=LzXaqPBz2WuH4FJjgihZ6bFikcwjpR0ht6OHnE8/m4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yas8s5PWC9RrHs/NqiYqcppqMjVf6RMdQVEN/f2tOPdZwFI4IfNvSFtOMQAVBFzZ7
	 nEbMhgXh3V//Hlkpg59cg9vcyrNPmgCj4PIcoWubvY5578LikmRYlA+iOIZsCgCq95
	 yF+Fv6bczsVTMlSceZvlIHziMStOSOBPzv0SfpwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 520/770] NFSD: Refactor NFSv3 CREATE
Date: Tue, 18 Jun 2024 14:36:13 +0200
Message-ID: <20240618123427.386167650@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit df9606abddfb01090d5ece7dcc2441d848f690f0 ]

The NFSv3 CREATE and NFSv4 OPEN(CREATE) use cases are about to
diverge such that it makes sense to split do_nfsd_create() into one
version for NFSv3 and one for NFSv4.

As a first step, copy do_nfsd_create() to nfs3proc.c and remove
NFSv4-specific logic.

One immediate legibility benefit is that the logic for handling
NFSv3 createhow is now quite straightforward. NFSv4 createhow
has some subtleties that IMO do not belong in generic code.

[ cel: backported to 5.10.y, prior to idmapped mounts ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c | 127 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 121 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 981a2a71c5af7..e314545bbdb2e 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -8,6 +8,7 @@
 #include <linux/fs.h>
 #include <linux/ext2_fs.h>
 #include <linux/magic.h>
+#include <linux/namei.h>
 
 #include "cache.h"
 #include "xdr3.h"
@@ -220,10 +221,126 @@ nfsd3_proc_write(struct svc_rqst *rqstp)
 }
 
 /*
- * With NFSv3, CREATE processing is a lot easier than with NFSv2.
- * At least in theory; we'll see how it fares in practice when the
- * first reports about SunOS compatibility problems start to pour in...
+ * Implement NFSv3's unchecked, guarded, and exclusive CREATE
+ * semantics for regular files. Except for the created file,
+ * this operation is stateless on the server.
+ *
+ * Upon return, caller must release @fhp and @resfhp.
  */
+static __be32
+nfsd3_create_file(struct svc_rqst *rqstp, struct svc_fh *fhp,
+		  struct svc_fh *resfhp, struct nfsd3_createargs *argp)
+{
+	struct iattr *iap = &argp->attrs;
+	struct dentry *parent, *child;
+	__u32 v_mtime, v_atime;
+	struct inode *inode;
+	__be32 status;
+	int host_err;
+
+	if (isdotent(argp->name, argp->len))
+		return nfserr_exist;
+	if (!(iap->ia_valid & ATTR_MODE))
+		iap->ia_mode = 0;
+
+	status = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_EXEC);
+	if (status != nfs_ok)
+		return status;
+
+	parent = fhp->fh_dentry;
+	inode = d_inode(parent);
+
+	host_err = fh_want_write(fhp);
+	if (host_err)
+		return nfserrno(host_err);
+
+	fh_lock_nested(fhp, I_MUTEX_PARENT);
+
+	child = lookup_one_len(argp->name, parent, argp->len);
+	if (IS_ERR(child)) {
+		status = nfserrno(PTR_ERR(child));
+		goto out;
+	}
+
+	if (d_really_is_negative(child)) {
+		status = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_CREATE);
+		if (status != nfs_ok)
+			goto out;
+	}
+
+	status = fh_compose(resfhp, fhp->fh_export, child, fhp);
+	if (status != nfs_ok)
+		goto out;
+
+	v_mtime = 0;
+	v_atime = 0;
+	if (argp->createmode == NFS3_CREATE_EXCLUSIVE) {
+		u32 *verifier = (u32 *)argp->verf;
+
+		/*
+		 * Solaris 7 gets confused (bugid 4218508) if these have
+		 * the high bit set, as do xfs filesystems without the
+		 * "bigtime" feature. So just clear the high bits.
+		 */
+		v_mtime = verifier[0] & 0x7fffffff;
+		v_atime = verifier[1] & 0x7fffffff;
+	}
+
+	if (d_really_is_positive(child)) {
+		status = nfs_ok;
+
+		switch (argp->createmode) {
+		case NFS3_CREATE_UNCHECKED:
+			if (!d_is_reg(child))
+				break;
+			iap->ia_valid &= ATTR_SIZE;
+			goto set_attr;
+		case NFS3_CREATE_GUARDED:
+			status = nfserr_exist;
+			break;
+		case NFS3_CREATE_EXCLUSIVE:
+			if (d_inode(child)->i_mtime.tv_sec == v_mtime &&
+			    d_inode(child)->i_atime.tv_sec == v_atime &&
+			    d_inode(child)->i_size == 0) {
+				break;
+			}
+			status = nfserr_exist;
+		}
+		goto out;
+	}
+
+	if (!IS_POSIXACL(inode))
+		iap->ia_mode &= ~current_umask();
+
+	host_err = vfs_create(inode, child, iap->ia_mode, true);
+	if (host_err < 0) {
+		status = nfserrno(host_err);
+		goto out;
+	}
+
+	/* A newly created file already has a file size of zero. */
+	if ((iap->ia_valid & ATTR_SIZE) && (iap->ia_size == 0))
+		iap->ia_valid &= ~ATTR_SIZE;
+	if (argp->createmode == NFS3_CREATE_EXCLUSIVE) {
+		iap->ia_valid = ATTR_MTIME | ATTR_ATIME |
+				ATTR_MTIME_SET | ATTR_ATIME_SET;
+		iap->ia_mtime.tv_sec = v_mtime;
+		iap->ia_atime.tv_sec = v_atime;
+		iap->ia_mtime.tv_nsec = 0;
+		iap->ia_atime.tv_nsec = 0;
+	}
+
+set_attr:
+	status = nfsd_create_setattr(rqstp, fhp, resfhp, iap);
+
+out:
+	fh_unlock(fhp);
+	if (child && !IS_ERR(child))
+		dput(child);
+	fh_drop_write(fhp);
+	return status;
+}
+
 static __be32
 nfsd3_proc_create(struct svc_rqst *rqstp)
 {
@@ -239,9 +356,7 @@ nfsd3_proc_create(struct svc_rqst *rqstp)
 	dirfhp = fh_copy(&resp->dirfh, &argp->fh);
 	newfhp = fh_init(&resp->fh, NFS3_FHSIZE);
 
-	resp->status = do_nfsd_create(rqstp, dirfhp, argp->name, argp->len,
-				      &argp->attrs, newfhp, argp->createmode,
-				      (u32 *)argp->verf, NULL, NULL);
+	resp->status = nfsd3_create_file(rqstp, dirfhp, newfhp, argp);
 	return rpc_success;
 }
 
-- 
2.43.0



