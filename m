Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2179443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A34C433C8;
	Sun, 13 Aug 2023 21:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961953;
	bh=GZWQy4wMUknFyU1T7CEyqwc2e+Alm6E+Wd3HmcY1kWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9UHdvQHi+SPkcDzKj49T2ABtGedZy33F7mC6z/jWOBA1yWVv8mNw8FQ3HLgdfyAj
	 HKt8dco4wgSQZfqJ7wB5q4k3CRYs3tB23QJHwdhdslY6Am9CFcGzU4iYqpE3TFH54j
	 3atmS9GDpSiEEsnMVkf5JU8Z2g+FjFvPK3tDX4kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	John David Anglin <dave.anglin@bell.net>
Subject: [PATCH 6.4 029/206] parisc: Fix lightweight spinlock checks to not break futexes
Date: Sun, 13 Aug 2023 23:16:39 +0200
Message-ID: <20230813211725.837786672@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit a0f4b7879f2e14986200747d1b545e5daac8c624 upstream.

The lightweight spinlock checks verify that a spinlock has either value
0 (spinlock locked) and that not any other bits than in
__ARCH_SPIN_LOCK_UNLOCKED_VAL is set.

This breaks the current LWS code, which writes the address of the lock
into the lock word to unlock it, which was an optimization to save one
assembler instruction.

Fix it by making spinlock_types.h accessible for asm code, change the
LWS spinlock-unlocking code to write __ARCH_SPIN_LOCK_UNLOCKED_VAL into
the lock word, and add some missing lightweight spinlock checks to the
LWS path. Finally, make the spinlock checks dependend on DEBUG_KERNEL.

Noticed-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Tested-by: John David Anglin <dave.anglin@bell.net>
Cc: stable@vger.kernel.org # v6.4+
Fixes: 15e64ef6520e ("parisc: Add lightweight spinlock checks")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/Kconfig.debug                |  2 +-
 arch/parisc/include/asm/spinlock.h       |  2 --
 arch/parisc/include/asm/spinlock_types.h |  6 ++++++
 arch/parisc/kernel/syscall.S             | 23 ++++++++++++++++++++---
 4 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/arch/parisc/Kconfig.debug b/arch/parisc/Kconfig.debug
index 1401e4c5fe5f..bf2b21b96f0b 100644
--- a/arch/parisc/Kconfig.debug
+++ b/arch/parisc/Kconfig.debug
@@ -2,7 +2,7 @@
 #
 config LIGHTWEIGHT_SPINLOCK_CHECK
 	bool "Enable lightweight spinlock checks"
-	depends on SMP && !DEBUG_SPINLOCK
+	depends on DEBUG_KERNEL && SMP && !DEBUG_SPINLOCK
 	default y
 	help
 	  Add checks with low performance impact to the spinlock functions
diff --git a/arch/parisc/include/asm/spinlock.h b/arch/parisc/include/asm/spinlock.h
index edfcb9858bcb..0b326e52255e 100644
--- a/arch/parisc/include/asm/spinlock.h
+++ b/arch/parisc/include/asm/spinlock.h
@@ -7,8 +7,6 @@
 #include <asm/processor.h>
 #include <asm/spinlock_types.h>
 
-#define SPINLOCK_BREAK_INSN	0x0000c006	/* break 6,6 */
-
 static inline void arch_spin_val_check(int lock_val)
 {
 	if (IS_ENABLED(CONFIG_LIGHTWEIGHT_SPINLOCK_CHECK))
diff --git a/arch/parisc/include/asm/spinlock_types.h b/arch/parisc/include/asm/spinlock_types.h
index d65934079ebd..efd06a897c6a 100644
--- a/arch/parisc/include/asm/spinlock_types.h
+++ b/arch/parisc/include/asm/spinlock_types.h
@@ -4,6 +4,10 @@
 
 #define __ARCH_SPIN_LOCK_UNLOCKED_VAL	0x1a46
 
+#define SPINLOCK_BREAK_INSN	0x0000c006	/* break 6,6 */
+
+#ifndef __ASSEMBLY__
+
 typedef struct {
 #ifdef CONFIG_PA20
 	volatile unsigned int slock;
@@ -27,6 +31,8 @@ typedef struct {
 	volatile unsigned int	counter;
 } arch_rwlock_t;
 
+#endif /* __ASSEMBLY__ */
+
 #define __ARCH_RW_LOCK_UNLOCKED__       0x01000000
 #define __ARCH_RW_LOCK_UNLOCKED         { .lock_mutex = __ARCH_SPIN_LOCK_UNLOCKED, \
 					.counter = __ARCH_RW_LOCK_UNLOCKED__ }
diff --git a/arch/parisc/kernel/syscall.S b/arch/parisc/kernel/syscall.S
index 1373e5129868..1f51aa9c8230 100644
--- a/arch/parisc/kernel/syscall.S
+++ b/arch/parisc/kernel/syscall.S
@@ -39,6 +39,7 @@ registers).
 #include <asm/assembly.h>
 #include <asm/processor.h>
 #include <asm/cache.h>
