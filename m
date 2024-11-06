Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BDB1F429C;
	Wed,  6 Nov 2024 12:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897548; cv=none; b=OXn7VvrR6u/EcY8krl96CHB/0D+oPpPv57PE3DrjM1FcRKRfB20mrG7dJAMfR+mx62TDy7ws92LuDIFW7VuI2HCKEhSVVL7tZshqRMAX3m2yOsomZ4pYmWoc5UjXKCdYV3iqFlYOrVLWd+CToCR3ZzNWWfpAEELwmN6PYZNmgzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897548; c=relaxed/simple;
	bh=GnXqGs2j03QtY9grWr6b1xIEXz/rgbTMPjoaOaM4xMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qc1oiEpzkhOAVk2jCac5QB4Plf9dBe+ZBdf970DRbl1SG3t1ilM9/13/WnnHf+Z2vy8+hKfC0y99To7mP7VrmOj5dtQxaDLDKoqbxzvElDUtgQkG0jcJiqym9MYmXHSZCPK4hw4dzRUSMbYGT0+KBydHfdVxl5l2SPMbjDi3Jdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3cgyV4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3cgyV4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94729C4CECD;
	Wed,  6 Nov 2024 12:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897548;
	bh=GnXqGs2j03QtY9grWr6b1xIEXz/rgbTMPjoaOaM4xMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3cgyV4IHOnOJB5hJpBxBdgZK0SsyvQzg1l+1BZWDTP7cEwMXTvegvOL52Q2Adokc
	 J2iKZWGBJBeofu+sRrV8i0C/0qwc5kujg92bbAw47YfZYgd03WbEyR/nEI2rtnimUc
	 ioGZhNY7+g9/L2qDltAmRD7fbdwlWORXs3cdFY/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Liaw <edliaw@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Peter Xu <peterx@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 091/151] Revert "selftests/mm: replace atomic_bool with pthread_barrier_t"
Date: Wed,  6 Nov 2024 13:04:39 +0100
Message-ID: <20241106120311.376731802@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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
@@ -17,7 +17,7 @@ bool map_shared;
 bool test_uffdio_wp = true;
 unsigned long long *count_verify;
 uffd_test_ops_t *uffd_test_ops;
-pthread_barrier_t ready_for_fork;
+atomic_bool ready_for_fork;
 
 static int uffd_mem_fd_create(off_t mem_size, bool hugetlb)
 {
@@ -508,8 +508,7 @@ void *uffd_poll_thread(void *arg)
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
@@ -98,7 +99,7 @@ extern bool map_shared;
 extern bool test_uffdio_wp;
 extern unsigned long long *count_verify;
 extern volatile bool test_uffdio_copy_eexist;
-extern pthread_barrier_t ready_for_fork;
+extern atomic_bool ready_for_fork;
 
 extern uffd_test_ops_t anon_uffd_test_ops;
 extern uffd_test_ops_t shmem_uffd_test_ops;
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -770,7 +770,7 @@ static void uffd_sigbus_test_common(bool
 	char c;
 	struct uffd_args args = { 0 };
 
-	pthread_barrier_init(&ready_for_fork, NULL, 2);
+	ready_for_fork = false;
 
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 
@@ -787,9 +787,8 @@ static void uffd_sigbus_test_common(bool
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
-	/* Wait for child thread to start before forking */
-	pthread_barrier_wait(&ready_for_fork);
-	pthread_barrier_destroy(&ready_for_fork);
+	while (!ready_for_fork)
+		; /* Wait for the poll_thread to start executing before forking */
 
 	pid = fork();
 	if (pid < 0)
@@ -830,7 +829,7 @@ static void uffd_events_test_common(bool
 	char c;
 	struct uffd_args args = { 0 };
 
-	pthread_barrier_init(&ready_for_fork, NULL, 2);
+	ready_for_fork = false;
 
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 	if (uffd_register(uffd, area_dst, nr_pages * page_size,
@@ -841,9 +840,8 @@ static void uffd_events_test_common(bool
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
-	/* Wait for child thread to start before forking */
-	pthread_barrier_wait(&ready_for_fork);
-	pthread_barrier_destroy(&ready_for_fork);
+	while (!ready_for_fork)
+		; /* Wait for the poll_thread to start executing before forking */
 
 	pid = fork();
 	if (pid < 0)


