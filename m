Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9432749D6;
	Mon, 29 Dec 2025 16:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025543; cv=none; b=uCgzyexC1DIHUcFjP+Ob830PJ5qodl/ysoPfuBGjfKIkXv5BszYkVvwqq33SWd3j9dpAoZR9IGA9MgKvTRD76vEYC//0GxcSFW1ijjM5OJrsOeix0DmWMze1NrEnc+GKSOvL6pkmN+XcFQGM7z8n+bAX7HUBAqDqERj2C6sB0nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025543; c=relaxed/simple;
	bh=xzLixRV7u1TsKndzv4UfmsRrmZ82lZGFkvm/IrsJtQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tC+0fivGmfuqDm2PfxajyGJOO1rpcE6ANMji7PJLMykhXgXSURvz5FBOTLn9HZNBdBY+H88pPvQ+6X5pW+cHi9on/vrQ6yaBsMJufnSLBpa0h56+jGu4e/B0AUX3EJaB3fircc17KBwdk4PUV3S30dx6CVgnEWmY7IeMM7eb3DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2n53FHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2n53FHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8ACC4CEF7;
	Mon, 29 Dec 2025 16:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025543;
	bh=xzLixRV7u1TsKndzv4UfmsRrmZ82lZGFkvm/IrsJtQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2n53FHQVG7rztRP4g/G0drx7vpTrC5sF2/Ux7dpywuMrlsjlgiCdWfPYobWv9OGh
	 bqmlZd24UkHrLKpTclTWsL+uUgq+/7LgCjyZ6ZelWCqaNBAULRSaqlM2COBL65Tho8
	 AJo5nDQsVp6lorGJiYgeBqR/Cjzq7QNyZUqPXnFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <coking@nvidia.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 251/430] crypto: scatterwalk - Fix memcpy_sglist() to always succeed
Date: Mon, 29 Dec 2025 17:10:53 +0100
Message-ID: <20251229160733.592763435@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 4dffc9bbffb9ccfcda730d899c97c553599e7ca8 upstream.

The original implementation of memcpy_sglist() was broken because it
didn't handle scatterlists that describe exactly the same memory, which
is a case that many callers rely on.  The current implementation is
broken too because it calls the skcipher_walk functions which can fail.
It ignores any errors from those functions.

Fix it by replacing it with a new implementation written from scratch.
It always succeeds.  It's also a bit faster, since it avoids the
overhead of skcipher_walk.  skcipher_walk includes a lot of
functionality (such as alignmask handling) that's irrelevant here.

Reported-by: Colin Ian King <coking@nvidia.com>
Closes: https://lore.kernel.org/r/20251114122620.111623-1-coking@nvidia.com
Fixes: 131bdceca1f0 ("crypto: scatterwalk - Add memcpy_sglist")
Fixes: 0f8d42bf128d ("crypto: scatterwalk - Move skcipher walk and use it for memcpy_sglist")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/scatterwalk.c         | 95 +++++++++++++++++++++++++++++++-----
 include/crypto/scatterwalk.h | 52 ++++++++++++--------
 2 files changed, 114 insertions(+), 33 deletions(-)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 1d010e2a1b1a..b95e5974e327 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -101,26 +101,97 @@ void memcpy_to_sglist(struct scatterlist *sg, unsigned int start,
 }
 EXPORT_SYMBOL_GPL(memcpy_to_sglist);
 
