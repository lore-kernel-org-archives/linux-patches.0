Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92033183CA3;
	Sun,  1 Sep 2024 16:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208415; cv=none; b=jkcZNvlwoSj3dVIvkc7le9RILvM+sn6D5wXU+E+xJmRHkr66l3ccW4NaDO3Ye5HixR8sxvKKWxo8I+Jh4h1UcMGAp2OT1H586B7AM1P1BA531saUuDgWzn2Tbs8YKKHZ9se0XwqMEjyaF3wgEJtZDyU8RAEeLVghHp9jVbM2G6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208415; c=relaxed/simple;
	bh=LBTXwQkuq2i2NVd6B4vobirttSdVpGdEgGEOHfZD960=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnfPevWdNudj3LefsTQAiFeI0hvqj2nsAlOHmMfVjPUY3+b2ShzFNVJ8fWWDaWs/wANGg68nX5RDjqXyo56382ItW4hTL44Li0LWdLa0BjngVdMV+HR2WX/GAnk5JVRiIycM+gDIaT+y8xooJxUXhJ9TOBr4LsQfpK+jjG+Ehus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ca5+Uel0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ca5+Uel0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010E8C4CEC3;
	Sun,  1 Sep 2024 16:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208415;
	bh=LBTXwQkuq2i2NVd6B4vobirttSdVpGdEgGEOHfZD960=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ca5+Uel0qFx7cgLgaOvplCBwoqpVcz9stgAddKJtCR0YhF+BGwOTn0re9TXGscG+U
	 f9R+qnGE+54LnKFrdiD1shbpQgvUusPMbreDEb3MEj7ZK+WGQmpVWBMrVNAwmRTMmt
	 S8bd+FOMEX3VFunVmm4PSYGNmW9TA16/xoNKZGjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 075/149] fs/nfsd: fix update of inode attrs in CB_GETATTR
Date: Sun,  1 Sep 2024 18:16:26 +0200
Message-ID: <20240901160820.286475202@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 7e8ae8486e4471513e2111aba6ac29f2357bed2a ]

Currently, we copy the mtime and ctime to the in-core inode and then
mark the inode dirty. This is fine for certain types of filesystems, but
not all. Some require a real setattr to properly change these values
(e.g. ceph or reexported NFS).

Fix this code to call notify_change() instead, which is the proper way
to effect a setattr. There is one problem though:

In this case, the client is holding a write delegation and has sent us
attributes to update our cache. We don't want to break the delegation
for this since that would defeat the purpose. Add a new ATTR_DELEG flag
that makes notify_change bypass the try_break_deleg call.

Fixes: c5967721e106 ("NFSD: handle GETATTR conflict with write delegation")
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/attr.c           | 14 +++++++++++---
 fs/nfsd/nfs4state.c | 18 +++++++++++++-----
 fs/nfsd/nfs4xdr.c   |  2 +-
 fs/nfsd/state.h     |  2 +-
 include/linux/fs.h  |  1 +
 5 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 960a310581ebb..0dbf43b6555c8 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -489,9 +489,17 @@ int notify_change(struct mnt_idmap *idmap, struct dentry *dentry,
 	error = security_inode_setattr(idmap, dentry, attr);
 	if (error)
 		return error;
-	error = try_break_deleg(inode, delegated_inode);
-	if (error)
-		return error;
+
+	/*
+	 * If ATTR_DELEG is set, then these attributes are being set on
+	 * behalf of the holder of a write delegation. We want to avoid
+	 * breaking the delegation in this case.
+	 */
+	if (!(ia_valid & ATTR_DELEG)) {
+		error = try_break_deleg(inode, delegated_inode);
+		if (error)
+			return error;
+	}
 
 	if (inode->i_op->setattr)
 		error = inode->i_op->setattr(idmap, dentry, attr);
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 02d43f95146ee..07f2496850c4c 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -8815,7 +8815,7 @@ nfsd4_get_writestateid(struct nfsd4_compound_state *cstate,
 /**
  * nfsd4_deleg_getattr_conflict - Recall if GETATTR causes conflict
  * @rqstp: RPC transaction context
- * @inode: file to be checked for a conflict
+ * @dentry: dentry of inode to be checked for a conflict
  * @modified: return true if file was modified
  * @size: new size of file if modified is true
  *
@@ -8830,7 +8830,7 @@ nfsd4_get_writestateid(struct nfsd4_compound_state *cstate,
  * code is returned.
  */
 __be32
-nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp, struct inode *inode,
+nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp, struct dentry *dentry,
 				bool *modified, u64 *size)
 {
 	__be32 status;
@@ -8839,6 +8839,7 @@ nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp, struct inode *inode,
 	struct file_lease *fl;
 	struct iattr attrs;
 	struct nfs4_cb_fattr *ncf;
+	struct inode *inode = d_inode(dentry);
 
 	*modified = false;
 	ctx = locks_inode_context(inode);
@@ -8890,15 +8891,22 @@ nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp, struct inode *inode,
 					ncf->ncf_cur_fsize != ncf->ncf_cb_fsize))
 				ncf->ncf_file_modified = true;
 			if (ncf->ncf_file_modified) {
+				int err;
+
 				/*
 				 * Per section 10.4.3 of RFC 8881, the server would
 				 * not update the file's metadata with the client's
 				 * modified size
 				 */
 				attrs.ia_mtime = attrs.ia_ctime = current_time(inode);
-				attrs.ia_valid = ATTR_MTIME | ATTR_CTIME;
-				setattr_copy(&nop_mnt_idmap, inode, &attrs);
-				mark_inode_dirty(inode);
+				attrs.ia_valid = ATTR_MTIME | ATTR_CTIME | ATTR_DELEG;
+				inode_lock(inode);
+				err = notify_change(&nop_mnt_idmap, dentry, &attrs, NULL);
+				inode_unlock(inode);
+				if (err) {
+					nfs4_put_stid(&dp->dl_stid);
+					return nfserrno(err);
+				}
 				ncf->ncf_cur_fsize = ncf->ncf_cb_fsize;
 				*size = ncf->ncf_cur_fsize;
 				*modified = true;
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 8a7bc2b58e721..0869062280ccc 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3565,7 +3565,7 @@ nfsd4_encode_fattr4(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 	}
 	args.size = 0;
 	if (attrmask[0] & (FATTR4_WORD0_CHANGE | FATTR4_WORD0_SIZE)) {
-		status = nfsd4_deleg_getattr_conflict(rqstp, d_inode(dentry),
+		status = nfsd4_deleg_getattr_conflict(rqstp, dentry,
 					&file_modified, &size);
 		if (status)
 			goto out;
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index ffc217099d191..ec4559ecd193b 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -781,5 +781,5 @@ static inline bool try_to_expire_client(struct nfs4_client *clp)
 }
 
 extern __be32 nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp,
-		struct inode *inode, bool *file_modified, u64 *size);
+		struct dentry *dentry, bool *file_modified, u64 *size);
 #endif   /* NFSD4_STATE_H */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 36b9e87439221..5f07c1c377df6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -208,6 +208,7 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define ATTR_OPEN	(1 << 15) /* Truncating from open(O_TRUNC) */
 #define ATTR_TIMES_SET	(1 << 16)
 #define ATTR_TOUCH	(1 << 17)
+#define ATTR_DELEG	(1 << 18) /* Delegated attrs. Don't break write delegations */
 
 /*
  * Whiteout is represented by a char device.  The following constants define the
-- 
2.43.0



