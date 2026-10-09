Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5BF2AF1D;
	Fri,  9 Oct 2026 14:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555561; cv=none; b=TaBG4Ph1iZkbqbmArJ8V4foafVzmOw2PC0HWyUFQq2essQhjG8Oj3v8ZZvIU53tKSo1q9VspnXjEReOGc/Nyy51H0JA0SDr7lX3MFjxx7jVe+4i1fmTCdj8i1MNqzzgtX0OhmLqsGNgkRGp165uC2VxjPbfCErZP946TlGlL0N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555561; c=relaxed/simple;
	bh=s82U54QLoKuZhh1SliWKH8zlCBkJ6s8ijHnjeJXu4T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KB2VkBsRupV9PbMzZXgGELCRH6JW6HxwNl9z82UzoLI8VEo7wiKeTA/oLForkSJlpwoNso7nKyYq6fJ5u1a9fxZJyfSxUEidM85lKsGdqfWt2j8zv7GSzhiy3bGmhymy0nNLPbIpOzFC58ysu1QFiZLnVk+lBmRs1xxCY/iuyEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mss15wWa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mss15wWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9560C1F000FF;
	Fri,  9 Oct 2026 14:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555557;
	bh=r46CrI2cmpam0r3Qar+fFUaL4adJ0+lh0TEFIFoUttk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mss15wWaCWlqhp/GYDXB60uO7/eo5pK128ltZx3rd72bJniRpnT3UDcNFpyT8yMac
	 uNCYltf6DBAQibqYyqEotdffCxd7Rw2Bc7mdr4McpH+B4wYVy0MRp1LdpKFk9Hmu8Z
	 KFIw/LLdCuaZxDPED+FAZeDQ9awwGObRAvKT7C9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shaobo Huang <huangshaobo3@xiaomi.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: [PATCH 7.2 028/428] kasan: unpoison task stack below watermark only in generic mode
Date: Fri,  9 Oct 2026 16:06:05 +0200
Message-ID: <20261009140946.693773862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Ryabinin <ryabinin.a.a@gmail.com>

commit 22ab0647764c38924669673634ae333578d77768 upstream.

CPU resume and BPF exception handling can discard stack frames without
running their compiler-generated epilogues.  Generic KASAN needs
kasan_unpoison_task_stack_below() to clear the redzones left behind by
those frames before the stack is reused.

CONFIG_KASAN_STACK also enables this helper for SW_TAGS.  The helper
derives the stack base from an untagged stack pointer, so kasan_unpoison()
writes KASAN_TAG_KERNEL (0xff) into the shadow for [base, watermark).  For
a vmapped task stack, vm_area->addr still carries the original random
allocation tag.  This creates a tag mismatch at the stack base even if
that memory has never held an instrumented stack object.

When the task exits and its stack is not cached, thread_stack_free_rcu()
passes vm_area->addr to vfree().  In RCU callback context this reaches
vfree_atomic(), whose llist_add() writes to the allocation base through
the tagged pointer and triggers a false KASAN invalid-access report:

  BUG: KASAN: invalid-access in vfree_atomic+0x90/0x150
  Write of size 8 at addr c2ffffc0a8f70000 by task rcuop/7/75
  Pointer tag: [c2], memory tag: [ff]
  Call trace:
   __hwasan_store8_noabort+0xe8/0xf8
   vfree_atomic+0x90/0x150
   vfree+0x220/0x298
   thread_stack_free_rcu+0x3c/0x4c
   rcu_do_batch+0x308/0xaf0
   rcu_nocb_cb_kthread+0x33c/0x708

The deferred-free path started using the tagged vm_area->addr in commit
449e0b4ed5a1 ("fork: clean-up naming of vm_stack/vm_struct variables in
vmap stacks code").  Previously it freed the untagged pointer derived from
tsk->stack, so the write was never tag-checked.

SW_TAGS does not need the blanket shadow reset to make subsequent stack
accesses valid: untagged kernel pointers have the match-all 0xff tag, and
the compiler initializes the shadow tags of instrumented stack objects
before use.

Return early unless CONFIG_KASAN_GENERIC is enabled.  Keep the mode check
in the common helper so it covers both resume and bpf_throw().

Link: https://lore.kernel.org/20260916175113.1327454-1-ryabinin.a.a@gmail.com
Fixes: 449e0b4ed5a1 ("fork: clean-up naming of vm_stack/vm_struct variables in vmap stacks code")
Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Shaobo Huang <huangshaobo3@xiaomi.com>
Closes: https://lore.kernel.org/all/20260806123020.90869-1-huangshaobo3@xiaomi.com/
Assisted-by: LLM
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kasan/common.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -114,12 +114,23 @@ void kasan_unpoison_task_stack(struct ta
 /* Unpoison the stack for the current task beyond a watermark sp value. */
 asmlinkage void kasan_unpoison_task_stack_below(const void *watermark)
 {
+	void *base;
+
+	/*
+	 * Only the generic mode needs this. In the tag-based mode the
+	 * compiler fully initializes the shadow of stack variables on
+	 * function entry, so stale tags left below the watermark are
+	 * harmless.
+	 */
+	if (!IS_ENABLED(CONFIG_KASAN_GENERIC))
+		return;
+
 	/*
 	 * Calculate the task stack base address.  Avoid using 'current'
 	 * because this function is called by early resume code which hasn't
 	 * yet set up the percpu register (%gs).
 	 */
-	void *base = (void *)((unsigned long)watermark & ~(THREAD_SIZE - 1));
+	base = (void *)((unsigned long)watermark & ~(THREAD_SIZE - 1));
 
 	kasan_unpoison(base, watermark - base, false);
 }


