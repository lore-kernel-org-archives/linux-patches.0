Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E03F2D0C8F;
	Mon, 17 Aug 2026 15:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979492; cv=none; b=K2K7IaWLc/25RKEOJQYtdta/AgMyvdjkD48AIMHhLLwetIC9sRw0D1VryLf4mfMFvDGd0sJjukPIBBPPkSMkfBVvN0DiSQNHBnfB5iagBIUaBYIyQ7iGUhFQokHtoKgEq7aB1Ul4ns0+dAsMFkN6JJ3UmpOVImvtKJWlS+WtdNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979492; c=relaxed/simple;
	bh=Q+Et1qgcGPqaaOA7vYlfx3JkfbJ/Ahn4PjKNoAxHY3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKpZu+rhhiv9D8WkZM6k7me1jvaM6Y2s231PMhZ526PkWq3UtYzVjHuAhSzn5KAVfid2BrPLJt4et/15NicACOGS6ImQYmjs7lOvxD/K017Vy7mTTmfV9091Cix0qVNjIHT1PoKMI0gCaMBAG+sJD1QBoKRatd4aIzebyq9snWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mF1dJGar; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mF1dJGar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3411F000E9;
	Mon, 17 Aug 2026 15:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979491;
	bh=bCdu3hvBKNwUfkNXobOBkjwZ1asmaYtQEGB0wroM0U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mF1dJGar5t8QefiNVjiHE7ycUi9h0Lx4UcIfPYVpUgxkEYhObPCAfxNSElCxirIEP
	 pj0ZOo+8qTEPummmSHvWRKHczPfpCdJUY3P9Yt31HgInZFoBOpjuACZ0bkzM3vjIq1
	 o5LZJCWUwwDjccwKTD1nZuaRVWRJCpbSlUya5mcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 245/609] Revert "arm64: syscall: Ensure saved x0 is kept in-sync with tracer updates"
Date: Mon, 17 Aug 2026 15:29:01 +0200
Message-ID: <20260817132552.282751359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2140,21 +2140,6 @@ static void report_syscall(struct pt_reg
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
@@ -2163,26 +2148,12 @@ int syscall_trace_enter(struct pt_regs *
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
 


