Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062430;
	b=2/1Htbf1EIVIqIdpDroWS0eL74o9K/CtzKRM7hKWBRdamNMZcF1Pn1k2wQKa5f/3/8f5
	 LVvfDZ/Wa5swcX1R45oi6BHOVd27YtHdX/W/zXgSkSzJN4KreG+om0txSWV8YN/et/AFK
	 xwqMmwhqc7CglV5DvUPrtmufxC4Bmin4bwGsNVsT7mOljDVV72kQ/gUdRIZn214Is11Pq
	 lmMGWxsRMhtxUmYb9CvxgAX6JQyNM/3BLB4zFpNltZN2/6OkhqhAUbE6VvXVr0jp6gops
	 cIt4mQ9EDL7y+ODHBhpanBjW5k5TCpCNVo+Jo3zh8gwIMr36L5aKqIY8nBoHPyHWsAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dzpO1kcG4kMDvmMeJfL26sLNbWCFylAgG/Jp+YtCaBU=;
	b=GRZQIgv4+CiYPYRgXd/j6v0Y2OKNcsTeOU3zwBaZJ3J0kge6a4yTABzzDXye3Zheqa1E
	 Q3aXsSpQHh37y9f+vQ+T2GWOEYImQAg2pohCXMeVRYjq0VNGcXf+jEdT22hy0XCxaW76K
	 6w4MAhbJbIWl6BEfVTaKJuxlfmJRz7nD1QDsYD6q8SEoMPBKrWKkFgUAEH5QMeB11aDke
	 FMqGYT/TITTjtrj3Tmq+LXj7+eyqTOn28AQs4/H1JtaparRnyceyoZ3XJOo4klcmuZaUm
	 0Rc+kuU8rayh6njpO/aI2uWV4RqZgWglW2DIQdPT0re95qOq0bRsd6ow8PUNAwnvNSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QA4Twi+S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C97E606EEA3;
	Sat,  7 Nov 2026 14:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QA4Twi+S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE17E1F008A3;
	Sat,  7 Nov 2026 14:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062430;
	bh=dzpO1kcG4kMDvmMeJfL26sLNbWCFylAgG/Jp+YtCaBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QA4Twi+Se3o7jlQD1gr8WSdt7UtzZcXSqZQblyjguBKnRKYn6mKweB7HEvWz5p2J0
	 H+7cW+hjEJyYxWfzu5zEgQ46/Lk/YzsGeH+oUhLSwWszDcr8IgVahlXoT7NyadL+93
	 8JoHAbMCEAc+lozQO23aXxDoshZpUHu0F+SKch9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1342/1536] alpha: handle VM_FAULT_HWPOISON in do_page_fault()
Date: Sat,  7 Nov 2026 08:55:58 -0500
Message-ID: <20261107135035.511537337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Turner <mattst88@gmail.com>

[ Upstream commit 4bef20bbb9e02568a009efa4d404ce2621289be5 ]

do_page_fault() handles VM_FAULT_OOM, VM_FAULT_SIGSEGV and
VM_FAULT_SIGBUS and then falls into BUG() for anything else in
VM_FAULT_ERROR. VM_FAULT_HWPOISON and VM_FAULT_HWPOISON_LARGE are in
that set, so a fault on a poisoned page takes down the kernel instead of
delivering a signal.

Alpha does not select ARCH_SUPPORTS_MEMORY_FAILURE, so the machine check
paths cannot produce these. UFFDIO_POISON can: it installs a poison PTE
marker without any memory failure support, and a subsequent access
returns VM_FAULT_HWPOISON. Registering an anonymous range with
userfaultfd, poisoning it and reading it back reliably hits the BUG():

  Kernel bug at arch/alpha/mm/fault.c:188
  poison(50809): Kernel Bug 1
  pc is at do_page_fault+0x4e8/0x550
  ra is at do_page_fault+0xfc/0x550

The BUG() fires with mmap_read_lock() still held, so the faulting task
is left unkillable in D state holding the lock, and shutdown stalls
behind it. A UFFD_USER_MODE_ONLY userfaultfd is always allowed, so any
local user can do this.

Deliver SIGBUS with BUS_MCEERR_AR instead, reporting the size of the
poisoned area, as the other architectures do. That is the huge page size
for VM_FAULT_HWPOISON_LARGE, which becomes reachable once alpha
implements huge pages.

Tested on an UP1500 (EV68AL): the reproducer above now takes a SIGBUS
and the kernel logs

  poison[373]: hardware memory error at 0000020000030000 pc 00000200010007ec

with no oops, no wedged task and no taint.

A backport needs the show_signal_msg() call dropped, since alpha only
has it since commit 9ca6af1aac40 ("alpha: select
SYSCTL_EXCEPTION_TRACE").

Fixes: fc71884a5f59 ("mm: userfaultfd: add new UFFDIO_POISON ioctl")
Cc: stable@vger.kernel.org # 6.6+
Reviewed-by: Magnus Lindholm <linmag7@gmail.com>
Tested-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Link: https://lore.kernel.org/r/20261007-alpha-hugepages-v2-2-8e108af2d961@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/mm/fault.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/alpha/mm/fault.c b/arch/alpha/mm/fault.c
index a9816bbc9f34d..f40ac0826a854 100644
--- a/arch/alpha/mm/fault.c
+++ b/arch/alpha/mm/fault.c
@@ -8,6 +8,7 @@
 #include <linux/sched/signal.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/hugetlb.h>
 #include <asm/io.h>
 
 #define __EXTERN_INLINE inline
@@ -89,6 +90,7 @@ do_page_fault(unsigned long address, unsigned long mmcsr,
 	struct mm_struct *mm = current->mm;
 	const struct exception_table_entry *fixup;
 	int si_code = SEGV_MAPERR;
+	unsigned int lsb;
 	vm_fault_t fault;
 	unsigned int flags = FAULT_FLAG_DEFAULT;
 
@@ -161,6 +163,8 @@ do_page_fault(unsigned long address, unsigned long mmcsr,
 			goto bad_area;
 		else if (fault & VM_FAULT_SIGBUS)
 			goto do_sigbus;
+		else if (fault & (VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE))
+			goto do_sigbus_mceerr;
 		BUG();
 	}
 
@@ -222,6 +226,21 @@ do_page_fault(unsigned long address, unsigned long mmcsr,
 		goto no_context;
 	return;
 
+ do_sigbus_mceerr:
+	mmap_read_unlock(mm);
+	if (!user_mode(regs))
+		goto no_context;
+	/*
+	 * Report the size of the poisoned area, which for a hugetlb fault
+	 * is the size of the huge page that could not be mapped.
+	 */
+	lsb = PAGE_SHIFT;
+	if (fault & VM_FAULT_HWPOISON_LARGE)
+		lsb = hstate_index_to_shift(VM_FAULT_GET_HINDEX(fault));
+	show_signal_msg(regs, address, SIGBUS, "hardware memory error");
+	force_sig_mceerr(BUS_MCEERR_AR, (void __user *) address, lsb);
+	return;
+
  do_sigsegv:
 	force_sig_fault(SIGSEGV, si_code, (void __user *) address);
 	return;
-- 
2.53.0



