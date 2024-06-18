Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520E0158A17;
	Tue, 18 Jun 2024 13:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716153; cv=none; b=Am+CJhK6MjtgUxT9VK+fmeiD7hS3HeqadjssbMTjwe3mIrZ6E2msRU3DcvGWFv4Q2/DFfbyM7pJE0rg/Em54aY6JGb80TrpQtaEaQqaLcA7zWTsLbnfNlnJB/kf1PAT8RRgiqG7vH1572KWNb7nGMIxEUTl1FetGBvbwnEjEG+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716153; c=relaxed/simple;
	bh=uWopAAzH/WD+sUrEa4KhmHZlCvIsZ+YOvucivWxdeSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USlxNyz3wf5oGmW9pRz/gsRxEtP9E2WMUqxpejCSD0l3cEhtOPPkdE2eITbtGkZpX8QhCSJBTFN/EopE/cJ9eQhZMJgnQXYDzUgnJ9IlWIkky/0DLVHFayBRyqz7qHbmJf4hnuLDi5KWIqvGgzPJsloEKzjOIzh2bqssan9LDQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NImQ/2GP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NImQ/2GP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A80C3277B;
	Tue, 18 Jun 2024 13:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716153;
	bh=uWopAAzH/WD+sUrEa4KhmHZlCvIsZ+YOvucivWxdeSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NImQ/2GPwAcFITvojAwvzB7s/BFMWDNNgB53vrAxuW0CHe7lStKrFqvr4a+caShwt
	 H2/G0JES92zwh/qbRG/hZw4Wf4uQsjmQHcYDCKcfmGY9zFYuNjmb5JpUN4DDWKWp0t
	 Pz5fAyny+HAsPsbAMBeOuxP42VWWG1deJXop1MHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 519/770] NFSD: Refactor nfsd_create_setattr()
Date: Tue, 18 Jun 2024 14:36:12 +0200
Message-ID: <20240618123427.347230981@linuxfoundation.org>
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

[ Upstream commit 5f46e950c395b9c14c282b53ba78c5fd46d6c256 ]

I'd like to move do_nfsd_create() out of vfs.c. Therefore
nfsd_create_setattr() needs to be made publicly visible.

Note that both call sites in vfs.c commit both the new object and
its parent directory, so just combine those common metadata commits
into nfsd_create_setattr().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 79 +++++++++++++++++++++++++++------------------------
 fs/nfsd/vfs.h |  2 ++
 2 files changed, 44 insertions(+), 37 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index cdeba19db16df..50451789a9444 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1207,14 +1207,26 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp, u64 offset,
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
@@ -1222,10 +1234,31 @@ nfsd_create_setattr(struct svc_rqst *rqstp, struct svc_fh *resfhp,
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
@@ -1252,7 +1285,6 @@ nfsd_create_locked(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	struct dentry	*dentry, *dchild;
 	struct inode	*dirp;
 	__be32		err;
-	__be32		err2;
 	int		host_err;
 
 	dentry = fhp->fh_dentry;
@@ -1324,22 +1356,8 @@ nfsd_create_locked(struct svc_rqst *rqstp, struct svc_fh *fhp,
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
@@ -1530,20 +1548,7 @@ do_nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
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



