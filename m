Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA1C1607AA;
	Tue, 18 Jun 2024 13:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715722; cv=none; b=iWs0F29pd7RZ8StSHbrY2TQk6S5nCt5Fjo7H536xgCohL+y5Geau6UlfPsB9qJCHj3OFSZ8xszXVvx6IiPkUauwW+XHJcJrmZBDgZBE2IlH6yF3682SG/W08YuRwvUtI+Rh/7BicaVfzHmIxO3nFVwVo15njbVPrwUymqrV6zFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715722; c=relaxed/simple;
	bh=mmAnu0QTM/QNz4Ra+tc0wvFnLh36/80aqE+IadbZCTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8bZM9zdGgbocwsOoFBR2vGi/F3857e9grovNmCk/H9mvu9WsXiDLN52aE6MHbb2zwzNtCKxmX8QGv5TLVfxmac4PF/E+KMATKTr5NpBq5RqPlu2xlb5hqzoxzGSQlek/kUSECsKqyNhSMaOkN3n+W2acv5voJR92o9+0kRwY7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NM3jQGNs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NM3jQGNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F08C3277B;
	Tue, 18 Jun 2024 13:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715722;
	bh=mmAnu0QTM/QNz4Ra+tc0wvFnLh36/80aqE+IadbZCTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NM3jQGNsWGKNu3pxBy3yuZfkuu+yr3tzfD9uWjstbw3vBnsTQ1/68G83mnv979CG8
	 xcMzaVgfYdD1gk+C6tuN/gk7zXBAwXZkLb804gKTM+8Cl1zWbK+mHXwMpj6l1eyrv6
	 Dpj0G0E2NgnC+gjd/U8LTjxnD545Y1XhDwlVxx50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anatoly Trosinenko <anatoly.trosinenko@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 404/770] NFSD: Fix READDIR buffer overflow
Date: Tue, 18 Jun 2024 14:34:17 +0200
Message-ID: <20240618123422.877449235@linuxfoundation.org>
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

[ Upstream commit 53b1119a6e5028b125f431a0116ba73510d82a72 ]

If a client sends a READDIR count argument that is too small (say,
zero), then the buffer size calculation in the new init_dirlist
helper functions results in an underflow, allowing the XDR stream
functions to write beyond the actual buffer.

This calculation has always been suspect. NFSD has never sanity-
checked the READDIR count argument, but the old entry encoders
managed the problem correctly.

With the commits below, entry encoding changed, exposing the
underflow to the pointer arithmetic in xdr_reserve_space().

Modern NFS clients attempt to retrieve as much data as possible
for each READDIR request. Also, we have no unit tests that
exercise the behavior of READDIR at the lower bound of @count
values. Thus this case was missed during testing.

Reported-by: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Fixes: f5dcccd647da ("NFSD: Update the NFSv2 READDIR entry encoder to use struct xdr_stream")
Fixes: 7f87fc2d34d4 ("NFSD: Update NFSv3 READDIR entry encoders to use struct xdr_stream")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c | 11 ++++-------
 fs/nfsd/nfsproc.c  |  8 ++++----
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 5abb5c8e2cd21..d26271c60ab44 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -443,22 +443,19 @@ nfsd3_proc_link(struct svc_rqst *rqstp)
 
 static void nfsd3_init_dirlist_pages(struct svc_rqst *rqstp,
 				     struct nfsd3_readdirres *resp,
-				     int count)
+				     u32 count)
 {
 	struct xdr_buf *buf = &resp->dirlist;
 	struct xdr_stream *xdr = &resp->xdr;
 
-	count = min_t(u32, count, svc_max_payload(rqstp));
+	count = clamp(count, (u32)(XDR_UNIT * 2), svc_max_payload(rqstp));
 
 	memset(buf, 0, sizeof(*buf));
 
 	/* Reserve room for the NULL ptr & eof flag (-2 words) */
 	buf->buflen = count - XDR_UNIT * 2;
 	buf->pages = rqstp->rq_next_page;
-	while (count > 0) {
-		rqstp->rq_next_page++;
-		count -= PAGE_SIZE;
-	}
+	rqstp->rq_next_page += (buf->buflen + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	/* This is xdr_init_encode(), but it assumes that
 	 * the head kvec has already been consumed. */
@@ -467,7 +464,7 @@ static void nfsd3_init_dirlist_pages(struct svc_rqst *rqstp,
 	xdr->page_ptr = buf->pages;
 	xdr->iov = NULL;
 	xdr->p = page_address(*buf->pages);
-	xdr->end = xdr->p + (PAGE_SIZE >> 2);
+	xdr->end = (void *)xdr->p + min_t(u32, buf->buflen, PAGE_SIZE);
 	xdr->rqst = NULL;
 }
 
diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 5a84aed17e705..8ee329bc3815d 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -556,17 +556,17 @@ nfsd_proc_rmdir(struct svc_rqst *rqstp)
 
 static void nfsd_init_dirlist_pages(struct svc_rqst *rqstp,
 				    struct nfsd_readdirres *resp,
-				    int count)
+				    u32 count)
 {
 	struct xdr_buf *buf = &resp->dirlist;
 	struct xdr_stream *xdr = &resp->xdr;
 
-	count = min_t(u32, count, PAGE_SIZE);
+	count = clamp(count, (u32)(XDR_UNIT * 2), svc_max_payload(rqstp));
 
 	memset(buf, 0, sizeof(*buf));
 
 	/* Reserve room for the NULL ptr & eof flag (-2 words) */
-	buf->buflen = count - sizeof(__be32) * 2;
+	buf->buflen = count - XDR_UNIT * 2;
 	buf->pages = rqstp->rq_next_page;
 	rqstp->rq_next_page++;
 
@@ -577,7 +577,7 @@ static void nfsd_init_dirlist_pages(struct svc_rqst *rqstp,
 	xdr->page_ptr = buf->pages;
 	xdr->iov = NULL;
 	xdr->p = page_address(*buf->pages);
-	xdr->end = xdr->p + (PAGE_SIZE >> 2);
+	xdr->end = (void *)xdr->p + min_t(u32, buf->buflen, PAGE_SIZE);
 	xdr->rqst = NULL;
 }
 
-- 
2.43.0



