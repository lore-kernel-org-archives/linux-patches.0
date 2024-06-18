Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B4C14EC75;
	Tue, 18 Jun 2024 12:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715021; cv=none; b=q7l5e4ch0G/PeqSG6FkwZgbgj1MZxvkyGpI3IGPYxssWoPRw2B9fFQ7vPqAnvVv28/N/pxAjRDQFocMJuq0N4g75pwNhuBZHrFjqvWjbSOVnvAMXrjiXa6UpdtAZ5c3tjlEYFJnCx5DW4rwMzXJe5tzaerz/4bKbiErML+M6Wo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715021; c=relaxed/simple;
	bh=RTHWvK9P1t1Iwck3e4AMqGgZOpk/S6u9qrPDc7+EwmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0xaetVJDIS04bnORIUZTKirOGAMDb2Ygiol7pHbJ65XmiB1nBk5g4llEEacBKUuHfAnUX8uU+edURwxFfrWl/mW+d0XKMFDMc9yxbwqhkeKrngKmIvpidSHs/xE9vhdHoeYW66tweosDRcGzefsq2ahlgLzI9IU2tLO4uBI2jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WT1/Cgj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WT1/Cgj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443B4C3277B;
	Tue, 18 Jun 2024 12:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715020;
	bh=RTHWvK9P1t1Iwck3e4AMqGgZOpk/S6u9qrPDc7+EwmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WT1/Cgj31O9jld88RvT3mEq2QetH3zR2Ew1m9bD5SUILZh01M5nNLg7WJPZfkfM9e
	 iEQl/R/3k5JrkhQpiPPasTDAXmiVeBNTqXZhkX80tecKBcItN7yp89lkDBM3j8/FY/
	 IA4rykvcztQdEV0BPhiOlqrWA3DkBgwXq4OBt3Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/770] NFSD: Update READLINK3arg decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:29:53 +0200
Message-ID: <20240618123412.679461086@linuxfoundation.org>
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

[ Upstream commit 224c1c894e48cd72e4dd9fb6311be80cbe1369b0 ]

The NFSv3 READLINK request takes a single filehandle, so it can
re-use GETATTR's decoder.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c |  9 +++++----
 fs/nfsd/nfs3xdr.c  | 13 -------------
 fs/nfsd/xdr3.h     |  6 ------
 3 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 2e477cd870913..71db0ed3c49ed 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -124,15 +124,16 @@ nfsd3_proc_access(struct svc_rqst *rqstp)
 static __be32
 nfsd3_proc_readlink(struct svc_rqst *rqstp)
 {
-	struct nfsd3_readlinkargs *argp = rqstp->rq_argp;
+	struct nfsd_fhandle *argp = rqstp->rq_argp;
 	struct nfsd3_readlinkres *resp = rqstp->rq_resp;
+	char *buffer = page_address(*(rqstp->rq_next_page++));
 
 	dprintk("nfsd: READLINK(3) %s\n", SVCFH_fmt(&argp->fh));
 
 	/* Read the symlink. */
 	fh_copy(&resp->fh, &argp->fh);
 	resp->len = NFS3_MAXPATHLEN;
-	resp->status = nfsd_readlink(rqstp, &resp->fh, argp->buffer, &resp->len);
+	resp->status = nfsd_readlink(rqstp, &resp->fh, buffer, &resp->len);
 	return rpc_success;
 }
 
@@ -773,10 +774,10 @@ static const struct svc_procedure nfsd_procedures3[22] = {
 	},
 	[NFS3PROC_READLINK] = {
 		.pc_func = nfsd3_proc_readlink,
-		.pc_decode = nfs3svc_decode_readlinkargs,
+		.pc_decode = nfs3svc_decode_fhandleargs,
 		.pc_encode = nfs3svc_encode_readlinkres,
 		.pc_release = nfs3svc_release_fhandle,
-		.pc_argsize = sizeof(struct nfsd3_readlinkargs),
+		.pc_argsize = sizeof(struct nfsd_fhandle),
 		.pc_ressize = sizeof(struct nfsd3_readlinkres),
 		.pc_cachetype = RC_NOCACHE,
 		.pc_xdrressize = ST+pAT+1+NFS3_MAXPATHLEN/4,
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index c06467e8ac829..6b6a839c1fc8c 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -543,19 +543,6 @@ nfs3svc_decode_renameargs(struct svc_rqst *rqstp, __be32 *p)
 	return xdr_argsize_check(rqstp, p);
 }
 
-int
-nfs3svc_decode_readlinkargs(struct svc_rqst *rqstp, __be32 *p)
-{
-	struct nfsd3_readlinkargs *args = rqstp->rq_argp;
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
 nfs3svc_decode_linkargs(struct svc_rqst *rqstp, __be32 *p)
 {
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index 7dfeeaa4e1dfc..08f909142ddf7 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -70,11 +70,6 @@ struct nfsd3_renameargs {
 	unsigned int		tlen;
 };
 
-struct nfsd3_readlinkargs {
-	struct svc_fh		fh;
-	char *			buffer;
-};
-
 struct nfsd3_linkargs {
 	struct svc_fh		ffh;
 	struct svc_fh		tfh;
@@ -282,7 +277,6 @@ int nfs3svc_decode_createargs(struct svc_rqst *, __be32 *);
 int nfs3svc_decode_mkdirargs(struct svc_rqst *, __be32 *);
 int nfs3svc_decode_mknodargs(struct svc_rqst *, __be32 *);
 int nfs3svc_decode_renameargs(struct svc_rqst *, __be32 *);
-int nfs3svc_decode_readlinkargs(struct svc_rqst *, __be32 *);
 int nfs3svc_decode_linkargs(struct svc_rqst *, __be32 *);
 int nfs3svc_decode_symlinkargs(struct svc_rqst *, __be32 *);
 int nfs3svc_decode_readdirargs(struct svc_rqst *, __be32 *);
-- 
2.43.0



