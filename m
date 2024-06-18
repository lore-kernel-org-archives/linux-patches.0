Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1826176AB0;
	Tue, 18 Jun 2024 12:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715462; cv=none; b=VGgx2b0khm4742VSnjrM3Xag9ZuMrJDcDt3TnKwMxPrzfqm6RVEvhHlz21TYxVTxqZBUMzbURVrd2xU6E0XravCoAbOAd7gYus+KKDqdAtmb3FJqTtuA6Bepx9Bbw8lmuaNGC9B73xp2zdqQwfQmAwrr2cI+dO988OMAJvNVXj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715462; c=relaxed/simple;
	bh=2AgYpAT80iclZgNbdo7FNjE3l5L+pPP88QZYYfE8nGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKQ60Nr4YFgKUOqq36hUe1JXXQoXXhXdsnvY/QZZkGWRZdtxG0OfZrn1E9HWcAmPbZoENVmZYhFCx8al3DlsKOIRctFXti7AaHTsRnZ2eiSii7Dr7aGeyye1aq0rojO596Y6saLdzOka/625rbmn0AwQX7bC3C8+/8cA8WRUWwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5K8hU9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5K8hU9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93DFC4AF1D;
	Tue, 18 Jun 2024 12:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715461;
	bh=2AgYpAT80iclZgNbdo7FNjE3l5L+pPP88QZYYfE8nGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5K8hU9SgmlMBaFLDFa/HvDIDIvZx6LUR3YdFOfrpDKOu/H7IAMMYznFNPF6ga4Du
	 DhUPCxEnHQtqUTOzn7RcaNIv6Ensk5nBm8M9X6KfCHutMMaYyavDTNo+it1Ohgo6ks
	 /EavVzU2JGIS+qLQthVF99M7tHzBI6kP157n1o0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 309/770] lockd: Update the NLMv1 SHARE arguments decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:42 +0200
Message-ID: <20240618123419.187911413@linuxfoundation.org>
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

[ Upstream commit 890939e1266b9adf3b0acd5e0385b39813cb8f11 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr.c | 96 ++++++++++++++------------------------------------
 1 file changed, 26 insertions(+), 70 deletions(-)

diff --git a/fs/lockd/xdr.c b/fs/lockd/xdr.c
index 421613170e5f9..c496f18eff06e 100644
--- a/fs/lockd/xdr.c
+++ b/fs/lockd/xdr.c
@@ -21,8 +21,6 @@
 
 #include "svcxdr.h"
 
-#define NLMDBG_FACILITY		NLMDBG_XDR
-
 
 static inline loff_t
 s32_to_loff_t(__s32 offset)
@@ -46,33 +44,6 @@ loff_t_to_s32(loff_t offset)
 /*
  * XDR functions for basic NLM types
  */
-static __be32 *nlm_decode_cookie(__be32 *p, struct nlm_cookie *c)
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
 static inline __be32 *
 nlm_encode_cookie(__be32 *p, struct nlm_cookie *c)
 {
@@ -82,22 +53,6 @@ nlm_encode_cookie(__be32 *p, struct nlm_cookie *c)
 	return p;
 }
 
-static __be32 *
-nlm_decode_fh(__be32 *p, struct nfs_fh *f)
-{
-	unsigned int	len;
-
-	if ((len = ntohl(*p++)) != NFS2_FHSIZE) {
-		dprintk("lockd: bad fhandle size %d (should be %d)\n",
-			len, NFS2_FHSIZE);
-		return NULL;
-	}
-	f->size = NFS2_FHSIZE;
-	memset(f->data, 0, sizeof(f->data));
-	memcpy(f->data, p, NFS2_FHSIZE);
-	return p + XDR_QUADLEN(NFS2_FHSIZE);
-}
-
 /*
  * NLM file handles are defined by specification to be a variable-length
  * XDR opaque no longer than 1024 bytes. However, this implementation
@@ -128,12 +83,6 @@ svcxdr_decode_fhandle(struct xdr_stream *xdr, struct nfs_fh *fh)
 /*
  * Encode and decode owner handle
  */
-static inline __be32 *
-nlm_decode_oh(__be32 *p, struct xdr_netobj *oh)
-{
-	return xdr_decode_netobj(p, oh);
-}
-
 static inline __be32 *
 nlm_encode_oh(__be32 *p, struct xdr_netobj *oh)
 {
@@ -339,35 +288,42 @@ nlmsvc_decode_reboot(struct svc_rqst *rqstp, __be32 *p)
 	return 1;
 }
 
-int
-nlmsvc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
-{
-	struct nlm_res *resp = rqstp->rq_resp;
-
-	if (!(p = nlm_encode_testres(p, resp)))
-		return 0;
-	return xdr_ressize_check(rqstp, p);
-}
-
 int
 nlmsvc_decode_shareargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nlm_args *argp = rqstp->rq_argp;
 	struct nlm_lock	*lock = &argp->lock;
 
 	memset(lock, 0, sizeof(*lock));
 	locks_init_lock(&lock->fl);
-	lock->svid = ~(u32) 0;
+	lock->svid = ~(u32)0;
 
-	if (!(p = nlm_decode_cookie(p, &argp->cookie))
-	 || !(p = xdr_decode_string_inplace(p, &lock->caller,
-					    &lock->len, NLM_MAXSTRLEN))
-	 || !(p = nlm_decode_fh(p, &lock->fh))
-	 || !(p = nlm_decode_oh(p, &lock->oh)))
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
+nlmsvc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
+{
+	struct nlm_res *resp = rqstp->rq_resp;
+
+	if (!(p = nlm_encode_testres(p, resp)))
+		return 0;
+	return xdr_ressize_check(rqstp, p);
 }
 
 int
-- 
2.43.0



