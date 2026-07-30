Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E8E443A89;
	Thu, 30 Jul 2026 16:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427244; cv=none; b=P93Cd6sRWjCrrYRxWbOMiAQqmmTB4xN8M0I8eUL719IZWE7dySKD97ra52zlLf7jSZy7AQ57Vu+F+4JAEZ4XqVaZv4fnPw/iTMtj8sEEROKDUJHk4DjP0W2dV/u0tUEEcIevdjUFHN7PU8X0QFsaRoVfoDacyGlVadeYD9ohZNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427244; c=relaxed/simple;
	bh=ve110+xJGkcTBDDgVLkz78tbPsFJt6F3C0gVUUn+XeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFHo87PmXpecToZqYbD1YRGEV1UUYGWu//g2njOGB53dG6LNdOrNgle0LQVbR5sFqHI6UvsMmT2LqyB8zfvvo9ZhiKTESt8CP243K0p7mOQW85RJ4Wor7AoP5iFI74yH6l3NxOKnURzpLOl+2i6gGAeIlXJkg0mm1F+EFlfJ25k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQYltMMs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQYltMMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D010F1F000E9;
	Thu, 30 Jul 2026 16:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427243;
	bh=M3QQPHUC3D7l7L+QpiSqYP/P/BPkcKMg2RxRoMYSTHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQYltMMs9qqfPeSCrs7DF//AjQEKMHuaq0lBOn+hBDx4l2o6Qi1MZ2iygUsTfekl7
	 Wz6OQkvyqYRBB95TDGTW/COgmB4w6KO6Lyz9FZDS5gvrpNueqM/ot6PI7ktq1KPAXr
	 Y+rXMm73eghMfediDQWAY8S8B2UynKz+R56LH8TA=
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
Subject: [PATCH 6.6 085/484] sched/vtime: Get rid of generic vtime_task_switch() implementation
Date: Thu, 30 Jul 2026 16:09:42 +0200
Message-ID: <20260730141425.295117940@linuxfoundation.org>
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
index 4961fb38e4385f..aff858ca99c05d 100644
--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@ -32,23 +32,10 @@
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
index dda35c404a6761..7fce6adb6f05fd 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -354,6 +354,28 @@ void vtime_flush(struct task_struct *tsk)
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
index b453f8a6a7c764..4feef0d4e4494d 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -424,19 +424,6 @@ static inline void irqtime_account_process_tick(struct task_struct *p, int user_
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



