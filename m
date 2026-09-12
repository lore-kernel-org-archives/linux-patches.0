Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758E3360EE9;
	Sat, 12 Sep 2026 15:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226207; cv=none; b=tuutkBCh1tnlcXkhM8zBXi88CtsWfAmeHTsOXAUXhgycc5vmaW0Kg8R1bp4dZ2YZy5PVP6J1kQql3YyKqxBCBJoXsuHsvTNuXM96oa1bdpDi6cXH2Qa1movUfGs98WcCSrCL00o1B9IC5sdj5GYkPtqWTP9qUJCWCn4eSji+V5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226207; c=relaxed/simple;
	bh=SG2uNWPw+5pOywSkDnoNQbkKWjB0nIbYwfPq5iD7tvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWZKdZB4we+IAjrnUoLuAv1XpdNGv7AefbUKxqWtLOrXbUQllDbWmBgqXPCbEvviU/9rP7zgySeoFW+TumNA35o2iVACLNs+CNMLZACsEuQ7hneJVNdKaCHidod82j1lzpx3qKNLBFcwQPzmreeQpxRJ5m8t4bUJ6YDQFvMLME4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bxGuduL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bxGuduL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759271F000FF;
	Sat, 12 Sep 2026 15:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226204;
	bh=5KszvjJKpor0bw0zKxZzqoh4wZF1PbOduYkb5VVvpww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1bxGuduLZ5r00A3KXOaNnrr9eXt9fHZdXcE+4dgY23BHvDoTZ874/TjWmEfVnbtTH
	 T9BO/uDcZXznInm83UGXVzzC5B4HzDbJS+IhQFnQVdfjHqmnju5tJYWxm7MnGADcWP
	 yRlTVB62SlmA8/Coj+RT/E+ooJiV5L8rIBwo9pTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Barry Song <v-songbaohua@oppo.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Rientjes <rientjes@google.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Hugh Dickins <hughd@google.com>,
	Itaru Kitayama <itaru.kitayama@gmail.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yang Shi <shy828301@gmail.com>,
	Yin Fengwei <fengwei.yin@intel.com>,
	Yu Zhao <yuzhao@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1354/1424] selftests/mm/cow: generalize do_run_with_thp() helper
Date: Sat, 12 Sep 2026 09:03:06 +0200
Message-ID: <20260912065637.584596475@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

[ Upstream commit 12dc16b38463a671bc91dc2df10f3a014a27ff3b ]

do_run_with_thp() prepares (PMD-sized) THP memory into different states
before running tests.  With the introduction of multi-size THP, we would
like to reuse this logic to also test those smaller THP sizes.  So let's
add a thpsize parameter which tells the function what size THP it should
operate on.

A separate commit will utilize this change to add new tests for multi-size
THP, where available.

Link: https://lkml.kernel.org/r/20231207161211.2374093-10-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 4004c130c358 ("selftests/mm: skip COW tmpfile cases when fallocate() is unsupported")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/cow.c | 121 +++++++++++++++++--------------
 1 file changed, 67 insertions(+), 54 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 76d37904172db..a49b0a0ecf58e 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -32,7 +32,7 @@
 
 static size_t pagesize;
 static int pagemap_fd;
-static size_t thpsize;
+static size_t pmdsize;
 static int nr_hugetlbsizes;
 static size_t hugetlbsizes[10];
 static int gup_fd;
@@ -734,7 +734,7 @@ enum thp_run {
 	THP_RUN_PARTIAL_SHARED,
 };
 
-static void do_run_with_thp(test_fn fn, enum thp_run thp_run)
+static void do_run_with_thp(test_fn fn, enum thp_run thp_run, size_t thpsize)
 {
 	char *mem, *mmap_mem, *tmp, *mremap_mem = MAP_FAILED;
 	size_t size, mmap_size, mremap_size;
@@ -759,11 +759,11 @@ static void do_run_with_thp(test_fn fn, enum thp_run thp_run)
 	}
 
 	/*
-	 * Try to populate a THP. Touch the first sub-page and test if we get
-	 * another sub-page populated automatically.
+	 * Try to populate a THP. Touch the first sub-page and test if
+	 * we get the last sub-page populated automatically.
 	 */
 	mem[0] = 0;
