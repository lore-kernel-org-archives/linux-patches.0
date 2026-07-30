Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C179435DA67;
	Thu, 30 Jul 2026 15:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426458; cv=none; b=lNiWipSb25HI5Eu+BQdqKtHopdndIWJTIgB5LcLj3xa7EkwXkoBjWGNTrEyELHXLJNwjLX3vJVbGd6Zi8tldLLuJr5ghoerpbNmCZ65hFFvcVlYtnr1YHMU5CLz/6mJs5OSZOXsxoJue1jMzI7q3PljxwRD3C1POn3/aO1BIQhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426458; c=relaxed/simple;
	bh=zfrt3aRGCI8QZw1sMke3QdPm9Ox8kp5v7cnAtWZ+R2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1HwgtoZdxSDVm9I1gk/rF+O6d5L4Ek2jaR6vfT5r3KyYkYLjkyQ1kZgi6dT0kA2FxU3FLKM2qjjfMFwkPcN4HxMU7FW4SmmW2Z+5OKJ3ocSBCBtMuUmG47NocoPKioQ4MKGujIyPL9Xk/LAOtHw8FxcRUQsGuHUXW6jqn3GBbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqNV5WMq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqNV5WMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2782A1F000E9;
	Thu, 30 Jul 2026 15:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426456;
	bh=Sq8hUVPn6GoOBuT9YK5RKlM4mpqZVY4SieXjQ8wX/3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jqNV5WMqN2cOpWE/Z+boCG1hgGa1kUpQiA0NGb2lF8JPsy6gi9epQc2As2wL3C7ol
	 m1jsACyUYn9Lmhn/zvpUO8QCm4JMEbZzBXoDdkllzUoerOhCk1eDJvtWMZZSnwMzIO
	 8qG0a1DB6LqPCR0FNXhRRUQ2W2dd2fveYYlFCw7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 382/602] arm64: syscall: Ensure saved x0 is kept in-sync with tracer updates
Date: Thu, 30 Jul 2026 16:12:54 +0200
Message-ID: <20260730141443.987360477@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

commit e057b94772328221405b067c3a85fe479b915dc8 upstream.

When seccomp support was originally added to arm64 in a1ae65b21941
("arm64: add seccomp support"), seccomp was erroneously called _before_
the ptrace syscall-enter-stop and therefore the tracer could trivially
manipulate the syscall register state after the seccomp check had
passed. This was subsequently fixed in a5cd110cb836 ("arm64/ptrace: run
seccomp after ptrace") by moving the seccomp check after the tracer has
run. Unfortunately, a decade later, that fix has been reported to be
incomplete.

On arm64, both the first argument to a syscall and its eventual return
value are allocated to register x0. In order to facilitate syscall
restarting and querying of syscall arguments on the syscall exit path,
the original value of x0 is stashed in 'struct pt_regs::orig_x0' early
during the syscall entry path and is returned for the first argument by
syscall_get_arguments(). Unlike 32-bit Arm, this stashed value is not
directly exposed via ptrace() and so changes to register x0 made by the
tracer on a syscall-enter-stop are not reflected in 'orig_x0'. This
means that seccomp, syscall tracepoints and audit can observe a stale
value for the register compared to the argument that will be observed by
the actual syscall.

Re-sync 'orig_x0' from x0 on the syscall entry path following a
potential ptrace stop (i.e. PTRACE_EVENTMSG_SYSCALL_ENTRY or
SECCOMP_RET_TRACE). This behaviour is limited to native tasks (because
compat tasks expose 'orig_r0' to ptrace) where the syscall is not being
skipped (because x0 is updated to hold the return value of -ENOSYS in
that case).

Cc: Kees Cook <kees@kernel.org>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Reported-by: Yiqi Sun <sunyiqixm@gmail.com>
Link: https://lore.kernel.org/all/20260529065444.1336608-1-sunyiqixm@gmail.com/
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Fixes: a5cd110cb836 ("arm64/ptrace: run seccomp after ptrace")
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Tested-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/ptrace.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -2285,6 +2285,21 @@ static void report_syscall(struct pt_reg
 	}
 }
 
+static void update_syscall_orig_x0_after_ptrace(struct pt_regs *regs)
+{
+	/*
+	 * Keep orig_x0 authoritative so that seccomp (via
+	 * syscall_get_arguments()), audit and the restart path all see the same
+	 * first argument the syscall is dispatched with, even if it has been
+	 * updated by a tracer. Skip this for NO_SYSCALL (set either by the user
+	 * or the tracer), as regs[0] holds the return value (see the comment in
+	 * el0_svc_common()) and can be unwound using syscall_rollback().
+	 * For compat tasks, orig_r0 is provided directly through GPR index 17.
+	 */
+	if (!is_compat_task() && regs->syscallno != NO_SYSCALL)
+		regs->orig_x0 = regs->regs[0];
+}
+
 int syscall_trace_enter(struct pt_regs *regs)
 {
 	unsigned long flags = read_thread_flags();
@@ -2293,12 +2308,26 @@ int syscall_trace_enter(struct pt_regs *
 		report_syscall(regs, PTRACE_SYSCALL_ENTER);
 		if (flags & _TIF_SYSCALL_EMU)
 			return NO_SYSCALL;
+
+		/*
+		 * Ensure ptrace changes to x0 during a regular
+		 * syscall-enter-stop (PTRACE_SYSCALL) are visible to
+		 * subsequent seccomp checks, tracepoints and audit.
+		 */
+		update_syscall_orig_x0_after_ptrace(regs);
 	}
 
 	/* Do the secure computing after ptrace; failures should be fast. */
 	if (secure_computing() == -1)
 		return NO_SYSCALL;
 
+	/*
+	 * Ensure tracer changes to x0 during seccomp ptrace exit
+	 * processing (SECCOMP_RET_TRACE) are visible to tracepoints and
+	 * audit.
+	 */
+	update_syscall_orig_x0_after_ptrace(regs);
+
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
 		trace_sys_enter(regs, regs->syscallno);
 


