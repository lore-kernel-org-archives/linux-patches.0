Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1680A1A3029;
	Tue, 21 Oct 2025 20:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077003; cv=none; b=NrQRyZDBptuTmGWGVaiLSFVdWQB84imnrlGqTnNN27oxj6cpruEWUnAwIIam5SIUMLr49i0m5G36bP2sEft+nxsvBxonOZENDkoQj7uOUlBNkV7uAgS9ip3Vaf0heRRjewZN8twuv6iIuehxBOoYwrDXUbvIi7EQE/I/hTmdC9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077003; c=relaxed/simple;
	bh=GcC7zowU+ZaCR5VSVFaXKl001hTLcDYI7PGlOHt+FKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acqobPcis/288gYIhd8CgPMyND5Ert4tmY/OvgOaPD6pejzppghW1Bfo08xH1vYJZHlsFFFvvwTXZwiG6kB6rwphTN2xhUefhp+iXgZS5OtwYIF6GPYg3U0N0T5oNHtZW+QnxAVDAJgairkiz8M4CAN4/92P2yis1kx6vnsY5tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSgDXFX7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSgDXFX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D706C4CEF1;
	Tue, 21 Oct 2025 20:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077002;
	bh=GcC7zowU+ZaCR5VSVFaXKl001hTLcDYI7PGlOHt+FKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSgDXFX7vWayEvJPuKNK3Fn+617rq20RptB0fnvMYPUSERUhP2VVuYFjnO1jcSzaZ
	 C4+oPbN2T1zuTfWo8sr32sPiGZiovKztidwQY813O+bDBp1LO0FZdXPi5hyu/HPYLQ
	 cWKuCTpnudAGaVVfosUY2fu7SWXjpOWa2XoLEBqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Evtushenko <koevtushenko@yandex.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/136] NFSD: Implement large extent array support in pNFS
Date: Tue, 21 Oct 2025 21:51:34 +0200
Message-ID: <20251021195038.512166247@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Bashirov <sergeybashirov@gmail.com>

[ Upstream commit f963cf2b91a30b5614c514f3ad53ca124cb65280 ]

When pNFS client in the block or scsi layout mode sends layoutcommit
to MDS, a variable length array of modified extents is supplied within
the request. This patch allows the server to accept such extent arrays
if they do not fit within single memory page.

The issue can be reproduced when writing to a 1GB file using FIO with
O_DIRECT, 4K block and large I/O depth without preallocation of the
file. In this case, the server returns NFSERR_BADXDR to the client.

