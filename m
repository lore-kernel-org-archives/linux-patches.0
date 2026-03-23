Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41246399352;
	Mon, 23 Mar 2026 14:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276992; cv=none; b=NtL5RwABE2ctoI2Jl2dh8Ja/IEVI0bhWiPrwNzpG3YcoFf/CGInjYxuZF7jE3KCVzZO57qUBKzGAZZ9Eetee16YdXeEjwnTsWYdWJLOV1u6VK62fkX9Z3i3zmnls1vuQPYe08TvTzaLZa5fYGAuuigbfVHCBcO2EWgrI6L527MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276992; c=relaxed/simple;
	bh=ZT2tpfoqCBSeOmNtCg8xBulrOENYZnCg/2Z5QmKezsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nz3NB5yUv+A7AqMuyU4zD11LS6cY2+ZQPcV31p7yeAQjTrcuhNYdizQ58/Xpj09oRllvV5emMJ+GWV1Be/dBwuYC+xD8sNq/JO88I4mNa/07McjZb+LuP/eKG9qWyIFcMde/5X6Ez1004GYxQ3zznkduYPrBe2U7njrV4kl/X4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6ZfBVno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6ZfBVno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E94BC4CEF7;
	Mon, 23 Mar 2026 14:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276992;
	bh=ZT2tpfoqCBSeOmNtCg8xBulrOENYZnCg/2Z5QmKezsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6ZfBVnoPTHRvxgaTS+ROxSlLspo+UPdgUA1pCP/hG7BxtkCrrmPufbW87qMqovNF
	 7sC6S0/5stkQyG/v9NXkdsNexm9pwjAbybFZCt4gw/BnwIWLrWGWqicq8Z1DMxteP0
	 nkk45muqbR0LlMhlZkmmsR+06FKtwY+12TM8TwuE=
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
Subject: [PATCH 6.12 279/460] tracing: Add recursion protection in kernel stack trace recording
Date: Mon, 23 Mar 2026 14:44:35 +0100
Message-ID: <20260323134533.333321346@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -58,6 +65,8 @@ enum {
 
 #define TRACE_LIST_START	TRACE_INTERNAL_BIT
 
+#define TRACE_EVENT_START	TRACE_INTERNAL_EVENT_BIT
+
 #define TRACE_CONTEXT_MASK	((1 << (TRACE_LIST_START + TRACE_CONTEXT_BITS)) - 1)
 
 /*
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2944,6 +2944,11 @@ static void __ftrace_trace_stack(struct
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
@@ -3015,6 +3020,7 @@ static void __ftrace_trace_stack(struct
 	__this_cpu_dec(ftrace_stack_reserve);
 	preempt_enable_notrace();
 
+	trace_clear_recursion(bit);
 }
 
 static inline void ftrace_trace_stack(struct trace_array *tr,


