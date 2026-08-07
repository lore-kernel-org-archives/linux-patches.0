Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DED47604A;
	Fri,  7 Aug 2026 15:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117280; cv=none; b=N7U/cuslR2Ta64r54ZzZtYpJUstyKhnV1OHP4s4ds8gLli2ZKodffQfvlOn8KduDKgF4v/NJEhLSi1Wp5N10TDD3LdZNYAtf4ZQ6L6NTtbxZ7wHx/6s7mo/B2U+kohrAv0RCmSUIcXaMLp7X+d1H/TpWY2A1YGNBty9eaPDmhaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117280; c=relaxed/simple;
	bh=3Z054E3gWDczjXVc+/RnQtX3yyg3ZB2m40Gwwpaz4h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DB+n7iZKed3mGv0rsDqqc54goka4b+0MxQF67JnkHGbaHbpgsM+xddmmdWBhZWz7G6XEizaO/NWJOk5ahQmO8zkbhQTE0ZY5oxgLucobaTlkkaH2tRJeCpV0HtYkq5g4hPLOJS+8mwQJvJYa/6ltM9yC1CWc0IJwqAIZR8A7l/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2wKxokCC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2wKxokCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4081F000E9;
	Fri,  7 Aug 2026 15:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117278;
	bh=kqLSKqRFnfkuIPq7/9NZcR6WeDTbTusQXO/tSWLgXDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2wKxokCC8MvD9eX1twtkdiZiAGW9Fs+2W+4kfds9r1FxpCjDP1Eu4kcefRycrgCPq
	 H52ZpOvC3ks1DOFxUXGBxAb4aUxVGh6NFFwNXSOVNIqcNEVKT7P9pE2t5j1JP/pqAn
	 cmFQyzS3arVWHJo+PgNi8niH3D+y4bUARbTvhx5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiryl Shutsemau <kas@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	David Hildenbrand <david@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 218/438] fs/proc/task_mmu: fix PAGEMAP_SCAN written state for unpopulated ptes
Date: Fri,  7 Aug 2026 16:36:54 +0200
Message-ID: <20260807143432.657153775@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiryl Shutsemau (Meta) <kas@kernel.org>

commit 07b4377bdbe74a3ec0c8da5849d014f70e003384 upstream.

PAGEMAP_SCAN reports an unpopulated pte differently depending on which
path serves the request.  The PAGE_IS_WRITTEN fast path in
pagemap_scan_pmd_entry() reports a pte_none as written (and, under
PM_SCAN_WP_MATCHING, arms a marker); pagemap_page_category() returns 0 for
the same pte_none.  A request that cannot take the fast path (an extra
category bit, category_anyof_mask or category_inverted) therefore reports
the pte as clean and skips arming it.

A range that was populated and then MADV_DONTNEED'd reads as written via
one mask and clean via another, and in the latter case is not re-armed for
the next round -- an incremental-dump consumer (e.g.  CRIU) using a richer
mask drops the zapped range and stops tracking writes to it.

Report pte_none as written in pagemap_page_category() too.  A pte_none
carries no uffd-wp marker, i.e.  it is not write-protected -- the same
condition under which the present and swap cases already report
PAGE_IS_WRITTEN.  The fast path applies no VMA test, so neither does this.

The hugetlb and fully-unpopulated-PMD (no page table) scans have no
PAGE_IS_WRITTEN fast path, so they do not exhibit the per-entry divergence
and are left unchanged.

Add a pagemap_ioctl selftest that populates a range, drops it with
MADV_DONTNEED, and checks that the fast path and the generic
(category_anyof_mask) path both report every page written.

