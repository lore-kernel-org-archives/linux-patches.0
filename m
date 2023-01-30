Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E751E28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD44C433EF;
	Mon, 30 Jan 2023 14:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087406;
	bh=PErPhc6FwlK5m7pwExcif+u7Q15JPcp5bbO4+O7OAVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blTAR46eWoy2ZooqtuDcdD20flGVxAju90LDdvcPoOfhbMHNBByzNS2JZaxY4dHjG
	 25xlovnfsERflWgYvdb4HzbbxKNLjBsEiI8GijPrsIflKz9iU9qSg0Fz/KCNlCSE/w
	 jde8j8b2/+xTAJxo8SA6KQ+IaCAT9smzXMNUMLJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 196/313] arm64: efi: Account for the EFI runtime stack in stack unwinder
Date: Mon, 30 Jan 2023 14:50:31 +0100
Message-Id: <20230130134345.829974922@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 7ea55715c421d22c1b63f7129cae6a654091b695 ]

The EFI runtime services run from a dedicated stack now, and so the
stack unwinder needs to be informed about this.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/stacktrace.h | 15 +++++++++++++++
 arch/arm64/kernel/stacktrace.c      | 12 ++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 5a0edb064ea4..327cdcfcb1db 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -104,4 +104,19 @@ static inline struct stack_info stackinfo_get_sdei_critical(void)
 #define stackinfo_get_sdei_critical()	stackinfo_get_unknown()
 #endif
 
+#ifdef CONFIG_EFI
+extern u64 *efi_rt_stack_top;
+
+static inline struct stack_info stackinfo_get_efi(void)
+{
+	unsigned long high = (u64)efi_rt_stack_top;
+	unsigned long low = high - THREAD_SIZE;
+
+	return (struct stack_info) {
+		.low = low,
+		.high = high,
+	};
+}
+#endif
+
 #endif	/* __ASM_STACKTRACE_H */
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 117e2c180f3c..83154303e682 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2012 ARM Ltd.
  */
 #include <linux/kernel.h>
+#include <linux/efi.h>
 #include <linux/export.h>
 #include <linux/ftrace.h>
 #include <linux/sched.h>
@@ -12,6 +13,7 @@
 #include <linux/sched/task_stack.h>
 #include <linux/stacktrace.h>
 
+#include <asm/efi.h>
 #include <asm/irq.h>
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>
@@ -186,6 +188,13 @@ void show_stack(struct task_struct *tsk, unsigned long *sp, const char *loglvl)
 			: stackinfo_get_unknown();		\
 	})
 
+#define STACKINFO_EFI						\
+	({							\
+		((task == current) && current_in_efi())		\
+			? stackinfo_get_efi()			\
+			: stackinfo_get_unknown();		\
+	})
+
 noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry,
 			      void *cookie, struct task_struct *task,
 			      struct pt_regs *regs)
@@ -199,6 +208,9 @@ noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry,
 #if defined(CONFIG_VMAP_STACK) && defined(CONFIG_ARM_SDE_INTERFACE)
 		STACKINFO_SDEI(normal),
 		STACKINFO_SDEI(critical),
+#endif
+#ifdef CONFIG_EFI
+		STACKINFO_EFI,
 #endif
 	};
 	struct unwind_state state = {
-- 
2.39.0



