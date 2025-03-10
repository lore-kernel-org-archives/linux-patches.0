Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E905D230D0F;
	Mon, 10 Mar 2025 17:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626677; cv=none; b=gQ9CFiWPeAuO9uadO8qo9bagh5kEfjlAME5g5ElUNxWfv1F3W05xJqpgB57r7/YTAVJ2RuUmXWtvvjkVQkofUdxvJo7G/CgWWQ9rDkHqIwSjh7rh4H9vHzlh+GN2jobRilU7sKi8dhFhIbu48p6KDiJ7jVIb7X2JjJGWPe4ns2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626677; c=relaxed/simple;
	bh=TTEy0OvicRofF9IB0NUO2G8cjtX3f6MkNYjQ8QxDbAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJlQZi/b6aEBEim83gWCf1y54Kk4VAU0iysnEyJRg2Meu4Ji1ggIW5bHHw6Qg2S4Vtumriji8tC/1uE4QFMbbMA+ynP8EBbSLzRo7GvyHG+vN1qnEmHQfm3ty1gzCrNb1OhPZL2SyW9q7QlZbvTdEIUZmi5JavKikIkQtG9aj24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qwJDJF0m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qwJDJF0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FD1C4CEE5;
	Mon, 10 Mar 2025 17:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626676;
	bh=TTEy0OvicRofF9IB0NUO2G8cjtX3f6MkNYjQ8QxDbAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwJDJF0mbpSURro1HGqy7IXP/7jRHisdmTbgopIDC52Qy1LW2nQOGp1yq56bB/nH4
	 2tMMisaKvSmZ7GdZO9kmUbLsNwID2nrs+UmQ/cZ6GrtCiBlF/FJgrkIJtzX5UUj0LR
	 fyV8oItV5eeZ/FD34JToycbXnEg5bkdVLNf1Kais=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hubbard <jhubbard@nvidia.com>,
	Dave Hansen <dave.hansen@intel.com>,
	Li Wang <liwang@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Peter Xu <peterx@redhat.com>,
	Rich Felker <dalias@libc.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 042/207] Revert "selftests/mm: remove local __NR_* definitions"
Date: Mon, 10 Mar 2025 18:03:55 +0100
Message-ID: <20250310170449.441292552@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Hubbard <jhubbard@nvidia.com>

commit 0a7565ee6ec31eb16c0476adbfc1af3f2271cb6b upstream.

This reverts commit a5c6bc590094a1a73cf6fa3f505e1945d2bf2461.

The general approach described in commit e076eaca5906 ("selftests: break
the dependency upon local header files") was taken one step too far here:
it should not have been extended to include the syscall numbers.  This is
because doing so would require per-arch support in tools/include/uapi, and
no such support exists.

This revert fixes two separate reports of test failures, from Dave
Hansen[1], and Li Wang[2].  An excerpt of Dave's report:

Before this commit (a5c6bc590094a1a73cf6fa3f505e1945d2bf2461) things are
fine.  But after, I get:

	running PKEY tests for unsupported CPU/OS

An excerpt of Li's report:

    I just found that mlock2_() return a wrong value in mlock2-test

[1] https://lore.kernel.org/dc585017-6740-4cab-a536-b12b37a7582d@intel.com
[2] https://lore.kernel.org/CAEemH2eW=UMu9+turT2jRie7+6ewUazXmA6kL+VBo3cGDGU6RA@mail.gmail.com

Link: https://lkml.kernel.org/r/20250214033850.235171-1-jhubbard@nvidia.com
Fixes: a5c6bc590094 ("selftests/mm: remove local __NR_* definitions")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Li Wang <liwang@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Andrei Vagin <avagin@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/hugepage-mremap.c      |    2 +-
 tools/testing/selftests/mm/ksm_functional_tests.c |    8 +++++++-
 tools/testing/selftests/mm/memfd_secret.c         |   14 +++++++++++++-
 tools/testing/selftests/mm/mkdirty.c              |    8 +++++++-
 tools/testing/selftests/mm/mlock2.h               |    1 -
 tools/testing/selftests/mm/protection_keys.c      |    2 +-
 tools/testing/selftests/mm/uffd-common.c          |    4 ++++
 tools/testing/selftests/mm/uffd-stress.c          |   15 ++++++++++++++-
 tools/testing/selftests/mm/uffd-unit-tests.c      |   14 +++++++++++++-
 9 files changed, 60 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugepage-mremap.c
@@ -15,7 +15,7 @@
 #define _GNU_SOURCE
 #include <stdlib.h>
 #include <stdio.h>
-#include <asm-generic/unistd.h>
+#include <unistd.h>
 #include <sys/mman.h>
 #include <errno.h>
 #include <fcntl.h> /* Definition of O_* constants */
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -11,7 +11,7 @@
 #include <string.h>
 #include <stdbool.h>
 #include <stdint.h>
-#include <asm-generic/unistd.h>
+#include <unistd.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <sys/mman.h>
@@ -369,6 +369,7 @@ unmap:
 	munmap(map, size);
 }
 
+#ifdef __NR_userfaultfd
 static void test_unmerge_uffd_wp(void)
 {
 	struct uffdio_writeprotect uffd_writeprotect;
@@ -429,6 +430,7 @@ close_uffd:
 unmap:
 	munmap(map, size);
 }
+#endif
 
 /* Verify that KSM can be enabled / queried with prctl. */
 static void test_prctl(void)
@@ -684,7 +686,9 @@ int main(int argc, char **argv)
 		exit(test_child_ksm());
 	}
 
+#ifdef __NR_userfaultfd
 	tests++;
+#endif
 
 	ksft_print_header();
 	ksft_set_plan(tests);
@@ -696,7 +700,9 @@ int main(int argc, char **argv)
 	test_unmerge();
 	test_unmerge_zero_pages();
 	test_unmerge_discarded();
