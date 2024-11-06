Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05E1646;
	Wed,  6 Nov 2024 13:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899009; cv=none; b=eyIJu+Eepx1Hh00nvzwjlHBQf0V7lRFgzF9lQl5s5Q8JK/Ko+mIrDxSjRSJeOtYYqYb79Z/ks93DrXHV/Vm+P8IU6EZb8OvfJohV/98zs2IekmqwVo7sBg/dLecsteuBDEaffVeMKiByky4iXP1EECZzAjPOYiJJM9fTGXeoMTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899009; c=relaxed/simple;
	bh=O8jSRNQczRBxb28jo103x6C7jp0XX/DTkD2B73STaYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKPfmU0qM95D3vmKpwQH8Ha+8k9b0ubxU9EDP/deObtQIbcUzMj5Tow3Qc3wJfsF5iBgpK5bHqFNZGGqQCyVav2c0Wuu815ecdHXLUxTEt4DWdSiuTtL3hcWvV063gQplCxK8u2d4lpKPPYgRI34kt/T4GvSbVdn7gLAoiuTsXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qu35SZmg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qu35SZmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE7FC4CECD;
	Wed,  6 Nov 2024 13:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899008;
	bh=O8jSRNQczRBxb28jo103x6C7jp0XX/DTkD2B73STaYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qu35SZmg+0ghiTDLOmMHd4IUqF0VtSaBBngmoU4+ddtqcmB3HPT4n9+Dr7MI/TnEs
	 yjMrLq0oWwPwonMHIhzuxH01idFg7/lSb9u6NWfWZVhg8oCprRBQgYi34LHlyWcuBC
	 eNsxttbdQBZUJLnQLKQHlWZiv4QFCUzPC+BA4bqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhao <zhaoyifan@sjtu.edu.cn>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Juhyung Park <qkrwngud825@gmail.com>
Subject: [PATCH 5.4 383/462] erofs: fix lz4 inplace decompression
Date: Wed,  6 Nov 2024 13:04:36 +0100
Message-ID: <20241106120340.981487388@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -178,7 +182,7 @@ static int z_erofs_lz4_decompress(struct
 	if (copied)
 		erofs_put_pcpubuf(src);
 	else
-		kunmap_atomic(src);
+		kunmap_atomic(src2);
 	return ret;
 }
 
@@ -248,7 +252,7 @@ static int z_erofs_decompress_generic(st
 			return PTR_ERR(dst);
 
 		rq->inplace_io = false;
-		ret = alg->decompress(rq, dst);
+		ret = alg->decompress(rq, dst, NULL);
 		if (!ret)
 			copy_from_pcpubuf(rq->out, dst, rq->pageofs_out,
 					  rq->outputsize);
@@ -282,7 +286,7 @@ static int z_erofs_decompress_generic(st
 	dst_maptype = 2;
 
 dstmap_out:
-	ret = alg->decompress(rq, dst + rq->pageofs_out);
+	ret = alg->decompress(rq, dst + rq->pageofs_out, dst);
 
 	if (!dst_maptype)
 		kunmap_atomic(dst);


