Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3CD44C649;
	Thu, 30 Jul 2026 16:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428277; cv=none; b=tEeJet28ygsvd0geFyTmouPqBFBrqxz/tggu+bBpsxoGOBDaLhvbMkM4HxZLPnNqx2XbV3mxzCZA2wwHEfMoCfn5CJGFz9xTRDOXo5I1A+wqXKhsT8KuQnVIHRasx+wXK70EyzBsX6OX2pTMZRqVtJZ4eVX4JXmZsEcNVe4WoSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428277; c=relaxed/simple;
	bh=FXsslTKsTpr5/mXsSgCb7R+w7FUX2BKdSUF8SK83ozs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4XQEjsFL2DGKq6v9Vfwqz3kMZiriyIi4+K0hk5VPUCqDR1gWQw0tcLloYG6f7uIKvginMfxn05/fdpEVPTzCJwKkOGv+RlVUzWgim2biK2AFj5Dtjl6tleWXgBZqkjNnFTvd60jOqGLG5+of+LpLb7Duon7ARleW1EMTAW8BIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1AhpcqE2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1AhpcqE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB94F1F000E9;
	Thu, 30 Jul 2026 16:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428276;
	bh=c905OAQt8mSTxiI9MeZhA89Rn4vZfV3xpcChUamAaxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1AhpcqE2Pl2bAftF5KW/eepKEtprGxUpQkC6W/Bhw5aOxomspBrd3MEFPZks61pWo
	 NS+H2zNtEcFDZXOjmuPd7cFXL5muADpy8bDxRvU+7H821NuOc4mfLd9mX24hpJdOly
	 7AnWQtImXy6J83dAjftt2Q62ODq8xGCQ6FUkoFwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 420/484] NFSD: pass nfsd_file to nfsd_iter_read()
Date: Thu, 30 Jul 2026 16:15:17 +0200
Message-ID: <20260730141432.602538655@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 803bc849f0039291f546ba0e2237faebeb5c073e ]

Prepare for nfsd_iter_read() to use the DIO alignment stored in
nfsd_file by passing the nfsd_file to nfsd_iter_read() rather than
just the file which is associaed with the nfsd_file.

This means nfsd4_encode_readv() now also needs the nfsd_file rather
than the file.  Instead of changing the file arg to be the nfsd_file,
we discard the file arg as the nfsd_file (and indeed the file) is
already available via the "read" argument.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 18c1cc698861 ("SUNRPC: Return an error from xdr_buf_to_bvec() on overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |    8 ++++----
 fs/nfsd/vfs.c     |    7 ++++---
 fs/nfsd/vfs.h     |    2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -4096,7 +4096,7 @@ out_err:
 
 static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
 				 struct nfsd4_read *read,
-				 struct file *file, unsigned long maxcount)
+				 unsigned long maxcount)
 {
 	struct xdr_stream *xdr = resp->xdr;
 	unsigned int base = xdr->buf->page_len & ~PAGE_MASK;
@@ -4107,7 +4107,7 @@ static __be32 nfsd4_encode_readv(struct
 	if (xdr_reserve_space_vec(xdr, maxcount) < 0)
 		return nfserr_resource;
 
-	nfserr = nfsd_iter_read(resp->rqstp, read->rd_fhp, file,
+	nfserr = nfsd_iter_read(resp->rqstp, read->rd_fhp, read->rd_nf,
 				read->rd_offset, &maxcount, base,
 				&read->rd_eof);
 	read->rd_length = maxcount;
@@ -4155,7 +4155,7 @@ nfsd4_encode_read(struct nfsd4_compoundr
 	if (file->f_op->splice_read && splice_ok)
 		nfserr = nfsd4_encode_splice_read(resp, read, file, maxcount);
 	else
-		nfserr = nfsd4_encode_readv(resp, read, file, maxcount);
+		nfserr = nfsd4_encode_readv(resp, read, maxcount);
 	if (nfserr) {
 		xdr_truncate_encode(xdr, starting_len);
 		return nfserr;
@@ -4906,7 +4906,7 @@ nfsd4_encode_read_plus_data(struct nfsd4
 	if (file->f_op->splice_read && splice_ok)
 		nfserr = nfsd4_encode_splice_read(resp, read, file, maxcount);
 	else
-		nfserr = nfsd4_encode_readv(resp, read, file, maxcount);
+		nfserr = nfsd4_encode_readv(resp, read, maxcount);
 	if (nfserr)
 		return nfserr;
 
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1061,7 +1061,7 @@ __be32 nfsd_splice_read(struct svc_rqst
  * nfsd_iter_read - Perform a VFS read using an iterator
  * @rqstp: RPC transaction context
  * @fhp: file handle of file to be read
- * @file: opened struct file of file to be read
+ * @nf: opened struct nfsd_file of file to be read
  * @offset: starting byte offset
  * @count: IN: requested number of bytes; OUT: number of bytes read
  * @base: offset in first page of read buffer
@@ -1074,9 +1074,10 @@ __be32 nfsd_splice_read(struct svc_rqst
  * returned.
  */
 __be32 nfsd_iter_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
-		      struct file *file, loff_t offset, unsigned long *count,
+		      struct nfsd_file *nf, loff_t offset, unsigned long *count,
 		      unsigned int base, u32 *eof)
 {
+	struct file *file = nf->nf_file;
 	unsigned long v, total;
 	struct iov_iter iter;
 	loff_t ppos = offset;
@@ -1258,7 +1259,7 @@ __be32 nfsd_read(struct svc_rqst *rqstp,
 	if (file->f_op->splice_read && test_bit(RQ_SPLICE_OK, &rqstp->rq_flags))
 		err = nfsd_splice_read(rqstp, fhp, file, offset, count, eof);
 	else
-		err = nfsd_iter_read(rqstp, fhp, file, offset, count, 0, eof);
+		err = nfsd_iter_read(rqstp, fhp, nf, offset, count, 0, eof);
 
 	nfsd_file_put(nf);
 	trace_nfsd_read_done(rqstp, fhp, offset, *count);
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -120,7 +120,7 @@ __be32		nfsd_splice_read(struct svc_rqst
 				unsigned long *count,
 				u32 *eof);
 __be32		nfsd_iter_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
-				struct file *file, loff_t offset,
+				struct nfsd_file *nf, loff_t offset,
 				unsigned long *count, unsigned int base,
 				u32 *eof);
 __be32		nfsd_read(struct svc_rqst *rqstp, struct svc_fh *fhp,


