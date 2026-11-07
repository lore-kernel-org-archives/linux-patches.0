Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065528;
	b=wy4naW4/FJ1j/5nhtSyXjg8Ged5h62vdyDTiVzoxo4e/j3S0433CoK3Awj2M/h7nauPU
	 aAALJ1d+eLAL4+ICBKeaqLMazlEH6Tndx3CvrKH1Hz96PJFiLpxEItwHWxmzpmfH2gMsI
	 PzGVvRDHIRI2vaBTVMiQWSykMjC8F0DKkC141T6fv+UJioWYw8U4wEi9q+W/J9Pmt/Wq8
	 EVYX7jrvJ051Gepvyzz8K8tG9HJrFqFhqtfIqYVN7vdoPRzl0cqFY5G+Yv1wl5sMDIaC9
	 LI2bbJwBzAxY7vir3qcqpE3Va3onzrgJDzpCVZmq+eYBGjSqFObfLVh1QjYx5IAZzMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dy3mNYETJb+hCoEfaBhRgb2EQ4lE4mPBKH98qFjhW7U=;
	b=m0RPxEvC20MFzJIVZ1w3gLFwtiiKskNXuWl7rh9d4xtuYo3mIN/uwe9qisNAYIyDwFwQ
	 vw1BDTpP8wlfI58a2spS/zVlvwZ1dmEiDOfp3/gwyd24yqWNC/QBed5mG2S/tWm/aGrFv
	 KuZMF4w2v1Db4aY1r55faclXsOIP5tZ6TeEcCOSKHrQ5GkOVGBTY6wIumVf9glM0edL8A
	 F1TJVbyAWdSeQwecIT3GnX2u4ViFqJwAJyCi0soaKxwNCamB2oha4yIZA0LlwW0Qqrwxr
	 iuwroVpsd2kRXsl1Uh5rYDFc9WeSL7STFFyxemo9KiagszOBUkRMj/vGtTrOQzsq8Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FmIQR834;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77002606A32C;
	Sat,  7 Nov 2026 15:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FmIQR834
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0021C1F0089F;
	Sat,  7 Nov 2026 15:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065528;
	bh=dy3mNYETJb+hCoEfaBhRgb2EQ4lE4mPBKH98qFjhW7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FmIQR834WoLoYqd5FAmrXHFt1jyDb8Oni8Xhv8F641oPAGDGxbfc8X4UoyTF2TrPv
	 auA+8iXou1e9Fs3c2E3CH/Mco1Bcamk2n6r6NpeKOK7CZh4MHo++p9gezuPEEKoveP
	 3kVKLsiO9jK/Vey4RlrZzlGvwz8H9GrIWEVyC2Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1169/1257] LoongArch: Only send SIGTRAP signal if necessary in do_watch()
Date: Sat,  7 Nov 2026 08:57:45 -0500
Message-ID: <20261107135011.470194948@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c4d7e55fb3ea5..20ce2c8d77a16 100644
--- a/arch/loongarch/kernel/traps.c
+++ b/arch/loongarch/kernel/traps.c
@@ -815,6 +815,8 @@ asmlinkage void noinstr do_watch(struct pt_regs *regs)
 #ifndef CONFIG_HAVE_HW_BREAKPOINT
 	pr_warn("Hardware watch point handler not implemented!\n");
 #else
+	bool need_sigtrap = !!current->ptrace;
+
 	if (kgdb_breakpoint_handler(regs))
 		goto out;
 
@@ -851,11 +853,12 @@ asmlinkage void noinstr do_watch(struct pt_regs *regs)
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



