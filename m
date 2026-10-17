Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796092E8DEB;
	Sat, 17 Oct 2026 16:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253350; cv=none; b=UH3Jh6BSJ3Kvp6Vm/n92/+AKmZ+vfwPjYM9EUM96qMNRWRr4V3uWFytRJfJr9cmBEYHFQVmf3KwRfa1xLwuqNjGiR0O/v0a86QkyE2oUNHmA0mqrIQWN/wxmKD0InOmNlwZAGnrYGsBT18mZ2m9Ni27k+MiNlbD9aM4ge+hYhmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253350; c=relaxed/simple;
	bh=bShewQsWeK7spDbTOqzlPF0nGVsMtMNiF4qRixBl2GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETrXLpuHag2oagn9KND+Ino7sAvcZf7L4hT/9VPcBqk78Y9sDL2t/va0HXVW9ogUu3AE2FOQjFJnATPQe18BwEIUfgWz/Dvic/noLCKZKAJbMSUXt/UGIYBsDy+BuLIDSBwP6bxA+0bUDrigr+RNFf8/gpQqm42uQhsgv0Leiuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LnNtCf8v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnNtCf8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB721F000C5;
	Sat, 17 Oct 2026 16:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253349;
	bh=JIv9hagFUBd+uOX0jhq4gaY/pv2DmbK1kWMtg8ffu0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LnNtCf8vkwus3qPdzjFXDSriN2lljm91KyHY22Pofv5gNwOHvxeXAOhGEgWfMgBEQ
	 2bG6rSNjV2ab1bKmjbHiTKoPGCPGEK+g1O6Armn2uq7GdUadDAdneDuJykx/+voCmP
	 W77+etzQDCE1eaG6ITfBz3q9srKjCEMshGm6oqzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/869] s390/entry: Remove __GMAP_ASCE and use _PIF_GUEST_FAULT again
Date: Sat, 17 Oct 2026 17:48:50 +0200
Message-ID: <20261017160039.316377968@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit f96cb0d61db6e25cef9d1764acfce3262e507719 ]

Now that the guest ASCE is passed as a parameter to __sie64a(),
_PIF_GUEST_FAULT can be used again to determine whether the fault was a
guest or host fault.

