Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A3946A5E0;
	Wed, 16 Sep 2026 08:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789545866; cv=none; b=Rc0CTXKBMAmuQj1CEZE6Lhv8qKiAGyPEuDsWTJBQxkAHm8AC7VUNjxYA4XR4D5I1IZxyHfzVVN2pMpirK0A9Boqcw6+XobHxFyiQFg4ITBcE8XNnDsGMULHJoJ4hQwk3UHMmTf9qvOgwHWsglQdZrSUaIqEU85mOqfk6Q49xDG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789545866; c=relaxed/simple;
	bh=EVtdQtbyKISZisfCLgyMuBDn5wVMNYdc1PaPcGT9VKM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lTXOvC64ThUp2siJVevN0Gd7d1S3gRsYWj4GAzNn/KLvQbpcRt61WRxAHyNJ3l4YJSZJqvYu9SyIZzWFhFddZfS0KADx+77unTQmKJ04BDBeTEU6bHD3E3IB6U0OiwWuWahtYXjAfE5FiP/F5Z+c2lTueVVoY1b9Ki04sgrS8Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=pvhhQ9Xz; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="pvhhQ9Xz"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=pQQVbvEcnC9Lm+sZzx/grxmOBr6oGi2Awq2Ra3qApIA=;
	b=pvhhQ9XzQmtTFcZ+qUvPHQqE0/yDx+295xk09FibQ/2tywlqxP6i55LhfGYWpA1lcXTd/+0cZ
	MegAjxOjTXil5S59tL6djYCQtRNZPcnbMTIhowgkl9eBNZ093hbHh1jQUoRjyYFsdvdVU+QEHLo
	rFMOjFYpFo8IXRhRKUBhFkU=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hlB2R5XkqznTyp;
	Wed, 16 Sep 2026 15:53:03 +0800 (CST)
Received: from kwepemk300012.china.huawei.com (unknown [7.202.194.175])
	by mail.maildlp.com (Postfix) with ESMTPS id D7DF04048B;
	Wed, 16 Sep 2026 16:04:08 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemk300012.china.huawei.com (7.202.194.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 16 Sep 2026 16:04:07 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <sashal@kernel.org>, <gregkh@linuxfoundation.org>,
	<linux@armlinux.org.uk>, <bigeasy@linutronix.de>, <clrkwllms@kernel.org>,
	<rostedt@goodmis.org>, <rmk+kernel@armlinux.org.uk>, <linusw@kernel.org>,
	<kuninori.morimoto.gx@renesas.com>, <arnd@arndb.de>, <xiqi2@huawei.com>,
	<ljs@kernel.org>, <wozizhi@huaweicloud.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-rt-devel@lists.linux.dev>, <stable@vger.kernel.org>,
	<patches@lists.linux.dev>, <lisongze2@huawei.com>, <wangbing6@huawei.com>,
	Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: [PATCH 5.10.y/5.15.y 1/4] ARM: fix hash_name() fault
Date: Wed, 16 Sep 2026 16:00:08 +0800
Message-ID: <20260916080011.170295-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk300012.china.huawei.com (7.202.194.175)

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 7733bc7d299d682f2723dc38fc7f370b9bf973e9 ]

Zizhi Wo reports:

"During the execution of hash_name()->load_unaligned_zeropad(), a
 potential memory access beyond the PAGE boundary may occur. For
 example, when the filename length is near the PAGE_SIZE boundary.
 This triggers a page fault, which leads to a call to
 do_page_fault()->mmap_read_trylock(). If we can't acquire the lock,
 we have to fall back to the mmap_read_lock() path, which calls
 might_sleep(). This breaks RCU semantics because path lookup occurs
 under an RCU read-side critical section."

This is seen with CONFIG_DEBUG_ATOMIC_SLEEP=y and CONFIG_KFENCE=y.

Kernel addresses (with the exception of the vectors/kuser helper
page) do not have VMAs associated with them. If the vectors/kuser
helper page faults, then there are two possibilities:

1. if the fault happened while in kernel mode, then we're basically
   dead, because the CPU won't be able to vector through this page
   to handle the fault.
2. if the fault happened while in user mode, that means the page was
   protected from user access, and we want to fault anyway.

Thus, we can handle kernel addresses from any context entirely
separately without going anywhere near the mmap lock. This gives us
an entirely non-sleeping path for all kernel mode kernel address
faults.

As we handle the kernel address faults before interrupts are enabled,
this change has the side effect of improving the branch predictor
hardening, but does not completely solve the issue.

[ Xie Yuanbin: At the upstream, the following patches are a patch set:
  1. commit dea20281ac8822661576 ("ARM: group is_permission_fault() with
     is_translation_fault()")
  2. commit 40b466db1dffb41f0529 ("ARM: allow __do_kernel_fault() to
     report execution of memory faults")
  3. commit 7733bc7d299d682f2723 ("ARM: fix hash_name() fault")
  4. commit fd2dee1c6e2256f726ba ("ARM: fix branch predictor hardening")
  patch 1. and 2. is unneeded for 5.10.y and 5.15.y . This patch backports
  patch 3. and simply adapts to the context differences. ]

Reported-by: Zizhi Wo <wozizhi@huaweicloud.com>
Reported-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Link: https://lore.kernel.org/r/20251126090505.3057219-1-wozizhi@huaweicloud.com
Reviewed-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Tested-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 arch/arm/mm/fault.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index c16d6a293b97..094137cd29c8 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -247,6 +247,35 @@ __do_page_fault(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
 	return fault;
 }
 
+static int __kprobes
+do_kernel_address_page_fault(struct mm_struct *mm, unsigned long addr,
+			     unsigned int fsr, struct pt_regs *regs)
+{
+	if (user_mode(regs)) {
+		/*
+		 * Fault from user mode for a kernel space address. User mode
+		 * should not be faulting in kernel space, which includes the
+		 * vector/khelper page. Send a SIGSEGV.
+		 */
+		__do_user_fault(addr, fsr, SIGSEGV, SEGV_MAPERR, regs);
+	} else {
+		/*
+		 * Fault from kernel mode. Enable interrupts if they were
+		 * enabled in the parent context. Section (upper page table)
+		 * translation faults are handled via do_translation_fault(),
+		 * so we will only get here for a non-present kernel space
+		 * PTE or PTE permission fault. This may happen in exceptional
+		 * circumstances and need the fixup tables to be walked.
+		 */
+		if (interrupts_enabled(regs))
+			local_irq_enable();
+
+		__do_kernel_fault(mm, addr, fsr, regs);
+	}
+
+	return 0;
+}
+
 static int __kprobes
 do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 {
@@ -261,6 +290,12 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 
 	tsk = current;
 	mm  = tsk->mm;
+	/*
+	 * Handle kernel addresses faults separately, which avoids touching
+	 * the mmap lock from contexts that are not able to sleep.
+	 */
+	if (addr >= TASK_SIZE)
+		return do_kernel_address_page_fault(mm, addr, fsr, regs);
 
 	/* Enable interrupts if they were enabled in the parent context. */
 	if (interrupts_enabled(regs))
-- 
2.55.0