+#ifdef __NR_userfaultfd
 	test_unmerge_uffd_wp();
+#endif
 
 	test_prot_none();
 
--- a/tools/testing/selftests/mm/memfd_secret.c
+++ b/tools/testing/selftests/mm/memfd_secret.c
@@ -17,7 +17,7 @@
 
 #include <stdlib.h>
 #include <string.h>
-#include <asm-generic/unistd.h>
+#include <unistd.h>
 #include <errno.h>
 #include <stdio.h>
 #include <fcntl.h>
@@ -28,6 +28,8 @@
 #define pass(fmt, ...) ksft_test_result_pass(fmt, ##__VA_ARGS__)
 #define skip(fmt, ...) ksft_test_result_skip(fmt, ##__VA_ARGS__)
 
+#ifdef __NR_memfd_secret
+
 #define PATTERN	0x55
 
 static const int prot = PROT_READ | PROT_WRITE;
@@ -332,3 +334,13 @@ int main(int argc, char *argv[])
 
 	ksft_finished();
 }
+
+#else /* __NR_memfd_secret */
+
+int main(int argc, char *argv[])
+{
+	printf("skip: skipping memfd_secret test (missing __NR_memfd_secret)\n");
+	return KSFT_SKIP;
+}
+
+#endif /* __NR_memfd_secret */
--- a/tools/testing/selftests/mm/mkdirty.c
+++ b/tools/testing/selftests/mm/mkdirty.c
@@ -9,7 +9,7 @@
  */
 #include <fcntl.h>
 #include <signal.h>
-#include <asm-generic/unistd.h>
+#include <unistd.h>
 #include <string.h>
 #include <errno.h>
 #include <stdlib.h>
@@ -265,6 +265,7 @@ munmap:
 	munmap(mmap_mem, mmap_size);
 }
 
+#ifdef __NR_userfaultfd
 static void test_uffdio_copy(void)
 {
 	struct uffdio_register uffdio_register;
@@ -321,6 +322,7 @@ munmap:
 	munmap(dst, pagesize);
 	free(src);
 }
+#endif /* __NR_userfaultfd */
 
 int main(void)
 {
@@ -333,7 +335,9 @@ int main(void)
 			       thpsize / 1024);
 		tests += 3;
 	}
+#ifdef __NR_userfaultfd
 	tests += 1;
+#endif /* __NR_userfaultfd */
 
 	ksft_print_header();
 	ksft_set_plan(tests);
@@ -363,7 +367,9 @@ int main(void)
 	if (thpsize)
 		test_pte_mapped_thp();
 	/* Placing a fresh page via userfaultfd may set the PTE dirty. */
+#ifdef __NR_userfaultfd
 	test_uffdio_copy();
+#endif /* __NR_userfaultfd */
 
 	err = ksft_get_fail_cnt();
 	if (err)
--- a/tools/testing/selftests/mm/mlock2.h
+++ b/tools/testing/selftests/mm/mlock2.h
@@ -3,7 +3,6 @@
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <asm-generic/unistd.h>
 
 static int mlock2_(void *start, size_t len, int flags)
 {
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -42,7 +42,7 @@
 #include <sys/wait.h>
 #include <sys/stat.h>
 #include <fcntl.h>
-#include <asm-generic/unistd.h>
+#include <unistd.h>
 #include <sys/ptrace.h>
 #include <setjmp.h>
 
--- a/tools/testing/selftests/mm/uffd-common.c
+++ b/tools/testing/selftests/mm/uffd-common.c
@@ -673,7 +673,11 @@ int uffd_open_dev(unsigned int flags)
 
 int uffd_open_sys(unsigned int flags)
 {
+#ifdef __NR_userfaultfd
 	return syscall(__NR_userfaultfd, flags);
+#else
+	return -1;
+#endif
 }
 
 int uffd_open(unsigned int flags)
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -33,10 +33,11 @@
  * pthread_mutex_lock will also verify the atomicity of the memory
  * transfer (UFFDIO_COPY).
  */
-#include <asm-generic/unistd.h>
+
 #include "uffd-common.h"
 
 uint64_t features;
+#ifdef __NR_userfaultfd
 
 #define BOUNCE_RANDOM		(1<<0)
 #define BOUNCE_RACINGFAULTS	(1<<1)
@@ -471,3 +472,15 @@ int main(int argc, char **argv)
 	       nr_pages, nr_pages_per_cpu);
 	return userfaultfd_stress();
 }
+
+#else /* __NR_userfaultfd */
+
+#warning "missing __NR_userfaultfd definition"
+
+int main(void)
+{
+	printf("skip: Skipping userfaultfd test (missing __NR_userfaultfd)\n");
+	return KSFT_SKIP;
+}
+
+#endif /* __NR_userfaultfd */
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -5,11 +5,12 @@
  *  Copyright (C) 2015-2023  Red Hat, Inc.
  */
 
-#include <asm-generic/unistd.h>
 #include "uffd-common.h"
 
 #include "../../../../mm/gup_test.h"
 
+#ifdef __NR_userfaultfd
+
 /* The unit test doesn't need a large or random size, make it 32MB for now */
 #define  UFFD_TEST_MEM_SIZE               (32UL << 20)
 
@@ -1558,3 +1559,14 @@ int main(int argc, char *argv[])
 	return ksft_get_fail_cnt() ? KSFT_FAIL : KSFT_PASS;
 }
 
+#else /* __NR_userfaultfd */
+
+#warning "missing __NR_userfaultfd definition"
+
+int main(void)
+{
+	printf("Skipping %s (missing __NR_userfaultfd)\n", __file__);
+	return KSFT_SKIP;
+}
+
+#endif /* __NR_userfaultfd */


