Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028C1152DEB;
	Tue, 18 Jun 2024 12:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715174; cv=none; b=B4R+ZgUuDYVlqeL+UJ4QsXUhTOVVu/9t59hycIF3UnrY8Q7dJZjv/IRqj3SuENT1NA+MTb0AUtOooXEBzWCgZ7v2g2/T4XIlspHT2qvdTksNcxUCo9dNTfDmJ13zN9oglQ12U1f+Zh12Yd7caoi0ufc4liVHm9uSr7oxtFJaar8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715174; c=relaxed/simple;
	bh=xI7tUxHCuabUt7WXs90aLc4uwOOaEf0o9H1ml52QCKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGq2jLpJl49cIkVKUtkXJYT9uHdwgJVPIYWP4Fc0oJeiuJWjWrlqfLb0g816m8iHea2uJv/phpG/kRL72bvmBCqZpibtejfwL69lLWdoPRBV/GZZSZktIgj56l0S+1zdX+y8ARQoYOWOJ1XtyyIV14lL2BjAXRbhP5JmmzbwxiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y91j2Uv/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y91j2Uv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C811C3277B;
	Tue, 18 Jun 2024 12:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715173;
	bh=xI7tUxHCuabUt7WXs90aLc4uwOOaEf0o9H1ml52QCKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y91j2Uv/8f7f8CHCrzaJD2MdYtlwfgFhKIiHhu3q2sF64FbU3KCvBkZmYDi2I0o8q
	 byn2wJGLE7FOxpYJP7i2Y7udzoFhpdf9zs3m7EsQ7YZkwMVdmnOK0yIzaS9XesXn6r
	 pX5x0rbYQlkmeZduGCC617LSRKlguGEKOFaTCI3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 220/770] NFSD: Update the NFSv2 diropres encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:31:13 +0200
Message-ID: <20240618123415.774722366@linuxfoundation.org>
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

[ Upstream commit e3b4ef221ac57c08341c97a10c8a81c041f76716 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsxdr.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 65c8f8f314443..989144b0d5be2 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -63,11 +63,17 @@ svcxdr_decode_fhandle(struct xdr_stream *xdr, struct svc_fh *fhp)
 	return true;
 }
 
-static __be32 *
-encode_fh(__be32 *p, struct svc_fh *fhp)
+static bool
+svcxdr_encode_fhandle(struct xdr_stream *xdr, const struct svc_fh *fhp)
 {
+	__be32 *p;
+
+	p = xdr_reserve_space(xdr, NFS_FHSIZE);
+	if (!p)
+		return false;
 	memcpy(p, &fhp->fh_handle.fh_base, NFS_FHSIZE);
-	return p + (NFS_FHSIZE>> 2);
+
+	return true;
 }
 
 static __be32 *
@@ -244,7 +250,7 @@ encode_fattr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp,
 	return p;
 }
 
-static int
+static bool
 svcxdr_encode_fattr(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 		    const struct svc_fh *fhp, const struct kstat *stat)
 {
@@ -257,7 +263,7 @@ svcxdr_encode_fattr(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 
 	p = xdr_reserve_space(xdr, XDR_UNIT * 17);
 	if (!p)
-		return 0;
+		return false;
 
 	*p++ = cpu_to_be32(nfs_ftypes[type >> 12]);
 	*p++ = cpu_to_be32((u32)stat->mode);
@@ -299,7 +305,7 @@ svcxdr_encode_fattr(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 	p = encode_timeval(p, &time);
 	encode_timeval(p, &stat->ctime);
 
-	return 1;
+	return true;
 }
 
 /* Helper function for NFSv2 ACL code */
@@ -501,15 +507,21 @@ nfssvc_encode_attrstatres(struct svc_rqst *rqstp, __be32 *p)
 int
 nfssvc_encode_diropres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd_diropres *resp = rqstp->rq_resp;
 
-	*p++ = resp->status;
-	if (resp->status != nfs_ok)
-		goto out;
-	p = encode_fh(p, &resp->fh);
-	p = encode_fattr(rqstp, p, &resp->fh, &resp->stat);
-out:
-	return xdr_ressize_check(rqstp, p);
+	if (!svcxdr_encode_stat(xdr, resp->status))
+		return 0;
+	switch (resp->status) {
+	case nfs_ok:
+		if (!svcxdr_encode_fhandle(xdr, &resp->fh))
+			return 0;
+		if (!svcxdr_encode_fattr(rqstp, xdr, &resp->fh, &resp->stat))
+			return 0;
+		break;
+	}
+
+	return 1;
 }
 
 int
-- 
2.43.0



