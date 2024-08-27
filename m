Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E711C1C3F0D;
	Tue, 27 Aug 2024 15:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771949; cv=none; b=uDfESfYmJWLABOWD70psYH2PrLaLfggkUqZhtYpQ5P1lNHiVVtJt5P532iK7AfjwjwMHnJJI7/upp8PScPIsJjjCcTofM+9CymH58NZe3PMJ5xC3kTyFpDWdp92q3VWmFx058Mr2NSYOGaLN6k22SFtA/V//Is3Ygm/xj/Lc2hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771949; c=relaxed/simple;
	bh=dXL7xDwOhR6Isg7y6SylJ2omXcVu3XhUZ5OtFQ7ovNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7JHvPDJrNyGS2vnebUPv4LUc1d8svJS8XkSmFIPH3ilAnEUZCUWPQbrdTYWJIqR16P3kRIkK/3XQS4xt85dUQI7xNF1rR8YiRSkNNcUBtHluup9c0CBiTnJUfYODsQMN8haCSLY9Md8RZTqL0xZ5xY7CCq/lU7PxCTWrtMUQ/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMGwQqfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMGwQqfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1327FC61067;
	Tue, 27 Aug 2024 15:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771948;
	bh=dXL7xDwOhR6Isg7y6SylJ2omXcVu3XhUZ5OtFQ7ovNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMGwQqfs6BGB4915s854DWp4ZZLCQd3uXyosHBUvfOOpwMD2DoBj4HMhyG22F4Kqd
	 7BV4Bl+MDVZyLzxe0EpzJnkkYvANOTAS+guFApt4UMdz04w4CJtAPvBftMwp3kNhe7
	 WwabiK3C4rnjGOXeSXr24mmjDu18Ky8B2+mpuFww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Lorenz Bauer <lmb@isovalent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/321] bpf: Split off basic BPF verifier log into separate file
Date: Tue, 27 Aug 2024 16:35:46 +0200
Message-ID: <20240827143839.674243802@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 4294a0a7ab6282c3d92f03de84e762dda993c93d ]

kernel/bpf/verifier.c file is large and growing larger all the time. So
it's good to start splitting off more or less self-contained parts into
separate files to keep source code size (somewhat) somewhat under
control.

This patch is a one step in this direction, moving some of BPF verifier log
routines into a separate kernel/bpf/log.c. Right now it's most low-level
and isolated routines to append data to log, reset log to previous
position, etc. Eventually we could probably move verifier state
printing logic here as well, but this patch doesn't attempt to do that
yet.

Subsequent patches will add more logic to verifier log management, so
having basics in a separate file will make sure verifier.c doesn't grow
more with new changes.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Lorenz Bauer <lmb@isovalent.com>
Link: https://lore.kernel.org/bpf/20230406234205.323208-2-andrii@kernel.org
Stable-dep-of: cff36398bd4c ("bpf: drop unnecessary user-triggerable WARN_ONCE in verifierl log")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h | 19 +++-----
 kernel/bpf/Makefile          |  3 +-
 kernel/bpf/log.c             | 85 ++++++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c        | 69 -----------------------------
 4 files changed, 94 insertions(+), 82 deletions(-)
 create mode 100644 kernel/bpf/log.c

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 131adc98080b8..33b073deb8c17 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -445,11 +445,6 @@ struct bpf_verifier_log {
 	u32 len_total;
 };
 
-static inline bool bpf_verifier_log_full(const struct bpf_verifier_log *log)
-{
-	return log->len_used >= log->len_total - 1;
-}
-
 #define BPF_LOG_LEVEL1	1
 #define BPF_LOG_LEVEL2	2
 #define BPF_LOG_STATS	4
@@ -459,6 +454,11 @@ static inline bool bpf_verifier_log_full(const struct bpf_verifier_log *log)
 #define BPF_LOG_MIN_ALIGNMENT 8U
 #define BPF_LOG_ALIGNMENT 40U
 
