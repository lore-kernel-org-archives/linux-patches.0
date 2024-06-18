Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E8D15358F;
	Tue, 18 Jun 2024 12:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715197; cv=none; b=RR2kMO2vXj8QVfuxXxRp/UkzF4VHgqMWTY2Hx79YN5wKigtpIVx9TdMidjaLXPUoxYiUKrJrHQZXUx+ApS9QLG/2w70UYYox6S0FF/v40iYr/22cOCLDnvXgqLV5QefjRTyOrODXguoBUyBjKvOcKZ72guzKiPMSI4mOSOQWmXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715197; c=relaxed/simple;
	bh=EmQCaxUHSbmAvDLEL8FPVzmBbfeRD4kd8/YFT8aEPn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFMzf0RMMeWoke8AC2KRSoW2ZwvtcH+KreaQn51sG9t/yS0B8EIbtiXqRWJnKFLtKyf6+kX3HSQQPdrNpO/AqzmSE35sHIyFZPs2AVZFJETEc64k23BGi14AhWa/Dr2msjAOFunXCCfPDPqwJe5nk4lAiPRXWTVn7U7NsKNNMjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LX08Ifyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LX08Ifyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C59EC3277B;
	Tue, 18 Jun 2024 12:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715197;
	bh=EmQCaxUHSbmAvDLEL8FPVzmBbfeRD4kd8/YFT8aEPn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LX08IfykcPrECokqr17GupPpYSV0o8T9yLzvndEV674EQ/maFvJgcDDztF1ZuZ9y6
	 3TFIlSVz75s1TOjGxNGWxRzv9yTuqhGw0/NslBGbgEWgzJZVe1BBQppZsXlKaCfT4Y
	 c3sGpWO6xtX1+Fj0YB+LYdiP1+ehHrahnXcOuh5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 227/770] NFSD: Update the NFSv2 READDIR entry encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:31:20 +0200
Message-ID: <20240618123416.043541838@linuxfoundation.org>
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

