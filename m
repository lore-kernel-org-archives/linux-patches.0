Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A246A429803;
	Sat, 12 Sep 2026 10:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209821; cv=none; b=TNT7ZjLtPupHwVTlbMy6/iOhN07VU9ipip+W+NDxj9BH7e4H9P40znalPknWSZsKSyovp9Oy6QxsGGUQyfnfZ5PVEJ03r1AR7QOmxdwVXq8Vv+SWh9eS+p0iqUkcX0haSVrr/S8v4ymC6MTWJfIXLtnwmxNjh93RqTEiIpJc1NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209821; c=relaxed/simple;
	bh=FNtKypYCZSZqdzvAeJzTzoLeAebU+KEu7N2jS6G+6C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LiL2tmHn30K+EvTpNbiKRrSeAYvhj46ryrXewP9i23AU+c5Vz0nfEyIuFO0JwCxAZm0gfHbTpQ4SbQ0Si8KfkGWyKf/pZKga8vTZiHQMBQCu87XnLbKlbgYtIcJB5XJlDyTjbCui6BNd7PkvmqU6iSfxPXai0KtEl5eIrcauXLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWTuku6Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWTuku6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCF41F000FF;
	Sat, 12 Sep 2026 10:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209818;
	bh=l2zwgDZAxlSwtA9BA0uO8HjpvBf+G1LNzz//8dkJCNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWTuku6QPG/3s8Rrx1fHtUCKSqhdBW3AzUuzx8SKzxeEIJF8D1D32kSNaGGpTXVmZ
	 jUa46dAq08IuJcEmOZ8avBDSGTzd0h1DX2TkHrKNJ0Vq7KeqJ1YWvGRJuFTr7I8Vsw
	 647xmnw88B3oq/+Z7ArxM/30YEY9OzxD2Au514oE=
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
Subject: [PATCH 6.18 0899/1518] ARM: 9485/1: mm: acquire mmap write lock around show_pte() for user faults
Date: Sat, 12 Sep 2026 08:51:08 +0200
Message-ID: <20260912065643.790026662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index ed4330cc3f4e6..65b652b4dec3d 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -204,7 +204,11 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
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
@@ -648,7 +652,15 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
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



