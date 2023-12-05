Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFF86AA0;
	Tue,  5 Dec 2023 03:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tDgMpPbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA23C433C8;
	Tue,  5 Dec 2023 03:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746489;
	bh=kt5oxSxU1jyoUm4rNETTGs3elKFBfxtOXBKFLeM0MWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tDgMpPbeSHyQIPn1ux7dsY7d4HlIdTZqZpdNL7PFA0UN21k1WtSGtLBwjI7irD6Ym
	 A9pvZa2dAb3iMbdS+I/TRRw+PDu1pOT8ixbfhf/4QnyUKe8MC3oEsoT7zE1i35I99y
	 JM2OXKMjudKmFWiTKnEzO3lIy/1JyHjw75BzGcRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 042/134] io_uring: dont allow discontig pages for IORING_SETUP_NO_MMAP
Date: Tue,  5 Dec 2023 12:15:14 +0900
Message-ID: <20231205031538.207109305@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 820d070feb668aab5bc9413c285a1dda2a70e076 upstream.

io_sqes_map() is used rather than io_mem_alloc(), if the application
passes in memory for mapping rather than have the kernel allocate it and
then mmap(2) the ranges. This then calls __io_uaddr_map() to perform the
page mapping and pinning, which checks if we end up with the same pages,
if more than one page is mapped. But this check is incorrect and only
checks if the first and last pages are the same, where it really should
be checking if the mapped pages are contigous. This allows mapping a
single normal page, or a huge page range.

Down the line we can add support for remapping pages to be virtually
contigous, which is really all that io_uring cares about.

Cc: stable@vger.kernel.org
Fixes: 03d89a2de25b ("io_uring: support for user allocated memory for rings/sqes")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2690,6 +2690,7 @@ static void *__io_uaddr_map(struct page
 {
 	struct page **page_array;
 	unsigned int nr_pages;
+	void *page_addr;
 	int ret, i;
 
 	*npages = 0;
@@ -2711,27 +2712,29 @@ err:
 		io_pages_free(&page_array, ret > 0 ? ret : 0);
 		return ret < 0 ? ERR_PTR(ret) : ERR_PTR(-EFAULT);
 	}
-	/*
-	 * Should be a single page. If the ring is small enough that we can
-	 * use a normal page, that is fine. If we need multiple pages, then
-	 * userspace should use a huge page. That's the only way to guarantee
-	 * that we get contigious memory, outside of just being lucky or
-	 * (currently) having low memory fragmentation.
-	 */
-	if (page_array[0] != page_array[ret - 1])
-		goto err;
-
-	/*
-	 * Can't support mapping user allocated ring memory on 32-bit archs
-	 * where it could potentially reside in highmem. Just fail those with
-	 * -EINVAL, just like we did on kernels that didn't support this
-	 * feature.
-	 */
+
+	page_addr = page_address(page_array[0]);
 	for (i = 0; i < nr_pages; i++) {
-		if (PageHighMem(page_array[i])) {
-			ret = -EINVAL;
+		ret = -EINVAL;
+
+		/*
+		 * Can't support mapping user allocated ring memory on 32-bit
+		 * archs where it could potentially reside in highmem. Just
+		 * fail those with -EINVAL, just like we did on kernels that
+		 * didn't support this feature.
+		 */
+		if (PageHighMem(page_array[i]))
+			goto err;
+
+		/*
+		 * No support for discontig pages for now, should either be a
+		 * single normal page, or a huge page. Later on we can add
+		 * support for remapping discontig pages, for now we will
+		 * just fail them with EINVAL.
+		 */
+		if (page_address(page_array[i]) != page_addr)
 			goto err;
-		}
+		page_addr += PAGE_SIZE;
 	}
 
 	*pages = page_array;


