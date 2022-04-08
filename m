Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD1D2CA4
	for <patches@lists.linux.dev>; Fri,  8 Apr 2022 20:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602F9C385A6;
	Fri,  8 Apr 2022 20:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1649448536;
	bh=5eKCVk5qd0asycbla6RyEsTQRSE7pFO3ajyfmUWIWH4=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=kSQZn0X3m8sgM/Ekjkg8XuUrnISN5jHemzWax+Jd6SmKxcnKy9jjhSO2JDALqZEoR
	 aWrMu9H0S6rjAhEw/d8SQm1uIfHorPI1bafdITzFRp2fBDmi0sf4qGL0dL76bYTl6Y
	 penRUT2eyFfaGTjM1SgjSS5vlztHRFd1AXvdlVuo=
Date: Fri, 08 Apr 2022 13:08:55 -0700
To: tglx@linutronix.de,stable@vger.kernel.org,peterz@infradead.org,jcmvbkbc@gmail.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220408130819.a89195e527ce58dfbe0700b9@linux-foundation.org>
Subject: [patch 2/9] highmem: fix checks in __kmap_local_sched_{in,out}
Message-Id: <20220408200856.602F9C385A6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Max Filippov <jcmvbkbc@gmail.com>
Subject: highmem: fix checks in __kmap_local_sched_{in,out}

When CONFIG_DEBUG_KMAP_LOCAL is enabled __kmap_local_sched_{in,out} check
that even slots in the tsk->kmap_ctrl.pteval are unmapped.  The slots are
initialized with 0 value, but the check is done with pte_none.  0 pte
however does not necessarily mean that pte_none will return true.  e.g. 
on xtensa it returns false, resulting in the following runtime warnings:

 WARNING: CPU: 0 PID: 101 at mm/highmem.c:627 __kmap_local_sched_out+0x51/0x108
 CPU: 0 PID: 101 Comm: touch Not tainted 5.17.0-rc7-00010-gd3a1cdde80d2-dirty #13
 Call Trace:
   dump_stack+0xc/0x40
   __warn+0x8f/0x174
   warn_slowpath_fmt+0x48/0xac
   __kmap_local_sched_out+0x51/0x108
   __schedule+0x71a/0x9c4
   preempt_schedule_irq+0xa0/0xe0
   common_exception_return+0x5c/0x93
   do_wp_page+0x30e/0x330
   handle_mm_fault+0xa70/0xc3c
   do_page_fault+0x1d8/0x3c4
   common_exception+0x7f/0x7f

 WARNING: CPU: 0 PID: 101 at mm/highmem.c:664 __kmap_local_sched_in+0x50/0xe0
 CPU: 0 PID: 101 Comm: touch Tainted: G        W         5.17.0-rc7-00010-gd3a1cdde80d2-dirty #13
 Call Trace:
   dump_stack+0xc/0x40
   __warn+0x8f/0x174
   warn_slowpath_fmt+0x48/0xac
   __kmap_local_sched_in+0x50/0xe0
   finish_task_switch$isra$0+0x1ce/0x2f8
   __schedule+0x86e/0x9c4
   preempt_schedule_irq+0xa0/0xe0
   common_exception_return+0x5c/0x93
   do_wp_page+0x30e/0x330
   handle_mm_fault+0xa70/0xc3c
   do_page_fault+0x1d8/0x3c4
   common_exception+0x7f/0x7f

Fix it by replacing !pte_none(pteval) with pte_val(pteval) != 0.

Link: https://lkml.kernel.org/r/20220403235159.3498065-1-jcmvbkbc@gmail.com
Fixes: 5fbda3ecd14a ("sched: highmem: Store local kmaps in task struct")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/highmem.c~highmem-fix-checks-in-__kmap_local_sched_inout
+++ a/mm/highmem.c
@@ -624,7 +624,7 @@ void __kmap_local_sched_out(void)
 
 		/* With debug all even slots are unmapped and act as guard */
 		if (IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL) && !(i & 0x01)) {
-			WARN_ON_ONCE(!pte_none(pteval));
+			WARN_ON_ONCE(pte_val(pteval) != 0);
 			continue;
 		}
 		if (WARN_ON_ONCE(pte_none(pteval)))
@@ -661,7 +661,7 @@ void __kmap_local_sched_in(void)
 
 		/* With debug all even slots are unmapped and act as guard */
 		if (IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL) && !(i & 0x01)) {
-			WARN_ON_ONCE(!pte_none(pteval));
+			WARN_ON_ONCE(pte_val(pteval) != 0);
 			continue;
 		}
 		if (WARN_ON_ONCE(pte_none(pteval)))
_
