Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A815247CA67;
	Sat, 12 Sep 2026 12:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217220; cv=none; b=divTYb/OE9FFFNGOMbVo/ssq1sfwWcqLDyY/Kmks89uSyX1oi46KtTmIGdG3zavUfn9gy53Y3P14IcseAn3pva/jI8uyXSce0bceLF774VjLHTX5YhxhEp3sS8BJLvoA8SpgzJgGEn8pPeeRpKY1d/KZsxckAEq909j2qkBq4uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217220; c=relaxed/simple;
	bh=1oH5eSftYUCJmEQwOYyX9dRpHL49/fsyQvXx3b60+W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRqtJL/70ZokGRJhdccrjbNzFfi+fi3FgJ7UhcV7TmjzVuvpoksyYCuaO9QEVvgw5MfIjE32AET4+HqUDQh8JBz6YEhlpM2+SGkOPV1tA3qgxWF3ypsUjuLEIb1DznJVk8fDxasvXXqc2w4rBfC0o3Bb8IcSVCyJLtc/lvXrogk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11t2SH8g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11t2SH8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D84D1F000FF;
	Sat, 12 Sep 2026 12:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217218;
	bh=9LPW4KpI+FzdH3m1UxxLzTEIMGgSF2aFQiJNPuBRQgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=11t2SH8gf3yJh5t2A+ywjdy0sv73kpIVSpxvXlsoEJVonkEAFfp3qsRrPxj7pZfPf
	 cjT5zSMucokT4kiIPnIkZCDnUgPbktQ9HnTCX5/ZfwPijPxtXRIxCD0o8iRYVpJ5vN
	 IqXbWT64AlHuMoZLtd1alDXRDu0PYBHF/GoOR/7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Wang <liwang@redhat.com>,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Keith Lucas <keith.lucas@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0897/1376] ksm_tests: skip hugepage test when Transparent Hugepages are disabled
Date: Sat, 12 Sep 2026 08:55:23 +0200
Message-ID: <20260912065627.555309098@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Wang <liwang@redhat.com>

[ Upstream commit fdc3bc3497946c6b416a17628907581657102e60 ]

Some systems (e.g.  minimal or real-time kernels) may not enable
Transparent Hugepages (THP), causing MADV_HUGEPAGE to return EINVAL.  This
patch introduces a runtime check using the existing THP sysfs interface
and skips the hugepage merging test (`-H`) when THP is not available.

To avoid those failures:

  # -----------------------------
  # running ./ksm_tests -H -s 100
  # -----------------------------
  # ksm_tests: MADV_HUGEPAGE: Invalid argument
  # [FAIL]
  not ok 1 ksm_tests -H -s 100 # exit=2

  # --------------------
  # running ./khugepaged
  # --------------------
  # Reading PMD pagesize failed# [FAIL]
  not ok 1 khugepaged # exit=1

  # --------------------
  # running ./soft-dirty
  # --------------------
  # TAP version 13
  # 1..15
  # ok 1 Test test_simple
  # ok 2 Test test_vma_reuse dirty bit of allocated page
  # ok 3 Test test_vma_reuse dirty bit of reused address page
  # Bail out! Reading PMD pagesize failed# Planned tests != run tests (15 != 3)
  # # Totals: pass:3 fail:0 xfail:0 xpass:0 skip:0 error:0
  # [FAIL]
  not ok 1 soft-dirty # exit=1
  # SUMMARY: PASS=0 SKIP=0 FAIL=1

  # -------------------
  # running ./migration
  # -------------------
  # TAP version 13
  # 1..3
  # # Starting 3 tests from 1 test cases.
  # #  RUN           migration.private_anon ...
  # #            OK  migration.private_anon
  # ok 1 migration.private_anon
  # #  RUN           migration.shared_anon ...
  # #            OK  migration.shared_anon
  # ok 2 migration.shared_anon
  # #  RUN           migration.private_anon_thp ...
  # # migration.c:196:private_anon_thp:Expected madvise(ptr, TWOMEG, MADV_HUGEPAGE) (-1) == 0 (0)
  # # private_anon_thp: Test terminated by assertion
  # #          FAIL  migration.private_anon_thp
  # not ok 3 migration.private_anon_thp
  # # FAILED: 2 / 3 tests passed.
  # # Totals: pass:2 fail:1 xfail:0 xpass:0 skip:0 error:0
  # [FAIL]
  not ok 1 migration # exit=1

It's true that CONFIG_TRANSPARENT_HUGEPAGE=y is explicitly enabled in
tools/testing/selftests/mm/config, so ideally the runtime environment
should also support THP.

However, in practice, we've found that on some systems:

- THP is disabled at boot time (transparent_hugepage=never)
- Or manually disabled via sysfs
- Or unavailable in RT kernels, containers, or minimal CI environments

In these cases, the test will fail with EINVAL on madvise(MADV_HUGEPAGE),
even though the kernel config is correct.

To make the test suite more robust and avoid false negatives, this patch
adds a runtime check for /sys/kernel/mm/transparent_hugepage/enabled.

