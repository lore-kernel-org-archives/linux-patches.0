Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DEF4DA10;
	Mon,  1 Apr 2024 16:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990368; cv=none; b=FI6sQUB2IFMAw0s9yWx8SP1Wdu4mIxjdoyBbd/Z1mLqQsgYui20izkGviyKpFjEoLqzDnLmYvZu/YI7A3dhZBOtaLV5MhrWx44vt8+L3vy/llRUJwhLhCUJReA2VIA6Veks083Wt9ao9kEqCB5pWSC+SUg7WVl/ASmWT7B0VFVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990368; c=relaxed/simple;
	bh=o3IE693d365Ayud37RpmMDwAZryHs0Tb/Tdkp3/k0TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHUaNFmPPeZqVCVwR605Nijy/0t4wKPHVQv4sWEblmQjOybCxM2x456rTJKtTQ8/0y6PuOeFF+d1OHAjPtUPahJDjdsPo7W5XO84FjuzKUPw9/1PZQ4g5OoHuv3SG2SUJ6m38L3xCKRYFp91yu1hD3o2eSMdmKHh3wb+gZTTPII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xp1kn3Kf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xp1kn3Kf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF5FC433F1;
	Mon,  1 Apr 2024 16:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990368;
	bh=o3IE693d365Ayud37RpmMDwAZryHs0Tb/Tdkp3/k0TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xp1kn3KfiFsxOGIE2VWuz87qF0ZPlBfvlbbnpwgRSnfv1Kxs0cJvKKmiZHVGEGsQT
	 4UHBvb+TjOx7zg72cRIme9XcMA0rCOFtXmTIHXyIthjagAIulUbuFiXpYh4xXFWnsA
	 D5nF3BSE6AnjV0zUvvYy7Fy+k5NRFWq4QpLAEtv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lokesh Gidra <lokeshgidra@google.com>,
	Edward Liaw <edliaw@google.com>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 330/396] selftests/mm: fix ARM related issue with fork after pthread_create
Date: Mon,  1 Apr 2024 17:46:19 +0200
Message-ID: <20240401152557.754533339@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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
@@ -17,6 +17,7 @@ bool map_shared;
 bool test_uffdio_wp = true;
 unsigned long long *count_verify;
 uffd_test_ops_t *uffd_test_ops;
+atomic_bool ready_for_fork;
 
 static int uffd_mem_fd_create(off_t mem_size, bool hugetlb)
 {
@@ -507,6 +508,8 @@ void *uffd_poll_thread(void *arg)
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
@@ -97,6 +98,7 @@ extern bool map_shared;
 extern bool test_uffdio_wp;
 extern unsigned long long *count_verify;
 extern volatile bool test_uffdio_copy_eexist;
+extern atomic_bool ready_for_fork;
 
 extern uffd_test_ops_t anon_uffd_test_ops;
 extern uffd_test_ops_t shmem_uffd_test_ops;
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -770,6 +770,8 @@ static void uffd_sigbus_test_common(bool
 	char c;
 	struct uffd_args args = { 0 };
 
+	ready_for_fork = false;
+
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 
 	if (uffd_register(uffd, area_dst, nr_pages * page_size,
@@ -785,6 +787,9 @@ static void uffd_sigbus_test_common(bool
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
+	while (!ready_for_fork)
+		; /* Wait for the poll_thread to start executing before forking */
+
 	pid = fork();
 	if (pid < 0)
 		err("fork");
@@ -824,6 +829,8 @@ static void uffd_events_test_common(bool
 	char c;
 	struct uffd_args args = { 0 };
 
+	ready_for_fork = false;
+
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 	if (uffd_register(uffd, area_dst, nr_pages * page_size,
 			  true, wp, false))
@@ -833,6 +840,9 @@ static void uffd_events_test_common(bool
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
+	while (!ready_for_fork)
+		; /* Wait for the poll_thread to start executing before forking */
+
 	pid = fork();
 	if (pid < 0)
 		err("fork");


