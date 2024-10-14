Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FBA1AB521;
	Mon, 14 Oct 2024 14:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917988; cv=none; b=UzSPElo1PQtK2soZnih+0wWmZdI3y3/trI6HlsfPF2y9pk3qVHCtqMMgDNeQE3eSebhEwT/WjMmKft3cgvGYiPhva7S3LoheEiwHkfN7Nkr4iStCDVFKChll0TxPasekwXcuQW3ACxEQ5ZOJZ7qujSM308qpMazgAIIwR3cQFEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917988; c=relaxed/simple;
	bh=y3ql5Jc5HGRDCdJNp1Jup2IhSZCLKkFWiPWnGsrVvxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNc2EFv1Vv8DOSpfRb2dEomr4Ht+pqNbYx5t2t+e2SmwZ3Llu5pdTHJJ+78UzQq2e0awghmxycNtx8H5w84NxN1y1Z13rv58tVFA9SRC+ojQe7cUv9lDR+uUNkzSZhweX3H30OtFT2KxXHviSChfzceuWaHitS7wndIC3z7VjA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7pBP65R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7pBP65R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE01C4CEC3;
	Mon, 14 Oct 2024 14:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917987;
	bh=y3ql5Jc5HGRDCdJNp1Jup2IhSZCLKkFWiPWnGsrVvxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7pBP65RXNloLRVI6lJHqYLweGGrIF4nOsIOjfkQTNRkRwZBS4URI05COQH8qVave
	 0zG6KO0XBrvx8HDP0pD4kOIBSqwMwjEW57I7uOQVsNy0VD3mSvgNQUSwSX891QMNUn
	 9emSbYFwibMZFjRSp7Zk5lP1W/Jof/wFi/otrJ5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Vernet <void@manifault.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/798] selftests/bpf: Move test_progs helpers to testing_helpers object
Date: Mon, 14 Oct 2024 16:11:53 +0200
Message-ID: <20241014141224.160074393@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 45db310984bfea977177fb5fc0ea23ab430129bd ]

Moving test_progs helpers to testing_helpers object so they can be
used from test_verifier in following changes.

Also adding missing ifndef header guard to testing_helpers.h header.

Using stderr instead of env.stderr because un/load_bpf_testmod helpers
will be used outside test_progs. Also at the point of calling them
in test_progs the std files are not hijacked yet and stderr is the
same as env.stderr.

Acked-by: David Vernet <void@manifault.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20230515133756.1658301-4-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: c9a83e76b5a9 ("selftests/bpf: Fix compile if backtrace support missing in libc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c      | 67 +------------------
 tools/testing/selftests/bpf/test_progs.h      |  1 -
 tools/testing/selftests/bpf/testing_helpers.c | 63 +++++++++++++++++
 tools/testing/selftests/bpf/testing_helpers.h |  9 +++
 4 files changed, 74 insertions(+), 66 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 513ee92e4f67c..e78289b72739f 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -11,7 +11,6 @@
 #include <signal.h>
 #include <string.h>
 #include <execinfo.h> /* backtrace */
-#include <linux/membarrier.h>
 #include <sys/sysinfo.h> /* get_nprocs */
 #include <netinet/in.h>
 #include <sys/select.h>
@@ -583,68 +582,6 @@ int compare_stack_ips(int smap_fd, int amap_fd, int stack_trace_len)
 	return err;
 }
 
-static int finit_module(int fd, const char *param_values, int flags)
-{
-	return syscall(__NR_finit_module, fd, param_values, flags);
-}
-
-static int delete_module(const char *name, int flags)
-{
-	return syscall(__NR_delete_module, name, flags);
-}
-
-/*
- * Trigger synchronize_rcu() in kernel.
- */
-int kern_sync_rcu(void)
-{
-	return syscall(__NR_membarrier, MEMBARRIER_CMD_SHARED, 0, 0);
-}
-
-static void unload_bpf_testmod(void)
-{
-	if (kern_sync_rcu())
-		fprintf(env.stderr, "Failed to trigger kernel-side RCU sync!\n");
-	if (delete_module("bpf_testmod", 0)) {
-		if (errno == ENOENT) {
-			if (verbose())
-				fprintf(stdout, "bpf_testmod.ko is already unloaded.\n");
-			return;
-		}
-		fprintf(env.stderr, "Failed to unload bpf_testmod.ko from kernel: %d\n", -errno);
-		return;
-	}
-	if (verbose())
-		fprintf(stdout, "Successfully unloaded bpf_testmod.ko.\n");
-}
-
-static int load_bpf_testmod(void)
-{
-	int fd;
-
-	/* ensure previous instance of the module is unloaded */
-	unload_bpf_testmod();
-
-	if (verbose())
-		fprintf(stdout, "Loading bpf_testmod.ko...\n");
-
-	fd = open("bpf_testmod.ko", O_RDONLY);
-	if (fd < 0) {
-		fprintf(env.stderr, "Can't find bpf_testmod.ko kernel module: %d\n", -errno);
-		return -ENOENT;
-	}
-	if (finit_module(fd, "", 0)) {
-		fprintf(env.stderr, "Failed to load bpf_testmod.ko into the kernel: %d\n", -errno);
-		close(fd);
-		return -EINVAL;
-	}
-	close(fd);
-
-	if (verbose())
-		fprintf(stdout, "Successfully loaded bpf_testmod.ko.\n");
-	return 0;
-}
-
 /* extern declarations for test funcs */
 #define DEFINE_TEST(name)				\
 	extern void test_##name(void) __weak;		\
