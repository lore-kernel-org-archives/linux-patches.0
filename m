Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF2632E696;
	Mon, 20 Apr 2026 15:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699970; cv=none; b=IHZCDdxv8P/w2GXMM7zEz1vPE97C5cdcxwEB5YT5MAq0a5K/LVMJf9ImdaZSdccplCSntEVxrcdXbe/g+JDeQL7QQUyNEw5eK9cxoDJQ7BfdB8WYBN067BVhkqP+bjy1i3lh8TSQhh9t0hSUMHkoJ7cHj7Tf0EbJBddAJhbgMW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699970; c=relaxed/simple;
	bh=mx8OgC753+ecKK1+es1hejr0js+wTiaswIBoYu26fAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTKr55XPEScgsvXdwyMnvdgppaKDIJX2dmt2TUHY5qwUbjIcZrHK7ccbjP311I6LeOxUsIua7aLHUJKJWSSstFocwOSdhvZkl9Tl69BjHHzZEIEKBJYKEoFTMUjn80BQ8aKE37nRm2aQN06x6yA4/qfme1P4EzFqY2xkgxzvsR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Na0T2mJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Na0T2mJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1444C19425;
	Mon, 20 Apr 2026 15:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699970;
	bh=mx8OgC753+ecKK1+es1hejr0js+wTiaswIBoYu26fAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Na0T2mJ72i/djYW77Fz6/F4qom6fV883VcPUtIbIA5cAAW5zjyOiu9Mbo8zeZRIK
	 S2qMV2kjYYEwA749Cc0O4dVKMYeq2hhumL+ACgXLvUiOkn6UmjBpu1LPGWKM0dx20C
	 U8HBsT0OjU7vx3OeXKV9Rxgd8bswEe4P6wXHgmUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Popple <apopple@nvidia.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Balbir Singh <balbirs@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 36/76] selftests/mm: hmm-tests: dont hardcode THP size to 2MB
Date: Mon, 20 Apr 2026 17:41:47 +0200
Message-ID: <20260420153912.137603475@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alistair Popple <apopple@nvidia.com>

commit f9d7975c52c00b3685cf9a90a81023d17817d991 upstream.

Several HMM tests hardcode TWOMEG as the THP size. This is wrong on
architectures where the PMD size is not 2MB such as arm64 with 64K base
pages where THP is 512MB. Fix this by using read_pmd_pagesize() from
vm_util instead.

While here also replace the custom file_read_ulong() helper used to
parse the default hugetlbfs page size from /proc/meminfo with the
existing default_huge_page_size() from vm_util.

Link: https://lore.kernel.org/20260331063445.3551404-3-apopple@nvidia.com
Link: https://lore.kernel.org/linux-mm/8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev/
Fixes: fee9f6d1b8df ("mm/hmm/test: add selftests for HMM")
Fixes: 519071529d2a ("selftests/mm/hmm-tests: new tests for zone device THP migration")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
Closes: https://lore.kernel.org/linux-mm/8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev/
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/hmm-tests.c |   83 ++++++---------------------------
 1 file changed, 16 insertions(+), 67 deletions(-)

--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -34,6 +34,7 @@
  */
 #include <lib/test_hmm_uapi.h>
 #include <mm/gup_test.h>
