Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE0040FDB9;
	Mon, 17 Aug 2026 14:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977058; cv=none; b=pBAm/HccD4UZSGZ1X4EKZX0wHzqKUQQeDaM3nj/iphHl1VrRwODimZ21a0kbjZfqhWbCbrRZNvgyou9FbyNHO5WgK72rpCoJzVydDsQyUCOk3N2Eo1rFRgh1eZlY/UsEoo++NaIwESHsNDYbmGWhShHeJj1EdgPt2DJnq3V5PG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977058; c=relaxed/simple;
	bh=V6srfxwd7E1AwnDs5bg866z9G3HKYW5/cAVZzxqSxIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNuTBy2tAsiFqYEvDrl3KLgFGdgB9sQ2f2tdmL+nGgUYaZCOJZid0WQalzTvcskMYBIZTrf4EJk+OLHQJCwyl8LGMNk5H2eBj8Un40UBilDzfIfMcoLeokiDPtU0aEYV4Z4Utk/8tTzOXVBQpsZtnnTuGIi++7g5Decv/MIlHpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mADMHXj0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mADMHXj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676161F000E9;
	Mon, 17 Aug 2026 14:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977056;
	bh=969gxZf3ZNw6puF4u/UzatWq003JpjCIraBtjmIPgz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mADMHXj0YCiHIBmWoBiV9glco8Flcp21XSirihxyBJYDZ9Wq7yBPKPt3CA1OH1Py3
	 ex/FGUfygsRTB3gDWIfpl60uJPXDr03sOdoxAAQ798U8g2jVjL0GUFEzVRJ79GG/dn
	 7ZjDd1jivgDoQn3TeNgeYJ7aBR43XFwye7QHEHFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.15 198/456] Revert "arm64: syscall: Ensure saved x0 is kept in-sync with tracer updates"
Date: Mon, 17 Aug 2026 15:29:48 +0200
Message-ID: <20260817132547.866856774@linuxfoundation.org>
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
@@ -1844,21 +1844,6 @@ static void tracehook_report_syscall(str
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
 	unsigned long flags = READ_ONCE(current_thread_info()->flags);
@@ -1867,26 +1852,12 @@ int syscall_trace_enter(struct pt_regs *
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
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
 


