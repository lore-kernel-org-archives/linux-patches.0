Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59274175A99;
	Mon, 17 Aug 2026 14:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976635; cv=none; b=IpZU3AVwH02/GXg9tTVjj/FgmNREGS9aTEh4wF7WQCGASZIN0wDlPovlWSRwBFXrmDTvgbZsw0drOXWfRKB0hIhoA1oXIN7nP6eiPt886DquBsbkBK/q7fzPE7ij45LYcfPyHTKEB5lwzTgZ30Cy14u6MoOT3UHBTwgqKJe/E20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976635; c=relaxed/simple;
	bh=du05Q/L3GQk16tfwaB2svk/N9yWtYSCYoZcvyrNi7io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3yBwPnU2gE2/UBINJrctMJP/fIdq43dwJJ3h1l7Z7czGuffegrV/2fcymoxVrslnU5/i0UFFDLwmyxKUf09obsUFzMoCvV3FuflL89dM+ODElgOu+6Tv9XH5WXLN3eIB2Qe9VoODYM0E4HVUeDQA6RSLb7uBDLMOblsba7louU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zy4BQSz3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zy4BQSz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71EC1F000E9;
	Mon, 17 Aug 2026 14:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976634;
	bh=2beF2A60ztJ0AfLr/y2oox16Xyq/sltvFdDRY6lqRH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zy4BQSz3mutkRQCtrScBhpD1kL0D7WZsHNNdZqZt0zJRPWdkzTnnuc7ruQhs+FkK3
	 iXkbePL89CWcx+Zdj76p7lHrd1CfUl8628uDtRFbvJCsp196xxDpg8wgmnNUb6ZNUF
	 FFyUT/0eBxHBdaOWpcblSudcvLXwX5RRYzTZSeIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Ingo Molnar <mingo@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/456] sched/vtime: Get rid of generic vtime_task_switch() implementation
Date: Mon, 17 Aug 2026 15:27:20 +0200
Message-ID: <20260817132541.992143810@linuxfoundation.org>
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

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 89d6910cc562ab34d1f1c08f3cf0a9700b8bf2c4 ]

The generic vtime_task_switch() implementation gets built only
if __ARCH_HAS_VTIME_TASK_SWITCH is not defined, but requires an
architecture to implement arch_vtime_task_switch() callback at
the same time, which is confusing.

Further, arch_vtime_task_switch() is implemented for 32-bit PowerPC
architecture only and vtime_task_switch() generic variant is rather
superfluous.

Simplify the whole vtime_task_switch() wiring by moving the existing
generic implementation to PowerPC.

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/2cb6e3caada93623f6d4f78ad938ac6cd0e2fda8.1712760275.git.agordeev@linux.ibm.com
Stable-dep-of: c1c1ffa490fc ("powerpc/vtime: Initialize starttime at boot for native accounting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/cputime.h | 13 -------------
 arch/powerpc/kernel/time.c         | 22 ++++++++++++++++++++++
 kernel/sched/cputime.c             | 13 -------------
 3 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/include/asm/cputime.h b/arch/powerpc/include/asm/cputime.h
index a23356c05af193..2e5cc3abd92df5 100644
--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@ -31,23 +31,10 @@
 #ifdef CONFIG_PPC64
 #define get_accounting(tsk)	(&get_paca()->accounting)
 #define raw_get_accounting(tsk)	(&local_paca->accounting)
-static inline void arch_vtime_task_switch(struct task_struct *tsk) { }
 
 #else
 #define get_accounting(tsk)	(&task_thread_info(tsk)->accounting)
 #define raw_get_accounting(tsk)	get_accounting(tsk)
-/*
- * Called from the context switch with interrupts disabled, to charge all
- * accumulated times to the current process, and to prepare accounting on
- * the next process.
- */
-static inline void arch_vtime_task_switch(struct task_struct *prev)
-{
-	struct cpu_accounting_data *acct = get_accounting(current);
-	struct cpu_accounting_data *acct0 = get_accounting(prev);
-
-	acct->starttime = acct0->starttime;
-}
 #endif
 
 /*
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index d0e59f427fd6f1..65235323bee49c 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -429,6 +429,28 @@ void vtime_flush(struct task_struct *tsk)
 	acct->hardirq_time = 0;
 	acct->softirq_time = 0;
 }
+
+/*
+ * Called from the context switch with interrupts disabled, to charge all
+ * accumulated times to the current process, and to prepare accounting on
+ * the next process.
+ */
+void vtime_task_switch(struct task_struct *prev)
+{
+	if (is_idle_task(prev))
+		vtime_account_idle(prev);
+	else
+		vtime_account_kernel(prev);
+
+	vtime_flush(prev);
+
+	if (!IS_ENABLED(CONFIG_PPC64)) {
+		struct cpu_accounting_data *acct = get_accounting(current);
+		struct cpu_accounting_data *acct0 = get_accounting(prev);
+
+		acct->starttime = acct0->starttime;
+	}
+}
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
 void __no_kcsan __delay(unsigned long loops)
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index e3022598f7b02b..d71c4817996b32 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -406,19 +406,6 @@ static inline void irqtime_account_process_tick(struct task_struct *p, int user_
  */
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 
-# ifndef __ARCH_HAS_VTIME_TASK_SWITCH
-void vtime_task_switch(struct task_struct *prev)
-{
-	if (is_idle_task(prev))
-		vtime_account_idle(prev);
-	else
-		vtime_account_kernel(prev);
-
-	vtime_flush(prev);
-	arch_vtime_task_switch(prev);
-}
-# endif
-
 void vtime_account_irq(struct task_struct *tsk, unsigned int offset)
 {
 	unsigned int pc = irq_count() - offset;
-- 
2.53.0



