Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B47B490C1C;
	Sat, 12 Sep 2026 19:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239640; cv=none; b=LKaZUOkjhFu1IGk2a5qIVMEY1u8VCFujJJToFR6L8jLOpsGgkDjuYlVkM1qS6Aqw5ah/9IFMdbZ8+Aq98P2R0Fxr1HP+kGl0mFF152kP1rUUTPWBxwqc1J/FKcTqtKJqjMn/9K4jpzy2nNcNIMTV+vAXPXAPEcE/duOe4HkTV/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239640; c=relaxed/simple;
	bh=Yetn9j4bbh46kTZZ/F+u3iPVEol+9Sq1/3ED+xdHE30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWFtOHvdQbTuh0Y1SckKsgCFM9LbEqoTW6RpdnCKOx4kZzL30AtELQlt8lGiU5u+IvlrjclBveMQJIy5a95DARAI/Pd6ci5rbA5/gEorfLBYkBgT7yrv3gQdXKUM+gWPqJDHWA3Yjbanp8MFVvSoTlvm856tj5tdrWO3sXqqjTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+t2GDIi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+t2GDIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D561F00893;
	Sat, 12 Sep 2026 19:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239638;
	bh=xuFodZUzwIg9HXTdEp2Sw2EaTxdH5stsJVJ/MdlRzVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b+t2GDIiR3l10n9PdPAR+BNws0fGnr87aPj19px1H/yR4CnSqazO2QptlZ46C/w0q
	 u6GOoa1qcMFWHVGlzhMrrG3c7UuTkvagOjTZoPVuYIe3ZFpybsK+8RenTEYBJLQeus
	 0E8UDU1WlaOJaT1ZafDle9/7u/nqDSn75xe8U2Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Qi Xi <xiqi2@huawei.com>,
	Xie Yuanbin <xieyuanbin1@huawei.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 704/935] ARM: 9485/1: mm: acquire mmap write lock around show_pte() for user faults
Date: Sat, 12 Sep 2026 09:02:14 +0200
Message-ID: <20260912065542.983047295@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Xie Yuanbin <xieyuanbin1@huawei.com>

[ Upstream commit 1039bffd6ae9c75b42b7d148d6c1106134107b66 ]

When CONFIG_DEBUG_USER=y, and cmdline "user_debug=31" is set,
a user fault may trigger show_pte() without any lock.
If another thread in the same process concurrently calls munmap(),
the page table pages may be freed while show_pte() is still traversing
them, causing a use-after-free in show_pte().

If CONFIG_ARM_LPAE=y, this may cause a kernel panic if the pages table
of PMD are freed when show_pte() is running.

Acquire mmap_write_lock() around show_pte() for user faults to fix the
contention.

For user faults, additionally restrict that show_pte() is called only
when the addr is a user-space address (addr < TASK_SIZE). This is because
the lock of tsk->mm only protects the virtual memory of user address space,
furthermore, dumping the page tables of a kernel-space address for user
faults is unnecessary and may have security implications.

Keep everything unchanged for kernel faults, because the kernel is
already in the "oops" state, acquiring a lock may risk a deadlock.

Co-developed-by: Qi Xi <xiqi2@huawei.com>

Fixes: 6d021b724481 ("ARM: dump pgd, pmd and pte states on unhandled data abort faults")
Link: https://lore.kernel.org/20260716014022.2823-1-xieyuanbin1@huawei.com
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Qi Xi <xiqi2@huawei.com>
Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/fault.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index bf1577216ffab..c16d6a293b97c 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -154,7 +154,11 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
 		pr_err("8<--- cut here ---\n");
 		pr_err("%s: unhandled page fault (%d) at 0x%08lx, code 0x%03x\n",
 		       tsk->comm, sig, addr, fsr);
-		show_pte(KERN_ERR, tsk->mm, addr);
+		if (likely(addr < TASK_SIZE)) {
+			mmap_write_lock(tsk->mm);
+			show_pte(KERN_ERR, tsk->mm, addr);
+			mmap_write_unlock(tsk->mm);
+		}
 		show_regs(regs);
 	}
 #endif
@@ -532,7 +536,15 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	pr_alert("8<--- cut here ---\n");
 	pr_alert("Unhandled fault: %s (0x%03x) at 0x%08lx\n",
 		inf->name, fsr, addr);
-	show_pte(KERN_ALERT, current->mm, addr);
+	if (likely(user_mode(regs))) {
+		if (addr < TASK_SIZE) {
+			mmap_write_lock(current->mm);
+			show_pte(KERN_ALERT, current->mm, addr);
+			mmap_write_unlock(current->mm);
+		}
+	} else {
+		show_pte(KERN_ALERT, current->mm, addr);
+	}
 
 	arm_notify_die("", regs, inf->sig, inf->code, (void __user *)addr,
 		       fsr, 0);
-- 
2.53.0



