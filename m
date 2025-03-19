Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F045B221D99;
	Wed, 19 Mar 2025 14:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395227; cv=none; b=hGZsZhS4ot2HpFCORsBsje2oWI47R+D9R1oy9ThG9CbtPbC9meNKGp0kHsVxpTqzFVBkE7kfEid9VO6UogL+WdM+j8NW4qzLe4OO7RgcI/6Sq5X0unooJp2AeEPznvP9SuSP/m/BQ4c84gc1ouSVHVItlbpTaSL9jnFygIr78fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395227; c=relaxed/simple;
	bh=/5wrQ/5Ake+QZoGaPxda7JPJY9Luq2AMDg4AApmPcOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sBw5jngTIgFTtbVYNbiiuc8b8+QZMjJ2ELhQ+U/uI6/jafYM1cROSNxK/rc29QRMvnoqx4tc62Q9HL9Ct4hmRQ9MLlf+Gi9/L1CIBiUO1bAbP9WrK4cGqG07cd77nmBWclsHxkhSg35whdoGIAeJ/Z8wq0h0V0NDNcVNZojEg2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLpJuI/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLpJuI/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBE7C4CEE4;
	Wed, 19 Mar 2025 14:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395226;
	bh=/5wrQ/5Ake+QZoGaPxda7JPJY9Luq2AMDg4AApmPcOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLpJuI/pp2sTMk07XA5dCOGlaeNJeOHMBC4/3MjBs0rQik44HzFUp4MrpclKqMTaK
	 404JIjt6hPlEfVclhrt5YLzydaS9GEImnigE2Yts5heyafk6bsbuq2N6aJm9DPvrt2
	 oZGSm9H5YS71NAn0A0T24ZqGaVgg1Y+0j5Q2lEvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Lucas=20M=C3=BClling?= <lmulling@proton.me>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 096/166] io_uring: dont attempt to mmap larger than what the user asks for
Date: Wed, 19 Mar 2025 07:31:07 -0700
Message-ID: <20250319143022.619456600@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 06fe9b1df1086b42718d632aa57e8f7cd1a66a21 upstream.

If IORING_FEAT_SINGLE_MMAP is ignored, as can happen if an application
uses an ancient liburing or does setup manually, then 3 mmap's are
required to map the ring into userspace. The kernel will still have
collapsed the mappings, however userspace may ask for mapping them
individually. If so, then we should not use the full number of ring
pages, as it may exceed the partial mapping. Doing so will yield an
-EFAULT from vm_insert_pages(), as we pass in more pages than what the
application asked for.

Cap the number of pages to match what the application asked for, for
the particular mapping operation.

Reported-by: Lucas Mülling <lmulling@proton.me>
Link: https://github.com/axboe/liburing/issues/1157
Fixes: 3ab1db3c6039 ("io_uring: get rid of remap_pfn_range() for mapping rings/sqes")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3612,6 +3612,7 @@ static __cold int io_uring_mmap(struct f
 	struct io_ring_ctx *ctx = file->private_data;
 	size_t sz = vma->vm_end - vma->vm_start;
 	long offset = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned int npages;
 	unsigned long pfn;
 	void *ptr;
 
@@ -3622,8 +3623,8 @@ static __cold int io_uring_mmap(struct f
 	switch (offset & IORING_OFF_MMAP_MASK) {
 	case IORING_OFF_SQ_RING:
 	case IORING_OFF_CQ_RING:
-		return io_uring_mmap_pages(ctx, vma, ctx->ring_pages,
-						ctx->n_ring_pages);
+		npages = min(ctx->n_ring_pages, (sz + PAGE_SIZE - 1) >> PAGE_SHIFT);
+		return io_uring_mmap_pages(ctx, vma, ctx->ring_pages, npages);
 	case IORING_OFF_SQES:
 		return io_uring_mmap_pages(ctx, vma, ctx->sqe_pages,
 						ctx->n_sqe_pages);


