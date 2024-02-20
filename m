Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE7D14F9DA;
	Tue, 20 Feb 2024 21:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465151; cv=none; b=JCIRHnYBrjBNPrs5OKqLUKsM7kg1ThCweqxDqrn6za/RK7pngmODrnHRRUbEotI4o8jKyQKwd3MYz2JG73RqQPwD0l1FJk08/Y2i9fx2rYLHUvjZfv/HMiP4H/XAcKj3QCnIarZeh8ojo3mrxjLJPCfns3mUybzskJOjIwmTVFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465151; c=relaxed/simple;
	bh=uoVoGdTMiLU7d/dUyzC4KjAHgBwjABwnXfifONscHn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDMJ5F9iJv4TNn9B7thybv/tlOjkkl/ynF4siKPCJB7v6NJyAtnHxbX0t6QfxOUiWp+I9z0IeogH8EAYcaG0nr/7rEVBFGWqUlKWyY+IY04O1x5LMEtRGZ7WPmMoYF2FcEB0OV7hNsg4MhyyjJn8X0uZ0RAvidWeUonK8uqAODU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4JhtTQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4JhtTQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0ACC433C7;
	Tue, 20 Feb 2024 21:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465151;
	bh=uoVoGdTMiLU7d/dUyzC4KjAHgBwjABwnXfifONscHn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4JhtTQtJXHgRwYRir5Z5qTpflV4IWlHl/OFKv4jtjrads13AhXnxngKBrkukqpP4
	 zoyQTPLSaEKXZQlCmGPC8tHNkWANFXmx5jo7zGwFKoWKocRzE6nxVzIZwLkB44ro7i
	 dArLgWNsM96XqAgKeHNNfSZemu1HjiFkVZL81YLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florent Revest <revest@chromium.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.7 225/309] ftrace: Fix DIRECT_CALLS to use SAVE_REGS by default
Date: Tue, 20 Feb 2024 21:56:24 +0100
Message-ID: <20240220205640.195170739@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit a8b9cf62ade1bf17261a979fc97e40c2d7842353 upstream.

The commit 60c8971899f3 ("ftrace: Make DIRECT_CALLS work WITH_ARGS
and !WITH_REGS") changed DIRECT_CALLS to use SAVE_ARGS when there
are multiple ftrace_ops at the same function, but since the x86 only
support to jump to direct_call from ftrace_regs_caller, when we set
the function tracer on the same target function on x86, ftrace-direct
does not work as below (this actually works on arm64.)

At first, insmod ftrace-direct.ko to put a direct_call on
'wake_up_process()'.

 # insmod kernel/samples/ftrace/ftrace-direct.ko
 # less trace
...
          <idle>-0       [006] ..s1.   564.686958: my_direct_func: waking up rcu_preempt-17
          <idle>-0       [007] ..s1.   564.687836: my_direct_func: waking up kcompactd0-63
          <idle>-0       [006] ..s1.   564.690926: my_direct_func: waking up rcu_preempt-17
          <idle>-0       [006] ..s1.   564.696872: my_direct_func: waking up rcu_preempt-17
          <idle>-0       [007] ..s1.   565.191982: my_direct_func: waking up kcompactd0-63

Setup a function filter to the 'wake_up_process' too, and enable it.

 # cd /sys/kernel/tracing/
 # echo wake_up_process > set_ftrace_filter
 # echo function > current_tracer
 # less trace
...
          <idle>-0       [006] ..s3.   686.180972: wake_up_process <-call_timer_fn
          <idle>-0       [006] ..s3.   686.186919: wake_up_process <-call_timer_fn
          <idle>-0       [002] ..s3.   686.264049: wake_up_process <-call_timer_fn
          <idle>-0       [002] d.h6.   686.515216: wake_up_process <-kick_pool
          <idle>-0       [002] d.h6.   686.691386: wake_up_process <-kick_pool

Then, only function tracer is shown on x86.
But if you enable 'kprobe on ftrace' event (which uses SAVE_REGS flag)
on the same function, it is shown again.

 # echo 'p wake_up_process' >> dynamic_events
 # echo 1 > events/kprobes/p_wake_up_process_0/enable
 # echo > trace
 # less trace
...
          <idle>-0       [006] ..s2.  2710.345919: p_wake_up_process_0: (wake_up_process+0x4/0x20)
          <idle>-0       [006] ..s3.  2710.345923: wake_up_process <-call_timer_fn
          <idle>-0       [006] ..s1.  2710.345928: my_direct_func: waking up rcu_preempt-17
          <idle>-0       [006] ..s2.  2710.349931: p_wake_up_process_0: (wake_up_process+0x4/0x20)
          <idle>-0       [006] ..s3.  2710.349934: wake_up_process <-call_timer_fn
          <idle>-0       [006] ..s1.  2710.349937: my_direct_func: waking up rcu_preempt-17

To fix this issue, use SAVE_REGS flag for multiple ftrace_ops flag of
direct_call by default.

Link: https://lore.kernel.org/linux-trace-kernel/170484558617.178953.1590516949390270842.stgit@devnote2

Fixes: 60c8971899f3 ("ftrace: Make DIRECT_CALLS work WITH_ARGS and !WITH_REGS")
Cc: stable@vger.kernel.org
Cc: Florent Revest <revest@chromium.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com> [arm64]
Acked-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5325,7 +5325,17 @@ static LIST_HEAD(ftrace_direct_funcs);
 
 static int register_ftrace_function_nolock(struct ftrace_ops *ops);
 
+/*
+ * If there are multiple ftrace_ops, use SAVE_REGS by default, so that direct
+ * call will be jumped from ftrace_regs_caller. Only if the architecture does
+ * not support ftrace_regs_caller but direct_call, use SAVE_ARGS so that it
+ * jumps from ftrace_caller for multiple ftrace_ops.
+ */
+#ifndef HAVE_DYNAMIC_FTRACE_WITH_REGS
 #define MULTI_FLAGS (FTRACE_OPS_FL_DIRECT | FTRACE_OPS_FL_SAVE_ARGS)
+#else
+#define MULTI_FLAGS (FTRACE_OPS_FL_DIRECT | FTRACE_OPS_FL_SAVE_REGS)
+#endif
 
 static int check_direct_multi(struct ftrace_ops *ops)
 {


