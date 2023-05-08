Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECDD168DF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED9EC433D2;
	Mon,  8 May 2023 11:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545507;
	bh=K5PWkHY0gX4P9gjFHbQxHQakx/+1u916dwODHrMuJLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wYJWy67+Dk5hmBSJUdLVg8V0iaplB8Jq1NpM5vRiKUbVgzVj4/KxLkOFtgZRmRBpH
	 ccIMbeDBp3JmVduMy68PSrK1QFd6xM5DOnA1M5ffwu8Zu9/8RLV2yrA8So4QbcOMpI
	 4M3Vx+5Cs80EJrLyzZoTr8a0IEYt75WUnrMKRJxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/371] selftests/resctrl: Extend CPU vendor detection
Date: Mon,  8 May 2023 11:44:22 +0200
Message-Id: <20230508094814.505424505@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>

[ Upstream commit 6220f69e72a534838cffd84dce6afd777777be03 ]

Currently, the resctrl_tests only has a function to detect AMD vendor.
Since when the Intel Sub-NUMA Clustering feature is enabled,
Intel CMT and MBM counters may not be accurate,
the resctrl_tests also need a function to detect Intel vendor.
And in the future, resctrl_tests will need a function to detect different
vendors, such as Arm.

Extend the function to detect Intel vendor as well. Also,
this function can be easily extended to detect other vendors.

Signed-off-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: fa10366cc6f4 ("selftests/resctrl: Allow ->setup() to return errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/cat_test.c    |  2 +-
 tools/testing/selftests/resctrl/resctrl.h     |  5 ++-
 .../testing/selftests/resctrl/resctrl_tests.c | 41 ++++++++++++-------
 tools/testing/selftests/resctrl/resctrlfs.c   |  2 +-
 4 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/resctrl/cat_test.c b/tools/testing/selftests/resctrl/cat_test.c
index cd4f68388e0f6..1c5e90c632548 100644
--- a/tools/testing/selftests/resctrl/cat_test.c
+++ b/tools/testing/selftests/resctrl/cat_test.c
@@ -89,7 +89,7 @@ static int check_results(struct resctrl_val_param *param)
 
 	return show_cache_info(sum_llc_perf_miss, no_of_bits, param->span / 64,
 			       MAX_DIFF, MAX_DIFF_PERCENT, NUM_OF_RUNS,
-			       !is_amd, false);
+			       get_vendor() == ARCH_INTEL, false);
 }
 
 void cat_test_cleanup(void)
diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/selftests/resctrl/resctrl.h
index 1ad10c47e31d1..f0ded31fb3c7c 100644
--- a/tools/testing/selftests/resctrl/resctrl.h
+++ b/tools/testing/selftests/resctrl/resctrl.h
@@ -34,6 +34,9 @@
 #define L3_MON_PATH		"/sys/fs/resctrl/info/L3_MON"
 #define L3_MON_FEATURES_PATH	"/sys/fs/resctrl/info/L3_MON/mon_features"
 
+#define ARCH_INTEL     1
+#define ARCH_AMD       2
+
 #define PARENT_EXIT(err_msg)			\
 	do {					\
 		perror(err_msg);		\
@@ -75,8 +78,8 @@ struct resctrl_val_param {
 extern pid_t bm_pid, ppid;
 
 extern char llc_occup_path[1024];
-extern bool is_amd;
 
+int get_vendor(void);
 bool check_resctrlfs_support(void);
 int filter_dmesg(void);
 int remount_resctrlfs(bool mum_resctrlfs);
diff --git a/tools/testing/selftests/resctrl/resctrl_tests.c b/tools/testing/selftests/resctrl/resctrl_tests.c
index 973f09a66e1ee..3e7cdf1125df4 100644
--- a/tools/testing/selftests/resctrl/resctrl_tests.c
+++ b/tools/testing/selftests/resctrl/resctrl_tests.c
@@ -13,25 +13,41 @@
 #define BENCHMARK_ARGS		64
 #define BENCHMARK_ARG_SIZE	64
 
-bool is_amd;
-
-void detect_amd(void)
+static int detect_vendor(void)
 {
 	FILE *inf = fopen("/proc/cpuinfo", "r");
+	int vendor_id = 0;
+	char *s = NULL;
 	char *res;
 
 	if (!inf)
-		return;
+		return vendor_id;
 
 	res = fgrep(inf, "vendor_id");
 
-	if (res) {
-		char *s = strchr(res, ':');
+	if (res)
+		s = strchr(res, ':');
+
+	if (s && !strcmp(s, ": GenuineIntel\n"))
+		vendor_id = ARCH_INTEL;
+	else if (s && !strcmp(s, ": AuthenticAMD\n"))
+		vendor_id = ARCH_AMD;
 
-		is_amd = s && !strcmp(s, ": AuthenticAMD\n");
-		free(res);
-	}
 	fclose(inf);
+	free(res);
+	return vendor_id;
+}
+
+int get_vendor(void)
+{
+	static int vendor = -1;
+
+	if (vendor == -1)
+		vendor = detect_vendor();
+	if (vendor == 0)
+		ksft_print_msg("Can not get vendor info...\n");
+
+	return vendor;
 }
 
 static void cmd_help(void)
@@ -207,9 +223,6 @@ int main(int argc, char **argv)
 	if (geteuid() != 0)
 		return ksft_exit_fail_msg("Not running as root, abort testing.\n");
 
-	/* Detect AMD vendor */
-	detect_amd();
-
 	if (has_ben) {
 		/* Extract benchmark command from command line. */
 		for (i = ben_ind; i < argc; i++) {
@@ -241,10 +254,10 @@ int main(int argc, char **argv)
 
 	ksft_set_plan(tests ? : 4);
 
-	if (!is_amd && mbm_test)
+	if ((get_vendor() == ARCH_INTEL) && mbm_test)
 		run_mbm_test(has_ben, benchmark_cmd, span, cpu_no, bw_report);
 
-	if (!is_amd && mba_test)
+	if ((get_vendor() == ARCH_INTEL) && mba_test)
 		run_mba_test(has_ben, benchmark_cmd, span, cpu_no, bw_report);
 
 	if (cmt_test)
diff --git a/tools/testing/selftests/resctrl/resctrlfs.c b/tools/testing/selftests/resctrl/resctrlfs.c
index 5f5a166ade60a..6f543e470ad4a 100644
--- a/tools/testing/selftests/resctrl/resctrlfs.c
+++ b/tools/testing/selftests/resctrl/resctrlfs.c
@@ -106,7 +106,7 @@ int get_resource_id(int cpu_no, int *resource_id)
 	char phys_pkg_path[1024];
 	FILE *fp;
 
-	if (is_amd)
+	if (get_vendor() == ARCH_AMD)
 		sprintf(phys_pkg_path, "%s%d/cache/index3/id",
 			PHYS_ID_PATH, cpu_no);
 	else
-- 
2.39.2