+/**
+ * memcpy_sglist() - Copy data from one scatterlist to another
+ * @dst: The destination scatterlist.  Can be NULL if @nbytes == 0.
+ * @src: The source scatterlist.  Can be NULL if @nbytes == 0.
+ * @nbytes: Number of bytes to copy
+ *
+ * The scatterlists can describe exactly the same memory, in which case this
+ * function is a no-op.  No other overlaps are supported.
+ *
+ * Context: Any context
+ */
 void memcpy_sglist(struct scatterlist *dst, struct scatterlist *src,
 		   unsigned int nbytes)
 {
-	struct skcipher_walk walk = {};
+	unsigned int src_offset, dst_offset;
 
-	if (unlikely(nbytes == 0)) /* in case sg == NULL */
+	if (unlikely(nbytes == 0)) /* in case src and/or dst is NULL */
 		return;
 
-	walk.total = nbytes;
+	src_offset = src->offset;
+	dst_offset = dst->offset;
+	for (;;) {
+		/* Compute the length to copy this step. */
+		unsigned int len = min3(src->offset + src->length - src_offset,
+					dst->offset + dst->length - dst_offset,
+					nbytes);
+		struct page *src_page = sg_page(src);
+		struct page *dst_page = sg_page(dst);
+		const void *src_virt;
+		void *dst_virt;
 
-	scatterwalk_start(&walk.in, src);
-	scatterwalk_start(&walk.out, dst);
+		if (IS_ENABLED(CONFIG_HIGHMEM)) {
+			/* HIGHMEM: we may have to actually map the pages. */
+			const unsigned int src_oip = offset_in_page(src_offset);
+			const unsigned int dst_oip = offset_in_page(dst_offset);
+			const unsigned int limit = PAGE_SIZE;
 
-	skcipher_walk_first(&walk, true);
-	do {
-		if (walk.src.virt.addr != walk.dst.virt.addr)
-			memcpy(walk.dst.virt.addr, walk.src.virt.addr,
-			       walk.nbytes);
-		skcipher_walk_done(&walk, 0);
-	} while (walk.nbytes);
+			/* Further limit len to not cross a page boundary. */
+			len = min3(len, limit - src_oip, limit - dst_oip);
+
+			/* Compute the source and destination pages. */
+			src_page += src_offset / PAGE_SIZE;
+			dst_page += dst_offset / PAGE_SIZE;
+
+			if (src_page != dst_page) {
+				/* Copy between different pages. */
+				memcpy_page(dst_page, dst_oip,
+					    src_page, src_oip, len);
+				flush_dcache_page(dst_page);
+			} else if (src_oip != dst_oip) {
+				/* Copy between different parts of same page. */
+				dst_virt = kmap_local_page(dst_page);
+				memcpy(dst_virt + dst_oip, dst_virt + src_oip,
+				       len);
+				kunmap_local(dst_virt);
+				flush_dcache_page(dst_page);
+			} /* Else, it's the same memory.  No action needed. */
+		} else {
+			/*
+			 * !HIGHMEM: no mapping needed.  Just work in the linear
+			 * buffer of each sg entry.  Note that we can cross page
+			 * boundaries, as they are not significant in this case.
+			 */
+			src_virt = page_address(src_page) + src_offset;
+			dst_virt = page_address(dst_page) + dst_offset;
+			if (src_virt != dst_virt) {
+				memcpy(dst_virt, src_virt, len);
+				if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE)
+					__scatterwalk_flush_dcache_pages(
+						dst_page, dst_offset, len);
+			} /* Else, it's the same memory.  No action needed. */
+		}
+		nbytes -= len;
+		if (nbytes == 0) /* No more to copy? */
+			break;
+
+		/*
+		 * There's more to copy.  Advance the offsets by the length
+		 * copied this step, and advance the sg entries as needed.
+		 */
+		src_offset += len;
+		if (src_offset >= src->offset + src->length) {
+			src = sg_next(src);
+			src_offset = src->offset;
+		}
+		dst_offset += len;
+		if (dst_offset >= dst->offset + dst->length) {
+			dst = sg_next(dst);
+			dst_offset = dst->offset;
+		}
+	}
 }
 EXPORT_SYMBOL_GPL(memcpy_sglist);
 
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 83d14376ff2b..f485454e3955 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -227,6 +227,34 @@ static inline void scatterwalk_done_src(struct scatter_walk *walk,
 	scatterwalk_advance(walk, nbytes);
 }
 
+/*
+ * Flush the dcache of any pages that overlap the region
+ * [offset, offset + nbytes) relative to base_page.
+ *
+ * This should be called only when ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE, to ensure
+ * that all relevant code (including the call to sg_page() in the caller, if
+ * applicable) gets fully optimized out when !ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE.
+ */
+static inline void __scatterwalk_flush_dcache_pages(struct page *base_page,
+						    unsigned int offset,
+						    unsigned int nbytes)
+{
+	unsigned int num_pages;
+
+	base_page += offset / PAGE_SIZE;
+	offset %= PAGE_SIZE;
+
+	/*
+	 * This is an overflow-safe version of
+	 * num_pages = DIV_ROUND_UP(offset + nbytes, PAGE_SIZE).
+	 */
+	num_pages = nbytes / PAGE_SIZE;
+	num_pages += DIV_ROUND_UP(offset + (nbytes % PAGE_SIZE), PAGE_SIZE);
+
+	for (unsigned int i = 0; i < num_pages; i++)
+		flush_dcache_page(base_page + i);
+}
+
 /**
  * scatterwalk_done_dst() - Finish one step of a walk of destination scatterlist
  * @walk: the scatter_walk
@@ -240,27 +268,9 @@ static inline void scatterwalk_done_dst(struct scatter_walk *walk,
 					unsigned int nbytes)
 {
 	scatterwalk_unmap(walk);
-	/*
-	 * Explicitly check ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE instead of just
-	 * relying on flush_dcache_page() being a no-op when not implemented,
-	 * since otherwise the BUG_ON in sg_page() does not get optimized out.
-	 * This also avoids having to consider whether the loop would get
-	 * reliably optimized out or not.
-	 */
-	if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE) {
-		struct page *base_page;
-		unsigned int offset;
-		int start, end, i;
-
-		base_page = sg_page(walk->sg);
-		offset = walk->offset;
-		start = offset >> PAGE_SHIFT;
-		end = start + (nbytes >> PAGE_SHIFT);
-		end += (offset_in_page(offset) + offset_in_page(nbytes) +
-			PAGE_SIZE - 1) >> PAGE_SHIFT;
-		for (i = start; i < end; i++)
-			flush_dcache_page(base_page + i);
-	}
+	if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE)
+		__scatterwalk_flush_dcache_pages(sg_page(walk->sg),
+						 walk->offset, nbytes);
 	scatterwalk_advance(walk, nbytes);
 }
 
-- 
2.52.0



