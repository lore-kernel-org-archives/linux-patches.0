Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ACB7464;
	Tue, 30 Apr 2024 10:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474777; cv=none; b=WMO9sv4OCivntCl8C5lM3Mi4NK/Ak0RUhwndPJ72fQImC+rccew62WIA1PHI0sxjIWO2dulXg3qOv3NHOnL4HyZRiZ4KdLUbbX7G86fNxz8qB0lKSdGiEcto9REO6NkP0CWjlkESN5kAh8KI92Y70UqJpSNLk/9oDn7Fpbgm6+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474777; c=relaxed/simple;
	bh=FKBbCRc0mKPRumS/Rn4HdxyJHlF9Ea2Woc7GOiPJarw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+HGFkyV7QAawxXntIgJtT61hzUk1kNGCE0zWug9tzRDdCdDNhT+N8eusYjWpYOL8UpVMHTVF2TiYbGwZ22Hz5ITMGhQTDEUXN9t0P3Ej6TRo82dV4R+8/17+2AxdFAxfzEKiV1nm+IDKHMsY5MxiKMJfWytVa3r5R8KCQn6Kg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQxCZptT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQxCZptT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B33C2BBFC;
	Tue, 30 Apr 2024 10:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474777;
	bh=FKBbCRc0mKPRumS/Rn4HdxyJHlF9Ea2Woc7GOiPJarw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQxCZptTltYfPcQf2jxx4/nr01ZP+NolAHZHme3lFwBgbrNtWC8unFbHjj9SzedWB
	 XhV/3xc3VZt4lA95kzpLu8Vgs7odKb1KPbWX4FlZE16mpsatqvIAWjzL+5s1U9D7nL
	 YzG5wfs5yHDgSjY75ChemsU4wP7ewVQAvajJQkzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@linux.alibaba.com>,
	Cooper Qu <cooper.qu@linux.alibaba.com>,
	Kees Cook <keescook@chromium.org>,
	Palmer Dabbelt <palmerdabbelt@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/138] riscv: Enable per-task stack canaries
Date: Tue, 30 Apr 2024 12:38:36 +0200
Message-ID: <20240430103050.347638688@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit fea2fed201ee5647699018a56fbb6a5e8cc053a5 ]

This enables the use of per-task stack canary values if GCC has
support for emitting the stack canary reference relative to the
value of tp, which holds the task struct pointer in the riscv
kernel.

After compare arm64 and x86 implementations, seems arm64's is more
flexible and readable. The key point is how gcc get the offset of
stack_canary from gs/el0_sp.

x86: Use a fix offset from gs, not flexible.

struct fixed_percpu_data {
	/*
	 * GCC hardcodes the stack canary as %gs:40.  Since the
	 * irq_stack is the object at %gs:0, we reserve the bottom
	 * 48 bytes of the irq stack for the canary.
	 */
	char            gs_base[40]; // :(
	unsigned long   stack_canary;
};

arm64: Use -mstack-protector-guard-offset & guard-reg
	gcc options:
	-mstack-protector-guard=sysreg
	-mstack-protector-guard-reg=sp_el0
	-mstack-protector-guard-offset=xxx

riscv: Use -mstack-protector-guard-offset & guard-reg
	gcc options:
	-mstack-protector-guard=tls
	-mstack-protector-guard-reg=tp
	-mstack-protector-guard-offset=xxx

 GCC's implementation has been merged:
 commit c931e8d5a96463427040b0d11f9c4352ac22b2b0
 Author: Cooper Qu <cooper.qu@linux.alibaba.com>
 Date:   Mon Jul 13 16:15:08 2020 +0800

     RISC-V: Add support for TLS stack protector canary access

In the end, these codes are inserted by gcc before return:

*  0xffffffe00020b396 <+120>:   ld      a5,1008(tp) # 0x3f0
*  0xffffffe00020b39a <+124>:   xor     a5,a5,a4
*  0xffffffe00020b39c <+126>:   mv      a0,s5
*  0xffffffe00020b39e <+128>:   bnez    a5,0xffffffe00020b61c <_do_fork+766>
   0xffffffe00020b3a2 <+132>:   ld      ra,136(sp)
   0xffffffe00020b3a4 <+134>:   ld      s0,128(sp)
   0xffffffe00020b3a6 <+136>:   ld      s1,120(sp)
   0xffffffe00020b3a8 <+138>:   ld      s2,112(sp)
   0xffffffe00020b3aa <+140>:   ld      s3,104(sp)
   0xffffffe00020b3ac <+142>:   ld      s4,96(sp)
   0xffffffe00020b3ae <+144>:   ld      s5,88(sp)
   0xffffffe00020b3b0 <+146>:   ld      s6,80(sp)
   0xffffffe00020b3b2 <+148>:   ld      s7,72(sp)
   0xffffffe00020b3b4 <+150>:   addi    sp,sp,144
   0xffffffe00020b3b6 <+152>:   ret
   ...
