Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24334471252;
	Tue, 21 Jul 2026 19:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660948; cv=none; b=qNpfImvXUzGqm5g41D4W36jgxjy70DwIogrdAAR5+Ktnsfktxm9dMia3hrRXS0ZZuvhpbizLwKA0UNRgZL8cQTcuLV+BRZJypyeRYgDride8CY3dpjpLOL7UqYI6PNaYUjvzYQV6P3F33+k2eQgzjZFbb5iPVjo50d2wiSJXgKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660948; c=relaxed/simple;
	bh=bA5cbWYPKjCPIdivajSMHLsQ1bwlPYhdv9ZZ5FOygT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+gj3XyWalJF2EoipCWSTgsBKLoMkYxx5eoH4RegU4VGzLP9XIugNc4ubS42LOTvn1KXyh/n0uCXJL8/uP/mSX0+U5pHwOUxpsQjC/7V9vwNTqTy/aK3a9EVguxaVw/7qJgpSRKobyH9RohPFmTOkzcF6hHZyMdKWt2OmGAumBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phkpZA3P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phkpZA3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4AF1F000E9;
	Tue, 21 Jul 2026 19:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660947;
	bh=h3E7ra4n4i7hjSNdmedTXf+UePDCdlO776Pyj+vcUMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=phkpZA3PbP6xuhPfxIlKDLIcDT9SiAJRUW3C602u4l+5KfaNK+C+d7ucgSlWy99rF
	 F1iBntRBXtNWwraCU672SQjCcVanUn6uAKasw1nsC8plDX62+BwSNvQ0ZpGlgd6Pgb
	 GuLnQuXF7UsYjcPQ8hVWvIAzkAF7XlT3g84d4SZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sayali Patil <sayalip@linux.ibm.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Alex Sierra <alex.sierra@amd.com>,
	Alistair Popple <apopple@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1173/2077] selftests/mm: remove hardcoded THP sizing assumptions in hmm tests
Date: Tue, 21 Jul 2026 17:14:06 +0200
Message-ID: <20260721152620.486557492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Sayali Patil <sayalip@linux.ibm.com>

[ Upstream commit 8edb0e769ce2a996774df83485781dd9f4bc2d44 ]

migrate_partial_unmap_fault() and migrate_remap_fault() use hardcoded
offsets based on a 2MB PMD size.  Similarly, benchmark_thp_migration()
assumes a fixed 2MB THP size when generating test buffer sizes.

Derive offsets and test sizes from the runtime PMD page size returned by
read_pmd_pagesize().  If unavailable, fall back to TWOMEG.  This allows
the tests to adapt correctly on systems where PMD-sized THP differs from
2MB.  Also replace the fixed 1MB unmap size with a PMD-relative value
derived from the runtime PMD size.

On systems with larger PMD sizes, computed test buffer sizes can exceed
INT_MAX.  Skip such test cases to avoid overflow.

Link: https://lore.kernel.org/20260611034102.1030738-3-aboorvad@linux.ibm.com
Fixes: 24c2c5b8ffbd ("selftests/mm/hmm-tests: partial unmap, mremap and anon_write tests")
Fixes: 271a7b2e3c13 ("selftests/mm/hmm-tests: new throughput tests including THP")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/hmm-tests.c | 62 ++++++++++++++++++--------
 1 file changed, 43 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index c7fda556f2a148..64e981548f72e5 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -21,6 +21,7 @@
 #include <strings.h>
 #include <time.h>
 #include <pthread.h>
+#include <limits.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
@@ -2348,12 +2349,21 @@ TEST_F(hmm, migrate_partial_unmap_fault)
 	struct hmm_buffer *buffer;
 	unsigned long npages;
 	unsigned long size = read_pmd_pagesize();
+	unsigned long unmap_size;
+	unsigned long offsets[3];
 	unsigned long i;
 	void *old_ptr;
 	void *map;
 	int *ptr;
 	int ret, j, use_thp;
