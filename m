Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3691DF964;
	Tue,  8 Oct 2024 13:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394189; cv=none; b=o4IIqCtS/a/9LVZmHb4uu6N1/wbgRRTYlu/d5Weq46jnLxILGDnIOSmr3yFki7lGNeLINEGl+NxTwcdiKFxGtNgAhjLLP/IZ8lqYYTPDtbSBEjn/IJ6ALwD4luctPNAGh2ZTb7da9QnBUne+qhTPJcyo/Fxb6pBd/8CorMlVG84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394189; c=relaxed/simple;
	bh=Mg8gp50QgKIVtgRHrOnY09DScRtmxaVlYB5rf0+d8JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1R05aLZaMegprctp3YsngiOZ6ZE1vyr3jWuJ4yj5PhQkFLJd2ued0GXX/TsRuPnCvO032QP5rEHbXhHc7ieHnKI4nizKEJ8ZKx4KJqpJHSz2nzpvEAHKtbiAR0tLyuG3GjfVIPuhIi01PjkEEYdbvXZ2Ym9HWyEgWTGgFX1f4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmtUuT7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmtUuT7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB88EC4CEC7;
	Tue,  8 Oct 2024 13:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394189;
	bh=Mg8gp50QgKIVtgRHrOnY09DScRtmxaVlYB5rf0+d8JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hmtUuT7FjnlowG3NnS27IeCbAPcKZ8fkDlOUDv7hePWz/HGB8GO6JU0D1DrkHH0+m
	 fG1lSKIR17P5PD08qeNB2IS0v9hLmcmBGdyyhZhcOEwDjOfw/b5R32TBHFrs8PCyv4
	 yIqICyLrs/PTAIMNw2tSkadQcJw3ZdZ+M5+xYxCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Md Iqbal Hossain <md.iqbal.hossain@intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH 6.6 374/386] efi/unaccepted: touch soft lockup during memory accept
Date: Tue,  8 Oct 2024 14:10:19 +0200
Message-ID: <20241008115644.106630676@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

Reported-by: Md Iqbal Hossain <md.iqbal.hossain@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Fixes: 50e782a86c98 ("efi/unaccepted: Fix soft lockups caused by parallel memory acceptance")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
(cherry picked from commit 1c5a1627f48105cbab81d25ec2f72232bfaa8185)
[Harshit: CVE-2024-36936; Minor conflict resolution due to header file
 differences due to missing commit: 7cd34dd3c9bf ("efi/unaccepted: do not
 let /proc/vmcore try to access unaccepted memory") in 6.6.y]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/unaccepted_memory.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/firmware/efi/unaccepted_memory.c
+++ b/drivers/firmware/efi/unaccepted_memory.c
@@ -3,6 +3,7 @@
 #include <linux/efi.h>
 #include <linux/memblock.h>
 #include <linux/spinlock.h>
+#include <linux/nmi.h>
 #include <asm/unaccepted_memory.h>
 
 /* Protects unaccepted memory bitmap and accepting_list */
@@ -148,6 +149,9 @@ retry:
 	}
 
 	list_del(&range.list);
+
+	touch_softlockup_watchdog();
+
 	spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
 }
 


