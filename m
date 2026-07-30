Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6077446BEE;
	Thu, 30 Jul 2026 16:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427802; cv=none; b=PF6Fd4s4V/KMEC3NlE2vnAOWs8dKA0du4Q3xWgDyHBczRn5VpKsJL1QyAe+Vr1sZu11+bb143lQOIYXl80tyTgScqVub9hQJjZpf8vtQiLy2GYzkL8M1wIWOD3kasX/yYELqDkCgxNPR2ifLetdfOiXoWP4Ds7C3bIBOOXQaXmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427802; c=relaxed/simple;
	bh=PDI2+7MwhNU2CZgyVzYZKO7On6teaitO+cVE9+ApiQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0hsje67MZina6Gk1ZYvtevVnNnUiFYpIgt0+pAJEMn5dlXEJCXjcR+ZZ8O/lqwDRdWJ13W+xzCwIzBLBDVoQs+fmDFVd9vWZHeRygntbuJ2bpH8MYq3K9eLrm+TJIQKEb2FpVASqd/EKVo7Zov1CoxXOrrlz0+z33AxvgkKeqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjdaNQZd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjdaNQZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A56D1F000E9;
	Thu, 30 Jul 2026 16:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427800;
	bh=gqXlVudsm4BAkavllgWXzJj4AwgGPXHN2inuAxt1IZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yjdaNQZdYJnA7I+2F57dHvmidmebkD1nuyiWuQwyvD8/otD5Dq0RicVQQ7ZCc10y+
	 0XtD8wIQ24EPR3vvg6ftpzsSP/Nn8BLNe1VxfvJfHwjUndP77EZq3hm41FXrMyttSY
	 gW55TtuzXCN1KgmlGDHh0yibdrF4sY7GnhZwjw+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 298/484] Revert "arm64: syscall: Ensure saved x0 is kept in-sync with tracer updates"
Date: Thu, 30 Jul 2026 16:13:15 +0200
Message-ID: <20260730141429.965458181@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

commit 26b483d52417253d88a3a01262ac85914a7aec8e upstream.

This reverts commit e057b94772328221405b067c3a85fe479b915dc8.

Sashiko points out that updating 'orig_x0' after secure_computing()
has returned is too late to handle the case where a seccomp filter is
re-evaluated after initially returning SECCOMP_RET_TRACE. This means
that a tracer can manipulate the first argument of the syscall behind
seccomp's back.

For now, revert the initial fix and we'll have another crack at it soon.
Since the incorrect fix was cc'd to stable, do the same here with an
appropriate fixes tag.

Cc: stable@vger.kernel.org
Fixes: e057b9477232 ("arm64: syscall: Ensure saved x0 is kept in-sync with tracer updates")
Link: https://sashiko.dev/#/patchset/20260716120640.6590-1-will@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/ptrace.c |   29 -----------------------------
 1 file changed, 29 deletions(-)

--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -2191,21 +2191,6 @@ static void report_syscall(struct pt_reg
 	}
 }
 
-static void update_syscall_orig_x0_after_ptrace(struct pt_regs *regs)
-{
-	/*
-	 * Keep orig_x0 authoritative so that seccomp (via
-	 * syscall_get_arguments()), audit and the restart path all see the same
-	 * first argument the syscall is dispatched with, even if it has been
-	 * updated by a tracer. Skip this for NO_SYSCALL (set either by the user
-	 * or the tracer), as regs[0] holds the return value (see the comment in
-	 * el0_svc_common()) and can be unwound using syscall_rollback().
-	 * For compat tasks, orig_r0 is provided directly through GPR index 17.
-	 */
-	if (!is_compat_task() && regs->syscallno != NO_SYSCALL)
-		regs->orig_x0 = regs->regs[0];
-}
-
 int syscall_trace_enter(struct pt_regs *regs)
 {
 	unsigned long flags = read_thread_flags();
@@ -2214,26 +2199,12 @@ int syscall_trace_enter(struct pt_regs *
 		report_syscall(regs, PTRACE_SYSCALL_ENTER);
 		if (flags & _TIF_SYSCALL_EMU)
 			return NO_SYSCALL;
-
-		/*
-		 * Ensure ptrace changes to x0 during a regular
-		 * syscall-enter-stop (PTRACE_SYSCALL) are visible to
-		 * subsequent seccomp checks, tracepoints and audit.
-		 */
-		update_syscall_orig_x0_after_ptrace(regs);
 	}
 
 	/* Do the secure computing after ptrace; failures should be fast. */
 	if (secure_computing() == -1)
 		return NO_SYSCALL;
 
-	/*
-	 * Ensure tracer changes to x0 during seccomp ptrace exit
-	 * processing (SECCOMP_RET_TRACE) are visible to tracepoints and
-	 * audit.
-	 */
-	update_syscall_orig_x0_after_ptrace(regs);
-
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
 		trace_sys_enter(regs, regs->syscallno);
 


