Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07DE2141C7;
	Wed, 30 Oct 2024 16:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730304902; cv=none; b=kispUS7qFipOZpAWGVFM8cFsRjxFSaVDXcI/D72RZO4vsiptqlfRTuTXspQTl8qjU5+eDjVDW5gid8qQ9ehjQhG4j95TKQoqIqaZT9EYAeSeu5e9eZDLBlxwJwOGTYEajudH7nucMbOKKs8gLvteJ/NRaHF6QRRN5vBWx24QXww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730304902; c=relaxed/simple;
	bh=bny68ibeBWGui6hlI4lPltyGDAij6kKvNGC+RLKS/Rc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=A9SP4uu8vzMo2yRWV7WWK5PmgG7HPmlJwh7RDLQYva4hD0pACNPwLxfchYaXSNoEfPuoIJnKQIxrCBzHzKcIEpwi529ygTuDVladnjVFOF4oxZ2R7nGZHwJFmi/nhd4mISg9OpBe/rCRnXCefXOdPGPU9LnU/mju1csgCR7sJ+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e943ggE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e943ggE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5D1C4CED2;
	Wed, 30 Oct 2024 16:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730304902;
	bh=bny68ibeBWGui6hlI4lPltyGDAij6kKvNGC+RLKS/Rc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=e943ggE6v2u8tcVa16aqJvizQbCafeD6+qqAEtDwngFpdCNWYJLwhIr5u5i0mB5b8
	 knKDRN39cB3UEr4vPJrzHTTwvN/ifS0rMLuc2gvkgsepfVScXuTtvkpKy6/ZC9DRzG
	 AMhZKNnJjNcZKWdG3ZNEZEMUipjTtdSAlSG8g7KL5IxVbawmqqJxlrftE+Xb0T6Gvo
	 87Ley3SQtt/9HiiZfQXEyPausdojNaQOUUTueslZsJaI0g9cI/Q42rJGe13UrGEhJY
	 z0CHBKo/Ge+A1Ung6ciCJXY0pH1g2IR0IG5H93s5YnP4l3jZoav9c3BP/2HroXJBIc
	 cZey07ODnU1nA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 30 Oct 2024 09:14:48 -0700
Subject: [PATCH 1/2] kprobes: Fix __get_insn_slot() after __counted_by
 annotation
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241030-kprobes-fix-counted-by-annotation-v1-1-8f266001fad0@kernel.org>
References: <20241030-kprobes-fix-counted-by-annotation-v1-0-8f266001fad0@kernel.org>
In-Reply-To: <20241030-kprobes-fix-counted-by-annotation-v1-0-8f266001fad0@kernel.org>
To: Masami Hiramatsu <mhiramat@kernel.org>, 
 Naveen N Rao <naveen@kernel.org>, 
 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Kees Cook <kees@kernel.org>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 Jinjie Ruan <ruanjinjie@huawei.com>, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3590; i=nathan@kernel.org;
 h=from:subject:message-id; bh=bny68ibeBWGui6hlI4lPltyGDAij6kKvNGC+RLKS/Rc=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOlK0S1Ml18YMDGy9Fw8cSr0h4nW/lWpjd+X/Jz+ptUxK
 8Yu+GJbRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZjIyoMM/0uiWSSm1HWKC+m2
 BKh/m+vUbujJqnRg8ryzn+ccO/MltpORYXWPzf1L9+7/ilQOttgmaCd79Ir95fLlz378/y1nevD
 mNQYA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Commit 0888460c9050 ("kprobes: Annotate structs with __counted_by()")
added a __counted_by annotation without adjusting the code for the
__counted_by requirements, resulting in a panic when UBSAN_BOUNDS and
FORTIFY_SOURCE are enabled:

  | memset: detected buffer overflow: 512 byte write of buffer size 0
  | WARNING: CPU: 0 PID: 1 at lib/string_helpers.c:1032 __fortify_report+0x64/0x80
  | Call Trace:
  |  __fortify_report+0x60/0x80 (unreliable)
  |  __fortify_panic+0x18/0x1c
  |  __get_insn_slot+0x33c/0x340

__counted_by requires that the counter be set before accessing the
flexible array but ->nused is not set until after ->slot_used is
accessed via memset(). Even if the current ->nused assignment were moved
up before memset(), the value of 1 would be incorrect because the entire
array is being accessed, not just one element.

Set ->nused to the full number of slots from slots_per_page() before
calling memset() to resolve the panic. While it is not strictly
necessary because of the new assignment, move the existing ->nused
assignment above accessing ->slot_used[0] for visual consistency.

The value of slots_per_page() should not change throughout
__get_insn_slot() because ->insn_size is never modified after its
initial assignment (which has to be done by this point otherwise it
would be incorrect) and the other values are constants, so use a new
variable to reuse its value directly.

Fixes: 0888460c9050 ("kprobes: Annotate structs with __counted_by()")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 kernel/kprobes.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 98d71a5acb723ddfff3efcc44cc6754ee36ec1de..2cf4628bc97ce2ae18547b513cd75b6350e9cc9c 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -145,16 +145,18 @@ kprobe_opcode_t *__get_insn_slot(struct kprobe_insn_cache *c)
 {
 	struct kprobe_insn_page *kip;
 	kprobe_opcode_t *slot = NULL;
+	int num_slots;
 
 	/* Since the slot array is not protected by rcu, we need a mutex */
 	mutex_lock(&c->mutex);
+	num_slots = slots_per_page(c);
  retry:
 	rcu_read_lock();
 	list_for_each_entry_rcu(kip, &c->pages, list) {
-		if (kip->nused < slots_per_page(c)) {
+		if (kip->nused < num_slots) {
 			int i;
 
-			for (i = 0; i < slots_per_page(c); i++) {
+			for (i = 0; i < num_slots; i++) {
 				if (kip->slot_used[i] == SLOT_CLEAN) {
 					kip->slot_used[i] = SLOT_USED;
 					kip->nused++;
@@ -164,7 +166,7 @@ kprobe_opcode_t *__get_insn_slot(struct kprobe_insn_cache *c)
 				}
 			}
 			/* kip->nused is broken. Fix it. */
-			kip->nused = slots_per_page(c);
+			kip->nused = num_slots;
 			WARN_ON(1);
 		}
 	}
@@ -175,7 +177,7 @@ kprobe_opcode_t *__get_insn_slot(struct kprobe_insn_cache *c)
 		goto retry;
 
 	/* All out of space.  Need to allocate a new page. */
-	kip = kmalloc(KPROBE_INSN_PAGE_SIZE(slots_per_page(c)), GFP_KERNEL);
+	kip = kmalloc(KPROBE_INSN_PAGE_SIZE(num_slots), GFP_KERNEL);
 	if (!kip)
 		goto out;
 
@@ -185,9 +187,11 @@ kprobe_opcode_t *__get_insn_slot(struct kprobe_insn_cache *c)
 		goto out;
 	}
 	INIT_LIST_HEAD(&kip->list);
-	memset(kip->slot_used, SLOT_CLEAN, slots_per_page(c));
-	kip->slot_used[0] = SLOT_USED;
+	/* nused must be set before accessing slot_used */
+	kip->nused = num_slots;
+	memset(kip->slot_used, SLOT_CLEAN, num_slots);
 	kip->nused = 1;
+	kip->slot_used[0] = SLOT_USED;
 	kip->ngarbage = 0;
 	kip->cache = c;
 	list_add_rcu(&kip->list, &c->pages);

-- 
2.47.0

