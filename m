Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC2115539D;
	Tue, 18 Jun 2024 12:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715476; cv=none; b=EcBi38sda/rYkpE9fBFWPMJBi0hsOKIJLafEf2yy/mhy8jg/qQZ61P5TyxpDt+26Qj4RFSIvQpJYWSvzhTDSKa+coUBy1+o0gqjm5AqeoXFLeWLYCf2OuA4RR6ly+b/V5TxixIFX3bZc4Hldi29k9MSzIEhUwM6GJEqhCeqKwJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715476; c=relaxed/simple;
	bh=5G6gKXBfj0Fr2iJEkkB9P/pRAGC+lxGLXCLdPAPB/Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCS4Ogk29XaGgmKcZ0dkGiy3uph0abxzdiCBv3fmxOAQzjEJ2Qx+fmIS4AVIiTNln0NBpKD3Z2+wz2hVrQC6gPMra2zVxlcf5sQU0Q9z2XoCtrMfvU9mu5yIerzQtohCm0dNKa21ZwVL8Q37EXPT7Xo4oJTT+2SKz8asKs0hsrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELxosIN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELxosIN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E319BC3277B;
	Tue, 18 Jun 2024 12:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715476;
	bh=5G6gKXBfj0Fr2iJEkkB9P/pRAGC+lxGLXCLdPAPB/Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELxosIN9W93Q+bPRgaT/cioGA3gzjbqYBXUlNfb2vugJZ4P6ykVxturfzOdUHQdMG
	 l31HT6iYp4pZPyRsJPf2dBEcXe3iwamgFH2Wcmr4Z5DPw8btlG8GfnAHfm0zOJlrpS
	 1TsC+GIyDhn1i9pMoqCJ8+qm8TMn6xwNfn/S7LkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 322/770] lockd: Update the NLMv4 SHARE arguments decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:55 +0200
Message-ID: <20240618123419.686863685@linuxfoundation.org>
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

[ Upstream commit 7cf96b6d0104b12aa30961901879e428884b1695 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr4.c | 99 +++++++++++++------------------------------------
 1 file changed, 26 insertions(+), 73 deletions(-)

diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index 2dbf82c2726be..e6bab1d1e41fb 100644
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -42,37 +42,6 @@ loff_t_to_s64(loff_t offset)
 	return res;
 }
 
-/*
- * XDR functions for basic NLM types
- */
-static __be32 *
-nlm4_decode_cookie(__be32 *p, struct nlm_cookie *c)
-{
-	unsigned int	len;
-
-	len = ntohl(*p++);
-	
-	if(len==0)
-	{
-		c->len=4;
-		memset(c->data, 0, 4);	/* hockeypux brain damage */
-	}
-	else if(len<=NLM_MAXCOOKIELEN)
-	{
-		c->len=len;
-		memcpy(c->data, p, len);
-		p+=XDR_QUADLEN(len);
-	}
-	else 
-	{
-		dprintk("lockd: bad cookie size %d (only cookies under "
-			"%d bytes are supported.)\n",
-				len, NLM_MAXCOOKIELEN);
-		return NULL;
-	}
-	return p;
-}
-
 static __be32 *
 nlm4_encode_cookie(__be32 *p, struct nlm_cookie *c)
 {
@@ -82,20 +51,6 @@ nlm4_encode_cookie(__be32 *p, struct nlm_cookie *c)
 	return p;
 }
 
-static __be32 *
-nlm4_decode_fh(__be32 *p, struct nfs_fh *f)
-{
-	memset(f->data, 0, sizeof(f->data));
-	f->size = ntohl(*p++);
-	if (f->size > NFS_MAXFHSIZE) {
-		dprintk("lockd: bad fhandle size %d (should be <=%d)\n",
-			f->size, NFS_MAXFHSIZE);
-		return NULL;
-	}
-      	memcpy(f->data, p, f->size);
-	return p + XDR_QUADLEN(f->size);
-}
-
 /*
  * NLM file handles are defined by specification to be a variable-length
  * XDR opaque no longer than 1024 bytes. However, this implementation
@@ -122,15 +77,6 @@ svcxdr_decode_fhandle(struct xdr_stream *xdr, struct nfs_fh *fh)
 	return true;
 }
 
-/*
- * Encode and decode owner handle
- */
-static __be32 *
-nlm4_decode_oh(__be32 *p, struct xdr_netobj *oh)
-{
-	return xdr_decode_netobj(p, oh);
-}
-
 static bool
 svcxdr_decode_lock(struct xdr_stream *xdr, struct nlm_lock *lock)
 {
@@ -335,35 +281,42 @@ nlm4svc_decode_reboot(struct svc_rqst *rqstp, __be32 *p)
 	return 1;
 }
 
-int
-nlm4svc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
-{
-	struct nlm_res *resp = rqstp->rq_resp;
-
-	if (!(p = nlm4_encode_testres(p, resp)))
-		return 0;
-	return xdr_ressize_check(rqstp, p);
-}
-
 int
 nlm4svc_decode_shareargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nlm_args *argp = rqstp->rq_argp;
 	struct nlm_lock	*lock = &argp->lock;
 
 	memset(lock, 0, sizeof(*lock));
 	locks_init_lock(&lock->fl);
-	lock->svid = ~(u32) 0;
+	lock->svid = ~(u32)0;
 
-	if (!(p = nlm4_decode_cookie(p, &argp->cookie))
-	 || !(p = xdr_decode_string_inplace(p, &lock->caller,
-					    &lock->len, NLM_MAXSTRLEN))
-	 || !(p = nlm4_decode_fh(p, &lock->fh))
-	 || !(p = nlm4_decode_oh(p, &lock->oh)))
+	if (!svcxdr_decode_cookie(xdr, &argp->cookie))
 		return 0;
-	argp->fsm_mode = ntohl(*p++);
-	argp->fsm_access = ntohl(*p++);
-	return xdr_argsize_check(rqstp, p);
+	if (!svcxdr_decode_string(xdr, &lock->caller, &lock->len))
+		return 0;
+	if (!svcxdr_decode_fhandle(xdr, &lock->fh))
+		return 0;
+	if (!svcxdr_decode_owner(xdr, &lock->oh))
+		return 0;
+	/* XXX: Range checks are missing in the original code */
+	if (xdr_stream_decode_u32(xdr, &argp->fsm_mode) < 0)
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &argp->fsm_access) < 0)
+		return 0;
+
+	return 1;
+}
+
+int
+nlm4svc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
+{
+	struct nlm_res *resp = rqstp->rq_resp;
+
+	if (!(p = nlm4_encode_testres(p, resp)))
+		return 0;
+	return xdr_ressize_check(rqstp, p);
 }
 
 int
-- 
2.43.0