@@ -1586,7 +1523,7 @@ int main(int argc, char **argv)
 	env.stderr = stderr;
 
 	env.has_testmod = true;
-	if (!env.list_test_names && load_bpf_testmod()) {
+	if (!env.list_test_names && load_bpf_testmod(verbose())) {
 		fprintf(env.stderr, "WARNING! Selftests relying on bpf_testmod.ko will be skipped.\n");
 		env.has_testmod = false;
 	}
@@ -1685,7 +1622,7 @@ int main(int argc, char **argv)
 	close(env.saved_netns_fd);
 out:
 	if (!env.list_test_names && env.has_testmod)
-		unload_bpf_testmod();
+		unload_bpf_testmod(verbose());
 
 	free_test_selector(&env.test_selector);
 	free_test_selector(&env.subtest_selector);
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index 924764f6ba976..feb14f14006d9 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -380,7 +380,6 @@ static inline void *u64_to_ptr(__u64 ptr)
 int bpf_find_map(const char *test, struct bpf_object *obj, const char *name);
 int compare_map_keys(int map1_fd, int map2_fd);
 int compare_stack_ips(int smap_fd, int amap_fd, int stack_trace_len);
-int kern_sync_rcu(void);
 int trigger_module_test_read(int read_sz);
 int trigger_module_test_write(int write_sz);
 int write_sysctl(const char *sysctl, const char *value);
diff --git a/tools/testing/selftests/bpf/testing_helpers.c b/tools/testing/selftests/bpf/testing_helpers.c
index 9c3de39023f60..cbf7e8cdd3e2f 100644
--- a/tools/testing/selftests/bpf/testing_helpers.c
+++ b/tools/testing/selftests/bpf/testing_helpers.c
@@ -8,6 +8,7 @@
 #include <bpf/libbpf.h>
 #include "test_progs.h"
 #include "testing_helpers.h"
+#include <linux/membarrier.h>
 
 int parse_num_list(const char *s, bool **num_set, int *num_set_len)
 {
@@ -249,3 +250,65 @@ __u64 read_perf_max_sample_freq(void)
 	fclose(f);
 	return sample_freq;
 }
+
+static int finit_module(int fd, const char *param_values, int flags)
+{
+	return syscall(__NR_finit_module, fd, param_values, flags);
+}
+
+static int delete_module(const char *name, int flags)
+{
+	return syscall(__NR_delete_module, name, flags);
+}
+
+void unload_bpf_testmod(bool verbose)
+{
+	if (kern_sync_rcu())
+		fprintf(stderr, "Failed to trigger kernel-side RCU sync!\n");
+	if (delete_module("bpf_testmod", 0)) {
+		if (errno == ENOENT) {
+			if (verbose)
+				fprintf(stdout, "bpf_testmod.ko is already unloaded.\n");
+			return;
+		}
+		fprintf(stderr, "Failed to unload bpf_testmod.ko from kernel: %d\n", -errno);
+		return;
+	}
+	if (verbose)
+		fprintf(stdout, "Successfully unloaded bpf_testmod.ko.\n");
+}
+
+int load_bpf_testmod(bool verbose)
+{
+	int fd;
+
+	/* ensure previous instance of the module is unloaded */
+	unload_bpf_testmod(verbose);
+
+	if (verbose)
+		fprintf(stdout, "Loading bpf_testmod.ko...\n");
+
+	fd = open("bpf_testmod.ko", O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, "Can't find bpf_testmod.ko kernel module: %d\n", -errno);
+		return -ENOENT;
+	}
+	if (finit_module(fd, "", 0)) {
+		fprintf(stderr, "Failed to load bpf_testmod.ko into the kernel: %d\n", -errno);
+		close(fd);
+		return -EINVAL;
+	}
+	close(fd);
+
+	if (verbose)
+		fprintf(stdout, "Successfully loaded bpf_testmod.ko.\n");
+	return 0;
+}
+
+/*
+ * Trigger synchronize_rcu() in kernel.
+ */
+int kern_sync_rcu(void)
+{
+	return syscall(__NR_membarrier, MEMBARRIER_CMD_SHARED, 0, 0);
+}
diff --git a/tools/testing/selftests/bpf/testing_helpers.h b/tools/testing/selftests/bpf/testing_helpers.h
index eb8790f928e4c..f72fb24f8e90f 100644
--- a/tools/testing/selftests/bpf/testing_helpers.h
+++ b/tools/testing/selftests/bpf/testing_helpers.h
@@ -1,5 +1,9 @@
 /* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
 /* Copyright (C) 2020 Facebook, Inc. */
+
+#ifndef __TESTING_HELPERS_H
+#define __TESTING_HELPERS_H
+
 #include <stdbool.h>
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
@@ -22,3 +26,8 @@ int parse_test_list(const char *s,
 		    bool is_glob_pattern);
 
 __u64 read_perf_max_sample_freq(void);
+int load_bpf_testmod(bool verbose);
+void unload_bpf_testmod(bool verbose);
+int kern_sync_rcu(void);
+
+#endif /* __TESTING_HELPERS_H */
-- 
2.43.0



