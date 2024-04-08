Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448E542046;
	Mon,  8 Apr 2024 13:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584357; cv=none; b=e1oeSZYWxaKAfrJyHv50UftYjpD3482k5RVJt/QNBXrXeRV/QsttZulAalyQ4V8W9aEyaxs44xsTkO4Yw3OLnpII8Awfq6zBFEweD3f8OQkN6uox+LptVdEpF6pGcBcDnr4I6b4xwz3hWikNi8ulsMjOd3VfUjd8sxfmXj2I2UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584357; c=relaxed/simple;
	bh=zQ0G8t3Hd+9DaFpJPfrmsGI5P0uQQIBsaLLAhnPugNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgWGhQTwRktqDwK+1M/q3qYt/r6GUmMuLts/beo0osYL7B+jiGV00XHXi/rGHb3+0swOKEaKxGJZF9zxMB+QjcRIbbvnrjS4KhKrAV/mvZ9Q4uKMJsU15HlqrGg0svnmcpdbbU5wlDvr5q/ADPDdty7wXyME+r76x/0oFa/cRiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TmLfKKms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TmLfKKms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D0AC433C7;
	Mon,  8 Apr 2024 13:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584357;
	bh=zQ0G8t3Hd+9DaFpJPfrmsGI5P0uQQIBsaLLAhnPugNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TmLfKKms/eVOEx47E86ExM+KLJqWO3+0W7pgG50hpjrrIw/wERUJwEjUY3YmrUFOh
	 +6Gfm0Tm5IbezUVHejFCZQu5HTxrjUg8tqgQd75ekWR1KNAXxefaP22sw1dJGp5YS6
	 C5DMWlLzzjK8f4yFwGqEcxEFljEJChrnQcbC9oJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 410/690] NFSD: reduce locking in nfsd_lookup()
Date: Mon,  8 Apr 2024 14:54:36 +0200
Message-ID: <20240408125414.432780016@linuxfoundation.org>
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

[ Upstream commit 19d008b46941b8c668402170522e0f7a9258409c ]

nfsd_lookup() takes an exclusive lock on the parent inode, but no
callers want the lock and it may not be needed at all if the
result is in the dcache.

Change nfsd_lookup_dentry() to not take the lock, and call
lookup_one_len_locked() which takes lock only if needed.

nfsd4_open() currently expects the lock to still be held, but that isn't
necessary as nfsd_validate_delegated_dentry() provides required
guarantees without the lock.

