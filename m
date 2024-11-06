Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBA91DFD9D;
	Wed,  6 Nov 2024 12:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896301; cv=none; b=ujA2zAReH+mcKYGefIoA1/DmdEjSGeN2ER+gIdsE0VjjLqH70lJbtA+qOMn5UEvbHXruxcbIbuJuP/XGvYzn2HABVQpFEwS9km5DZNZMoTmzlgyPVyX4+AkUhQWKZ5KAJw57zZsgugHi3Fn+bAPNAOyFrdbpbXaCL8TqG44DPMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896301; c=relaxed/simple;
	bh=UoL/97lqYSaqYkeBR6yN8I9Dz8wn7WBbWwHBR/kvaps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0wGwR8mOYDwjeX/jXmOMxWU6rf9VONBWE54hPfwVzVsjzq+9tg1WXVvJRRn/pwpc2exTdaE2MJ0zEgk5HfI6rQhPv438gp4NPBqr1rh61p3BKcuvQcQozauHzq4GHjI0Az0mUclxhODMeee5iVnmLcxQC+IJ8+nBFyituu1RCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=roWvFbpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="roWvFbpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC02C4CECD;
	Wed,  6 Nov 2024 12:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896301;
	bh=UoL/97lqYSaqYkeBR6yN8I9Dz8wn7WBbWwHBR/kvaps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roWvFbpB32ZX+0SfdHXj4TAmwWjQGbT8FaKndqra92QkX2PDzGxgr8XugAHRNVPLq
	 mHex8uKfH6nQbv74nfbj+2+PlsueLjPzjf6gYZPwq/IIP/6tWgAbc55uFWUHC8GCnb
	 o/3GdXpcBGn0+XB/FYDUuJx5w4DYQAE2z9vwbyoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Liaw <edliaw@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Peter Xu <peterx@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 121/245] Revert "selftests/mm: replace atomic_bool with pthread_barrier_t"
Date: Wed,  6 Nov 2024 13:02:54 +0100
Message-ID: <20241106120322.200852289@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Liaw <edliaw@google.com>

commit 3673167a3a07f25b3f06754d69f406edea65543a upstream.

This reverts commit e61ef21e27e8deed8c474e9f47f4aa7bc37e138c.

uffd_poll_thread may be called by other tests that do not initialize the
pthread_barrier, so this approach is not correct.  This will revert to
using atomic_bool instead.

Link: https://lkml.kernel.org/r/20241018171734.2315053-3-edliaw@google.com
Fixes: e61ef21e27e8 ("selftests/mm: replace atomic_bool with pthread_barrier_t")
Signed-off-by: Edward Liaw <edliaw@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/uffd-common.c     |    5 ++---
 tools/testing/selftests/mm/uffd-common.h     |    3 ++-
 tools/testing/selftests/mm/uffd-unit-tests.c |   14 ++++++--------
 3 files changed, 10 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c
+++ b/tools/testing/selftests/mm/uffd-common.c
@@ -18,7 +18,7 @@ bool test_uffdio_wp = true;
 unsigned long long *count_verify;
 uffd_test_ops_t *uffd_test_ops;
 uffd_test_case_ops_t *uffd_test_case_ops;
-pthread_barrier_t ready_for_fork;
+atomic_bool ready_for_fork;
 
 static int uffd_mem_fd_create(off_t mem_size, bool hugetlb)
 {
@@ -519,8 +519,7 @@ void *uffd_poll_thread(void *arg)
 	pollfd[1].fd = pipefd[cpu*2];
 	pollfd[1].events = POLLIN;
 
-	/* Ready for parent thread to fork */
-	pthread_barrier_wait(&ready_for_fork);
+	ready_for_fork = true;
 
 	for (;;) {
 		ret = poll(pollfd, 2, -1);
--- a/tools/testing/selftests/mm/uffd-common.h
+++ b/tools/testing/selftests/mm/uffd-common.h
@@ -33,6 +33,7 @@
 #include <inttypes.h>
 #include <stdint.h>
 #include <sys/random.h>
+#include <stdatomic.h>
 
 #include "../kselftest.h"
 #include "vm_util.h"
@@ -104,7 +105,7 @@ extern bool map_shared;
 extern bool test_uffdio_wp;
 extern unsigned long long *count_verify;
 extern volatile bool test_uffdio_copy_eexist;
-extern pthread_barrier_t ready_for_fork;
+extern atomic_bool ready_for_fork;
 
 extern uffd_test_ops_t anon_uffd_test_ops;
 extern uffd_test_ops_t shmem_uffd_test_ops;
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -774,7 +774,7 @@ static void uffd_sigbus_test_common(bool
 	char c;
 	struct uffd_args args = { 0 };
 
-	pthread_barrier_init(&ready_for_fork, NULL, 2);
+	ready_for_fork = false;
 
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 
@@ -791,9 +791,8 @@ static void uffd_sigbus_test_common(bool
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
-	/* Wait for child thread to start before forking */
-	pthread_barrier_wait(&ready_for_fork);
-	pthread_barrier_destroy(&ready_for_fork);
+	while (!ready_for_fork)
+		; /* Wait for the poll_thread to start executing before forking */
 
 	pid = fork();
 	if (pid < 0)
@@ -834,7 +833,7 @@ static void uffd_events_test_common(bool
 	char c;
 	struct uffd_args args = { 0 };
 
-	pthread_barrier_init(&ready_for_fork, NULL, 2);
+	ready_for_fork = false;
 
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 	if (uffd_register(uffd, area_dst, nr_pages * page_size,
@@ -845,9 +844,8 @@ static void uffd_events_test_common(bool
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
-	/* Wait for child thread to start before forking */
-	pthread_barrier_wait(&ready_for_fork);
-	pthread_barrier_destroy(&ready_for_fork);
+	while (!ready_for_fork)
+		; /* Wait for the poll_thread to start executing before forking */
 
 	pid = fork();
 	if (pid < 0)


