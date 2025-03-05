Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81574250C1C;
	Wed,  5 Mar 2025 17:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197505; cv=none; b=Ab6ZB8oHoTDj0nP9x/LnHr10DHKnCndTJqKSVyCAYGO3kKeCWDO96XE0i7XIXYEEAJAFhiIn5s3dfMnpery5ov0SBhYqoAghqgGT60nw5oVhOEsSAniBZyG6cW2fc3H1rqPQmUibnoppxROie42B8k3zdUXrlmpi8IaeCTJdhTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197505; c=relaxed/simple;
	bh=AXyv6ob3D8txljdXEDdUgUiMFa9HNMsnhf88KWBBnkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K22cM3GvR8sQ6eXTSsPPc8oQQoQ89BqdQUUwqOL1v+sR7XPSqLTR0NFEzDXHWzDohPb3X7q/ocVl69B/IdLIhCAq+u013fxgwRKzho61I5RlXKNpoOcq19jdH80VcUBJA1Nsj712qkOsvqsJs2WDnzBKzuIzsa/nyKgsgusDQjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usdXOgJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usdXOgJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BAEC4CED1;
	Wed,  5 Mar 2025 17:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197505;
	bh=AXyv6ob3D8txljdXEDdUgUiMFa9HNMsnhf88KWBBnkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usdXOgJC/bAD4xx+uPDnWRu/LcIMNsyt6q4maXP9qr1F+MsAZXYhd+gaVtTqAVz+E
	 o0WVbRxeQQ04zaXKcTYxaYcAsj1s6O7M5egXxTfyBTmQnX+BPhjgrT39JvSZhz+A7q
	 RJTWtNrkEDrLb/n6/SyQyoNGUJ9uxbU03t8L0OK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 6.1 172/176] ptrace: Introduce exception_ip arch hook
Date: Wed,  5 Mar 2025 18:49:01 +0100
Message-ID: <20250305174512.343904385@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit 11ba1728be3edb6928791f4c622f154ebe228ae6 upstream.

On architectures with delay slot, architecture level instruction
pointer (or program counter) in pt_regs may differ from where
exception was triggered.

Introduce exception_ip hook to invoke architecture code and determine
actual instruction pointer to the exception.

Link: https://lore.kernel.org/lkml/00d1b813-c55f-4365-8d81-d70258e10b16@app.fastmail.com/
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/ptrace.h |    2 ++
 arch/mips/kernel/ptrace.c      |    7 +++++++
 include/linux/ptrace.h         |    4 ++++
 3 files changed, 13 insertions(+)

--- a/arch/mips/include/asm/ptrace.h
+++ b/arch/mips/include/asm/ptrace.h
@@ -155,6 +155,8 @@ static inline long regs_return_value(str
 }
 
 #define instruction_pointer(regs) ((regs)->cp0_epc)
+extern unsigned long exception_ip(struct pt_regs *regs);
+#define exception_ip(regs) exception_ip(regs)
 #define profile_pc(regs) instruction_pointer(regs)
 
 extern asmlinkage long syscall_trace_enter(struct pt_regs *regs);
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -31,6 +31,7 @@
 #include <linux/seccomp.h>
 #include <linux/ftrace.h>
 
+#include <asm/branch.h>
 #include <asm/byteorder.h>
 #include <asm/cpu.h>
 #include <asm/cpu-info.h>
@@ -48,6 +49,12 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/syscalls.h>
 
+unsigned long exception_ip(struct pt_regs *regs)
+{
+	return exception_epc(regs);
+}
+EXPORT_SYMBOL(exception_ip);
+
 /*
  * Called by kernel/ptrace.c when detaching..
  *
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -402,6 +402,10 @@ static inline void user_single_step_repo
 #define current_user_stack_pointer() user_stack_pointer(current_pt_regs())
 #endif
 
+#ifndef exception_ip
+#define exception_ip(x) instruction_pointer(x)
+#endif
+
 extern int task_current_syscall(struct task_struct *target, struct syscall_info *info);
 
 extern void sigaction_compat_abi(struct k_sigaction *act, struct k_sigaction *oact);


