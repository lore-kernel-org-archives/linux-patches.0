Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313304A8430;
	Wed, 30 Sep 2026 18:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791901; cv=none; b=ImZujAY4HjJ3MGKUYwJJsBo8HRk+7bWLBx2VrmaWA2J5ZsVjicSI7Eo37PzB4o0awdhmlwLC46iqOmDhXbKp0qqQJprVp45mGP5VKtoiQfq8NI/pj7bF0uQZ7cPg873MVa7xpx2FAPqd5SHo84spVJ/1uf2R/e/Jssr2JitaHnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791901; c=relaxed/simple;
	bh=g4a7vmLL+EPWspsSmjzNOPvueH9qTKlggtxVL6xuHug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3ZuBu+hZiF24YEtDi7E6ssLvXhrKv+f9XcVSN2Q8LPqfJX7d6QX1zJhHlu9aCvlSWlVg01ZsioDYmaa+kWp9W8DfqvXSVZDAg6BjBMISvZblkTYnMqDYfN4xfvMYC6vGYaXTz4fhOJAtpF2H7NHhQQxkzqr0BJRph2IAWsKuVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnLY6uRN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnLY6uRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEA01F000FF;
	Wed, 30 Sep 2026 18:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791899;
	bh=1qDCd3HTYPQtwTX63Lt9ZsbCQWbspPC+6iBF9mxRCDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UnLY6uRNWDzpDiwo8FlwifHnCatMuu3pB3x0qLNYUfL6zdxjmXOnkg5JCysb7CSQz
	 NvhotWKvqNH0NXyI/D2MZO8dPlNsuPkvBzhjd7cNS5BN5puByxUr4/w7TmFtR9aGdw
	 uozlqOUN4kRFKT/E+j0OPV6bRB+0Q9oe75KpZk2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huaweicloud.com>,
	Xie Yuanbin <xieyuanbin1@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 421/752] ARM: fix hash_name() fault
Date: Wed, 30 Sep 2026 17:24:51 +0200
Message-ID: <20260930152407.394940641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/fault.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 622fa99e138f6..831fc426cda1f 100644
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
2.53.0