+#include <asm/spinlock_types.h>
 
 #include <linux/linkage.h>
 
@@ -66,6 +67,16 @@ registers).
 	stw	\reg1, 0(%sr2,\reg2)
 	.endm
 
+	/* raise exception if spinlock content is not zero or
+	 * __ARCH_SPIN_LOCK_UNLOCKED_VAL */
+	.macro	spinlock_check spin_val,tmpreg
+#ifdef CONFIG_LIGHTWEIGHT_SPINLOCK_CHECK
+	ldi	__ARCH_SPIN_LOCK_UNLOCKED_VAL, \tmpreg
+	andcm,=	\spin_val, \tmpreg, %r0
+	.word	SPINLOCK_BREAK_INSN
+#endif
+	.endm
+
 	.text
 
 	.import syscall_exit,code
@@ -508,7 +519,8 @@ lws_start:
 
 lws_exit_noerror:
 	lws_pagefault_enable	%r1,%r21
-	stw,ma	%r20, 0(%sr2,%r20)
+	ldi	__ARCH_SPIN_LOCK_UNLOCKED_VAL, %r21
+	stw,ma	%r21, 0(%sr2,%r20)
 	ssm	PSW_SM_I, %r0
 	b	lws_exit
 	copy	%r0, %r21
@@ -521,7 +533,8 @@ lws_wouldblock:
 
 lws_pagefault:
 	lws_pagefault_enable	%r1,%r21
-	stw,ma	%r20, 0(%sr2,%r20)
+	ldi	__ARCH_SPIN_LOCK_UNLOCKED_VAL, %r21
+	stw,ma	%r21, 0(%sr2,%r20)
 	ssm	PSW_SM_I, %r0
 	ldo	3(%r0),%r28
 	b	lws_exit
@@ -619,6 +632,7 @@ lws_compare_and_swap:
 
 	/* Try to acquire the lock */
 	LDCW	0(%sr2,%r20), %r28
+	spinlock_check	%r28, %r21
 	comclr,<>	%r0, %r28, %r0
 	b,n	lws_wouldblock
 
@@ -772,6 +786,7 @@ cas2_lock_start:
 
 	/* Try to acquire the lock */
 	LDCW	0(%sr2,%r20), %r28
+	spinlock_check	%r28, %r21
 	comclr,<>	%r0, %r28, %r0
 	b,n	lws_wouldblock
 
@@ -1001,6 +1016,7 @@ atomic_xchg_start:
 
 	/* Try to acquire the lock */
 	LDCW	0(%sr2,%r20), %r28
+	spinlock_check	%r28, %r21
 	comclr,<>	%r0, %r28, %r0
 	b,n	lws_wouldblock
 
@@ -1199,6 +1215,7 @@ atomic_store_start:
 
 	/* Try to acquire the lock */
 	LDCW	0(%sr2,%r20), %r28
+	spinlock_check	%r28, %r21
 	comclr,<>	%r0, %r28, %r0
 	b,n	lws_wouldblock
 
@@ -1330,7 +1347,7 @@ ENTRY(lws_lock_start)
 	/* lws locks */
 	.rept 256
 	/* Keep locks aligned at 16-bytes */
-	.word 1
+	.word __ARCH_SPIN_LOCK_UNLOCKED_VAL
 	.word 0 
 	.word 0
 	.word 0
-- 
2.41.0



