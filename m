Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BBE15FA69;
	Tue, 18 Jun 2024 12:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715026; cv=none; b=OR2fBBei1UMnopt/HAZxQg87BvVYF5vTBN+SK8SgIC/172VXrqpYRFf2kl7pxMfY3+qEJ+lmCsGveunvnpyT/5Py9hp3pauLDfFn01UT20hDywS+4Lvfg+HzLt6PxsaGMy39x9RjXzYWWxRoJI/LLMWWSLdzIFhSiounli2pU7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715026; c=relaxed/simple;
	bh=cIjprvmy4M80CPatA9cM0/HGyU4tQ8t3bpGBj3HIQE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2eP+D3TppQft3BESaTAm0d6D8e11XVEB5GlAW3YUktpKMoJMzKmQoB+0zpBN/xaHeZ27oOlniGXsOgetsARY9NY+yLfIIN3NwMtSlPvl22ta6M5Le4eApUy2PPOKAUXBEHiZqkS483eHNKic5wNeKsS1SAJ/xrhGaMsc+7zdoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/qCvBlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/qCvBlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36364C3277B;
	Tue, 18 Jun 2024 12:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715026;
	bh=cIjprvmy4M80CPatA9cM0/HGyU4tQ8t3bpGBj3HIQE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/qCvBlZJHB7bemti8wiWwNver2J8YgVA+gCq1GHKnE+iJD1DTthTDrPZHEAH1I6r
	 aY7xEozHSDzqAiniOOoSrxc092XQ5wfm089oLkaf4hQQMGceisKQjvX2QVtwdp5bC1
	 e3WZIkSou+WHU562bVTxn7yu/HavHKlSCwsud9b8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 168/770] NFSD: Update the NFSv2 SETACL argument decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:21 +0200
Message-ID: <20240618123413.756741368@linuxfoundation.org>
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

[ Upstream commit 427eab3ba22891845265f9a3846de6ac152ec836 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c | 29 ++++++++++++-----------------
 fs/nfsd/xdr3.h    |  2 +-
 2 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index df2e145cfab0d..123820ec79d37 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -201,28 +201,23 @@ static int nfsaclsvc_decode_getaclargs(struct svc_rqst *rqstp, __be32 *p)
 
 static int nfsaclsvc_decode_setaclargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd3_setaclargs *argp = rqstp->rq_argp;
-	struct kvec *head = rqstp->rq_arg.head;
-	unsigned int base;
-	int n;
 
-	p = nfs2svc_decode_fh(p, &argp->fh);
-	if (!p)
+	if (!svcxdr_decode_fhandle(xdr, &argp->fh))
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &argp->mask) < 0)
+		return 0;
+	if (argp->mask & ~NFS_ACL_MASK)
 		return 0;
-	argp->mask = ntohl(*p++);
-	if (argp->mask & ~NFS_ACL_MASK ||
-	    !xdr_argsize_check(rqstp, p))
+	if (!nfs_stream_decode_acl(xdr, NULL, (argp->mask & NFS_ACL) ?
+				   &argp->acl_access : NULL))
+		return 0;
+	if (!nfs_stream_decode_acl(xdr, NULL, (argp->mask & NFS_DFACL) ?
+				   &argp->acl_default : NULL))
 		return 0;
 
-	base = (char *)p - (char *)head->iov_base;
-	n = nfsacl_decode(&rqstp->rq_arg, base, NULL,
-			  (argp->mask & NFS_ACL) ?
-			  &argp->acl_access : NULL);
-	if (n > 0)
-		n = nfsacl_decode(&rqstp->rq_arg, base + n, NULL,
-				  (argp->mask & NFS_DFACL) ?
-				  &argp->acl_default : NULL);
-	return (n > 0);
+	return 1;
 }
 
 static int nfsaclsvc_decode_fhandleargs(struct svc_rqst *rqstp, __be32 *p)
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index 43db4206cd254..5afb3ce4f0622 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -108,7 +108,7 @@ struct nfsd3_getaclargs {
 struct posix_acl;
 struct nfsd3_setaclargs {
 	struct svc_fh		fh;
-	int			mask;
+	__u32			mask;
 	struct posix_acl	*acl_access;
 	struct posix_acl	*acl_default;
 };
-- 
2.43.0



