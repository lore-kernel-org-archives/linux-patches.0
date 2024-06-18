Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC241514F4;
	Tue, 18 Jun 2024 12:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715117; cv=none; b=IKTkE7SxhVAhf6N0+NV34Ih95lY+zsw5dQ8WsLDmnrYgzaUq5Q6DcX2fYHjOc8ct+JryWuAC2RcFtetzz2uJ8OLGJivipyTSUjIMqXYWd0Y/Zw11WWIgx0xWMvXK0DYwKkaIfL81M3bGrXz9HIPVpdfnrb4/HT0THO9JA61ABAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715117; c=relaxed/simple;
	bh=zRlejpJkU7qKNboNIMvvGPqqEGBPpUuFK7UzQEncwog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bv5ND3A1IA/UYJzNgYLUPQ2emktrL+OaqtjUWkj6mxyRy1RowoB16ZFaPJADyAEtLTvzUw8+iU+xmZL4qDb7aSuKypcLKrL2V8NzTjwsvXApc4iB1CW7Vo2WVmzieyEOFtIFjEpgyYD9v+1ec8RJPz2uoKvOynLLjO9wCzoROjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7xl7Xj+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7xl7Xj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2279DC3277B;
	Tue, 18 Jun 2024 12:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715117;
	bh=zRlejpJkU7qKNboNIMvvGPqqEGBPpUuFK7UzQEncwog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7xl7Xj+mrchx1mlOXfKxap/QTonimucUEOl8xzLxejZUIjPtqHKh4NrRgRkHufYC
	 2FpfIrbMDF9i3eHbBXwy93lZRo2b3B9NfR/EtOOkgP4yreVEFhEcGOnq64do6TdVf4
	 iOYV1ifgWQo4Q9s+eO8mhyPe1zoEUD6o0nbDwPA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 200/770] NFSD: Update the NFSv3 LOOKUP3res encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:53 +0200
Message-ID: <20240618123414.997314568@linuxfoundation.org>
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

[ Upstream commit 5cf353354af1a385f29dec4609a1532d32c83a25 ]

Also, clean up: Rename the encoder function to match the name of
the result structure in RFC 1813, consistent with other encoder
function names in nfs3xdr.c. "diropres" is an NFSv2 thingie.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c |  2 +-
 fs/nfsd/nfs3xdr.c  | 43 +++++++++++++++++++++++++++++++++++--------
 fs/nfsd/xdr3.h     |  2 +-
 3 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 1c3cf97ed95d2..60e8c25be7571 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -763,7 +763,7 @@ static const struct svc_procedure nfsd_procedures3[22] = {
 	[NFS3PROC_LOOKUP] = {
 		.pc_func = nfsd3_proc_lookup,
 		.pc_decode = nfs3svc_decode_diropargs,
-		.pc_encode = nfs3svc_encode_diropres,
+		.pc_encode = nfs3svc_encode_lookupres,
 		.pc_release = nfs3svc_release_fhandle2,
 		.pc_argsize = sizeof(struct nfsd3_diropargs),
 		.pc_ressize = sizeof(struct nfsd3_diropres),
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 9d6c989df6d8d..2bb998b3834bf 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -104,6 +104,23 @@ svcxdr_encode_nfsstat3(struct xdr_stream *xdr, __be32 status)
 	return true;
 }
 
+static bool
+svcxdr_encode_nfs_fh3(struct xdr_stream *xdr, const struct svc_fh *fhp)
+{
+	u32 size = fhp->fh_handle.fh_size;
+	__be32 *p;
+
+	p = xdr_reserve_space(xdr, XDR_UNIT + size);
+	if (!p)
+		return false;
+	*p++ = cpu_to_be32(size);
+	if (size)
+		p[XDR_QUADLEN(size) - 1] = 0;
+	memcpy(p, &fhp->fh_handle.fh_base, size);
+
+	return true;
+}
+
 static __be32 *
 encode_fh(__be32 *p, struct svc_fh *fhp)
 {
@@ -846,18 +863,28 @@ nfs3svc_encode_wccstat(struct svc_rqst *rqstp, __be32 *p)
 }
 
 /* LOOKUP */
-int
-nfs3svc_encode_diropres(struct svc_rqst *rqstp, __be32 *p)
+int nfs3svc_encode_lookupres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd3_diropres *resp = rqstp->rq_resp;
 
-	*p++ = resp->status;
-	if (resp->status == 0) {
-		p = encode_fh(p, &resp->fh);
-		p = encode_post_op_attr(rqstp, p, &resp->fh);
+	if (!svcxdr_encode_nfsstat3(xdr, resp->status))
+		return 0;
+	switch (resp->status) {
+	case nfs_ok:
+		if (!svcxdr_encode_nfs_fh3(xdr, &resp->fh))
+			return 0;
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &resp->fh))
+			return 0;
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &resp->dirfh))
+			return 0;
+		break;
+	default:
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &resp->dirfh))
+			return 0;
 	}
-	p = encode_post_op_attr(rqstp, p, &resp->dirfh);
-	return xdr_ressize_check(rqstp, p);
+
+	return 1;
 }
 
 /* ACCESS */
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index 0822981c61b93..7db4ee17aa209 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -282,7 +282,7 @@ int nfs3svc_decode_readdirplusargs(struct svc_rqst *, __be32 *);
 int nfs3svc_decode_commitargs(struct svc_rqst *, __be32 *);
 int nfs3svc_encode_getattrres(struct svc_rqst *, __be32 *);
 int nfs3svc_encode_wccstat(struct svc_rqst *, __be32 *);
-int nfs3svc_encode_diropres(struct svc_rqst *, __be32 *);
+int nfs3svc_encode_lookupres(struct svc_rqst *, __be32 *);
 int nfs3svc_encode_accessres(struct svc_rqst *, __be32 *);
 int nfs3svc_encode_readlinkres(struct svc_rqst *, __be32 *);
 int nfs3svc_encode_readres(struct svc_rqst *, __be32 *);
-- 
2.43.0



