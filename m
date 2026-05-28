Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CC92580D7;
	Thu, 28 May 2026 20:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999479; cv=none; b=J2KQVDjGZixspSqhUmSciIwOvPLZ9dreYiBF6obz3pSSE6eWz/mT9YlXxvhXZcnd/+2Do7XqNgeo4j1uzfjaCmi6XL+sv0xovftxbEC/JYIbS7rc34+e4zB+hkphVWl83I37iwlhahOdNbWLkb9SKA2ocivbEOpNwyAQC27Hq6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999479; c=relaxed/simple;
	bh=9/segINcuyHiXILb/V+RMTzWmZFBKx//b9imjimG/tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIGP4+emFyf0fOeDJ/tRx+lBpENPOOtaMNBRH2qXg1OLR4EIYtOB6z7+mYIUazOgI4EXmW4uaKQ24mi7nPyqtgVKPs8sh2MwM6VwX7vUS3rk/a4SZtRxkVzx51QYVIc6wJLlkcJSqJeTwIhb65PEtyyeXWUEhuvual5fcVCM3TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjfXBZYw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjfXBZYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4524B1F00A3A;
	Thu, 28 May 2026 20:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999477;
	bh=pwDOrXiBZfr7rMCMCfnw+HBKVeXy5oWtVPFJifE1gRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cjfXBZYwRap1fy4pZA1NZC8G1GTnlhpdI/EWHo3Omtl1YJGR5bMZWJijdnbUyB6Cu
	 zBXRquIMRFiHlM7BfTM2x2Gaeo0xIwRa5loJgash9lf0YuMDglWcR8K8F9SQdIa7pY
	 rPZL35CYHbWSbvpGvSj1p7PV1HYjDvZ6mrqkgTfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ian Rogers <irogers@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 082/377] ring-buffer: Flush and stop persistent ring buffer on panic
Date: Thu, 28 May 2026 21:45:20 +0200
Message-ID: <20260528194640.751461349@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit a494d3c8d5392bcdff83c2a593df0c160ff9f322 upstream.

On real hardware, panic and machine reboot may not flush hardware cache
to memory. This means the persistent ring buffer, which relies on a
coherent state of memory, may not have its events written to the buffer
and they may be lost. Moreover, there may be inconsistency with the
counters which are used for validation of the integrity of the
persistent ring buffer which may cause all data to be discarded.

To avoid this issue, stop recording of the ring buffer on panic and
flush the cache of the ring buffer's memory.

Fixes: e645535a954a ("tracing: Add option to use memmapped memory for trace boot instance")
Cc: stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ian Rogers <irogers@google.com>
Link: https://patch.msgid.link/177751969602.2136606.12031934362587643488.stgit@mhiramat.tok.corp.google.com
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/include/asm/Kbuild        |    1 +
 arch/arc/include/asm/Kbuild          |    1 +
 arch/arm/include/asm/Kbuild          |    1 +
 arch/arm64/include/asm/ring_buffer.h |   10 ++++++++++
 arch/csky/include/asm/Kbuild         |    1 +
 arch/hexagon/include/asm/Kbuild      |    1 +
 arch/loongarch/include/asm/Kbuild    |    1 +
 arch/m68k/include/asm/Kbuild         |    1 +
 arch/microblaze/include/asm/Kbuild   |    1 +
 arch/mips/include/asm/Kbuild         |    1 +
 arch/nios2/include/asm/Kbuild        |    1 +
 arch/openrisc/include/asm/Kbuild     |    1 +
 arch/parisc/include/asm/Kbuild       |    1 +
 arch/powerpc/include/asm/Kbuild      |    1 +
 arch/riscv/include/asm/Kbuild        |    1 +
 arch/s390/include/asm/Kbuild         |    1 +
 arch/sh/include/asm/Kbuild           |    1 +
 arch/sparc/include/asm/Kbuild        |    1 +
 arch/um/include/asm/Kbuild           |    1 +
 arch/x86/include/asm/Kbuild          |    1 +
 arch/xtensa/include/asm/Kbuild       |    1 +
 include/asm-generic/ring_buffer.h    |   13 +++++++++++++
 kernel/trace/ring_buffer.c           |   22 ++++++++++++++++++++++
 23 files changed, 65 insertions(+)
 create mode 100644 arch/arm64/include/asm/ring_buffer.h
 create mode 100644 include/asm-generic/ring_buffer.h

