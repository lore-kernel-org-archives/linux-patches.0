Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590739;
	b=pjMfrQuM6oDs8EWnrKfumCWCRs4ZCRQNQJFUuq5+HD+c/znLwf5S0DrWdRy/Hx64T8PW
	 zQ1coOHx2SGWyzZEPkB8d83NqArTtha1Nc7Wh/iu41N6PCdYRMTHDBQo9yYJJ5u2qKfe/
	 GH8v900gITrkKax717MG2k4RuWBhKKuIDI1YI1zIZ3SNXIACiJF7D0WuFnsRmL44Y+Tlc
	 77472N8mFyc7iBjH/3x7X7kBn9jW4i/f4tK9J+3nqRue498plYRAE7hYZb8yfiqpuNblI
	 BfXKQ6CKZe37t/2YbIDc9n3okqs/spqore2588ynsP7R4wT3P4sid5LYV4csTi0oFgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RWzT0t0VAoZAhqCoLQbmsAm4GctgfKv6MyY1kx4aRmc=;
	b=tQrj17enMfNMUlJUkVZ+nM/infdYrj1JobLsQdaAa7hBSPj+pVPi25u1WyXhWzbmfy4y
	 6MDZURHsFYj2UBiuEDB/h1jb2tlAEzqbEbtz1aMsqhL9L8Q3yrQTikSPnHhKnX/sG533D
	 nAcB7DWg7tM4HpgVds7a/IURNF/KAmhblU7NtqPLZnpAqBZYaR1vJgyM27V71Sy6yksZN
	 aW0g/CKNys5P+DMWBWs9rUf2eTzcRrZtn4vM3fkIaVcd+tv7EO8UuueQ08uOui4GXoLD3
	 2bKm2pEN34E5uJ4amuHHFoGQmqOR5R05ZJhISsPNWlZ6JozpJmFNzpf4ca6CYEQPf6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uxbkP7kF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3FD607B5A3;
	Fri, 13 Nov 2026 17:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uxbkP7kF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7A01F000C6;
	Fri, 13 Nov 2026 17:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590739;
	bh=RWzT0t0VAoZAhqCoLQbmsAm4GctgfKv6MyY1kx4aRmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uxbkP7kFCLEkm0zYiil2aNky7EWDNMsiWGvUWNwGUsHauRG1KhU6lKOivsZxz+OUv
	 lL4IZ9PGl5La8w2Fq3FmNOGqP+BdZI9/8An5+k1SMt2PrrzquMyyJjKs5zOjTEOZRp
	 ElAa6vAA5tOSB0zgJbAVGbq0019GKavPtaSYIAHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 640/686] LoongArch: Fix one-shot limitation for perf hardware breakpoints
Date: Fri, 13 Nov 2026 10:52:53 -0500
Message-ID: <20261113153843.482562469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 5e0b00fd000a53a5428fed6c96be74019bd0ad17 ]

In breakpoint_handler() and watchpoint_handler(), the code disables the
hardware slot by executing update_bp_registers(regs, 0, ...). This design
forces the active hardware breakpoint configuration to be wiped out upon
its first hit, turning standard perf hardware breakpoints into "one-shot"
events.

Furthermore, while the ptrace single-step path in do_watch() executes a
hardware single-step skip mechanism to advance the PC, the standard perf
path lacks any mechanism to bypass the original triggering instruction.

To maintain the long-term persistence of hardware breakpoints for perf
usage, eliminate the disruptive calls to update_bp_registers() within
the handler loops to keep the breakpoint configuration enabled.

Concurrently, execute a single, unified register write outside the loop
to atomize the state transition and explicitly enforce the hardware skip
mechanism once per exception return, ensuring the processor safely steps
forward without lockups.

Meanwhile, in order to prevent status contamination during single-core
context switches or cross-core thread migrations, the hardware register
skip state of the previous thread is saved first. Then, the skip state
is restored and its software skip flag is also cleared only if the next
thread has the skip flag; otherwise, 0 is written to clear the FWPS and
MWPS registers, which explicitly clears the skip bit according to the
architectural specification.

Additionally, explicitly clear hbp_break_skip and hbp_watch_skip inside
ptrace_hw_copy_thread() which is called by copy_thread() during the task
creation. This guarantees that a newly cloned child task starts with a
clean slate.

Here is a user-space reproducer to demonstrate the issue.

