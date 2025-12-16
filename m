Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DE0341645;
	Tue, 16 Dec 2025 11:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884097; cv=none; b=XPCOAT9x2SwncHVW1+Qf2z0w/iNteCh141H0puyFXPNgFnxeVic4Sp19xC0gHEf77mfTFBRZ8X3K7iq2TyNVJ69MhxQf703c9XkZJjP6+3amLV7fZTsxuk9uLWMTnGdMrYh1G95par3SYJh2NcYAW92NM8zYcVqidWT8eo9DJCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884097; c=relaxed/simple;
	bh=V6XIIg9CfQLocA2UFlGb+rnvEZVf2YSY1cbRcmo9YYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPtilgobIMKc1W8fGXp9C1VYlapvvYsMn3LWaoF9I0bA8FglCE4b+P4VMcXGHWf1AP5waWPqg3XEPmtjCRT23phz5Gxq2bLcvr/IEvggE15veKkD4kgX5sN3edzes2v+KzWBtSR9StS/7InihhXf2arNfPv7QemwSo3CW4adodE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2Qv1fJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2Qv1fJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CDFC4CEF5;
	Tue, 16 Dec 2025 11:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884097;
	bh=V6XIIg9CfQLocA2UFlGb+rnvEZVf2YSY1cbRcmo9YYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2Qv1fJLSjQaWXDRXZttKiMAP9PoC2tCHo1Kz967wDZ5eXAteMS4HYXoP8UKQ0xOg
	 QZbbGWkRlvgc3kFEBmotM5uduolQc/eQOQtBe+W7nbrDZF9YRKopzkSqbc8Qi851uI
	 cLNAogHCctk/pVehr+bwGHkNdLD4yUhkuCQh7ZfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/354] x86/dumpstack: Prevent KASAN false positive warnings in __show_regs()
Date: Tue, 16 Dec 2025 12:10:57 +0100
Message-ID: <20251216111324.184352811@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index b2b118a8c09be..5f011e99f0f09 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -183,8 +183,8 @@ static void show_regs_if_on_stack(struct stack_info *info, struct pt_regs *regs,
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
@@ -305,6 +305,25 @@ static void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
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



