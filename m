Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE79828B4FA;
	Sat, 12 Sep 2026 08:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201389; cv=none; b=okyB9Op1gQ1KBvZRsTpexAzTFr1dQXorepOC9GjvRgtmgb+lnzbguHSMnFcR2ouOP+6ckMwSThbwx/i6xkv5Wp6Yd5FhlIR9RPQh1xQ8flYNOLMsJ8DalHEiNSmH1neYo/NZIOipvE73OXegv3ipKOz7rxhYJ14EGsW3qkY8fX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201389; c=relaxed/simple;
	bh=bJhE6iwP5obuRQyLX9UZZ6A9dj2G7IJutUX0oz0ZGe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O2QnDInG0TTrrnSNXpn4y40rVjhXynq/TCFNG9laD5El4s0znDHoirUmgLdcmPX5rpwauM8clcOeudE9iiH92bl7fOA+cN9ciksGRKRIdzrnQoSuB1AJTO3qBVtlAzh94FgxUFN4oZayTA8v508CdU7uQUobsjP6qFzbYpNfS+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBsrTmN0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBsrTmN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314B71F000FF;
	Sat, 12 Sep 2026 08:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201388;
	bh=iIJtmospa9PH4ztbc7CVzqynjTgol3VgPTEMfZBMGAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jBsrTmN0YXwlWqnwcFRZunGx/XIVUPbeHdU6DTd0f3EnJ4xIfcS/+uHa13xwjKUl7
	 F0uFhgOzD48+vGTFJx74mKJbtvK8pcxGBUhbbBTHM9nG4iuvZmZqeLWD+zR3IZXNIJ
	 Clu5tNO3kIcShdzu1l4uuL1h0QHjauUphak3+/m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
	"Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0986/1815] powerpc/syscall: Fix syscall skip handling for seccomp and ptrace
Date: Sat, 12 Sep 2026 08:45:36 +0200
Message-ID: <20260912065712.141526542@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>

[ Upstream commit 69cb2be898be6d5826cacd1a628f6945a24480b6 ]

After enabling GENERIC_ENTRY on PowerPC, syscall_enter_from_user_mode()
returns -1 as a sentinel to signal that seccomp or ptrace has intercepted
the syscall and already set a return value via syscall_set_return_value().
system_call_exception() was not handling this sentinel, and since -1UL
is >= NR_syscalls, the code fell into the out-of-range path and returned
-ENOSYS, overwriting the errno already placed in regs->gpr[3].

The naive fix of checking r0 == -1L before the NR_syscalls bounds check
is ambiguous: a user legitimately calling syscall(-1) also produces r0 ==
-1L, and a tracer intercepting such a call would have its injected return
value silently discarded.

Fix this by introducing a thread flag that is set whenever
syscall_set_return_value() explicitly updates the return value. In
system_call_exception(), check and clear this flag before dispatching
the syscall, and return the preset value directly when it is present.
This ensures that an explicitly supplied return value always suppresses
syscall execution, regardless of the syscall number.

This handles all seccomp actions correctly:

  - SECCOMP_RET_ERRNO, SECCOMP_RET_TRACE (no tracer), SECCOMP_RET_USER_NOTIF:
    all call syscall_set_return_value(), flag is set, injected value returned.
  - SECCOMP_RET_TRAP, SECCOMP_RET_KILL: call syscall_rollback() and deliver
    a signal; flag is not set, but the process is dying so the return value
    is irrelevant.

The fix covers both ppc32 and ppc64 with no #ifdefs.

Fixes: bee25f97ad24 ("powerpc: Enable GENERIC_ENTRY feature")
Reported-by: Michal Suchánek <msuchanek@suse.de>
Closes: https://lore.kernel.org/all/ajpp-_XnbF3UTM_E@kunlun.suse.cz/
Tested-by: Michal Suchánek <msuchanek@suse.de>
Reviewed-by: Michal Suchánek <msuchanek@suse.de>
Signed-off-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260731081521.1852133-1-mkchauras@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/syscall.h     | 6 ++++++
 arch/powerpc/include/asm/thread_info.h | 1 +
 arch/powerpc/kernel/syscall.c          | 3 +++
 3 files changed, 10 insertions(+)

diff --git a/arch/powerpc/include/asm/syscall.h b/arch/powerpc/include/asm/syscall.h
index 834fcc4f7b543..19d1739af0b77 100644
--- a/arch/powerpc/include/asm/syscall.h
+++ b/arch/powerpc/include/asm/syscall.h
@@ -98,6 +98,12 @@ static inline void syscall_set_return_value(struct task_struct *task,
 			regs->gpr[3] = val;
 		}
 	}
+	/*
+	 * Mark that a return value has been explicitly set by seccomp or
+	 * ptrace so that system_call_exception() can skip the syscall
+	 * unconditionally, even when the user requested syscall(-1).
+	 */
+	set_thread_flag(TIF_SYSCALL_RET);
 }
 
 static inline void syscall_get_arguments(struct task_struct *task,
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index 0487e94d34169..1e069a2e7ce87 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -120,6 +120,7 @@ void arch_setup_new_exec(void);
 #endif
 #define TIF_POLLING_NRFLAG	19	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_32BIT		20	/* 32 bit binary */
+#define TIF_SYSCALL_RET		21	/* syscall error value set */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
diff --git a/arch/powerpc/kernel/syscall.c b/arch/powerpc/kernel/syscall.c
index a9da2af6efa87..9d1b29f44ea0d 100644
--- a/arch/powerpc/kernel/syscall.c
+++ b/arch/powerpc/kernel/syscall.c
@@ -22,6 +22,9 @@ notrace long system_call_exception(struct pt_regs *regs, unsigned long r0)
 	add_random_kstack_offset();
 	r0 = syscall_enter_from_user_mode(regs, r0);
 
+	if (unlikely(test_and_clear_thread_flag(TIF_SYSCALL_RET)))
+		return syscall_get_error(current, regs);
+
 	if (unlikely(r0 >= NR_syscalls)) {
 		if (unlikely(trap_is_unsupported_scv(regs))) {
 			/* Unsupported scv vector */
-- 
2.53.0