-	if (!pagemap_is_populated(pagemap_fd, mem + pagesize)) {
+	if (!pagemap_is_populated(pagemap_fd, mem + thpsize - pagesize)) {
 		ksft_test_result_skip("Did not get a THP populated\n");
 		goto munmap;
 	}
@@ -773,12 +773,14 @@ static void do_run_with_thp(test_fn fn, enum thp_run thp_run)
 	switch (thp_run) {
 	case THP_RUN_PMD:
 	case THP_RUN_PMD_SWAPOUT:
+		assert(thpsize == pmdsize);
 		break;
 	case THP_RUN_PTE:
 	case THP_RUN_PTE_SWAPOUT:
 		/*
 		 * Trigger PTE-mapping the THP by temporarily mapping a single
-		 * subpage R/O.
+		 * subpage R/O. This is a noop if the THP is not pmdsize (and
+		 * therefore already PTE-mapped).
 		 */
 		ret = mprotect(mem + pagesize, pagesize, PROT_READ);
 		if (ret) {
@@ -875,52 +877,60 @@ static void do_run_with_thp(test_fn fn, enum thp_run thp_run)
 		munmap(mremap_mem, mremap_size);
 }
 
-static void run_with_thp(test_fn fn, const char *desc)
+static void run_with_thp(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PMD);
+	ksft_print_msg("[RUN] %s ... with THP (%zu kB)\n",
+		desc, size / 1024);
+	do_run_with_thp(fn, THP_RUN_PMD, size);
 }
 
-static void run_with_thp_swap(test_fn fn, const char *desc)
+static void run_with_thp_swap(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with swapped-out THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PMD_SWAPOUT);
+	ksft_print_msg("[RUN] %s ... with swapped-out THP (%zu kB)\n",
+		desc, size / 1024);
+	do_run_with_thp(fn, THP_RUN_PMD_SWAPOUT, size);
 }
 
-static void run_with_pte_mapped_thp(test_fn fn, const char *desc)
+static void run_with_pte_mapped_thp(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with PTE-mapped THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PTE);
+	ksft_print_msg("[RUN] %s ... with PTE-mapped THP (%zu kB)\n",
+		desc, size / 1024);
+	do_run_with_thp(fn, THP_RUN_PTE, size);
 }
 
-static void run_with_pte_mapped_thp_swap(test_fn fn, const char *desc)
+static void run_with_pte_mapped_thp_swap(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with swapped-out, PTE-mapped THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PTE_SWAPOUT);
+	ksft_print_msg("[RUN] %s ... with swapped-out, PTE-mapped THP (%zu kB)\n",
+		desc, size / 1024);
+	do_run_with_thp(fn, THP_RUN_PTE_SWAPOUT, size);
 }
 
-static void run_with_single_pte_of_thp(test_fn fn, const char *desc)
+static void run_with_single_pte_of_thp(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with single PTE of THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_SINGLE_PTE);
+	ksft_print_msg("[RUN] %s ... with single PTE of THP (%zu kB)\n",
+		desc, size / 1024);
+	do_run_with_thp(fn, THP_RUN_SINGLE_PTE, size);
 }
 
-static void run_with_single_pte_of_thp_swap(test_fn fn, const char *desc)
+static void run_with_single_pte_of_thp_swap(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with single PTE of swapped-out THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_SINGLE_PTE_SWAPOUT);
+	ksft_print_msg("[RUN] %s ... with single PTE of swapped-out THP (%zu kB)\n",
+		desc, size / 1024);
+	do_run_with_thp(fn, THP_RUN_SINGLE_PTE_SWAPOUT, size);
 }
 
-static void run_with_partial_mremap_thp(test_fn fn, const char *desc)
+static void run_with_partial_mremap_thp(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with partially mremap()'ed THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PARTIAL_MREMAP);
+	ksft_print_msg("[RUN] %s ... with partially mremap()'ed THP (%zu kB)\n",
+		desc, size / 1024);
+	do_run_with_thp(fn, THP_RUN_PARTIAL_MREMAP, size);
 }
 
-static void run_with_partial_shared_thp(test_fn fn, const char *desc)
+static void run_with_partial_shared_thp(test_fn fn, const char *desc, size_t size)
 {
-	ksft_print_msg("[RUN] %s ... with partially shared THP\n", desc);
-	do_run_with_thp(fn, THP_RUN_PARTIAL_SHARED);
+	ksft_print_msg("[RUN] %s ... with partially shared THP (%zu kB)\n",
+		desc, size / 1024);
+	do_run_with_thp(fn, THP_RUN_PARTIAL_SHARED, size);
 }
 
 static void run_with_hugetlb(test_fn fn, const char *desc, size_t hugetlbsize)
@@ -1091,15 +1101,15 @@ static void run_anon_test_case(struct test_case const *test_case)
 
 	run_with_base_page(test_case->fn, test_case->desc);
 	run_with_base_page_swap(test_case->fn, test_case->desc);