Link: https://lore.kernel.org/20260707151349.92143-1-kirill@shutemov.name
Fixes: 12f6b01a0bcb ("fs/proc/task_mmu: add fast paths to get/clear PAGE_IS_WRITTEN flag")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Assisted-by: Claude:claude-fable-5
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c                         |   14 ++++++-
 tools/testing/selftests/mm/pagemap_ioctl.c |   56 ++++++++++++++++++++++++++++-
 2 files changed, 67 insertions(+), 3 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2345,8 +2345,18 @@ static unsigned long pagemap_page_catego
 {
 	unsigned long categories;
 
-	if (pte_none(pte))
-		return 0;
+	if (pte_none(pte)) {
+		/*
+		 * An unpopulated pte carries no uffd-wp marker, i.e. it is not
+		 * write-protected, the same condition under which the present
+		 * and swap cases below report PAGE_IS_WRITTEN. Report it here
+		 * too so this generic path agrees with the PAGE_IS_WRITTEN fast
+		 * path in pagemap_scan_pmd_entry(), which reports pte_none as
+		 * written and, under PM_SCAN_WP_MATCHING, arms a marker. The
+		 * fast path applies no VMA test, so neither does this.
+		 */
+		return PAGE_IS_WRITTEN;
+	}
 
 	if (pte_present(pte)) {
 		struct page *page;
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1049,6 +1049,57 @@ static void test_simple(void)
 	ksft_test_result(i == TEST_ITERATIONS, "Test %s\n", __func__);
 }
 
+/*
+ * A range that was populated and then MADV_DONTNEED'd is genuine pte_none
+ * with no uffd-wp marker. Such a pte must read the same regardless of which
+ * PAGEMAP_SCAN path serves the request: both the PAGE_IS_WRITTEN fast path and
+ * the generic path (reached e.g. via category_anyof_mask) must report every
+ * page written.
+ */
+static void unpopulated_scan_test(void)
+{
+	int npages = 16, i;
+	long mem_size = npages * page_size;
+	struct page_region regions[16];
+	long fast = 0, slow = 0, ret;
+	char *mem;
+
+	mem = mmap(NULL, mem_size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mem == MAP_FAILED)
+		ksft_exit_fail_msg("%s mmap failed\n", __func__);
+
+	wp_init(mem, mem_size);
+
+	/* Populate, then drop: the ptes become pte_none without a marker. */
+	memset(mem, 1, mem_size);
+	if (madvise(mem, mem_size, MADV_DONTNEED))
+		ksft_exit_fail_msg("%s MADV_DONTNEED failed\n", __func__);
+
+	/* Fast path: category_mask == return_mask == PAGE_IS_WRITTEN. */
+	ret = pagemap_ioctl(mem, mem_size, regions, npages, 0, 0,
+			    PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
+	if (ret < 0)
+		ksft_exit_fail_msg("%s fast scan failed\n", __func__);
+	for (i = 0; i < ret; i++)
+		fast += LEN(regions[i]);
+
+	/* Generic path: same query expressed via category_anyof_mask. */
+	ret = pagemap_ioctl(mem, mem_size, regions, npages, 0, 0,
+			    0, PAGE_IS_WRITTEN, 0, PAGE_IS_WRITTEN);
+	if (ret < 0)
+		ksft_exit_fail_msg("%s generic scan failed\n", __func__);
+	for (i = 0; i < ret; i++)
+		slow += LEN(regions[i]);
+
+	ksft_test_result(fast == npages && slow == npages,
+			 "%s unpopulated ptes reported written by both paths (%ld, %ld of %d)\n",
+			 __func__, fast, slow, npages);
+
+	wp_free(mem, mem_size);
+	munmap(mem, mem_size);
+}
+
 int sanity_tests(void)
 {
 	unsigned long long mem_size, vec_size;
@@ -1554,7 +1605,7 @@ int main(int __attribute__((unused)) arg
 	if (init_uffd())
 		ksft_exit_skip("Failed to initialize userfaultfd\n");
 
-	ksft_set_plan(117);
+	ksft_set_plan(118);
 
 	page_size = getpagesize();
 	hpage_size = read_pmd_pagesize();
@@ -1732,6 +1783,9 @@ int main(int __attribute__((unused)) arg
 	/* 17. ZEROPFN tests */
 	zeropfn_tests();
 
+	/* 18. Unpopulated pte scan-path consistency */
+	unpopulated_scan_test();
+
 	close(pagemap_fd);
 	ksft_finished();
 }


