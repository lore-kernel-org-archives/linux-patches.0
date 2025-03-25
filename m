Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5D1266B69;
	Tue, 25 Mar 2025 12:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905680; cv=none; b=ugHRa5sXgAB45xSq0F9zrWr6u/8IbxHjM22846ns0eW+q/yLkFRylYyedNxFADoeaGN1pQl8zlp2R/K1se75dIt4Scs/kCjun0Fo6LD86p58ZzXgrl6GJKdDhbOLv8sfyY5cmJ6gc3YArPC0t2PqNkdpWOC4zZh6q9iZrbqkDv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905680; c=relaxed/simple;
	bh=oOn19yTA6ySVqXjOE1le5P4JVOG00+drbfjby6VJg4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZw+84t67cxU9oGe3Mbnv/cKb8rV3EznUUHKgjXeKgf3WGveTejO++SmWbmUEm8RJBdkDWy0rs/CFTDBpXB6jlr4kRlt9NKzDYmV1A5AWhPC9Trct6a05cYlGop48QkEjFjF6RgaZA8PLgcZ040gM8uuYfPwgI/jhicO6043ivE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLGbJYHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLGbJYHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6643BC4CEE4;
	Tue, 25 Mar 2025 12:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905680;
	bh=oOn19yTA6ySVqXjOE1le5P4JVOG00+drbfjby6VJg4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLGbJYHkpipyyyEnGV84E1GG+vUwHh7nEXDg3uClcOkx/kgFPLSeS2+nZNAn96UpM
	 PbLEa14k+L0Cpyc8swYD0kKxYe58KUMMBlUG8tRQj06r5DwWIOA8+Q8CsGZ+XdUxFL
	 VI6+on3GnRwPY2HPTfpT2wkL46em4azoZv9NnJXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 075/198] io_uring: get rid of remap_pfn_range() for mapping rings/sqes
Date: Tue, 25 Mar 2025 08:20:37 -0400
Message-ID: <20250325122158.606190957@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 3ab1db3c6039e02a9deb9d5091d28d559917a645 upstream.

Rather than use remap_pfn_range() for this and manually free later,
switch to using vm_insert_pages() and have it Just Work.

If possible, allocate a single compound page that covers the range that
is needed. If that works, then we can just use page_address() on that
page. If we fail to get a compound page, allocate single pages and use
vmap() to map them into the kernel virtual address space.

This just covers the rings/sqes, the other remaining user of the mmap
remap_pfn_range() user will be converted separately. Once that is done,
we can kill the old alloc/free code.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |    5 +
 include/uapi/linux/io_uring.h  |    1 
 io_uring/io_uring.c            |  133 ++++++++++++++++++++++++++++++++++++-----
 io_uring/io_uring.h            |    2 
 4 files changed, 125 insertions(+), 16 deletions(-)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -352,6 +352,11 @@ struct io_ring_ctx {
 	unsigned			sq_thread_idle;
 	/* protected by ->completion_lock */
 	unsigned			evfd_last_cq_tail;
+
+	unsigned short			n_ring_pages;
+	unsigned short			n_sqe_pages;
+	struct page			**ring_pages;
+	struct page			**sqe_pages;
 };
 
 enum {
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -379,6 +379,7 @@ enum {
 #define IORING_OFF_SQ_RING		0ULL
 #define IORING_OFF_CQ_RING		0x8000000ULL
 #define IORING_OFF_SQES			0x10000000ULL
+#define IORING_OFF_MMAP_MASK		0xf8000000ULL
 
 /*
  * Filled with the offset for mmap(2)
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -71,6 +71,7 @@
 #include <linux/io_uring.h>
 #include <linux/audit.h>
 #include <linux/security.h>
+#include <linux/vmalloc.h>
 #include <asm/shmparam.h>
 
 #define CREATE_TRACE_POINTS
@@ -2513,37 +2514,118 @@ static int io_cqring_wait(struct io_ring
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
 }
 
-static void io_mem_free(void *ptr)
+static void io_pages_unmap(void *ptr, struct page ***pages,
+			   unsigned short *npages)
 {
-	struct page *page;
+	bool do_vunmap = false;
 
 	if (!ptr)
 		return;
 
-	page = virt_to_head_page(ptr);
-	if (put_page_testzero(page))
-		free_compound_page(page);
+	if (*npages) {
+		struct page **to_free = *pages;
+		int i;
+
+		/*
+		 * Only did vmap for the non-compound multiple page case.
+		 * For the compound page, we just need to put the head.
+		 */
+		if (PageCompound(to_free[0]))
+			*npages = 1;
+		else if (*npages > 1)
+			do_vunmap = true;
+		for (i = 0; i < *npages; i++)
+			put_page(to_free[i]);
+	}
+	if (do_vunmap)
+		vunmap(ptr);
+	kvfree(*pages);
+	*pages = NULL;
+	*npages = 0;
 }
 
 static void io_rings_free(struct io_ring_ctx *ctx)
 {
-	io_mem_free(ctx->rings);
-	io_mem_free(ctx->sq_sqes);
+	io_pages_unmap(ctx->rings, &ctx->ring_pages, &ctx->n_ring_pages);
+	io_pages_unmap(ctx->sq_sqes, &ctx->sqe_pages, &ctx->n_sqe_pages);
 	ctx->rings = NULL;
 	ctx->sq_sqes = NULL;
 }
 