(1) Test program (test_perf_continuous.c):

  #include <stdio.h>
  #include <unistd.h>
  #include <sys/syscall.h>
  #include <sys/ioctl.h>
  #include <linux/perf_event.h>
  #include <linux/hw_breakpoint.h>

  static int var = 0;

  int main(void)
  {
  	size_t count = 0;
  	struct perf_event_attr attr = {
  		.type = PERF_TYPE_BREAKPOINT,
  		.size = sizeof(attr),
  		.bp_type = HW_BREAKPOINT_W,
  		.bp_addr = (unsigned long)&var,
  		.bp_len = HW_BREAKPOINT_LEN_1,
  		.exclude_kernel = 1,
  	};

  	int fd = syscall(__NR_perf_event_open, &attr, 0, -1, -1, 0);
  	ioctl(fd, PERF_EVENT_IOC_ENABLE, 0);

  	asm volatile("st.b %1, %0" : "=m"(var) : "r"(11) : "memory");
  	asm volatile("st.b %1, %0" : "=m"(var) : "r"(22) : "memory");
  	asm volatile("st.b %1, %0" : "=m"(var) : "r"(33) : "memory");

  	ioctl(fd, PERF_EVENT_IOC_DISABLE, 0);
  	read(fd, &count, sizeof(size_t));

  	printf("Watchpoint counts: expected = 3, actual = %zu\n", count);

  	close(fd);
  	return 0;
  }

(2) Test steps:

  $ gcc test_perf_continuous.c -o test_perf_continuous
  $ ./test_perf_continuous

(3) Test results:

Without this patch:

  Watchpoint counts: expected = 3, actual = 1

With this patch:

  Watchpoint counts: expected = 3, actual = 3

Cc: stable@vger.kernel.org
Fixes: 3eb2a8b23598 ("LoongArch: Fix multiple hardware watchpoint issues")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
[ sashal: Adjusted context to preserve the existing __switch_to() call passing task_thread_info(next). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/hw_breakpoint.h |  4 +--
 arch/loongarch/include/asm/loongarch.h     |  3 ++
 arch/loongarch/include/asm/processor.h     |  1 +
 arch/loongarch/include/asm/switch_to.h     |  2 +-
 arch/loongarch/kernel/hw_breakpoint.c      | 39 +++++++++++++++++++---
 5 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/arch/loongarch/include/asm/hw_breakpoint.h b/arch/loongarch/include/asm/hw_breakpoint.h
index d202052df8a16..f4478936787d6 100644
--- a/arch/loongarch/include/asm/hw_breakpoint.h
+++ b/arch/loongarch/include/asm/hw_breakpoint.h
@@ -121,12 +121,12 @@ bool watchpoint_handler(struct pt_regs *regs);
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 extern void ptrace_hw_copy_thread(struct task_struct *task);
-extern void hw_breakpoint_thread_switch(struct task_struct *next);
+extern void hw_breakpoint_thread_switch(struct task_struct *prev, struct task_struct *next);
 #else
 static inline void ptrace_hw_copy_thread(struct task_struct *task)
 {
 }
-static inline void hw_breakpoint_thread_switch(struct task_struct *next)
+static inline void hw_breakpoint_thread_switch(struct task_struct *prev, struct task_struct *next)
 {
 }
 #endif
diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index 642dc9adddceb..9a85227ed84ca 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -1093,6 +1093,9 @@
 #define CSR_FWPS_SKIP_SHIFT		16
 #define CSR_FWPS_SKIP			(_ULCAST_(1) << CSR_FWPS_SKIP_SHIFT)
 
+#define CSR_MWPS_SKIP_SHIFT		16
+#define CSR_MWPS_SKIP			(_ULCAST_(1) << CSR_MWPS_SKIP_SHIFT)
+
 /*
  * CSR_ECFG IM
  */
diff --git a/arch/loongarch/include/asm/processor.h b/arch/loongarch/include/asm/processor.h
index c3bc44b5f5b30..81af48cbee7b9 100644
--- a/arch/loongarch/include/asm/processor.h
+++ b/arch/loongarch/include/asm/processor.h
@@ -138,6 +138,7 @@ struct thread_struct {
 	struct loongarch_lbt lbt; /* Also conditionally copied */
 
 	/* Hardware breakpoints pinned to this task. */
+	bool hbp_break_skip, hbp_watch_skip;
 	struct perf_event *hbp_break[LOONGARCH_MAX_BRP];
 	struct perf_event *hbp_watch[LOONGARCH_MAX_WRP];
 };
diff --git a/arch/loongarch/include/asm/switch_to.h b/arch/loongarch/include/asm/switch_to.h
index 5b225aff3ba21..3b662b18e19a6 100644
--- a/arch/loongarch/include/asm/switch_to.h
+++ b/arch/loongarch/include/asm/switch_to.h
@@ -36,7 +36,7 @@ extern asmlinkage struct task_struct *__switch_to(struct task_struct *prev,
 do {										\
 	lose_fpu_inatomic(1, prev);						\
 	lose_lbt_inatomic(1, prev);						\
-	hw_breakpoint_thread_switch(next);					\
+	hw_breakpoint_thread_switch(prev, next);				\
 	(last) = __switch_to(prev, next, task_thread_info(next),		\
 		 __builtin_return_address(0), __builtin_frame_address(0));	\
 } while (0)
diff --git a/arch/loongarch/kernel/hw_breakpoint.c b/arch/loongarch/kernel/hw_breakpoint.c
index 1a05350159f7b..df149ff06dd50 100644
--- a/arch/loongarch/kernel/hw_breakpoint.c
+++ b/arch/loongarch/kernel/hw_breakpoint.c
@@ -156,6 +156,9 @@ static int hw_breakpoint_slot_setup(struct perf_event **slots, int max_slots,
 
 void ptrace_hw_copy_thread(struct task_struct *tsk)
 {
+	tsk->thread.hbp_break_skip = 0;
+	tsk->thread.hbp_watch_skip = 0;
+
 	memset(tsk->thread.hbp_break, 0, sizeof(tsk->thread.hbp_break));
 	memset(tsk->thread.hbp_watch, 0, sizeof(tsk->thread.hbp_watch));
 }
@@ -485,6 +488,7 @@ NOKPROBE_SYMBOL(update_bp_registers);
 bool breakpoint_handler(struct pt_regs *regs)
 {
 	int i;
+	unsigned int clear_mask = 0;
 	bool need_sigtrap = false;
 	struct perf_event *bp, **slots;
 
@@ -500,11 +504,13 @@ bool breakpoint_handler(struct pt_regs *regs)
 			if (bp->attr.sigtrap)
 				need_sigtrap = true;
 
-			csr_write32(0x1 << i, LOONGARCH_CSR_FWPS);
-			update_bp_registers(regs, 0, 0);
+			clear_mask |= (0x1 << i);
 		}
 	}
 
+	if (clear_mask)
+		csr_write32(clear_mask | CSR_FWPS_SKIP, LOONGARCH_CSR_FWPS);
+
 	return need_sigtrap;
 }
 NOKPROBE_SYMBOL(breakpoint_handler);
@@ -512,6 +518,7 @@ NOKPROBE_SYMBOL(breakpoint_handler);
 bool watchpoint_handler(struct pt_regs *regs)
 {
 	int i;
+	unsigned int clear_mask = 0;
 	bool need_sigtrap = false;
 	struct perf_event *wp, **slots;
 
@@ -527,11 +534,13 @@ bool watchpoint_handler(struct pt_regs *regs)
 			if (wp->attr.sigtrap)
 				need_sigtrap = true;
 
-			csr_write32(0x1 << i, LOONGARCH_CSR_MWPS);
-			update_bp_registers(regs, 0, 1);
+			clear_mask |= (0x1 << i);
 		}
 	}
 
