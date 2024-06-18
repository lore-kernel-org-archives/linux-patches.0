Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB5715381A;
	Tue, 18 Jun 2024 12:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715247; cv=none; b=Bv5ZZozwnE3m9ioVKezDeZycbJMyPORkNYAK+GvrYeXKU3sYw4UCasTbAvADCE/6IZsQY96Knl2ziJj3vFJf8dca/73OZTMa/15K7+MtGObx4MODMbHkQSnFREezJLKc7VHfgbBOAsGoXYsl0B2jYUr3US5VJ4U8jKU7ke8RB6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715247; c=relaxed/simple;
	bh=MfJUw5FUsZZ/bQ/cPYNFmehQg8eGmz0sCUJnzuyF9Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acV6En4rDbds+AbJ69s22jN8wZ2MVVFHL+vrXsL6tKng8oBI8NeXTjbdxjLTIBOpVqcZc4VRb8qFMIyA5M/kNGUwqg73OI+H1k5Z2j48YlHhQtfM99NoutK0t89l1jqXenw+K08NYOhOeaNwTbu8OD+b4EKGGIL199WrGHhn6Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbvSPPB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbvSPPB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C24C32786;
	Tue, 18 Jun 2024 12:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715247;
	bh=MfJUw5FUsZZ/bQ/cPYNFmehQg8eGmz0sCUJnzuyF9Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XbvSPPB4OFflncMiqzbrDL2hTYATSR4PHSOayf9+HWls/xVmhMsFN14c068MIiBdi
	 iMk1gBiqVAyaFwDII4FVL2RiAyWWePeQ77sBd/UWIW+htBiTz+TKVDbh9R5WBibavv
	 mbwTJDC1Ji1BHWIrWFmWcYivcg9we+TfcIdGbQ9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 213/770] NFSD: Count bytes instead of pages in the NFSv3 READDIR encoder
Date: Tue, 18 Jun 2024 14:31:06 +0200
Message-ID: <20240618123415.496236119@linuxfoundation.org>
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

[ Upstream commit a1409e2de4f11034c8eb30775cc3e37039a4ef13 ]

Clean up: Counting the bytes used by each returned directory entry
seems less brittle to me than trying to measure consumed pages after
the fact.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c | 31 ++-----------------------------
 fs/nfsd/nfs3xdr.c  |  1 +
 2 files changed, 3 insertions(+), 29 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index acb0a2d37dcbb..7dcc7abb1f346 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -467,10 +467,7 @@ nfsd3_proc_readdir(struct svc_rqst *rqstp)
 {
 	struct nfsd3_readdirargs *argp = rqstp->rq_argp;
 	struct nfsd3_readdirres  *resp = rqstp->rq_resp;
-	int		count = 0;
 	loff_t		offset;
-	struct page	**p;
-	caddr_t		page_addr = NULL;
 
 	dprintk("nfsd: READDIR(3)  %s %d bytes at %d\n",
 				SVCFH_fmt(&argp->fh),
@@ -481,6 +478,7 @@ nfsd3_proc_readdir(struct svc_rqst *rqstp)
 	/* Read directory and encode entries on the fly */
 	fh_copy(&resp->fh, &argp->fh);
 
+	resp->count = 0;
 	resp->common.err = nfs_ok;
 	resp->rqstp = rqstp;
 	offset = argp->cookie;
@@ -488,18 +486,6 @@ nfsd3_proc_readdir(struct svc_rqst *rqstp)
 	resp->status = nfsd_readdir(rqstp, &resp->fh, &offset,
 				    &resp->common, nfs3svc_encode_entry);
 	memcpy(resp->verf, argp->verf, 8);
-	count = 0;
-	for (p = rqstp->rq_respages + 1; p < rqstp->rq_next_page; p++) {
-		page_addr = page_address(*p);
-
-		if (((caddr_t)resp->buffer >= page_addr) &&
-		    ((caddr_t)resp->buffer < page_addr + PAGE_SIZE)) {
-			count += (caddr_t)resp->buffer - page_addr;
-			break;
-		}
-		count += PAGE_SIZE;
-	}
-	resp->count = count >> 2;
 	nfs3svc_encode_cookie3(resp, offset);
 
 	return rpc_success;
@@ -514,10 +500,7 @@ nfsd3_proc_readdirplus(struct svc_rqst *rqstp)
 {
 	struct nfsd3_readdirargs *argp = rqstp->rq_argp;
 	struct nfsd3_readdirres  *resp = rqstp->rq_resp;
-	int	count = 0;
 	loff_t	offset;
-	struct page **p;
-	caddr_t	page_addr = NULL;
 
 	dprintk("nfsd: READDIR+(3) %s %d bytes at %d\n",
 				SVCFH_fmt(&argp->fh),
@@ -528,6 +511,7 @@ nfsd3_proc_readdirplus(struct svc_rqst *rqstp)
 	/* Read directory and encode entries on the fly */
 	fh_copy(&resp->fh, &argp->fh);
 
+	resp->count = 0;
 	resp->common.err = nfs_ok;
 	resp->rqstp = rqstp;
 	offset = argp->cookie;
@@ -544,17 +528,6 @@ nfsd3_proc_readdirplus(struct svc_rqst *rqstp)
 	resp->status = nfsd_readdir(rqstp, &resp->fh, &offset,
 				    &resp->common, nfs3svc_encode_entry_plus);
 	memcpy(resp->verf, argp->verf, 8);
-	for (p = rqstp->rq_respages + 1; p < rqstp->rq_next_page; p++) {
-		page_addr = page_address(*p);
-
-		if (((caddr_t)resp->buffer >= page_addr) &&
-		    ((caddr_t)resp->buffer < page_addr + PAGE_SIZE)) {
-			count += (caddr_t)resp->buffer - page_addr;
-			break;
-		}
-		count += PAGE_SIZE;
-	}
-	resp->count = count >> 2;
 	nfs3svc_encode_cookie3(resp, offset);
 
 out:
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index e334a1454edbb..523b2dca04944 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -1364,6 +1364,7 @@ encode_entry(struct readdir_cd *ccd, const char *name, int namlen,
 		return -EINVAL;
 	}
 
+	cd->count += num_entry_words;
 	cd->buflen -= num_entry_words;
 	cd->buffer = p;
 	cd->common.err = nfs_ok;
-- 
2.43.0