Since the guest ASCE will not be taken from the gmap pointer in lowcore
anymore, __GMAP_ASCE can be removed. For the same reason the guest
ASCE needs now to be saved into the cr1 save area unconditionally.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20241022120601.167009-2-imbrenda@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 11709abccf93 ("s390/mm: Fix in_atomic() handling in do_secure_storage_access()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/ptrace.h |  2 ++
 arch/s390/kernel/asm-offsets.c |  2 --
 arch/s390/kernel/entry.S       | 26 ++++++++++++++------------
 arch/s390/mm/fault.c           |  6 ++----
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/s390/include/asm/ptrace.h b/arch/s390/include/asm/ptrace.h
index 2ad9324f63387..788bc4467445c 100644
--- a/arch/s390/include/asm/ptrace.h
+++ b/arch/s390/include/asm/ptrace.h
@@ -14,11 +14,13 @@
 #define PIF_SYSCALL			0	/* inside a system call */
 #define PIF_EXECVE_PGSTE_RESTART	1	/* restart execve for PGSTE binaries */
 #define PIF_SYSCALL_RET_SET		2	/* return value was set via ptrace */
+#define PIF_GUEST_FAULT			3	/* indicates program check in sie64a */
 #define PIF_FTRACE_FULL_REGS		4	/* all register contents valid (ftrace) */
 
 #define _PIF_SYSCALL			BIT(PIF_SYSCALL)
 #define _PIF_EXECVE_PGSTE_RESTART	BIT(PIF_EXECVE_PGSTE_RESTART)
 #define _PIF_SYSCALL_RET_SET		BIT(PIF_SYSCALL_RET_SET)
+#define _PIF_GUEST_FAULT		BIT(PIF_GUEST_FAULT)
 #define _PIF_FTRACE_FULL_REGS		BIT(PIF_FTRACE_FULL_REGS)
 
 #define PSW32_MASK_PER		_AC(0x40000000, UL)
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index 8fd98a0f999f8..1848d51230004 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -14,7 +14,6 @@
 #include <linux/purgatory.h>
 #include <linux/pgtable.h>
 #include <linux/ftrace.h>
-#include <asm/gmap.h>
 #include <asm/stacktrace.h>
 
 int main(void)
@@ -162,7 +161,6 @@ int main(void)
 	OFFSET(__LC_PGM_TDB, lowcore, pgm_tdb);
 	BLANK();
 	/* gmap/sie offsets */
-	OFFSET(__GMAP_ASCE, gmap, asce);
 	OFFSET(__SIE_PROG0C, kvm_s390_sie_block, prog0c);
 	OFFSET(__SIE_PROG20, kvm_s390_sie_block, prog20);
 	/* kexec_sha_region */
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 8f5120802115b..2245f562089e4 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -328,13 +328,23 @@ SYM_CODE_START(pgm_check_handler)
 	GET_LC	%r13
 	stpt	__LC_SYS_ENTER_TIMER(%r13)
 	BPOFF
-	lgr	%r10,%r15
 	lmg	%r8,%r9,__LC_PGM_OLD_PSW(%r13)
+	xgr	%r10,%r10
+	xgr	%r12,%r12
 	tmhh	%r8,0x0001		# coming from user space?
 	jno	.Lpgm_skip_asce
 	lctlg	%c1,%c1,__LC_KERNEL_ASCE(%r13)
 	j	3f			# -> fault in user space
 .Lpgm_skip_asce:
+#if IS_ENABLED(CONFIG_KVM)
+	lg	%r11,__LC_CURRENT(%r13)
+	tm	__TI_sie(%r11),0xff
+	jz	1f
+	BPENTER	__SF_SIE_FLAGS(%r15),_TIF_ISOLATE_BP_GUEST
+	SIEEXIT __SF_SIE_CONTROL(%r15),%r13
+	lg	%r12,__SF_SIE_GUEST_ASCE(%r15)
+	lghi	%r10,_PIF_GUEST_FAULT
+#endif
 1:	tmhh	%r8,0x4000		# PER bit set in old PSW ?
 	jnz	2f			# -> enabled, can't be a double fault
 	tm	__LC_PGM_ILC+3(%r13),0x80	# check for per exception
@@ -345,21 +355,13 @@ SYM_CODE_START(pgm_check_handler)
 	CHECK_VMAP_STACK __LC_SAVE_AREA,%r13,4f
 3:	lg	%r15,__LC_KERNEL_STACK(%r13)
 4:	la	%r11,STACK_FRAME_OVERHEAD(%r15)
-	xc	__PT_FLAGS(8,%r11),__PT_FLAGS(%r11)
+	stg	%r10,__PT_FLAGS(%r11)
+	stg	%r12,__PT_CR1(%r11)
 	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	stmg	%r0,%r7,__PT_R0(%r11)
 	mvc	__PT_R8(64,%r11),__LC_SAVE_AREA(%r13)
 	mvc	__PT_LAST_BREAK(8,%r11),__LC_PGM_LAST_BREAK(%r13)
-	stctg	%c1,%c1,__PT_CR1(%r11)
-#if IS_ENABLED(CONFIG_KVM)
-	ltg	%r12,__LC_GMAP(%r13)
-	jz	5f
-	clc	__GMAP_ASCE(8,%r12), __PT_CR1(%r11)
-	jne	5f
-	BPENTER	__SF_SIE_FLAGS(%r10),_TIF_ISOLATE_BP_GUEST
-	SIEEXIT __SF_SIE_CONTROL(%r10),%r13
-#endif
-5:	stmg	%r8,%r9,__PT_PSW(%r11)
+	stmg	%r8,%r9,__PT_PSW(%r11)
 	# clear user controlled registers to prevent speculative use
 	xgr	%r0,%r0
 	xgr	%r1,%r1
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index ad8b0d6b77ea1..a6cf33b0f3390 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -68,15 +68,13 @@ early_initcall(fault_init);
 static enum fault_type get_fault_type(struct pt_regs *regs)
 {
 	union teid teid = { .val = regs->int_parm_long };
-	struct gmap *gmap;
 
 	if (likely(teid.as == PSW_BITS_AS_PRIMARY)) {
 		if (user_mode(regs))
 			return USER_FAULT;
 		if (!IS_ENABLED(CONFIG_PGSTE))
 			return KERNEL_FAULT;
-		gmap = (struct gmap *)get_lowcore()->gmap;
-		if (gmap && gmap->asce == regs->cr1)
+		if (test_pt_regs_flag(regs, PIF_GUEST_FAULT))
 			return GMAP_FAULT;
 		return KERNEL_FAULT;
 	}
@@ -187,7 +185,7 @@ static void dump_fault_info(struct pt_regs *regs)
 		pr_cont("user ");
 		break;
 	case GMAP_FAULT:
-		asce = ((struct gmap *)get_lowcore()->gmap)->asce;
+		asce = regs->cr1;
 		pr_cont("gmap ");
 		break;
 	case KERNEL_FAULT:
-- 
2.53.0



