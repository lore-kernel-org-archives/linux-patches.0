Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C11514F10F;
	Tue, 18 Jun 2024 12:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714985; cv=none; b=KUx1oS+ZgExDodV+onux0XIUvyRRvhykjnofjV16cFUh0ErSm1suIhqmPW4Vgim2clpPggU0skVv1M6o3MyFl6/2B3SUWQ/mD58jouzMHSEpnz/Iiuju+axGtnV7MCAxTKDM6UV0xWWslK5FV9OkvFkM3HJKIEqAetDjhsIW7XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714985; c=relaxed/simple;
	bh=uT3X53UaTd3DgsuF4Gmp0Ea6AhTXLHw8jZAeFUzLDMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xiwdztt8NggayUjbMhprldeVO7JfcIkvdqnBCDKSIXt/WYEkVkOrTMaSoLbxG/g19CMye5SgEjD99y8vrQJL6P1Y7NoM9y3P2CVTA07JLYT2qapJfEzfQSr2HadvptCpf19jihdM7rt0PpzBCZAejzKJO8pdilalwOPnZsc4ckI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HhzvHSFg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HhzvHSFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E27C3277B;
	Tue, 18 Jun 2024 12:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714985;
	bh=uT3X53UaTd3DgsuF4Gmp0Ea6AhTXLHw8jZAeFUzLDMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhzvHSFgwh1CWbMOSJbAMLWd3Qa45ha3XFroo3Hkrc3usdOPVSdYqxDoX0JL3GTHS
	 dXyeFIQJuNo4U+bDxhF703UgHROQ3i13JDXsdEbsD7uYWwROZ06Urj9EyADkgt89uO
	 4zomZvs1/rXJpBebxW1aLh9A/7JTrajSQKxuzEq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 156/770] NFSD: Update the NFSv2 READLINK argument decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:09 +0200
Message-ID: <20240618123413.298030227@linuxfoundation.org>
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

[ Upstream commit 1fcbd1c9456ba129d38420e345e91c4b6363db47 ]

If the code that sets up the sink buffer for nfsd_readlink() is
moved adjacent to the nfsd_readlink() call site that uses it, then
the only argument is a file handle, and the fhandle decoder can be
used instead.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsproc.c |  9 +++++----
 fs/nfsd/nfsxdr.c  | 13 -------------
 fs/nfsd/xdr.h     |  6 ------
 3 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index c70ae20e54c49..6352da0168e04 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -149,14 +149,15 @@ nfsd_proc_lookup(struct svc_rqst *rqstp)
 static __be32
 nfsd_proc_readlink(struct svc_rqst *rqstp)
 {
-	struct nfsd_readlinkargs *argp = rqstp->rq_argp;
+	struct nfsd_fhandle *argp = rqstp->rq_argp;
 	struct nfsd_readlinkres *resp = rqstp->rq_resp;
+	char *buffer = page_address(*(rqstp->rq_next_page++));
 
 	dprintk("nfsd: READLINK %s\n", SVCFH_fmt(&argp->fh));
 
 	/* Read the symlink. */
 	resp->len = NFS_MAXPATHLEN;
-	resp->status = nfsd_readlink(rqstp, &argp->fh, argp->buffer, &resp->len);
+	resp->status = nfsd_readlink(rqstp, &argp->fh, buffer, &resp->len);
 
 	fh_put(&argp->fh);
 	return rpc_success;
@@ -674,9 +675,9 @@ static const struct svc_procedure nfsd_procedures2[18] = {
 	},
 	[NFSPROC_READLINK] = {
 		.pc_func = nfsd_proc_readlink,
-		.pc_decode = nfssvc_decode_readlinkargs,
+		.pc_decode = nfssvc_decode_fhandleargs,
 		.pc_encode = nfssvc_encode_readlinkres,
-		.pc_argsize = sizeof(struct nfsd_readlinkargs),
+		.pc_argsize = sizeof(struct nfsd_fhandle),
 		.pc_ressize = sizeof(struct nfsd_readlinkres),
 		.pc_cachetype = RC_NOCACHE,
 		.pc_xdrressize = ST+1+NFS_MAXPATHLEN/4,
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 11d27b219cff2..02dd9888d93b2 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -326,19 +326,6 @@ nfssvc_decode_renameargs(struct svc_rqst *rqstp, __be32 *p)
 	return xdr_argsize_check(rqstp, p);
 }
 
-int
-nfssvc_decode_readlinkargs(struct svc_rqst *rqstp, __be32 *p)
-{
-	struct nfsd_readlinkargs *args = rqstp->rq_argp;
-
-	p = decode_fh(p, &args->fh);
-	if (!p)
-		return 0;
-	args->buffer = page_address(*(rqstp->rq_next_page++));
-
-	return xdr_argsize_check(rqstp, p);
-}
-
 int
 nfssvc_decode_linkargs(struct svc_rqst *rqstp, __be32 *p)
 {
diff --git a/fs/nfsd/xdr.h b/fs/nfsd/xdr.h
index 7c704fa3215eb..1338551de828e 100644
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -52,11 +52,6 @@ struct nfsd_renameargs {
 	unsigned int		tlen;
 };
 
-struct nfsd_readlinkargs {
-	struct svc_fh		fh;
-	char *			buffer;
-};
-	
 struct nfsd_linkargs {
 	struct svc_fh		ffh;
 	struct svc_fh		tfh;
@@ -150,7 +145,6 @@ int nfssvc_decode_readargs(struct svc_rqst *, __be32 *);
 int nfssvc_decode_writeargs(struct svc_rqst *, __be32 *);
 int nfssvc_decode_createargs(struct svc_rqst *, __be32 *);
 int nfssvc_decode_renameargs(struct svc_rqst *, __be32 *);
-int nfssvc_decode_readlinkargs(struct svc_rqst *, __be32 *);
 int nfssvc_decode_linkargs(struct svc_rqst *, __be32 *);
 int nfssvc_decode_symlinkargs(struct svc_rqst *, __be32 *);
 int nfssvc_decode_readdirargs(struct svc_rqst *, __be32 *);
-- 
2.43.0