NOTE: NFSv4 requires directory changeinfo for OPEN even when a create
  wasn't requested and no change happened.  Now that nfsd_lookup()
  doesn't use fh_lock(), we need to explicitly fill the attributes
  when no create happens.  A new fh_fill_both_attrs() is provided
  for that task.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c  | 20 ++++++++++++--------
 fs/nfsd/nfs4state.c |  3 ---
 fs/nfsd/nfsfh.c     | 19 +++++++++++++++++++
 fs/nfsd/nfsfh.h     |  2 +-
 fs/nfsd/vfs.c       | 34 ++++++++++++++--------------------
 5 files changed, 46 insertions(+), 32 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 26cd2479e30cf..b6df56fb6755d 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -302,6 +302,11 @@ nfsd4_create_file(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (d_really_is_positive(child)) {
 		status = nfs_ok;
 
+		/* NFSv4 protocol requires change attributes even though
+		 * no change happened.
+		 */
+		fh_fill_both_attrs(fhp);
+
 		switch (open->op_createmode) {
 		case NFS4_CREATE_UNCHECKED:
 			if (!d_is_reg(child))
@@ -417,15 +422,15 @@ do_open_lookup(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate, stru
 		if (nfsd4_create_is_exclusive(open->op_createmode) && status == 0)
 			open->op_bmval[1] |= (FATTR4_WORD1_TIME_ACCESS |
 						FATTR4_WORD1_TIME_MODIFY);
-	} else
-		/*
-		 * Note this may exit with the parent still locked.
-		 * We will hold the lock until nfsd4_open's final
-		 * lookup, to prevent renames or unlinks until we've had
-		 * a chance to an acquire a delegation if appropriate.
-		 */
+	} else {
 		status = nfsd_lookup(rqstp, current_fh,
 				     open->op_fname, open->op_fnamelen, *resfh);
+		if (!status)
+			/* NFSv4 protocol requires change attributes even though
+			 * no change happened.
+			 */
+			fh_fill_both_attrs(current_fh);
+	}
 	if (status)
 		goto out;
 	status = nfsd_check_obj_isreg(*resfh);
@@ -1043,7 +1048,6 @@ nfsd4_secinfo(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 				    &exp, &dentry);
 	if (err)
 		return err;
-	fh_unlock(&cstate->current_fh);
 	if (d_really_is_negative(dentry)) {
 		exp_put(exp);
 		err = nfserr_noent;
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index a299aeaa0de07..f66fb39714893 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5321,9 +5321,6 @@ nfsd4_verify_deleg_dentry(struct nfsd4_open *open, struct nfs4_file *fp,
 	struct dentry *child;
 	__be32 err;
 
-	/* parent may already be locked, and it may get unlocked by
-	 * this call, but that is safe.
-	 */
 	err = nfsd_lookup_dentry(open->op_rqstp, parent,
 				 open->op_fname, open->op_fnamelen,
 				 &exp, &child);
diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index 5e2ed4b2a925c..cd2946a88d727 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -672,6 +672,25 @@ void fh_fill_post_attrs(struct svc_fh *fhp)
 			nfsd4_change_attribute(&fhp->fh_post_attr, inode);
 }
 
+/**
+ * fh_fill_both_attrs - Fill pre-op and post-op attributes
+ * @fhp: file handle to be updated
+ *
+ * This is used when the directory wasn't changed, but wcc attributes
+ * are needed anyway.
+ */
+void fh_fill_both_attrs(struct svc_fh *fhp)
+{
+	fh_fill_post_attrs(fhp);
+	if (!fhp->fh_post_saved)
+		return;
+	fhp->fh_pre_change = fhp->fh_post_change;
+	fhp->fh_pre_mtime = fhp->fh_post_attr.mtime;
+	fhp->fh_pre_ctime = fhp->fh_post_attr.ctime;
+	fhp->fh_pre_size = fhp->fh_post_attr.size;
+	fhp->fh_pre_saved = true;
+}
+
 /*
  * Release a file handle.
  */
diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index fb9d358a267e5..28a4f9a94e2c8 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -322,7 +322,7 @@ static inline u64 nfsd4_change_attribute(struct kstat *stat,
 
 extern void fh_fill_pre_attrs(struct svc_fh *fhp);
 extern void fh_fill_post_attrs(struct svc_fh *fhp);
-
+extern void fh_fill_both_attrs(struct svc_fh *fhp);
 
 /*
  * Lock a file handle/inode
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index ac716ced1fd5f..c07fe50d6bdfb 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -198,27 +198,13 @@ nfsd_lookup_dentry(struct svc_rqst *rqstp, struct svc_fh *fhp,
 				goto out_nfserr;
 		}
 	} else {
-		/*
-		 * In the nfsd4_open() case, this may be held across
-		 * subsequent open and delegation acquisition which may
-		 * need to take the child's i_mutex:
-		 */
-		fh_lock_nested(fhp, I_MUTEX_PARENT);
-		dentry = lookup_one_len(name, dparent, len);
+		dentry = lookup_one_len_unlocked(name, dparent, len);
 		host_err = PTR_ERR(dentry);
 		if (IS_ERR(dentry))
 			goto out_nfserr;
 		if (nfsd_mountpoint(dentry, exp)) {
-			/*
-			 * We don't need the i_mutex after all.  It's
-			 * still possible we could open this (regular
-			 * files can be mountpoints too), but the
-			 * i_mutex is just there to prevent renames of
-			 * something that we might be about to delegate,
-			 * and a mountpoint won't be renamed:
-			 */
-			fh_unlock(fhp);
-			if ((host_err = nfsd_cross_mnt(rqstp, &dentry, &exp))) {
+			host_err = nfsd_cross_mnt(rqstp, &dentry, &exp);
+			if (host_err) {
 				dput(dentry);
 				goto out_nfserr;
 			}
@@ -233,7 +219,15 @@ nfsd_lookup_dentry(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	return nfserrno(host_err);
 }
 
-/*
+/**
+ * nfsd_lookup - look up a single path component for nfsd
+ *
+ * @rqstp:   the request context
+ * @fhp:     the file handle of the directory
+ * @name:    the component name, or %NULL to look up parent
+ * @len:     length of name to examine
+ * @resfh:   pointer to pre-initialised filehandle to hold result.
+ *
  * Look up one component of a pathname.
  * N.B. After this call _both_ fhp and resfh need an fh_put
  *
@@ -243,11 +237,11 @@ nfsd_lookup_dentry(struct svc_rqst *rqstp, struct svc_fh *fhp,
  * returned. Otherwise the covered directory is returned.
  * NOTE: this mountpoint crossing is not supported properly by all
  *   clients and is explicitly disallowed for NFSv3
- *      NeilBrown <neilb@cse.unsw.edu.au>
+ *
  */
 __be32
 nfsd_lookup(struct svc_rqst *rqstp, struct svc_fh *fhp, const char *name,
-				unsigned int len, struct svc_fh *resfh)
+	    unsigned int len, struct svc_fh *resfh)
 {
 	struct svc_export	*exp;
 	struct dentry		*dentry;
-- 
2.43.0



