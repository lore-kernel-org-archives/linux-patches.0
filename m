Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043391CA8F;
	Mon,  1 Apr 2024 16:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987519; cv=none; b=LumO8HWeB8Zfu06F8VDbS/hGRD0oFzB/ezbvOq0bdhXDJfWzFCaA1wtUyfpgwlWqrYahNShyVjAb63V0VE1gY8gb2PD6GdK/H+GKfrs6ceBCZ0iqhLARlHHUJM4TGvtteG4tqFubAy3Qwpk5kjeBCQ29rJAGeQMXJo/UkQOmY4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987519; c=relaxed/simple;
	bh=DjU0LG/JJrXDkw0A4G+ty5pUY6MtXk0EsjBF9EjQWJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBO/sgRAZtCMLIGYSYPCKZzxYfqGP20dXyBMl10PyCBQPUuBnWlOX7/Ew81S3CNChhyX/DfDX/V0X/Vbzq9qpDvTNFa1NCrCuhcf9EIIMPRU7ewnXuupoKXW+mVvhuhb6FZx8z2p6ZlUTpLUFo22yetmM0J5WB1KhtH0ZGbiS5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EeMDuEyO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EeMDuEyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6988FC433C7;
	Mon,  1 Apr 2024 16:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987518;
	bh=DjU0LG/JJrXDkw0A4G+ty5pUY6MtXk0EsjBF9EjQWJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EeMDuEyOE5Jhe2Ev9zy5RufF3wJFzoyVEFpcV60u36XVqkVrPBAkmqkBNDSwbUUql
	 KRh0G1ZgCKAKr7wE53a0RU9y3fIRwyd+yDQSN5MmxjeBPyRFJcGP7aErxz4VAvqtjC
	 nbPRHzzO15cJt37RKvaS0b3hTpDlOO5jtmK0sZ90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lokesh Gidra <lokeshgidra@google.com>,
	Edward Liaw <edliaw@google.com>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.8 311/399] selftests/mm: fix ARM related issue with fork after pthread_create
Date: Mon,  1 Apr 2024 17:44:37 +0200
Message-ID: <20240401152558.470910234@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Liaw <edliaw@google.com>

commit 8c864371b2a15a23ce35aa7e2bd241baaad6fbe8 upstream.

Following issue was observed while running the uffd-unit-tests selftest
on ARM devices. On x86_64 no issues were detected:

pthread_create followed by fork caused deadlock in certain cases wherein
fork required some work to be completed by the created thread.  Used
synchronization to ensure that created thread's start function has started
before invoking fork.

[edliaw@google.com: refactored to use atomic_bool]
Link: https://lkml.kernel.org/r/20240325194100.775052-1-edliaw@google.com
Fixes: 760aee0b71e3 ("selftests/mm: add tests for RO pinning vs fork()")
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Signed-off-by: Edward Liaw <edliaw@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/uffd-common.c     |    3 +++
 tools/testing/selftests/mm/uffd-common.h     |    2 ++
 tools/testing/selftests/mm/uffd-unit-tests.c |   10 ++++++++++
 3 files changed, 15 insertions(+)

--- a/tools/testing/selftests/mm/uffd-common.c
+++ b/tools/testing/selftests/mm/uffd-common.c
@@ -18,6 +18,7 @@ bool test_uffdio_wp = true;
 unsigned long long *count_verify;
 uffd_test_ops_t *uffd_test_ops;
 uffd_test_case_ops_t *uffd_test_case_ops;
+atomic_bool ready_for_fork;
 
 static int uffd_mem_fd_create(off_t mem_size, bool hugetlb)
 {
@@ -518,6 +519,8 @@ void *uffd_poll_thread(void *arg)
 	pollfd[1].fd = pipefd[cpu*2];
 	pollfd[1].events = POLLIN;
 
+	ready_for_fork = true;
+
 	for (;;) {
 		ret = poll(pollfd, 2, -1);
 		if (ret <= 0) {
--- a/tools/testing/selftests/mm/uffd-common.h
+++ b/tools/testing/selftests/mm/uffd-common.h
@@ -32,6 +32,7 @@
 #include <inttypes.h>
 #include <stdint.h>
 #include <sys/random.h>
+#include <stdatomic.h>
 
 #include "../kselftest.h"
 #include "vm_util.h"
@@ -103,6 +104,7 @@ extern bool map_shared;
 extern bool test_uffdio_wp;
 extern unsigned long long *count_verify;
 extern volatile bool test_uffdio_copy_eexist;
+extern atomic_bool ready_for_fork;
 
 extern uffd_test_ops_t anon_uffd_test_ops;
 extern uffd_test_ops_t shmem_uffd_test_ops;
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -775,6 +775,8 @@ static void uffd_sigbus_test_common(bool
 	char c;
 	struct uffd_args args = { 0 };
 
+	ready_for_fork = false;
+
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 
 	if (uffd_register(uffd, area_dst, nr_pages * page_size,
@@ -790,6 +792,9 @@ static void uffd_sigbus_test_common(bool
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
+	while (!ready_for_fork)
+		; /* Wait for the poll_thread to start executing before forking */
+
 	pid = fork();
 	if (pid < 0)
 		err("fork");
@@ -829,6 +834,8 @@ static void uffd_events_test_common(bool
 	char c;
 	struct uffd_args args = { 0 };
 
+	ready_for_fork = false;
+
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 	if (uffd_register(uffd, area_dst, nr_pages * page_size,
 			  true, wp, false))
@@ -838,6 +845,9 @@ static void uffd_events_test_common(bool
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
+	while (!ready_for_fork)
+		; /* Wait for the poll_thread to start executing before forking */
+
 	pid = fork();
 	if (pid < 0)
 		err("fork");