+	if (clear_mask)
+		csr_write32(clear_mask | CSR_MWPS_SKIP, LOONGARCH_CSR_MWPS);
+
 	return need_sigtrap;
 }
 NOKPROBE_SYMBOL(watchpoint_handler);
@@ -555,7 +564,7 @@ static int __init arch_hw_breakpoint_init(void)
 }
 arch_initcall(arch_hw_breakpoint_init);
 
-void hw_breakpoint_thread_switch(struct task_struct *next)
+void hw_breakpoint_thread_switch(struct task_struct *prev, struct task_struct *next)
 {
 	u64 addr, mask;
 	struct pt_regs *regs = task_pt_regs(next);
@@ -567,6 +576,26 @@ void hw_breakpoint_thread_switch(struct task_struct *next)
 			csr_write32(CSR_FWPS_SKIP, LOONGARCH_CSR_FWPS);
 		regs->csr_prmd |= CSR_PRMD_PWE;
 	} else {
+		unsigned int fwps = csr_read32(LOONGARCH_CSR_FWPS);
+		unsigned int mwps = csr_read32(LOONGARCH_CSR_MWPS);
+
+		prev->thread.hbp_break_skip = !!(fwps & CSR_FWPS_SKIP);
+		prev->thread.hbp_watch_skip = !!(mwps & CSR_MWPS_SKIP);
+
+		if (!next->thread.hbp_break_skip)
+			csr_write32(0, LOONGARCH_CSR_FWPS);
+		else {
+			csr_write32(CSR_FWPS_SKIP, LOONGARCH_CSR_FWPS);
+			next->thread.hbp_break_skip = 0;
+		}
+
+		if (!next->thread.hbp_watch_skip)
+			csr_write32(0, LOONGARCH_CSR_MWPS);
+		else {
+			csr_write32(CSR_MWPS_SKIP, LOONGARCH_CSR_MWPS);
+			next->thread.hbp_watch_skip = 0;
+		}
+
 		/* Update breakpoints */
 		update_bp_registers(regs, 1, 0);
 		/* Update watchpoints */
-- 
2.53.0