--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -5,4 +5,5 @@ generic-y += agp.h
 generic-y += asm-offsets.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
+generic-y += ring_buffer.h
 generic-y += text-patching.h
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -5,5 +5,6 @@ generic-y += extable.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += parport.h
+generic-y += ring_buffer.h
 generic-y += user.h
 generic-y += text-patching.h
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -3,6 +3,7 @@ generic-y += early_ioremap.h
 generic-y += extable.h
 generic-y += flat.h
 generic-y += parport.h
+generic-y += ring_buffer.h
 
 generated-y += mach-types.h
 generated-y += unistd-nr.h
--- /dev/null
+++ b/arch/arm64/include/asm/ring_buffer.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASM_ARM64_RING_BUFFER_H
+#define _ASM_ARM64_RING_BUFFER_H
+
+#include <asm/cacheflush.h>
+
+/* Flush D-cache on persistent ring buffer */
+#define arch_ring_buffer_flush_range(start, end)	dcache_clean_pop(start, end)
+
+#endif /* _ASM_ARM64_RING_BUFFER_H */
--- a/arch/csky/include/asm/Kbuild
+++ b/arch/csky/include/asm/Kbuild
@@ -9,6 +9,7 @@ generic-y += qrwlock.h
 generic-y += qrwlock_types.h
 generic-y += qspinlock.h
 generic-y += parport.h
+generic-y += ring_buffer.h
 generic-y += user.h
 generic-y += vmlinux.lds.h
 generic-y += text-patching.h
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -5,4 +5,5 @@ generic-y += extable.h
 generic-y += iomap.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
+generic-y += ring_buffer.h
 generic-y += text-patching.h
--- a/arch/loongarch/include/asm/Kbuild
+++ b/arch/loongarch/include/asm/Kbuild
@@ -9,5 +9,6 @@ generic-y += qrwlock.h
 generic-y += user.h
 generic-y += ioctl.h
 generic-y += mmzone.h
+generic-y += ring_buffer.h
 generic-y += statfs.h
 generic-y += text-patching.h
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -3,5 +3,6 @@ generated-y += syscall_table.h
 generic-y += extable.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
+generic-y += ring_buffer.h
 generic-y += spinlock.h
 generic-y += text-patching.h
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -5,6 +5,7 @@ generic-y += extable.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += parport.h
+generic-y += ring_buffer.h
 generic-y += syscalls.h
 generic-y += tlb.h
 generic-y += user.h
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -12,5 +12,6 @@ generic-y += mcs_spinlock.h
 generic-y += parport.h
 generic-y += qrwlock.h
 generic-y += qspinlock.h
+generic-y += ring_buffer.h
 generic-y += user.h
 generic-y += text-patching.h
--- a/arch/nios2/include/asm/Kbuild
+++ b/arch/nios2/include/asm/Kbuild
@@ -5,6 +5,7 @@ generic-y += cmpxchg.h
 generic-y += extable.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
+generic-y += ring_buffer.h
 generic-y += spinlock.h
 generic-y += user.h
 generic-y += text-patching.h
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -8,4 +8,5 @@ generic-y += spinlock_types.h
 generic-y += spinlock.h
 generic-y += qrwlock_types.h
 generic-y += qrwlock.h
+generic-y += ring_buffer.h
 generic-y += user.h
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -4,4 +4,5 @@ generated-y += syscall_table_64.h
 generic-y += agp.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
+generic-y += ring_buffer.h
 generic-y += user.h
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -5,4 +5,5 @@ generated-y += syscall_table_spu.h
 generic-y += agp.h
 generic-y += mcs_spinlock.h
 generic-y += qrwlock.h
+generic-y += ring_buffer.h
 generic-y += early_ioremap.h
--- a/arch/riscv/include/asm/Kbuild
+++ b/arch/riscv/include/asm/Kbuild
@@ -14,5 +14,6 @@ generic-y += ticket_spinlock.h
 generic-y += qrwlock.h
 generic-y += qrwlock_types.h
 generic-y += qspinlock.h
+generic-y += ring_buffer.h
 generic-y += user.h
 generic-y += vmlinux.lds.h
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -8,3 +8,4 @@ generic-y += asm-offsets.h
 generic-y += kvm_types.h
 generic-y += mcs_spinlock.h
 generic-y += mmzone.h
