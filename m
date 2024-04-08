Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401926EB72;
	Mon,  8 Apr 2024 13:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584413; cv=none; b=J7NWAXOb5YOIC/u6syzpvT4/fNOKwH4t4N0tMied0FFkJgJk/ftWxuUO89FbAXSk+yP1vFEyhyaxbb7Qod5I03hH7dR70cNXQHNooNE077m/zALEEpjp9QPP2OdCeoS8MsmWVYnUijwgZrcuHhVl3A/3uBIXi8MG2bYVnMg28Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584413; c=relaxed/simple;
	bh=tbTu+AseHWIEIAdHCJ13iLvbZAfqn3hmL8mG1QVVKEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etFT+8h7pttjOqsTezDSxlrIC3AmMKClh4bMQF4xAiBXPZamF52OFSqeFJENbuWIHnjj0EGuP4PELnIe4m6gYsRCQ26WgQEcDoiOPWWbBXM1hKxDqMmdEm2VEIhjnrN8Z+mgeQVlw1Pe85/djg8etq9/xEk4t5RxKe9jPpypJuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwUGWYSe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwUGWYSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA80C433F1;
	Mon,  8 Apr 2024 13:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584413;
	bh=tbTu+AseHWIEIAdHCJ13iLvbZAfqn3hmL8mG1QVVKEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MwUGWYSeTawDux/dA5C4AvZ16TTzxd1sfjD0BgcDt7SHdeKzZVUkgkM1k0T1qrYcz
	 0Q2YwlkrMStZcxkB2GmM1TQvweHBvHZY0i3WmEYzJS64E8iwHzzPw6YULYyK0pQP2U
	 V4UslEsV0ck1eZu9sQUvVdO9an9cfdIAsN37zv10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 430/690] NFSD: Refactor nfsd_setattr()
Date: Mon,  8 Apr 2024 14:54:56 +0200
Message-ID: <20240408125415.185557432@linuxfoundation.org>
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

[ Upstream commit c0aa1913db57219e91a0a8832363cbafb3a9cf8f ]

Move code that will be retried (in a subsequent patch) into a helper
function.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/vfs.c | 97 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 57 insertions(+), 40 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 77f8ab3826d75..392df2353556e 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -344,8 +344,61 @@ nfsd_get_write_access(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	return nfserrno(get_write_access(inode));
 }
 
-/*
- * Set various file attributes.  After this call fhp needs an fh_put.
+static int __nfsd_setattr(struct dentry *dentry, struct iattr *iap)
+{
+	int host_err;
+
+	if (iap->ia_valid & ATTR_SIZE) {
+		/*
+		 * RFC5661, Section 18.30.4:
+		 *   Changing the size of a file with SETATTR indirectly
+		 *   changes the time_modify and change attributes.
+		 *
+		 * (and similar for the older RFCs)
+		 */
+		struct iattr size_attr = {
+			.ia_valid	= ATTR_SIZE | ATTR_CTIME | ATTR_MTIME,
+			.ia_size	= iap->ia_size,
+		};
+
+		if (iap->ia_size < 0)
+			return -EFBIG;
+
+		host_err = notify_change(&init_user_ns, dentry, &size_attr, NULL);
+		if (host_err)
+			return host_err;
+		iap->ia_valid &= ~ATTR_SIZE;
+
+		/*
+		 * Avoid the additional setattr call below if the only other
+		 * attribute that the client sends is the mtime, as we update
+		 * it as part of the size change above.
+		 */
+		if ((iap->ia_valid & ~ATTR_MTIME) == 0)
+			return 0;
+	}
+
+	if (!iap->ia_valid)
+		return 0;
+
+	iap->ia_valid |= ATTR_CTIME;
+	return notify_change(&init_user_ns, dentry, iap, NULL);
+}
+
+/**
+ * nfsd_setattr - Set various file attributes.
+ * @rqstp: controlling RPC transaction
+ * @fhp: filehandle of target
+ * @attr: attributes to set
+ * @check_guard: set to 1 if guardtime is a valid timestamp
+ * @guardtime: do not act if ctime.tv_sec does not match this timestamp
+ *
+ * This call may adjust the contents of @attr (in particular, this
+ * call may change the bits in the na_iattr.ia_valid field).
+ *
+ * Returns nfs_ok on success, otherwise an NFS status code is
+ * returned. Caller must release @fhp by calling fh_put in either
+ * case.
  */
 __be32
 nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
@@ -358,7 +411,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	int		accmode = NFSD_MAY_SATTR;
 	umode_t		ftype = 0;
 	__be32		err;
-	int		host_err = 0;
+	int		host_err;
 	bool		get_write_count;
 	bool		size_change = (iap->ia_valid & ATTR_SIZE);
 
@@ -415,43 +468,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	}
 
 	inode_lock(inode);
-	if (size_change) {
-		/*
-		 * RFC5661, Section 18.30.4:
-		 *   Changing the size of a file with SETATTR indirectly
-		 *   changes the time_modify and change attributes.
-		 *
-		 * (and similar for the older RFCs)
-		 */
-		struct iattr size_attr = {
-			.ia_valid	= ATTR_SIZE | ATTR_CTIME | ATTR_MTIME,
-			.ia_size	= iap->ia_size,
-		};
-
-		host_err = -EFBIG;
-		if (iap->ia_size < 0)
-			goto out_unlock;
-
-		host_err = notify_change(&init_user_ns, dentry, &size_attr, NULL);
-		if (host_err)
-			goto out_unlock;
-		iap->ia_valid &= ~ATTR_SIZE;
-
-		/*
-		 * Avoid the additional setattr call below if the only other
-		 * attribute that the client sends is the mtime, as we update
-		 * it as part of the size change above.
-		 */
-		if ((iap->ia_valid & ~ATTR_MTIME) == 0)
-			goto out_unlock;
-	}
-
-	if (iap->ia_valid) {
-		iap->ia_valid |= ATTR_CTIME;
-		host_err = notify_change(&init_user_ns, dentry, iap, NULL);
-	}
-
-out_unlock:
+	host_err = __nfsd_setattr(dentry, iap);
 	if (attr->na_seclabel && attr->na_seclabel->len)
 		attr->na_labelerr = security_inode_setsecctx(dentry,
 			attr->na_seclabel->data, attr->na_seclabel->len);
-- 
2.43.0



