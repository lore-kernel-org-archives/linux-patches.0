Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2083713AD2F;
	Tue, 18 Jun 2024 12:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715168; cv=none; b=pDVTZlxEQwPMUdHF7qBnEBR98r14KVrXpJe8ajxBRGXLUxC/U8xlm7CQ2AdrlpUvnkyr2fKkDdO/cMqlrYR4J0C4+EXc5TiW2ZCn+ZKu7owV+R7lv75zzl0m1qNCHWQVRdqypKb5zg8fFkWRbc1B3SM8Msm62QXmW85r7wjTzHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715168; c=relaxed/simple;
	bh=GUGZ9KGyku0uFYtLKczzL5PuE+bImu7Ese1DCgbrwBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pt+YuILo8FjgEGu/Lqphn8IP8In1ftaQ0ZgP2e4tBkaitHsefOPMr/eGq98c+8/jhu04Wd+QDOPP0xj0JDXa3IkjUSquux6aO0DYvL5+t87rhflghHEiipeEvlEz3qTlEeehrtp5eBOIRLfLbY8wZbh68d76tb1ISMDfGN5oSf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jybzsEug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jybzsEug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E243C3277B;
	Tue, 18 Jun 2024 12:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715168;
	bh=GUGZ9KGyku0uFYtLKczzL5PuE+bImu7Ese1DCgbrwBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jybzsEugq03OVTiLWm5wq03A1C85JMZ05DeolcC0/efavIvWzVHYa5FexeDFKz4Rg
	 BsTfM7NRWuA3409sXo2o9cclBDIGs29BYpZHMewfEqdRoe3ffhneEkm/xu7CUUnkOr
	 4gjNdl6xbrXOEm8CwrNfEbo5B14BEngESyTpBX/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 218/770] NFSD: Update the NFSv2 stat encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:31:11 +0200
Message-ID: <20240618123415.696156392@linuxfoundation.org>
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

[ Upstream commit a887eaed2a964754334cd3f8c5fe87e413e68fef ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsproc.c | 10 +++++-----
 fs/nfsd/nfsxdr.c  | 19 ++++++++++++++++---
 fs/nfsd/xdr.h     |  2 +-
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index a628ea4d66ead..00eb722129ab3 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -736,7 +736,7 @@ static const struct svc_procedure nfsd_procedures2[18] = {
 	[NFSPROC_REMOVE] = {
 		.pc_func = nfsd_proc_remove,
 		.pc_decode = nfssvc_decode_diropargs,
-		.pc_encode = nfssvc_encode_stat,
+		.pc_encode = nfssvc_encode_statres,
 		.pc_argsize = sizeof(struct nfsd_diropargs),
 		.pc_ressize = sizeof(struct nfsd_stat),
 		.pc_cachetype = RC_REPLSTAT,
@@ -746,7 +746,7 @@ static const struct svc_procedure nfsd_procedures2[18] = {
 	[NFSPROC_RENAME] = {
 		.pc_func = nfsd_proc_rename,
 		.pc_decode = nfssvc_decode_renameargs,
-		.pc_encode = nfssvc_encode_stat,
+		.pc_encode = nfssvc_encode_statres,
 		.pc_argsize = sizeof(struct nfsd_renameargs),
 		.pc_ressize = sizeof(struct nfsd_stat),
 		.pc_cachetype = RC_REPLSTAT,
@@ -756,7 +756,7 @@ static const struct svc_procedure nfsd_procedures2[18] = {
 	[NFSPROC_LINK] = {
 		.pc_func = nfsd_proc_link,
 		.pc_decode = nfssvc_decode_linkargs,
-		.pc_encode = nfssvc_encode_stat,
+		.pc_encode = nfssvc_encode_statres,
 		.pc_argsize = sizeof(struct nfsd_linkargs),
 		.pc_ressize = sizeof(struct nfsd_stat),
 		.pc_cachetype = RC_REPLSTAT,
@@ -766,7 +766,7 @@ static const struct svc_procedure nfsd_procedures2[18] = {
 	[NFSPROC_SYMLINK] = {
 		.pc_func = nfsd_proc_symlink,
 		.pc_decode = nfssvc_decode_symlinkargs,
-		.pc_encode = nfssvc_encode_stat,
+		.pc_encode = nfssvc_encode_statres,
 		.pc_argsize = sizeof(struct nfsd_symlinkargs),
 		.pc_ressize = sizeof(struct nfsd_stat),
 		.pc_cachetype = RC_REPLSTAT,
@@ -787,7 +787,7 @@ static const struct svc_procedure nfsd_procedures2[18] = {
 	[NFSPROC_RMDIR] = {
 		.pc_func = nfsd_proc_rmdir,
 		.pc_decode = nfssvc_decode_diropargs,
-		.pc_encode = nfssvc_encode_stat,
+		.pc_encode = nfssvc_encode_statres,
 		.pc_argsize = sizeof(struct nfsd_diropargs),
 		.pc_ressize = sizeof(struct nfsd_stat),
 		.pc_cachetype = RC_REPLSTAT,
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 5d79ef6a0c7fc..10cd120044b30 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -26,6 +26,19 @@ static u32	nfs_ftypes[] = {
  * Basic NFSv2 data types (RFC 1094 Section 2.3)
  */
 
+static bool
+svcxdr_encode_stat(struct xdr_stream *xdr, __be32 status)
+{
+	__be32 *p;
+
+	p = xdr_reserve_space(xdr, sizeof(status));
+	if (!p)
+		return false;
+	*p = status;
+
+	return true;
+}
+
 /**
  * svcxdr_decode_fhandle - Decode an NFSv2 file handle
  * @xdr: XDR stream positioned at an encoded NFSv2 FH
@@ -390,12 +403,12 @@ nfssvc_decode_readdirargs(struct svc_rqst *rqstp, __be32 *p)
  */
 
 int
-nfssvc_encode_stat(struct svc_rqst *rqstp, __be32 *p)
+nfssvc_encode_statres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd_stat *resp = rqstp->rq_resp;
 
-	*p++ = resp->status;
-	return xdr_ressize_check(rqstp, p);
+	return svcxdr_encode_stat(xdr, resp->status);
 }
 
 int
diff --git a/fs/nfsd/xdr.h b/fs/nfsd/xdr.h
index b92f1acec9e77..f040123373bf5 100644
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -147,7 +147,7 @@ int nfssvc_decode_renameargs(struct svc_rqst *, __be32 *);
 int nfssvc_decode_linkargs(struct svc_rqst *, __be32 *);
 int nfssvc_decode_symlinkargs(struct svc_rqst *, __be32 *);
 int nfssvc_decode_readdirargs(struct svc_rqst *, __be32 *);
-int nfssvc_encode_stat(struct svc_rqst *, __be32 *);
+int nfssvc_encode_statres(struct svc_rqst *, __be32 *);
 int nfssvc_encode_attrstat(struct svc_rqst *, __be32 *);
 int nfssvc_encode_diropres(struct svc_rqst *, __be32 *);
 int nfssvc_encode_readlinkres(struct svc_rqst *, __be32 *);
-- 
2.43.0



