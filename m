Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBCA2BAF1;
	Thu,  6 Jun 2024 14:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682963; cv=none; b=GQ1mxnA6jfSnauMO7MsdSwigYNJd6is3pGz59Bf3U3Lg+CGXsLqOsieE+2Y4rQ4VantVsYdWQP3L4ne9QhG2yTKmJc7MXCRE8CC5EfxnwU3qjKHU50DqEpPZOAddicXW2EGZWAhfkBvX1sSgF97gOB1sgeB+6IAyLIKH5HCkRF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682963; c=relaxed/simple;
	bh=lpLgc4UQf0zxQHjyV5L/7OEGWZvCHEbASY6BEvTLAS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmbNzbxBKFjHvME7hcmGGVMKLH/V5DghAOWpcuR9/HMhgsXSkh78aYufJmUjYwtZu8Qi1y4kU8nQZyLaoXigL93AciNV6o57YlEseRpdzt9YoxACB47i7fGNl1KSKhFdBoVZumwnHNCy4laU7LpG1u84rUaaS2CAOSi2PIcGh1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deg7JdAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deg7JdAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB89C32781;
	Thu,  6 Jun 2024 14:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682962;
	bh=lpLgc4UQf0zxQHjyV5L/7OEGWZvCHEbASY6BEvTLAS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=deg7JdAviJkIpRo66KJZE1kbbLHm4iqjVfd3zeIfBEL5YvZ+LqXxHfp4Bj+I1c2S9
	 TIkTR9WaRYhbp5pYzeyypU6WjnYjq6vf9BqrsVf5jrUVeUW353xHWlmOFweExdl7gF
	 Uh2M7EwjTiGxS6IQxzPaWihnSTtP6T+y66AJPoQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Remus <jremus@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 131/374] s390/stacktrace: Merge perf_callchain_user() and arch_stack_walk_user()
Date: Thu,  6 Jun 2024 16:01:50 +0200
Message-ID: <20240606131656.291318572@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit ebd912ff9919a10609511383d94942362234c077 ]

The two functions perf_callchain_user() and arch_stack_walk_user() are
nearly identical. Reduce code duplication and add a common helper which can
be called by both functions.

Fixes: aa44433ac4ee ("s390: add USER_STACKTRACE support")
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/stacktrace.h |  7 ++++++
 arch/s390/kernel/perf_event.c      | 34 +-----------------------------
 arch/s390/kernel/stacktrace.c      | 33 ++++++++++++++++++++++++-----
 3 files changed, 36 insertions(+), 38 deletions(-)

diff --git a/arch/s390/include/asm/stacktrace.h b/arch/s390/include/asm/stacktrace.h
index 433fde85b14ea..4aefbe32265d8 100644
--- a/arch/s390/include/asm/stacktrace.h
+++ b/arch/s390/include/asm/stacktrace.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_S390_STACKTRACE_H
 #define _ASM_S390_STACKTRACE_H
 
+#include <linux/stacktrace.h>
 #include <linux/uaccess.h>
 #include <linux/ptrace.h>
 
@@ -12,6 +13,12 @@ struct stack_frame_user {
 	unsigned long empty2[4];
 };
 
