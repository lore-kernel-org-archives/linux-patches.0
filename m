Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436673B95EB;
	Mon, 23 Mar 2026 15:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278933; cv=none; b=Hy7NHX3zhvyhPWQ1zboEXwl8Fphv0vInSp3WClwOhHOfL7zbw5kxe9H6O9eRmhlXMof/3XxE5ZS+1EndUA4UpMCBnNEiQclW/CJfY7h9Sq7hrfLXBxqlncUzPMWCyA4LG0w+SZdih4JWWnoFBbEUcpMmK7sdqS8UMY12E/uUQcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278933; c=relaxed/simple;
	bh=FR+xJpa0UruSvCkOHg7QvDfRkITs647WFokf7GpWgWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kk06hbmmAUq7dokxIexsrT5dZZ+5mml3j5XLKeIq60u0oqPexhxIjkABaCZxy74c3OeyGdUG6UdD+FwtAzh0gemmtVGXcTJ1uLXofShWYbaqFknck2dXWB+E/LwLLyefnJ00RFLLd/CS1vXMhU0vlk1V/IaSQpNVJA6d+z4xb8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHG4Xa6/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHG4Xa6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D412C2BC9E;
	Mon, 23 Mar 2026 15:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278933;
	bh=FR+xJpa0UruSvCkOHg7QvDfRkITs647WFokf7GpWgWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHG4Xa6/KAL50S9zsbuJS5h04erE7tyjvtgjBq8uIgJLdOpxP5ZiZz7rwq2X0HdpH
	 yKI5PKP0yh2J/RVTdkqcQ6tkOygAHNzju+CbZ9gXLqmaoclzqL1T/x4gBHJ6N6WudK
	 SB7UobZe7O6ySEIxOOC75h3HRTV5ew76Xi9IRIgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Yao Kai <yaokai34@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Leon Chen <leonchen.oss@139.com>
Subject: [PATCH 6.6 423/567] tracing: Add recursion protection in kernel stack trace recording
Date: Mon, 23 Mar 2026 14:45:43 +0100
Message-ID: <20260323134544.354050710@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 5f1ef0dfcb5b7f4a91a9b0e0ba533efd9f7e2cdb ]

A bug was reported about an infinite recursion caused by tracing the rcu
events with the kernel stack trace trigger enabled. The stack trace code
called back into RCU which then called the stack trace again.

Expand the ftrace recursion protection to add a set of bits to protect
events from recursion. Each bit represents the context that the event is
in (normal, softirq, interrupt and NMI).

Have the stack trace code use the interrupt context to protect against
recursion.

Note, the bug showed an issue in both the RCU code as well as the tracing
stacktrace code. This only handles the tracing stack trace side of the
bug. The RCU fix will be handled separately.

Link: https://lore.kernel.org/all/20260102122807.7025fc87@gandalf.local.home/

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Link: https://patch.msgid.link/20260105203141.515cd49f@gandalf.local.home
Reported-by: Yao Kai <yaokai34@huawei.com>
Tested-by: Yao Kai <yaokai34@huawei.com>
Fixes: 5f5fa7ea89dc ("rcu: Don't use negative nesting depth in __rcu_read_unlock()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Leon Chen <leonchen.oss@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/trace_recursion.h |    9 +++++++++
 kernel/trace/trace.c            |    6 ++++++
 2 files changed, 15 insertions(+)

--- a/include/linux/trace_recursion.h
+++ b/include/linux/trace_recursion.h
@@ -34,6 +34,13 @@ enum {
 	TRACE_INTERNAL_SIRQ_BIT,
 	TRACE_INTERNAL_TRANSITION_BIT,
 
+	/* Internal event use recursion bits */
+	TRACE_INTERNAL_EVENT_BIT,
+	TRACE_INTERNAL_EVENT_NMI_BIT,
+	TRACE_INTERNAL_EVENT_IRQ_BIT,
+	TRACE_INTERNAL_EVENT_SIRQ_BIT,
+	TRACE_INTERNAL_EVENT_TRANSITION_BIT,
+
 	TRACE_BRANCH_BIT,
 /*
  * Abuse of the trace_recursion.
@@ -97,6 +104,8 @@ enum {
 
 #define TRACE_LIST_START	TRACE_INTERNAL_BIT
 
+#define TRACE_EVENT_START	TRACE_INTERNAL_EVENT_BIT
+
 #define TRACE_CONTEXT_MASK	((1 << (TRACE_LIST_START + TRACE_CONTEXT_BITS)) - 1)
 
 /*
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3105,6 +3105,11 @@ static void __ftrace_trace_stack(struct
 	struct ftrace_stack *fstack;
 	struct stack_entry *entry;
 	int stackidx;
+	int bit;
+
+	bit = trace_test_and_set_recursion(_THIS_IP_, _RET_IP_, TRACE_EVENT_START);
+	if (bit < 0)
+		return;
 
 	/*
 	 * Add one, for this function and the call to save_stack_trace()
@@ -3162,6 +3167,7 @@ static void __ftrace_trace_stack(struct
 	__this_cpu_dec(ftrace_stack_reserve);
 	preempt_enable_notrace();
 
+	trace_clear_recursion(bit);
 }
 
 static inline void ftrace_trace_stack(struct trace_array *tr,


