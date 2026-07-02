Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A163A59B1;
	Thu,  2 Jul 2026 16:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010625; cv=none; b=fpnEGUgZ6XdjrBTJraRaWI8ubd9gAJTCZatq8QdtSiZryEB9/siheZ6mkgEc/Ix1BAqQngreMf527PxryA+o4g2NehFW4gLVEJfwO38BvQlXwHTmFP0Ki32k0sgt/gZBUADXaY5/C8hF4ue5eodsyeRWg7Hx1DE9F6GxviE289Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010625; c=relaxed/simple;
	bh=HlW7JilBt+C8C9Vs0hLLyuY4qgA8z9jvHRMPxu5s2bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HN9g2vIYD5axTHq4umEYCpQ2/H9b5VnyrIzXMkv102g9o4+8hLT+krg9CDoPfNXsSGUI4EdCz/UWymL8mEUwAdIbeoGHtmzkXFzj2xQAWULeAJgGtGI14yk2XNa2zj8sMAekRYnMv1BqOxEyHhTluEH9vM40P0PuLuk1vcpGykU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hj9azS9z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hj9azS9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF65E1F000E9;
	Thu,  2 Jul 2026 16:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010624;
	bh=Tc1GGdSuCp4FKXPVzuwIzrC6EYhRsOBf7JamLk0NXXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hj9azS9z8tWygUfrq3cT+chAbY6N95B9fLv80pNBbR/wlQAf8zQrxzQP7AmpT6QY2
	 Fe1d9DrkZWhALliYIjayngiGyrzbUvMBxZsxDhrLBQAFluSy+mwAur2nUKFQq2RRBq
	 MGjdw3TFRuu3BLDq4cI4TwUzyuZna/OejVC1jXr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanko Kaneti <yaneti@declera.com>,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.12 180/204] riscv: kfence: Call mark_new_valid_map() for kfence_unprotect()
Date: Thu,  2 Jul 2026 18:20:37 +0200
Message-ID: <20260702155122.427793718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivian Wang <wangruikang@iscas.ac.cn>

commit 8d6c8c40e733b3fcaf92fed0a078bba2f6941a3b upstream.

In kfence_protect_page(), which kfence_unprotect() calls, we cannot send
IPIs to other CPUs to ask them to flush TLB. This may lead to those CPUs
spuriously faulting on a recently allocated kfence object despite it
being valid, leading to false positive use-after-free reports.

Fix this by calling mark_new_valid_map() so that the page fault handling
code path notices the spurious fault and flushes TLB then retries the
access.

Update the comment in handle_exception to indicate that
new_valid_map_cpus_check also handles kfence_unprotect() spurious
faults.

Note that kfence_protect() has the same stale TLB entries problem, but
that leads to false negatives, which is fine with kfence.

Cc: stable@vger.kernel.org
Reported-by: Yanko Kaneti <yaneti@declera.com>
Fixes: b3431a8bb336 ("riscv: Fix IPIs usage in kfence_protect_page()")
Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Link: https://patch.msgid.link/20260303-handle-kfence-protect-spurious-fault-v2-2-f80d8354d79d@iscas.ac.cn
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/kfence.h |    7 +++++--
 arch/riscv/kernel/entry.S       |    6 ++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/arch/riscv/include/asm/kfence.h
+++ b/arch/riscv/include/asm/kfence.h
@@ -6,6 +6,7 @@
 #include <linux/kfence.h>
 #include <linux/pfn.h>
 #include <asm-generic/pgalloc.h>
+#include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
 static inline bool arch_kfence_init_pool(void)
@@ -17,10 +18,12 @@ static inline bool kfence_protect_page(u
 {
 	pte_t *pte = virt_to_kpte(addr);
 
-	if (protect)
+	if (protect) {
 		set_pte(pte, __pte(pte_val(ptep_get(pte)) & ~_PAGE_PRESENT));
-	else
+	} else {
 		set_pte(pte, __pte(pte_val(ptep_get(pte)) | _PAGE_PRESENT));
+		mark_new_valid_map();
+	}
 
 	preempt_disable();
 	local_flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -106,8 +106,10 @@ SYM_CODE_START(handle_exception)
 
 #ifdef CONFIG_64BIT
 	/*
-	 * The RISC-V kernel does not eagerly emit a sfence.vma after each
-	 * new vmalloc mapping, which may result in exceptions:
+	 * The RISC-V kernel does not flush TLBs on all CPUS after each new
+	 * vmalloc mapping or kfence_unprotect(), which may result in
+	 * exceptions:
+	 *
 	 * - if the uarch caches invalid entries, the new mapping would not be
 	 *   observed by the page table walker and an invalidation is needed.
 	 * - if the uarch does not cache invalid entries, a reordered access


