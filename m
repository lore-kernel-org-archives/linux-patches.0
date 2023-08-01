Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885381F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098A3C433C8;
	Tue,  1 Aug 2023 09:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881807;
	bh=2SJQnLtg9IBgEELKFZxGGLYlZ4XuM5VNPa1/SkNC2ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2Q/IbTY1KguMYusxMrqB76vIs1SlTZ4mjWD/IUvVe+a7XhkgDy93DaRqYA+6HuLq
	 UIQhTrHvbEj/HyPKzoldd8BgKnVRIi1AjuNucr+ML7UQApGzp6QgoVp417hxs+DToe
	 qmr1IFo24oH3Lyyc4PyEUIiUx54s8TaJfgG+U6KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Tom Zanussi <zanussi@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/155] Revert "tracing: Add "(fault)" name injection to kernel probes"
Date: Tue,  1 Aug 2023 11:19:08 +0200
Message-ID: <20230801091911.469165142@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 4ed8f337dee32df71435689c19d22e4ee846e15a ]

This reverts commit 2e9906f84fc7c99388bb7123ade167250d50f1c0.

It was turned out that commit 2e9906f84fc7 ("tracing: Add "(fault)"
name injection to kernel probes") did not work correctly and probe
events still show just '(fault)' (instead of '"(fault)"'). Also,
current '(fault)' is more explicit that it faulted.

This also moves FAULT_STRING macro to trace.h so that synthetic
event can keep using it, and uses it in trace_probe.c too.

Link: https://lore.kernel.org/all/168908495772.123124.1250788051922100079.stgit@devnote2/
Link: https://lore.kernel.org/all/20230706230642.3793a593@rorschach.local.home/

Cc: stable@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 797311bce5c2 ("tracing/probes: Fix to record 0-length data_loc in fetch_store_string*() if fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.h              |  2 ++
 kernel/trace/trace_probe.c        |  2 +-
 kernel/trace/trace_probe_kernel.h | 31 ++++++-------------------------
 3 files changed, 9 insertions(+), 26 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 33c55c8826a7e..43058077a4def 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -113,6 +113,8 @@ enum trace_type {
 #define MEM_FAIL(condition, fmt, ...)					\
 	DO_ONCE_LITE_IF(condition, pr_err, "ERROR: " fmt, ##__VA_ARGS__)
 
+#define FAULT_STRING "(fault)"
+
 #define HIST_STACKTRACE_DEPTH	16
 #define HIST_STACKTRACE_SIZE	(HIST_STACKTRACE_DEPTH * sizeof(unsigned long))
 #define HIST_STACKTRACE_SKIP	5
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 90bae188d0928..0888f0644d257 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -64,7 +64,7 @@ int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s, void *data, void *ent)
 	int len = *(u32 *)data >> 16;
 
 	if (!len)
-		trace_seq_puts(s, "(fault)");
+		trace_seq_puts(s, FAULT_STRING);
 	else
 		trace_seq_printf(s, "\"%s\"",
 				 (const char *)get_loc_data(data, ent));
diff --git a/kernel/trace/trace_probe_kernel.h b/kernel/trace/trace_probe_kernel.h
index 77dbd9ff97826..1d43df29a1f8e 100644
--- a/kernel/trace/trace_probe_kernel.h
+++ b/kernel/trace/trace_probe_kernel.h
@@ -2,8 +2,6 @@
 #ifndef __TRACE_PROBE_KERNEL_H_
 #define __TRACE_PROBE_KERNEL_H_
 
-#define FAULT_STRING "(fault)"
-
 /*
  * This depends on trace_probe.h, but can not include it due to
  * the way trace_probe_tmpl.h is used by trace_kprobe.c and trace_eprobe.c.
@@ -15,16 +13,8 @@ static nokprobe_inline int
 kern_fetch_store_strlen_user(unsigned long addr)
 {
 	const void __user *uaddr =  (__force const void __user *)addr;
-	int ret;
 
-	ret = strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
-	/*
-	 * strnlen_user_nofault returns zero on fault, insert the
-	 * FAULT_STRING when that occurs.
-	 */
-	if (ret <= 0)
-		return strlen(FAULT_STRING) + 1;
-	return ret;
+	return strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
 }
 
 /* Return the length of string -- including null terminal byte */
@@ -44,18 +34,7 @@ kern_fetch_store_strlen(unsigned long addr)
 		len++;
 	} while (c && ret == 0 && len < MAX_STRING_SIZE);
 
-	/* For faults, return enough to hold the FAULT_STRING */
-	return (ret < 0) ? strlen(FAULT_STRING) + 1 : len;
-}
-
-static nokprobe_inline void set_data_loc(int ret, void *dest, void *__dest, void *base, int len)
-{
-	if (ret >= 0) {
-		*(u32 *)dest = make_data_loc(ret, __dest - base);
-	} else {
-		strscpy(__dest, FAULT_STRING, len);
-		ret = strlen(__dest) + 1;
-	}
+	return (ret < 0) ? ret : len;
 }
 
 /*
@@ -76,7 +55,8 @@ kern_fetch_store_string_user(unsigned long addr, void *dest, void *base)
 	__dest = get_loc_data(dest, base);
 
 	ret = strncpy_from_user_nofault(__dest, uaddr, maxlen);
-	set_data_loc(ret, dest, __dest, base, maxlen);
+	if (ret >= 0)
+		*(u32 *)dest = make_data_loc(ret, __dest - base);
 
 	return ret;
 }
@@ -107,7 +87,8 @@ kern_fetch_store_string(unsigned long addr, void *dest, void *base)
 	 * probing.
 	 */
 	ret = strncpy_from_kernel_nofault(__dest, (void *)addr, maxlen);
-	set_data_loc(ret, dest, __dest, base, maxlen);
+	if (ret >= 0)
+		*(u32 *)dest = make_data_loc(ret, __dest - base);
 
 	return ret;
 }
-- 
2.39.2



