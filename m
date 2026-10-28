Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214635;
	b=WLr9HofaCKBAJMpjJbHtiAOlZDy5i3SSE+dm4ZrJoI8rTts5hwZ6AgFIqOIQAuka+MC6
	 YWFvtsX521WBH5oRhSqWgauEmvZlMNIxCYSw5UQLJkt+mkX3g4pSdh7P3jOMYTx1sMacZ
	 vJ4xfgyi0Uik3g8RzMvwrF+CKaJV7lRg3WRl5vrn9YyokmJmk078DRwPi0QeyN6YI5YMj
	 u1RN/T2WyBAYAgP6pS+M7so+xj1nnkBTT26Jbc7Veprv4p9WhIar64h/bgz7Nkmzr1wBq
	 EE+1MF2G1E4tz3tDP4TUEB4Ftyf95sWTomfLEXzrby3ey9K+pSAp04C/OUPPanndQ3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xiw6duruzDuWiYBIhFhQJ0dqogKvrbs/dJ69Kjj2wgE=;
	b=CpLdKwyeJn1kSlaLz+6s1BQYdWYIMtOaQNyg2LD5MoaYj7fIYDbdRtf8y4/H9w8+ta0e
	 2vnyXvCyt5cwZEGjowFjJCVLhfjSGIVJhsVw5iqPV0/4nqkWPhkJkRsKodoUbHTabo+N6
	 WokGR15IkgoPgocW17rvEY0rzoZo+wwHWA2BZvhylUl4o+TR9miHONMSADadTwFazbvNK
	 HPiN0RowIkhaUeHZCHURNrLFUjWtgid2gAAZhPkfEOjNcio+XLSBKEZVhpHMo0ua8VDZ7
	 bhKtK8YmRaANDI73/IOqBOV3Iz7LkgX9qPB6x0bhKWE+4sHq9rQ71p5oEopbXeK8gLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HVocC/93";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4968F606B7C7;
	Wed, 28 Oct 2026 19:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HVocC/93
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1211F01825;
	Wed, 28 Oct 2026 19:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214635;
	bh=xiw6duruzDuWiYBIhFhQJ0dqogKvrbs/dJ69Kjj2wgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HVocC/93X8cR1fxOeX3okaPxGgzuDAIXddviFsyaZGbP4tB44y02+0xhr8/0Sj1Y4
	 uhT3PYDu71lrXhwPRqAJVurkt47KIMX3jfhtZKZLUgrpVY5eOXflx5X7Gw1LQK4o5T
	 vP4Cx6BOpm1X8Vn5tSiNMxNOsURe5oXLMnSvLs8A=
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
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0928/1887] tracing: Add recursion protection in kernel stack trace recording
Date: Wed, 28 Oct 2026 17:50:24 +0100
Message-ID: <20261028170520.533182884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/trace_recursion.h | 9 +++++++++
 kernel/trace/trace.c            | 7 ++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/trace_recursion.h b/include/linux/trace_recursion.h
index c303f7a114e91..2ac1853f056d5 100644
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
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 33770d2b3489e..5426bad36419a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3043,6 +3043,11 @@ static void __ftrace_trace_stack(struct trace_buffer *buffer,
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
@@ -3099,7 +3104,7 @@ static void __ftrace_trace_stack(struct trace_buffer *buffer,
 	barrier();
 	__this_cpu_dec(ftrace_stack_reserve);
 	preempt_enable_notrace();
-
+	trace_clear_recursion(bit);
 }
 
 static inline void ftrace_trace_stack(struct trace_array *tr,
-- 
2.53.0



