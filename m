Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEB013AD1;
	Sat,  3 Feb 2024 04:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933753; cv=none; b=h7ZuBSiHyN5vJludlDmz8lktyrkY4vw9tPbVfL7qUvhvIf8fE21TdHX+MZa6kti594FDg49anWWNmx4EfY/tyuYfoYxR/qfP4EIIcT8ijvUyjXu35SdG+EGn6nAvekNAt9zC7Q7KepwLTo81KL20xlPvNbx432yViFajLBNiOn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933753; c=relaxed/simple;
	bh=Gy0DtQmXbE6UlwGFfwk138phI0AY7qAUUounFN43zIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Icvl2rXNHIfd87kf+cNeNGKECpO10vnU6rQJeeTSdjwjEifIEd33y4GUEGK7SoZ6WYmcvb58OrCPmQpPaf8EWm6RbulTXgM1lBexlUYcfjw15SDPRbYE9FIq0skLHuaa+N5TrEvRHfXAyn1CErAlwRkJEALbUSBQHOYC3l/DHEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8SEpvNM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8SEpvNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA52EC43390;
	Sat,  3 Feb 2024 04:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933753;
	bh=Gy0DtQmXbE6UlwGFfwk138phI0AY7qAUUounFN43zIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8SEpvNMhFlzlNzWCRNj/w6k2kxxZ04+pSBHI46YDllLD8y0wCJi80QSmLROwYIQ6
	 TXTHBrgedNJtE4ABTKS1uXbZAb/D9CmeLFAOLTk86IlgMeg2BmxfUbMI8otbFN7Hkf
	 LVUlY8XubAZUxhvmmsFB8Pl+nYSKexmUjOKyR0UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 048/353] arch: fix asm-offsets.c building with -Wmissing-prototypes
Date: Fri,  2 Feb 2024 20:02:46 -0800
Message-ID: <20240203035405.333706430@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 4d86896793dd6eeacdf32b85af1ef130349db4be ]

When -Wmissing-prototypes is enabled, the some asm-offsets.c files fail
to build, even when this warning is disabled in the Makefile for normal
files:

arch/sparc/kernel/asm-offsets.c:22:5: error: no previous prototype for 'sparc32_foo' [-Werror=missing-prototypes]
arch/sparc/kernel/asm-offsets.c:48:5: error: no previous prototype for 'foo' [-Werror=missing-prototypes]

Address this by making use of the same trick as x86, marking these
functions as 'static __used' to avoid the need for a prototype
by not drop them in dead-code elimination.

Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://lore.kernel.org/lkml/CAK7LNARfEmFk0Du4Hed19eX_G6tUC5wG0zP+L1AyvdpOF4ybXQ@mail.gmail.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/asm-offsets.c     |  2 +-
 arch/loongarch/kernel/asm-offsets.c | 26 +++++++++++++-------------
 arch/sparc/kernel/asm-offsets.c     |  6 +++---
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/alpha/kernel/asm-offsets.c b/arch/alpha/kernel/asm-offsets.c
index b121294bee26..bf1eedd27cf7 100644
--- a/arch/alpha/kernel/asm-offsets.c
+++ b/arch/alpha/kernel/asm-offsets.c
@@ -12,7 +12,7 @@
 #include <linux/kbuild.h>
 #include <asm/io.h>
 
