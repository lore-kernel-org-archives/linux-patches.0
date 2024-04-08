Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F647FBDF;
	Mon,  8 Apr 2024 13:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583801; cv=none; b=F6rl2SnesLvWwUakYwUlClhZtADNII+PPdVpYmgHV3f5lz4kkRDGWvakV+PEIE/F/RcQV5SCIrjE2JJO8Za0Vt/xsthiFjyGpOuE8x4K6sTpZkzb1HjT2qAF8Ki+xcVGlseFSFCT1VHuMVxtMF9x4g3gQPa2Zm8zi2TB0HDcMbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583801; c=relaxed/simple;
	bh=XExZ+qsjS9PVpjHUH07OPP5llz40wBhNfQBf0kEghMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFD/uqiLGvJs06uaUeP7fkXup/G4n5SgfmyC0Of9Jzz6VAbCOHKsj7jDIBRTalUjRcW9nOK6rlOTLa041P5btgxVKXZJ1CBfOVGK+Dd0DNQ/KUTPvGyCkX7t1ca6KL2yeC5VgQotWTt/lj98YSCW68g6Al90ptlfbwvH7T8Z5Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JuwiScNu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuwiScNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B90C43390;
	Mon,  8 Apr 2024 13:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583801;
	bh=XExZ+qsjS9PVpjHUH07OPP5llz40wBhNfQBf0kEghMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JuwiScNuNtCdkaFpsWjWzmJLMyZdQta8hR2HAd09+rXael/9Uerq15LwxYansKPtK
	 lAX3YgmAFua5a1jdNdeffAmzcs4J+2j8vTFXj73Psk0ITUD3PbeISg/i2D6l6NWvVX
	 Z/Bf/qCdfeJOu60vJR0gzjgP0mc8oIyz/v2+i5cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 264/690] NFSD: Move fill_pre_wcc() and fill_post_wcc()
Date: Mon,  8 Apr 2024 14:52:10 +0200
Message-ID: <20240408125409.183054156@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit fcb5e3fa012351f3b96024c07bc44834c2478213 ]

These functions are related to file handle processing and have
nothing to do with XDR encoding or decoding. Also they are no longer
NFSv3-specific. As a clean-up, move their definitions to a more
appropriate location. WCC is also an NFSv3-specific term, so rename
them as general-purpose helpers.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs3xdr.c  | 55 --------------------------------------
 fs/nfsd/nfs4proc.c |  2 +-
 fs/nfsd/nfsfh.c    | 66 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/nfsd/nfsfh.h    | 40 ++++++++++++++++++----------
 fs/nfsd/vfs.c      |  8 +++---
 5 files changed, 96 insertions(+), 75 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 48e8a02ebc83b..2e47a07029f1d 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -487,61 +487,6 @@ svcxdr_encode_wcc_data(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 	return true;
 }
 
-/*
- * Fill in the pre_op attr for the wcc data
- */
-void fill_pre_wcc(struct svc_fh *fhp)
-{
-	struct inode    *inode;
-	struct kstat	stat;
-	bool v4 = (fhp->fh_maxsize == NFS4_FHSIZE);
-	__be32 err;
-
-	if (fhp->fh_no_wcc || fhp->fh_pre_saved)
-		return;
-	inode = d_inode(fhp->fh_dentry);
-	err = fh_getattr(fhp, &stat);
-	if (err) {
-		/* Grab the times from inode anyway */
-		stat.mtime = inode->i_mtime;
-		stat.ctime = inode->i_ctime;
-		stat.size  = inode->i_size;
-	}
-	if (v4)
-		fhp->fh_pre_change = nfsd4_change_attribute(&stat, inode);
-
-	fhp->fh_pre_mtime = stat.mtime;
-	fhp->fh_pre_ctime = stat.ctime;
-	fhp->fh_pre_size  = stat.size;
-	fhp->fh_pre_saved = true;
-}
-
-/*
- * Fill in the post_op attr for the wcc data
- */
-void fill_post_wcc(struct svc_fh *fhp)
-{
-	bool v4 = (fhp->fh_maxsize == NFS4_FHSIZE);
-	struct inode *inode = d_inode(fhp->fh_dentry);
-	__be32 err;
-
-	if (fhp->fh_no_wcc)
-		return;
-
-	if (fhp->fh_post_saved)
-		printk("nfsd: inode locked twice during operation.\n");
-
-	err = fh_getattr(fhp, &fhp->fh_post_attr);
-	if (err) {
-		fhp->fh_post_saved = false;
-		fhp->fh_post_attr.ctime = inode->i_ctime;
-	} else
-		fhp->fh_post_saved = true;
-	if (v4)
-		fhp->fh_post_change =
-			nfsd4_change_attribute(&fhp->fh_post_attr, inode);
-}
-
 /*
  * XDR decode functions
  */
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index a8ad7e6ace927..73c62561580a1 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2536,7 +2536,7 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 			goto encode_op;
 		}
 