+struct perf_callchain_entry_ctx;
+
+void arch_stack_walk_user_common(stack_trace_consume_fn consume_entry, void *cookie,
+				 struct perf_callchain_entry_ctx *entry,
+				 const struct pt_regs *regs, bool perf);
+
 enum stack_type {
 	STACK_TYPE_UNKNOWN,
 	STACK_TYPE_TASK,
diff --git a/arch/s390/kernel/perf_event.c b/arch/s390/kernel/perf_event.c
index dfa77da2fd2ec..5fff629b1a898 100644
--- a/arch/s390/kernel/perf_event.c
+++ b/arch/s390/kernel/perf_event.c
@@ -218,39 +218,7 @@ void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 			 struct pt_regs *regs)
 {
-	struct stack_frame_user __user *sf;
-	unsigned long ip, sp;
-	bool first = true;
-
-	if (is_compat_task())
-		return;
-	perf_callchain_store(entry, instruction_pointer(regs));
-	sf = (void __user *)user_stack_pointer(regs);
-	pagefault_disable();
-	while (entry->nr < entry->max_stack) {
-		if (__get_user(sp, &sf->back_chain))
-			break;
-		if (__get_user(ip, &sf->gprs[8]))
-			break;
-		if (ip & 0x1) {
-			/*
-			 * If the instruction address is invalid, and this
-			 * is the first stack frame, assume r14 has not
-			 * been written to the stack yet. Otherwise exit.
-			 */
-			if (first && !(regs->gprs[14] & 0x1))
-				ip = regs->gprs[14];
-			else
-				break;
-		}
-		perf_callchain_store(entry, ip);
-		/* Sanity check: ABI requires SP to be aligned 8 bytes. */
-		if (!sp || sp & 0x7)
-			break;
-		sf = (void __user *)sp;
-		first = false;
-	}
-	pagefault_enable();
+	arch_stack_walk_user_common(NULL, NULL, entry, regs, true);
 }
 
 /* Perf definitions for PMU event attributes in sysfs */
diff --git a/arch/s390/kernel/stacktrace.c b/arch/s390/kernel/stacktrace.c
index 7c294da45bf52..e580d4cd2729a 100644
--- a/arch/s390/kernel/stacktrace.c
+++ b/arch/s390/kernel/stacktrace.c
@@ -5,6 +5,7 @@
  *  Copyright IBM Corp. 2006
  */
 
+#include <linux/perf_event.h>
 #include <linux/stacktrace.h>
 #include <linux/uaccess.h>
 #include <linux/compat.h>
@@ -62,8 +63,23 @@ int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
 	return 0;
 }
 
-void arch_stack_walk_user(stack_trace_consume_fn consume_entry, void *cookie,
-			  const struct pt_regs *regs)
+static inline bool store_ip(stack_trace_consume_fn consume_entry, void *cookie,
+			    struct perf_callchain_entry_ctx *entry, bool perf,
+			    unsigned long ip)
+{
+#ifdef CONFIG_PERF_EVENTS
+	if (perf) {
+		if (perf_callchain_store(entry, ip))
+			return false;
+		return true;
+	}
+#endif
+	return consume_entry(cookie, ip);
+}
+
+void arch_stack_walk_user_common(stack_trace_consume_fn consume_entry, void *cookie,
+				 struct perf_callchain_entry_ctx *entry,
+				 const struct pt_regs *regs, bool perf)
 {
 	struct stack_frame_user __user *sf;
 	unsigned long ip, sp;
@@ -71,7 +87,8 @@ void arch_stack_walk_user(stack_trace_consume_fn consume_entry, void *cookie,
 
 	if (is_compat_task())
 		return;
-	if (!consume_entry(cookie, instruction_pointer(regs)))
+	ip = instruction_pointer(regs);
+	if (!store_ip(consume_entry, cookie, entry, perf, ip))
 		return;
 	sf = (void __user *)user_stack_pointer(regs);
 	pagefault_disable();
@@ -91,8 +108,8 @@ void arch_stack_walk_user(stack_trace_consume_fn consume_entry, void *cookie,
 			else
 				break;
 		}
-		if (!consume_entry(cookie, ip))
-			break;
+		if (!store_ip(consume_entry, cookie, entry, perf, ip))
+			return;
 		/* Sanity check: ABI requires SP to be aligned 8 bytes. */
 		if (!sp || sp & 0x7)
 			break;
@@ -102,6 +119,12 @@ void arch_stack_walk_user(stack_trace_consume_fn consume_entry, void *cookie,
 	pagefault_enable();
 }
 
+void arch_stack_walk_user(stack_trace_consume_fn consume_entry, void *cookie,
+			  const struct pt_regs *regs)
+{
+	arch_stack_walk_user_common(consume_entry, cookie, NULL, regs, false);
+}
+
 unsigned long return_address(unsigned int n)
 {
 	struct unwind_state state;
-- 
2.43.0



