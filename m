Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BD639FF8;
	Fri, 24 Nov 2023 18:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWCeUrL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F2BC433C8;
	Fri, 24 Nov 2023 18:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850073;
	bh=kgkagFCmEYnAyWfmjpB0XJedXgxjMHBC590Mdx/ZT90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWCeUrL5HL39HqBndWJC+p/AMzKl9q55YUGVUDAn3Lqo3ol2rEAja351rgqnBsYHf
	 zbdIt0p6O1HpERYPhgJoBF6qwylc2ZaLxj6Xfn8V6kr/wz3qlW/2IW6DFoJXrHkDh2
	 VVJJWBNyrnjupx/5zsiBKZBrUuQQtwL/H4HSrQIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 410/530] selftests/resctrl: Make benchmark command const and build it with pointers
Date: Fri, 24 Nov 2023 17:49:36 +0000
Message-ID: <20231124172040.530716542@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit e33cb5702a9f287d829b0e9e6abe57f6a4aba6d2 ]

Benchmark command is used in multiple tests so it should not be
mutated by the tests but CMT test alters span argument. Due to the
order of tests (CMT test runs last), mutating the span argument in CMT
test does not trigger any real problems currently.

Mark benchmark_cmd strings as const and setup the benchmark command
using pointers. Because the benchmark command becomes const, the input
arguments can be used directly. Besides being simpler, using the input
arguments directly also removes the internal size restriction.

CMT test has to create a copy of the benchmark command before altering
the benchmark command.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: "Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: 3aff51464455 ("selftests/resctrl: Extend signal handler coverage to unmount on receiving signal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/cmt_test.c    | 25 +++++++++---
 tools/testing/selftests/resctrl/mba_test.c    |  2 +-
 tools/testing/selftests/resctrl/mbm_test.c    |  2 +-
 tools/testing/selftests/resctrl/resctrl.h     | 10 +++--
 .../testing/selftests/resctrl/resctrl_tests.c | 39 ++++++++-----------
 tools/testing/selftests/resctrl/resctrl_val.c | 10 ++++-
 6 files changed, 53 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/resctrl/cmt_test.c b/tools/testing/selftests/resctrl/cmt_test.c
index 33dbe51e77122..50bdbce9fba95 100644
--- a/tools/testing/selftests/resctrl/cmt_test.c
+++ b/tools/testing/selftests/resctrl/cmt_test.c
@@ -68,14 +68,17 @@ void cmt_test_cleanup(void)
 	remove(RESULT_FILE_NAME);
 }
 
-int cmt_resctrl_val(int cpu_no, int n, char **benchmark_cmd)
+int cmt_resctrl_val(int cpu_no, int n, const char * const *benchmark_cmd)
 {
+	const char * const *cmd = benchmark_cmd;
+	const char *new_cmd[BENCHMARK_ARGS];
 	unsigned long cache_size = 0;
 	unsigned long long_mask;
+	char *span_str = NULL;
 	char cbm_mask[256];
 	int count_of_bits;
 	size_t span;
-	int ret;
+	int ret, i;
 
 	ret = get_cbm_mask("L3", cbm_mask);
 	if (ret)
@@ -108,12 +111,23 @@ int cmt_resctrl_val(int cpu_no, int n, char **benchmark_cmd)
 	};
 
 	span = cache_size * n / count_of_bits;
-	if (strcmp(benchmark_cmd[0], "fill_buf") == 0)
-		sprintf(benchmark_cmd[1], "%zu", span);
+
+	if (strcmp(cmd[0], "fill_buf") == 0) {
+		/* Duplicate the command to be able to replace span in it */
+		for (i = 0; benchmark_cmd[i]; i++)
+			new_cmd[i] = benchmark_cmd[i];
+		new_cmd[i] = NULL;
+
+		ret = asprintf(&span_str, "%zu", span);
+		if (ret < 0)
+			return -1;
+		new_cmd[1] = span_str;
+		cmd = new_cmd;
+	}
 
 	remove(RESULT_FILE_NAME);
 
-	ret = resctrl_val(benchmark_cmd, &param);
+	ret = resctrl_val(cmd, &param);
 	if (ret)
 		goto out;
 
@@ -121,6 +135,7 @@ int cmt_resctrl_val(int cpu_no, int n, char **benchmark_cmd)
 
 out:
 	cmt_test_cleanup();
+	free(span_str);
 
 	return ret;
 }
diff --git a/tools/testing/selftests/resctrl/mba_test.c b/tools/testing/selftests/resctrl/mba_test.c
index c5c0588779d2b..d3bf4368341ec 100644
--- a/tools/testing/selftests/resctrl/mba_test.c
+++ b/tools/testing/selftests/resctrl/mba_test.c
@@ -141,7 +141,7 @@ void mba_test_cleanup(void)
 	remove(RESULT_FILE_NAME);
 }
 
