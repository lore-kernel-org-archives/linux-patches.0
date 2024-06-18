Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8833815F300;
	Tue, 18 Jun 2024 12:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714979; cv=none; b=LIjstn2AdLyXVJINZcsWDR9QyZFcOPu8tyNfWZysl6kChrlIU5AX9a0CgS+XImcYRRfcwtTjIzxRSpY0vA/V46ZKEDXiqKedoe9HIcGWfRdcfxB13wad0kkGW5x3tEmbn5EtvUkPfi91b2E78sKDG+PVEcGfpUcb6tYXlEpQtko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714979; c=relaxed/simple;
	bh=UUAtUXfduLeaK9p/FqF96o+tPlfAI4cb+cIVOJ/+abE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=taKbqOyKmPb3aH9dhtci6Mz1JS+FeVLbl8gNQxzzbIAItCqCIjgYUXLCiWCqlD4xUhqKkSllLt4+Vll0IGaRIiAwM8SPaAHV/oWIcaCuTYF2Dga+Ca0XBJlL3G4XHfdwz/klxqyCnhh+rMhPT851rrR7l/cTjvQnU6j1s5f64Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zshyt7Ws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zshyt7Ws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094DCC3277B;
	Tue, 18 Jun 2024 12:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714979;
	bh=UUAtUXfduLeaK9p/FqF96o+tPlfAI4cb+cIVOJ/+abE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zshyt7Ws2P2ppRoP6ZQ9fYp4ialO0MBH57gomP7RyhgfEMvC0QqXnl7qNfiNvSyiH
	 FKTXYtxZpEm3mAyzODA2vkbbdsI5NnYR4jCdAwYMIz9UwHL3YLRRng6JtrJJyV4A3r
	 Uw4v0kE2KrqB/X0Uf279UCUhywgVG5CcfU3LdFUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 154/770] NFSD: Update the NFSv2 READ argument decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:07 +0200
Message-ID: <20240618123413.220975532@linuxfoundation.org>
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

[ Upstream commit 8c293ef993c8df0b1bea9ecb0de6eb96dec3ac9d ]

The code that sets up rq_vec is refactored so that it is now
adjacent to the nfsd_read() call site where it is used.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsproc.c | 32 ++++++++++++++++++--------------
 fs/nfsd/nfsxdr.c  | 36 ++++++++++++------------------------
 fs/nfsd/xdr.h     |  1 -
 3 files changed, 30 insertions(+), 39 deletions(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 3cac9972aa83f..c70ae20e54c49 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -171,32 +171,36 @@ nfsd_proc_read(struct svc_rqst *rqstp)
 {
 	struct nfsd_readargs *argp = rqstp->rq_argp;
 	struct nfsd_readres *resp = rqstp->rq_resp;
+	unsigned int len;
 	u32 eof;
+	int v;
 
 	dprintk("nfsd: READ    %s %d bytes at %d\n",
 		SVCFH_fmt(&argp->fh),
 		argp->count, argp->offset);
 
+	argp->count = min_t(u32, argp->count, NFSSVC_MAXBLKSIZE_V2);
+
+	v = 0;
+	len = argp->count;
+	while (len > 0) {
+		struct page *page = *(rqstp->rq_next_page++);
+
+		rqstp->rq_vec[v].iov_base = page_address(page);
+		rqstp->rq_vec[v].iov_len = min_t(unsigned int, len, PAGE_SIZE);
+		len -= rqstp->rq_vec[v].iov_len;
+		v++;
+	}
+
 	/* Obtain buffer pointer for payload. 19 is 1 word for
 	 * status, 17 words for fattr, and 1 word for the byte count.
 	 */
-
-	if (NFSSVC_MAXBLKSIZE_V2 < argp->count) {
-		char buf[RPC_MAX_ADDRBUFLEN];
-		printk(KERN_NOTICE
-			"oversized read request from %s (%d bytes)\n",
-				svc_print_addr(rqstp, buf, sizeof(buf)),
-				argp->count);
-		argp->count = NFSSVC_MAXBLKSIZE_V2;
-	}
 	svc_reserve_auth(rqstp, (19<<2) + argp->count + 4);
 
 	resp->count = argp->count;
-	resp->status = nfsd_read(rqstp, fh_copy(&resp->fh, &argp->fh),
-				 argp->offset,
-				 rqstp->rq_vec, argp->vlen,
-				 &resp->count,
-				 &eof);
+	fh_copy(&resp->fh, &argp->fh);
+	resp->status = nfsd_read(rqstp, &resp->fh, argp->offset,
+				 rqstp->rq_vec, v, &resp->count, &eof);
 	if (resp->status == nfs_ok)
 		resp->status = fh_getattr(&resp->fh, &resp->stat);
 	else if (resp->status == nfserr_jukebox)
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index f3189e1be20fa..1eacaa2c13a95 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -246,33 +246,21 @@ nfssvc_decode_diropargs(struct svc_rqst *rqstp, __be32 *p)
 int
 nfssvc_decode_readargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd_readargs *args = rqstp->rq_argp;
-	unsigned int len;
-	int v;
-	p = decode_fh(p, &args->fh);
-	if (!p)
-		return 0;
+	u32 totalcount;
 
-	args->offset    = ntohl(*p++);
-	len = args->count     = ntohl(*p++);
-	p++; /* totalcount - unused */
-
-	len = min_t(unsigned int, len, NFSSVC_MAXBLKSIZE_V2);
+	if (!svcxdr_decode_fhandle(xdr, &args->fh))
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &args->offset) < 0)
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &args->count) < 0)
+		return 0;
+	/* totalcount is ignored */
+	if (xdr_stream_decode_u32(xdr, &totalcount) < 0)
+		return 0;
 
-	/* set up somewhere to store response.
-	 * We take pages, put them on reslist and include in iovec
-	 */
-	v=0;
-	while (len > 0) {
-		struct page *p = *(rqstp->rq_next_page++);
-
-		rqstp->rq_vec[v].iov_base = page_address(p);
-		rqstp->rq_vec[v].iov_len = min_t(unsigned int, len, PAGE_SIZE);
-		len -= rqstp->rq_vec[v].iov_len;
-		v++;
-	}
-	args->vlen = v;
-	return xdr_argsize_check(rqstp, p);
+	return 1;
 }
 
 int
diff --git a/fs/nfsd/xdr.h b/fs/nfsd/xdr.h
index 50466ac6200cc..7c704fa3215eb 100644
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -27,7 +27,6 @@ struct nfsd_readargs {
 	struct svc_fh		fh;
 	__u32			offset;
 	__u32			count;
-	int			vlen;
 };
 
 struct nfsd_writeargs {
-- 
2.43.0



