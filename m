Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84395223E7B;
	Thu, 12 Dec 2024 17:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022993; cv=none; b=KsLNIx06xJKOweHZRA6M9ALxHs6l2lRkWDPt13QP0C1yx82tmerpaXcp1aVrTU2Zue3BHSS1ZDcM+ggf2MdyPwAsz97WU1i+dR8SMYsoQ1p3ghV6OO3JyOUHsME8JzpMkPl/hr1idMcuSOmjlzrjg5oVuqGJ4IgZvzg7pPpFqJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022993; c=relaxed/simple;
	bh=bzuF+JqDGd+q/JmTm0CCnusbNOj/gqtK297xn/YM1ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKWky50hlfWdtzuze/wbQDpTJQnapebwchR21B9Co/sKQubXBUaIXPUVOX2++fUun1CjRKWjOGKOMET+jXO2m4c/+FmKX9W9YS0VclGtqtGh7YXXBPwDrasWO5t2Zd2su5FPZ3JRR0LFfDpxZnNZQ+xOx5ZtgbYERpPzNErtPrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGILp30X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGILp30X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB04EC4CED0;
	Thu, 12 Dec 2024 17:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022993;
	bh=bzuF+JqDGd+q/JmTm0CCnusbNOj/gqtK297xn/YM1ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGILp30XljNVbieOrNG2eBT5E0CMNn0RrjN6nBI39+LzixEzkw0XgNDKjezQH3dMa
	 kaul/DIoE3vqp0vwHdpWQwGMmv1kkCulcC2xvjiZsscj+wBq8JZ7Dg35RsSwvWLFb5
	 4tSXtDxVlvkr9Ji9iOD8HOVMcbaNu0R4ia1//+PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.15 383/565] s390/entry: Mark IRQ entries to fix stack depot warnings
Date: Thu, 12 Dec 2024 15:59:38 +0100
Message-ID: <20241212144326.774822439@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -474,9 +474,13 @@ ENTRY(\name)
 ENDPROC(\name)
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
 	return register_kprobe(&trampoline);
 }
 
+int __init arch_populate_kprobe_blacklist(void)
+{
+	return kprobe_add_area_blacklist((unsigned long)__irqentry_text_start,
+					 (unsigned long)__irqentry_text_end);
+}
+
 int arch_trampoline_kprobe(struct kprobe *p)
 {
 	return p->addr == (kprobe_opcode_t *) &kretprobe_trampoline;


