Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB481C36
	for <patches@lists.linux.dev>; Wed, 26 Oct 2022 20:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA52C433D6;
	Wed, 26 Oct 2022 20:40:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="d/VgUBbd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1666816837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AjdQcbTZ/4LQ9U5Pp719hqjaA/vLTDOip6pEN5i0CB4=;
	b=d/VgUBbdmhzx0qAZMCE9tnooH2l2LF1UI2JoXz4spAjAWRyXO/EPhmn5EgLBSHudVrVtpf
	b6bt9CEAYH+YCcM+Keuj26K7XWQPaRXtA6qjCScPxsTUIhsZcXb2Ew5PWDy7ZaeYL6A+0J
	CJztRjTycrL6MgLx1iNt2rDhdmmnq/w=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 33fc5469 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 26 Oct 2022 20:40:37 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: kasan-dev@googlegroups.com,
	elver@google.com,
	patches@lists.linux.dev
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] kfence: buffer random bools in bitmask
Date: Wed, 26 Oct 2022 22:40:31 +0200
Message-Id: <20221026204031.1699061-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recently kfence got a 4x speed up in calls to the RNG, due to using
internally get_random_u8() instead of get_random_u32() for its random
boolean values. We can extend that speed up another 8x, to 32x total, by
buffering a long at a time, and reading bits from it.

I'd looked into introducing a get_random_bool(), along with the
complexities required for that kind of function to work for a general
case. But kfence is the only high-speed user of random booleans in a hot
path, so we're better off open coding this to take advantage of kfence
particularities.

In particular, we take advantage of the fact that kfence_guarded_alloc()
already disables interrupts for its raw spinlocks, so that we can keep
track of a per-cpu buffered boolean bitmask, without needing to add more
interrupt disabling.

This is slightly complicated by PREEMPT_RT, where we actually need to
take a local_lock instead. But the resulting code in both cases compiles
down to something very compact, and is basically zero cost.
Specifically, on !PREEMPT_RT, this amounts to:

    local_irq_save(flags);
    random boolean stuff;
    raw_spin_lock(&other_thing);
    do the existing stuff;
    raw_spin_unlock_irqrestore(&other_thing, flags);

By using a local_lock in the way this patch does, we now also get this
code on PREEMPT_RT:

    spin_lock(this_cpu_ptr(&local_lock));
    random boolean stuff;
    spin_unlock(this_cpu_ptr(&local_lock));
    raw_spin_lock_irqsave(&other_thing, flags);
    do the existing stuff;
    raw_spin_unlock_irqrestore(&other_thing, flags);

This is also optimal for RT systems. So all and all, this is pretty
good. But there are some compile-time conditionals in order to
accomplish this.

Cc: Marco Elver <elver@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 mm/kfence/core.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 6cbd93f2007b..c212ae0cecba 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -356,21 +356,47 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
 				  unsigned long *stack_entries, size_t num_stack_entries,
 				  u32 alloc_stack_hash)
 {
+	struct random_bools {
+		unsigned long bits;
+		unsigned int len;
+		local_lock_t lock;
+	};
+	static DEFINE_PER_CPU(struct random_bools, pcpu_bools) = {
+		.lock = INIT_LOCAL_LOCK(pcpu_bools.lock)
+	};
+	struct random_bools *bools;
 	struct kfence_metadata *meta = NULL;
 	unsigned long flags;
 	struct slab *slab;
 	void *addr;
-	const bool random_right_allocate = get_random_u32_below(2);
+	bool random_right_allocate;
 	const bool random_fault = CONFIG_KFENCE_STRESS_TEST_FAULTS &&
 				  !get_random_u32_below(CONFIG_KFENCE_STRESS_TEST_FAULTS);
 
+	local_lock_irqsave(&pcpu_bools.lock, flags);
+	bools = raw_cpu_ptr(&pcpu_bools);
+	if (unlikely(!bools->len)) {
+		bools->bits = get_random_long();
+		bools->len = BITS_PER_LONG;
+	}
+	random_right_allocate = bools->bits & 1;
+	bools->bits >>= 1;
+	bools->len--;
+
 	/* Try to obtain a free object. */
-	raw_spin_lock_irqsave(&kfence_freelist_lock, flags);
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		raw_spin_lock_irqsave(&kfence_freelist_lock, flags);
+	else
+		raw_spin_lock(&kfence_freelist_lock);
 	if (!list_empty(&kfence_freelist)) {
 		meta = list_entry(kfence_freelist.next, struct kfence_metadata, list);
 		list_del_init(&meta->list);
 	}
-	raw_spin_unlock_irqrestore(&kfence_freelist_lock, flags);
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		raw_spin_unlock_irqrestore(&kfence_freelist_lock, flags);
+	else
+		raw_spin_unlock(&kfence_freelist_lock);
+	local_unlock_irqrestore(&pcpu_bools.lock, flags);
 	if (!meta) {
 		atomic_long_inc(&counters[KFENCE_COUNTER_SKIP_CAPACITY]);
 		return NULL;
-- 
2.38.1

