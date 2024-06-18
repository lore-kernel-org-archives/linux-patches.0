Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE3514EC4C;
	Tue, 18 Jun 2024 12:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714973; cv=none; b=C2SHAqj7KNW6Z0EWHzIkVrh50kwPrOiXRabyANXWfKz9uFh4NTMElq0CFV8nwVhh+7GTfOjaFwCanawCmchf2YvpMzAlBWWOH8xFU4HAgqFxl0EPq8N5OeJ/m9qXquA8Vs1tDuhr+hs/eqvDma7kRC+2D3MSWbrwSbiKTdq7BYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714973; c=relaxed/simple;
	bh=DGu65gZ/yAIVj01v+WsY52Iyw9wR9p9S8gZ7pMSuLKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZWSQtVWYoTdHCgvsPZKoHsdssqsANj/TskMW6BYueF5j7o0X8+jn2FpEanqYFvvlLSYOBvRv1UsVAj+t4drCNGDXTPFu9w+v+Jc6XVXx6B+Lp5NIxlspbk1wk+ltjKUZKwO+DcNs37g1VW2SOKNv2vYcA1uiP9+OiceAXi4lVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R2wZXaqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R2wZXaqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271A7C3277B;
	Tue, 18 Jun 2024 12:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714973;
	bh=DGu65gZ/yAIVj01v+WsY52Iyw9wR9p9S8gZ7pMSuLKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2wZXaqOxQwD3cZe2VAfGN7OSOdL+WrmWMx/jPydIraOwvFVItUrx7TUSbQSurv0X
	 v6x0I2vDIz8yJSLlbobXXPefb7tTu4zgMTuAkVNf5e/dLRdxNfzKAfDyZEHE9zHGJX
	 Boc4LU9yewXYlY9QCnfOxszZY6yahqu0j7pM1FwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 152/770] NFSD: Update the MKNOD3args decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:05 +0200
Message-ID: <20240618123413.142000701@linuxfoundation.org>
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

[ Upstream commit f8a38e2d6c885f9d7cd03febc515d36293de4a5b ]

This commit removes the last usage of the original decode_sattr3(),
so it is removed as a clean-up.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 107 +++++++++++++++-------------------------------
 1 file changed, 35 insertions(+), 72 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index eb17231ab1661..a30b418a51160 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -103,26 +103,6 @@ encode_fh(__be32 *p, struct svc_fh *fhp)
 	return p + XDR_QUADLEN(size);
 }
 
-/*
- * Decode a file name and make sure that the path contains
- * no slashes or null bytes.
- */
-static __be32 *
-decode_filename(__be32 *p, char **namp, unsigned int *lenp)
-{
-	char		*name;
-	unsigned int	i;
-
-	if ((p = xdr_decode_string_inplace(p, namp, lenp, NFS3_MAXNAMLEN)) != NULL) {
-		for (i = 0, name = *namp; i < *lenp; i++, name++) {
-			if (*name == '\0' || *name == '/')
-				return NULL;
-		}
-	}
-
-	return p;
-}
-
 static bool
 svcxdr_decode_filename3(struct xdr_stream *xdr, char **name, unsigned int *len)
 {
@@ -262,49 +242,26 @@ svcxdr_decode_sattrguard3(struct xdr_stream *xdr, struct nfsd3_sattrargs *args)
 	return true;
 }
 
-static __be32 *
-decode_sattr3(__be32 *p, struct iattr *iap, struct user_namespace *userns)
+static bool
+svcxdr_decode_specdata3(struct xdr_stream *xdr, struct nfsd3_mknodargs *args)
 {
-	u32	tmp;
+	__be32 *p;
 
-	iap->ia_valid = 0;
+	p = xdr_inline_decode(xdr, XDR_UNIT * 2);
+	if (!p)
+		return false;
+	args->major = be32_to_cpup(p++);
+	args->minor = be32_to_cpup(p);
 
-	if (*p++) {
-		iap->ia_valid |= ATTR_MODE;
-		iap->ia_mode = ntohl(*p++);
-	}
-	if (*p++) {
-		iap->ia_uid = make_kuid(userns, ntohl(*p++));
-		if (uid_valid(iap->ia_uid))
-			iap->ia_valid |= ATTR_UID;
-	}
-	if (*p++) {
-		iap->ia_gid = make_kgid(userns, ntohl(*p++));
-		if (gid_valid(iap->ia_gid))
-			iap->ia_valid |= ATTR_GID;
-	}
-	if (*p++) {
-		u64	newsize;
+	return true;
+}
 
-		iap->ia_valid |= ATTR_SIZE;
-		p = xdr_decode_hyper(p, &newsize);
-		iap->ia_size = min_t(u64, newsize, NFS_OFFSET_MAX);
-	}
-	if ((tmp = ntohl(*p++)) == 1) {	/* set to server time */
-		iap->ia_valid |= ATTR_ATIME;
-	} else if (tmp == 2) {		/* set to client time */
-		iap->ia_valid |= ATTR_ATIME | ATTR_ATIME_SET;
-		iap->ia_atime.tv_sec = ntohl(*p++);
-		iap->ia_atime.tv_nsec = ntohl(*p++);
-	}
-	if ((tmp = ntohl(*p++)) == 1) {	/* set to server time */
-		iap->ia_valid |= ATTR_MTIME;
-	} else if (tmp == 2) {		/* set to client time */
-		iap->ia_valid |= ATTR_MTIME | ATTR_MTIME_SET;
-		iap->ia_mtime.tv_sec = ntohl(*p++);
-		iap->ia_mtime.tv_nsec = ntohl(*p++);
-	}
-	return p;
+static bool
+svcxdr_decode_devicedata3(struct svc_rqst *rqstp, struct xdr_stream *xdr,
+			  struct nfsd3_mknodargs *args)
+{
+	return svcxdr_decode_sattr3(rqstp, xdr, &args->attrs) &&
+		svcxdr_decode_specdata3(xdr, args);
 }
 
 static __be32 *encode_fsid(__be32 *p, struct svc_fh *fhp)
@@ -644,24 +601,30 @@ nfs3svc_decode_symlinkargs(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_decode_mknodargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd3_mknodargs *args = rqstp->rq_argp;
 
-	if (!(p = decode_fh(p, &args->fh))
-	 || !(p = decode_filename(p, &args->name, &args->len)))
+	if (!svcxdr_decode_diropargs3(xdr, &args->fh, &args->name, &args->len))
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &args->ftype) < 0)
+		return 0;
+	switch (args->ftype) {
+	case NF3CHR:
+	case NF3BLK:
+		return svcxdr_decode_devicedata3(rqstp, xdr, args);
+	case NF3SOCK:
+	case NF3FIFO:
+		return svcxdr_decode_sattr3(rqstp, xdr, &args->attrs);
+	case NF3REG:
+	case NF3DIR:
+	case NF3LNK:
+		/* Valid XDR but illegal file types */
+		break;
+	default:
 		return 0;
-
-	args->ftype = ntohl(*p++);
-
-	if (args->ftype == NF3BLK  || args->ftype == NF3CHR
-	 || args->ftype == NF3SOCK || args->ftype == NF3FIFO)
-		p = decode_sattr3(p, &args->attrs, nfsd_user_namespace(rqstp));
-
-	if (args->ftype == NF3BLK || args->ftype == NF3CHR) {
-		args->major = ntohl(*p++);
-		args->minor = ntohl(*p++);
 	}
 
-	return xdr_argsize_check(rqstp, p);
+	return 1;
 }
 
 int
-- 
2.43.0