-int mba_schemata_change(int cpu_no, char **benchmark_cmd)
+int mba_schemata_change(int cpu_no, const char * const *benchmark_cmd)
 {
 	struct resctrl_val_param param = {
 		.resctrl_val	= MBA_STR,
diff --git a/tools/testing/selftests/resctrl/mbm_test.c b/tools/testing/selftests/resctrl/mbm_test.c
index 445aea1c64e83..d3c0d30c676a7 100644
--- a/tools/testing/selftests/resctrl/mbm_test.c
+++ b/tools/testing/selftests/resctrl/mbm_test.c
@@ -109,7 +109,7 @@ void mbm_test_cleanup(void)
 	remove(RESULT_FILE_NAME);
 }
 
-int mbm_bw_change(int cpu_no, char **benchmark_cmd)
+int mbm_bw_change(int cpu_no, const char * const *benchmark_cmd)
 {
 	struct resctrl_val_param param = {
 		.resctrl_val	= MBM_STR,
diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/selftests/resctrl/resctrl.h
index d33452fde5b94..8578a8b4e1459 100644
--- a/tools/testing/selftests/resctrl/resctrl.h
+++ b/tools/testing/selftests/resctrl/resctrl.h
@@ -33,6 +33,8 @@
 
 #define END_OF_TESTS	1
 
+#define BENCHMARK_ARGS		64
+
 #define DEFAULT_SPAN		(250 * MB)
 
 #define PARENT_EXIT(err_msg)			\
@@ -92,11 +94,11 @@ int write_bm_pid_to_resctrl(pid_t bm_pid, char *ctrlgrp, char *mongrp,
 int perf_event_open(struct perf_event_attr *hw_event, pid_t pid, int cpu,
 		    int group_fd, unsigned long flags);
 int run_fill_buf(size_t span, int memflush, int op, bool once);
-int resctrl_val(char **benchmark_cmd, struct resctrl_val_param *param);
-int mbm_bw_change(int cpu_no, char **benchmark_cmd);
+int resctrl_val(const char * const *benchmark_cmd, struct resctrl_val_param *param);
+int mbm_bw_change(int cpu_no, const char * const *benchmark_cmd);
 void tests_cleanup(void);
 void mbm_test_cleanup(void);
-int mba_schemata_change(int cpu_no, char **benchmark_cmd);
+int mba_schemata_change(int cpu_no, const char * const *benchmark_cmd);
 void mba_test_cleanup(void);
 int get_cbm_mask(char *cache_type, char *cbm_mask);
 int get_cache_size(int cpu_no, char *cache_type, unsigned long *cache_size);
@@ -106,7 +108,7 @@ void signal_handler_unregister(void);
 int cat_val(struct resctrl_val_param *param, size_t span);
 void cat_test_cleanup(void);
 int cat_perf_miss_val(int cpu_no, int no_of_bits, char *cache_type);
-int cmt_resctrl_val(int cpu_no, int n, char **benchmark_cmd);
+int cmt_resctrl_val(int cpu_no, int n, const char * const *benchmark_cmd);
 unsigned int count_bits(unsigned long n);
 void cmt_test_cleanup(void);
 int get_core_sibling(int cpu_no);
diff --git a/tools/testing/selftests/resctrl/resctrl_tests.c b/tools/testing/selftests/resctrl/resctrl_tests.c
index 1826b674ea300..1ac22c6d8ce8f 100644
--- a/tools/testing/selftests/resctrl/resctrl_tests.c
+++ b/tools/testing/selftests/resctrl/resctrl_tests.c
@@ -10,9 +10,6 @@
  */
 #include "resctrl.h"
 
-#define BENCHMARK_ARGS		64
-#define BENCHMARK_ARG_SIZE	64
-
 static int detect_vendor(void)
 {
 	FILE *inf = fopen("/proc/cpuinfo", "r");
@@ -70,7 +67,7 @@ void tests_cleanup(void)
 	cat_test_cleanup();
 }
 
-static void run_mbm_test(char **benchmark_cmd, int cpu_no)
+static void run_mbm_test(const char * const *benchmark_cmd, int cpu_no)
 {
 	int res;
 
@@ -98,7 +95,7 @@ static void run_mbm_test(char **benchmark_cmd, int cpu_no)
 	umount_resctrlfs();
 }
 
-static void run_mba_test(char **benchmark_cmd, int cpu_no)
+static void run_mba_test(const char * const *benchmark_cmd, int cpu_no)
 {
 	int res;
 
@@ -124,7 +121,7 @@ static void run_mba_test(char **benchmark_cmd, int cpu_no)
 	umount_resctrlfs();
 }
 
-static void run_cmt_test(char **benchmark_cmd, int cpu_no)
+static void run_cmt_test(const char * const *benchmark_cmd, int cpu_no)
 {
 	int res;
 
@@ -178,11 +175,12 @@ static void run_cat_test(int cpu_no, int no_of_bits)
 int main(int argc, char **argv)
 {
 	bool has_ben = false, mbm_test = true, mba_test = true, cmt_test = true;
-	char benchmark_cmd_area[BENCHMARK_ARGS][BENCHMARK_ARG_SIZE];
 	int c, cpu_no = 1, argc_new = argc, i, no_of_bits = 0;
-	char *benchmark_cmd[BENCHMARK_ARGS];
+	const char *benchmark_cmd[BENCHMARK_ARGS];
 	int ben_ind, ben_count, tests = 0;
+	char *span_str = NULL;
 	bool cat_test = true;
+	int ret;
 
 	for (i = 0; i < argc; i++) {
 		if (strcmp(argv[i], "-b") == 0) {
@@ -262,23 +260,19 @@ int main(int argc, char **argv)
 			ksft_exit_fail_msg("Too long benchmark command.\n");
 
 		/* Extract benchmark command from command line. */
-		for (i = ben_ind; i < argc; i++) {
-			benchmark_cmd[i - ben_ind] = benchmark_cmd_area[i];
-			if (strlen(argv[i]) >= BENCHMARK_ARG_SIZE)
-				ksft_exit_fail_msg("Too long benchmark command argument.\n");
-			sprintf(benchmark_cmd[i - ben_ind], "%s", argv[i]);
-		}
+		for (i = 0; i < argc - ben_ind; i++)
+			benchmark_cmd[i] = argv[i + ben_ind];
 		benchmark_cmd[ben_count] = NULL;
 	} else {
 		/* If no benchmark is given by "-b" argument, use fill_buf. */
-		for (i = 0; i < 5; i++)
-			benchmark_cmd[i] = benchmark_cmd_area[i];
-
-		strcpy(benchmark_cmd[0], "fill_buf");
-		sprintf(benchmark_cmd[1], "%u", DEFAULT_SPAN);
-		strcpy(benchmark_cmd[2], "1");
-		strcpy(benchmark_cmd[3], "0");
-		strcpy(benchmark_cmd[4], "false");
+		benchmark_cmd[0] = "fill_buf";
+		ret = asprintf(&span_str, "%u", DEFAULT_SPAN);
+		if (ret < 0)
+			ksft_exit_fail_msg("Out of memory!\n");
+		benchmark_cmd[1] = span_str;
+		benchmark_cmd[2] = "1";
+		benchmark_cmd[3] = "0";
+		benchmark_cmd[4] = "false";
 		benchmark_cmd[5] = NULL;
 	}
 
@@ -304,5 +298,6 @@ int main(int argc, char **argv)
 	if (cat_test)
 		run_cat_test(cpu_no, no_of_bits);
 
+	free(span_str);
 	ksft_finished();
 }
diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
index ee07e0943f583..01bbe11a89834 100644
--- a/tools/testing/selftests/resctrl/resctrl_val.c
+++ b/tools/testing/selftests/resctrl/resctrl_val.c
@@ -629,7 +629,7 @@ measure_vals(struct resctrl_val_param *param, unsigned long *bw_resc_start)
  *
  * Return:		0 on success. non-zero on failure.
  */
-int resctrl_val(char **benchmark_cmd, struct resctrl_val_param *param)
+int resctrl_val(const char * const *benchmark_cmd, struct resctrl_val_param *param)
 {
 	char *resctrl_val = param->resctrl_val;
 	unsigned long bw_resc_start = 0;
@@ -710,7 +710,13 @@ int resctrl_val(char **benchmark_cmd, struct resctrl_val_param *param)
 	if (ret)
 		goto out;
 
-	value.sival_ptr = benchmark_cmd;
+	/*
+	 * The cast removes constness but nothing mutates benchmark_cmd within
+	 * the context of this process. At the receiving process, it becomes
+	 * argv, which is mutable, on exec() but that's after fork() so it
+	 * doesn't matter for the process running the tests.
+	 */
+	value.sival_ptr = (void *)benchmark_cmd;
 
 	/* Taskset benchmark to specified cpu */
 	ret = taskset_benchmark(bm_pid, param->cpu_no);
-- 
2.42.0



