Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DA11C687;
	Mon,  4 Mar 2024 21:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588125; cv=none; b=S7G8zixeU56pXEpixPLvki3spwoOeWPcGwxhxBDi3u+6f+SYS55R5zjCD84lgQAzQ+qKhH6PkVhk7xFUlq39wzWcciF+xKwePMtxP7crfQsSXaMEugxoIA2E0qxiqh59wG2H1zw87VRrqXJBjCc9AKK4VDSIOcaQ4D25pJMssWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588125; c=relaxed/simple;
	bh=gKHTCAXaSD1GF57imsbwHl9Y9bYmgMSzvPdpLYA9QVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baeb/gRqW4r6X4m3jCruXFjj7D6PWBMsYqc6AkwPd7/LvLSIba9WiFFmxGepMV7pcomoZSjRidI5VSnbTx4DXJmI66ZADmfues/7+/ms7bcVinBfO30y6NPHG+lgKgP4HGUraeRcuK21tUe/r3MH+YS623cMknO5X0ZyZkmaEBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hz33Gpbm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hz33Gpbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DC3C433C7;
	Mon,  4 Mar 2024 21:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588125;
	bh=gKHTCAXaSD1GF57imsbwHl9Y9bYmgMSzvPdpLYA9QVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hz33GpbmprSMBvT3D9jTyKMcCGXr15jw336KBTOIRkNyIzA58IfXk+IR0W61UZqzT
	 IjSWpG6KLWbafDveGwKZbmj3nXMfEVC2b2Xkd+ojRgM6VeXjvHn/So8sPF0mJh5z8d
	 cIEcJ0loHPzbL7/WLSR6HaLPV4pCQmIKKoSD3SKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Zong Li <zong.li@sifive.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.10 31/42] riscv: add CALLER_ADDRx support
Date: Mon,  4 Mar 2024 21:23:58 +0000
Message-ID: <20240304211538.686526619@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211537.631764077@linuxfoundation.org>
References: <20240304211537.631764077@linuxfoundation.org>
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

From: Zong Li <zong.li@sifive.com>

commit 680341382da56bd192ebfa4e58eaf4fec2e5bca7 upstream.

CALLER_ADDRx returns caller's address at specified level, they are used
for several tracers. These macros eventually use
__builtin_return_address(n) to get the caller's address if arch doesn't
define their own implementation.

In RISC-V, __builtin_return_address(n) only works when n == 0, we need
to walk the stack frame to get the caller's address at specified level.

data.level started from 'level + 3' due to the call flow of getting
caller's address in RISC-V implementation. If we don't have additional
three iteration, the level is corresponding to follows:

callsite -> return_address -> arch_stack_walk -> walk_stackframe
|           |                 |                  |
level 3     level 2           level 1            level 0

Fixes: 10626c32e382 ("riscv/ftrace: Add basic support")
Cc: stable@vger.kernel.org
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Zong Li <zong.li@sifive.com>
Link: https://lore.kernel.org/r/20240202015102.26251-1-zong.li@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/ftrace.h    |    5 +++
 arch/riscv/kernel/Makefile         |    2 +
 arch/riscv/kernel/return_address.c |   48 +++++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+)
 create mode 100644 arch/riscv/kernel/return_address.c

--- a/arch/riscv/include/asm/ftrace.h
+++ b/arch/riscv/include/asm/ftrace.h
@@ -25,6 +25,11 @@
 
 #define ARCH_SUPPORTS_FTRACE_OPS 1
 #ifndef __ASSEMBLY__
+
+extern void *return_address(unsigned int level);
+
+#define ftrace_return_address(n) return_address(n)
+
 void MCOUNT_NAME(void);
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -7,6 +7,7 @@ ifdef CONFIG_FTRACE
 CFLAGS_REMOVE_ftrace.o	= $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_patch.o	= $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_sbi.o	= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_return_address.o	= $(CC_FLAGS_FTRACE)
 endif
 
 extra-y += head.o
@@ -20,6 +21,7 @@ obj-y	+= irq.o
 obj-y	+= process.o
 obj-y	+= ptrace.o
 obj-y	+= reset.o
+obj-y	+= return_address.o
 obj-y	+= setup.o
 obj-y	+= signal.o
 obj-y	+= syscall_table.o
--- /dev/null
+++ b/arch/riscv/kernel/return_address.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * This code come from arch/arm64/kernel/return_address.c
+ *
+ * Copyright (C) 2023 SiFive.
+ */
+
+#include <linux/export.h>
+#include <linux/kprobes.h>
+#include <linux/stacktrace.h>
+
+struct return_address_data {
+	unsigned int level;
+	void *addr;
+};
+
+static bool save_return_addr(void *d, unsigned long pc)
+{
+	struct return_address_data *data = d;
+
+	if (!data->level) {
+		data->addr = (void *)pc;
+		return false;
+	}
+
+	--data->level;
+
+	return true;
+}
+NOKPROBE_SYMBOL(save_return_addr);
+
+noinline void *return_address(unsigned int level)
+{
+	struct return_address_data data;
+
+	data.level = level + 3;
+	data.addr = NULL;
+
+	arch_stack_walk(save_return_addr, &data, current, NULL);
+
+	if (!data.level)
+		return data.addr;
+	else
+		return NULL;
+
+}
+EXPORT_SYMBOL_GPL(return_address);
+NOKPROBE_SYMBOL(return_address);


