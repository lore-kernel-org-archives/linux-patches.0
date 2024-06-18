Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF92314F118;
	Tue, 18 Jun 2024 12:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715017; cv=none; b=GHfI0FXhjgi/xSOZ6410JKIHjeRHF/Bh1xri4RYa9fjSspxT1ePzazbTOmXU2dgCi6rlnEVS1JducspU1XFML8eyM7vy3xJT1SixUwf1TT6u2vf5rdojJrrsc1dtdhcygYxOShbeHHff1/F8d/hDqFpiBWf4e7BBFeUf87yBUrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715017; c=relaxed/simple;
	bh=YBLPUvmzXgMekbcRxNWF8hzn7AkhjtRkyu0HgN1xAqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYu4FVDWZzyiWMy+UDGavIUBCLcEo03LkLvPJDXqNH40SdugXbP6ThmWAGmj4eqmzujtW3meFeHfyGsMsVWBcV9wT8Levw5P/G7qiByftol6uBsGY0kZ6/FzLQ4Qas33VCDsOd0HmT2Yrszqnt4cIWHoEcKuFHvXNDIRLehx/VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZV3PXsT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZV3PXsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B1AC3277B;
	Tue, 18 Jun 2024 12:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715017;
	bh=YBLPUvmzXgMekbcRxNWF8hzn7AkhjtRkyu0HgN1xAqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZV3PXsTUAkGcEGNn0APExqnIpiLZBDc5pXz2P2Mynks4B9Z+55ZZXLr00IlG17Ww
	 Izj5TNo2tbUoXR49wDXWN2uJVy3yTHJaLtolOn2s4XplQdRmgg8bDq+82KFlhxy4Tm
	 V8XtmcIa7HIklSID5S/SveKTc2MMdpE0C+OypLck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 166/770] NFSD: Update the NFSv2 GETACL argument decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:19 +0200
Message-ID: <20240618123413.681881769@linuxfoundation.org>
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

[ Upstream commit 635a45d34706400c59c3b18ca9fccba195147bda ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c | 10 +++++-----
 fs/nfsd/nfsxdr.c  | 11 ++++++++++-
 fs/nfsd/xdr.h     |  1 +
 fs/nfsd/xdr3.h    |  2 +-
 4 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index 899762da23c92..df2e145cfab0d 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -188,17 +188,17 @@ static __be32 nfsacld_proc_access(struct svc_rqst *rqstp)
 
 static int nfsaclsvc_decode_getaclargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd3_getaclargs *argp = rqstp->rq_argp;
 
-	p = nfs2svc_decode_fh(p, &argp->fh);
-	if (!p)
+	if (!svcxdr_decode_fhandle(xdr, &argp->fh))
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &argp->mask) < 0)
 		return 0;
-	argp->mask = ntohl(*p); p++;
 
-	return xdr_argsize_check(rqstp, p);
+	return 1;
 }
 
-
 static int nfsaclsvc_decode_setaclargs(struct svc_rqst *rqstp, __be32 *p)
 {
 	struct nfsd3_setaclargs *argp = rqstp->rq_argp;
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index f2cb4794aeaf6..5ab9fc14816c2 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -38,7 +38,16 @@ decode_fh(__be32 *p, struct svc_fh *fhp)
 	return p + (NFS_FHSIZE >> 2);
 }
 
-static bool
+/**
+ * svcxdr_decode_fhandle - Decode an NFSv2 file handle
+ * @xdr: XDR stream positioned at an encoded NFSv2 FH
+ * @fhp: OUT: filled-in server file handle
+ *
+ * Return values:
+ *  %false: The encoded file handle was not valid
+ *  %true: @fhp has been initialized
+ */
+bool
 svcxdr_decode_fhandle(struct xdr_stream *xdr, struct svc_fh *fhp)
 {
 	__be32 *p;
diff --git a/fs/nfsd/xdr.h b/fs/nfsd/xdr.h
index ff68643504c3c..77afad72c2aa1 100644
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -165,5 +165,6 @@ void nfssvc_release_readres(struct svc_rqst *rqstp);
 /* Helper functions for NFSv2 ACL code */
 __be32 *nfs2svc_encode_fattr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp, struct kstat *stat);
 __be32 *nfs2svc_decode_fh(__be32 *p, struct svc_fh *fhp);
+bool svcxdr_decode_fhandle(struct xdr_stream *xdr, struct svc_fh *fhp);
 
 #endif /* LINUX_NFSD_H */
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index 64af5b01c5d7b..43db4206cd254 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -102,7 +102,7 @@ struct nfsd3_commitargs {
 
 struct nfsd3_getaclargs {
 	struct svc_fh		fh;
-	int			mask;
+	__u32			mask;
 };
 
 struct posix_acl;
-- 
2.43.0



