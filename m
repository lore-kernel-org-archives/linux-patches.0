Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9041D89F5;
	Tue, 15 Oct 2024 11:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993273; cv=none; b=QzGVdGukH8fYUe+rwwkFKOtOOJf8fya+880Lp5H8WjDJrMQVz0f9FBhhLM8106CJ7szEFWIuzKI9SpXBodW7JksNw33caODO0Lz8WLzzTZ2kPwmJd4lv6elRCewlE0Lle2fJwIhkNKRSO26Vi6y939fDnzkRBCOnghofyfFtOwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993273; c=relaxed/simple;
	bh=IuMryy82ityy+y2gYnkxMLPoqWMc/MmLFk7ryYs3AlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D09+WC89AlaC09RrTXvsDHITrwFBSE+FraZg1FRGpUKZGYPbW81vXx+F6/VShfYFLsWA9chnwLWZss+leHPZ9SYwwYwoXm1pAhEjDcWUZuosd3gWhSrwxAKBt+D2wnO0hBZHvkWb1CIRClnmjl4xP78f9ZVMNa+ttIYDG1OAKX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUjb7Hl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUjb7Hl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00838C4CEC6;
	Tue, 15 Oct 2024 11:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993273;
	bh=IuMryy82ityy+y2gYnkxMLPoqWMc/MmLFk7ryYs3AlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUjb7Hl8Wope3l4HvK6zw1bJfM/Ui5ot/WIHIujF3KVDX7E1/doZJFAZrUpuGFUyt
	 bka9r7X9q2wrUOHg9M5iMnBoC0bJnEecoDdMTGn04GLGJBPlyzFmNXLgcbqApvc6dY
	 Tcq05DzHelIuPFekJut+tBTIDKB1vlqNlNPSFDqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Vyukov <dvyukov@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alexander Potapenko <glider@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 363/691] x86/entry: Remove unwanted instrumentation in common_interrupt()
Date: Tue, 15 Oct 2024 13:25:11 +0200
Message-ID: <20241015112454.753187274@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dmitry Vyukov <dvyukov@google.com>

[ Upstream commit 477d81a1c47a1b79b9c08fc92b5dea3c5143800b ]

common_interrupt() and related variants call kvm_set_cpu_l1tf_flush_l1d(),
which is neither marked noinstr nor __always_inline.

So compiler puts it out of line and adds instrumentation to it.  Since the
call is inside of instrumentation_begin/end(), objtool does not warn about
it.

The manifestation is that KCOV produces spurious coverage in
kvm_set_cpu_l1tf_flush_l1d() in random places because the call happens when
preempt count is not yet updated to say that the kernel is in an interrupt.

Mark kvm_set_cpu_l1tf_flush_l1d() as __always_inline and move it out of the
instrumentation_begin/end() section.  It only calls __this_cpu_write()
which is already safe to call in noinstr contexts.

Fixes: 6368558c3710 ("x86/entry: Provide IDTENTRY_SYSVEC")
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/3f9a1de9e415fcb53d07dc9e19fa8481bb021b1b.1718092070.git.dvyukov@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/hardirq.h  | 8 ++++++--
 arch/x86/include/asm/idtentry.h | 6 +++---
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 275e7fd20310f..a18df4191699c 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -62,7 +62,11 @@ extern u64 arch_irq_stat(void);
 
 
 #if IS_ENABLED(CONFIG_KVM_INTEL)
-static inline void kvm_set_cpu_l1tf_flush_l1d(void)
+/*
+ * This function is called from noinstr interrupt contexts
+ * and must be inlined to not get instrumentation.
+ */
+static __always_inline void kvm_set_cpu_l1tf_flush_l1d(void)
 {
 	__this_cpu_write(irq_stat.kvm_cpu_l1tf_flush_l1d, 1);
 }
@@ -77,7 +81,7 @@ static __always_inline bool kvm_get_cpu_l1tf_flush_l1d(void)
 	return __this_cpu_read(irq_stat.kvm_cpu_l1tf_flush_l1d);
 }
 #else /* !IS_ENABLED(CONFIG_KVM_INTEL) */
-static inline void kvm_set_cpu_l1tf_flush_l1d(void) { }
+static __always_inline void kvm_set_cpu_l1tf_flush_l1d(void) { }
 #endif /* IS_ENABLED(CONFIG_KVM_INTEL) */
 
 #endif /* _ASM_X86_HARDIRQ_H */
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index a65575136255b..151cd0b5f4306 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -210,8 +210,8 @@ __visible noinstr void func(struct pt_regs *regs,			\
 	irqentry_state_t state = irqentry_enter(regs);			\
 	u32 vector = (u32)(u8)error_code;				\
 									\
+	kvm_set_cpu_l1tf_flush_l1d();                                   \
 	instrumentation_begin();					\
-	kvm_set_cpu_l1tf_flush_l1d();					\
 	run_irq_on_irqstack_cond(__##func, regs, vector);		\
 	instrumentation_end();						\
 	irqentry_exit(regs, state);					\
@@ -248,7 +248,6 @@ static void __##func(struct pt_regs *regs);				\
 									\
 static __always_inline void instr_##func(struct pt_regs *regs)		\
 {									\
-	kvm_set_cpu_l1tf_flush_l1d();					\
 	run_sysvec_on_irqstack_cond(__##func, regs);			\
 }									\
 									\
@@ -256,6 +255,7 @@ __visible noinstr void func(struct pt_regs *regs)			\
 {									\
 	irqentry_state_t state = irqentry_enter(regs);			\
 									\
+	kvm_set_cpu_l1tf_flush_l1d();                                   \
 	instrumentation_begin();					\
 	instr_##func (regs);						\
 	instrumentation_end();						\
@@ -286,7 +286,6 @@ static __always_inline void __##func(struct pt_regs *regs);		\
 static __always_inline void instr_##func(struct pt_regs *regs)		\
 {									\
 	__irq_enter_raw();						\
-	kvm_set_cpu_l1tf_flush_l1d();					\
 	__##func (regs);						\
 	__irq_exit_raw();						\
 }									\
@@ -295,6 +294,7 @@ __visible noinstr void func(struct pt_regs *regs)			\
 {									\
 	irqentry_state_t state = irqentry_enter(regs);			\
 									\
+	kvm_set_cpu_l1tf_flush_l1d();                                   \
 	instrumentation_begin();					\
 	instr_##func (regs);						\
 	instrumentation_end();						\
-- 
2.43.0



