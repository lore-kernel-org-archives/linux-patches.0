Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7A726ED5D;
	Sun,  7 Jun 2026 11:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830088; cv=none; b=IzvWkOVrEEKI7ntWKt+UAIUFFeBQp5d0VkDOxb6+UnAfete/B2sXccSWADf7n98+/7oWZxqinv6DcUA65gJqQsjr5/XZteym5ZklGoS1nRJsiMtsqsMHU5MEh+EID+N8pcjmbbuVBo5U4t0dgXmSrOkKmQYcLjw6EhEmfKxbzKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830088; c=relaxed/simple;
	bh=o7/BgE+76qSGZoefPh+RPxNdKKaYc0iKDc6vIH6b4hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYtCb6dUDtQZY28qPMFRd0X1lB4nCTuJzj5FCW0sMxho5akx6lPqKrj9ntLFcf0EEiDnAUB/aYMva8Y6P/PMwwPdSl2ePUwv6U7YUROBfCQtviiBGt1AbG/jqNu16jrDYXQl8xm3NDVolU0BbJ81ZADffB85R2yN/wF1vdJ3m8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oklbvcLH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oklbvcLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD901F00893;
	Sun,  7 Jun 2026 11:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830087;
	bh=UbJIjrkhcDK0+G7ASX0fT+fzBppASnfPMtl7d9Cz7Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oklbvcLHGk6j3+33ttQxVnIfFb5a0Q7XBUJ1UkUE6cQTvAO72rmjQVWcSHduQRoqi
	 RnjEZ/KWq+RB6MFc8STvou90GQto7EH6WoJ9Zc2g7VQ4iW57jhnqbzuaSkRC68u2ES
	 COvzMSQw0tPJpn3qC+WICbWPtvF+XB/q/kY7QQKM=
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
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 281/307] ring-buffer: Flush and stop persistent ring buffer on panic
Date: Sun,  7 Jun 2026 12:01:18 +0200
Message-ID: <20260607095738.049064374@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

[ Upstream commit a494d3c8d5392bcdff83c2a593df0c160ff9f322 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
@@ -5,3 +5,4 @@ generic-y += agp.h
 generic-y += asm-offsets.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
+generic-y += ring_buffer.h
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -5,4 +5,5 @@ generic-y += extable.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += parport.h
+generic-y += ring_buffer.h
 generic-y += user.h
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
@@ -9,5 +9,6 @@ generic-y += qrwlock.h
 generic-y += qrwlock_types.h
 generic-y += qspinlock.h
 generic-y += parport.h
+generic-y += ring_buffer.h
 generic-y += user.h
 generic-y += vmlinux.lds.h
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -5,3 +5,4 @@ generic-y += extable.h
 generic-y += iomap.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
+generic-y += ring_buffer.h
--- a/arch/loongarch/include/asm/Kbuild
+++ b/arch/loongarch/include/asm/Kbuild
@@ -9,5 +9,6 @@ generic-y += qrwlock.h
 generic-y += user.h
 generic-y += ioctl.h
 generic-y += mmzone.h
+generic-y += ring_buffer.h
 generic-y += statfs.h
 generic-y += param.h
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -3,4 +3,5 @@ generated-y += syscall_table.h
 generic-y += extable.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
+generic-y += ring_buffer.h
 generic-y += spinlock.h
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
@@ -12,4 +12,5 @@ generic-y += mcs_spinlock.h
 generic-y += parport.h
 generic-y += qrwlock.h
 generic-y += qspinlock.h
+generic-y += ring_buffer.h
 generic-y += user.h
--- a/arch/nios2/include/asm/Kbuild
+++ b/arch/nios2/include/asm/Kbuild
@@ -5,5 +5,6 @@ generic-y += cmpxchg.h
 generic-y += extable.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
+generic-y += ring_buffer.h
 generic-y += spinlock.h
 generic-y += user.h
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
@@ -6,4 +6,5 @@ generic-y += agp.h
 generic-y += kvm_types.h
 generic-y += mcs_spinlock.h
 generic-y += qrwlock.h
+generic-y += ring_buffer.h
 generic-y += early_ioremap.h
--- a/arch/riscv/include/asm/Kbuild
+++ b/arch/riscv/include/asm/Kbuild
@@ -11,5 +11,6 @@ generic-y += spinlock.h
 generic-y += spinlock_types.h
 generic-y += qrwlock.h
 generic-y += qrwlock_types.h
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
@@ -3,3 +3,4 @@ generated-y += syscall_table.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += parport.h
+generic-y += ring_buffer.h
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -4,3 +4,4 @@ generated-y += syscall_table_64.h
 generic-y += agp.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
+generic-y += ring_buffer.h
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -19,6 +19,7 @@ generic-y += param.h
 generic-y += parport.h
 generic-y += percpu.h
 generic-y += preempt.h
+generic-y += ring_buffer.h
 generic-y += runtime-const.h
 generic-y += softirq_stack.h
 generic-y += switch_to.h
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -12,3 +12,4 @@ generated-y += xen-hypercalls.h
 generic-y += early_ioremap.h
 generic-y += mcs_spinlock.h
 generic-y += mmzone.h
+generic-y += ring_buffer.h
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -7,4 +7,5 @@ generic-y += param.h
 generic-y += parport.h
 generic-y += qrwlock.h
 generic-y += qspinlock.h
+generic-y += ring_buffer.h
 generic-y += user.h
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
 
@@ -549,6 +551,7 @@ struct trace_buffer {
 
 	unsigned long			range_addr_start;
 	unsigned long			range_addr_end;
+	struct notifier_block		flush_nb;
 
 	long				last_text_delta;
 	long				last_data_delta;
@@ -2316,6 +2319,16 @@ static void rb_free_cpu_buffer(struct ri
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
@@ -2421,6 +2434,12 @@ static struct trace_buffer *alloc_buffer
 
 	mutex_init(&buffer->mutex);
 
+	/* Persistent ring buffer needs to flush cache before reboot. */
+	if (start && end) {
+		buffer->flush_nb.notifier_call = rb_flush_buffer_cb;
+		atomic_notifier_chain_register(&panic_notifier_list, &buffer->flush_nb);
+	}
+
 	return buffer;
 
  fail_free_buffers:
@@ -2512,6 +2531,9 @@ ring_buffer_free(struct trace_buffer *bu
 {
 	int cpu;
 
+	if (buffer->range_addr_start && buffer->range_addr_end)
+		atomic_notifier_chain_unregister(&panic_notifier_list, &buffer->flush_nb);
+
 	cpuhp_state_remove_instance(CPUHP_TRACE_RB_PREPARE, &buffer->node);
 
 	irq_work_sync(&buffer->irq_work.work);


