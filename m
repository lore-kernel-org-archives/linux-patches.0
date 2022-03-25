Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4381FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D7DC340EE;
	Fri, 25 Mar 2022 01:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170671;
	bh=QNv5HjDELt9zqB7usRbJE0Lh3n1r0l/8EFCxZvOSM5Y=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=eCxjljCqhxwYN2cW4Ydx2W3V8YNSoHef5pRunUyx8QH1iWuzIE157zMoOb08HJYdI
	 6avEwGSfPUk8Fi2CbeEdiFiqsujW29cYLt8yA4mFbcaln4bD2Gs3AFGiJOTNXBt2Np
	 Hfhw0hYhvY4ZE7QKnUNU5SBC/WfHn11ST6jASHFs=
Date: Thu, 24 Mar 2022 18:11:10 -0700
To: will@kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,pcc@google.com,mark.rutland@arm.com,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,dan.carpenter@oracle.com,catalin.marinas@arm.com,andreyknvl@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 052/114] kasan, arm64: reset pointer tags of vmapped stacks
Message-Id: <20220325011111.75D7DC340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, arm64: reset pointer tags of vmapped stacks

Once tag-based KASAN modes start tagging vmalloc() allocations, kernel
stacks start getting tagged if CONFIG_VMAP_STACK is enabled.

Reset the tag of kernel stack pointers after allocation in
arch_alloc_vmap_stack().

For SW_TAGS KASAN, when CONFIG_KASAN_STACK is enabled, the instrumentation
can't handle the SP register being tagged.

For HW_TAGS KASAN, there's no instrumentation-related issues.  However,
the impact of having a tagged SP register needs to be properly evaluated,
so keep it non-tagged for now.

Note, that the memory for the stack allocation still gets tagged to catch
vmalloc-into-stack out-of-bounds accesses.

[andreyknvl@google.com: fix case when a stack is retrieved from cached_stacks]
  Link: https://lkml.kernel.org/r/f50c5f96ef896d7936192c888b0c0a7674e33184.1644943792.git.andreyknvl@google.com
[dan.carpenter@oracle.com: remove unnecessary check in alloc_thread_stack_node()]
  Link: https://lkml.kernel.org/r/20220301080706.GB17208@kili
Link: https://lkml.kernel.org/r/698c5ab21743c796d46c15d075b9481825973e34.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/vmap_stack.h |    5 ++++-
 kernel/fork.c                       |   11 ++++++-----
 2 files changed, 10 insertions(+), 6 deletions(-)

--- a/arch/arm64/include/asm/vmap_stack.h~kasan-arm64-reset-pointer-tags-of-vmapped-stacks
+++ a/arch/arm64/include/asm/vmap_stack.h
@@ -17,10 +17,13 @@
  */
 static inline unsigned long *arch_alloc_vmap_stack(size_t stack_size, int node)
 {
+	void *p;
+
 	BUILD_BUG_ON(!IS_ENABLED(CONFIG_VMAP_STACK));
 
-	return __vmalloc_node(stack_size, THREAD_ALIGN, THREADINFO_GFP, node,
+	p = __vmalloc_node(stack_size, THREAD_ALIGN, THREADINFO_GFP, node,
 			__builtin_return_address(0));
+	return kasan_reset_tag(p);
 }
 
 #endif /* __ASM_VMAP_STACK_H */
--- a/kernel/fork.c~kasan-arm64-reset-pointer-tags-of-vmapped-stacks
+++ a/kernel/fork.c
@@ -286,11 +286,13 @@ static int alloc_thread_stack_node(struc
 		if (!s)
 			continue;
 
-		/* Mark stack accessible for KASAN. */
+		/* Reset stack metadata. */
 		kasan_unpoison_range(s->addr, THREAD_SIZE);
 
+		stack = kasan_reset_tag(s->addr);
+
 		/* Clear stale pointers from reused stack. */
-		memset(s->addr, 0, THREAD_SIZE);
+		memset(stack, 0, THREAD_SIZE);
 
 		if (memcg_charge_kernel_stack(s)) {
 			vfree(s->addr);
@@ -298,7 +300,7 @@ static int alloc_thread_stack_node(struc
 		}
 
 		tsk->stack_vm_area = s;
-		tsk->stack = s->addr;
+		tsk->stack = stack;
 		return 0;
 	}
 
@@ -326,8 +328,7 @@ static int alloc_thread_stack_node(struc
 	 * so cache the vm_struct.
 	 */
 	tsk->stack_vm_area = vm;
-	if (stack)
-		stack = kasan_reset_tag(stack);
+	stack = kasan_reset_tag(stack);
 	tsk->stack = stack;
 	return 0;
 }
_
