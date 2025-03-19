Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FA0209F50;
	Wed, 19 Mar 2025 14:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395229; cv=none; b=HxiWMJXcKb8TD9/mknxFvTVbKL2avHnjsLQjLcgyL+TxvFoD7bDMp8q3rnYaeKs42ik0nAuDCkTivGoEP9kjhE/GyRkIZN7nfts8q4XWto4iqfqGG/OL4hQQIRETSZ6VtnzUqo9gojP2TFJUimDvpAhf6ZIa8FStNXpARXKRXjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395229; c=relaxed/simple;
	bh=mr+B9fVcZBD8oWOkm1G4EuClIv22IrDF7dX3IJJDDWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZieCficNZkwr+bQ3FvK3kk8QyqdMbVQ0I62BGIS1riiCwekyQLOUFKOtjEMY6Fds7hxyfpaY1+34mrXxWiOZBmfhTO4Fr/g5w61Tn3+h8t+IZXdZlst2bcVhOSU+h8WlNE1p+mB4UQNUXtJKrfIUHC7jmdJ6RtMA9wTHatfsgvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pf+BNOkS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pf+BNOkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1E7C4CEE8;
	Wed, 19 Mar 2025 14:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395229;
	bh=mr+B9fVcZBD8oWOkm1G4EuClIv22IrDF7dX3IJJDDWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pf+BNOkS00qPtpsGWM3XcAZyEBN6AWM5S2qBMn1mLn9PwWhPzuENoyIdKvqJwhmoQ
	 +wKDn6ZP/8y2axhVnY03e3skMptoQRojQDN/DD97Wv/+Ra6VcoLd21Kvl5NkfFNEiX
	 uNyo0Lo2baWexD1htyYGStDP68CCiqRXFZLunUY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 100/166] io_uring/kbuf: vmap pinned buffer ring
Date: Wed, 19 Mar 2025 07:31:11 -0700
Message-ID: <20250319143022.725359077@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jens Axboe <axboe@kernel.dk>

Commit e270bfd22a2a10d1cfbaddf23e79b6d0b405d21e upstream.

This avoids needing to care about HIGHMEM, and it makes the buffer
indexing easier as both ring provided buffer methods are now virtually
mapped in a contigious fashion.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |   39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/namei.h>
 #include <linux/poll.h>
+#include <linux/vmalloc.h>
 #include <linux/io_uring.h>
 
 #include <uapi/linux/io_uring.h>
@@ -153,15 +154,7 @@ static void __user *io_ring_buffer_selec
 		return NULL;
 
 	head &= bl->mask;
-	/* mmaped buffers are always contig */
-	if (bl->is_mmap || head < IO_BUFFER_LIST_BUF_PER_PAGE) {
-		buf = &br->bufs[head];
-	} else {
-		int off = head & (IO_BUFFER_LIST_BUF_PER_PAGE - 1);
-		int index = head / IO_BUFFER_LIST_BUF_PER_PAGE;
-		buf = page_address(bl->buf_pages[index]);
-		buf += off;
-	}
+	buf = &br->bufs[head];
 	if (*len == 0 || *len > buf->len)
 		*len = buf->len;
 	req->flags |= REQ_F_BUFFER_RING;
@@ -249,6 +242,7 @@ static int __io_remove_buffers(struct io
 			for (j = 0; j < bl->buf_nr_pages; j++)
 				unpin_user_page(bl->buf_pages[j]);
 			kvfree(bl->buf_pages);
+			vunmap(bl->buf_ring);
 			bl->buf_pages = NULL;
 			bl->buf_nr_pages = 0;
 		}
@@ -501,9 +495,9 @@ err:
 static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 			    struct io_buffer_list *bl)
 {
-	struct io_uring_buf_ring *br;
+	struct io_uring_buf_ring *br = NULL;
+	int nr_pages, ret, i;
 	struct page **pages;
-	int i, nr_pages;
 
 	pages = io_pin_pages(reg->ring_addr,
 			     flex_array_size(br, bufs, reg->ring_entries),
@@ -511,18 +505,12 @@ static int io_pin_pbuf_ring(struct io_ur
 	if (IS_ERR(pages))
 		return PTR_ERR(pages);
 
-	/*
-	 * Apparently some 32-bit boxes (ARM) will return highmem pages,
-	 * which then need to be mapped. We could support that, but it'd
-	 * complicate the code and slowdown the common cases quite a bit.
-	 * So just error out, returning -EINVAL just like we did on kernels
-	 * that didn't support mapped buffer rings.
-	 */
-	for (i = 0; i < nr_pages; i++)
-		if (PageHighMem(pages[i]))
-			goto error_unpin;
+	br = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
+	if (!br) {
+		ret = -ENOMEM;
+		goto error_unpin;
+	}
 
-	br = page_address(pages[0]);
 #ifdef SHM_COLOUR
 	/*
 	 * On platforms that have specific aliasing requirements, SHM_COLOUR
@@ -533,8 +521,10 @@ static int io_pin_pbuf_ring(struct io_ur
 	 * should use IOU_PBUF_RING_MMAP instead, and liburing will handle
 	 * this transparently.
 	 */
-	if ((reg->ring_addr | (unsigned long) br) & (SHM_COLOUR - 1))
+	if ((reg->ring_addr | (unsigned long) br) & (SHM_COLOUR - 1)) {
+		ret = -EINVAL;
 		goto error_unpin;
+	}
 #endif
 	bl->buf_pages = pages;
 	bl->buf_nr_pages = nr_pages;
@@ -546,7 +536,8 @@ error_unpin:
 	for (i = 0; i < nr_pages; i++)
 		unpin_user_page(pages[i]);
 	kvfree(pages);
-	return -EINVAL;
+	vunmap(br);
+	return ret;
 }
 
 /*


