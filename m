Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C039F15381A;
	Tue, 18 Jun 2024 12:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715250; cv=none; b=eRwZWXe02o7giz71lK4+Z4KmGqUPHm5khRcje8Q9xOZ8HkQgQYg9j1v3j8qHagB6SIKQIKvP9ZlsImL7duqpZOla6lyWyF3jI/RQQC7yNx4OFlNp+eVfpoqLrKQETJ+0hWAtxhjQ7iF4gdJq9RD6SataMVcEFJuhXsCkbu+n6aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715250; c=relaxed/simple;
	bh=Lq/2J6q8iFfNFQpU8mDvgBe6jP4ySgXNr5jcPV8ybQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbxFf334/uom1tRmiAnOHpS840PXbS70r5twtBxqSDOd3v+vrAQDc2oVeLssO/OmbdcGDMWNONxgfOnpSVUxfC3pCZ4EbuvdgpVnDoFc8pIBre209h5Vc3sUyBqbglg6TdI5IGfUCwvv3cSrVFwgttt/GF20fmWg1tUBQySe3gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmtAjkTT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmtAjkTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4880DC3277B;
	Tue, 18 Jun 2024 12:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715250;
	bh=Lq/2J6q8iFfNFQpU8mDvgBe6jP4ySgXNr5jcPV8ybQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UmtAjkTTE9x0fPOkSgfugnZin6qScIAGheJXfkFr//O0l6FeuaoTWSQAMLcPz26sL
	 4/GebD6u5e0aaLFONmJaDVbHmazW0YxTng1B5kG/1pO4e8rfPC3ECMe0SUxqLYGAmF
	 LoXEMrvkHenbQaj1RQLF3tMJbMLfFGvYsRJR0ZdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 214/770] NFSD: Update the NFSv3 READDIR3res encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:31:07 +0200
Message-ID: <20240618123415.535416367@linuxfoundation.org>
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

[ Upstream commit e4ccfe3014de435984939a3d84b7f241d3b57b0d ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c |  3 ++-
 fs/nfsd/nfs3xdr.c  | 54 ++++++++++++++++++++++++++++++----------------
 fs/nfsd/xdr3.h     |  1 +
 3 files changed, 38 insertions(+), 20 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 7dcc7abb1f346..9e8481242dea8 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -452,7 +452,8 @@ static void nfsd3_init_dirlist_pages(struct svc_rqst *rqstp,
 	 * and reserve room for the NULL ptr & eof flag (-2 words) */
 	resp->buflen = (count >> 2) - 2;
 
-	resp->buffer = page_address(*rqstp->rq_next_page);
+	resp->pages = rqstp->rq_next_page;
+	resp->buffer = page_address(*resp->pages);
 	while (count > 0) {
 		rqstp->rq_next_page++;
 		count -= PAGE_SIZE;
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 523b2dca04944..3d076d3c5c7b8 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -158,6 +158,19 @@ encode_fh(__be32 *p, struct svc_fh *fhp)
 	return p + XDR_QUADLEN(size);
 }
 
+static bool
+svcxdr_encode_cookieverf3(struct xdr_stream *xdr, const __be32 *verf)
+{
+	__be32 *p;
+
+	p = xdr_reserve_space(xdr, NFS3_COOKIEVERFSIZE);
+	if (!p)
+		return false;
+	memcpy(p, verf, NFS3_COOKIEVERFSIZE);
+
+	return true;
+}
+
 static bool
 svcxdr_encode_writeverf3(struct xdr_stream *xdr, const __be32 *verf)
 {
@@ -1124,27 +1137,30 @@ nfs3svc_encode_linkres(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_encode_readdirres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd3_readdirres *resp = rqstp->rq_resp;
 
-	*p++ = resp->status;
-	p = encode_post_op_attr(rqstp, p, &resp->fh);
-
-	if (resp->status == 0) {
-		/* stupid readdir cookie */
-		memcpy(p, resp->verf, 8); p += 2;
-		xdr_ressize_check(rqstp, p);
-		if (rqstp->rq_res.head[0].iov_len + (2<<2) > PAGE_SIZE)
-			return 1; /*No room for trailer */
-		rqstp->rq_res.page_len = (resp->count) << 2;
-
-		/* add the 'tail' to the end of the 'head' page - page 0. */
-		rqstp->rq_res.tail[0].iov_base = p;
-		*p++ = 0;		/* no more entries */
-		*p++ = htonl(resp->common.err == nfserr_eof);
-		rqstp->rq_res.tail[0].iov_len = 2<<2;
-		return 1;
-	} else
-		return xdr_ressize_check(rqstp, p);
+	if (!svcxdr_encode_nfsstat3(xdr, resp->status))
+		return 0;
+	switch (resp->status) {
+	case nfs_ok:
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &resp->fh))
+			return 0;
+		if (!svcxdr_encode_cookieverf3(xdr, resp->verf))
+			return 0;
+		xdr_write_pages(xdr, resp->pages, 0, resp->count << 2);
+		/* no more entries */
+		if (xdr_stream_encode_item_absent(xdr) < 0)
+			return 0;
+		if (xdr_stream_encode_bool(xdr, resp->common.err == nfserr_eof) < 0)
+			return 0;
+		break;
+	default:
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &resp->fh))
+			return 0;
+	}
+
+	return 1;
 }
 
 static __be32 *
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index e76e9230827e4..a4cdd8ccb175a 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -176,6 +176,7 @@ struct nfsd3_readdirres {
 	struct svc_fh		scratch;
 	int			count;
 	__be32			verf[2];
+	struct page		**pages;
 
 	struct readdir_cd	common;
 	__be32 *		buffer;
-- 
2.43.0



