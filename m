Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEFD155736;
	Tue, 18 Jun 2024 13:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715885; cv=none; b=gVoWX0kdBjPvISzYM0V6LcKwqWNIA04qZanxpVUY3XIzjlmG7lVz/ac8tLUEgtm4gnM+pewNbFYnYbE1HMXNwkh/Ypn0bqe1qtXiBLohbziy6SEeeDZMn2vjQE+dmqyBjxyNsXuUgHZn61OK0wkJxr90keK1J3cZdHAiHlXGzjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715885; c=relaxed/simple;
	bh=CL5Cdwdh4ZIkKbR5q44yfYhIczhX1Wg0c+HnpLNA57A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqQnlbnKFWIZWeIKW+tRSaXU95otkp0oesb4ITjlJ1rJVRrafgmM/UhN9Vr8pVSIRh79l8V+gumxlMxALAtt8s+p5ms14v+OhpFhWQKJiXSY8OjRDnS+/jkXJUj5G+I7r2JAOh4S9z12h8nl6JwXikRjS+wQO9gRlw/j9qlSKhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNPB627I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNPB627I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DC3C3277B;
	Tue, 18 Jun 2024 13:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715885;
	bh=CL5Cdwdh4ZIkKbR5q44yfYhIczhX1Wg0c+HnpLNA57A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNPB627ITUKKfp8gyEmF5Hjef/EFjQbq4GZCA5xBYqxyhEK242tGLl4/bGgxI+7W3
	 nHNZS48A0SK83RZ4/5zq0PnQmkvGVJsUUnaFmMbRHtwKwLfiV4B4ecMveiaz7zDJOY
	 N18TE30F5thsNgmoszmNSMRyiyev7cGxwE0NR/pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 460/770] NFSD: Move fill_pre_wcc() and fill_post_wcc()
Date: Tue, 18 Jun 2024 14:35:13 +0200
Message-ID: <20240618123425.069184195@linuxfoundation.org>
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

[ Upstream commit fcb5e3fa012351f3b96024c07bc44834c2478213 ]

These functions are related to file handle processing and have
nothing to do with XDR encoding or decoding. Also they are no longer
NFSv3-specific. As a clean-up, move their definitions to a more
appropriate location. WCC is also an NFSv3-specific term, so rename
them as general-purpose helpers.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c  | 55 --------------------------------------
 fs/nfsd/nfs4proc.c |  2 +-
 fs/nfsd/nfsfh.c    | 66 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/nfsd/nfsfh.h    | 40 ++++++++++++++++++----------
 fs/nfsd/vfs.c      |  8 +++---
 5 files changed, 96 insertions(+), 75 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 84088581bbe09..7c45ba4db61be 100644
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
index e8ffaa7faced9..451190813302e 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2523,7 +2523,7 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 			goto encode_op;
 		}
 
-		fh_clear_wcc(current_fh);
+		fh_clear_pre_post_attrs(current_fh);
 
 		/* If op is non-idempotent */
 		if (op->opdesc->op_flags & OP_MODIFIES_SOMETHING) {
diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index 34e201b6eb623..3b9751555f8f2 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -610,6 +610,70 @@ fh_update(struct svc_fh *fhp)
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
@@ -622,7 +686,7 @@ fh_put(struct svc_fh *fhp)
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
index 77f48779210d0..d4b6bc3b4d735 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1787,8 +1787,8 @@ nfsd_rename(struct svc_rqst *rqstp, struct svc_fh *ffhp, char *fname, int flen,
 	 * so do it by hand */
 	trap = lock_rename(tdentry, fdentry);
 	ffhp->fh_locked = tfhp->fh_locked = true;
-	fill_pre_wcc(ffhp);
-	fill_pre_wcc(tfhp);
+	fh_fill_pre_attrs(ffhp);
+	fh_fill_pre_attrs(tfhp);
 
 	odentry = lookup_one_len(fname, fdentry, flen);
 	host_err = PTR_ERR(odentry);
@@ -1840,8 +1840,8 @@ nfsd_rename(struct svc_rqst *rqstp, struct svc_fh *ffhp, char *fname, int flen,
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



