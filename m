Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8291F482F1;
	Sat,  3 Feb 2024 04:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933719; cv=none; b=XJjdjvooQQcRccT7Tr9zZm0uUA3/H4jdVl1dCoj1Iu2JSJEUPT6ajQXGEUoVVvLKIMzHwu3HydAZH4QfzwikolRiz8pwBUPn9ywOFdhtSoSRqj7+iHj4Yh0SEVprAN5U2Fpg+rkYkdufejcBx6qk5patIW4y7BZhnEfv048sc0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933719; c=relaxed/simple;
	bh=JLlLt+OqxjjiLg4DVFlRiIWE9ngZ/pPz/g3+JGkC3tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myW0001T28mAMsgVxiAgn1magX8cXgXuRRDCk33oL5A/zVW22h/p7f1UERy7WvJqo6w3uS1AW2pZ4KrOT+1azJ2Rhj2PiNy5rhbiI9C5bnTwfm0Ijv4Pugj5BtHDF7cxVh7vo70FnbOglp5keCas5yDiKDLMKyJeSZyOF/syOSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uaV5E0JK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uaV5E0JK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFD9C43399;
	Sat,  3 Feb 2024 04:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933718;
	bh=JLlLt+OqxjjiLg4DVFlRiIWE9ngZ/pPz/g3+JGkC3tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uaV5E0JKs/bs4GiY2RO09f+jFUzzr73oaVWyWq1vzbO+1i5ykabrdddataB62bwI2
	 x3PYN3iSZrI6l0MK8OaGxBLlphIy/I+d9PVTwisfUFIE3KVgw5rUwOUQvRsaLyzk72
	 1Mt2M8lQb5FgUXR10+hfQgKHjrqFFJIoLgSotXoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	syzbot+93a9e8a3dea8d6085e12@syzkaller.appspotmail.com,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 317/322] mm, kmsan: fix infinite recursion due to RCU critical section
Date: Fri,  2 Feb 2024 20:06:54 -0800
Message-ID: <20240203035409.279393138@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Marco Elver <elver@google.com>

commit f6564fce256a3944aa1bc76cb3c40e792d97c1eb upstream.

Alexander Potapenko writes in [1]: "For every memory access in the code
instrumented by KMSAN we call kmsan_get_metadata() to obtain the metadata
for the memory being accessed.  For virtual memory the metadata pointers
are stored in the corresponding `struct page`, therefore we need to call
virt_to_page() to get them.

According to the comment in arch/x86/include/asm/page.h,
virt_to_page(kaddr) returns a valid pointer iff virt_addr_valid(kaddr) is
true, so KMSAN needs to call virt_addr_valid() as well.

To avoid recursion, kmsan_get_metadata() must not call instrumented code,
therefore ./arch/x86/include/asm/kmsan.h forks parts of
arch/x86/mm/physaddr.c to check whether a virtual address is valid or not.

But the introduction of rcu_read_lock() to pfn_valid() added instrumented
RCU API calls to virt_to_page_or_null(), which is called by
kmsan_get_metadata(), so there is an infinite recursion now.  I do not
think it is correct to stop that recursion by doing
kmsan_enter_runtime()/kmsan_exit_runtime() in kmsan_get_metadata(): that
would prevent instrumented functions called from within the runtime from
tracking the shadow values, which might introduce false positives."

Fix the issue by switching pfn_valid() to the _sched() variant of
rcu_read_lock/unlock(), which does not require calling into RCU.  Given
the critical section in pfn_valid() is very small, this is a reasonable
trade-off (with preemptible RCU).

KMSAN further needs to be careful to suppress calls into the scheduler,
which would be another source of recursion.  This can be done by wrapping
the call to pfn_valid() into preempt_disable/enable_no_resched().  The
downside is that this sacrifices breaking scheduling guarantees; however,
a kernel compiled with KMSAN has already given up any performance
guarantees due to being heavily instrumented.

Note, KMSAN code already disables tracing via Makefile, and since mmzone.h
is included, it is not necessary to use the notrace variant, which is
generally preferred in all other cases.

Link: https://lkml.kernel.org/r/20240115184430.2710652-1-glider@google.com [1]
Link: https://lkml.kernel.org/r/20240118110022.2538350-1-elver@google.com
Fixes: 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing memory_section->usage")
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Alexander Potapenko <glider@google.com>
Reported-by: syzbot+93a9e8a3dea8d6085e12@syzkaller.appspotmail.com
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Alexander Potapenko <glider@google.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kmsan.h |   17 ++++++++++++++++-
 include/linux/mmzone.h       |    6 +++---
 2 files changed, 19 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/kmsan.h
+++ b/arch/x86/include/asm/kmsan.h
@@ -64,6 +64,7 @@ static inline bool kmsan_virt_addr_valid
 {
 	unsigned long x = (unsigned long)addr;
 	unsigned long y = x - __START_KERNEL_map;
+	bool ret;
 
 	/* use the carry flag to determine if x was < __START_KERNEL_map */
 	if (unlikely(x > y)) {
@@ -79,7 +80,21 @@ static inline bool kmsan_virt_addr_valid
 			return false;
 	}
 
-	return pfn_valid(x >> PAGE_SHIFT);
+	/*
+	 * pfn_valid() relies on RCU, and may call into the scheduler on exiting
+	 * the critical section. However, this would result in recursion with
+	 * KMSAN. Therefore, disable preemption here, and re-enable preemption
+	 * below while suppressing reschedules to avoid recursion.
+	 *
+	 * Note, this sacrifices occasionally breaking scheduling guarantees.
+	 * Although, a kernel compiled with KMSAN has already given up on any
+	 * performance guarantees due to being heavily instrumented.
+	 */
+	preempt_disable();
+	ret = pfn_valid(x >> PAGE_SHIFT);
+	preempt_enable_no_resched();
+
+	return ret;
 }
 
 #endif /* !MODULE */
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2006,9 +2006,9 @@ static inline int pfn_valid(unsigned lon
 	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
 		return 0;
 	ms = __pfn_to_section(pfn);
-	rcu_read_lock();
+	rcu_read_lock_sched();
 	if (!valid_section(ms)) {
-		rcu_read_unlock();
+		rcu_read_unlock_sched();
 		return 0;
 	}
 	/*
@@ -2016,7 +2016,7 @@ static inline int pfn_valid(unsigned lon
 	 * the entire section-sized span.
 	 */
 	ret = early_section(ms) || pfn_section_valid(ms, pfn);
-	rcu_read_unlock();
+	rcu_read_unlock_sched();
 
 	return ret;
 }


