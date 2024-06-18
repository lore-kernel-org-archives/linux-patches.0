Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09757158DC1;
	Tue, 18 Jun 2024 13:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716429; cv=none; b=nTrOhsbbwWZdRRlfWSB7n/jm4bjTyBJIrm1pzLO+HyDbH3BLF06rB5RFMY3Ze+axxizGQeiAomM7Cm882lyPQmv0Fmf5ucV2rYpN98MT29VM7tsc+sMzGxNY/VS8FiZ+TT4EekZayVZM3l8cTjiP7zwZSehna32kgnimPZuyUJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716429; c=relaxed/simple;
	bh=Eh4WgEuneopKYm79FeY3nP5x2oKSw/EVEmzIkZ1xwu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSq7M5qbArNxs74zjK86U0cmLUiD5hRdtQazBzA0tLQllwg8+94pqNnzHng5A0aKi99vzNmuFKp7vmQmmc4H9/WxQR8EAe0lh9mKpvbOqI8rM0SxxRZe3l4YQfoOpBjguIYtRqgyBSKUKfRFAb6XRJrNWmRq1SgC6R1N7Y2ZWLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ap8qR0UR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ap8qR0UR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E7DC3277B;
	Tue, 18 Jun 2024 13:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716428;
	bh=Eh4WgEuneopKYm79FeY3nP5x2oKSw/EVEmzIkZ1xwu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ap8qR0UR95BVEhChXnL52AK7M2VQpgYAjSpShwQi2/5ENtllDARe1f7fQlOGw6G8t
	 ZccJ9ubZsMFlthxFBRYot4OXfQL65egz5sGG4dMeEufcozQIuUGA5WTRlLauNgr5l5
	 zlCs1whltXCcB6/FBTi6H0hdmbk+zHmk9Ds5li1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 643/770] NFSD: Refactor nfsd_setattr()
Date: Tue, 18 Jun 2024 14:38:16 +0200
Message-ID: <20240618123432.108638492@linuxfoundation.org>
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

[ Upstream commit c0aa1913db57219e91a0a8832363cbafb3a9cf8f ]

Move code that will be retried (in a subsequent patch) into a helper
function.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
[ cel: backported to 5.10.y, prior to idmapped mounts ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 97 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 57 insertions(+), 40 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 5ec1119a87859..e32b0c807ea9d 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -356,8 +356,61 @@ nfsd_get_write_access(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	return nfserrno(host_err);
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
+		host_err = notify_change(dentry, &size_attr, NULL);
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
+	return notify_change(dentry, iap, NULL);
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
@@ -370,7 +423,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	int		accmode = NFSD_MAY_SATTR;
 	umode_t		ftype = 0;
 	__be32		err;
-	int		host_err = 0;
+	int		host_err;
 	bool		get_write_count;
 	bool		size_change = (iap->ia_valid & ATTR_SIZE);
 
@@ -427,43 +480,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
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
-		host_err = notify_change(dentry, &size_attr, NULL);
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
-		host_err = notify_change(dentry, iap, NULL);
-	}
-
-out_unlock:
+	host_err = __nfsd_setattr(dentry, iap);
 	if (attr->na_seclabel && attr->na_seclabel->len)
 		attr->na_labelerr = security_inode_setsecctx(dentry,
 			attr->na_seclabel->data, attr->na_seclabel->len);
-- 
2.43.0