If THP is not available, the hugepage test (-H) is skipped with a clear
message.

Link: https://lkml.kernel.org/r/20250624032748.393836-1-liwang@redhat.com
Signed-off-by: Li Wang <liwang@redhat.com>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 15828a150c58 ("selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA nodes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c   |  5 +++++
 tools/testing/selftests/mm/ksm_tests.c    |  6 ++++++
 tools/testing/selftests/mm/migration.c    |  8 ++++++++
 tools/testing/selftests/mm/soft-dirty.c   |  9 ++++++++-
 tools/testing/selftests/mm/thp_settings.c | 11 +++++++++++
 tools/testing/selftests/mm/thp_settings.h |  2 ++
 6 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 8a4d34cce36b2..6822eb7ea58e8 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1190,6 +1190,11 @@ int main(int argc, char **argv)
 		.read_ahead_kb = 0,
 	};
 
+	if (!thp_is_enabled()) {
+		printf("Transparent Hugepages not available\n");
+		return KSFT_SKIP;
+	}
+
 	parse_test_type(argc, argv);
 
 	setbuf(stdout, NULL);
diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index b748c48908d9d..faa3d053994df 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -15,6 +15,7 @@
 #include "../kselftest.h"
 #include <include/vdso/time64.h>
 #include "vm_util.h"
+#include "thp_settings.h"
 
 #define KSM_SYSFS_PATH "/sys/kernel/mm/ksm/"
 #define KSM_FP(s) (KSM_SYSFS_PATH s)
@@ -555,6 +556,11 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
 	unsigned long scan_time_ns;
 	int pagemap_fd, n_normal_pages, n_huge_pages;
 
+	if (!thp_is_enabled()) {
+		printf("Transparent Hugepages not available\n");
+		return KSFT_SKIP;
+	}
+
 	map_size *= MB;
 	size_t len = map_size;
 
diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index cfd01e951e89c..7ad742c8c1325 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -5,6 +5,8 @@
  */
 
 #include "../kselftest_harness.h"
+#include "thp_settings.h"
+
 #include <strings.h>
 #include <pthread.h>
 #include <numa.h>
@@ -186,6 +188,9 @@ TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
 	uint64_t *ptr;
 	int i;
 
+	if (!thp_is_enabled())
+		SKIP(return, "Transparent Hugepages not available");
+
 	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
 		SKIP(return, "Not enough threads or NUMA nodes available");
 
@@ -215,6 +220,9 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
 	uint64_t *ptr;
 	int i;
 
+	if (!thp_is_enabled())
+		SKIP(return, "Transparent Hugepages not available");
+
 	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
 		SKIP(return, "Not enough threads or NUMA nodes available");
 
diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index 7b91df12ce5b9..ca65ff3096b25 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -6,8 +6,10 @@
 #include <stdint.h>
 #include <malloc.h>
 #include <sys/mman.h>
+
 #include "../kselftest.h"
 #include "vm_util.h"
+#include "thp_settings.h"
 
 #define PAGEMAP_FILE_PATH "/proc/self/pagemap"
 #define TEST_ITERATIONS 10000
@@ -78,8 +80,13 @@ static void test_hugepage(int pagemap_fd, int pagesize)
 {
 	char *map;
 	int i, ret;
-	size_t hpage_len = read_pmd_pagesize();
 
+	if (!thp_is_enabled()) {
+		ksft_test_result_skip("Transparent Hugepages not available\n");
+		return;
+	}
+
+	size_t hpage_len = read_pmd_pagesize();
 	if (!hpage_len)
 		ksft_exit_fail_msg("Reading PMD pagesize failed");
 
diff --git a/tools/testing/selftests/mm/thp_settings.c b/tools/testing/selftests/mm/thp_settings.c
index 577eaab6266fd..38f70155bfbf1 100644
--- a/tools/testing/selftests/mm/thp_settings.c
+++ b/tools/testing/selftests/mm/thp_settings.c
@@ -381,3 +381,14 @@ unsigned long thp_shmem_supported_orders(void)
 {
 	return __thp_supported_orders(true);
 }
+
+bool thp_is_enabled(void)
+{
+	if (access(THP_SYSFS, F_OK) != 0)
+		return false;
+
+	int mode = thp_read_string("enabled", thp_enabled_strings);
+
+	/* THP is considered enabled if it's either "always" or "madvise" */
+	return mode == 1 || mode == 3;
+}
diff --git a/tools/testing/selftests/mm/thp_settings.h b/tools/testing/selftests/mm/thp_settings.h
index 876235a23460c..079a58a662b0e 100644
--- a/tools/testing/selftests/mm/thp_settings.h
+++ b/tools/testing/selftests/mm/thp_settings.h
@@ -84,4 +84,6 @@ void thp_set_read_ahead_path(char *path);
 unsigned long thp_supported_orders(void);
 unsigned long thp_shmem_supported_orders(void);
 
+bool thp_is_enabled(void);
+
 #endif /* __THP_SETTINGS_H__ */
-- 
2.53.0



