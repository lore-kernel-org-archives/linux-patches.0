Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAB012BF3D;
	Tue, 14 May 2024 10:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682483; cv=none; b=TFfvsdMmj1+Drtc6XtIizIu1sCubbeScwndTnMvbTbx48Pt24baBKUxJ1+KyvqUzKpScN1Pj8fgmd0uyemE74HEF0AQYW3WD2br7B/HiZ7OfqWGK3NctL1QlYMhcTRnxNSSeYp/tJCXWgNDy4esaANPb9aV6U90vhIQ3wrGP6GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682483; c=relaxed/simple;
	bh=cKfXZan9IgkGEu0rf4rbaY2DFqNxHjzZNCJFGSfb4Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkaFs0nEn+NZGY5+PJhMdZwrhKdq4Hxe2SP2brKPcyUOYsCTLjmrCvKV2U+JxVhLb+a1LBUlXRebamFSe1yJVdDdrv1M4vE+leIy3bP/JgBJCLplN5I9RroU4pdU7M6JdvfYV2Jc7mXcnrPPYxQd5kjpz7lQeOojmdiowigUesc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+Evo9pw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+Evo9pw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94439C2BD10;
	Tue, 14 May 2024 10:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682482;
	bh=cKfXZan9IgkGEu0rf4rbaY2DFqNxHjzZNCJFGSfb4Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+Evo9pwN59MLZSyArwUhLEdRlAlQwYAxHZrVmza8IX33DMoCrV/w7mmyqOyVJQcX
	 E2A2912Pdmd0BjydRCJAEHjM4eiL/NWPUCRfIVMtyyNWNlH415J6xjYceCJ8TFxgPJ
	 WaFY5mNbVCEOptU4N6RdujF8Jf9I1dDJFffD1BoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Hossain, Md Iqbal" <md.iqbal.hossain@intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Hossain
Subject: [PATCH 6.8 042/336] efi/unaccepted: touch soft lockup during memory accept
Date: Tue, 14 May 2024 12:14:06 +0200
Message-ID: <20240514101040.197513665@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Yu <yu.c.chen@intel.com>

[ Upstream commit 1c5a1627f48105cbab81d25ec2f72232bfaa8185 ]

Commit 50e782a86c98 ("efi/unaccepted: Fix soft lockups caused by
parallel memory acceptance") has released the spinlock so other CPUs can
do memory acceptance in parallel and not triggers softlockup on other
CPUs.

However the softlock up was intermittent shown up if the memory of the
TD guest is large, and the timeout of softlockup is set to 1 second:

 RIP: 0010:_raw_spin_unlock_irqrestore
 Call Trace:
 ? __hrtimer_run_queues
 <IRQ>
 ? hrtimer_interrupt
 ? watchdog_timer_fn
 ? __sysvec_apic_timer_interrupt
 ? __pfx_watchdog_timer_fn
 ? sysvec_apic_timer_interrupt
 </IRQ>
 ? __hrtimer_run_queues
 <TASK>
 ? hrtimer_interrupt
 ? asm_sysvec_apic_timer_interrupt
 ? _raw_spin_unlock_irqrestore
 ? __sysvec_apic_timer_interrupt
 ? sysvec_apic_timer_interrupt
 accept_memory
 try_to_accept_memory
 do_huge_pmd_anonymous_page
 get_page_from_freelist
 __handle_mm_fault
 __alloc_pages
 __folio_alloc
 ? __tdx_hypercall
 handle_mm_fault
 vma_alloc_folio
 do_user_addr_fault
 do_huge_pmd_anonymous_page
 exc_page_fault
 ? __do_huge_pmd_anonymous_page
 asm_exc_page_fault
 __handle_mm_fault

When the local irq is enabled at the end of accept_memory(), the
softlockup detects that the watchdog on single CPU has not been fed for
a while. That is to say, even other CPUs will not be blocked by
spinlock, the current CPU might be stunk with local irq disabled for a
while, which hurts not only nmi watchdog but also softlockup.

Chao Gao pointed out that the memory accept could be time costly and
there was similar report before. Thus to avoid any softlocup detection
during this stage, give the softlockup a flag to skip the timeout check
at the end of accept_memory(), by invoking touch_softlockup_watchdog().

Reported-by: Hossain, Md Iqbal <md.iqbal.hossain@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Fixes: 50e782a86c98 ("efi/unaccepted: Fix soft lockups caused by parallel memory acceptance")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/unaccepted_memory.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
index 5b439d04079c8..50f6503fe49f5 100644
--- a/drivers/firmware/efi/unaccepted_memory.c
+++ b/drivers/firmware/efi/unaccepted_memory.c
@@ -4,6 +4,7 @@
 #include <linux/memblock.h>
 #include <linux/spinlock.h>
 #include <linux/crash_dump.h>
+#include <linux/nmi.h>
 #include <asm/unaccepted_memory.h>
 
 /* Protects unaccepted memory bitmap and accepting_list */
@@ -149,6 +150,9 @@ void accept_memory(phys_addr_t start, phys_addr_t end)
 	}
 
 	list_del(&range.list);
+
+	touch_softlockup_watchdog();
+
 	spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
 }
 
-- 
2.43.0



