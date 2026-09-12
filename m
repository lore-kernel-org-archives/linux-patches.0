Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A386288B9;
	Sat, 12 Sep 2026 16:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230863; cv=none; b=Mx0/EzA4jfpblB+AWvSjFzTfLwUVv+jcYXghdqlTCIPfmzg5bfe50uNilGWW6X7BTbmFqZPnMTaeKBrcLJD5n0VjU6MO+pZ+CHNVGTI+sqO3ntBkVLtX6hMC8IZGGj1R7iriCbZLa86s3kbv1DT0e4IXzO0KT1aQYnE017hb4X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230863; c=relaxed/simple;
	bh=L3KQkPep29bAv5H0fdNPinKSjZE6ihoZySUN5DEVuqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9TlUmfDq9xdByLmHSR1D9Zs90f+otX561xEBvLTOipPYUN7H1MmmRIMaHVOJ1XOqMiAMBGO/rhHd08xqWEWDpEmVk4AUGzcX1EMdHYlXfDzzu7ZRnKU3ZhJ4TNN4Dn/RmSW6CpsBgHYkBgYTU5eVeH0GDnuMh6Nnq01dUn2v5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbgN4Fxm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbgN4Fxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5131F000FF;
	Sat, 12 Sep 2026 16:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230861;
	bh=fvFPy72X/Po8+K8dzBYZ8jJf/Lh7rnEYDzPp12KUY5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PbgN4FxmSkaVIbFBT28TE833Umxzl5S/XievAqVr+wq6rtbHCph+KP/KDcpTrK096
	 zSS+65jG/5iTI+CK7tkRkeY1kZI5WIP6SVb1txtp+gy7jyhpG/ELeQclKcK6sgVtEV
	 alJuApnwX5b+JOWPV60fUa0tpJWx6NxmezrJ5CsY=
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
Subject: [PATCH 6.1 0874/1191] ARM: 9485/1: mm: acquire mmap write lock around show_pte() for user faults
Date: Sat, 12 Sep 2026 09:00:02 +0200
Message-ID: <20260912065607.882344069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d0681285dbda3..29a995c6d7c6b 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -201,7 +201,11 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
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
@@ -582,7 +586,15 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
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