-	if (thpsize) {
-		run_with_thp(test_case->fn, test_case->desc);
-		run_with_thp_swap(test_case->fn, test_case->desc);
-		run_with_pte_mapped_thp(test_case->fn, test_case->desc);
-		run_with_pte_mapped_thp_swap(test_case->fn, test_case->desc);
-		run_with_single_pte_of_thp(test_case->fn, test_case->desc);
-		run_with_single_pte_of_thp_swap(test_case->fn, test_case->desc);
-		run_with_partial_mremap_thp(test_case->fn, test_case->desc);
-		run_with_partial_shared_thp(test_case->fn, test_case->desc);
+	if (pmdsize) {
+		run_with_thp(test_case->fn, test_case->desc, pmdsize);
+		run_with_thp_swap(test_case->fn, test_case->desc, pmdsize);
+		run_with_pte_mapped_thp(test_case->fn, test_case->desc, pmdsize);
+		run_with_pte_mapped_thp_swap(test_case->fn, test_case->desc, pmdsize);
+		run_with_single_pte_of_thp(test_case->fn, test_case->desc, pmdsize);
+		run_with_single_pte_of_thp_swap(test_case->fn, test_case->desc, pmdsize);
+		run_with_partial_mremap_thp(test_case->fn, test_case->desc, pmdsize);
+		run_with_partial_shared_thp(test_case->fn, test_case->desc, pmdsize);
 	}
 	for (i = 0; i < nr_hugetlbsizes; i++)
 		run_with_hugetlb(test_case->fn, test_case->desc,
@@ -1120,7 +1130,7 @@ static int tests_per_anon_test_case(void)
 {
 	int tests = 2 + nr_hugetlbsizes;
 
-	if (thpsize)
+	if (pmdsize)
 		tests += 8;
 	return tests;
 }
@@ -1329,7 +1339,7 @@ static void run_anon_thp_test_cases(void)
 {
 	int i;
 
-	if (!thpsize)
+	if (!pmdsize)
 		return;
 
 	ksft_print_msg("[INFO] Anonymous THP tests\n");
@@ -1338,13 +1348,13 @@ static void run_anon_thp_test_cases(void)
 		struct test_case const *test_case = &anon_thp_test_cases[i];
 
 		ksft_print_msg("[RUN] %s\n", test_case->desc);
-		do_run_with_thp(test_case->fn, THP_RUN_PMD);
+		do_run_with_thp(test_case->fn, THP_RUN_PMD, pmdsize);
 	}
 }
 
 static int tests_per_anon_thp_test_case(void)
 {
-	return thpsize ? 1 : 0;
+	return pmdsize ? 1 : 0;
 }
 
 typedef void (*non_anon_test_fn)(char *mem, const char *smem, size_t size);
@@ -1419,7 +1429,7 @@ static void run_with_huge_zeropage(non_anon_test_fn fn, const char *desc)
 	}
 
 	/* For alignment purposes, we need twice the thp size. */
-	mmap_size = 2 * thpsize;
+	mmap_size = 2 * pmdsize;
 	mmap_mem = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
 			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	if (mmap_mem == MAP_FAILED) {
@@ -1434,11 +1444,11 @@ static void run_with_huge_zeropage(non_anon_test_fn fn, const char *desc)
 	}
 
 	/* We need a THP-aligned memory area. */
-	mem = (char *)(((uintptr_t)mmap_mem + thpsize) & ~(thpsize - 1));
-	smem = (char *)(((uintptr_t)mmap_smem + thpsize) & ~(thpsize - 1));
+	mem = (char *)(((uintptr_t)mmap_mem + pmdsize) & ~(pmdsize - 1));
+	smem = (char *)(((uintptr_t)mmap_smem + pmdsize) & ~(pmdsize - 1));
 
-	ret = madvise(mem, thpsize, MADV_HUGEPAGE);
-	ret |= madvise(smem, thpsize, MADV_HUGEPAGE);
+	ret = madvise(mem, pmdsize, MADV_HUGEPAGE);
+	ret |= madvise(smem, pmdsize, MADV_HUGEPAGE);
 	if (ret) {
 		ksft_test_result_fail("MADV_HUGEPAGE failed\n");
 		goto munmap;
@@ -1457,7 +1467,7 @@ static void run_with_huge_zeropage(non_anon_test_fn fn, const char *desc)
 		goto munmap;
 	}
 
-	fn(mem, smem, thpsize);
+	fn(mem, smem, pmdsize);
 munmap:
 	munmap(mmap_mem, mmap_size);
 	if (mmap_smem != MAP_FAILED)
@@ -1650,7 +1660,7 @@ static void run_non_anon_test_case(struct non_anon_test_case const *test_case)
 	run_with_zeropage(test_case->fn, test_case->desc);
 	run_with_memfd(test_case->fn, test_case->desc);
 	run_with_tmpfile(test_case->fn, test_case->desc);
-	if (thpsize)
+	if (pmdsize)
 		run_with_huge_zeropage(test_case->fn, test_case->desc);
 	for (i = 0; i < nr_hugetlbsizes; i++)
 		run_with_memfd_hugetlb(test_case->fn, test_case->desc,
@@ -1671,7 +1681,7 @@ static int tests_per_non_anon_test_case(void)
 {
 	int tests = 3 + nr_hugetlbsizes;
 
-	if (thpsize)
+	if (pmdsize)
 		tests += 1;
 	return tests;
 }
@@ -1683,10 +1693,13 @@ int main(int argc, char **argv)
 	ksft_print_header();
 
 	pagesize = getpagesize();
-	thpsize = read_pmd_pagesize();
-	if (thpsize)
+	pmdsize = read_pmd_pagesize();
+	if (pmdsize) {
+		ksft_print_msg("[INFO] detected PMD size: %zu KiB\n",
+			       pmdsize / 1024);
 		ksft_print_msg("[INFO] detected THP size: %zu KiB\n",
-			       thpsize / 1024);
+			       pmdsize / 1024);
+	}
 	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
 						    ARRAY_SIZE(hugetlbsizes));
 	detect_huge_zeropage();
-- 
2.53.0



