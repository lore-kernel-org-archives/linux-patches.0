Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3404A1F5404;
	Tue, 21 Jan 2025 18:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482574; cv=none; b=KbaVd8scwTgEY7//DrosSR5Xp7AuTe2Uspd/itHljEa+DBWKYGPr1WIvZJc3nS0l43tZFuED5fEA2vfEdpRs5SWK58eudOG2wMIsxG7jHzISmDyA6mR2BVE1aGBRgmR2ODsnoqdmXXmeyYaPj/WurYfQqrk+crsulxAg/EEqL+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482574; c=relaxed/simple;
	bh=pSHzfc3LV5aEz3xE9MkKSfOLJOCawAQA4Gh2aBMrSFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmNDsFfYr2HOjS+G5AcCdhJUMFTd/hTrEOfUmrT5kUuYb8wKbjrAxv1V163G6CLmW0kIDfiMgqJW7XppbItdVrParueihVcu18Z3pGAYSlLM0lcuUmlLJV9bs3mRVF4HBZ7Rcv9hWm0QjIYpUn1jrV5f4Ux+Hj3CUEYS5p6rLPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bffD4Uhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bffD4Uhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B108CC4CEDF;
	Tue, 21 Jan 2025 18:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482574;
	bh=pSHzfc3LV5aEz3xE9MkKSfOLJOCawAQA4Gh2aBMrSFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bffD4Uhz/zWtS2PzlQivAs8w1Qc3nvZyJ3k/p2djeto0il4yDSwDRnM5nBMb42Bkx
	 2fSGJq0KgLlIKV2P1Pfct2AdqfTPQkMWM6z9BhzXAVaO2qHNMAQzCD3W2uV26PW4XU
	 ym472cRYxotUN9uuVolnKNijSKvC8LF1gmDrchEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 098/122] selftests/mm: set allocated memory to non-zero content in cow test
Date: Tue, 21 Jan 2025 18:52:26 +0100
Message-ID: <20250121174536.809993058@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

commit a32bf5bb7933fde6f39747499f8ec232b5b5400f upstream.

After commit b1f202060afe ("mm: remap unused subpages to shared zeropage
when splitting isolated thp"), cow test cases involving swapping out THPs
via madvise(MADV_PAGEOUT) started to be skipped due to the subsequent
check via pagemap determining that the memory was not actually swapped
out.  Logs similar to this were emitted:

   ...

   # [RUN] Basic COW after fork() ... with swapped-out, PTE-mapped THP (16 kB)
   ok 2 # SKIP MADV_PAGEOUT did not work, is swap enabled?
   # [RUN] Basic COW after fork() ... with single PTE of swapped-out THP (16 kB)
   ok 3 # SKIP MADV_PAGEOUT did not work, is swap enabled?
   # [RUN] Basic COW after fork() ... with swapped-out, PTE-mapped THP (32 kB)
   ok 4 # SKIP MADV_PAGEOUT did not work, is swap enabled?

   ...

The commit in question introduces the behaviour of scanning THPs and if
their content is predominantly zero, it splits them and replaces the pages
which are wholly zero with the zero page.  These cow test cases were
getting caught up in this.

So let's avoid that by filling the contents of all allocated memory with
a non-zero value. With this in place, the tests are passing again.

Link: https://lkml.kernel.org/r/20250107142555.1870101-1-ryan.roberts@arm.com
Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/cow.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -758,7 +758,7 @@ static void do_run_with_base_page(test_f
 	}
 
 	/* Populate a base page. */
-	memset(mem, 0, pagesize);
+	memset(mem, 1, pagesize);
 
 	if (swapout) {
 		madvise(mem, pagesize, MADV_PAGEOUT);
@@ -824,12 +824,12 @@ static void do_run_with_thp(test_fn fn,
 	 * Try to populate a THP. Touch the first sub-page and test if
 	 * we get the last sub-page populated automatically.
 	 */
-	mem[0] = 0;
+	mem[0] = 1;
 	if (!pagemap_is_populated(pagemap_fd, mem + thpsize - pagesize)) {
 		ksft_test_result_skip("Did not get a THP populated\n");
 		goto munmap;
 	}
-	memset(mem, 0, thpsize);
+	memset(mem, 1, thpsize);
 
 	size = thpsize;
 	switch (thp_run) {
@@ -1012,7 +1012,7 @@ static void run_with_hugetlb(test_fn fn,
 	}
 
 	/* Populate an huge page. */
-	memset(mem, 0, hugetlbsize);
+	memset(mem, 1, hugetlbsize);
 
 	/*
 	 * We need a total of two hugetlb pages to handle COW/unsharing


