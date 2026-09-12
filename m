Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B410436606A;
	Sat, 12 Sep 2026 07:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199694; cv=none; b=ZWw3cN8MdBTRnZlc82TWYQ9SfJh5JZ163L9CpgelFUXs3x+URJtn44lvEF9cqwmMh1b1IlPRwllLv015mb0lYsIqqcPom0QAbXdLfJJk7AgDPaU1PLHu6cfOqdwj+Mku1+2SwHpF5hN+0Y7xlHFkvOwN8kUUlTD4wz7twxMDZJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199694; c=relaxed/simple;
	bh=4xGjRkdM2b2K1CW7pVE/ElVgKkHT43CbM2B1uXOd58Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+Jrdxx0qoXTLxJOFtKNlhNNgW+oQ6sUmqHiySATeoepcsgwX5DW2oMSVr124YAHLcq1jmm8soOYQ3uAHy4b+xVxSQs8wRa+PlXmdhl3YYgaiy2nWqek6EzeqSCWGz4IspUNJ/QFlSxjz00unnX4nDMXSDLzUUB1md3JZW63OrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+7b2lOs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+7b2lOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A5C1F000FF;
	Sat, 12 Sep 2026 07:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199692;
	bh=cyc5jhrusAeIJoOF+wP0VYYhCDeOCs8zI9V+Jfl6iCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s+7b2lOsPfw7/Z23ykj3GZChnG6SUxQz+0sw5Tjd53hZeGHLL0u7LlrPcF9cP81Z3
	 JPCExXlr/HWrBt03kvC9bsB5lsfcIZlN837QqrdLqY6/mQx5L3MzK6dZHF5znMHiil
	 hk5JBSUz8Zy7JOTYVELndO98XjLoguXA210M/LBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0635/1815] perf cap: Remove used_root parameter and simplify capability checks
Date: Sat, 12 Sep 2026 08:39:45 +0200
Message-ID: <20260912065703.785472728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 87ec3437f37b9fe44c524ba967cb12e78de06f15 ]

Refactor perf_cap__capable() to completely remove the used_root out-parameter
as requested by the maintainer. Relying on an explicit used_root boolean
poisoned sequential capability checks (e.g. failing CAP_SYS_ADMIN checks
poisoning the flag for subsequent CAP_PERFMON evaluations for unprivileged
users) and created redundant complexity across check_ftrace_capable(),
symbol__read_kptr_restrict(), and perf_event_paranoid_check().

Streamline the capability API to perform a pure true/false boolean
evaluation. The function checks the Effective set using SYS_capget; if
the syscall is missing or fails on legacy kernels, it cleanly falls back
to checking EUID == 0. This perfectly preserves modern capability-aware host
sessions, guarantees transparent fallback for older kernels, and correctly
rejects privileged operations for containerized root processes that have
explicitly dropped their capability bounding and permitted sets.

