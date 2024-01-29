Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB1815704E;
	Mon, 29 Jan 2024 17:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548022; cv=none; b=gVkTDt0eY4IdVOVMCKzDEncHkHA1vmVmK6a6QDEQM0ieVAXDw6VXEEpEf1pWWdOmmoGrm3+z6DwFxIPA8NKVkMOa0ZAQePc9Z24dbwscnehzTnplDo7geVz5ENdaNJfAaYnnpHzxdOuTCkl2gahDlDvZTUJW0TfLUC9ARes2oVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548022; c=relaxed/simple;
	bh=kcC+YmA/wtrLQxX5lZdEMG2ubfPKmgax/6Os/WZnAbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTnEIRe8SsSQo58NegoLXyr4MgVOaLvo46aeCaNtvscsufOHUf+OE/ympuUXRAt/vsiG/4EKY5Zfxb9LW3/M1IReM8OCLrKqi/Y3YUSATlx+9ivWO3nZW1IC+1zZwSjgs5AXEroc3iCjGt+mD1v+8ZPeS0Ohxi37Pil2fH/wukY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BP/Jw6ho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BP/Jw6ho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD9AC433F1;
	Mon, 29 Jan 2024 17:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548022;
	bh=kcC+YmA/wtrLQxX5lZdEMG2ubfPKmgax/6Os/WZnAbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BP/Jw6hoIQ6DVA3dBUxSaIWnyP6ce5A2pZN6Ewl8EqbZMUpZLnioyyGoYb5kfbrVq
	 O0P8T9V3rJaEKYh5BUE7h4yC5HCNJGn7dk1/a47sV/KCPLcjupAV/VM9bflBTatMC+
	 h784xtqVLzMuYAvS7XFKdUIkDf7DfW2BEm6WwdqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhao <zhaoyifan@sjtu.edu.cn>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Juhyung Park <qkrwngud825@gmail.com>
Subject: [PATCH 6.7 015/346] erofs: fix lz4 inplace decompression
Date: Mon, 29 Jan 2024 09:00:46 -0800
Message-ID: <20240129170016.807059606@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 fs/erofs/decompressor.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -121,11 +121,11 @@ static int z_erofs_lz4_prepare_dstpages(
 }
 
 static void *z_erofs_lz4_handle_overlap(struct z_erofs_lz4_decompress_ctx *ctx,
-			void *inpage, unsigned int *inputmargin, int *maptype,
-			bool may_inplace)
+			void *inpage, void *out, unsigned int *inputmargin,
+			int *maptype, bool may_inplace)
 {
 	struct z_erofs_decompress_req *rq = ctx->rq;
-	unsigned int omargin, total, i, j;
+	unsigned int omargin, total, i;
 	struct page **in;
 	void *src, *tmp;
 
@@ -135,12 +135,13 @@ static void *z_erofs_lz4_handle_overlap(
 		    omargin < LZ4_DECOMPRESS_INPLACE_MARGIN(rq->inputsize))
 			goto docopy;
 
-		for (i = 0; i < ctx->inpages; ++i) {
-			DBG_BUGON(rq->in[i] == NULL);
-			for (j = 0; j < ctx->outpages - ctx->inpages + i; ++j)
-				if (rq->out[j] == rq->in[i])
-					goto docopy;
-		}
+		for (i = 0; i < ctx->inpages; ++i)
+			if (rq->out[ctx->outpages - ctx->inpages + i] !=
+			    rq->in[i])
+				goto docopy;
+		kunmap_local(inpage);
+		*maptype = 3;
+		return out + ((ctx->outpages - ctx->inpages) << PAGE_SHIFT);
 	}
 
 	if (ctx->inpages <= 1) {
@@ -148,7 +149,6 @@ static void *z_erofs_lz4_handle_overlap(
 		return inpage;
 	}
 	kunmap_local(inpage);
-	might_sleep();
 	src = erofs_vm_map_ram(rq->in, ctx->inpages);
 	if (!src)
 		return ERR_PTR(-ENOMEM);
@@ -204,12 +204,12 @@ int z_erofs_fixup_insize(struct z_erofs_
 }
 
 static int z_erofs_lz4_decompress_mem(struct z_erofs_lz4_decompress_ctx *ctx,
-				      u8 *out)
+				      u8 *dst)
 {
 	struct z_erofs_decompress_req *rq = ctx->rq;
 	bool support_0padding = false, may_inplace = false;
 	unsigned int inputmargin;
-	u8 *headpage, *src;
+	u8 *out, *headpage, *src;
 	int ret, maptype;
 
 	DBG_BUGON(*rq->in == NULL);
@@ -230,11 +230,12 @@ static int z_erofs_lz4_decompress_mem(st
 	}
 
 	inputmargin = rq->pageofs_in;
-	src = z_erofs_lz4_handle_overlap(ctx, headpage, &inputmargin,
+	src = z_erofs_lz4_handle_overlap(ctx, headpage, dst, &inputmargin,
 					 &maptype, may_inplace);
 	if (IS_ERR(src))
 		return PTR_ERR(src);
 
+	out = dst + rq->pageofs_out;
 	/* legacy format could compress extra data in a pcluster. */
 	if (rq->partial_decoding || !support_0padding)
 		ret = LZ4_decompress_safe_partial(src + inputmargin, out,
@@ -265,7 +266,7 @@ static int z_erofs_lz4_decompress_mem(st
 		vm_unmap_ram(src, ctx->inpages);
 	} else if (maptype == 2) {
 		erofs_put_pcpubuf(src);
-	} else {
+	} else if (maptype != 3) {
 		DBG_BUGON(1);
 		return -EFAULT;
 	}
@@ -308,7 +309,7 @@ static int z_erofs_lz4_decompress(struct
 	}
 
 dstmap_out:
-	ret = z_erofs_lz4_decompress_mem(&ctx, dst + rq->pageofs_out);
+	ret = z_erofs_lz4_decompress_mem(&ctx, dst);
 	if (!dst_maptype)
 		kunmap_local(dst);
 	else if (dst_maptype == 2)


