Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D429381CE;
	Fri, 24 Nov 2023 19:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JlTY9RDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E74C433CA;
	Fri, 24 Nov 2023 19:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853172;
	bh=Jhv2SsQR2rM/MlSHwhMm8hAKlDIvwhAHm/E6mnYtWQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JlTY9RDQptu0EUNRYOwaZ9N8vDpjkUGdkQSo+hgndyHK7CeFBO/AIpS9n6t5vHEcG
	 v/02pY2mWZqOk1jhhmS+8EuTaXL4VhRdiQAmKuY88H76qxlZ6e1LfWdbWX7l8PLsYE
	 SchssDVWaecaZFuIVr5zKB/ZAIsetJRrmay7xh+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/297] tracing: Reuse logic from perfs get_recursion_context()
Date: Fri, 24 Nov 2023 17:52:05 +0000
Message-ID: <20231124172003.158072801@linuxfoundation.org>
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

[ Upstream commit 9b84fadc444de5456ab5f5487e2108311c724c3f ]

Instead of having branches that adds noise to the branch prediction, use
the addition logic to set the bit for the level of interrupt context that
the state is currently in. This copies the logic from perf's
get_recursion_context() function.

Link: https://lore.kernel.org/all/20211015161702.GF174703@worktop.programming.kicks-ass.net/

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Stable-dep-of: 87c3a5893e86 ("sched/core: Optimize in_task() and in_interrupt() a bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/trace_recursion.h | 11 ++++++-----
 kernel/trace/ring_buffer.c      | 12 ++++++------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/linux/trace_recursion.h b/include/linux/trace_recursion.h
index fe95f09225266..00acd7dca7a7d 100644
--- a/include/linux/trace_recursion.h
+++ b/include/linux/trace_recursion.h
@@ -117,12 +117,13 @@ enum {
 static __always_inline int trace_get_context_bit(void)
 {
 	unsigned long pc = preempt_count();
+	unsigned char bit = 0;
 
-	if (!(pc & (NMI_MASK | HARDIRQ_MASK | SOFTIRQ_OFFSET)))
-		return TRACE_CTX_NORMAL;
-	else
-		return pc & NMI_MASK ? TRACE_CTX_NMI :
-			pc & HARDIRQ_MASK ? TRACE_CTX_IRQ : TRACE_CTX_SOFTIRQ;
+	bit += !!(pc & (NMI_MASK));
+	bit += !!(pc & (NMI_MASK | HARDIRQ_MASK));
+	bit += !!(pc & (NMI_MASK | HARDIRQ_MASK | SOFTIRQ_OFFSET));
+
+	return TRACE_CTX_NORMAL - bit;
 }
 
 #ifdef CONFIG_FTRACE_RECORD_RECURSION
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index e5dc7b5a261c6..c3c9960c9f27b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3250,13 +3250,13 @@ trace_recursive_lock(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	unsigned int val = cpu_buffer->current_context;
 	unsigned long pc = preempt_count();
-	int bit;
+	int bit = 0;
 
-	if (!(pc & (NMI_MASK | HARDIRQ_MASK | SOFTIRQ_OFFSET)))
-		bit = RB_CTX_NORMAL;
-	else
-		bit = pc & NMI_MASK ? RB_CTX_NMI :
-			pc & HARDIRQ_MASK ? RB_CTX_IRQ : RB_CTX_SOFTIRQ;
+	bit += !!(pc & (NMI_MASK));
+	bit += !!(pc & (NMI_MASK | HARDIRQ_MASK));
+	bit += !!(pc & (NMI_MASK | HARDIRQ_MASK | SOFTIRQ_OFFSET));
+
+	bit = RB_CTX_NORMAL - bit;
 
 	if (unlikely(val & (1 << (bit + cpu_buffer->nest)))) {
 		/*
-- 
2.42.0



