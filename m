Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DCF420484;
	Mon, 17 Aug 2026 14:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977055; cv=none; b=VIZDkukDL9+S6Pd0+5OlJbQejn6DQqzQaW1tIWx160iDoTubdOuR6ag0YVXvLfJ+DAQ0axZD3pF5goKlQmWWsGU3TPbH6vAVhNjg8466TGBZUElFoOJE+vZsrfphym7b1lLJpIOQokWfKWrRDQQ2r1EC4HtUAeh8cpQ0+MNbDpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977055; c=relaxed/simple;
	bh=e1uFW3oJe9IZBSfhKG6TyHzlunpaN0QqzKtPkBJdWCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxuMBqeCoHQr2l5SFom5yGfuJDAzA9QYXxbcRgxqM0/VD86k8pQz1YWVYUSsjogQws91QnHqDh6In54yxVkp1jrhuaggCO7RbltO+GQLNUqX9XO6Le3pkv6JRFffITCJR2XvwNtdB1YQJ9uMIiYnO3pWpQ2Y5UzQNkhGslaDTOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08DYT2IA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08DYT2IA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B26D1F000E9;
	Mon, 17 Aug 2026 14:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977054;
	bh=v0B3FevwUesXUzCKVjKPImzmGpjdTGAYAYjRPHAWTD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=08DYT2IA1n86qd2qvrxK8lyxnjncDnBJN5ki7whr5PEEEwxHE7BFBTKFw2ESZ7XbH
	 JrZ9W3zQI9sBzvPsCsT+uEKhglBSBYW6iqAl5BHFR8+i35LVjFHJjt5a0biUM3jTuR
	 iFZMdZ34tp8BgeIDVIPyUbNcd3MLU3zLW3J/uc10=
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
Subject: [PATCH 5.15 197/456] arm64: syscall: Ensure saved x0 is kept in-sync with tracer updates
Date: Mon, 17 Aug 2026 15:29:47 +0200
Message-ID: <20260817132547.829858881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1844,6 +1844,21 @@ static void tracehook_report_syscall(str
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
 	unsigned long flags = READ_ONCE(current_thread_info()->flags);
@@ -1852,12 +1867,26 @@ int syscall_trace_enter(struct pt_regs *
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
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
 


