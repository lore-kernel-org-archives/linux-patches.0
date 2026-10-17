Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2770D3D25D2;
	Sat, 17 Oct 2026 18:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260139; cv=none; b=oGfxL3Sged5mAiLbBs+5O0QU/lEcu39/1J440uP4ywpjQuP1AflLiuMO/ka619cDulbnGdRtovpaVKoX1nc/VICho1ms12KEdu6U93xpNzF2mjoutZTPxAajWiLmctUVaSftEEkYMYtoMw/EvPRwm6fS0aMtCfweTe6wrfaQL28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260139; c=relaxed/simple;
	bh=5MQ6oJ9N5GVk2UtzmRQECX3QuE87HU0z6IhRurssU7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NCaoQuIC4aCDKu5rHuuFxb8dSnojYu5TnvRCtyKWYlU9KJ4eTVx5O7GrW54EvFh5eVbKpQtEtGomvzvFTVgOz+FBFiiaG67ZmHgickgwGdtmj6YiMQdgu0qO7wNgVwffPyWZgZ9XQ5PmBVQOoBwDxcQWDTXcmhnhaxTAi+36VTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFqQ+KvT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFqQ+KvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAD51F000C4;
	Sat, 17 Oct 2026 18:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260134;
	bh=8TCCrJp+kQI9kBYnbqQbMbyc/TNXI7/1i3wuBlh7fbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFqQ+KvTyA2zDviXbBYVr5fY7cXCsnQcSedBSfLNlORP0QPfX4cO7WaO+ZYKkavcr
	 k10ZSEWpemNfmJckgL8+qmT1mt3WQPLy7rOmc/A+TazwJChv5kFi+By3BINvTYUAd7
	 cm/dtO+/Mqaoq0awt5l27C7ah6+2/G4oRtcZFHbo=
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
Subject: [PATCH 6.6 1444/1674] arm64: ptrace: Keep orig_x0 in-sync with x0 on syscall entry
Date: Sat, 17 Oct 2026 18:01:56 +0200
Message-ID: <20261017160508.245655973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index c30f5a70bd18f..69854a0a6301a 100644
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
 
@@ -717,6 +761,12 @@ static int system_call_set(struct task_struct *target,
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



