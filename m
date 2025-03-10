Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE15A231A30;
	Mon, 10 Mar 2025 17:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626494; cv=none; b=QXQkIUzZKmhkTUUm/+otCULxP9h4biKsYSC1T0/uvMjfimWi51H0m5E4GUhws4vLke6qQqxWcyYo7F7rrlXaSQsW3hCx9XXUCOlkpFEkhNCva3N9koqPSq4lFsboPg/JzpNaH75dfioyVbda9VksKtT0wuBYq3pz97lw64iStjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626494; c=relaxed/simple;
	bh=tNnHXWV1c5/Uh6Pes2bJ9aR2gIm+mSr79ICLwMzSyY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzkaD5mV8n6xndqDBf+1sgPZuT0lbfm+VgkMqorpDtKllBerEEcHU6csZFc4cGfikEvhtodFeynjl1Z21nd2ITPYZJDjolthLcsCZsWUzCtPfxIB59+SmfOf6k4W3G0pE7NWcq1VWbSbzB3rIU/gKQ/lF7PvQ2POgA6W56Y7zfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7jZPFub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7jZPFub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3373EC4CEE5;
	Mon, 10 Mar 2025 17:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626494;
	bh=tNnHXWV1c5/Uh6Pes2bJ9aR2gIm+mSr79ICLwMzSyY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7jZPFubrMI251ah3nGfNBa69ofNOOBrRoyUQxfMwZXETZVoK5foM6fQTr+YgMyu2
	 CQAj+DbRGMPwqiXDZjPNi2bxpOXCqRE55prbUJJU9/WKvh7fZVlHIPgAIh+eXTdGtW
	 zbLKEbUHUsjzQhHiRl5HvFgsn+w+eqR9BZuSKj4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erpeng Xu <xuerpeng@uniontech.com>,
	Yuli Wang <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.13 012/207] LoongArch: Use polling play_dead() when resuming from hibernation
Date: Mon, 10 Mar 2025 18:03:25 +0100
Message-ID: <20250310170448.254364481@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -19,6 +19,7 @@
 #include <linux/smp.h>
 #include <linux/threads.h>
 #include <linux/export.h>
+#include <linux/suspend.h>
 #include <linux/syscore_ops.h>
 #include <linux/time.h>
 #include <linux/tracepoint.h>
@@ -423,7 +424,7 @@ void loongson_cpu_die(unsigned int cpu)
 	mb();
 }
 
-void __noreturn arch_cpu_idle_dead(void)
+static void __noreturn idle_play_dead(void)
 {
 	register uint64_t addr;
 	register void (*init_fn)(void);
@@ -447,6 +448,50 @@ void __noreturn arch_cpu_idle_dead(void)
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


