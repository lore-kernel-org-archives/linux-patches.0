Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02D5266B6C;
	Tue, 25 Mar 2025 12:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905682; cv=none; b=GE62YQGfRJkVQqTUDo9TRCIEGP5VaA7QVhVWZ5W6aH3GusVWdEynnDPnwg3Xa8rz9gOOFjgRHgfYuvuYELsqVgE2cILVHTCfo44VdGXkf2aFbbDUz095TPBRMbszccfEUlPuoN8M6L5dAETPSgqUCc+1xnWR2E6IqLsd4A7Jz5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905682; c=relaxed/simple;
	bh=icPh597X6mjC+ltNedFPq9LM7XMx40tpWD4DO8RZOHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SfumU4B9AfhL54I8bce4BzQwBJYoCl5+gyZb+s+tJRlOqX60Bz2RQajJJWE4idPsqVi44XzGqKJTO8pttlARjGe1ygFasR6MnKhT+JRDJmTYpr6Hn9uS31TjKClIHDDAI6RWMCvxutXiqjiFhsDod/SR12XAY6BY2nahhO8bPGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/dTx+aB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/dTx+aB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A69C4CEE4;
	Tue, 25 Mar 2025 12:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905682;
	bh=icPh597X6mjC+ltNedFPq9LM7XMx40tpWD4DO8RZOHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/dTx+aBmbgXFlCmXT2EKR6UdkzKG3V7ZdmdfnJo0dNOjwiUiqmbnB3rvD7hKsYRr
	 ywyk5sdp7DwK+HKxf0AM6qhAPhpakOdCqbLt1XyotZixvuw5qZw6XsNvZ2CPOv1RVd
	 VkI6odqWKj3PuOSTiTsHHSaaUgHhjneMU5zT9eT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Lucas=20M=C3=BClling?= <lmulling@proton.me>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 076/198] io_uring: dont attempt to mmap larger than what the user asks for
Date: Tue, 25 Mar 2025 08:20:38 -0400
Message-ID: <20250325122158.631004052@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3237,6 +3237,7 @@ static __cold int io_uring_mmap(struct f
 	struct io_ring_ctx *ctx = file->private_data;
 	size_t sz = vma->vm_end - vma->vm_start;
 	long offset = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned int npages;
 	unsigned long pfn;
 	void *ptr;
 
@@ -3247,8 +3248,8 @@ static __cold int io_uring_mmap(struct f
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


