Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519AF15FA69;
	Tue, 18 Jun 2024 12:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715041; cv=none; b=Ujdmn2NPtVQGEdBt+uQJzv7A0XEJgXjfXo985qvVBP4mOmgGX+TIEFLUKm17AhH1oZqoe7HBICxUEiluNY6GT0vXNuILnWYoMdn9PP9j9gSMDCYr/N8m/7KE17x4VSasy7o/Gf4VCcf9SwgBk9atdzwy2a35wUha7pseZK8TNYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715041; c=relaxed/simple;
	bh=PlOIIQ0MbjnyU8KQOPFy3cjFntQXO3nuIv7eVaQnka8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDgtRCpxnP5iGtuo0MJnOCNSYKN/lFZcjDZTq2+0p+ozxq8NKO1thefGY8XHNEqtTA9HFB3XK4QVpSe+qtf5bS+kX1QR2bq6gimhaaWXo5oWVNyfHZTRiXX3NIKIhxOxo+P60295quIPPv9gWYshB//Wg+dB+VNSOu1gA6mqisI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bDV+DfU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDV+DfU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF30CC3277B;
	Tue, 18 Jun 2024 12:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715041;
	bh=PlOIIQ0MbjnyU8KQOPFy3cjFntQXO3nuIv7eVaQnka8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDV+DfU5zbfzbnEVhvwssSWUDwcEtzaiFt4YBsxa0bSjji7u/oL9FaELgQEBJbnU9
	 Z+S3kV7maLukJ8S+OlTUzf5NQMi6Z2nWkLWNQyE/xYurd8AtVcA1v2UE2leqx8pWqL
	 7TOJrLApl+aqVdp35+Xr/f2rztXKnwi/xEvcdW7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 142/770] NFSD: Add helper to set up the pages where the dirlist is encoded
Date: Tue, 18 Jun 2024 14:29:55 +0200
Message-ID: <20240618123412.759169402@linuxfoundation.org>
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

[ Upstream commit 40116ebd0934cca7e46423bdb3397d3d27eb9fb9 ]

De-duplicate some code that is used by both READDIR and READDIRPLUS
to build the dirlist in the Reply. Because this code is not related
to decoding READ arguments, it is moved to a more appropriate spot.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c | 29 +++++++++++++++++++----------
 fs/nfsd/nfs3xdr.c  | 20 --------------------
 fs/nfsd/xdr3.h     |  1 -
 3 files changed, 19 insertions(+), 31 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 8cffd9852ef04..25f31a03c4f1b 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -440,6 +440,23 @@ nfsd3_proc_link(struct svc_rqst *rqstp)
 	return rpc_success;
 }
 
+static void nfsd3_init_dirlist_pages(struct svc_rqst *rqstp,
+				     struct nfsd3_readdirres *resp,
+				     int count)
+{
+	count = min_t(u32, count, svc_max_payload(rqstp));
+
+	/* Convert byte count to number of words (i.e. >> 2),
+	 * and reserve room for the NULL ptr & eof flag (-2 words) */
+	resp->buflen = (count >> 2) - 2;
+
+	resp->buffer = page_address(*rqstp->rq_next_page);
+	while (count > 0) {
+		rqstp->rq_next_page++;
+		count -= PAGE_SIZE;
+	}
+}
+
 /*
  * Read a portion of a directory.
  */
@@ -457,16 +474,12 @@ nfsd3_proc_readdir(struct svc_rqst *rqstp)
 				SVCFH_fmt(&argp->fh),
 				argp->count, (u32) argp->cookie);
 
-	/* Make sure we've room for the NULL ptr & eof flag, and shrink to
-	 * client read size */
-	count = (argp->count >> 2) - 2;
+	nfsd3_init_dirlist_pages(rqstp, resp, argp->count);
 
 	/* Read directory and encode entries on the fly */
 	fh_copy(&resp->fh, &argp->fh);
 
-	resp->buflen = count;
 	resp->common.err = nfs_ok;
-	resp->buffer = argp->buffer;
 	resp->rqstp = rqstp;
 	offset = argp->cookie;
 
@@ -518,16 +531,12 @@ nfsd3_proc_readdirplus(struct svc_rqst *rqstp)
 				SVCFH_fmt(&argp->fh),
 				argp->count, (u32) argp->cookie);
 
-	/* Convert byte count to number of words (i.e. >> 2),
-	 * and reserve room for the NULL ptr & eof flag (-2 words) */
-	resp->count = (argp->count >> 2) - 2;
+	nfsd3_init_dirlist_pages(rqstp, resp, argp->count);
 
 	/* Read directory and encode entries on the fly */
 	fh_copy(&resp->fh, &argp->fh);
 
 	resp->common.err = nfs_ok;
-	resp->buffer = argp->buffer;
-	resp->buflen = resp->count;
 	resp->rqstp = rqstp;
 	offset = argp->cookie;
 
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 6b6a839c1fc8c..8394aeb8381e6 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -560,8 +560,6 @@ int
 nfs3svc_decode_readdirargs(struct svc_rqst *rqstp, __be32 *p)
 {
 	struct nfsd3_readdirargs *args = rqstp->rq_argp;
-	int len;
-	u32 max_blocksize = svc_max_payload(rqstp);
 
 	p = decode_fh(p, &args->fh);
 	if (!p)
@@ -570,14 +568,6 @@ nfs3svc_decode_readdirargs(struct svc_rqst *rqstp, __be32 *p)
 	args->verf   = p; p += 2;
 	args->dircount = ~0;
 	args->count  = ntohl(*p++);
-	len = args->count  = min_t(u32, args->count, max_blocksize);
-
-	while (len > 0) {
-		struct page *p = *(rqstp->rq_next_page++);
-		if (!args->buffer)
-			args->buffer = page_address(p);
-		len -= PAGE_SIZE;
-	}
 
 	return xdr_argsize_check(rqstp, p);
 }
@@ -586,8 +576,6 @@ int
 nfs3svc_decode_readdirplusargs(struct svc_rqst *rqstp, __be32 *p)
 {
 	struct nfsd3_readdirargs *args = rqstp->rq_argp;
-	int len;
-	u32 max_blocksize = svc_max_payload(rqstp);
 
 	p = decode_fh(p, &args->fh);
 	if (!p)
@@ -597,14 +585,6 @@ nfs3svc_decode_readdirplusargs(struct svc_rqst *rqstp, __be32 *p)
 	args->dircount = ntohl(*p++);
 	args->count    = ntohl(*p++);
 
-	len = args->count = min(args->count, max_blocksize);
-	while (len > 0) {
-		struct page *p = *(rqstp->rq_next_page++);
-		if (!args->buffer)
-			args->buffer = page_address(p);
-		len -= PAGE_SIZE;
-	}
-
 	return xdr_argsize_check(rqstp, p);
 }
 
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index 08f909142ddf7..789a364d5e69d 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -93,7 +93,6 @@ struct nfsd3_readdirargs {
 	__u32			dircount;
 	__u32			count;
 	__be32 *		verf;
-	__be32 *		buffer;
 };
 
 struct nfsd3_commitargs {
-- 
2.43.0



