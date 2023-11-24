Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D892D28DBB;
	Fri, 24 Nov 2023 19:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJP+EM8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64349C433C8;
	Fri, 24 Nov 2023 19:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853174;
	bh=bI0km5Q1zOK/UAt95hT6DEbSPaHQ6GTcNlUFGCNHY6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJP+EM8IH2zH7SW+ShdGLereRUaUsDLnn6aXurohX7mCT5NXrcrhy3GInG/zfkW5O
	 9YNv3mg3ZhFj7ZjfkT9Sxgx88o8Zx1FtU3we0qx8hAhY+Dki75AO7uyB9PdcqXrFzh
	 CuEmsFRE/L1XgI5TdbGd6FmX+I8QrSpuQrNO5Syk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/297] tracing/perf: Add interrupt_context_level() helper
Date: Fri, 24 Nov 2023 17:52:06 +0000
Message-ID: <20231124172003.190133820@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit 91ebe8bcbff9d2ff21303e73bf7434f39a98b255 ]

Now that there are three different instances of doing the addition trick
to the preempt_count() and NMI_MASK, HARDIRQ_MASK and SOFTIRQ_OFFSET
macros, it deserves a helper function defined in the preempt.h header.

Add the interrupt_context_level() helper and replace the three instances
that do that logic with it.

Link: https://lore.kernel.org/all/20211015142541.4badd8a9@gandalf.local.home/

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Stable-dep-of: 87c3a5893e86 ("sched/core: Optimize in_task() and in_interrupt() a bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/preempt.h         | 21 +++++++++++++++++++++
 include/linux/trace_recursion.h |  7 +------
 kernel/events/internal.h        |  7 +------
 kernel/trace/ring_buffer.c      |  7 +------
 4 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 4d244e295e855..b32e3dabe28bd 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -77,6 +77,27 @@
 /* preempt_count() and related functions, depends on PREEMPT_NEED_RESCHED */
 #include <asm/preempt.h>
 
+/**
+ * interrupt_context_level - return interrupt context level
+ *
+ * Returns the current interrupt context level.
+ *  0 - normal context
+ *  1 - softirq context
+ *  2 - hardirq context
+ *  3 - NMI context
+ */
+static __always_inline unsigned char interrupt_context_level(void)
+{
+	unsigned long pc = preempt_count();
+	unsigned char level = 0;
+
+	level += !!(pc & (NMI_MASK));
+	level += !!(pc & (NMI_MASK | HARDIRQ_MASK));
+	level += !!(pc & (NMI_MASK | HARDIRQ_MASK | SOFTIRQ_OFFSET));
+
+	return level;
+}
+
 #define nmi_count()	(preempt_count() & NMI_MASK)
 #define hardirq_count()	(preempt_count() & HARDIRQ_MASK)
 #ifdef CONFIG_PREEMPT_RT
diff --git a/include/linux/trace_recursion.h b/include/linux/trace_recursion.h
index 00acd7dca7a7d..816d7a0d2aad6 100644
--- a/include/linux/trace_recursion.h
+++ b/include/linux/trace_recursion.h
@@ -116,12 +116,7 @@ enum {
 
 static __always_inline int trace_get_context_bit(void)
 {
-	unsigned long pc = preempt_count();
-	unsigned char bit = 0;
-
-	bit += !!(pc & (NMI_MASK));
-	bit += !!(pc & (NMI_MASK | HARDIRQ_MASK));
-	bit += !!(pc & (NMI_MASK | HARDIRQ_MASK | SOFTIRQ_OFFSET));
+	unsigned char bit = interrupt_context_level();
 
 	return TRACE_CTX_NORMAL - bit;
 }
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index aa23ffdaf819f..5150d5f84c033 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -210,12 +210,7 @@ DEFINE_OUTPUT_COPY(__output_copy_user, arch_perf_out_copy_user)
 
 static inline int get_recursion_context(int *recursion)
 {
-	unsigned int pc = preempt_count();
-	unsigned char rctx = 0;
-
-	rctx += !!(pc & (NMI_MASK));
-	rctx += !!(pc & (NMI_MASK | HARDIRQ_MASK));
-	rctx += !!(pc & (NMI_MASK | HARDIRQ_MASK | SOFTIRQ_OFFSET));
+	unsigned char rctx = interrupt_context_level();
 
 	if (recursion[rctx])
 		return -1;
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index c3c9960c9f27b..a930a9d7d834d 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3249,12 +3249,7 @@ static __always_inline int
 trace_recursive_lock(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	unsigned int val = cpu_buffer->current_context;
-	unsigned long pc = preempt_count();
-	int bit = 0;
-
-	bit += !!(pc & (NMI_MASK));
-	bit += !!(pc & (NMI_MASK | HARDIRQ_MASK));
-	bit += !!(pc & (NMI_MASK | HARDIRQ_MASK | SOFTIRQ_OFFSET));
+	int bit = interrupt_context_level();
 
 	bit = RB_CTX_NORMAL - bit;
 
-- 
2.42.0