+generic-y += ring_buffer.h
--- a/arch/sh/include/asm/Kbuild
+++ b/arch/sh/include/asm/Kbuild
@@ -3,4 +3,5 @@ generated-y += syscall_table.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += parport.h
+generic-y += ring_buffer.h
 generic-y += text-patching.h
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -4,4 +4,5 @@ generated-y += syscall_table_64.h
 generic-y += agp.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
+generic-y += ring_buffer.h
 generic-y += text-patching.h
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -18,6 +18,7 @@ generic-y += module.lds.h
 generic-y += parport.h
 generic-y += percpu.h
 generic-y += preempt.h
+generic-y += ring_buffer.h
 generic-y += runtime-const.h
 generic-y += softirq_stack.h
 generic-y += switch_to.h
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -14,3 +14,4 @@ generic-y += early_ioremap.h
 generic-y += fprobe.h
 generic-y += mcs_spinlock.h
 generic-y += mmzone.h
+generic-y += ring_buffer.h
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -6,5 +6,6 @@ generic-y += mcs_spinlock.h
 generic-y += parport.h
 generic-y += qrwlock.h
 generic-y += qspinlock.h
+generic-y += ring_buffer.h
 generic-y += user.h
 generic-y += text-patching.h
--- /dev/null
+++ b/include/asm-generic/ring_buffer.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Generic arch dependent ring_buffer macros.
+ */
+#ifndef __ASM_GENERIC_RING_BUFFER_H__
+#define __ASM_GENERIC_RING_BUFFER_H__
+
+#include <linux/cacheflush.h>
+
+/* Flush cache on ring buffer range if needed. Do nothing by default. */
+#define arch_ring_buffer_flush_range(start, end)	do { } while (0)
+
+#endif /* __ASM_GENERIC_RING_BUFFER_H__ */
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2008 Steven Rostedt <srostedt@redhat.com>
  */
 #include <linux/trace_recursion.h>
+#include <linux/panic_notifier.h>
 #include <linux/trace_events.h>
 #include <linux/ring_buffer.h>
 #include <linux/trace_clock.h>
@@ -29,6 +30,7 @@
 #include <linux/oom.h>
 #include <linux/mm.h>
 
+#include <asm/ring_buffer.h>
 #include <asm/local64.h>
 #include <asm/local.h>
 #include <asm/setup.h>
@@ -553,6 +555,7 @@ struct trace_buffer {
 
 	unsigned long			range_addr_start;
 	unsigned long			range_addr_end;
+	struct notifier_block		flush_nb;
 
 	struct ring_buffer_meta		*meta;
 
@@ -2455,6 +2458,16 @@ static void rb_free_cpu_buffer(struct ri
 	kfree(cpu_buffer);
 }
 
+/* Stop recording on a persistent buffer and flush cache if needed. */
+static int rb_flush_buffer_cb(struct notifier_block *nb, unsigned long event, void *data)
+{
+	struct trace_buffer *buffer = container_of(nb, struct trace_buffer, flush_nb);
+
+	ring_buffer_record_off(buffer);
+	arch_ring_buffer_flush_range(buffer->range_addr_start, buffer->range_addr_end);
+	return NOTIFY_DONE;
+}
+
 static struct trace_buffer *alloc_buffer(unsigned long size, unsigned flags,
 					 int order, unsigned long start,
 					 unsigned long end,
@@ -2574,6 +2587,12 @@ static struct trace_buffer *alloc_buffer
 
 	mutex_init(&buffer->mutex);
 
+	/* Persistent ring buffer needs to flush cache before reboot. */
+	if (start && end) {
+		buffer->flush_nb.notifier_call = rb_flush_buffer_cb;
+		atomic_notifier_chain_register(&panic_notifier_list, &buffer->flush_nb);
+	}
+
 	return_ptr(buffer);
 
  fail_free_buffers:
@@ -2661,6 +2680,9 @@ ring_buffer_free(struct trace_buffer *bu
 {
 	int cpu;
 
+	if (buffer->range_addr_start && buffer->range_addr_end)
+		atomic_notifier_chain_unregister(&panic_notifier_list, &buffer->flush_nb);
+
 	cpuhp_state_remove_instance(CPUHP_TRACE_RB_PREPARE, &buffer->node);
 
 	irq_work_sync(&buffer->irq_work.work);


