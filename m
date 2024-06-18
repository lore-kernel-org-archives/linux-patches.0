Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CD914F130;
	Tue, 18 Jun 2024 12:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715221; cv=none; b=kDH8dYfFwhIhpCP4pTAR3c6rK2OKejUYTtiHmarafOE1Fj4npir4csdyjPMgaoeRQu3CAh/hQYVNT3wy+g80a58us8+bKHMobcQHO93FODSTXrzXmz2XMx2fs3j6R2Mydu4Dn2If7dWB9p3L9+FHSvTa2GSr2yeC/kvAGhaxLXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715221; c=relaxed/simple;
	bh=E+s+yugD9udSteH6Wef+BQuyRy9dJsGh7dTzo4v9nZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnSyttWxMjP0i450RaU8YfpZm6OzpGLVlPGkAFehUplpXj6/E8zxpYJZfacwf+w2sOUnO8ZPhF7uptUrQZ+Jh5RqVKSeY3zSm8u6j1jSnX/5AcAj4sKcFmYV0gp7HrAwnScwdCrvqs0ZJpULllZXoB6/gG+D2KpMpcNOtC/mrs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XiR11ZrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XiR11ZrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D534FC3277B;
	Tue, 18 Jun 2024 12:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715221;
	bh=E+s+yugD9udSteH6Wef+BQuyRy9dJsGh7dTzo4v9nZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XiR11ZrW3TIj1d+CtNFblULKyBHiZyTt67gwoVcmwG7AbIRDZJAaqqPXqEbiAiAB5
	 Bz47H+uhO2S1slZLN4bi5UzLYV/BpKR9PhI+jHokbArU/sELZn74Yo3oqJdVXLUSlJ
	 1tzLLra1KBpx9v4xoIuCzfJp5zDOXmWzqbZ+vQ1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 235/770] NFSD: Update the NFSv3 GETACL result encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:31:28 +0200
Message-ID: <20240618123416.350993531@linuxfoundation.org>
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

[ Upstream commit 20798dfe249a01ad1b12eec7dbc572db5003244a ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3acl.c | 33 +++++++++++++++++++--------------
 fs/nfsd/nfs3xdr.c | 23 +++++++++++++++++++++--
 fs/nfsd/xdr3.h    |  3 +++
 3 files changed, 43 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/nfs3acl.c b/fs/nfsd/nfs3acl.c
index a568b842e9ebe..04e157b0b201a 100644
--- a/fs/nfsd/nfs3acl.c
+++ b/fs/nfsd/nfs3acl.c
@@ -166,22 +166,25 @@ static int nfs3svc_decode_setaclargs(struct svc_rqst *rqstp, __be32 *p)
 /* GETACL */
 static int nfs3svc_encode_getaclres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd3_getaclres *resp = rqstp->rq_resp;
 	struct dentry *dentry = resp->fh.fh_dentry;
+	struct kvec *head = rqstp->rq_res.head;
+	struct inode *inode = d_inode(dentry);
+	unsigned int base;
+	int n;
+	int w;
 
-	*p++ = resp->status;
-	p = nfs3svc_encode_post_op_attr(rqstp, p, &resp->fh);
-	if (resp->status == 0 && dentry && d_really_is_positive(dentry)) {
-		struct inode *inode = d_inode(dentry);
-		struct kvec *head = rqstp->rq_res.head;
-		unsigned int base;
-		int n;
-		int w;
-
-		*p++ = htonl(resp->mask);
-		if (!xdr_ressize_check(rqstp, p))
+	if (!svcxdr_encode_nfsstat3(xdr, resp->status))
+		return 0;
+	switch (resp->status) {
+	case nfs_ok:
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &resp->fh))
 			return 0;
-		base = (char *)p - (char *)head->iov_base;
+		if (xdr_stream_encode_u32(xdr, resp->mask) < 0)
+			return 0;
+
+		base = (char *)xdr->p - (char *)head->iov_base;
 
 		rqstp->rq_res.page_len = w = nfsacl_size(
 			(resp->mask & NFS_ACL)   ? resp->acl_access  : NULL,
@@ -202,9 +205,11 @@ static int nfs3svc_encode_getaclres(struct svc_rqst *rqstp, __be32 *p)
 					  NFS_ACL_DEFAULT);
 		if (n <= 0)
 			return 0;
-	} else
-		if (!xdr_ressize_check(rqstp, p))
+		break;
+	default:
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &resp->fh))
 			return 0;
+	}
 
 	return 1;
 }
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 646bbfc5b7794..941740a97f8f5 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -107,7 +107,16 @@ svcxdr_decode_nfs_fh3(struct xdr_stream *xdr, struct svc_fh *fhp)
 	return true;
 }
 
-static bool
+/**
+ * svcxdr_encode_nfsstat3 - Encode an NFSv3 status code
+ * @xdr: XDR stream
+ * @status: status value to encode
+ *
+ * Return values:
+ *   %false: Send buffer space was exhausted
+ *   %true: Success
+ */
+bool
 svcxdr_encode_nfsstat3(struct xdr_stream *xdr, __be32 status)
 {
 	__be32 *p;
@@ -464,7 +473,17 @@ svcxdr_encode_pre_op_attr(struct xdr_stream *xdr, const struct svc_fh *fhp)
 	return svcxdr_encode_wcc_attr(xdr, fhp);
 }
 
-static bool
+/**
+ * svcxdr_encode_post_op_attr - Encode NFSv3 post-op attributes
+ * @rqstp: Context of a completed RPC transaction
+ * @xdr: XDR stream
+ * @fhp: File handle to encode
+ *
+ * Return values:
+ *   %false: Send buffer space was exhausted
+ *   %true: Success
+ */
+bool
 svcxdr_encode_post_op_attr(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 			   const struct svc_fh *fhp)
 {
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index b851458373db6..746c5f79964f1 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -308,5 +308,8 @@ int nfs3svc_encode_entryplus3(void *data, const char *name, int namlen,
 __be32 *nfs3svc_encode_post_op_attr(struct svc_rqst *rqstp, __be32 *p,
 				struct svc_fh *fhp);
 bool svcxdr_decode_nfs_fh3(struct xdr_stream *xdr, struct svc_fh *fhp);
+bool svcxdr_encode_nfsstat3(struct xdr_stream *xdr, __be32 status);
+bool svcxdr_encode_post_op_attr(struct svc_rqst *rqstp, struct xdr_stream *xdr,
+				const struct svc_fh *fhp);
 
 #endif /* _LINUX_NFSD_XDR3_H */
-- 
2.43.0



