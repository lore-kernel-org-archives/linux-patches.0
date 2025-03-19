Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46678209673;
	Wed, 19 Mar 2025 14:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395226; cv=none; b=Y8mUvKsRmYH57eBmCqMbSSFZZS4om4YqB9pGgUBR03nSxoz5NHr2ymOcYNheQwbJRlopEtfC4nflk9F7a2svO8s3FZEJLzRkuC8N0SCcZpmoriDHh2mC7Qp3Ll9KRHbM0w0/pzI5VwBMhQGojRRHVVuprNs91HTY5a+2cVWiZKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395226; c=relaxed/simple;
	bh=oY6/Zqx23rB88P1KfNzghJBOFccp18xXESiUtdaZMUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtabvLD4cl1tyMIVhzQqxOfJqnKNRY6AsYACn3DcI3/kL/I92iR3+R7t8htZgfVAiMYIlfUG4cicYAMoaBHD8JoZ+jNnFAI7pqeoOgDEMt3FrMruRtR0J4Ki44mJP8yz4kmzjVWZhalISro0aldgEkKDffWfT+8Yj8tRkieP91k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdiDS5L/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdiDS5L/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF33C4CEE4;
	Wed, 19 Mar 2025 14:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395226;
	bh=oY6/Zqx23rB88P1KfNzghJBOFccp18xXESiUtdaZMUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdiDS5L/X5qJnsOjSTOukli6sCvyeTUxYF/bXwb1tgsBoljD+c/kTNO4FzVAh1FE0
	 IGFkYt3KN+WOhjN3tjV3fX8uu5Cc2LUJitd1C+9msn9W/Col2M51lY+sijoh2PhzTc
	 IhVWXQM8bF3q8jfLvjL3wPdxcLGLtLsQEqpIfu0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 095/166] io_uring: get rid of remap_pfn_range() for mapping rings/sqes
Date: Wed, 19 Mar 2025 07:31:06 -0700
Message-ID: <20250319143022.593793636@linuxfoundation.org>
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
 io_uring/io_uring.c |  139 +++++++++++++++++++++++++++++++++++++++++++++++++---
 io_uring/io_uring.h |    2 
 2 files changed, 133 insertions(+), 8 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2683,6 +2683,36 @@ static int io_cqring_wait(struct io_ring
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
 }
 
+static void io_pages_unmap(void *ptr, struct page ***pages,
+			   unsigned short *npages)
+{
+	bool do_vunmap = false;
+
+	if (!ptr)
+		return;
+
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
+}
+
 void io_mem_free(void *ptr)
 {
 	if (!ptr)
@@ -2787,8 +2817,8 @@ static void *io_sqes_map(struct io_ring_
 static void io_rings_free(struct io_ring_ctx *ctx)
 {
 	if (!(ctx->flags & IORING_SETUP_NO_MMAP)) {
-		io_mem_free(ctx->rings);
-		io_mem_free(ctx->sq_sqes);
+		io_pages_unmap(ctx->rings, &ctx->ring_pages, &ctx->n_ring_pages);
+		io_pages_unmap(ctx->sq_sqes, &ctx->sqe_pages, &ctx->n_sqe_pages);
 	} else {
 		io_pages_free(&ctx->ring_pages, ctx->n_ring_pages);
 		ctx->n_ring_pages = 0;
@@ -2800,6 +2830,80 @@ static void io_rings_free(struct io_ring
 	ctx->sq_sqes = NULL;
 }
 
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
+{
+	void *ret;
+	int i;
+
+	for (i = 0; i < nr_pages; i++) {
+		pages[i] = alloc_page(gfp);
+		if (!pages[i])
+			goto err;
+	}
+
+	ret = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
+	if (ret)
+		return ret;
+err:
+	while (i--)
+		put_page(pages[i]);
+	return ERR_PTR(-ENOMEM);
+}
+
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
 void *io_mem_alloc(size_t size)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
@@ -3463,14 +3567,12 @@ static void *io_uring_validate_mmap_requ
 		/* Don't allow mmap if the ring was setup without it */
 		if (ctx->flags & IORING_SETUP_NO_MMAP)
 			return ERR_PTR(-EINVAL);
-		ptr = ctx->rings;
-		break;
+		return ctx->rings;
 	case IORING_OFF_SQES:
 		/* Don't allow mmap if the ring was setup without it */
 		if (ctx->flags & IORING_SETUP_NO_MMAP)
 			return ERR_PTR(-EINVAL);
-		ptr = ctx->sq_sqes;
-		break;
+		return ctx->sq_sqes;
 	case IORING_OFF_PBUF_RING: {
 		struct io_buffer_list *bl;
 		unsigned int bgid;
@@ -3494,11 +3596,22 @@ static void *io_uring_validate_mmap_requ
 	return ptr;
 }
 
+int io_uring_mmap_pages(struct io_ring_ctx *ctx, struct vm_area_struct *vma,
+			struct page **pages, int npages)
+{
+	unsigned long nr_pages = npages;
+
+	vm_flags_set(vma, VM_DONTEXPAND);
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
 
@@ -3506,6 +3619,16 @@ static __cold int io_uring_mmap(struct f
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
@@ -3795,7 +3918,7 @@ static __cold int io_allocate_scq_urings
 		return -EOVERFLOW;
 
 	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
-		rings = io_mem_alloc(size);
+		rings = io_pages_map(&ctx->ring_pages, &ctx->n_ring_pages, size);
 	else
 		rings = io_rings_map(ctx, p->cq_off.user_addr, size);
 
@@ -3820,7 +3943,7 @@ static __cold int io_allocate_scq_urings
 	}
 
 	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
-		ptr = io_mem_alloc(size);
+		ptr = io_pages_map(&ctx->sqe_pages, &ctx->n_sqe_pages, size);
 	else
 		ptr = io_sqes_map(ctx, p->sq_off.user_addr, size);
 
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -55,6 +55,8 @@ bool io_fill_cqe_req_aux(struct io_kiocb
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
+int io_uring_mmap_pages(struct io_ring_ctx *ctx, struct vm_area_struct *vma,
+			struct page **pages, int npages);
 
 struct file *io_file_get_normal(struct io_kiocb *req, int fd);
 struct file *io_file_get_fixed(struct io_kiocb *req, int fd,


