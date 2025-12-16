Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD51A34D3B8;
	Tue, 16 Dec 2025 11:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885377; cv=none; b=T4lpWmzPgunHWY3N09lxMXm+WvoLqbwHP2I+ooAgKHW2xTWmKZnx0YFux+lhga3WkM4iHgJQ5EcHf0E098XjK4X2JDMinFadG9qomc1AOeh9YNPD+m+k03cPgGtbe4duxyYeNjQyIpEk5tIAS3dHD1DwC+AqV9YPTKQ++5fwrw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885377; c=relaxed/simple;
	bh=va6neb/QgmqkcpvMi27UD9xBjZWyIP7THwi8HADA3uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1DMvz9NHkl54Dx6PLGjlBYikM+ZENLeB6m3Za4sPBmsQUQ0krhxpuvQ0qOadodM1lOWawJUcuZW6H1iqLY3+3OuDWNYWnPCe3EWhWKslKcKynOtbP+oku3BeGodud6URko27pCnQsMolnYUDbpHsiClPJSBMqJJtQ9yCiuF6Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UH5zGWzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UH5zGWzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A5EC4CEF1;
	Tue, 16 Dec 2025 11:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885377;
	bh=va6neb/QgmqkcpvMi27UD9xBjZWyIP7THwi8HADA3uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UH5zGWzLvqZEcUp+j7xCtfHNPVukUveqE3TFkja0KMEY09nv1iFXQ8idaKKL6e2kL
	 5hCeo2PRK/l2Kuk46cKdV538wiVh+4uZHaUu+yCZkVUo5l4gk/XmLYCBBCwH/GEa3M
	 ufdvCvAqFBh3AAJyKgCMNrfwIFIbdU+tLaqrihwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 121/507] x86/dumpstack: Prevent KASAN false positive warnings in __show_regs()
Date: Tue, 16 Dec 2025 12:09:22 +0100
Message-ID: <20251216111349.916938371@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tengda Wu <wutengda@huaweicloud.com>

[ Upstream commit ced37e9ceae50e4cb6cd058963bd315ec9afa651 ]

When triggering a stack dump via sysrq (echo t > /proc/sysrq-trigger),
KASAN may report false-positive out-of-bounds access:

  BUG: KASAN: out-of-bounds in __show_regs+0x4b/0x340
  Call Trace:
    dump_stack_lvl
    print_address_description.constprop.0
    print_report
    __show_regs
    show_trace_log_lvl
    sched_show_task
    show_state_filter
    sysrq_handle_showstate
    __handle_sysrq
    write_sysrq_trigger
    proc_reg_write
    vfs_write
    ksys_write
    do_syscall_64
    entry_SYSCALL_64_after_hwframe

The issue occurs as follows:

  Task A (walk other tasks' stacks)           Task B (running)
  1. echo t > /proc/sysrq-trigger
  show_trace_log_lvl
    regs = unwind_get_entry_regs()
    show_regs_if_on_stack(regs)
                                              2. The stack value pointed by
                                                 `regs` keeps changing, and
                                                 so are the tags in its
                                                 KASAN shadow region.
      __show_regs(regs)
        regs->ax, regs->bx, ...
          3. hit KASAN redzones, OOB

When task A walks task B's stack without suspending it, the continuous changes
in task B's stack (and corresponding KASAN shadow tags) may cause task A to
hit KASAN redzones when accessing obsolete values on the stack, resulting in
false positive reports.

Simply stopping the task before unwinding is not a viable fix, as it would
alter the state intended to inspect. This is especially true for diagnosing
misbehaving tasks (e.g., in a hard lockup), where stopping might fail or hide
the root cause by changing the call stack.

Therefore, fix this by disabling KASAN checks during asynchronous stack
unwinding, which is identified when the unwinding task does not match the
current task (task != current).

  [ bp: Align arguments on function's opening brace. ]

Fixes: 3b3fa11bc700 ("x86/dumpstack: Print any pt_regs found on the stack")
Signed-off-by: Tengda Wu <wutengda@huaweicloud.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://patch.msgid.link/all/20251023090632.269121-1-wutengda@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/dumpstack.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 71ee20102a8af..b10684dedc589 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -181,8 +181,8 @@ static void show_regs_if_on_stack(struct stack_info *info, struct pt_regs *regs,
  * in false positive reports. Disable instrumentation to avoid those.
  */
 __no_kmsan_checks
-static void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-			unsigned long *stack, const char *log_lvl)
+static void __show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
+				 unsigned long *stack, const char *log_lvl)
 {
 	struct unwind_state state;
 	struct stack_info stack_info = {0};
@@ -303,6 +303,25 @@ static void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	}
 }
 
+static void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
+			       unsigned long *stack, const char *log_lvl)
+{
+	/*
+	 * Disable KASAN to avoid false positives during walking another
+	 * task's stacks, as values on these stacks may change concurrently
+	 * with task execution.
+	 */
+	bool disable_kasan = task && task != current;
+
+	if (disable_kasan)
+		kasan_disable_current();
+
+	__show_trace_log_lvl(task, regs, stack, log_lvl);
+
+	if (disable_kasan)
+		kasan_enable_current();
+}
+
 void show_stack(struct task_struct *task, unsigned long *sp,
 		       const char *loglvl)
 {
-- 
2.51.0



