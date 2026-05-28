Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9632580D7;
	Thu, 28 May 2026 20:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999598; cv=none; b=npTjm0BupOfAtrrGUPUrC2JXPOKX4Qzvg5yCRQviZRYntLgsmcRD+FI+Mr3+b+Wygxp4QWPRyy/AzqBdCDgqZCrW9n5WoD3IgYb6W8HrHZQreGSGyN0joGifyZXYh8HR0NmiN8VaJe/n9VVs0bv32oF19WBbS8f8/vKcLI66pZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999598; c=relaxed/simple;
	bh=OtPvXg4jrgmxaiZ/BnQ98iJRwUdY4oayOwnXSdCpQv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSvE1tLlalUAKyy4sMJvGJrV2qxQbTYR8iJ4u+CVfkzKzPO4wdkvtjpte80yHyvTK32HQgoOIcWuhXV6Pq9y2RSNgwLJHbPdpppeqyZDDjd91DTgMb01Hgb/aI3EsrPE7RMvq+6m1K6D5W5aPDQPBx4NYIFG8rX6Ez/iSsvstQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPGOo64F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPGOo64F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA8C1F000E9;
	Thu, 28 May 2026 20:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999597;
	bh=DbdtBs3jP0BPLH/Kic1Gdin5KCSkUdWfqZYdJ3qXb54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zPGOo64Flcvc8ElAqSsPkwhwfCp9J4vw1S79iqncFsHvQ5ZWOkxUJMk46GlRG9vNx
	 4CASgC20ctp9GDqHVK1hhUjOc1UpEaZCTUte/Bvc+8pQK83KuLVx7O8xhZhB8AuJCt
	 hRcOFHk4aEJIsuelSBz1BT08WMdXKc059uPxg6Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 124/377] LoongArch: kprobes: Use larch_insn_text_copy() to patch instructions
Date: Thu, 28 May 2026 21:46:02 +0200
Message-ID: <20260528194641.935235732@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit e3ef9a28f558d1cbf0b42d6dcd16c60da557562b upstream.

On SMP systems, kprobe handlers would occasionally fail to execute on
certain CPU cores. The issue is hard to reproduce and typically occurs
randomly under high system load.

The root cause is a software-side instruction hazard. According to the
LoongArch Reference Manual, while the cache coherency is maintained by
hardware, software must explicitly use the "IBAR" instruction to ensure
the instruction fetch unit (IFU) observes the effects of recent stores.

The current arch_arm_kprobe() and arch_disarm_kprobe() only execute the
"IBAR" barrier (via flush_insn_slot -> local_flush_icache_range) on the
local CPU. This leaves a vulnerable window where remote CPU cores may
continue executing stale instructions from their pipelines or prefetch
buffers, as they have not executed an "IBAR" since the code modification.

Switch to larch_insn_text_copy() to fix this:
1. Synchronization: It uses stop_machine_cpuslocked() to synchronize all
   online CPUs, ensuring no CPU is executing the target code area during
   modification.
2. Visibility: By passing cpu_online_mask to stop_machine_cpuslocked(),
   the callback text_copy_cb() is executed on all online cores. Each CPU
   core invokes local_flush_icache_range() to execute "IBAR", clearing
   instruction hazards system-wide and ensuring the "break" instruction
   is visible to the fetch units of all cores.
3. Robustness: It properly manages memory write permissions (ROX/RW) for
   the kernel text segment during patching, ensuring compatibility with
   CONFIG_STRICT_KERNEL_RWX.

Cc: <stable@vger.kernel.org>  # 6.18+
Fixes: 6d4cc40fb5f5 ("LoongArch: Add kprobes support")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/kprobes.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/loongarch/kernel/kprobes.c
+++ b/arch/loongarch/kernel/kprobes.c
@@ -60,16 +60,18 @@ NOKPROBE_SYMBOL(arch_prepare_kprobe);
 /* Install breakpoint in text */
 void arch_arm_kprobe(struct kprobe *p)
 {
-	*p->addr = KPROBE_BP_INSN;
-	flush_insn_slot(p);
+	u32 insn = KPROBE_BP_INSN;
+
+	larch_insn_text_copy(p->addr, &insn, LOONGARCH_INSN_SIZE);
 }
 NOKPROBE_SYMBOL(arch_arm_kprobe);
 
 /* Remove breakpoint from text */
 void arch_disarm_kprobe(struct kprobe *p)
 {
-	*p->addr = p->opcode;
-	flush_insn_slot(p);
+	u32 insn = p->opcode;
+
+	larch_insn_text_copy(p->addr, &insn, LOONGARCH_INSN_SIZE);
 }
 NOKPROBE_SYMBOL(arch_disarm_kprobe);
 