-static void *io_mem_alloc(size_t size)
+static void *io_mem_alloc_compound(struct page **pages, int nr_pages,
+				   size_t size, gfp_t gfp)
+{
+	struct page *page;
+	int i, order;
+
+	order = get_order(size);
+	if (order > 10)
+		return ERR_PTR(-ENOMEM);
+	else if (order)
+		gfp |= __GFP_COMP;
+
+	page = alloc_pages(gfp, order);
+	if (!page)
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0; i < nr_pages; i++)
+		pages[i] = page + i;
+
+	return page_address(page);
+}
+
+static void *io_mem_alloc_single(struct page **pages, int nr_pages, size_t size,
+				 gfp_t gfp)
 {
-	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
 	void *ret;
+	int i;
 
-	ret = (void *) __get_free_pages(gfp, get_order(size));
+	for (i = 0; i < nr_pages; i++) {
+		pages[i] = alloc_page(gfp);
+		if (!pages[i])
+			goto err;
+	}
+
+	ret = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
 	if (ret)
 		return ret;
+err:
+	while (i--)
+		put_page(pages[i]);
 	return ERR_PTR(-ENOMEM);
 }
 
+static void *io_pages_map(struct page ***out_pages, unsigned short *npages,
+			  size_t size)
+{
+	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
+	struct page **pages;
+	int nr_pages;
+	void *ret;
+
+	nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	pages = kvmalloc_array(nr_pages, sizeof(struct page *), gfp);
+	if (!pages)
+		return ERR_PTR(-ENOMEM);
+
+	ret = io_mem_alloc_compound(pages, nr_pages, size, gfp);
+	if (!IS_ERR(ret))
+		goto done;
+
+	ret = io_mem_alloc_single(pages, nr_pages, size, gfp);
+	if (!IS_ERR(ret)) {
+done:
+		*out_pages = pages;
+		*npages = nr_pages;
+		return ret;
+	}
+
+	kvfree(pages);
+	*out_pages = NULL;
+	*npages = 0;
+	return ret;
+}
+
 static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned int sq_entries,
 				unsigned int cq_entries, size_t *sq_offset)
 {
@@ -3125,11 +3207,9 @@ static void *io_uring_validate_mmap_requ
 	switch (offset) {
 	case IORING_OFF_SQ_RING:
 	case IORING_OFF_CQ_RING:
-		ptr = ctx->rings;
-		break;
+		return ctx->rings;
 	case IORING_OFF_SQES:
-		ptr = ctx->sq_sqes;
-		break;
+		return ctx->sq_sqes;
 	default:
 		return ERR_PTR(-EINVAL);
 	}
@@ -3141,11 +3221,22 @@ static void *io_uring_validate_mmap_requ
 	return ptr;
 }
 
+int io_uring_mmap_pages(struct io_ring_ctx *ctx, struct vm_area_struct *vma,
+			struct page **pages, int npages)
+{
+	unsigned long nr_pages = npages;
+
+	vma->vm_flags |= VM_DONTEXPAND;
+	return vm_insert_pages(vma, vma->vm_start, pages, &nr_pages);
+}
+
 #ifdef CONFIG_MMU
 
 static __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	struct io_ring_ctx *ctx = file->private_data;
 	size_t sz = vma->vm_end - vma->vm_start;
+	long offset = vma->vm_pgoff << PAGE_SHIFT;
 	unsigned long pfn;
 	void *ptr;
 
@@ -3153,6 +3244,16 @@ static __cold int io_uring_mmap(struct f
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);
 
+	switch (offset & IORING_OFF_MMAP_MASK) {
+	case IORING_OFF_SQ_RING:
+	case IORING_OFF_CQ_RING:
+		return io_uring_mmap_pages(ctx, vma, ctx->ring_pages,
+						ctx->n_ring_pages);
+	case IORING_OFF_SQES:
+		return io_uring_mmap_pages(ctx, vma, ctx->sqe_pages,
+						ctx->n_sqe_pages);
+	}
+
 	pfn = virt_to_phys(ptr) >> PAGE_SHIFT;
 	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
 }
@@ -3443,7 +3544,7 @@ static __cold int io_allocate_scq_urings
 	if (size == SIZE_MAX)
 		return -EOVERFLOW;
 
-	rings = io_mem_alloc(size);
+	rings = io_pages_map(&ctx->ring_pages, &ctx->n_ring_pages, size);
 	if (IS_ERR(rings))
 		return PTR_ERR(rings);
 
@@ -3463,7 +3564,7 @@ static __cold int io_allocate_scq_urings
 		return -EOVERFLOW;
 	}
 
-	ptr = io_mem_alloc(size);
+	ptr = io_pages_map(&ctx->sqe_pages, &ctx->n_sqe_pages, size);
 	if (IS_ERR(ptr)) {
 		io_rings_free(ctx);
 		return PTR_ERR(ptr);
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -41,6 +41,8 @@ bool io_fill_cqe_aux(struct io_ring_ctx
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
+int io_uring_mmap_pages(struct io_ring_ctx *ctx, struct vm_area_struct *vma,
+			struct page **pages, int npages);
 
 struct file *io_file_get_normal(struct io_kiocb *req, int fd);
 struct file *io_file_get_fixed(struct io_kiocb *req, int fd,