-		fh_clear_wcc(current_fh);
+		fh_clear_pre_post_attrs(current_fh);
 
 		/* If op is non-idempotent */
 		if (op->opdesc->op_flags & OP_MODIFIES_SOMETHING) {
diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index f3779fa72c896..145208bcb9bd4 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -611,6 +611,70 @@ fh_update(struct svc_fh *fhp)
 	return nfserr_serverfault;
 }
 
+#ifdef CONFIG_NFSD_V3
+
+/**
+ * fh_fill_pre_attrs - Fill in pre-op attributes
+ * @fhp: file handle to be updated
+ *
+ */
+void fh_fill_pre_attrs(struct svc_fh *fhp)
+{
+	bool v4 = (fhp->fh_maxsize == NFS4_FHSIZE);
+	struct inode *inode;
+	struct kstat stat;
+	__be32 err;
+
+	if (fhp->fh_no_wcc || fhp->fh_pre_saved)
+		return;
+
+	inode = d_inode(fhp->fh_dentry);
+	err = fh_getattr(fhp, &stat);
+	if (err) {
+		/* Grab the times from inode anyway */
+		stat.mtime = inode->i_mtime;
+		stat.ctime = inode->i_ctime;
+		stat.size  = inode->i_size;
+	}
+	if (v4)
+		fhp->fh_pre_change = nfsd4_change_attribute(&stat, inode);
+
+	fhp->fh_pre_mtime = stat.mtime;
+	fhp->fh_pre_ctime = stat.ctime;
+	fhp->fh_pre_size  = stat.size;
+	fhp->fh_pre_saved = true;
+}
+
+/**
+ * fh_fill_post_attrs - Fill in post-op attributes
+ * @fhp: file handle to be updated
+ *
+ */
+void fh_fill_post_attrs(struct svc_fh *fhp)
+{
+	bool v4 = (fhp->fh_maxsize == NFS4_FHSIZE);
+	struct inode *inode = d_inode(fhp->fh_dentry);
+	__be32 err;
+
+	if (fhp->fh_no_wcc)
+		return;
+
+	if (fhp->fh_post_saved)
+		printk("nfsd: inode locked twice during operation.\n");
+
+	err = fh_getattr(fhp, &fhp->fh_post_attr);
+	if (err) {
+		fhp->fh_post_saved = false;
+		fhp->fh_post_attr.ctime = inode->i_ctime;
+	} else
+		fhp->fh_post_saved = true;
+	if (v4)
+		fhp->fh_post_change =
+			nfsd4_change_attribute(&fhp->fh_post_attr, inode);
+}
+
+#endif /* CONFIG_NFSD_V3 */
+
 /*
  * Release a file handle.
  */
@@ -623,7 +687,7 @@ fh_put(struct svc_fh *fhp)
 		fh_unlock(fhp);
 		fhp->fh_dentry = NULL;
 		dput(dentry);
