Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA66028EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51339C433EF;
	Mon, 30 Jan 2023 14:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087400;
	bh=PWYosrf9Kd/gdZZn1RErsxTdT2IXrtH28PlKz6Z4y4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qg0I+WKrrgxZpUKtvtNW/ucjklc4cFzuRBIUsO/4FfzhVZTnRJp+bNTtW/EQdNeV5
	 cRYBjCnizDTBh/zkF0uhDviJKvonvFt4w1IIaGoaDD3Mw9KyouO8h6Qq0PImJqygkV
	 kvf4+JI1+iGvN/6tzt9pYDDNuBgegMaJaNFMv69U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 195/313] arm64: efi: Avoid workqueue to check whether EFI runtime is live
Date: Mon, 30 Jan 2023 14:50:30 +0100
Message-Id: <20230130134345.780635162@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 8a9a1a18731eb123e35f48176380a18b9782845e ]

Comparing current_work() against efi_rts_work.work is sufficient to
decide whether current is currently running EFI runtime services code at
any level in its call stack.

However, there are other potential users of the EFI runtime stack, such
as the ACPI subsystem, which may invoke efi_call_virt_pointer()
directly, and so any sync exceptions occurring in firmware during those
calls are currently misidentified.

So instead, let's check whether the stashed value of the thread stack
pointer points into current's thread stack. This can only be the case if
current was interrupted while running EFI runtime code. Note that this
implies that we should clear the stashed value after switching back, to
avoid false positives.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/efi.h       | 9 +++++++++
 arch/arm64/kernel/efi-rt-wrapper.S | 6 ++++++
 arch/arm64/kernel/efi.c            | 3 ++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 0edaf8e385b8..b13c22046de5 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -48,8 +48,17 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 })
 
 extern spinlock_t efi_rt_lock;
+extern u64 *efi_rt_stack_top;
 efi_status_t __efi_rt_asm_wrapper(void *, const char *, ...);
 
+/*
+ * efi_rt_stack_top[-1] contains the value the stack pointer had before
+ * switching to the EFI runtime stack.
+ */
+#define current_in_efi()						\
+	(!preemptible() && efi_rt_stack_top != NULL &&			\
+	 on_task_stack(current, READ_ONCE(efi_rt_stack_top[-1]), 1))
+
 #define ARCH_EFI_IRQ_FLAGS_MASK (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
 
 /*
diff --git a/arch/arm64/kernel/efi-rt-wrapper.S b/arch/arm64/kernel/efi-rt-wrapper.S
index d872d18101d8..e8ae803662cf 100644
--- a/arch/arm64/kernel/efi-rt-wrapper.S
+++ b/arch/arm64/kernel/efi-rt-wrapper.S
@@ -46,7 +46,10 @@ SYM_FUNC_START(__efi_rt_asm_wrapper)
 	mov	x4, x6
 	blr	x8
 
+	mov	x16, sp
 	mov	sp, x29
+	str	xzr, [x16, #8]			// clear recorded task SP value
+
 	ldp	x1, x2, [sp, #16]
 	cmp	x2, x18
 	ldp	x29, x30, [sp], #112
@@ -71,6 +74,9 @@ SYM_FUNC_END(__efi_rt_asm_wrapper)
 SYM_CODE_START(__efi_rt_asm_recover)
 	mov	sp, x30
 
+	ldr_l	x16, efi_rt_stack_top		// clear recorded task SP value
+	str	xzr, [x16, #-8]
+
 	ldp	x19, x20, [sp, #32]
 	ldp	x21, x22, [sp, #48]
 	ldp	x23, x24, [sp, #64]
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index fab05de2e12d..b273900f4566 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 
 #include <asm/efi.h>
+#include <asm/stacktrace.h>
 
 static bool region_is_misaligned(const efi_memory_desc_t *md)
 {
@@ -154,7 +155,7 @@ asmlinkage efi_status_t __efi_rt_asm_recover(void);
 bool efi_runtime_fixup_exception(struct pt_regs *regs, const char *msg)
 {
 	 /* Check whether the exception occurred while running the firmware */
-	if (current_work() != &efi_rts_work.work || regs->pc >= TASK_SIZE_64)
+	if (!current_in_efi() || regs->pc >= TASK_SIZE_64)
 		return false;
 
 	pr_err(FW_BUG "Unable to handle %s in EFI runtime service\n", msg);
-- 
2.39.0



