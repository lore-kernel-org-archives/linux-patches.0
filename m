Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369BE13F431;
	Tue, 18 Jun 2024 12:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715059; cv=none; b=MIsqmeK5T2vXh71euLe4IabpFA9fn0dasZdZzg7X8j37nHTSES5Ewud2WXS06TSbXNll79eZN+7v88n5iRxvE+DSBbefIcUX/HhX/G1G147nyHwjd2cgHccyGnV/7ZspELzetaKl4IPSmmA71i2elaa8YH6hzYyVIVxHpcs3jxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715059; c=relaxed/simple;
	bh=4V8EYxYktO+usQgplM/SDmsYAJcA+pVwQj4yOhm2afE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfgQC3r8DIsLBn1e+O3YabwF0cmWFBqrV6WiDKZLkuyiGwAgyqFcvxA33cVgjEnOhVIm5PTuhJllX+lhNtUEsASi7QrouuB77kCVlzZizIC34QetENCH1Js5FhNb4i2IjwokGlxJo1Ejih/XZc2ulNskHOrjuFXef8doIFHY/XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psX/hYXx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psX/hYXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF31C3277B;
	Tue, 18 Jun 2024 12:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715058;
	bh=4V8EYxYktO+usQgplM/SDmsYAJcA+pVwQj4yOhm2afE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psX/hYXxesn1AgRSrUqikgRUrGK1ChiEkua8wtfep/aCpfO54d38h3gaMVSwIb7n2
	 8Lmuv6LLbLoetbkwyryMvYP2MS45eNxrZ1Fb8X91s0hojxsKC1TI+Mtul6xo18fIUL
	 0wLJmu2xVyK/Ir5546zQ5ZFmcN/CQi3/TzHcxEJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 173/770] NFSD: Update the NFSv2 SETACL argument decoder to use struct xdr_stream, again
Date: Tue, 18 Jun 2024 14:30:26 +0200
Message-ID: <20240618123413.948542434@linuxfoundation.org>
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

[ Upstream commit 68519ff2a1c72c67fcdc4b81671acda59f420af9 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3acl.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/nfsd/nfs3acl.c b/fs/nfsd/nfs3acl.c
index addb0d7d5500f..a568b842e9ebe 100644
--- a/fs/nfsd/nfs3acl.c
+++ b/fs/nfsd/nfs3acl.c
@@ -140,28 +140,23 @@ static int nfs3svc_decode_getaclargs(struct svc_rqst *rqstp, __be32 *p)
 
 static int nfs3svc_decode_setaclargs(struct svc_rqst *rqstp, __be32 *p)
 {
-	struct nfsd3_setaclargs *args = rqstp->rq_argp;
-	struct kvec *head = rqstp->rq_arg.head;
-	unsigned int base;
-	int n;
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
+	struct nfsd3_setaclargs *argp = rqstp->rq_argp;
 
-	p = nfs3svc_decode_fh(p, &args->fh);
-	if (!p)
+	if (!svcxdr_decode_nfs_fh3(xdr, &argp->fh))
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &argp->mask) < 0)
 		return 0;
-	args->mask = ntohl(*p++);
-	if (args->mask & ~NFS_ACL_MASK ||
-	    !xdr_argsize_check(rqstp, p))
+	if (argp->mask & ~NFS_ACL_MASK)
+		return 0;
+	if (!nfs_stream_decode_acl(xdr, NULL, (argp->mask & NFS_ACL) ?
+				   &argp->acl_access : NULL))
+		return 0;
+	if (!nfs_stream_decode_acl(xdr, NULL, (argp->mask & NFS_DFACL) ?
+				   &argp->acl_default : NULL))
 		return 0;
 
-	base = (char *)p - (char *)head->iov_base;
-	n = nfsacl_decode(&rqstp->rq_arg, base, NULL,
-			  (args->mask & NFS_ACL) ?
-			  &args->acl_access : NULL);
-	if (n > 0)
-		n = nfsacl_decode(&rqstp->rq_arg, base + n, NULL,
-				  (args->mask & NFS_DFACL) ?
-				  &args->acl_default : NULL);
-	return (n > 0);
+	return 1;
 }
 
 /*
-- 
2.43.0



