Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48EF3F482E;
	Thu, 16 Jul 2026 13:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209349; cv=none; b=OG9x1m2WS9uWClIPDiYUX75h1lJ5Bq++5C6oJn3/0bkLGyT3D2gIkTfzKNCPFukgqhKUHl+s6t+rO2f0YQq7QCNQo2UQn6fEeRUuJ1YhGYmI7swUZ2vyHxFitZz0TdFmTmZW+2nxkMoJUPFgn1GmNXp1zKX5yq4rv9NY04i8gX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209349; c=relaxed/simple;
	bh=DhB67bsz95hVuCFqnBobi1ktEt4M7dpjj31YiCQbh6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJVltE1JjNPbuGWMfuKWuZD76btCP6YWhjfEAylPivyW8kvMkTcVP6AmonDDWpkrTm+4il1oWL4Cd5+OsKsLwJCSvIJP/fFIId77mkbvMa501pwgmhsS5KyM6Sem19JcGgKJdHTGg1XYqZpKgPaNboNYlEWyKcJB7a7+uUQNLqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l2Q1LqJe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l2Q1LqJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557A91F000E9;
	Thu, 16 Jul 2026 13:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209347;
	bh=BeF5Auu0aQI4RQc6AKG15ovLNSdLtJsVe4ISgeCyjDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l2Q1LqJe/v+ckB2kwAgmNLIxOIdfEKLdMdHHEx8/CYl6JkzTc/HItkqyMzJTgAOaG
	 6VERz33qgI14hzAHQtGfgJZQAbYmWy2vpSZZ5T0l7djvCp9WdfjRoyrUOLgWQ2h9S8
	 oILTBb5tjKwUbDCu09gnjGPpA78irYkQt5XtlWYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanhe Shu <xiangzao@linux.alibaba.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 150/518] tracing: Fix NULL pointer dereference in func_set_flag()
Date: Thu, 16 Jul 2026 15:26:58 +0200
Message-ID: <20260716133051.130662065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanhe Shu <xiangzao@linux.alibaba.com>

commit c3e94604675e3db186111b8942650d86577df9b0 upstream.

func_set_flag() dereferences tr->current_trace_flags before verifying
that the current tracer is actually the function tracer. When the active
tracer has been switched away from "function" (e.g., to "wakeup_rt"),
tr->current_trace_flags can be NULL, leading to a NULL pointer
dereference and kernel crash.

The call chain that triggers this is:

  trace_options_write()
    -> __set_tracer_option()
      -> trace->set_flag()          /* func_set_flag */

In func_set_flag(), the first operation is:

  if (!!set == !!(tr->current_trace_flags->val & bit))

This dereferences tr->current_trace_flags unconditionally. The safety
check that guards against a non-function tracer:

  if (tr->current_trace != &function_trace)
      return 0;

is placed *after* the dereference, which is too late.

This was observed with the following crash dump:

  BUG: unable to handle page fault at 0000000000000000
  RIP: func_set_flag+0xd

  Call Trace:
   __set_tracer_option+0x27
   trace_options_write+0x75
   vfs_write+0x12a
   ksys_write+0x66
   do_syscall_64+0x5b

  RIP: ffffffff914c973d  RSP: ff67ec88b01dfdf0  RFLAGS: 00010202
  RAX: 0000000000000000  RBX: ff3a826e80354580  RCX: 0000000000000001
  RDX: 0000000000000001  RSI: 0000000000000000  RDI: ffffffff93918080

The disassembly confirms the fault:

  func_set_flag+0:   mov 0x1f08(%rdi), %rax  ; RAX = tr->current_trace_flags = NULL
  func_set_flag+13:  mov (%rax), %eax        ; page fault: dereference NULL

At the time of the crash:
  tr->current_trace_flags = 0x0 (NULL)
  tr->current_trace = wakeup_rt_tracer (not function_trace)

The scenario is that a process opens a function tracer option file (such
as "func_stack_trace"), then the current tracer is switched to another
tracer (e.g., "wakeup_rt"), which sets current_trace_flags to NULL. When
the process subsequently writes to the option file, func_set_flag() is
invoked and crashes on the NULL dereference.

Fix this by moving the current_trace check before the
current_trace_flags dereference, so that func_set_flag() returns early
when the function tracer is not active.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260624061715.1445655-1-xiangzao@linux.alibaba.com
Fixes: 76680d0d2825 ("tracing: Have function tracer define options per instance")
Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_functions.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -458,12 +458,12 @@ func_set_flag(struct trace_array *tr, u3
 	ftrace_func_t func;
 	u32 new_flags;
 
-	/* Do nothing if already set. */
-	if (!!set == !!(tr->current_trace_flags->val & bit))
+	/* We can change this flag only when current tracer is function. */
+	if (tr->current_trace != &function_trace)
 		return 0;
 
-	/* We can change this flag only when not running. */
-	if (tr->current_trace != &function_trace)
+	/* Do nothing if already set. */
+	if (!!set == !!(tr->current_trace_flags->val & bit))
 		return 0;
 
 	new_flags = (tr->current_trace_flags->val & ~bit) | (set ? bit : 0);


