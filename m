Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C158233716;
	Mon, 10 Mar 2025 17:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627922; cv=none; b=eVlFwPPlchYF2EF6PssWPmbmYxpd5bl8RBvcHQ9H83gXbq5+8PYKnxU5sDV2EgEJ7oRX5pbGqMtJfEyZIVH7UvLDXnC8Xy2j3emLGPcM3Z/lKCtlt53kGGS25c6Kg6EhhzbFuellefVe0pgOg7b3bA0nN8O+zjIu3zIuKxt2DVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627922; c=relaxed/simple;
	bh=8rqbmhdA16jeLud7fwaukdu4HFmTm51OCf2jijtfnDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2mMgpwAz1S+XFa1CRKn2JQWWxW70nc9nbldWAjYy76C09gpo+7eHkWr4KbCj5vZlSeUAQgK27ifGclZX5iYwC4u8i5t+Y9nRRrtXODqpYqLE3l84YW2XV0An6Yil0WSAM8uu1t9U3/SR0pWMQqG0/Ut6/iUECHjoFfxYdso7Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1sJyy/py; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1sJyy/py"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7788C4CEE5;
	Mon, 10 Mar 2025 17:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627922;
	bh=8rqbmhdA16jeLud7fwaukdu4HFmTm51OCf2jijtfnDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1sJyy/pyclEyoBVIV6roQTZDaPb1kZgRR3ZRrX938ciyK9JtTFrYNt6OMdSN/mo2s
	 0AU4tqL5N60t3P+KgVEK0KWMdDlMCmx1DXxtxu4NZbj/fdGWgREJH/dFp3E9fOP2zO
	 H3mFfDadRGkq6znwXV/NyW7qnh2EPNqgm6XjZFyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erpeng Xu <xuerpeng@uniontech.com>,
	Yuli Wang <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 026/145] LoongArch: Use polling play_dead() when resuming from hibernation
Date: Mon, 10 Mar 2025 18:05:20 +0100
Message-ID: <20250310170435.793116925@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit c9117434c8f7523f0b77db4c5766f5011cc94677 upstream.

When CONFIG_RANDOM_KMALLOC_CACHES or other randomization infrastructrue
enabled, the idle_task's stack may different between the booting kernel
and target kernel. So when resuming from hibernation, an ACTION_BOOT_CPU
IPI wakeup the idle instruction in arch_cpu_idle_dead() and jump to the
interrupt handler. But since the stack pointer is changed, the interrupt
handler cannot restore correct context.

So rename the current arch_cpu_idle_dead() to idle_play_dead(), make it
as the default version of play_dead(), and the new arch_cpu_idle_dead()
call play_dead() directly. For hibernation, implement an arch-specific
hibernate_resume_nonboot_cpu_disable() to use the polling version (idle
instruction is replace by nop, and irq is disabled) of play_dead(), i.e.
poll_play_dead(), to avoid IPI handler corrupting the idle_task's stack
when resuming from hibernation.

This solution is a little similar to commit 406f992e4a372dafbe3c ("x86 /
hibernate: Use hlt_play_dead() when resuming from hibernation").

Cc: stable@vger.kernel.org
Tested-by: Erpeng Xu <xuerpeng@uniontech.com>
Tested-by: Yuli Wang <wangyuli@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/smp.c |   47 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

--- a/arch/loongarch/kernel/smp.c
+++ b/arch/loongarch/kernel/smp.c
@@ -18,6 +18,7 @@
 #include <linux/smp.h>
 #include <linux/threads.h>
 #include <linux/export.h>
+#include <linux/suspend.h>
 #include <linux/syscore_ops.h>
 #include <linux/time.h>
 #include <linux/tracepoint.h>
@@ -388,7 +389,7 @@ void loongson_cpu_die(unsigned int cpu)
 	mb();
 }
 
-void __noreturn arch_cpu_idle_dead(void)
+static void __noreturn idle_play_dead(void)
 {
 	register uint64_t addr;
 	register void (*init_fn)(void);
@@ -412,6 +413,50 @@ void __noreturn arch_cpu_idle_dead(void)
 	BUG();
 }
 
+#ifdef CONFIG_HIBERNATION
+static void __noreturn poll_play_dead(void)
+{
+	register uint64_t addr;
+	register void (*init_fn)(void);
+
+	idle_task_exit();
+	__this_cpu_write(cpu_state, CPU_DEAD);
+
+	__smp_mb();
+	do {
+		__asm__ __volatile__("nop\n\t");
+		addr = iocsr_read64(LOONGARCH_IOCSR_MBUF0);
+	} while (addr == 0);
+
+	init_fn = (void *)TO_CACHE(addr);
+	iocsr_write32(0xffffffff, LOONGARCH_IOCSR_IPI_CLEAR);
+
+	init_fn();
+	BUG();
+}
+#endif
+
+static void (*play_dead)(void) = idle_play_dead;
+
+void __noreturn arch_cpu_idle_dead(void)
+{
+	play_dead();
+	BUG(); /* play_dead() doesn't return */
+}
+
+#ifdef CONFIG_HIBERNATION
+int hibernate_resume_nonboot_cpu_disable(void)
+{
+	int ret;
+
+	play_dead = poll_play_dead;
+	ret = suspend_disable_secondary_cpus();
+	play_dead = idle_play_dead;
+
+	return ret;
+}
+#endif
+
 #endif
 
 /*


