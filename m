Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9269B2054F8;
	Thu, 12 Dec 2024 15:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017108; cv=none; b=WA1WiZFXR3TiUj65wiSr2Jj1f6uqZJjcCdDwisGgrnCUg4w6Am5wMp+nlZuFgqu4/MU/eAzh7r1nYilx2nTsA3y+pLR2B4lGRnKhrA87ky6ElwAlSlidGolbTsctIJLGgtWVCewX+0P03lTUjHCXUQLAzVgwhlcnOxonW8qbjtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017108; c=relaxed/simple;
	bh=r6PK7uxeFoeVSDQ1VG+mRn8wLK0L54GgkjkpoKC6Y9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyHNVBp3mANhf4VGNLY1EQSb9u/DTuDr3JgSPv37SqbJdoayegBHOAEOVi+kUlkAt9eJh0dAz6+vF39PkNUVdxPjsV+5IyjoJzl+prbhDhN1K0QYSC/dxFGoIkEUDfDSglrPtXJyc3T/Qjsf2nHBkvAbjYxT1AoF1bMmkuemjE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sq+862Lc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sq+862Lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986D1C4CECE;
	Thu, 12 Dec 2024 15:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017107;
	bh=r6PK7uxeFoeVSDQ1VG+mRn8wLK0L54GgkjkpoKC6Y9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sq+862Lc9/5HnFwreB10zhMKSVl2sMX5RIFg5JsqTk7ckgK/tE5et3Ex99ySWD2tu
	 1lI+JUg1NHn0/3lYYZWxyzjNmgTa/VNS1E03FtbD6fCn8WvWOqrVUZAMilmIWQiYxp
	 TifggFyyfM3Fmi+y7rmm8t4SNBBe9VtjpV+aHtwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tatsuya S <tatsuya.s2862@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 384/466] tracing: Fix function name for trampoline
Date: Thu, 12 Dec 2024 15:59:13 +0100
Message-ID: <20241212144321.942096154@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tatsuya S <tatsuya.s2862@gmail.com>

[ Upstream commit 6ce5a6f0a07d37cc377df08a8d8a9c283420f323 ]

The issue that unrelated function name is shown on stack trace like
following even though it should be trampoline code address is caused by
the creation of trampoline code in the area where .init.text section
of module was freed after module is loaded.

bash-1344    [002] .....    43.644608: <stack trace>
=> (MODULE INIT FUNCTION)
=> vfs_write
=> ksys_write
=> do_syscall_64
=> entry_SYSCALL_64_after_hwframe

To resolve this, when function address of stack trace entry is in
trampoline, output without looking up symbol name.

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20241021071454.34610-2-tatsuya.s2862@gmail.com
Signed-off-by: Tatsuya S <tatsuya.s2862@gmail.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c        | 33 +++++++++++++++++++++++++--------
 kernel/trace/trace.h        |  7 +++++++
 kernel/trace/trace_output.c |  4 ++++
 3 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 6a891e00aa7f4..17d2ffde0bb60 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -988,7 +988,8 @@ static inline void trace_access_lock_init(void)
 #endif
 
 #ifdef CONFIG_STACKTRACE
