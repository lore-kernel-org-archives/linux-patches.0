Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6361E1C11;
	Mon, 21 Oct 2024 10:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506501; cv=none; b=fvoJU8ZzFSVCWzO+Ok0RWXP+G+QzerJYF2VxYX+hc6qfs3lWA05a4n+43l8wyEZ7X+Ab++V4PKEdPtuHdJQrsaFLDX3aIWwYeIBlyXuFRE84oG5CfqMTlzSlZjKBFDmVsbsWYKnoJoeCOzP3GZI6/QcQx2UdNprqXrCSHR3pOXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506501; c=relaxed/simple;
	bh=0wktlfJ0cNJMiJpnuxkezOAQtoVwUqlNFNGp6VR88U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mC5NTqY797CqJd7kKtQHz+TdMFubnECkjQQxS19ZXDVL8Zmw6R5lV9Jq0S5Yex0A9+MGwzZt/QeofvLFMCB31gBCnbCRqLw6yzw8ZpUTnbZoXOQcykpqQVmKSFUki3APZD2MTOEZFJZ4QBm+zdOR+cTDLB//08Phh6DNtrVtEwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSav55p1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSav55p1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86589C4CEC3;
	Mon, 21 Oct 2024 10:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506501;
	bh=0wktlfJ0cNJMiJpnuxkezOAQtoVwUqlNFNGp6VR88U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSav55p1ofjYU3gZa0V763DzMA4p2BxHpKiwgK7MpAmkL52bVi+O78GpfBVLoOrOI
	 mq9JPEjdQ8bNq8KMeiO6gE1qohxhDQaES/Q4K8IQwUMgNAyUNwH0Jjt8rxI5k8WyaZ
	 X2z6MguDv/n0tkQm3WlrgOJaWUrZCaR6DlQ/3LS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Liaw <edliaw@google.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	Peter Xu <peterx@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 025/135] selftests/mm: replace atomic_bool with pthread_barrier_t
Date: Mon, 21 Oct 2024 12:23:01 +0200
Message-ID: <20241021102300.321253158@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

commit e61ef21e27e8deed8c474e9f47f4aa7bc37e138c upstream.

Patch series "selftests/mm: fix deadlock after pthread_create".

On Android arm, pthread_create followed by a fork caused a deadlock in the
case where the fork required work to be completed by the created thread.

Update the synchronization primitive to use pthread_barrier instead of
atomic_bool.

Apply the same fix to the wp-fork-with-event test.


This patch (of 2):

Swap synchronization primitive with pthread_barrier, so that stdatomic.h
does not need to be included.

The synchronization is needed on Android ARM64; we see a deadlock with
pthread_create when the parent thread races forward before the child has a
chance to start doing work.

Link: https://lkml.kernel.org/r/20241003211716.371786-1-edliaw@google.com
Link: https://lkml.kernel.org/r/20241003211716.371786-2-edliaw@google.com
Fixes: cff294582798 ("selftests/mm: extend and rename uffd pagemap test")
Signed-off-by: Edward Liaw <edliaw@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/uffd-common.c     |    5 +++--
 tools/testing/selftests/mm/uffd-common.h     |    3 +--
 tools/testing/selftests/mm/uffd-unit-tests.c |   14 ++++++++------
 3 files changed, 12 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c
+++ b/tools/testing/selftests/mm/uffd-common.c
@@ -18,7 +18,7 @@ bool test_uffdio_wp = true;
 unsigned long long *count_verify;
 uffd_test_ops_t *uffd_test_ops;
 uffd_test_case_ops_t *uffd_test_case_ops;
-atomic_bool ready_for_fork;
+pthread_barrier_t ready_for_fork;
 
 static int uffd_mem_fd_create(off_t mem_size, bool hugetlb)
 {
@@ -519,7 +519,8 @@ void *uffd_poll_thread(void *arg)
 	pollfd[1].fd = pipefd[cpu*2];
 	pollfd[1].events = POLLIN;
 
-	ready_for_fork = true;
+	/* Ready for parent thread to fork */
+	pthread_barrier_wait(&ready_for_fork);
 
 	for (;;) {
 		ret = poll(pollfd, 2, -1);
--- a/tools/testing/selftests/mm/uffd-common.h
+++ b/tools/testing/selftests/mm/uffd-common.h
@@ -33,7 +33,6 @@
 #include <inttypes.h>
 #include <stdint.h>
 #include <sys/random.h>
-#include <stdatomic.h>
 
 #include "../kselftest.h"
 #include "vm_util.h"
@@ -105,7 +104,7 @@ extern bool map_shared;
 extern bool test_uffdio_wp;
 extern unsigned long long *count_verify;
 extern volatile bool test_uffdio_copy_eexist;
-extern atomic_bool ready_for_fork;
+extern pthread_barrier_t ready_for_fork;
 
 extern uffd_test_ops_t anon_uffd_test_ops;
 extern uffd_test_ops_t shmem_uffd_test_ops;
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -774,7 +774,7 @@ static void uffd_sigbus_test_common(bool
 	char c;
 	struct uffd_args args = { 0 };
 
-	ready_for_fork = false;
+	pthread_barrier_init(&ready_for_fork, NULL, 2);
 
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 
@@ -791,8 +791,9 @@ static void uffd_sigbus_test_common(bool
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
-	while (!ready_for_fork)
-		; /* Wait for the poll_thread to start executing before forking */
+	/* Wait for child thread to start before forking */
+	pthread_barrier_wait(&ready_for_fork);
+	pthread_barrier_destroy(&ready_for_fork);
 
 	pid = fork();
 	if (pid < 0)
@@ -833,7 +834,7 @@ static void uffd_events_test_common(bool
 	char c;
 	struct uffd_args args = { 0 };
 
-	ready_for_fork = false;
+	pthread_barrier_init(&ready_for_fork, NULL, 2);
 
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 	if (uffd_register(uffd, area_dst, nr_pages * page_size,
@@ -844,8 +845,9 @@ static void uffd_events_test_common(bool
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
-	while (!ready_for_fork)
-		; /* Wait for the poll_thread to start executing before forking */
+	/* Wait for child thread to start before forking */
+	pthread_barrier_wait(&ready_for_fork);
+	pthread_barrier_destroy(&ready_for_fork);
 
 	pid = fork();
 	if (pid < 0)


