Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2943F81754;
	Mon,  8 Apr 2024 13:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584075; cv=none; b=DdXthcxW8hH7m/TMzI4S98nGFIEO7lxwIcs68K8SeNu68XrepqaAfs+tfBJShLEai1aCALdUR3Fskv3IO5Gkep/R/zAKFVkCI5DZBm1Kf71BwsuoPG3zxPwkGPgCkPTjbFJo4+SepD8s0FfW6unJ34i0RerUNdhtB9DFKYTpsTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584075; c=relaxed/simple;
	bh=oyDtS4OKyzxux7Zm9jFzBja0ww/UQRumeesEEnTtGtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5ZVWB6Or/GckcRWx+S0sO+2IZXbO1X+kmf8gWc2ERnH9abaayHywrZbf3e9RiAuOXtQJxnTbn4QJ6r4g5EoyUl2SYNwjVNeKTLGwRH8r6lHt8EGlPx62OvHJtjtTfWH0d2pj/zqqb7kKUds92GQCl9WGIW0aWz45rBNgdMMCuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LuMLIy9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LuMLIy9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54905C433F1;
	Mon,  8 Apr 2024 13:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584074;
	bh=oyDtS4OKyzxux7Zm9jFzBja0ww/UQRumeesEEnTtGtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LuMLIy9J9fDStmXmnqO4Z8PwfkBfiHdsFj1OAPgIyOK/aWQpUlv0EGu3jb/szWHl8
	 hVurdgt6GYzuKTMzoxm6mTTdVLJq5TLsEJ1p9A330PDalAcgoXVIxu+fugdpkTnxIF
	 KXvVgmVTe8bG8NGeBWQF0Cecnx/BeDD0C0WComYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 316/690] NFSD: Refactor nfsd_create_setattr()
Date: Mon,  8 Apr 2024 14:53:02 +0200
Message-ID: <20240408125411.048901863@linuxfoundation.org>
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

[ Upstream commit 5f46e950c395b9c14c282b53ba78c5fd46d6c256 ]

I'd like to move do_nfsd_create() out of vfs.c. Therefore
nfsd_create_setattr() needs to be made publicly visible.

Note that both call sites in vfs.c commit both the new object and
its parent directory, so just combine those common metadata commits
into nfsd_create_setattr().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/vfs.c | 79 +++++++++++++++++++++++++++------------------------
 fs/nfsd/vfs.h |  2 ++
 2 files changed, 44 insertions(+), 37 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index a46ab32216dee..e4f100a43ce52 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1189,14 +1189,26 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp, u64 offset,
 	return err;
 }
 
-static __be32
-nfsd_create_setattr(struct svc_rqst *rqstp, struct svc_fh *resfhp,
-			struct iattr *iap)
+/**
+ * nfsd_create_setattr - Set a created file's attributes
+ * @rqstp: RPC transaction being executed
+ * @fhp: NFS filehandle of parent directory
+ * @resfhp: NFS filehandle of new object
+ * @iap: requested attributes of new object
+ *
+ * Returns nfs_ok on success, or an nfsstat in network byte order.
+ */
+__be32
+nfsd_create_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
+		    struct svc_fh *resfhp, struct iattr *iap)
 {
+	__be32 status;
+
 	/*
-	 * Mode has already been set earlier in create:
+	 * Mode has already been set by file creation.
 	 */
 	iap->ia_valid &= ~ATTR_MODE;
+
 	/*
 	 * Setting uid/gid works only for root.  Irix appears to
 	 * send along the gid on create when it tries to implement
@@ -1204,10 +1216,31 @@ nfsd_create_setattr(struct svc_rqst *rqstp, struct svc_fh *resfhp,
 	 */
 	if (!uid_eq(current_fsuid(), GLOBAL_ROOT_UID))
 		iap->ia_valid &= ~(ATTR_UID|ATTR_GID);
+
+	/*
+	 * Callers expect new file metadata to be committed even
+	 * if the attributes have not changed.
+	 */
 	if (iap->ia_valid)
-		return nfsd_setattr(rqstp, resfhp, iap, 0, (time64_t)0);
-	/* Callers expect file metadata to be committed here */
-	return nfserrno(commit_metadata(resfhp));
+		status = nfsd_setattr(rqstp, resfhp, iap, 0, (time64_t)0);
+	else
+		status = nfserrno(commit_metadata(resfhp));
+
+	/*
+	 * Transactional filesystems had a chance to commit changes
+	 * for both parent and child simultaneously making the
+	 * following commit_metadata a noop in many cases.
+	 */
+	if (!status)
+		status = nfserrno(commit_metadata(fhp));
+
+	/*
+	 * Update the new filehandle to pick up the new attributes.
+	 */
+	if (!status)
+		status = fh_update(resfhp);
+
+	return status;
 }
 
 /* HPUX client sometimes creates a file in mode 000, and sets size to 0.
@@ -1234,7 +1267,6 @@ nfsd_create_locked(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	struct dentry	*dentry, *dchild;
 	struct inode	*dirp;
 	__be32		err;
-	__be32		err2;
 	int		host_err;
 
 	dentry = fhp->fh_dentry;
@@ -1307,22 +1339,8 @@ nfsd_create_locked(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (host_err < 0)
 		goto out_nfserr;
 
-	err = nfsd_create_setattr(rqstp, resfhp, iap);
+	err = nfsd_create_setattr(rqstp, fhp, resfhp, iap);
 
-	/*
-	 * nfsd_create_setattr already committed the child.  Transactional
-	 * filesystems had a chance to commit changes for both parent and
-	 * child simultaneously making the following commit_metadata a
-	 * noop.
-	 */
-	err2 = nfserrno(commit_metadata(fhp));
-	if (err2)
-		err = err2;
-	/*
-	 * Update the file handle to get the new inode info.
-	 */
-	if (!err)
-		err = fh_update(resfhp);
 out:
 	dput(dchild);
 	return err;
@@ -1513,20 +1531,7 @@ do_nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	}
 
  set_attr:
-	err = nfsd_create_setattr(rqstp, resfhp, iap);
-
-	/*
-	 * nfsd_create_setattr already committed the child
-	 * (and possibly also the parent).
-	 */
-	if (!err)
-		err = nfserrno(commit_metadata(fhp));
-
-	/*
-	 * Update the filehandle to get the new inode info.
-	 */
-	if (!err)
-		err = fh_update(resfhp);
+	err = nfsd_create_setattr(rqstp, fhp, resfhp, iap);
 
  out:
 	fh_unlock(fhp);
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index ccb87b2864f64..1f32a83456b03 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -69,6 +69,8 @@ __be32		nfsd_create(struct svc_rqst *, struct svc_fh *,
 				char *name, int len, struct iattr *attrs,
 				int type, dev_t rdev, struct svc_fh *res);
 __be32		nfsd_access(struct svc_rqst *, struct svc_fh *, u32 *, u32 *);
+__be32		nfsd_create_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
+				struct svc_fh *resfhp, struct iattr *iap);
 __be32		do_nfsd_create(struct svc_rqst *, struct svc_fh *,
 				char *name, int len, struct iattr *attrs,
 				struct svc_fh *res, int createmode,
-- 
2.43.0



