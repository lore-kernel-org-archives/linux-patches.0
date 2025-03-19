Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70646221D9B;
	Wed, 19 Mar 2025 14:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395229; cv=none; b=jQrBs8gQHZnOuoXjCLzccnz7Pzcc9aIRSC2+56PzUMETmF8HfbniPm7KT3urhYiYRpwR5h+HLV94fUPBQxTdueBg1Aj/PmTUnYV3avCMyZFwg3D8WbXy1h+VQIWpuNWJ7hOMcmJi0TKwFSY/yVmSxLvKQMpYM+OCsaEdbKakOhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395229; c=relaxed/simple;
	bh=LORcam1fmhKB7VPS+Ej75jVTxjAjPZoXGeG5fkBM1aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nlh7u3ky51TH5UeYoIT+dUZHXRSyo5cz04xE1+iNQrECFrfH8enT1s4AVyznkns/3DbR8SpqGDYQoQbGMgiFgQmvQ2GPTAUj4YRdtEyPPFS2jj8DBI+aoCmgY0KMDg9UKK4DM1GCPF7Q3SpFXEMemR97kT+bqf9J9rZCRMnGe64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERyQcefM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERyQcefM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFC8C4CEE9;
	Wed, 19 Mar 2025 14:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395228;
	bh=LORcam1fmhKB7VPS+Ej75jVTxjAjPZoXGeG5fkBM1aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERyQcefM7eL4zTrwjeI2GUqTe3PUVcCJkTGvAOqQlYWtlyzYsuIFk2QjdQQnKmMJe
	 DnaZwptmZ6XkwHaMX+7s5dNHKlqlDHyRglLJQsKqEmcdm0HT88ASFW/mh+yFf6EeqI
	 tjuiBRx6f6XBIEwmm2l9toijYR7ujxcvibX2NWaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 099/166] io_uring: unify io_pin_pages()
Date: Wed, 19 Mar 2025 07:31:10 -0700
Message-ID: <20250319143022.697173971@linuxfoundation.org>
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

Commit 1943f96b3816e0f0d3d6686374d6e1d617c8b42c upstream.

Move it into io_uring.c where it belongs, and use it in there as well
rather than have two implementations of this.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   61 +++++++++++++++++++++++++++++++++++-----------------
 io_uring/rsrc.c     |   39 ---------------------------------
 2 files changed, 42 insertions(+), 58 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2738,33 +2738,57 @@ static void io_pages_free(struct page **
 	*pages = NULL;
 }
 
+struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
+{
+	unsigned long start, end, nr_pages;
+	struct page **pages;
+	int ret;
+
+	end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	start = uaddr >> PAGE_SHIFT;
+	nr_pages = end - start;
+	if (WARN_ON_ONCE(!nr_pages))
+		return ERR_PTR(-EINVAL);
+
+	pages = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
+	if (!pages)
+		return ERR_PTR(-ENOMEM);
+
+	ret = pin_user_pages_fast(uaddr, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
+					pages);
+	/* success, mapped all pages */
+	if (ret == nr_pages) {
+		*npages = nr_pages;
+		return pages;
+	}
+
+	/* partial map, or didn't map anything */
+	if (ret >= 0) {
+		/* if we did partial map, release any pages we did get */
+		if (ret)
+			unpin_user_pages(pages, ret);
+		ret = -EFAULT;
+	}
+	kvfree(pages);
+	return ERR_PTR(ret);
+}
+
 static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 			    unsigned long uaddr, size_t size)
 {
 	struct page **page_array;
 	unsigned int nr_pages;
 	void *page_addr;
-	int ret, pinned;
 
 	*npages = 0;
 
 	if (uaddr & (PAGE_SIZE - 1) || !size)
 		return ERR_PTR(-EINVAL);
 
-	nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (nr_pages > USHRT_MAX)
-		return ERR_PTR(-EINVAL);
-	page_array = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
-	if (!page_array)
-		return ERR_PTR(-ENOMEM);
-
-
-	pinned = pin_user_pages_fast(uaddr, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
-				     page_array);
-	if (pinned != nr_pages) {
-		ret = (pinned < 0) ? pinned : -EFAULT;
-		goto free_pages;
-	}
+	nr_pages = 0;
+	page_array = io_pin_pages(uaddr, size, &nr_pages);
+	if (IS_ERR(page_array))
+		return page_array;
 
 	page_addr = vmap(page_array, nr_pages, VM_MAP, PAGE_KERNEL);
 	if (page_addr) {
@@ -2772,10 +2796,9 @@ static void *__io_uaddr_map(struct page
 		*npages = nr_pages;
 		return page_addr;
 	}
-	ret = -ENOMEM;
-free_pages:
-	io_pages_free(&page_array, pinned > 0 ? pinned : 0);
-	return ERR_PTR(ret);
+
+	io_pages_free(&page_array, nr_pages);
+	return ERR_PTR(-ENOMEM);
 }
 
 static void *io_rings_map(struct io_ring_ctx *ctx, unsigned long uaddr,
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -873,45 +873,6 @@ static int io_buffer_account_pin(struct
 	return ret;
 }
 
-struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
-{
-	unsigned long start, end, nr_pages;
-	struct page **pages = NULL;
-	int pret, ret = -ENOMEM;
-
-	end = (ubuf + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	start = ubuf >> PAGE_SHIFT;
-	nr_pages = end - start;
-
-	pages = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
-	if (!pages)
-		goto done;
-
-	ret = 0;
-	mmap_read_lock(current->mm);
-	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
-			      pages);
-	if (pret == nr_pages)
-		*npages = nr_pages;
-	else
-		ret = pret < 0 ? pret : -EFAULT;
-
-	mmap_read_unlock(current->mm);
-	if (ret) {
-		/* if we did partial map, release any pages we did get */
-		if (pret > 0)
-			unpin_user_pages(pages, pret);
-		goto done;
-	}
-	ret = 0;
-done:
-	if (ret < 0) {
-		kvfree(pages);
-		pages = ERR_PTR(ret);
-	}
-	return pages;
-}
-
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 				  struct io_mapped_ubuf **pimu,
 				  struct page **last_hpage)


