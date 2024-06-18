Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1996C13DB8D;
	Tue, 18 Jun 2024 12:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714932; cv=none; b=UwYSSI7gyZMhBILHvgJq131PcmnFkZp45RZpoMecvT2DLbDPI0laYrWv8/JUM37VU0qUCQIJ/jYhPqEoEPrlUZba1p91H92uMpTkCMiHKjHq1M9ORKmygjE+3vfKtaznngjeWIb27/mfow7J28jwqmy4USvAlmtP6eImMVqcl9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714932; c=relaxed/simple;
	bh=yJ4cK5F5rnV7zZ88Oeif9qrGA7Y2WF+cWethbj/85jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tH6cNP7++4r5PeRClM7jtBpzkmwZxdiNROZDkg5SVntYfJRNIoJ0Ad9htxLCpPCKSqVFxTShGXV+x2FKibnglBjDmU3DaBdSWL7SZZc4VwzE4dgKWS6XtewieZNGwie/8o3+eSzQaJO9ImMkdifVEROckzC69ebE1MKNL9vGylg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5dYXU9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5dYXU9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DFBC3277B;
	Tue, 18 Jun 2024 12:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714932;
	bh=yJ4cK5F5rnV7zZ88Oeif9qrGA7Y2WF+cWethbj/85jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5dYXU9yze3jH02vgu29myHCaQW3JcaQ9UfjazmN1tRh12vw2fumVY/lloc+Bg+OI
	 vAK2zZMFj4iH+mTa+w5wzFxbA9UsFnQNB5md+wHXUIIKHFFmkJxCJNGPqon4oiveY6
	 AhS965aeSbSDlvvhZp1fnstAUoV6asCOMf48Ewdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/770] NFSD: Update GETATTR3args decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:29:49 +0200
Message-ID: <20240618123412.526946167@linuxfoundation.org>
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

[ Upstream commit 9575363a9e4c8d7e2f9ba5e79884d623fff0be6f ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c |  3 +--
 fs/nfsd/nfs3xdr.c  | 31 +++++++++++++++++++++++++------
 fs/nfsd/xdr3.h     |  2 +-
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 0f79e007c620f..a1d743bbb837d 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -688,7 +688,6 @@ nfsd3_proc_commit(struct svc_rqst *rqstp)
  * NFSv3 Server procedures.
  * Only the results of non-idempotent operations are cached.
  */
-#define nfs3svc_decode_fhandleargs	nfs3svc_decode_fhandle
 #define nfs3svc_encode_attrstatres	nfs3svc_encode_attrstat
 #define nfs3svc_encode_wccstatres	nfs3svc_encode_wccstat
 #define nfsd3_mkdirargs			nfsd3_createargs
@@ -720,7 +719,7 @@ static const struct svc_procedure nfsd_procedures3[22] = {
 		.pc_decode = nfs3svc_decode_fhandleargs,
 		.pc_encode = nfs3svc_encode_attrstatres,
 		.pc_release = nfs3svc_release_fhandle,
-		.pc_argsize = sizeof(struct nfsd3_fhandleargs),
+		.pc_argsize = sizeof(struct nfsd_fhandle),
 		.pc_ressize = sizeof(struct nfsd3_attrstatres),
 		.pc_cachetype = RC_NOCACHE,
 		.pc_xdrressize = ST+AT,
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 34b880211e5ea..3a2b4abea1a42 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -29,8 +29,9 @@ static u32	nfs3_ftypes[] = {
 
 
 /*
- * XDR functions for basic NFS types
+ * Basic NFSv3 data types (RFC 1813 Sections 2.5 and 2.6)
  */
+
 static __be32 *
 encode_time3(__be32 *p, struct timespec64 *time)
 {
@@ -46,6 +47,26 @@ decode_time3(__be32 *p, struct timespec64 *time)
 	return p;
 }
 
+static bool
+svcxdr_decode_nfs_fh3(struct xdr_stream *xdr, struct svc_fh *fhp)
+{
+	__be32 *p;
+	u32 size;
+
+	if (xdr_stream_decode_u32(xdr, &size) < 0)
+		return false;
+	if (size == 0 || size > NFS3_FHSIZE)
+		return false;
+	p = xdr_inline_decode(xdr, size);
+	if (!p)
+		return false;
+	fh_init(fhp, NFS3_FHSIZE);
+	fhp->fh_handle.fh_size = size;
+	memcpy(&fhp->fh_handle.fh_base, p, size);
+
+	return true;
+}
+
 static __be32 *
 decode_fh(__be32 *p, struct svc_fh *fhp)
 {
@@ -312,14 +333,12 @@ void fill_post_wcc(struct svc_fh *fhp)
  */
 
 int
-nfs3svc_decode_fhandle(struct svc_rqst *rqstp, __be32 *p)
+nfs3svc_decode_fhandleargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd_fhandle *args = rqstp->rq_argp;
 
-	p = decode_fh(p, &args->fh);
-	if (!p)
-		return 0;
-	return xdr_argsize_check(rqstp, p);
+	return svcxdr_decode_nfs_fh3(xdr, &args->fh);
 }
 
 int
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index 456fcd7a10383..62ea669768cf3 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -273,7 +273,7 @@ union nfsd3_xdrstore {
 
 #define NFS3_SVC_XDRSIZE		sizeof(union nfsd3_xdrstore)
 
-int nfs3svc_decode_fhandle(struct svc_rqst *, __be32 *);
+int nfs3svc_decode_fhandleargs(struct svc_rqst *, __be32 *);
 int nfs3svc_decode_sattrargs(struct svc_rqst *, __be32 *);
 int nfs3svc_decode_diropargs(struct svc_rqst *, __be32 *);
 int nfs3svc_decode_accessargs(struct svc_rqst *, __be32 *);
-- 
2.43.0