Co-developed-by: Konstantin Evtushenko <koevtushenko@yandex.com>
Signed-off-by: Konstantin Evtushenko <koevtushenko@yandex.com>
Signed-off-by: Sergey Bashirov <sergeybashirov@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: d68886bae76a ("NFSD: Fix last write offset handling in layoutcommit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/blocklayout.c    |   20 ++++++-----
 fs/nfsd/blocklayoutxdr.c |   83 +++++++++++++++++++++++++++++++----------------
 fs/nfsd/blocklayoutxdr.h |    4 +-
 fs/nfsd/nfs4proc.c       |    2 -
 fs/nfsd/nfs4xdr.c        |   11 ++----
 fs/nfsd/pnfs.h           |    1 
 fs/nfsd/xdr4.h           |    3 -
 7 files changed, 78 insertions(+), 46 deletions(-)

--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -173,16 +173,18 @@ nfsd4_block_proc_getdeviceinfo(struct su
 }
 
 static __be32
-nfsd4_block_proc_layoutcommit(struct inode *inode,
+nfsd4_block_proc_layoutcommit(struct inode *inode, struct svc_rqst *rqstp,
 		struct nfsd4_layoutcommit *lcp)
 {
 	struct iomap *iomaps;
 	int nr_iomaps;
 	__be32 nfserr;
 
-	nfserr = nfsd4_block_decode_layoutupdate(lcp->lc_up_layout,
-			lcp->lc_up_len, &iomaps, &nr_iomaps,
-			i_blocksize(inode));
+	rqstp->rq_arg = lcp->lc_up_layout;
+	svcxdr_init_decode(rqstp);
+
+	nfserr = nfsd4_block_decode_layoutupdate(&rqstp->rq_arg_stream,
+			&iomaps, &nr_iomaps, i_blocksize(inode));
 	if (nfserr != nfs_ok)
 		return nfserr;
 
@@ -313,16 +315,18 @@ nfsd4_scsi_proc_getdeviceinfo(struct sup
 	return nfserrno(nfsd4_block_get_device_info_scsi(sb, clp, gdp));
 }
 static __be32
-nfsd4_scsi_proc_layoutcommit(struct inode *inode,
+nfsd4_scsi_proc_layoutcommit(struct inode *inode, struct svc_rqst *rqstp,
 		struct nfsd4_layoutcommit *lcp)
 {
 	struct iomap *iomaps;
 	int nr_iomaps;
 	__be32 nfserr;
 
-	nfserr = nfsd4_scsi_decode_layoutupdate(lcp->lc_up_layout,
-			lcp->lc_up_len, &iomaps, &nr_iomaps,
-			i_blocksize(inode));
+	rqstp->rq_arg = lcp->lc_up_layout;
+	svcxdr_init_decode(rqstp);
+
+	nfserr = nfsd4_scsi_decode_layoutupdate(&rqstp->rq_arg_stream,
+			&iomaps, &nr_iomaps, i_blocksize(inode));
 	if (nfserr != nfs_ok)
 		return nfserr;
 
--- a/fs/nfsd/blocklayoutxdr.c
+++ b/fs/nfsd/blocklayoutxdr.c
@@ -113,8 +113,7 @@ nfsd4_block_encode_getdeviceinfo(struct
 
 /**
  * nfsd4_block_decode_layoutupdate - decode the block layout extent array
- * @p: pointer to the xdr data
- * @len: number of bytes to decode
+ * @xdr: subbuf set to the encoded array
  * @iomapp: pointer to store the decoded extent array
  * @nr_iomapsp: pointer to store the number of extents
  * @block_size: alignment of extent offset and length
@@ -127,25 +126,24 @@ nfsd4_block_encode_getdeviceinfo(struct
  *
  * Return values:
  *   %nfs_ok: Successful decoding, @iomapp and @nr_iomapsp are valid
- *   %nfserr_bad_xdr: The encoded array in @p is invalid
+ *   %nfserr_bad_xdr: The encoded array in @xdr is invalid
  *   %nfserr_inval: An unaligned extent found
  *   %nfserr_delay: Failed to allocate memory for @iomapp
  */
 __be32
-nfsd4_block_decode_layoutupdate(__be32 *p, u32 len, struct iomap **iomapp,
+nfsd4_block_decode_layoutupdate(struct xdr_stream *xdr, struct iomap **iomapp,
 		int *nr_iomapsp, u32 block_size)
 {
 	struct iomap *iomaps;
-	u32 nr_iomaps, i;
+	u32 nr_iomaps, expected, len, i;
+	__be32 nfserr;
 
-	if (len < sizeof(u32))
-		return nfserr_bad_xdr;
-	len -= sizeof(u32);
-	if (len % PNFS_BLOCK_EXTENT_SIZE)
+	if (xdr_stream_decode_u32(xdr, &nr_iomaps))
 		return nfserr_bad_xdr;
 
-	nr_iomaps = be32_to_cpup(p++);
-	if (nr_iomaps != len / PNFS_BLOCK_EXTENT_SIZE)
+	len = sizeof(__be32) + xdr_stream_remaining(xdr);
+	expected = sizeof(__be32) + nr_iomaps * PNFS_BLOCK_EXTENT_SIZE;
+	if (len != expected)
 		return nfserr_bad_xdr;
 
 	iomaps = kcalloc(nr_iomaps, sizeof(*iomaps), GFP_KERNEL);
@@ -155,21 +153,44 @@ nfsd4_block_decode_layoutupdate(__be32 *
 	for (i = 0; i < nr_iomaps; i++) {
 		struct pnfs_block_extent bex;
 
-		p = svcxdr_decode_deviceid4(p, &bex.vol_id);
-		p = xdr_decode_hyper(p, &bex.foff);
+		if (nfsd4_decode_deviceid4(xdr, &bex.vol_id)) {
+			nfserr = nfserr_bad_xdr;
+			goto fail;
+		}
+
+		if (xdr_stream_decode_u64(xdr, &bex.foff)) {
+			nfserr = nfserr_bad_xdr;
+			goto fail;
+		}
 		if (bex.foff & (block_size - 1)) {
+			nfserr = nfserr_inval;
+			goto fail;
+		}
+
+		if (xdr_stream_decode_u64(xdr, &bex.len)) {
+			nfserr = nfserr_bad_xdr;
 			goto fail;
 		}
-		p = xdr_decode_hyper(p, &bex.len);
 		if (bex.len & (block_size - 1)) {
+			nfserr = nfserr_inval;
+			goto fail;
+		}
+
+		if (xdr_stream_decode_u64(xdr, &bex.soff)) {
+			nfserr = nfserr_bad_xdr;
 			goto fail;
 		}
-		p = xdr_decode_hyper(p, &bex.soff);
 		if (bex.soff & (block_size - 1)) {
+			nfserr = nfserr_inval;
+			goto fail;
+		}
+
+		if (xdr_stream_decode_u32(xdr, &bex.es)) {
+			nfserr = nfserr_bad_xdr;
 			goto fail;
 		}
-		bex.es = be32_to_cpup(p++);
 		if (bex.es != PNFS_BLOCK_READWRITE_DATA) {
+			nfserr = nfserr_inval;
 			goto fail;
 		}
 
@@ -182,13 +203,12 @@ nfsd4_block_decode_layoutupdate(__be32 *
 	return nfs_ok;
 fail:
 	kfree(iomaps);
-	return nfserr_inval;
+	return nfserr;
 }
 
 /**
  * nfsd4_scsi_decode_layoutupdate - decode the scsi layout extent array
- * @p: pointer to the xdr data
- * @len: number of bytes to decode
+ * @xdr: subbuf set to the encoded array
  * @iomapp: pointer to store the decoded extent array
  * @nr_iomapsp: pointer to store the number of extents
  * @block_size: alignment of extent offset and length
@@ -200,21 +220,22 @@ fail:
  *
  * Return values:
  *   %nfs_ok: Successful decoding, @iomapp and @nr_iomapsp are valid
- *   %nfserr_bad_xdr: The encoded array in @p is invalid
+ *   %nfserr_bad_xdr: The encoded array in @xdr is invalid
  *   %nfserr_inval: An unaligned extent found
  *   %nfserr_delay: Failed to allocate memory for @iomapp
  */
 __be32
-nfsd4_scsi_decode_layoutupdate(__be32 *p, u32 len, struct iomap **iomapp,
+nfsd4_scsi_decode_layoutupdate(struct xdr_stream *xdr, struct iomap **iomapp,
 		int *nr_iomapsp, u32 block_size)
 {
 	struct iomap *iomaps;
-	u32 nr_iomaps, expected, i;
+	u32 nr_iomaps, expected, len, i;
+	__be32 nfserr;
 
-	if (len < sizeof(u32))
+	if (xdr_stream_decode_u32(xdr, &nr_iomaps))
 		return nfserr_bad_xdr;
 
-	nr_iomaps = be32_to_cpup(p++);
+	len = sizeof(__be32) + xdr_stream_remaining(xdr);
 	expected = sizeof(__be32) + nr_iomaps * PNFS_SCSI_RANGE_SIZE;
 	if (len != expected)
 		return nfserr_bad_xdr;
@@ -226,14 +247,22 @@ nfsd4_scsi_decode_layoutupdate(__be32 *p
 	for (i = 0; i < nr_iomaps; i++) {
 		u64 val;
 
-		p = xdr_decode_hyper(p, &val);
+		if (xdr_stream_decode_u64(xdr, &val)) {
+			nfserr = nfserr_bad_xdr;
+			goto fail;
+		}
 		if (val & (block_size - 1)) {
+			nfserr = nfserr_inval;
 			goto fail;
 		}
 		iomaps[i].offset = val;
 
-		p = xdr_decode_hyper(p, &val);
+		if (xdr_stream_decode_u64(xdr, &val)) {
+			nfserr = nfserr_bad_xdr;
+			goto fail;
+		}
 		if (val & (block_size - 1)) {
+			nfserr = nfserr_inval;
 			goto fail;
 		}
 		iomaps[i].length = val;
@@ -244,5 +273,5 @@ nfsd4_scsi_decode_layoutupdate(__be32 *p
 	return nfs_ok;
 fail:
 	kfree(iomaps);
-	return nfserr_inval;
+	return nfserr;
 }
--- a/fs/nfsd/blocklayoutxdr.h
+++ b/fs/nfsd/blocklayoutxdr.h
@@ -54,9 +54,9 @@ __be32 nfsd4_block_encode_getdeviceinfo(
 		const struct nfsd4_getdeviceinfo *gdp);
 __be32 nfsd4_block_encode_layoutget(struct xdr_stream *xdr,
 		const struct nfsd4_layoutget *lgp);
-__be32 nfsd4_block_decode_layoutupdate(__be32 *p, u32 len,
+__be32 nfsd4_block_decode_layoutupdate(struct xdr_stream *xdr,
 		struct iomap **iomapp, int *nr_iomapsp, u32 block_size);
-__be32 nfsd4_scsi_decode_layoutupdate(__be32 *p, u32 len,
+__be32 nfsd4_scsi_decode_layoutupdate(struct xdr_stream *xdr,
 		struct iomap **iomapp, int *nr_iomapsp, u32 block_size);
 
 #endif /* _NFSD_BLOCKLAYOUTXDR_H */
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2407,7 +2407,7 @@ nfsd4_layoutcommit(struct svc_rqst *rqst
 		lcp->lc_size_chg = false;
 	}
 
-	nfserr = ops->proc_layoutcommit(inode, lcp);
+	nfserr = ops->proc_layoutcommit(inode, rqstp, lcp);
 	nfs4_put_stid(&ls->ls_stid);
 out:
 	return nfserr;
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -571,6 +571,8 @@ static __be32
 nfsd4_decode_layoutupdate4(struct nfsd4_compoundargs *argp,
 			   struct nfsd4_layoutcommit *lcp)
 {
+	u32 len;
+
 	if (xdr_stream_decode_u32(argp->xdr, &lcp->lc_layout_type) < 0)
 		return nfserr_bad_xdr;
 	if (lcp->lc_layout_type < LAYOUT_NFSV4_1_FILES)
@@ -578,13 +580,10 @@ nfsd4_decode_layoutupdate4(struct nfsd4_
 	if (lcp->lc_layout_type >= LAYOUT_TYPE_MAX)
 		return nfserr_bad_xdr;
 
-	if (xdr_stream_decode_u32(argp->xdr, &lcp->lc_up_len) < 0)
+	if (xdr_stream_decode_u32(argp->xdr, &len) < 0)
+		return nfserr_bad_xdr;
+	if (!xdr_stream_subsegment(argp->xdr, &lcp->lc_up_layout, len))
 		return nfserr_bad_xdr;
-	if (lcp->lc_up_len > 0) {
-		lcp->lc_up_layout = xdr_inline_decode(argp->xdr, lcp->lc_up_len);
-		if (!lcp->lc_up_layout)
-			return nfserr_bad_xdr;
-	}
 
 	return nfs_ok;
 }
--- a/fs/nfsd/pnfs.h
+++ b/fs/nfsd/pnfs.h
@@ -35,6 +35,7 @@ struct nfsd4_layout_ops {
 			const struct nfsd4_layoutget *lgp);
 
 	__be32 (*proc_layoutcommit)(struct inode *inode,
+			struct svc_rqst *rqstp,
 			struct nfsd4_layoutcommit *lcp);
 
 	void (*fence_client)(struct nfs4_layout_stateid *ls,
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -665,8 +665,7 @@ struct nfsd4_layoutcommit {
 	u64			lc_last_wr;	/* request */
 	struct timespec64	lc_mtime;	/* request */
 	u32			lc_layout_type;	/* request */
-	u32			lc_up_len;	/* layout length */
-	void			*lc_up_layout;	/* decoded by callback */
+	struct xdr_buf		lc_up_layout;	/* decoded by callback */
 	bool			lc_size_chg;	/* response */
 	u64			lc_newsize;	/* response */
 };