+static inline bool bpf_verifier_log_full(const struct bpf_verifier_log *log)
+{
+	return log->len_used >= log->len_total - 1;
+}
+
 static inline bool bpf_verifier_log_needed(const struct bpf_verifier_log *log)
 {
 	return log &&
@@ -466,13 +466,6 @@ static inline bool bpf_verifier_log_needed(const struct bpf_verifier_log *log)
 		 log->level == BPF_LOG_KERNEL);
 }
 
-static inline bool
-bpf_verifier_log_attr_valid(const struct bpf_verifier_log *log)
-{
-	return log->len_total >= 128 && log->len_total <= UINT_MAX >> 2 &&
-	       log->level && log->ubuf && !(log->level & ~BPF_LOG_MASK);
-}
-
 #define BPF_MAX_SUBPROGS 256
 
 struct bpf_subprog_info {
@@ -556,12 +549,14 @@ struct bpf_verifier_env {
 	char type_str_buf[TYPE_STR_BUF_LEN];
 };
 
+bool bpf_verifier_log_attr_valid(const struct bpf_verifier_log *log);
 __printf(2, 0) void bpf_verifier_vlog(struct bpf_verifier_log *log,
 				      const char *fmt, va_list args);
 __printf(2, 3) void bpf_verifier_log_write(struct bpf_verifier_env *env,
 					   const char *fmt, ...);
 __printf(2, 3) void bpf_log(struct bpf_verifier_log *log,
 			    const char *fmt, ...);
+void bpf_vlog_reset(struct bpf_verifier_log *log, u32 new_pos);
 
 static inline struct bpf_func_state *cur_func(struct bpf_verifier_env *env)
 {
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 341c94f208f4c..5b86ea9f09c46 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -6,7 +6,8 @@ cflags-nogcse-$(CONFIG_X86)$(CONFIG_CC_IS_GCC) := -fno-gcse
 endif
 CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
 
-obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o link_iter.o
+obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o log.o
+obj-$(CONFIG_BPF_SYSCALL) += bpf_iter.o map_iter.o task_iter.o prog_iter.o link_iter.o
 obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o bloom_filter.o
 obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o
diff --git a/kernel/bpf/log.c b/kernel/bpf/log.c
new file mode 100644
index 0000000000000..920061e38d2e1
--- /dev/null
+++ b/kernel/bpf/log.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2011-2014 PLUMgrid, http://plumgrid.com
+ * Copyright (c) 2016 Facebook
+ * Copyright (c) 2018 Covalent IO, Inc. http://covalent.io
+ */
+#include <uapi/linux/btf.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/bpf.h>
+#include <linux/bpf_verifier.h>
+
+bool bpf_verifier_log_attr_valid(const struct bpf_verifier_log *log)
+{
+	return log->len_total >= 128 && log->len_total <= UINT_MAX >> 2 &&
+	       log->level && log->ubuf && !(log->level & ~BPF_LOG_MASK);
+}
+
+void bpf_verifier_vlog(struct bpf_verifier_log *log, const char *fmt,
+		       va_list args)
+{
+	unsigned int n;
+
+	n = vscnprintf(log->kbuf, BPF_VERIFIER_TMP_LOG_SIZE, fmt, args);
+
+	WARN_ONCE(n >= BPF_VERIFIER_TMP_LOG_SIZE - 1,
+		  "verifier log line truncated - local buffer too short\n");
+
+	if (log->level == BPF_LOG_KERNEL) {
+		bool newline = n > 0 && log->kbuf[n - 1] == '\n';
+
+		pr_err("BPF: %s%s", log->kbuf, newline ? "" : "\n");
+		return;
+	}
+
+	n = min(log->len_total - log->len_used - 1, n);
+	log->kbuf[n] = '\0';
+	if (!copy_to_user(log->ubuf + log->len_used, log->kbuf, n + 1))
+		log->len_used += n;
+	else
+		log->ubuf = NULL;
+}
+
+void bpf_vlog_reset(struct bpf_verifier_log *log, u32 new_pos)
+{
+	char zero = 0;
+
+	if (!bpf_verifier_log_needed(log))
+		return;
+
+	log->len_used = new_pos;
+	if (put_user(zero, log->ubuf + new_pos))
+		log->ubuf = NULL;
+}
+
+/* log_level controls verbosity level of eBPF verifier.
+ * bpf_verifier_log_write() is used to dump the verification trace to the log,
+ * so the user can figure out what's wrong with the program
+ */
+__printf(2, 3) void bpf_verifier_log_write(struct bpf_verifier_env *env,
+					   const char *fmt, ...)
+{
+	va_list args;
+
+	if (!bpf_verifier_log_needed(&env->log))
+		return;
+
+	va_start(args, fmt);
+	bpf_verifier_vlog(&env->log, fmt, args);
+	va_end(args);
+}
+EXPORT_SYMBOL_GPL(bpf_verifier_log_write);
+
+__printf(2, 3) void bpf_log(struct bpf_verifier_log *log,
+			    const char *fmt, ...)
+{
+	va_list args;
+
+	if (!bpf_verifier_log_needed(log))
+		return;
+
+	va_start(args, fmt);
+	bpf_verifier_vlog(log, fmt, args);
+	va_end(args);
+}
+EXPORT_SYMBOL_GPL(bpf_log);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8973d3c9597ce..4efa50eb07d72 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -291,61 +291,6 @@ find_linfo(const struct bpf_verifier_env *env, u32 insn_off)
 	return &linfo[i - 1];
 }
 
-void bpf_verifier_vlog(struct bpf_verifier_log *log, const char *fmt,
-		       va_list args)
-{
-	unsigned int n;
-
-	n = vscnprintf(log->kbuf, BPF_VERIFIER_TMP_LOG_SIZE, fmt, args);
-
-	WARN_ONCE(n >= BPF_VERIFIER_TMP_LOG_SIZE - 1,
-		  "verifier log line truncated - local buffer too short\n");
-
-	if (log->level == BPF_LOG_KERNEL) {
-		bool newline = n > 0 && log->kbuf[n - 1] == '\n';
-
-		pr_err("BPF: %s%s", log->kbuf, newline ? "" : "\n");
-		return;
-	}
-
-	n = min(log->len_total - log->len_used - 1, n);
-	log->kbuf[n] = '\0';
-	if (!copy_to_user(log->ubuf + log->len_used, log->kbuf, n + 1))
-		log->len_used += n;
-	else
-		log->ubuf = NULL;
-}
-
-static void bpf_vlog_reset(struct bpf_verifier_log *log, u32 new_pos)
-{
-	char zero = 0;
-
-	if (!bpf_verifier_log_needed(log))
-		return;
-
-	log->len_used = new_pos;
-	if (put_user(zero, log->ubuf + new_pos))
-		log->ubuf = NULL;
-}
-
-/* log_level controls verbosity level of eBPF verifier.
- * bpf_verifier_log_write() is used to dump the verification trace to the log,
- * so the user can figure out what's wrong with the program
- */
-__printf(2, 3) void bpf_verifier_log_write(struct bpf_verifier_env *env,
-					   const char *fmt, ...)
-{
-	va_list args;
-
-	if (!bpf_verifier_log_needed(&env->log))
-		return;
-
-	va_start(args, fmt);
-	bpf_verifier_vlog(&env->log, fmt, args);
-	va_end(args);
-}
-EXPORT_SYMBOL_GPL(bpf_verifier_log_write);
-
 __printf(2, 3) static void verbose(void *private_data, const char *fmt, ...)
 {
 	struct bpf_verifier_env *env = private_data;
@@ -359,20 +304,6 @@ __printf(2, 3) static void verbose(void *private_data, const char *fmt, ...)
 	va_end(args);
 }
 
-__printf(2, 3) void bpf_log(struct bpf_verifier_log *log,
-			    const char *fmt, ...)
-{
-	va_list args;
-
-	if (!bpf_verifier_log_needed(log))
-		return;
-
-	va_start(args, fmt);
-	bpf_verifier_vlog(log, fmt, args);
-	va_end(args);
-}
-EXPORT_SYMBOL_GPL(bpf_log);
-
 static const char *ltrim(const char *s)
 {
 	while (isspace(*s))
-- 
2.43.0