-static void __ftrace_trace_stack(struct trace_buffer *buffer,
+static void __ftrace_trace_stack(struct trace_array *tr,
+				 struct trace_buffer *buffer,
 				 unsigned int trace_ctx,
 				 int skip, struct pt_regs *regs);
 static inline void ftrace_trace_stack(struct trace_array *tr,
@@ -997,7 +998,8 @@ static inline void ftrace_trace_stack(struct trace_array *tr,
 				      int skip, struct pt_regs *regs);
 
 #else
-static inline void __ftrace_trace_stack(struct trace_buffer *buffer,
+static inline void __ftrace_trace_stack(struct trace_array *tr,
+					struct trace_buffer *buffer,
 					unsigned int trace_ctx,
 					int skip, struct pt_regs *regs)
 {
@@ -2947,7 +2949,8 @@ struct ftrace_stacks {
 static DEFINE_PER_CPU(struct ftrace_stacks, ftrace_stacks);
 static DEFINE_PER_CPU(int, ftrace_stack_reserve);
 
-static void __ftrace_trace_stack(struct trace_buffer *buffer,
+static void __ftrace_trace_stack(struct trace_array *tr,
+				 struct trace_buffer *buffer,
 				 unsigned int trace_ctx,
 				 int skip, struct pt_regs *regs)
 {
@@ -2994,6 +2997,20 @@ static void __ftrace_trace_stack(struct trace_buffer *buffer,
 		nr_entries = stack_trace_save(fstack->calls, size, skip);
 	}
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+	/* Mark entry of stack trace as trampoline code */
+	if (tr->ops && tr->ops->trampoline) {
+		unsigned long tramp_start = tr->ops->trampoline;
+		unsigned long tramp_end = tramp_start + tr->ops->trampoline_size;
+		unsigned long *calls = fstack->calls;
+
+		for (int i = 0; i < nr_entries; i++) {
+			if (calls[i] >= tramp_start && calls[i] < tramp_end)
+				calls[i] = FTRACE_TRAMPOLINE_MARKER;
+		}
+	}
+#endif
+
 	event = __trace_buffer_lock_reserve(buffer, TRACE_STACK,
 				    struct_size(entry, caller, nr_entries),
 				    trace_ctx);
@@ -3024,7 +3041,7 @@ static inline void ftrace_trace_stack(struct trace_array *tr,
 	if (!(tr->trace_flags & TRACE_ITER_STACKTRACE))
 		return;
 
-	__ftrace_trace_stack(buffer, trace_ctx, skip, regs);
+	__ftrace_trace_stack(tr, buffer, trace_ctx, skip, regs);
 }
 
 void __trace_stack(struct trace_array *tr, unsigned int trace_ctx,
@@ -3033,7 +3050,7 @@ void __trace_stack(struct trace_array *tr, unsigned int trace_ctx,
 	struct trace_buffer *buffer = tr->array_buffer.buffer;
 
 	if (rcu_is_watching()) {
-		__ftrace_trace_stack(buffer, trace_ctx, skip, NULL);
+		__ftrace_trace_stack(tr, buffer, trace_ctx, skip, NULL);
 		return;
 	}
 
@@ -3050,7 +3067,7 @@ void __trace_stack(struct trace_array *tr, unsigned int trace_ctx,
 		return;
 
 	ct_irq_enter_irqson();
-	__ftrace_trace_stack(buffer, trace_ctx, skip, NULL);
+	__ftrace_trace_stack(tr, buffer, trace_ctx, skip, NULL);
 	ct_irq_exit_irqson();
 }
 
@@ -3067,8 +3084,8 @@ void trace_dump_stack(int skip)
 	/* Skip 1 to skip this function. */
 	skip++;
 #endif
-	__ftrace_trace_stack(printk_trace->array_buffer.buffer,
-			     tracing_gen_ctx(), skip, NULL);
+	__ftrace_trace_stack(printk_trace, printk_trace->array_buffer.buffer,
+				tracing_gen_ctx(), skip, NULL);
 }
 EXPORT_SYMBOL_GPL(trace_dump_stack);
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c866991b9c78b..30d6675c78cfe 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -2176,4 +2176,11 @@ static inline int rv_init_interface(void)
 }
 #endif
 
+/*
+ * This is used only to distinguish
+ * function address from trampoline code.
+ * So this value has no meaning.
+ */
+#define FTRACE_TRAMPOLINE_MARKER  ((unsigned long) INT_MAX)
+
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 868f2f912f280..c14573e5a9033 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1246,6 +1246,10 @@ static enum print_line_t trace_stack_print(struct trace_iterator *iter,
 			break;
 
 		trace_seq_puts(s, " => ");
+		if ((*p) == FTRACE_TRAMPOLINE_MARKER) {
+			trace_seq_puts(s, "[FTRACE TRAMPOLINE]\n");
+			continue;
+		}
 		seq_print_ip_sym(s, (*p) + delta, flags);
 		trace_seq_putc(s, '\n');
 	}
-- 
2.43.0



