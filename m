Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FE11DF270;
	Wed, 19 Mar 2025 14:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395228; cv=none; b=nmVTq37Q+e70DKFzAcECz6/ZI6Vs0IGnSHATiR4l6kpqX68hoarpnhLxGtBnTf5JAGhyV4y3cDf1BCTXcRdTuh8iqsEqIYTGZ7y4XTs1kyY4EdOVjByOZMQBuK78R5Eh2IjbCk7pARJZwxj/+vVC5EugYeHTmksDg4ix6l2RVjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395228; c=relaxed/simple;
	bh=t2E6tqYUVNUO7d6UbMi16CEqU/FHVT5OhQdbFI8HCoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDtSGfc2MEU8mq3Gzi7oCMc5LurZ89xS3LT5KlhLhdNsEvFQidx5WHH7sHyaILLp228w3txIqXLw6CsQsqzfre8Dzb0GOkQwBgLnVIsu9NAjl/wvseFcScVdBX4IXNgswn97ghnkOgka03hxg09vRvlq7tuJqeymmEyESqVdKso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aOQZ7lUn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aOQZ7lUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22925C4CEE4;
	Wed, 19 Mar 2025 14:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395228;
	bh=t2E6tqYUVNUO7d6UbMi16CEqU/FHVT5OhQdbFI8HCoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aOQZ7lUnUaZUkaBp20ApCBdbYhFrpyw8A4a6laG2VMyDtCZSMRZ/RkARfmoOSA3R2
	 glNmibdP/WYm+Mu5CqYwiNULMjEZFXpK4Wya9qX3OxIYCXn9YwIITk4C/9X8ovnzCw
	 pmnED2WZvNCbV1pA1Xm5nqp3qYe71Oc1SwAHLGvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 098/166] io_uring: use vmap() for ring mapping
Date: Wed, 19 Mar 2025 07:31:09 -0700
Message-ID: <20250319143022.670590107@linuxfoundation.org>
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

Commit 09fc75e0c035a2cabb8caa15cec6e85159dd94f0 upstream.

This is the last holdout which does odd page checking, convert it to
vmap just like what is done for the non-mmap path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   38 +++++++++-----------------------------
 1 file changed, 9 insertions(+), 29 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -64,7 +64,6 @@
 #include <linux/sched/mm.h>
 #include <linux/uaccess.h>
 #include <linux/nospec.h>
-#include <linux/highmem.h>
 #include <linux/fsnotify.h>
 #include <linux/fadvise.h>
 #include <linux/task_work.h>
@@ -2745,7 +2744,7 @@ static void *__io_uaddr_map(struct page
 	struct page **page_array;
 	unsigned int nr_pages;
 	void *page_addr;
-	int ret, i, pinned;
+	int ret, pinned;
 
 	*npages = 0;
 
@@ -2767,34 +2766,13 @@ static void *__io_uaddr_map(struct page
 		goto free_pages;
 	}
 
-	page_addr = page_address(page_array[0]);
-	for (i = 0; i < nr_pages; i++) {
-		ret = -EINVAL;
-
-		/*
-		 * Can't support mapping user allocated ring memory on 32-bit
-		 * archs where it could potentially reside in highmem. Just
-		 * fail those with -EINVAL, just like we did on kernels that
-		 * didn't support this feature.
-		 */
-		if (PageHighMem(page_array[i]))
-			goto free_pages;
-
-		/*
-		 * No support for discontig pages for now, should either be a
-		 * single normal page, or a huge page. Later on we can add
-		 * support for remapping discontig pages, for now we will
-		 * just fail them with EINVAL.
-		 */
-		if (page_address(page_array[i]) != page_addr)
-			goto free_pages;
-		page_addr += PAGE_SIZE;
+	page_addr = vmap(page_array, nr_pages, VM_MAP, PAGE_KERNEL);
+	if (page_addr) {
+		*pages = page_array;
+		*npages = nr_pages;
+		return page_addr;
 	}
-
-	*pages = page_array;
-	*npages = nr_pages;
-	return page_to_virt(page_array[0]);
-
+	ret = -ENOMEM;
 free_pages:
 	io_pages_free(&page_array, pinned > 0 ? pinned : 0);
 	return ERR_PTR(ret);
@@ -2824,6 +2802,8 @@ static void io_rings_free(struct io_ring
 		ctx->n_ring_pages = 0;
 		io_pages_free(&ctx->sqe_pages, ctx->n_sqe_pages);
 		ctx->n_sqe_pages = 0;
+		vunmap(ctx->rings);
+		vunmap(ctx->sq_sqes);
 	}
 
 	ctx->rings = NULL;


