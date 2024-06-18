Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9A973461;
	Tue, 18 Jun 2024 12:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715206; cv=none; b=e/IHmS6O10iS6JsJDsdd5XgJPDIE2zmVoPKM27aBUsArcFxxQIbOshcNS9mzjCsMOmYLS72YsrCmJ4n4YCt8M94shVJfutavSl4HImZVrXGfM6wZd/9Uf81C10jvT4kVgaZlinGzqWP/rPGvYmionAGh5hoN/pprjYay566W670=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715206; c=relaxed/simple;
	bh=Wts7Lwf2ZAd5KMAjBSwh4Ny5FDcnEItyusKKv1l97T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRceP5Mrz4ZCX6xiV6zwuzcO58CBQAY7eHVGzP8A1KGjowBFJh4GbANbgNHekRXIUYluQotiIwn3UF2Qk78rTtawNs+8O0fLd32Lyp32fNGBQurGJtJ9DSNjKe6vfE1tTnR/C+ybWjrvRqIpVc/voQsvxOnmT0ik2wUXogztqdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xu22Jy0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xu22Jy0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB52C4AF49;
	Tue, 18 Jun 2024 12:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715206;
	bh=Wts7Lwf2ZAd5KMAjBSwh4Ny5FDcnEItyusKKv1l97T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xu22Jy0iv+sqjjzthGig8Cvzo63u2nsoNFf0Zno+e9l1PqnsbQbG1ZOzI/0XYQfOD
	 cpYWV+TQ23+sNPFkQgvjOZQiv8TRMPnr4mFwHo0mpQVmNOAGlVPXXQ66/hpclAt3Lu
	 +oJt3TIJxF6Mf1WDcjGFMyYdRgGaDl0BV30nM1EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 230/770] NFSD: Update the NFSv2 GETACL result encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:31:23 +0200
Message-ID: <20240618123416.161014063@linuxfoundation.org>
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

[ Upstream commit f8cba47344f794b54373189bec23195b51020faf ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c | 42 ++++++++++++++++--------------------------
 fs/nfsd/nfsxdr.c  | 24 ++++++++++++++++++++++--
 fs/nfsd/xdr.h     |  3 +++
 3 files changed, 41 insertions(+), 28 deletions(-)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index 7eeac5b81c200..102f8a9a235cb 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -240,51 +240,41 @@ static int nfsaclsvc_decode_accessargs(struct svc_rqst *rqstp, __be32 *p)
 /* GETACL */
 static int nfsaclsvc_encode_getaclres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd3_getaclres *resp = rqstp->rq_resp;
 	struct dentry *dentry = resp->fh.fh_dentry;
 	struct inode *inode;
-	struct kvec *head = rqstp->rq_res.head;
-	unsigned int base;
-	int n;
 	int w;
 
-	*p++ = resp->status;
-	if (resp->status != nfs_ok)
-		return xdr_ressize_check(rqstp, p);
+	if (!svcxdr_encode_stat(xdr, resp->status))
+		return 0;
 
-	/*
-	 * Since this is version 2, the check for nfserr in
-	 * nfsd_dispatch actually ensures the following cannot happen.
-	 * However, it seems fragile to depend on that.
-	 */
 	if (dentry == NULL || d_really_is_negative(dentry))
-		return 0;
+		return 1;
 	inode = d_inode(dentry);
 
-	p = nfs2svc_encode_fattr(rqstp, p, &resp->fh, &resp->stat);
-	*p++ = htonl(resp->mask);
-	if (!xdr_ressize_check(rqstp, p))
+	if (!svcxdr_encode_fattr(rqstp, xdr, &resp->fh, &resp->stat))
+		return 0;
+	if (xdr_stream_encode_u32(xdr, resp->mask) < 0)
 		return 0;
-	base = (char *)p - (char *)head->iov_base;
 
 	rqstp->rq_res.page_len = w = nfsacl_size(
 		(resp->mask & NFS_ACL)   ? resp->acl_access  : NULL,
 		(resp->mask & NFS_DFACL) ? resp->acl_default : NULL);
 	while (w > 0) {
 		if (!*(rqstp->rq_next_page++))
-			return 0;
+			return 1;
 		w -= PAGE_SIZE;
 	}
 
-	n = nfsacl_encode(&rqstp->rq_res, base, inode,
-			  resp->acl_access,
-			  resp->mask & NFS_ACL, 0);
-	if (n > 0)
-		n = nfsacl_encode(&rqstp->rq_res, base + n, inode,
-				  resp->acl_default,
-				  resp->mask & NFS_DFACL,
-				  NFS_ACL_DEFAULT);
-	return (n > 0);
+	if (!nfs_stream_encode_acl(xdr, inode, resp->acl_access,
+				   resp->mask & NFS_ACL, 0))
+		return 0;
+	if (!nfs_stream_encode_acl(xdr, inode, resp->acl_default,
+				   resp->mask & NFS_DFACL, NFS_ACL_DEFAULT))
+		return 0;
+
+	return 1;
 }
 
 static int nfsaclsvc_encode_attrstatres(struct svc_rqst *rqstp, __be32 *p)
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 5df6f00d76fd5..1fed3a8deb183 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -26,7 +26,16 @@ static const u32 nfs_ftypes[] = {
  * Basic NFSv2 data types (RFC 1094 Section 2.3)
  */
 
-static bool
+/**
+ * svcxdr_encode_stat - Encode an NFSv2 status code
+ * @xdr: XDR stream
+ * @status: status value to encode
+ *
+ * Return values:
+ *   %false: Send buffer space was exhausted
+ *   %true: Success
+ */
+bool
 svcxdr_encode_stat(struct xdr_stream *xdr, __be32 status)
 {
 	__be32 *p;
@@ -250,7 +259,18 @@ encode_fattr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp,
 	return p;
 }
 
-static bool
+/**
+ * svcxdr_encode_fattr - Encode NFSv2 file attributes
+ * @rqstp: Context of a completed RPC transaction
+ * @xdr: XDR stream
+ * @fhp: File handle to encode
+ * @stat: Attributes to encode
+ *
+ * Return values:
+ *   %false: Send buffer space was exhausted
+ *   %true: Success
+ */
+bool
 svcxdr_encode_fattr(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 		    const struct svc_fh *fhp, const struct kstat *stat)
 {
diff --git a/fs/nfsd/xdr.h b/fs/nfsd/xdr.h
index 10f3bd25e8ccc..8bcdc37398ab5 100644
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -170,5 +170,8 @@ void nfssvc_release_readres(struct svc_rqst *rqstp);
 /* Helper functions for NFSv2 ACL code */
 __be32 *nfs2svc_encode_fattr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp, struct kstat *stat);
 bool svcxdr_decode_fhandle(struct xdr_stream *xdr, struct svc_fh *fhp);
+bool svcxdr_encode_stat(struct xdr_stream *xdr, __be32 status);
+bool svcxdr_encode_fattr(struct svc_rqst *rqstp, struct xdr_stream *xdr,
+			 const struct svc_fh *fhp, const struct kstat *stat);
 
 #endif /* LINUX_NFSD_H */
-- 
2.43.0



