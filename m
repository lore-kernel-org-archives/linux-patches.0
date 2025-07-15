Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01DE2E2F0C;
	Tue, 15 Jul 2025 13:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587936; cv=none; b=Mjbm6HskD5hiw5CvxEPKdP9KxJjl16dxI8OLWGxDPn3nXW4H18vtknaksJP04dah43UBVmVOCtPkEXg+n/3IhEdK/xx1WWY6Vf38gbg2gtvuKunGzaiv3BKebq/+dhHBfrd5cvCX1IjNwMEfPQjKJSC4WIirROINP77B2c5q71A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587936; c=relaxed/simple;
	bh=7QFAx513F6j88YIPHnn5ysDsAwgDTMi4tFtRsPVPjfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5vTTkjEvtLi9QC7evCl2z9FRHI7gqN8wPIJb/x0xaPy0oaIYOTxQ2aPEw6OmUMMtWZNTtAjgUehgej8sN/+43XBaEvJkhL9REbDO+X3CBwLBCpzhCBuVlGhY3erNyAPycDa19cotrG9pQCZT8bI0JQ2eR9PIL3qA2l93te+234=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdUNcHK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdUNcHK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F59C4CEE3;
	Tue, 15 Jul 2025 13:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587936;
	bh=7QFAx513F6j88YIPHnn5ysDsAwgDTMi4tFtRsPVPjfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdUNcHK7ihHHdbJJyDxuEdEqFYWhARlBsL4YApuZA77+bf7tziAevKDj7JQ7Rc/wG
	 VLADSwoYkneBIIzzDtJnm4bp9bhhxts1xye/tar4YOpr9k5oH2pcy/OLLp6NgGbHyY
	 pstYMhevThhKvFg9RdWqWFvsIIAcrZiF2dwhx8Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 5.10 167/208] x86/modules: Set VM_FLUSH_RESET_PERMS in module_alloc()
Date: Tue, 15 Jul 2025 15:14:36 +0200
Message-ID: <20250715130817.670221771@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 4c4eb3ecc91f4fee6d6bf7cfbc1e21f2e38d19ff upstream.

Instead of resetting permissions all over the place when freeing module
memory tell the vmalloc code to do so. Avoids the exercise for the next
upcoming user.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220915111143.406703869@infradead.org
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/ftrace.c       |    2 --
 arch/x86/kernel/kprobes/core.c |    1 -
 arch/x86/kernel/module.c       |    8 ++++----
 3 files changed, 4 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -422,8 +422,6 @@ create_trampoline(struct ftrace_ops *ops
 	/* ALLOC_TRAMP flags lets us know we created it */
 	ops->flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
 
-	set_vm_flush_reset_perms(trampoline);
-
 	if (likely(system_state != SYSTEM_BOOTING))
 		set_memory_ro((unsigned long)trampoline, npages);
 	set_memory_x((unsigned long)trampoline, npages);
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -403,7 +403,6 @@ void *alloc_insn_page(void)
 	if (!page)
 		return NULL;
 
-	set_vm_flush_reset_perms(page);
 	/*
 	 * First make the page read-only, and only then make it executable to
 	 * prevent it from being W+X in between.
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -73,10 +73,10 @@ void *module_alloc(unsigned long size)
 		return NULL;
 
 	p = __vmalloc_node_range(size, MODULE_ALIGN,
-				    MODULES_VADDR + get_module_load_offset(),
-				    MODULES_END, GFP_KERNEL,
-				    PAGE_KERNEL, 0, NUMA_NO_NODE,
-				    __builtin_return_address(0));
+				 MODULES_VADDR + get_module_load_offset(),
+				 MODULES_END, GFP_KERNEL, PAGE_KERNEL,
+				 VM_FLUSH_RESET_PERMS, NUMA_NO_NODE,
+				 __builtin_return_address(0));
 	if (p && (kasan_module_alloc(p, size) < 0)) {
 		vfree(p);
 		return NULL;


