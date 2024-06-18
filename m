Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D7913AD2F;
	Tue, 18 Jun 2024 12:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715180; cv=none; b=ISSLLYfVeZ0Uh/fOq4NQjxPaGuVXnGIsWhvp4FXL8Cqmeb+nA5r/GgH7VK5Op7cqXilASOgCFZqy+vI9L/5je1Twd+v4Byqclm/do+AvQmMrLo4GhUjYlnl098C+AoL0dt0EhqqNtRYOcVwrLTt0oN2+fTtLFsgbWhBJtOKEyjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715180; c=relaxed/simple;
	bh=lj698T7AvwXRrAh5p54o0vOisW5UN97hqBAlAVMUpAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSanziAVj77gOdZa9/hcXXRyqDCRd6TqH3d0yjzUy/XjbDubN9EGh/WlaAH6kz6XUxZXv1GDyhp5MENQrTt/PyAXTrNsgwg1+gEWjYTEBaAU0JcrRk7W/+ChqoWrBaXd1NO/BH39tNO5gKXOhjhFLUFG8xVuV4f9WXlXiUklk5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITmaLvXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITmaLvXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81060C3277B;
	Tue, 18 Jun 2024 12:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715179;
	bh=lj698T7AvwXRrAh5p54o0vOisW5UN97hqBAlAVMUpAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITmaLvXHFVd3ZU4arTw13d1b1TnimdBZJ/WyURXSH5iSrLtfrai3HgcnAiPd3YUUT
	 BLifk86aIYxDk/fGnbQXs4yuuUJNooXKyq0cLVgI8x1M9wOq65lXK6lsHIkGoSL0+Q
	 v442iMx58hAU3SVUVtQzVTsmsE77/BCzyzMBFkqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 222/770] NFSD: Update the NFSv2 READ result encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:31:15 +0200
Message-ID: <20240618123415.851391684@linuxfoundation.org>
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

[ Upstream commit a6f8d9dc9e44b51303d9abde4643460137d19b28 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsproc.c |  1 +
 fs/nfsd/nfsxdr.c  | 32 +++++++++++++++-----------------
 fs/nfsd/xdr.h     |  1 +
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index fa9a18897bc29..1fd91e00b97ba 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -185,6 +185,7 @@ nfsd_proc_read(struct svc_rqst *rqstp)
 
 	v = 0;
 	len = argp->count;
+	resp->pages = rqstp->rq_next_page;
 	while (len > 0) {
 		struct page *page = *(rqstp->rq_next_page++);
 
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 74d9d11949c6c..d6d7d07dbb1b2 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -549,27 +549,25 @@ nfssvc_encode_readlinkres(struct svc_rqst *rqstp, __be32 *p)
 int
 nfssvc_encode_readres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd_readres *resp = rqstp->rq_resp;
 	struct kvec *head = rqstp->rq_res.head;
 
-	*p++ = resp->status;
-	if (resp->status != nfs_ok)
-		return xdr_ressize_check(rqstp, p);
-
-	p = encode_fattr(rqstp, p, &resp->fh, &resp->stat);
-	*p++ = htonl(resp->count);
-	xdr_ressize_check(rqstp, p);
-
-	/* now update rqstp->rq_res to reflect data as well */
-	rqstp->rq_res.page_len = resp->count;
-	if (resp->count & 3) {
-		/* need to pad the tail */
-		rqstp->rq_res.tail[0].iov_base = p;
-		*p = 0;
-		rqstp->rq_res.tail[0].iov_len = 4 - (resp->count&3);
-	}
-	if (svc_encode_result_payload(rqstp, head->iov_len, resp->count))
+	if (!svcxdr_encode_stat(xdr, resp->status))
 		return 0;
+	switch (resp->status) {
+	case nfs_ok:
+		if (!svcxdr_encode_fattr(rqstp, xdr, &resp->fh, &resp->stat))
+			return 0;
+		if (xdr_stream_encode_u32(xdr, resp->count) < 0)
+			return 0;
+		xdr_write_pages(xdr, resp->pages, rqstp->rq_res.page_base,
+				resp->count);
+		if (svc_encode_result_payload(rqstp, head->iov_len, resp->count) < 0)
+			return 0;
+		break;
+	}
+
 	return 1;
 }
 
diff --git a/fs/nfsd/xdr.h b/fs/nfsd/xdr.h
index b17fd72c69a6a..337c581e15b4c 100644
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -102,6 +102,7 @@ struct nfsd_readres {
 	struct svc_fh		fh;
 	unsigned long		count;
 	struct kstat		stat;
+	struct page		**pages;
 };
 
 struct nfsd_readdirres {
-- 
2.43.0



