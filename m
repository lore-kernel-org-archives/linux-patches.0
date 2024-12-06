Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DB5149E1A;
	Fri,  6 Dec 2024 15:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498609; cv=none; b=kamG5tGm0MD2fAxBbvCaZ6O5Yj+X3zPm079WeqZMCxXuQiTAw2sHtwUfOjv4AiuMPfKHYZk3mlcqjYWjWjNenjGC6khg7DYOmmPo4NuCQ38Ad8Qm5eR6t4X+oFThm7C7c+ymO5M3MYQ29yekXaWEirCqSGBLtB5MslhgoZQhWz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498609; c=relaxed/simple;
	bh=ebeSlqjL09JdnBr02GGnywTeUnl05JKK++VYTH0Woek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EARq4AG4CbkrtzPkmhKw7DSkucQuuT1p6BDzVZ4eiMjjZFBtyqLU1V8iUAy6niza6Pufmxj5LGHlUXQCkQt6UG8lqBz7XkQAOIRn9/15nRT+f8VlF73CPIqThC+E3V77R8ekSF64urZebrobIMYAmHwbPo8gwKMvrFtSrMYZC18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPkRuDm5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPkRuDm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A4CC4CED1;
	Fri,  6 Dec 2024 15:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498609;
	bh=ebeSlqjL09JdnBr02GGnywTeUnl05JKK++VYTH0Woek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPkRuDm5ElnsXHqAIzrrkPHuoxr0y+eMOR6U7/82gqbLQe3p29QOkrCpmb2yg/12/
	 mIGG3GjD6rCOVTDm8d0ulkGOblSd+3Pn1cGRgmlGeIY0u7P+Gz89U/9tWfbcSRoq3X
	 mQtXKYEVbLXfxNsqC/vkRJ7vAkQjiNPC90fREkaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.6 636/676] s390/entry: Mark IRQ entries to fix stack depot warnings
Date: Fri,  6 Dec 2024 15:37:35 +0100
Message-ID: <20241206143718.212293484@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vasily Gorbik <gor@linux.ibm.com>

commit 45c9f2b856a075a34873d00788d2e8a250c1effd upstream.

The stack depot filters out everything outside of the top interrupt
context as an uninteresting or irrelevant part of the stack traces. This
helps with stack trace de-duplication, avoiding an explosion of saved
stack traces that share the same IRQ context code path but originate
from different randomly interrupted points, eventually exhausting the
stack depot.

Filtering uses in_irqentry_text() to identify functions within the
.irqentry.text and .softirqentry.text sections, which then become the
last stack trace entries being saved.

While __do_softirq() is placed into the .softirqentry.text section by
common code, populating .irqentry.text is architecture-specific.

Currently, the .irqentry.text section on s390 is empty, which prevents
stack depot filtering and de-duplication and could result in warnings
like:

Stack depot reached limit capacity
WARNING: CPU: 0 PID: 286113 at lib/stackdepot.c:252 depot_alloc_stack+0x39a/0x3c8

with PREEMPT and KASAN enabled.

Fix this by moving the IO/EXT interrupt handlers from .kprobes.text into
the .irqentry.text section and updating the kprobes blacklist to include
the .irqentry.text section.

This is done only for asynchronous interrupts and explicitly not for
program checks, which are synchronous and where the context beyond the
program check is important to preserve. Despite machine checks being
somewhat in between, they are extremely rare, and preserving context
when possible is also of value.

SVCs and Restart Interrupts are not relevant, one being always at the
boundary to user space and the other being a one-time thing.

IRQ entries filtering is also optionally used in ftrace function graph,
where the same logic applies.

Cc: stable@vger.kernel.org # 5.15+
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/entry.S   |    4 ++++
 arch/s390/kernel/kprobes.c |    6 ++++++
 2 files changed, 10 insertions(+)

--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -458,9 +458,13 @@ SYM_CODE_START(\name)
 SYM_CODE_END(\name)
 .endm
 
+	.section .irqentry.text, "ax"
+
 INT_HANDLER ext_int_handler,__LC_EXT_OLD_PSW,do_ext_irq
 INT_HANDLER io_int_handler,__LC_IO_OLD_PSW,do_io_irq
 
+	.section .kprobes.text, "ax"
+
 /*
  * Load idle PSW.
  */
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -518,6 +518,12 @@ int __init arch_init_kprobes(void)
 	return 0;
 }
 
+int __init arch_populate_kprobe_blacklist(void)
+{
+	return kprobe_add_area_blacklist((unsigned long)__irqentry_text_start,
+					 (unsigned long)__irqentry_text_end);
+}
+
 int arch_trampoline_kprobe(struct kprobe *p)
 {
 	return 0;