-void foo(void)
+static void __used foo(void)
 {
 	DEFINE(TI_TASK, offsetof(struct thread_info, task));
 	DEFINE(TI_FLAGS, offsetof(struct thread_info, flags));
diff --git a/arch/loongarch/kernel/asm-offsets.c b/arch/loongarch/kernel/asm-offsets.c
index 173fe514fc9e..bee9f7a3108f 100644
--- a/arch/loongarch/kernel/asm-offsets.c
+++ b/arch/loongarch/kernel/asm-offsets.c
@@ -15,7 +15,7 @@
 #include <asm/processor.h>
 #include <asm/ftrace.h>
 
-void output_ptreg_defines(void)
+static void __used output_ptreg_defines(void)
 {
 	COMMENT("LoongArch pt_regs offsets.");
 	OFFSET(PT_R0, pt_regs, regs[0]);
@@ -62,7 +62,7 @@ void output_ptreg_defines(void)
 	BLANK();
 }
 
-void output_task_defines(void)
+static void __used output_task_defines(void)
 {
 	COMMENT("LoongArch task_struct offsets.");
 	OFFSET(TASK_STATE, task_struct, __state);
@@ -77,7 +77,7 @@ void output_task_defines(void)
 	BLANK();
 }
 
-void output_thread_info_defines(void)
+static void __used output_thread_info_defines(void)
 {
 	COMMENT("LoongArch thread_info offsets.");
 	OFFSET(TI_TASK, thread_info, task);
@@ -93,7 +93,7 @@ void output_thread_info_defines(void)
 	BLANK();
 }
 
-void output_thread_defines(void)
+static void __used output_thread_defines(void)
 {
 	COMMENT("LoongArch specific thread_struct offsets.");
 	OFFSET(THREAD_REG01, task_struct, thread.reg01);
@@ -129,7 +129,7 @@ void output_thread_defines(void)
 	BLANK();
 }
 
-void output_thread_fpu_defines(void)
+static void __used output_thread_fpu_defines(void)
 {
 	OFFSET(THREAD_FPR0, loongarch_fpu, fpr[0]);
 	OFFSET(THREAD_FPR1, loongarch_fpu, fpr[1]);
@@ -170,7 +170,7 @@ void output_thread_fpu_defines(void)
 	BLANK();
 }
 
-void output_thread_lbt_defines(void)
+static void __used output_thread_lbt_defines(void)
 {
 	OFFSET(THREAD_SCR0,  loongarch_lbt, scr0);
 	OFFSET(THREAD_SCR1,  loongarch_lbt, scr1);
@@ -180,7 +180,7 @@ void output_thread_lbt_defines(void)
 	BLANK();
 }
 
-void output_mm_defines(void)
+static void __used output_mm_defines(void)
 {
 	COMMENT("Size of struct page");
 	DEFINE(STRUCT_PAGE_SIZE, sizeof(struct page));
@@ -212,7 +212,7 @@ void output_mm_defines(void)
 	BLANK();
 }
 
-void output_sc_defines(void)
+static void __used output_sc_defines(void)
 {
 	COMMENT("Linux sigcontext offsets.");
 	OFFSET(SC_REGS, sigcontext, sc_regs);
@@ -220,7 +220,7 @@ void output_sc_defines(void)
 	BLANK();
 }
 
-void output_signal_defines(void)
+static void __used output_signal_defines(void)
 {
 	COMMENT("Linux signal numbers.");
 	DEFINE(_SIGHUP, SIGHUP);
@@ -258,7 +258,7 @@ void output_signal_defines(void)
 }
 
 #ifdef CONFIG_SMP
-void output_smpboot_defines(void)
+static void __used output_smpboot_defines(void)
 {
 	COMMENT("Linux smp cpu boot offsets.");
 	OFFSET(CPU_BOOT_STACK, secondary_data, stack);
@@ -268,7 +268,7 @@ void output_smpboot_defines(void)
 #endif
 
 #ifdef CONFIG_HIBERNATION
-void output_pbe_defines(void)
+static void __used output_pbe_defines(void)
 {
 	COMMENT("Linux struct pbe offsets.");
 	OFFSET(PBE_ADDRESS, pbe, address);
@@ -280,7 +280,7 @@ void output_pbe_defines(void)
 #endif
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-void output_fgraph_ret_regs_defines(void)
+static void __used output_fgraph_ret_regs_defines(void)
 {
 	COMMENT("LoongArch fgraph_ret_regs offsets.");
 	OFFSET(FGRET_REGS_A0, fgraph_ret_regs, regs[0]);
@@ -291,7 +291,7 @@ void output_fgraph_ret_regs_defines(void)
 }
 #endif
 
-void output_kvm_defines(void)
+static void __used output_kvm_defines(void)
 {
 	COMMENT("KVM/LoongArch Specific offsets.");
 
diff --git a/arch/sparc/kernel/asm-offsets.c b/arch/sparc/kernel/asm-offsets.c
index 5784f2df489a..3d9b9855dce9 100644
--- a/arch/sparc/kernel/asm-offsets.c
+++ b/arch/sparc/kernel/asm-offsets.c
@@ -19,14 +19,14 @@
 #include <asm/hibernate.h>
 
 #ifdef CONFIG_SPARC32
-int sparc32_foo(void)
+static int __used sparc32_foo(void)
 {
 	DEFINE(AOFF_thread_fork_kpsr,
 			offsetof(struct thread_struct, fork_kpsr));
 	return 0;
 }
 #else
-int sparc64_foo(void)
+static int __used sparc64_foo(void)
 {
 #ifdef CONFIG_HIBERNATION
 	BLANK();
@@ -45,7 +45,7 @@ int sparc64_foo(void)
 }
 #endif
 
-int foo(void)
+static int __used foo(void)
 {
 	BLANK();
 	DEFINE(AOFF_task_thread, offsetof(struct task_struct, thread));
-- 
2.43.0