-		fh_clear_wcc(fhp);
+		fh_clear_pre_post_attrs(fhp);
 	}
 	fh_drop_write(fhp);
 	if (exp) {
diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index d11e4b6870d68..434930d8a946e 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -284,12 +284,13 @@ static inline u32 knfsd_fh_hash(const struct knfsd_fh *fh)
 #endif
 
 #ifdef CONFIG_NFSD_V3
-/*
- * The wcc data stored in current_fh should be cleared
- * between compound ops.
+
+/**
+ * fh_clear_pre_post_attrs - Reset pre/post attributes
+ * @fhp: file handle to be updated
+ *
  */
-static inline void
-fh_clear_wcc(struct svc_fh *fhp)
+static inline void fh_clear_pre_post_attrs(struct svc_fh *fhp)
 {
 	fhp->fh_post_saved = false;
 	fhp->fh_pre_saved = false;
@@ -323,13 +324,24 @@ static inline u64 nfsd4_change_attribute(struct kstat *stat,
 		return time_to_chattr(&stat->ctime);
 }
 
-extern void fill_pre_wcc(struct svc_fh *fhp);
-extern void fill_post_wcc(struct svc_fh *fhp);
-#else
-#define fh_clear_wcc(ignored)
-#define fill_pre_wcc(ignored)
-#define fill_post_wcc(notused)
-#endif /* CONFIG_NFSD_V3 */
+extern void fh_fill_pre_attrs(struct svc_fh *fhp);
+extern void fh_fill_post_attrs(struct svc_fh *fhp);
+
+#else /* !CONFIG_NFSD_V3 */
+
+static inline void fh_clear_pre_post_attrs(struct svc_fh *fhp)
+{
+}
+
+static inline void fh_fill_pre_attrs(struct svc_fh *fhp)
+{
+}
+
+static inline void fh_fill_post_attrs(struct svc_fh *fhp)
+{
+}
+
+#endif /* !CONFIG_NFSD_V3 */
 
 
 /*
@@ -355,7 +367,7 @@ fh_lock_nested(struct svc_fh *fhp, unsigned int subclass)
 
 	inode = d_inode(dentry);
 	inode_lock_nested(inode, subclass);
-	fill_pre_wcc(fhp);
+	fh_fill_pre_attrs(fhp);
 	fhp->fh_locked = true;
 }
 
@@ -372,7 +384,7 @@ static inline void
 fh_unlock(struct svc_fh *fhp)
 {
 	if (fhp->fh_locked) {
-		fill_post_wcc(fhp);
+		fh_fill_post_attrs(fhp);
 		inode_unlock(d_inode(fhp->fh_dentry));
 		fhp->fh_locked = false;
 	}
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 284dc900d10ba..4d07a506164b0 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1793,8 +1793,8 @@ nfsd_rename(struct svc_rqst *rqstp, struct svc_fh *ffhp, char *fname, int flen,
 	 * so do it by hand */
 	trap = lock_rename(tdentry, fdentry);
 	ffhp->fh_locked = tfhp->fh_locked = true;
-	fill_pre_wcc(ffhp);
-	fill_pre_wcc(tfhp);
+	fh_fill_pre_attrs(ffhp);
+	fh_fill_pre_attrs(tfhp);
 
 	odentry = lookup_one_len(fname, fdentry, flen);
 	host_err = PTR_ERR(odentry);
@@ -1848,8 +1848,8 @@ nfsd_rename(struct svc_rqst *rqstp, struct svc_fh *ffhp, char *fname, int flen,
 	 * were the same, so again we do it by hand.
 	 */
 	if (!close_cached) {
-		fill_post_wcc(ffhp);
-		fill_post_wcc(tfhp);
+		fh_fill_post_attrs(ffhp);
+		fh_fill_post_attrs(tfhp);
 	}
 	unlock_rename(tdentry, fdentry);
 	ffhp->fh_locked = tfhp->fh_locked = false;
-- 
2.43.0



