Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5293429000;
	Sat, 12 Sep 2026 12:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216708; cv=none; b=lvUFcYoXDdJNkjqA3Ofc4ZJJz/pnrGBKyktbj/xvzq3qOx19jY8UegMfGhIDyLF66/yvusAYHTk8TZsrYRzLw1/PRIeTxDFu/Ni/tJvp1z8AnT6Xn4q6EzMzBhkpieXrlMoW+/TGFhZxFPOsaDbOw1t1E7H705MMoShcIeLraXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216708; c=relaxed/simple;
	bh=1sbkt9Pj4WhdKw1ST7kfUCPz73KCXczVg11C+4V10VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFDhMqc9ZL+sevDwHaiqkfpi28yCTsTawlKaYnCACBhImhTMfHLpUXUz/6d/mXqe0yAuAwPM0U49MlXJBR/1+cu3wKCFIsEllCw/gB9bxqaVZcig+/wm+GuuWd+T6GMVeDRgy7pSqtQw5+hznn+aEKA+s6Vx+OPDC0nZqjmjymk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cN7p7C2S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cN7p7C2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94501F000FF;
	Sat, 12 Sep 2026 12:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216706;
	bh=yiEYviMoHW1DZ46ExttkYXvjh1K04vsIBJY9H3XvDRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cN7p7C2ScoMFUGHSQCaR07sHPCfli2gQkL60PaFP/BTUFtNulwSvzNwdkfECIHm3u
	 lzrk6WLFi9jKKT78sb+1fSgea5lzBclo9NhI52xP2sGpei8cZAupYR/m5qsxQsLVWm
	 Vi84/+Mky3Q9wyxoyd+/b17Yimqw9kZmcs0TX6zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0749/1376] slab: Make slub local_(try)lock more precise for LOCKDEP
Date: Sat, 12 Sep 2026 08:52:55 +0200
Message-ID: <20260912065624.235782880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 83382af9ddc3cb0ef43f67d049b461720ad785e6 ]

kmalloc_nolock() can be called from any context
the ___slab_alloc() can acquire local_trylock_t (which is rt_spin_lock
in PREEMPT_RT) and attempt to acquire a different local_trylock_t
while in the same task context.

The calling sequence might look like:
kmalloc() -> tracepoint -> bpf -> kmalloc_nolock()

or more precisely:
__lock_acquire+0x12ad/0x2590
lock_acquire+0x133/0x2d0
rt_spin_lock+0x6f/0x250
___slab_alloc+0xb7/0xec0
kmalloc_nolock_noprof+0x15a/0x430
my_debug_callback+0x20e/0x390 [testmod]
___slab_alloc+0x256/0xec0
__kmalloc_cache_noprof+0xd6/0x3b0

Make LOCKDEP understand that local_trylock_t-s protect
different kmem_caches. In order to do that add lock_class_key
for each kmem_cache and use that key in local_trylock_t.

This stack trace is possible on both PREEMPT_RT and !PREEMPT_RT,
but teach lockdep about it only for PREEMPT_RT, since
in !PREEMPT_RT the ___slab_alloc() code is using
local_trylock_irqsave() when lockdep is on.

Note, this patch applies this logic to local_lock_t
while the next one converts it to local_trylock_t.
Both are mapped to rt_spin_lock in PREEMPT_RT.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Stable-dep-of: 4c6eb712a91f ("wifi: ath12k: fix stride mismatch in mac_phy_caps_parse()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slab.h |  1 +
 mm/slub.c | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/mm/slab.h b/mm/slab.h
index 8e9fc3efc3fa4..1b58c2a771407 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -258,6 +258,7 @@ struct kmem_cache_order_objects {
 struct kmem_cache {
 #ifndef CONFIG_SLUB_TINY
 	struct kmem_cache_cpu __percpu *cpu_slab;
+	struct lock_class_key lock_key;
 #endif
 	/* Used for retrieving partial slabs, etc. */
 	slab_flags_t flags;
diff --git a/mm/slub.c b/mm/slub.c
index 68407f1177482..f3868bad83dbb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3078,12 +3078,29 @@ static inline void note_cmpxchg_failure(const char *n,
 
 static void init_kmem_cache_cpus(struct kmem_cache *s)
 {
+#ifdef CONFIG_PREEMPT_RT
+	/*
+	 * Register lockdep key for non-boot kmem caches to avoid
+	 * WARN_ON_ONCE(static_obj(key))) in lockdep_register_key()
+	 */
+	bool finegrain_lockdep = !init_section_contains(s, 1);
+#else
+	/*
+	 * Don't bother with different lockdep classes for each
+	 * kmem_cache, since we only use local_trylock_irqsave().
+	 */
+	bool finegrain_lockdep = false;
+#endif
 	int cpu;
 	struct kmem_cache_cpu *c;
 
+	if (finegrain_lockdep)
+		lockdep_register_key(&s->lock_key);
 	for_each_possible_cpu(cpu) {
 		c = per_cpu_ptr(s->cpu_slab, cpu);
 		local_lock_init(&c->lock);
+		if (finegrain_lockdep)
+			lockdep_set_class(&c->lock, &s->lock_key);
 		c->tid = init_tid(cpu);
 	}
 }
@@ -5304,6 +5321,9 @@ void __kmem_cache_release(struct kmem_cache *s)
 {
 	cache_random_seq_destroy(s);
 #ifndef CONFIG_SLUB_TINY
+#ifdef CONFIG_PREEMPT_RT
+	lockdep_unregister_key(&s->lock_key);
+#endif
 	free_percpu(s->cpu_slab);
 #endif
 	free_kmem_cache_nodes(s);
-- 
2.53.0



