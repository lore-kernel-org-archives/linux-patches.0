Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CA23ABDB3;
	Sat, 17 Oct 2026 16:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255125; cv=none; b=jLua1DYlBO6Grv2fWOmnTdtcp03+KA68+1Om2FvL0hvtlbLCb20LH7NwXwh7MDQ+RO7BozfBrPPMMybfWlvgZUhq9J2S/iOABvdqPMdm7EGel3MN+rZwbUwzB/JAOuwErbOH7QKK03pkEjHvgfa+7qN38MyIWalTqOp9P/h3ajo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255125; c=relaxed/simple;
	bh=PlzQwKeuHgCVawermRCsHrsmWC96xPc+YNlpJ7OnSUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHGmaddRM2QbEWHGNg64AU/h5DFPexxt23pkwPJeRqhr4qvMkgK1V/irGAQqSiMTR8H/GV8ICx0kswAWO8eag1TdAIPCBp/3lm4M7Ep67tGUt1aAwDAiSYguuNxaCb9IswXOvfiuI2qA2hLdGP5ghDSU9cRjn/NMZunpT3t3Nd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzvbadsm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzvbadsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2981F000C5;
	Sat, 17 Oct 2026 16:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255123;
	bh=At4FtfzI44XKWpYZ7Y6W1YNpFb6gx4joiMJBdXoNbuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jzvbadsmUwx8VaIosoL/Sh2VSzc5l+DVJxNwoxDHRdA8zvTHU5kczFugjDUPYajvn
	 yBMbv42gT3SL9fAfbkg9U9n6R6EB/6ncbqTa431pcJDPDQAf+Bcuh4Z07N0VVtrOPT
	 Ob5651hFc68EJODuHbbi6LjcpvsMC2CFeMmpv/4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 673/869] arm64: ptrace: Keep orig_x0 in-sync with x0 on syscall entry
Date: Sat, 17 Oct 2026 17:58:34 +0200
Message-ID: <20261017160054.242410045@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Will Deacon <will@kernel.org>

[ Upstream commit 88b839ce497ccb1ff92f7ae742c78dd2937ba572 ]

Commit e057b9477232 ("arm64: syscall: Ensure saved x0 is kept in-sync
with tracer updates") attempted to resolve a long-standing issue with
syscall entry tracing, where a tracer is able to manipulate the first
syscall argument without being subjected to seccomp or audit checking.

Unfortunately, that fix was incomplete [1], as it failed to update
'orig_x0' between a tracer updating x0 during a seccomp ptrace exit
(SECCOMP_RET_TRACE) and the seccomp filter being re-evaluated.

Rather than add hooks to the core seccomp code, instead move the
synchronisation code into the ptrace GPR and syscall setting code so
that 'orig_x0' is kept up to date with x0 whenever we're stopped on the
syscall entry path.

Cc: Kees Cook <kees@kernel.org>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Link: https://sashiko.dev/#/patchset/20260716120640.6590-1-will@kernel.org [1]
Reported-by: Yiqi Sun <sunyiqixm@gmail.com>
Link: https://lore.kernel.org/all/20260529065444.1336608-1-sunyiqixm@gmail.com/
Fixes: e057b9477232 ("arm64: syscall: Ensure saved x0 is kept in-sync with tracer updates")
Fixes: a5cd110cb836 ("arm64/ptrace: run seccomp after ptrace")
Tested-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/ptrace.c | 50 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index ff1fe2d398692..fd3bf1c9f8528 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -559,6 +559,42 @@ static int gpr_get(struct task_struct *target,
 	return membuf_write(&to, uregs, sizeof(*uregs));
 }
 
+static void update_syscall_orig_x0_after_ptrace(struct task_struct *target)
+{
+	struct pt_regs *regs = task_pt_regs(target);
+	struct kernel_siginfo *info = target->last_siginfo;
+
+	/*
+	 * Skip the update for NO_SYSCALL (set either by the user or the
+	 * tracer), as regs[0] holds the return value (see the comment in
+	 * el0_svc_common()) and can be unwound using syscall_rollback().
+	 */
+	if (regs->syscallno == NO_SYSCALL)
+		return;
+
+	/* We should only be called when target is in a ptrace stop */
+	if (WARN_ON_ONCE(!info))
+		return;
+
+	/*
+	 * For compat tasks, orig_r0 is provided directly through GPR index
+	 * 17.
+	 */
+	if (is_compat_thread(task_thread_info(target)))
+		return;
+
+	/*
+	 * Don't update orig_x0 for a syscall-exit-stop, as x0 now contains the
+	 * return value of the system call.
+	 */
+	if ((info->si_code & ~0x80) == SIGTRAP &&
+	    target->ptrace_message == PTRACE_EVENTMSG_SYSCALL_EXIT) {
+		return;
+	}
+
+	regs->orig_x0 = regs->regs[0];
+}
+
 static int gpr_set(struct task_struct *target, const struct user_regset *regset,
 		   unsigned int pos, unsigned int count,
 		   const void *kbuf, const void __user *ubuf)
@@ -574,6 +610,14 @@ static int gpr_set(struct task_struct *target, const struct user_regset *regset,
 		return -EINVAL;
 
 	task_pt_regs(target)->user_regs = newregs;
+
+	/*
+	 * Keep orig_x0 authoritative so that seccomp (via
+	 * syscall_get_arguments()), audit and the restart path all see the same
+	 * first argument the syscall is dispatched with, even if it has been
+	 * updated by a tracer.
+	 */
+	update_syscall_orig_x0_after_ptrace(target);
 	return 0;
 }
 
@@ -752,6 +796,12 @@ static int system_call_set(struct task_struct *target,
 		return ret;
 
 	task_pt_regs(target)->syscallno = syscallno;
+
+	/*
+	 * Re-sync orig_x0 in case the syscall number has been changed
+	 * from NO_SYSCALL.
+	 */
+	update_syscall_orig_x0_after_ptrace(target);
 	return ret;
 }
 
-- 
2.53.0



