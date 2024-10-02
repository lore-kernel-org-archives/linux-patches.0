Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAD91D07BC;
	Wed,  2 Oct 2024 14:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878914; cv=none; b=FVePrqnobVbMnxII5elszjmGkFapNlAm4rLeACAgWDABq8y/t4HxMe4YOF3At98kYKDiCAFvrqEPT7/WhPEQxuNWq9cdbjLTlpFxjESCe2BdZf39pC3EvSkLkF0TdiL/PIHDAy6wViCYz35mjZAJwXpGk6e1eEJ5reEWFK2Ce5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878914; c=relaxed/simple;
	bh=aB/E+dh0CZ2m+HEmMuk0FaKPieCeY/ik+Bsy9KdjKxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWQ3QgWY+elQtjTZNxMULnRI5sxQ6WMYkI224l5cRvebBmkkfslcKL//uD/dImTpID+qzOzNRP1f0NoHO0b7c9daKotxsioAs8vUkap4cIQr1l479q+x1LpRF8g2zg8tNGk03R6WY3GP7Pyq+vXGQoHFc11Uru6C6hmHcrx2Mco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6EkyCGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6EkyCGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15664C4CECD;
	Wed,  2 Oct 2024 14:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878914;
	bh=aB/E+dh0CZ2m+HEmMuk0FaKPieCeY/ik+Bsy9KdjKxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A6EkyCGZtfpjR6ifo7bpP0IuqCLUcVJ1UlP8rSb6E2pmFrYgpyPwg3z5ORJ3/S9rb
	 dY7B/unaydWGfX9YppMs61LdhnIJWKgW233vcqqXc966zsfoujkpNWtwaN7x7N3/Cn
	 6Y3LfV9rD7lhi9InJy0A4t2pMVioo5Q8u4e9GucI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Vyukov <dvyukov@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alexander Potapenko <glider@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.10 544/634] x86/entry: Remove unwanted instrumentation in common_interrupt()
Date: Wed,  2 Oct 2024 15:00:44 +0200
Message-ID: <20241002125832.582442204@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Vyukov <dvyukov@google.com>

commit 477d81a1c47a1b79b9c08fc92b5dea3c5143800b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/hardirq.h  |    8 ++++++--
 arch/x86/include/asm/idtentry.h |    6 +++---
 2 files changed, 9 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -69,7 +69,11 @@ extern u64 arch_irq_stat(void);
 #define local_softirq_pending_ref       pcpu_hot.softirq_pending
 
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
@@ -84,7 +88,7 @@ static __always_inline bool kvm_get_cpu_
 	return __this_cpu_read(irq_stat.kvm_cpu_l1tf_flush_l1d);
 }
 #else /* !IS_ENABLED(CONFIG_KVM_INTEL) */
-static inline void kvm_set_cpu_l1tf_flush_l1d(void) { }
+static __always_inline void kvm_set_cpu_l1tf_flush_l1d(void) { }
 #endif /* IS_ENABLED(CONFIG_KVM_INTEL) */
 
 #endif /* _ASM_X86_HARDIRQ_H */
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -212,8 +212,8 @@ __visible noinstr void func(struct pt_re
 	irqentry_state_t state = irqentry_enter(regs);			\
 	u32 vector = (u32)(u8)error_code;				\
 									\
+	kvm_set_cpu_l1tf_flush_l1d();                                   \
 	instrumentation_begin();					\
-	kvm_set_cpu_l1tf_flush_l1d();					\
 	run_irq_on_irqstack_cond(__##func, regs, vector);		\
 	instrumentation_end();						\
 	irqentry_exit(regs, state);					\
@@ -250,7 +250,6 @@ static void __##func(struct pt_regs *reg
 									\
 static __always_inline void instr_##func(struct pt_regs *regs)		\
 {									\
-	kvm_set_cpu_l1tf_flush_l1d();					\
 	run_sysvec_on_irqstack_cond(__##func, regs);			\
 }									\
 									\
@@ -258,6 +257,7 @@ __visible noinstr void func(struct pt_re
 {									\
 	irqentry_state_t state = irqentry_enter(regs);			\
 									\
+	kvm_set_cpu_l1tf_flush_l1d();                                   \
 	instrumentation_begin();					\
 	instr_##func (regs);						\
 	instrumentation_end();						\
@@ -288,7 +288,6 @@ static __always_inline void __##func(str
 static __always_inline void instr_##func(struct pt_regs *regs)		\
 {									\
 	__irq_enter_raw();						\
-	kvm_set_cpu_l1tf_flush_l1d();					\
 	__##func (regs);						\
 	__irq_exit_raw();						\
 }									\
@@ -297,6 +296,7 @@ __visible noinstr void func(struct pt_re
 {									\
 	irqentry_state_t state = irqentry_enter(regs);			\
 									\
+	kvm_set_cpu_l1tf_flush_l1d();                                   \
 	instrumentation_begin();					\
 	instr_##func (regs);						\
 	instrumentation_end();						\


