Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A928328D83E;
	Mon, 13 Oct 2025 15:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369238; cv=none; b=Hy+8B1wurqAyE6Rmjc8o9vE+RJkF9YQTrqHUu6qYDv+/2/cY/EYUze5COJRDrbdmocUMJJs1UQnVfS/dcTUT18wI90Gk0lcYSOm7Jrpm/faYxXxdVmzOkaUtDjfSGYYyOGDgF0ihLfzvxFrIw+CWCPUtP1xKZUwiRR6nYv2PJmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369238; c=relaxed/simple;
	bh=+cxVP38u/GJ0aCpsacxkW4uydzWMgB5zG6eEO8kjrHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyeJpCMjKKkzvG+23bKcTB2wWfqhBOunX/7VHhwd/yLfGY3XNAme4sfMic10ERueIaqMV1GbfTqwkM2+1L5sgJG1y+BILyHIvTmJBX5CNGTyhLUSMM8Fc9Ys3n7NbmpoAmyztI1KPxOITVCgPiPDEwowWnlB5vbNWzPygz2gqJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6yo4axs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6yo4axs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8CDC4CEE7;
	Mon, 13 Oct 2025 15:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369238;
	bh=+cxVP38u/GJ0aCpsacxkW4uydzWMgB5zG6eEO8kjrHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6yo4axs9SGSuoVQ4xXaYaJ2U6NoJE8IZgMABw9C6t1KBwxIa/tia1GB2fIVh1hhw
	 YfXLfYe/gO6Sk2NEnZy1IukUeXdJZpb6QmW/p0jIRtmMt6NVt6A/cYXO4NTdEI7t+U
	 xIu6xQeNriBJi8WRFksrVa9GhF9iepVFnR5+Mt68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 177/563] selftest/futex: Compile also with libnuma < 2.0.16
Date: Mon, 13 Oct 2025 16:40:38 +0200
Message-ID: <20251013144417.698419341@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit ed323aeda5e09fa1ab95946673939c8c425c329c ]

After using numa_set_mempolicy_home_node() the test fails to compile on
systems with libnuma library versioned lower than 2.0.16.

In order to allow lower library version add a pkg-config related check
and exclude that part of the code. Without the proper MPOL setup it
can't be tested.

Make a total number of tests two. The first one is the first batch and
the second is the MPOL related one. The goal is to let the user know if
it has been skipped due to library limitation.

Remove test_futex_mpol(), it was unused and it is now complained by the
compiler if the part is not compiled.

Fixes: 0ecb4232fc65e ("selftests/futex: Set the home_node in futex_numa_mpol")
Closes: https://lore.kernel.org/oe-lkp/202507150858.bedaf012-lkp@intel.com
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/futex/functional/Makefile       |  5 ++++-
 .../futex/functional/futex_numa_mpol.c        | 21 +++++++++----------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/testing/selftests/futex/functional/Makefile
index ddfa61d857b9b..bd50aecfca8a3 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -1,6 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
+PKG_CONFIG ?= pkg-config
+LIBNUMA_TEST = $(shell sh -c "$(PKG_CONFIG) numa --atleast-version 2.0.16 > /dev/null 2>&1 && echo SUFFICIENT || echo NO")
+
 INCLUDES := -I../include -I../../ $(KHDR_INCLUDES)
-CFLAGS := $(CFLAGS) -g -O2 -Wall -pthread -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64 $(INCLUDES) $(KHDR_INCLUDES)
+CFLAGS := $(CFLAGS) -g -O2 -Wall -pthread -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64 $(INCLUDES) $(KHDR_INCLUDES) -DLIBNUMA_VER_$(LIBNUMA_TEST)=1
 LDLIBS := -lpthread -lrt -lnuma
 
 LOCAL_HDRS := \
diff --git a/tools/testing/selftests/futex/functional/futex_numa_mpol.c b/tools/testing/selftests/futex/functional/futex_numa_mpol.c
index dd7b05e8cda45..7f2b2e1ff9f8a 100644
--- a/tools/testing/selftests/futex/functional/futex_numa_mpol.c
+++ b/tools/testing/selftests/futex/functional/futex_numa_mpol.c
@@ -131,11 +131,6 @@ static void test_futex(void *futex_ptr, int err_value)
 	__test_futex(futex_ptr, err_value, FUTEX2_SIZE_U32 | FUTEX_PRIVATE_FLAG | FUTEX2_NUMA);
 }
 
-static void test_futex_mpol(void *futex_ptr, int err_value)
-{
-	__test_futex(futex_ptr, err_value, FUTEX2_SIZE_U32 | FUTEX_PRIVATE_FLAG | FUTEX2_NUMA | FUTEX2_MPOL);
-}
-
 static void usage(char *prog)
 {
 	printf("Usage: %s\n", prog);
@@ -148,7 +143,7 @@ static void usage(char *prog)
 int main(int argc, char *argv[])
 {
 	struct futex32_numa *futex_numa;
-	int mem_size, i;
+	int mem_size;
 	void *futex_ptr;
 	int c;
 
@@ -171,7 +166,7 @@ int main(int argc, char *argv[])
 	}
 
 	ksft_print_header();
-	ksft_set_plan(1);
+	ksft_set_plan(2);
 
 	mem_size = sysconf(_SC_PAGE_SIZE);
 	futex_ptr = mmap(NULL, mem_size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
@@ -205,8 +200,11 @@ int main(int argc, char *argv[])
 	ksft_print_msg("Memory back to RW\n");
 	test_futex(futex_ptr, 0);
 
+	ksft_test_result_pass("futex2 memory boundarie tests passed\n");
+
 	/* MPOL test. Does not work as expected */
-	for (i = 0; i < 4; i++) {
+#ifdef LIBNUMA_VER_SUFFICIENT
+	for (int i = 0; i < 4; i++) {
 		unsigned long nodemask;
 		int ret;
 
@@ -225,15 +223,16 @@ int main(int argc, char *argv[])
 			ret = futex2_wake(futex_ptr, 0, FUTEX2_SIZE_U32 | FUTEX_PRIVATE_FLAG | FUTEX2_NUMA | FUTEX2_MPOL);
 			if (ret < 0)
 				ksft_test_result_fail("Failed to wake 0 with MPOL: %m\n");
-			if (0)
-				test_futex_mpol(futex_numa, 0);
 			if (futex_numa->numa != i) {
 				ksft_exit_fail_msg("Returned NUMA node is %d expected %d\n",
 						   futex_numa->numa, i);
 			}
 		}
 	}
-	ksft_test_result_pass("NUMA MPOL tests passed\n");
+	ksft_test_result_pass("futex2 MPOL hints test passed\n");
+#else
+	ksft_test_result_skip("futex2 MPOL hints test requires libnuma 2.0.16+\n");
+#endif
 	ksft_finished();
 	return 0;
 }
-- 
2.51.0



