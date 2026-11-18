Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037003;
	b=2R36ZXRKC56i7R+UWd2OPBPph3ve/O4vGrmC90ZHHOw6DLorHbOCxPGwQuqKxKYkwiFp
	 jp0w67HApCLhOZao4bhKTCIfdxdml6GG0dJ2tLEjOlFCKp7x7FOZmEY/n+P+Uia0Hx1WR
	 9O5QsMBCPEZhF8aiy72Ma7Ke5VcHv7DZ+prjGBOSyfdkDtBjTQImHkeXx9a3tI/Q4zJer
	 KPF43S0ylnxEMhZuzBhjZCpeF4NByhHg0n8n4jYgoCKxMy6znLi4oSwac9qXjqa2A76A8
	 Oce6qBaKMZfYaaFqAmlYTckOLE3qkmgAUQmiMPCTD/k9ye2csfQxojUpm/Rr30ksV6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F6ohpccDIfWUJSZjoChlo4wQ/iY5T0iqL2g7ISc0e90=;
	b=pxuXh9eKwJisX/lhtWZohU0xB5ZnIou5eNXx1wOPqif6HVlb+riBxcdxkoNTxKdeICXc
	 8fbsd81/MRyqL0SzNebcGHvrTzM7B4BrYx99P4T9ENcNcUfm6Jq2zmcKL3VJEa8oCiYVU
	 I/dcZHiCRZlPnyYerzqsQyynfJKHUzrzWCkQ6yTNK5UKR97DslybxmQbdgxHmTnGQAU+o
	 KbqDZmIyK7ITzU6NyuiBzBJ/voiPEuh6nBMy3fYYg2/dLQ5z5Cm/3Peg5S6Z9IK/K0R6Y
	 rkDNK8iHZn33/UCva9sBIgIJGYNyUBX60qbf8ImpVYUtZgBSRTHpxOSVHXS52EaAEzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PiZvHUg4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4E7606A31C;
	Wed, 18 Nov 2026 21:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PiZvHUg4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9A21F000C4;
	Wed, 18 Nov 2026 21:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037003;
	bh=F6ohpccDIfWUJSZjoChlo4wQ/iY5T0iqL2g7ISc0e90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PiZvHUg47lmjGDkhIpxFeZ1b7u0NG7LAho/pMFs3Mzd/zTREKZQ1F8wzxmgRp3SFd
	 M90vjYLngrpk4cPYQAaGikozJaDA89BxUml7pyUHoB0gq1qR7vygmu0NUUG/lPoRhx
	 CFfZYPTOfUqo+pXWhpTWDKIi2hlUr8AmnbCG2Ts0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1260/3318] LoongArch: Only send SIGTRAP signal if necessary in do_watch()
Date: Wed, 18 Nov 2026 15:31:22 +0100
Message-ID: <20261118150358.001475556@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit f087903018e35d38b8932e18b010ee2e8699d1a1 ]

In do_watch(), the kernel unconditionally forces a SIGTRAP signal at the
end of the handler via force_sig(SIGTRAP). This is essential for ptrace
operations, but it severely disrupts standard perf_event usage.

Under normal perf usage, it is not necessary to force a SIGTRAP signal
on every hit. Forcing it unnecessarily aborts the target process if no
user-space signal handler is registered, which violates performance
monitoring behaviors and injects context switch overheads.

However, a conditional check using only 'current->ptrace' would block
legitimate user-requested signals when a perf_event is configured with
'attr.sigtrap = 1' for asynchronous user-space tracking.

Fix this by refactoring breakpoint_handler() and watchpoint_handler()
to return a boolean status indicating whether any triggered breakpoint
explicitly requires a signal notification. Update do_watch() to enforce
the SIGTRAP signal only when the process is actively being debugged via
ptrace, or when the underlying perf_event infrastructure specifically
demands it via 'attr.sigtrap'.