Fixes: e25ebda78e23 ("perf cap: Tidy up and improve capability testing")
Suggested-by: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-ftrace.c  | 13 +++----------
 tools/perf/util/bpf-filter.c | 22 +++++++++-------------
 tools/perf/util/cap.c        |  4 +---
 tools/perf/util/cap.h        |  3 +--
 tools/perf/util/symbol.c     |  3 +--
 tools/perf/util/util.c       | 12 +++---------
 6 files changed, 18 insertions(+), 39 deletions(-)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 9e4c5220d43c2..f7126196b0921 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -72,18 +72,11 @@ static void ftrace__workload_exec_failed_signal(int signo __maybe_unused,
 
 static bool check_ftrace_capable(void)
 {
-	bool used_root;
-
-	if (perf_cap__capable(CAP_PERFMON, &used_root))
-		return true;
-
-	if (!used_root && perf_cap__capable(CAP_SYS_ADMIN, &used_root))
+	if (perf_cap__capable(CAP_PERFMON) ||
+	    perf_cap__capable(CAP_SYS_ADMIN))
 		return true;
 
-	pr_err("ftrace only works for %s!\n",
-		used_root ? "root"
-			  : "users with the CAP_PERFMON or CAP_SYS_ADMIN capability"
-		);
+	pr_err("ftrace only works for users with the CAP_PERFMON or CAP_SYS_ADMIN capability!\n");
 	return false;
 }
 
diff --git a/tools/perf/util/bpf-filter.c b/tools/perf/util/bpf-filter.c
index 1a2e7b388d57d..bcd81084e3420 100644
--- a/tools/perf/util/bpf-filter.c
+++ b/tools/perf/util/bpf-filter.c
@@ -629,24 +629,20 @@ struct perf_bpf_filter_expr *perf_bpf_filter_expr__new(enum perf_bpf_filter_term
 
 static bool check_bpf_filter_capable(void)
 {
-	bool used_root;
+	int fd;
 
-	if (perf_cap__capable(CAP_BPF, &used_root))
+	if (perf_cap__capable(CAP_BPF))
 		return true;
 
-	if (!used_root) {
-		/* Check if root already pinned the filter programs and maps */
-		int fd = get_pinned_fd("filters");
-
-		if (fd >= 0) {
-			close(fd);
-			return true;
-		}
+	/* Check if root already pinned the filter programs and maps */
+	fd = get_pinned_fd("filters");
+	if (fd >= 0) {
+		close(fd);
+		return true;
 	}
 
-	pr_err("Error: BPF filter only works for %s!\n"
-	       "\tPlease run 'perf record --setup-filter pin' as root first.\n",
-	       used_root ? "root" : "users with the CAP_BPF capability");
+	pr_err("Error: BPF filter only works for users with the CAP_BPF capability!\n"
+	       "\tPlease run 'perf record --setup-filter pin' as root first.\n");
 
 	return false;
 }
diff --git a/tools/perf/util/cap.c b/tools/perf/util/cap.c
index ac6d1d9a523d9..272bd8255ff12 100644
--- a/tools/perf/util/cap.c
+++ b/tools/perf/util/cap.c
@@ -12,7 +12,7 @@
 
 #define MAX_LINUX_CAPABILITY_U32S _LINUX_CAPABILITY_U32S_3
 
-bool perf_cap__capable(int cap, bool *used_root)
+bool perf_cap__capable(int cap)
 {
 	struct __user_cap_header_struct header = {
 		.version = _LINUX_CAPABILITY_VERSION_3,
@@ -21,7 +21,6 @@ bool perf_cap__capable(int cap, bool *used_root)
 	struct __user_cap_data_struct data[MAX_LINUX_CAPABILITY_U32S] = {};
 	__u32 cap_val;
 
-	*used_root = false;
 	while (syscall(SYS_capget, &header, &data[0]) == -1) {
 		/* Retry, first attempt has set the header.version correctly. */
 		if (errno == EINVAL && header.version != _LINUX_CAPABILITY_VERSION_3 &&
@@ -29,7 +28,6 @@ bool perf_cap__capable(int cap, bool *used_root)
 			continue;
 
 		pr_debug2("capget syscall failed (%m) fall back on root check\n");
-		*used_root = true;
 		return geteuid() == 0;
 	}
 
diff --git a/tools/perf/util/cap.h b/tools/perf/util/cap.h
index c1b8ac033ccc5..bf09fb20c7793 100644
--- a/tools/perf/util/cap.h
+++ b/tools/perf/util/cap.h
@@ -18,7 +18,6 @@
 #define CAP_BPF		39
 #endif
 
-/* Query if a capability is supported, used_root is set if the fallback root check was used. */
-bool perf_cap__capable(int cap, bool *used_root);
+bool perf_cap__capable(int cap);
 
 #endif /* __PERF_CAP_H */
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index cd379ced19e5b..35104a56d8e38 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2452,8 +2452,7 @@ static bool symbol__read_kptr_restrict(void)
 {
 	bool value = false;
 	FILE *fp = fopen("/proc/sys/kernel/kptr_restrict", "r");
-	bool used_root;
-	bool cap_syslog = perf_cap__capable(CAP_SYSLOG, &used_root);
+	bool cap_syslog = perf_cap__capable(CAP_SYSLOG);
 
 	if (fp != NULL) {
 		char line[8];
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 2c2a5c449ffd0..8f7cd32f524dc 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -378,15 +378,9 @@ int perf_event_paranoid(void)
 
 bool perf_event_paranoid_check(int max_level)
 {
-	bool used_root;
-
-	if (perf_cap__capable(CAP_SYS_ADMIN, &used_root))
-		return true;
-
-	if (!used_root && perf_cap__capable(CAP_PERFMON, &used_root))
-		return true;
-
-	return perf_event_paranoid() <= max_level;
+	return perf_cap__capable(CAP_SYS_ADMIN) ||
+	       perf_cap__capable(CAP_PERFMON) ||
+	       perf_event_paranoid() <= max_level;
 }
 
 int perf_tip(char **strp, const char *dirpath)
-- 
2.53.0



