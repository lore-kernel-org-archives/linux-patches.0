Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB3B1D7995;
	Tue, 16 Jun 2026 15:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622477; cv=none; b=p/00z3AdiM7/i0vIPE9nOKKAaIzat2KSOri6I5DeoaS0v3w+khc5VfRRnDl+D8dzyFXFzT+0A2eH1EzyCF+F8DCRhcvsC21nBXMO/lw7Qco8DCgjDQQQQHuFh4T1a/+BGPNI/SDAjapqBB9DJTI522iBGsfdhoqO/R8nCZcmGbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622477; c=relaxed/simple;
	bh=EZICChnBlQrprmt1E3kvjTJ/kc9D/4hwOnysGT09FtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsmmVzLLsqwo6qYYBsDwU6B56RX8BLxv/3NmOvkZ8aIku7hysB57lGo+MwjxUtUKdtukvXFzvgdUUpxzeflhOpvSchuaxgt7vQbziL79uvFasdqNw+doqd8c6kNz2O5xzHRutmi7yoAiVcK66YZZzP2EJuNlhoqoH6awGhEDD88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWmmreiZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWmmreiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DA81F000E9;
	Tue, 16 Jun 2026 15:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622476;
	bh=P7GCs90HSFtUDC3288tR+7fEzctdo6UTAyQMB9Arr9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yWmmreiZUGMb8B+JQcku52dIgoZMCJN8ANNCxaWv26jzlnKNi+wCqXYO3e/3XZgu2
	 DxyaD50sahO2TPQAovMk4bi3SYMDqjmP7XXU82Se3pO6GIYBa7+iRTFAFXpLng+UYj
	 Df1Sz1Dlm4XheoEqXKhu+gsFMvKQuLAxvxgs/ow0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huaweicloud.com>,
	Xie Yuanbin <xieyuanbin1@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/325] ARM: fix hash_name() fault
Date: Tue, 16 Jun 2026 20:26:40 +0530
Message-ID: <20260616145058.051397092@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 7733bc7d299d682f2723dc38fc7f370b9bf973e9 upstream.

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

Reported-by: Zizhi Wo <wozizhi@huaweicloud.com>
Reported-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Link: https://lore.kernel.org/r/20251126090505.3057219-1-wozizhi@huaweicloud.com
Reviewed-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Tested-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/fault.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 192c8ab196dbab..0e5b4bc7b21760 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -261,6 +261,35 @@ static inline bool ttbr0_usermode_access_allowed(struct pt_regs *regs)
 }
 #endif
 
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
@@ -274,6 +303,12 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	if (kprobe_page_fault(regs, fsr))
 		return 0;
 
+	/*
+	 * Handle kernel addresses faults separately, which avoids touching
+	 * the mmap lock from contexts that are not able to sleep.
+	 */
+	if (addr >= TASK_SIZE)
+		return do_kernel_address_page_fault(mm, addr, fsr, regs);
 
 	/* Enable interrupts if they were enabled in the parent context. */
 	if (interrupts_enabled(regs))
-- 
2.53.0