-	int offsets[] = { 0, 512 * ONEKB, ONEMEG };
+
+	if (!size)
+		size = TWOMEG;
+
+	unmap_size = size / 2;
+	offsets[0] = 0;
+	offsets[1] = size / 4;
+	offsets[2] = size / 2;
 
 	for (use_thp = 0; use_thp < 2; ++use_thp) {
 		for (j = 0; j < ARRAY_SIZE(offsets); ++j) {
@@ -2395,12 +2405,12 @@ TEST_F(hmm, migrate_partial_unmap_fault)
 			for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
 				ASSERT_EQ(ptr[i], i);
 
-			munmap(buffer->ptr + offsets[j], ONEMEG);
+			munmap(buffer->ptr + offsets[j], unmap_size);
 
 			/* Fault pages back to system memory and check them. */
 			for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 				if (i * sizeof(int) < offsets[j] ||
-				    i * sizeof(int) >= offsets[j] + ONEMEG)
+				    i * sizeof(int) >= offsets[j] + unmap_size)
 					ASSERT_EQ(ptr[i], i);
 
 			buffer->ptr = old_ptr;
@@ -2414,12 +2424,19 @@ TEST_F(hmm, migrate_remap_fault)
 	struct hmm_buffer *buffer;
 	unsigned long npages;
 	unsigned long size = read_pmd_pagesize();
+	unsigned long offsets[3];
 	unsigned long i;
 	void *old_ptr, *new_ptr = NULL;
 	void *map;
 	int *ptr;
 	int ret, j, use_thp, dont_unmap, before;
-	int offsets[] = { 0, 512 * ONEKB, ONEMEG };
+
+	if (!size)
+		size = TWOMEG;
+
+	offsets[0] = 0;
+	offsets[1] = size / 4;
+	offsets[2] = size / 2;
 
 	for (before = 0; before < 2; ++before) {
 		for (dont_unmap = 0; dont_unmap < 2; ++dont_unmap) {
@@ -2822,38 +2839,45 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 TEST_F_TIMEOUT(hmm, benchmark_thp_migration, 120)
 {
 	struct benchmark_results thp_results, regular_results;
-	size_t thp_size = 2 * 1024 * 1024; /* 2MB - typical THP size */
+	size_t thp_size = read_pmd_pagesize();
 	int iterations = 5;
 
+	if (!thp_size)
+		thp_size = TWOMEG;
+
 	printf("\nHMM THP Migration Benchmark\n");
 	printf("---------------------------\n");
 	printf("System page size: %ld bytes\n", sysconf(_SC_PAGESIZE));
 
 	/* Test different buffer sizes */
 	size_t test_sizes[] = {
-		thp_size / 4,      /* 512KB - smaller than THP */
-		thp_size / 2,      /* 1MB - half THP */
-		thp_size,          /* 2MB - single THP */
-		thp_size * 2,      /* 4MB - two THPs */
-		thp_size * 4,      /* 8MB - four THPs */
-		thp_size * 8,       /* 16MB - eight THPs */
-		thp_size * 128,       /* 256MB - one twenty eight THPs */
+		thp_size / 4,      /* quarter THP */
+		thp_size / 2,      /* half THP */
+		thp_size,          /* single THP */
+		thp_size * 2,      /* two THPs */
+		thp_size * 4,      /* four THPs */
+		thp_size * 8,      /* eight THPs */
+		thp_size * 128,    /* one twenty eight THPs */
 	};
 
 	static const char *const test_names[] = {
-		"Small Buffer (512KB)",
-		"Half THP Size (1MB)",
-		"Single THP Size (2MB)",
-		"Two THP Size (4MB)",
-		"Four THP Size (8MB)",
-		"Eight THP Size (16MB)",
-		"One twenty eight THP Size (256MB)"
+		"Small Buffer",
+		"Half THP Size",
+		"Single THP Size",
+		"Two THP Size",
+		"Four THP Size",
+		"Eight THP Size",
+		"One twenty eight THP Size"
 	};
 
 	int num_tests = ARRAY_SIZE(test_sizes);
 
 	/* Run all tests */
 	for (int i = 0; i < num_tests; i++) {
+		/* Skip test sizes exceeding INT_MAX to avoid overflow */
+		if (test_sizes[i] > INT_MAX)
+			break;
+
 		/* Test with THP */
 		ASSERT_EQ(run_migration_benchmark(self->fd, 1, test_sizes[i],
 					iterations, &thp_results), 0);
-- 
2.53.0