Cc: stable@vger.kernel.org
Fixes: 424421a7f34c ("LoongArch: ptrace: Add hardware single step support")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/hw_breakpoint.h |  4 ++--
 arch/loongarch/kernel/hw_breakpoint.c      | 18 ++++++++++++++++--
 arch/loongarch/kernel/traps.c              |  9 ++++++---
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/loongarch/include/asm/hw_breakpoint.h b/arch/loongarch/include/asm/hw_breakpoint.h
index 5faa97a87a9e2..d202052df8a16 100644
--- a/arch/loongarch/include/asm/hw_breakpoint.h
+++ b/arch/loongarch/include/asm/hw_breakpoint.h
@@ -116,8 +116,8 @@ extern void arch_uninstall_hw_breakpoint(struct perf_event *bp);
 extern int hw_breakpoint_slots(int type);
 extern void hw_breakpoint_pmu_read(struct perf_event *bp);
 
-void breakpoint_handler(struct pt_regs *regs);
-void watchpoint_handler(struct pt_regs *regs);
+bool breakpoint_handler(struct pt_regs *regs);
+bool watchpoint_handler(struct pt_regs *regs);
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 extern void ptrace_hw_copy_thread(struct task_struct *task);
diff --git a/arch/loongarch/kernel/hw_breakpoint.c b/arch/loongarch/kernel/hw_breakpoint.c
index 7f69cf361a5e2..d009ed780cf02 100644
--- a/arch/loongarch/kernel/hw_breakpoint.c
+++ b/arch/loongarch/kernel/hw_breakpoint.c
@@ -482,9 +482,10 @@ NOKPROBE_SYMBOL(update_bp_registers);
 /*
  * Debug exception handlers.
  */
-void breakpoint_handler(struct pt_regs *regs)
+bool breakpoint_handler(struct pt_regs *regs)
 {
 	int i;
+	bool need_sigtrap = false;
 	struct perf_event *bp, **slots;
 
 	slots = this_cpu_ptr(bp_on_reg);
@@ -494,17 +495,24 @@ void breakpoint_handler(struct pt_regs *regs)
 			bp = slots[i];
 			if (bp == NULL)
 				continue;
+
 			perf_bp_event(bp, regs);
+			if (bp->attr.sigtrap)
+				need_sigtrap = true;
+
 			csr_write32(0x1 << i, LOONGARCH_CSR_FWPS);
 			update_bp_registers(regs, 0, 0);
 		}
 	}
+
+	return need_sigtrap;
 }
 NOKPROBE_SYMBOL(breakpoint_handler);
 
-void watchpoint_handler(struct pt_regs *regs)
+bool watchpoint_handler(struct pt_regs *regs)
 {
 	int i;
+	bool need_sigtrap = false;
 	struct perf_event *wp, **slots;
 
 	slots = this_cpu_ptr(wp_on_reg);
@@ -514,11 +522,17 @@ void watchpoint_handler(struct pt_regs *regs)
 			wp = slots[i];
 			if (wp == NULL)
 				continue;
+
 			perf_bp_event(wp, regs);
+			if (wp->attr.sigtrap)
+				need_sigtrap = true;
+
 			csr_write32(0x1 << i, LOONGARCH_CSR_MWPS);
 			update_bp_registers(regs, 0, 1);
 		}
 	}
+
+	return need_sigtrap;
 }
 NOKPROBE_SYMBOL(watchpoint_handler);
 
diff --git a/arch/loongarch/kernel/traps.c b/arch/loongarch/kernel/traps.c
index fd1921718fefc..d65f6dc420b79 100644
--- a/arch/loongarch/kernel/traps.c
+++ b/arch/loongarch/kernel/traps.c
@@ -773,6 +773,8 @@ asmlinkage void noinstr do_watch(struct pt_regs *regs)
 #ifndef CONFIG_HAVE_HW_BREAKPOINT
 	pr_warn("Hardware watch point handler not implemented!\n");
 #else
+	bool need_sigtrap = !!current->ptrace;
+
 	if (kgdb_breakpoint_handler(regs))
 		goto out;
 
@@ -809,11 +811,12 @@ asmlinkage void noinstr do_watch(struct pt_regs *regs)
 			}
 		}
 	} else {
-		breakpoint_handler(regs);
-		watchpoint_handler(regs);
+		need_sigtrap |= breakpoint_handler(regs);
+		need_sigtrap |= watchpoint_handler(regs);
 	}
 
-	force_sig(SIGTRAP);
+	if (need_sigtrap)
+		force_sig(SIGTRAP);
 out:
 #endif
 	irqentry_exit(regs, state);
-- 
2.53.0



