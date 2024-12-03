Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264FA1F76D1;
	Tue,  3 Dec 2024 16:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241892; cv=none; b=kGNQ0b+8KBn8ugvg5AdZTqU0k3Cp0sWN9dYYwXW+tp8Ki+tsdXmMFgueX8DWhj8m+mnStgTgmi4XN72R9udhysD1MJ0Pj95dxuACBkwQ9CsQA1SK2+nbhmplhIm8Bz3FzQHikfrw1FzLTXcv0vOQcdqaZgQeRigB5upLCbWNqqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241892; c=relaxed/simple;
	bh=Wf7RgiQm9ztBAv8bV4XZMV4tpIlZ+W6cw6xrO5SkEAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3cL2hFpsfCyDp5SxNQjlQqJo3zQlyManJ8O29AAGnqAuuD00KEaEeWP8fYtdmOD5nf9psrZNB/rJlpr3/GS4LeGLdxLM5RhPPpUMbWvYrxZkEOgzpXH6w8XfACnZflw49yvp3y3/p+PHPbaZs+HOmmRDb+pcAAzqMbZlZSBos4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Im3VYAki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Im3VYAki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD26C4CECF;
	Tue,  3 Dec 2024 16:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241892;
	bh=Wf7RgiQm9ztBAv8bV4XZMV4tpIlZ+W6cw6xrO5SkEAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Im3VYAkitm8uZI01i0WOnwqo2pC+hmIFrT6eKBy9bC9ieVmTRRQiNig50ptJK5iQ2
	 Saq1u4nl/BPSxl5/jLNtLGhNiLbLnY229EVrrfIuDE99lM4hdjInVg+irpq9QmNql4
	 x2B0MXzp80/9YR61trMiDswdGC1qwpOSgQIcN0yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 514/826] nfsd: drop inode parameter from nfsd4_change_attribute()
Date: Tue,  3 Dec 2024 15:44:01 +0100
Message-ID: <20241203144803.815182738@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit f67eef8da0e8c54709fefdecd16ad8d70f0c9d20 ]

The inode that nfs4_open_delegation() passes to this function is
wrong, which throws off the result. The inode will end up getting a
directory-style change attr instead of a regular-file-style one.

Fix up nfs4_delegation_stat() to fetch STATX_MODE, and then drop the
inode parameter from nfsd4_change_attribute(), since it's no longer
needed.

Fixes: c5967721e106 ("NFSD: handle GETATTR conflict with write delegation")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c |  5 ++---
 fs/nfsd/nfs4xdr.c   |  2 +-
 fs/nfsd/nfsfh.c     | 20 ++++++++++++--------
 fs/nfsd/nfsfh.h     |  3 +--
 4 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 551d2958ec290..d3cfc64715399 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5957,7 +5957,7 @@ nfs4_delegation_stat(struct nfs4_delegation *dp, struct svc_fh *currentfh,
 	path.dentry = file_dentry(nf->nf_file);
 
 	rc = vfs_getattr(&path, stat,
-			 (STATX_SIZE | STATX_CTIME | STATX_CHANGE_COOKIE),
+			 (STATX_MODE | STATX_SIZE | STATX_CTIME | STATX_CHANGE_COOKIE),
 			 AT_STATX_SYNC_AS_STAT);
 
 	nfsd_file_put(nf);
@@ -6041,8 +6041,7 @@ nfs4_open_delegation(struct nfsd4_open *open, struct nfs4_ol_stateid *stp,
 		}
 		open->op_delegate_type = NFS4_OPEN_DELEGATE_WRITE;
 		dp->dl_cb_fattr.ncf_cur_fsize = stat.size;
-		dp->dl_cb_fattr.ncf_initial_cinfo =
-			nfsd4_change_attribute(&stat, d_inode(currentfh->fh_dentry));
+		dp->dl_cb_fattr.ncf_initial_cinfo = nfsd4_change_attribute(&stat);
 		trace_nfsd_deleg_write(&dp->dl_stid.sc_stateid);
 	} else {
 		open->op_delegate_type = NFS4_OPEN_DELEGATE_READ;
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index f118921250c31..8d25aef51ad15 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3040,7 +3040,7 @@ static __be32 nfsd4_encode_fattr4_change(struct xdr_stream *xdr,
 		return nfs_ok;
 	}
 
-	c = nfsd4_change_attribute(&args->stat, d_inode(args->dentry));
+	c = nfsd4_change_attribute(&args->stat);
 	return nfsd4_encode_changeid4(xdr, c);
 }
 
diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index 40ad58a6a0361..96e19c50a5d7e 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -667,20 +667,18 @@ fh_update(struct svc_fh *fhp)
 __be32 __must_check fh_fill_pre_attrs(struct svc_fh *fhp)
 {
 	bool v4 = (fhp->fh_maxsize == NFS4_FHSIZE);
-	struct inode *inode;
 	struct kstat stat;
 	__be32 err;
 
 	if (fhp->fh_no_wcc || fhp->fh_pre_saved)
 		return nfs_ok;
 
-	inode = d_inode(fhp->fh_dentry);
 	err = fh_getattr(fhp, &stat);
 	if (err)
 		return err;
 
 	if (v4)
-		fhp->fh_pre_change = nfsd4_change_attribute(&stat, inode);
+		fhp->fh_pre_change = nfsd4_change_attribute(&stat);
 
 	fhp->fh_pre_mtime = stat.mtime;
 	fhp->fh_pre_ctime = stat.ctime;
@@ -697,7 +695,6 @@ __be32 __must_check fh_fill_pre_attrs(struct svc_fh *fhp)
 __be32 fh_fill_post_attrs(struct svc_fh *fhp)
 {
 	bool v4 = (fhp->fh_maxsize == NFS4_FHSIZE);
-	struct inode *inode = d_inode(fhp->fh_dentry);
 	__be32 err;
 
 	if (fhp->fh_no_wcc)
@@ -713,7 +710,7 @@ __be32 fh_fill_post_attrs(struct svc_fh *fhp)
 	fhp->fh_post_saved = true;
 	if (v4)
 		fhp->fh_post_change =
-			nfsd4_change_attribute(&fhp->fh_post_attr, inode);
+			nfsd4_change_attribute(&fhp->fh_post_attr);
 	return nfs_ok;
 }
 
@@ -804,7 +801,14 @@ enum fsid_source fsid_source(const struct svc_fh *fhp)
 	return FSIDSOURCE_DEV;
 }
 
-/*
+/**
+ * nfsd4_change_attribute - Generate an NFSv4 change_attribute value
+ * @stat: inode attributes
+ *
+ * Caller must fill in @stat before calling, typically by invoking
+ * vfs_getattr() with STATX_MODE, STATX_CTIME, and STATX_CHANGE_COOKIE.
+ * Returns an unsigned 64-bit changeid4 value (RFC 8881 Section 3.2).
+ *
  * We could use i_version alone as the change attribute.  However, i_version
  * can go backwards on a regular file after an unclean shutdown.  On its own
  * that doesn't necessarily cause a problem, but if i_version goes backwards
@@ -821,13 +825,13 @@ enum fsid_source fsid_source(const struct svc_fh *fhp)
  * assume that the new change attr is always logged to stable storage in some
  * fashion before the results can be seen.
  */
-u64 nfsd4_change_attribute(const struct kstat *stat, const struct inode *inode)
+u64 nfsd4_change_attribute(const struct kstat *stat)
 {
 	u64 chattr;
 
 	if (stat->result_mask & STATX_CHANGE_COOKIE) {
 		chattr = stat->change_cookie;
-		if (S_ISREG(inode->i_mode) &&
+		if (S_ISREG(stat->mode) &&
 		    !(stat->attributes & STATX_ATTR_CHANGE_MONOTONIC)) {
 			chattr += (u64)stat->ctime.tv_sec << 30;
 			chattr += stat->ctime.tv_nsec;
diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index 5b7394801dc42..876152a91f122 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -297,8 +297,7 @@ static inline void fh_clear_pre_post_attrs(struct svc_fh *fhp)
 	fhp->fh_pre_saved = false;
 }
 
-u64 nfsd4_change_attribute(const struct kstat *stat,
-			   const struct inode *inode);
+u64 nfsd4_change_attribute(const struct kstat *stat);
 __be32 __must_check fh_fill_pre_attrs(struct svc_fh *fhp);
 __be32 fh_fill_post_attrs(struct svc_fh *fhp);
 __be32 __must_check fh_fill_both_attrs(struct svc_fh *fhp);
-- 
2.43.0