+#include <mm/vm_util.h>
 
 struct hmm_buffer {
 	void		*ptr;
@@ -548,7 +549,7 @@ TEST_F(hmm, anon_write_child)
 
 	for (migrate = 0; migrate < 2; ++migrate) {
 		for (use_thp = 0; use_thp < 2; ++use_thp) {
-			npages = ALIGN(use_thp ? TWOMEG : HMM_BUFFER_SIZE,
+			npages = ALIGN(use_thp ? read_pmd_pagesize() : HMM_BUFFER_SIZE,
 				       self->page_size) >> self->page_shift;
 			ASSERT_NE(npages, 0);
 			size = npages << self->page_shift;
@@ -728,7 +729,7 @@ TEST_F(hmm, anon_write_huge)
 	int *ptr;
 	int ret;
 
-	size = 2 * TWOMEG;
+	size = 2 * read_pmd_pagesize();
 
 	buffer = malloc(sizeof(*buffer));
 	ASSERT_NE(buffer, NULL);
@@ -744,7 +745,7 @@ TEST_F(hmm, anon_write_huge)
 			   buffer->fd, 0);
 	ASSERT_NE(buffer->ptr, MAP_FAILED);
 
-	size = TWOMEG;
+	size /= 2;
 	npages = size >> self->page_shift;
 	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
 	ret = madvise(map, size, MADV_HUGEPAGE);
@@ -771,54 +772,6 @@ TEST_F(hmm, anon_write_huge)
 }
 
 /*
- * Read numeric data from raw and tagged kernel status files.  Used to read
- * /proc and /sys data (without a tag) and from /proc/meminfo (with a tag).
- */
-static long file_read_ulong(char *file, const char *tag)
-{
-	int fd;
-	char buf[2048];
-	int len;
-	char *p, *q;
-	long val;
-
-	fd = open(file, O_RDONLY);
-	if (fd < 0) {
-		/* Error opening the file */
-		return -1;
-	}
-
-	len = read(fd, buf, sizeof(buf));
-	close(fd);
-	if (len < 0) {
-		/* Error in reading the file */
-		return -1;
-	}
-	if (len == sizeof(buf)) {
-		/* Error file is too large */
-		return -1;
-	}
-	buf[len] = '\0';
-
-	/* Search for a tag if provided */
-	if (tag) {
-		p = strstr(buf, tag);
-		if (!p)
-			return -1; /* looks like the line we want isn't there */
-		p += strlen(tag);
-	} else
-		p = buf;
-
-	val = strtol(p, &q, 0);
-	if (*q != ' ') {
-		/* Error parsing the file */
-		return -1;
-	}
-
-	return val;
-}
-
-/*
  * Write huge TLBFS page.
  */
 TEST_F(hmm, anon_write_hugetlbfs)
@@ -826,15 +779,13 @@ TEST_F(hmm, anon_write_hugetlbfs)
 	struct hmm_buffer *buffer;
 	unsigned long npages;
 	unsigned long size;
-	unsigned long default_hsize;
+	unsigned long default_hsize = default_huge_page_size();
 	unsigned long i;
 	int *ptr;
 	int ret;
 
-	default_hsize = file_read_ulong("/proc/meminfo", "Hugepagesize:");
-	if (default_hsize < 0 || default_hsize*1024 < default_hsize)
+	if (!default_hsize)
 		SKIP(return, "Huge page size could not be determined");
-	default_hsize = default_hsize*1024; /* KB to B */
 
 	size = ALIGN(TWOMEG, default_hsize);
 	npages = size >> self->page_shift;
@@ -1606,7 +1557,7 @@ TEST_F(hmm, compound)
 	struct hmm_buffer *buffer;
 	unsigned long npages;
 	unsigned long size;
-	unsigned long default_hsize;
+	unsigned long default_hsize = default_huge_page_size();
 	int *ptr;
 	unsigned char *m;
 	int ret;
@@ -1614,10 +1565,8 @@ TEST_F(hmm, compound)
 
 	/* Skip test if we can't allocate a hugetlbfs page. */
 
-	default_hsize = file_read_ulong("/proc/meminfo", "Hugepagesize:");
-	if (default_hsize < 0 || default_hsize*1024 < default_hsize)
+	if (!default_hsize)
 		SKIP(return, "Huge page size could not be determined");
-	default_hsize = default_hsize*1024; /* KB to B */
 
 	size = ALIGN(TWOMEG, default_hsize);
 	npages = size >> self->page_shift;
@@ -2106,7 +2055,7 @@ TEST_F(hmm, migrate_anon_huge_empty)
 	int *ptr;
 	int ret;
 
-	size = TWOMEG;
+	size = read_pmd_pagesize();
 
 	buffer = malloc(sizeof(*buffer));
 	ASSERT_NE(buffer, NULL);
@@ -2158,7 +2107,7 @@ TEST_F(hmm, migrate_anon_huge_zero)
 	int ret;
 	int val;
 
-	size = TWOMEG;
+	size = read_pmd_pagesize();
 
 	buffer = malloc(sizeof(*buffer));
 	ASSERT_NE(buffer, NULL);
@@ -2221,7 +2170,7 @@ TEST_F(hmm, migrate_anon_huge_free)
 	int *ptr;
 	int ret;
 
-	size = TWOMEG;
+	size = read_pmd_pagesize();
 
 	buffer = malloc(sizeof(*buffer));
 	ASSERT_NE(buffer, NULL);
@@ -2280,7 +2229,7 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	int *ptr;
 	int ret;
 
-	size = TWOMEG;
+	size = read_pmd_pagesize();
 
 	buffer = malloc(sizeof(*buffer));
 	ASSERT_NE(buffer, NULL);
@@ -2332,7 +2281,7 @@ TEST_F(hmm, migrate_partial_unmap_fault)
 {
 	struct hmm_buffer *buffer;
 	unsigned long npages;
-	unsigned long size = TWOMEG;
+	unsigned long size = read_pmd_pagesize();
 	unsigned long i;
 	void *old_ptr;
 	void *map;
@@ -2398,7 +2347,7 @@ TEST_F(hmm, migrate_remap_fault)
 {
 	struct hmm_buffer *buffer;
 	unsigned long npages;
-	unsigned long size = TWOMEG;
+	unsigned long size = read_pmd_pagesize();
 	unsigned long i;
 	void *old_ptr, *new_ptr = NULL;
 	void *map;
@@ -2498,7 +2447,7 @@ TEST_F(hmm, migrate_anon_huge_err)
 	int *ptr;
 	int ret;
 
-	size = TWOMEG;
+	size = read_pmd_pagesize();
 
 	buffer = malloc(sizeof(*buffer));
 	ASSERT_NE(buffer, NULL);
@@ -2593,7 +2542,7 @@ TEST_F(hmm, migrate_anon_huge_zero_err)
 	int *ptr;
 	int ret;
 
-	size = TWOMEG;
+	size = read_pmd_pagesize();
 
 	buffer = malloc(sizeof(*buffer));
 	ASSERT_NE(buffer, NULL);