[ Upstream commit f5dcccd647da513a89f3b6ca392b0c1eb050b9fc ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsproc.c | 26 +++++++++++----
 fs/nfsd/nfsxdr.c  | 81 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/nfsd/xdr.h     |  7 ++++
 3 files changed, 103 insertions(+), 11 deletions(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 23b2a900cb79d..135c0bc468bce 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -559,14 +559,27 @@ static void nfsd_init_dirlist_pages(struct svc_rqst *rqstp,
 				    struct nfsd_readdirres *resp,
 				    int count)
 {
+	struct xdr_buf *buf = &resp->dirlist;
+	struct xdr_stream *xdr = &resp->xdr;
+
 	count = min_t(u32, count, PAGE_SIZE);
 
-	/* Convert byte count to number of words (i.e. >> 2),
-	 * and reserve room for the NULL ptr & eof flag (-2 words) */
-	resp->buflen = (count >> 2) - 2;
+	memset(buf, 0, sizeof(*buf));
 
-	resp->buffer = page_address(*rqstp->rq_next_page);
+	/* Reserve room for the NULL ptr & eof flag (-2 words) */
+	buf->buflen = count - sizeof(__be32) * 2;
+	buf->pages = rqstp->rq_next_page;
 	rqstp->rq_next_page++;
+
+	/* This is xdr_init_encode(), but it assumes that
+	 * the head kvec has already been consumed. */
+	xdr_set_scratch_buffer(xdr, NULL, 0);
+	xdr->buf = buf;
+	xdr->page_ptr = buf->pages;
+	xdr->iov = NULL;
+	xdr->p = page_address(*buf->pages);
+	xdr->end = xdr->p + (PAGE_SIZE >> 2);
+	xdr->rqst = NULL;
 }
 
 /*
@@ -585,12 +598,11 @@ nfsd_proc_readdir(struct svc_rqst *rqstp)
 
 	nfsd_init_dirlist_pages(rqstp, resp, argp->count);
 
-	resp->offset = NULL;
 	resp->common.err = nfs_ok;
-	/* Read directory and encode entries on the fly */
+	resp->cookie_offset = 0;
 	offset = argp->cookie;
 	resp->status = nfsd_readdir(rqstp, &argp->fh, &offset,
-				    &resp->common, nfssvc_encode_entry);
+				    &resp->common, nfs2svc_encode_entry);
 	nfssvc_encode_nfscookie(resp, offset);
 
 	fh_put(&argp->fh);
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 9522e5c5f49db..1102d40ded03f 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -576,12 +576,13 @@ nfssvc_encode_readdirres(struct svc_rqst *rqstp, __be32 *p)
 {
 	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd_readdirres *resp = rqstp->rq_resp;
+	struct xdr_buf *dirlist = &resp->dirlist;
 
 	if (!svcxdr_encode_stat(xdr, resp->status))
 		return 0;
 	switch (resp->status) {
 	case nfs_ok:
-		xdr_write_pages(xdr, &resp->page, 0, resp->count << 2);
+		xdr_write_pages(xdr, dirlist->pages, 0, dirlist->len);
 		/* no more entries */
 		if (xdr_stream_encode_item_absent(xdr) < 0)
 			return 0;
@@ -623,14 +624,86 @@ nfssvc_encode_statfsres(struct svc_rqst *rqstp, __be32 *p)
  * @resp: readdir result context
  * @offset: offset cookie to encode
  *
+ * The buffer space for the offset cookie has already been reserved
+ * by svcxdr_encode_entry_common().
  */
 void nfssvc_encode_nfscookie(struct nfsd_readdirres *resp, u32 offset)
 {
-	if (!resp->offset)
+	__be32 cookie = cpu_to_be32(offset);
+
+	if (!resp->cookie_offset)
 		return;
 
-	*resp->offset = cpu_to_be32(offset);
-	resp->offset = NULL;
+	write_bytes_to_xdr_buf(&resp->dirlist, resp->cookie_offset, &cookie,
+			       sizeof(cookie));
+	resp->cookie_offset = 0;
+}
+
+static bool
+svcxdr_encode_entry_common(struct nfsd_readdirres *resp, const char *name,
+			   int namlen, loff_t offset, u64 ino)
+{
+	struct xdr_buf *dirlist = &resp->dirlist;
+	struct xdr_stream *xdr = &resp->xdr;
+
+	if (xdr_stream_encode_item_present(xdr) < 0)
+		return false;
+	/* fileid */
+	if (xdr_stream_encode_u32(xdr, (u32)ino) < 0)
+		return false;
+	/* name */
+	if (xdr_stream_encode_opaque(xdr, name, min(namlen, NFS2_MAXNAMLEN)) < 0)
+		return false;
+	/* cookie */
+	resp->cookie_offset = dirlist->len;
+	if (xdr_stream_encode_u32(xdr, ~0U) < 0)
+		return false;
+
+	return true;
+}
+
+/**
+ * nfs2svc_encode_entry - encode one NFSv2 READDIR entry
+ * @data: directory context
+ * @name: name of the object to be encoded
+ * @namlen: length of that name, in bytes
+ * @offset: the offset of the previous entry
+ * @ino: the fileid of this entry
+ * @d_type: unused
+ *
+ * Return values:
+ *   %0: Entry was successfully encoded.
+ *   %-EINVAL: An encoding problem occured, secondary status code in resp->common.err
+ *
+ * On exit, the following fields are updated:
+ *   - resp->xdr
+ *   - resp->common.err
+ *   - resp->cookie_offset
+ */
+int nfs2svc_encode_entry(void *data, const char *name, int namlen,
+			 loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct readdir_cd *ccd = data;
+	struct nfsd_readdirres *resp = container_of(ccd,
+						    struct nfsd_readdirres,
+						    common);
+	unsigned int starting_length = resp->dirlist.len;
+
+	/* The offset cookie for the previous entry */
+	nfssvc_encode_nfscookie(resp, offset);
+
+	if (!svcxdr_encode_entry_common(resp, name, namlen, offset, ino))
+		goto out_toosmall;
+
+	xdr_commit_encode(&resp->xdr);
+	resp->common.err = nfs_ok;
+	return 0;
+
+out_toosmall:
+	resp->cookie_offset = 0;
+	resp->common.err = nfserr_toosmall;
+	resp->dirlist.len = starting_length;
+	return -EINVAL;
 }
 
 int
diff --git a/fs/nfsd/xdr.h b/fs/nfsd/xdr.h
index d7beef2c2ed5b..a065852c9ea86 100644
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -106,15 +106,20 @@ struct nfsd_readres {
 };
 
 struct nfsd_readdirres {
+	/* Components of the reply */
 	__be32			status;
 
 	int			count;
 
+	/* Used to encode the reply's entry list */
+	struct xdr_stream	xdr;
+	struct xdr_buf		dirlist;
 	struct readdir_cd	common;
 	__be32 *		buffer;
 	int			buflen;
 	__be32 *		offset;
 	struct page		*page;
+	unsigned int		cookie_offset;
 };
 
 struct nfsd_statfsres {
@@ -159,6 +164,8 @@ int nfssvc_encode_statfsres(struct svc_rqst *, __be32 *);
 int nfssvc_encode_readdirres(struct svc_rqst *, __be32 *);
 
 void nfssvc_encode_nfscookie(struct nfsd_readdirres *resp, u32 offset);
+int nfs2svc_encode_entry(void *data, const char *name, int namlen,
+			 loff_t offset, u64 ino, unsigned int d_type);
 int nfssvc_encode_entry(void *, const char *name,
 			int namlen, loff_t offset, u64 ino, unsigned int);
 
-- 
2.43.0