*  0xffffffe00020b61c <+766>:   auipc   ra,0x7f8
*  0xffffffe00020b620 <+770>:   jalr    -1764(ra) # 0xffffffe000a02f38 <__stack_chk_fail>

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Cooper Qu <cooper.qu@linux.alibaba.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Stable-dep-of: d14fa1fcf69d ("riscv: process: Fix kernel gp leakage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Kconfig                      |  7 +++++++
 arch/riscv/Makefile                     | 10 ++++++++++
 arch/riscv/include/asm/stackprotector.h |  3 ++-
 arch/riscv/kernel/asm-offsets.c         |  3 +++
 arch/riscv/kernel/process.c             |  2 +-
 5 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index b28fabfc91bf7..0248da3be3e70 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -445,6 +445,13 @@ config EFI
 	  allow the kernel to be booted as an EFI application. This
 	  is only useful on systems that have UEFI firmware.
 
+config CC_HAVE_STACKPROTECTOR_TLS
+	def_bool $(cc-option,-mstack-protector-guard=tls -mstack-protector-guard-reg=tp -mstack-protector-guard-offset=0)
+
+config STACKPROTECTOR_PER_TASK
+	def_bool y
+	depends on STACKPROTECTOR && CC_HAVE_STACKPROTECTOR_TLS
+
 endmenu
 
 config BUILTIN_DTB
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index daa679440000a..8572d23fba700 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -88,6 +88,16 @@ KBUILD_AFLAGS_MODULE += $(call as-option,-Wa$(comma)-mno-relax)
 # architectures.  It's faster to have GCC emit only aligned accesses.
 KBUILD_CFLAGS += $(call cc-option,-mstrict-align)
 
+ifeq ($(CONFIG_STACKPROTECTOR_PER_TASK),y)
+prepare: stack_protector_prepare
+stack_protector_prepare: prepare0
+	$(eval KBUILD_CFLAGS += -mstack-protector-guard=tls		  \
+				-mstack-protector-guard-reg=tp		  \
+				-mstack-protector-guard-offset=$(shell	  \
+			awk '{if ($$2 == "TSK_STACK_CANARY") print $$3;}' \
+					include/generated/asm-offsets.h))
+endif
+
 # arch specific predefines for sparse
 CHECKFLAGS += -D__riscv -D__riscv_xlen=$(BITS)
 
diff --git a/arch/riscv/include/asm/stackprotector.h b/arch/riscv/include/asm/stackprotector.h
index 5962f8891f06f..09093af46565e 100644
--- a/arch/riscv/include/asm/stackprotector.h
+++ b/arch/riscv/include/asm/stackprotector.h
@@ -24,6 +24,7 @@ static __always_inline void boot_init_stack_canary(void)
 	canary &= CANARY_MASK;
 
 	current->stack_canary = canary;
-	__stack_chk_guard = current->stack_canary;
+	if (!IS_ENABLED(CONFIG_STACKPROTECTOR_PER_TASK))
+		__stack_chk_guard = current->stack_canary;
 }
 #endif /* _ASM_RISCV_STACKPROTECTOR_H */
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index db203442c08f9..877ff65b4e136 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -66,6 +66,9 @@ void asm_offsets(void)
 	OFFSET(TASK_THREAD_F30, task_struct, thread.fstate.f[30]);
 	OFFSET(TASK_THREAD_F31, task_struct, thread.fstate.f[31]);
 	OFFSET(TASK_THREAD_FCSR, task_struct, thread.fstate.fcsr);
+#ifdef CONFIG_STACKPROTECTOR
+	OFFSET(TSK_STACK_CANARY, task_struct, stack_canary);
+#endif
 
 	DEFINE(PT_SIZE, sizeof(struct pt_regs));
 	OFFSET(PT_EPC, pt_regs, epc);
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 7868050ff426d..d83d7761a157d 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -24,7 +24,7 @@
 
 register unsigned long gp_in_global __asm__("gp");
 
-#ifdef CONFIG_STACKPROTECTOR
+#if defined(CONFIG_STACKPROTECTOR) && !defined(CONFIG_STACKPROTECTOR_PER_TASK)
 #include <linux/stackprotector.h>
 unsigned long __stack_chk_guard __read_mostly;
 EXPORT_SYMBOL(__stack_chk_guard);
-- 
2.43.0



