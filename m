Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F6714F108;
	Tue, 18 Jun 2024 12:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715191; cv=none; b=YrVw3kOrZ5Zg9gKLtTSXuBNVODF2jVfHwZmzH0XcKp/b8CwgHBFVMcx1aFZ5W6p1Z+O8Qd+o3jH3xIzJ6HONj2Yn6had08/4QLSpICOVmBMrFvdtr0ueTSLqqlv4Y23fDQ5BqW7sKbQ8MOu2nmrUgi3NXa9UF2sCrfYq9pJceTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715191; c=relaxed/simple;
	bh=+rbcOuhNv6LwI5+u9JZmh6al2gEJN58NChxNRs6rh+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXX3M8nI8E/08ahpPijZ0v8HTvQ1htFfFlzmd+PPluro2/R0Rce2/aiQvEudu3O5jUQEfMZiDx3KYrP86y54QVJT6KkGFyVBclA9xJ1OIe8y5FTItQSGZKtRD9YhjPU5LtXkYV+ma8GY8vHqEuFWoQCF6oMT2FWUiW/vpn8jBB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dcIGo0cB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dcIGo0cB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49728C3277B;
	Tue, 18 Jun 2024 12:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715191;
	bh=+rbcOuhNv6LwI5+u9JZmh6al2gEJN58NChxNRs6rh+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcIGo0cBC5hE56aY/++PYpYZmYZzvWbD7YNAZGIn7mIvHJG6adXmrzOXUK+cU/+Kl
	 FetQDmE59EipbuU8j0b+IT/xzSVa2QVVkZf+x3XCvfT98pu14+Gt7e7oq/cZCrXuQX
	 CzNmKomQ3LeJJuZKGBwk961dXFVS3B+rE67Lo+MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 208/770] NFSD: Update the NFSv3 FSSTAT3res encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:31:01 +0200
Message-ID: <20240618123415.304859740@linuxfoundation.org>
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

[ Upstream commit 8b7044984fd6eeadf72285e3617116bd15e9e676 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 58 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index e159e45574288..e4a569e7216d5 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -17,6 +17,13 @@
 #define NFSDDBG_FACILITY		NFSDDBG_XDR
 
 
+/*
+ * Force construction of an empty post-op attr
+ */
+static const struct svc_fh nfs3svc_null_fh = {
+	.fh_no_wcc	= true,
+};
+
 /*
  * Mapping of S_IF* types to NFS file types
  */
@@ -1392,27 +1399,50 @@ nfs3svc_encode_entry_plus(void *cd, const char *name,
 	return encode_entry(cd, name, namlen, offset, ino, d_type, 1);
 }
 
+static bool
+svcxdr_encode_fsstat3resok(struct xdr_stream *xdr,
+			   const struct nfsd3_fsstatres *resp)
+{
+	const struct kstatfs *s = &resp->stats;
+	u64 bs = s->f_bsize;
+	__be32 *p;
+
+	p = xdr_reserve_space(xdr, XDR_UNIT * 13);
+	if (!p)
+		return false;
+	p = xdr_encode_hyper(p, bs * s->f_blocks);	/* total bytes */
+	p = xdr_encode_hyper(p, bs * s->f_bfree);	/* free bytes */
+	p = xdr_encode_hyper(p, bs * s->f_bavail);	/* user available bytes */
+	p = xdr_encode_hyper(p, s->f_files);		/* total inodes */
+	p = xdr_encode_hyper(p, s->f_ffree);		/* free inodes */
+	p = xdr_encode_hyper(p, s->f_ffree);		/* user available inodes */
+	*p = cpu_to_be32(resp->invarsec);		/* mean unchanged time */
+
+	return true;
+}
+
 /* FSSTAT */
 int
 nfs3svc_encode_fsstatres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd3_fsstatres *resp = rqstp->rq_resp;
-	struct kstatfs	*s = &resp->stats;
-	u64		bs = s->f_bsize;
 
-	*p++ = resp->status;
-	*p++ = xdr_zero;	/* no post_op_attr */
-
-	if (resp->status == 0) {
-		p = xdr_encode_hyper(p, bs * s->f_blocks);	/* total bytes */
-		p = xdr_encode_hyper(p, bs * s->f_bfree);	/* free bytes */
-		p = xdr_encode_hyper(p, bs * s->f_bavail);	/* user available bytes */
-		p = xdr_encode_hyper(p, s->f_files);	/* total inodes */
-		p = xdr_encode_hyper(p, s->f_ffree);	/* free inodes */
-		p = xdr_encode_hyper(p, s->f_ffree);	/* user available inodes */
-		*p++ = htonl(resp->invarsec);	/* mean unchanged time */
+	if (!svcxdr_encode_nfsstat3(xdr, resp->status))
+		return 0;
+	switch (resp->status) {
+	case nfs_ok:
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &nfs3svc_null_fh))
+			return 0;
+		if (!svcxdr_encode_fsstat3resok(xdr, resp))
+			return 0;
+		break;
+	default:
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &nfs3svc_null_fh))
+			return 0;
 	}
-	return xdr_ressize_check(rqstp, p);
+
+	return 1;
 }
 
 /* FSINFO */
-- 
2.43.0



