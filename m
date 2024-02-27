Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE60D17F0;
	Tue, 27 Feb 2024 14:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044206; cv=none; b=I8xsQRCujScljrejDdpN7I4r53B6g4cfkxWj0b2zKgcfxKljScylHudTdTVIcYPch/e7zZdFjbVEgx8gacTXxx1rIE4xmt8aWF3y2oM9kcGpjTtIqFyQ97DtzjvOkaH77JLSV3It6B8MMogL+faJOPI2I8HSL3tWqFwIoEIJ+A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044206; c=relaxed/simple;
	bh=IFO3gLHYC2a3sa9xD2R6iebt55T2dcP4xPYic8y5RbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n95fvJ9i8SEfxDYDgy9LA3TfhDDF3emyqMKdLQDIKG9z+YrkTP1evukaysospZKj7Cz6oEf1CJb2YnPCmKGsgLhPWGOJo8pnKHkWkyntZUA4ho6XeBQtEIFh/JOBnMsfx0qglerb3u1v72PhyXH/h0uBoNm03W34kFA6j11YUR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyJvOFFd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyJvOFFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C50EC433F1;
	Tue, 27 Feb 2024 14:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044205;
	bh=IFO3gLHYC2a3sa9xD2R6iebt55T2dcP4xPYic8y5RbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyJvOFFdzrSfGtkMJPjnkoif/mtVlEL4ypPSL4NmEzZoYLGKJGwRI4nkiVQ1Q02jj
	 8MVTb1D0aIP+HN7fuYP+pRBzYILjDSGVNqWRArPEByuw4LnWqgFjTiZBTSSokD5pHS
	 tgf+aLPuGhj1WOjtLQNtYT7sEmSzHiGwGiyGUIrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhao <zhaoyifan@sjtu.edu.cn>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Juhyung Park <qkrwngud825@gmail.com>
Subject: [PATCH 5.10 073/122] erofs: fix lz4 inplace decompression
Date: Tue, 27 Feb 2024 14:27:14 +0100
Message-ID: <20240227131601.092540561@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 3c12466b6b7bf1e56f9b32c366a3d83d87afb4de upstream.

Currently EROFS can map another compressed buffer for inplace
decompression, that was used to handle the cases that some pages of
compressed data are actually not in-place I/O.

However, like most simple LZ77 algorithms, LZ4 expects the compressed
data is arranged at the end of the decompressed buffer and it
explicitly uses memmove() to handle overlapping:
  __________________________________________________________
 |_ direction of decompression --> ____ |_ compressed data _|

Although EROFS arranges compressed data like this, it typically maps two
individual virtual buffers so the relative order is uncertain.
Previously, it was hardly observed since LZ4 only uses memmove() for
short overlapped literals and x86/arm64 memmove implementations seem to
completely cover it up and they don't have this issue.  Juhyung reported
that EROFS data corruption can be found on a new Intel x86 processor.
After some analysis, it seems that recent x86 processors with the new
FSRM feature expose this issue with "rep movsb".

Let's strictly use the decompressed buffer for lz4 inplace
decompression for now.  Later, as an useful improvement, we could try
to tie up these two buffers together in the correct order.

Reported-and-tested-by: Juhyung Park <qkrwngud825@gmail.com>
Closes: https://lore.kernel.org/r/CAD14+f2AVKf8Fa2OO1aAUdDNTDsVzzR6ctU_oJSmTyd6zSYR2Q@mail.gmail.com
Fixes: 0ffd71bcc3a0 ("staging: erofs: introduce LZ4 decompression inplace")
Fixes: 598162d05080 ("erofs: support decompress big pcluster for lz4 backend")
Cc: stable <stable@vger.kernel.org> # 5.4+
Tested-by: Yifan Zhao <zhaoyifan@sjtu.edu.cn>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20231206045534.3920847-1-hsiangkao@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/decompressor.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -24,7 +24,8 @@ struct z_erofs_decompressor {
 	 */
 	int (*prepare_destpages)(struct z_erofs_decompress_req *rq,
 				 struct list_head *pagepool);
-	int (*decompress)(struct z_erofs_decompress_req *rq, u8 *out);
+	int (*decompress)(struct z_erofs_decompress_req *rq, u8 *out,
+			  u8 *obase);
 	char *name;
 };
 
@@ -114,10 +115,13 @@ static void *generic_copy_inplace_data(s
 	return tmp;
 }
 
-static int z_erofs_lz4_decompress(struct z_erofs_decompress_req *rq, u8 *out)
+static int z_erofs_lz4_decompress(struct z_erofs_decompress_req *rq, u8 *out,
+				  u8 *obase)
 {
+	const uint nrpages_out = PAGE_ALIGN(rq->pageofs_out +
+					    rq->outputsize) >> PAGE_SHIFT;
 	unsigned int inputmargin, inlen;
-	u8 *src;
+	u8 *src, *src2;
 	bool copied, support_0padding;
 	int ret;
 
@@ -125,6 +129,7 @@ static int z_erofs_lz4_decompress(struct
 		return -EOPNOTSUPP;
 
 	src = kmap_atomic(*rq->in);
+	src2 = src;
 	inputmargin = 0;
 	support_0padding = false;
 
@@ -148,16 +153,15 @@ static int z_erofs_lz4_decompress(struct
 	if (rq->inplace_io) {
 		const uint oend = (rq->pageofs_out +
 				   rq->outputsize) & ~PAGE_MASK;
-		const uint nr = PAGE_ALIGN(rq->pageofs_out +
-					   rq->outputsize) >> PAGE_SHIFT;
-
 		if (rq->partial_decoding || !support_0padding ||
-		    rq->out[nr - 1] != rq->in[0] ||
+		    rq->out[nrpages_out - 1] != rq->in[0] ||
 		    rq->inputsize - oend <
 		      LZ4_DECOMPRESS_INPLACE_MARGIN(inlen)) {
 			src = generic_copy_inplace_data(rq, src, inputmargin);
 			inputmargin = 0;
 			copied = true;
+		} else {
+			src = obase + ((nrpages_out - 1) << PAGE_SHIFT);
 		}
 	}
 
@@ -187,7 +191,7 @@ static int z_erofs_lz4_decompress(struct
 	if (copied)
 		erofs_put_pcpubuf(src);
 	else
-		kunmap_atomic(src);
+		kunmap_atomic(src2);
 	return ret;
 }
 
@@ -257,7 +261,7 @@ static int z_erofs_decompress_generic(st
 			return PTR_ERR(dst);
 
 		rq->inplace_io = false;
-		ret = alg->decompress(rq, dst);
+		ret = alg->decompress(rq, dst, NULL);
 		if (!ret)
 			copy_from_pcpubuf(rq->out, dst, rq->pageofs_out,
 					  rq->outputsize);
@@ -291,7 +295,7 @@ static int z_erofs_decompress_generic(st
 	dst_maptype = 2;
 
 dstmap_out:
-	ret = alg->decompress(rq, dst + rq->pageofs_out);
+	ret = alg->decompress(rq, dst + rq->pageofs_out, dst);
 
 	if (!dst_maptype)
 		kunmap_atomic(dst);


