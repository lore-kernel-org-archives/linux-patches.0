Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0062F30DEA6;
	Sat, 12 Sep 2026 13:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219041; cv=none; b=AF3+x7wY9VVXBuXkJdjuAZ+ld/gOzXEoD37GQB6KA6IKa/a7hjkUdd4BPI9adAAbbOX2Uik4kDmJlQMIKAxXRiJkBv5dTzVG/4v824oKsiLfi4/Dc4fyIS3kLNgxQV1Wqn+Xo0NbZ2chfRXi47fyiAIRhA4aqfXzZQ4lWYCG1KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219041; c=relaxed/simple;
	bh=wHBgJic0BUdka5Gry5eONeYx2NR4SnhdiUpIhx/DZRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRVmJq/4r6nOOwEIv4pU/TUJ/cV0VbJzq2kDbL88UWNLHHWmqDCfBk/goDJRorOeyzJU/s3GxLvonOGoYUj1Z1yOiXL2Hq9qFDs9NsogIGeZVpV2BxnK9+P9hhaUH5NgoRoowQ6W86h2rUujYrZ6pOewe1f5ABNDaCflWbJw9Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFIoPK/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFIoPK/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA0D1F000FF;
	Sat, 12 Sep 2026 13:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219039;
	bh=6f/2tON0H0u1UVhzYc+Gv28xqdRjv3DFQ52f7NxGFxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pFIoPK/CnRwIVmw322iq3j7iJU08b7XktidajMQePUFwaKbHDO+PhrMn6aWqahZlm
	 bjUNCBgx8EAQE6fMCyf3nEjXH/Hhph4v/yiXM3G1oDWWTQr80R/n8JgZLOy7CSbtEn
	 scTNzrepyYdzVjJ8UoTkdDwHFiaCHVHv1YJn5cYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1269/1376] powerpc: Add preempt lazy support
Date: Sat, 12 Sep 2026 09:01:35 +0200
Message-ID: <20260912065635.822174041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Shrikanth Hegde <sshegde@linux.ibm.com>

[ Upstream commit 00199ed6f2ca6601b2c5856fac64132303d9437a ]

Define preempt lazy bit for Powerpc. Use bit 9 which is free and within
16 bit range of NEED_RESCHED, so compiler can issue single andi.

Since Powerpc doesn't use the generic entry/exit, add lazy check at exit
to user. CONFIG_PREEMPTION is defined for lazy/full/rt so use it for
return to kernel.

Ran a few benchmarks and db workload on Power10. Performance is close to
preempt=none/voluntary.

Since Powerpc systems can have large core count and large memory,
preempt lazy is going to be helpful in avoiding soft lockup issues.

Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Ankur Arora <ankur.a.arora@oracle.com>
Signed-off-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20241116192306.88217-2-sshegde@linux.ibm.com
Stable-dep-of: 902caade3cfd ("arm64: ptdump: Make note_page_flush() range aware")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig                   | 1 +
 arch/powerpc/include/asm/thread_info.h | 9 ++++++---
 arch/powerpc/kernel/interrupt.c        | 4 ++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index c7b420d6787ca..1bd5a9ff8505d 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -145,6 +145,7 @@ config PPC
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PHYS_TO_DMA
 	select ARCH_HAS_PMEM_API
+	select ARCH_HAS_PREEMPT_LAZY
 	select ARCH_HAS_PTE_DEVMAP		if PPC_BOOK3S_64
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index 6ebca2996f18f..2785c7462ebf7 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -103,6 +103,7 @@ void arch_setup_new_exec(void);
 #define TIF_PATCH_PENDING	6	/* pending live patching update */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SINGLESTEP		8	/* singlestepping active */
+#define TIF_NEED_RESCHED_LAZY	9       /* Scheduler driven lazy preemption */
 #define TIF_SECCOMP		10	/* secure computing */
 #define TIF_RESTOREALL		11	/* Restore all regs (implies NOERROR) */
 #define TIF_NOERROR		12	/* Force successful syscall return */
@@ -122,6 +123,7 @@ void arch_setup_new_exec(void);
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
+#define _TIF_NEED_RESCHED_LAZY	(1<<TIF_NEED_RESCHED_LAZY)
 #define _TIF_NOTIFY_SIGNAL	(1<<TIF_NOTIFY_SIGNAL)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_32BIT		(1<<TIF_32BIT)
@@ -142,9 +144,10 @@ void arch_setup_new_exec(void);
 				 _TIF_SYSCALL_EMU)
 
 #define _TIF_USER_WORK_MASK	(_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
-				 _TIF_NOTIFY_RESUME | _TIF_UPROBE | \
-				 _TIF_RESTORE_TM | _TIF_PATCH_PENDING | \
-				 _TIF_NOTIFY_SIGNAL)
+				 _TIF_NEED_RESCHED_LAZY | _TIF_NOTIFY_RESUME | \
+				 _TIF_UPROBE | _TIF_RESTORE_TM | \
+				 _TIF_PATCH_PENDING | _TIF_NOTIFY_SIGNAL)
+
 #define _TIF_PERSYSCALL_MASK	(_TIF_RESTOREALL|_TIF_NOERROR)
 
 /* Bits in local_flags */
diff --git a/arch/powerpc/kernel/interrupt.c b/arch/powerpc/kernel/interrupt.c
index af62ec974b970..8f4acc55407b0 100644
--- a/arch/powerpc/kernel/interrupt.c
+++ b/arch/powerpc/kernel/interrupt.c
@@ -185,7 +185,7 @@ interrupt_exit_user_prepare_main(unsigned long ret, struct pt_regs *regs)
 	ti_flags = read_thread_flags();
 	while (unlikely(ti_flags & (_TIF_USER_WORK_MASK & ~_TIF_RESTORE_TM))) {
 		local_irq_enable();
-		if (ti_flags & _TIF_NEED_RESCHED) {
+		if (ti_flags & (_TIF_NEED_RESCHED | _TIF_NEED_RESCHED_LAZY)) {
 			schedule();
 		} else {
 			/*
@@ -396,7 +396,7 @@ notrace unsigned long interrupt_exit_kernel_prepare(struct pt_regs *regs)
 		/* Returning to a kernel context with local irqs enabled. */
 		WARN_ON_ONCE(!(regs->msr & MSR_EE));
 again:
-		if (IS_ENABLED(CONFIG_PREEMPT)) {
+		if (IS_ENABLED(CONFIG_PREEMPTION)) {
 			/* Return to preemptible kernel context */
 			if (unlikely(read_thread_flags() & _TIF_NEED_RESCHED)) {
 				if (preempt_count() == 0)
-- 
2.53.0



