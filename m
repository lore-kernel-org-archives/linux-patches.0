Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027061;
	b=ZlOSoCRCHS6Qu4JFlGNjdOCfds4dVoZq89zXojqza1KxHW19r2cbybT5ro0OSANEDGDh
	 qrIijKt0y7dXRGfKj9O/oyi4/alRRpgLt24hE7dJWD1ZnQFB9AeeNsWJtzR+Y1pneEch5
	 +qCa1YRMe7hG53CpEcJEA73rGpPtmc3i8HX9xly8Iznw3qN2yWb8IyGnzExqdkkneCcAR
	 LKsHtn2XauK3roCPLZnumic5OGfPyTKjsV8vXUgKRbRgiFB404gk/lkwSnJvgghlTq9+Z
	 GhLJanEBSOc03/l9ek8hrtG3luSHHhCGq4pANQU4ByE3OZJqrCGMceJJUo0/MHFVW5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZGX6cCL/QLmGbGAnPJzkT0lLc8hygGX9ufys5X5u1TU=;
	b=ENLTLy5Jv+yXK1CaK1S60XP0xCUuey9etW43aCyOA7fxDyUVZktQaH2+3h1TFG/x/COR
	 Uhw9iXzsjbWhl+DLLzbs6HtnTDqz34DojQrHS+Lb0/O3aVoX/dFyDbjDwj7qrm9jjVeB/
	 cv1QP3Ys8shs1HEkWXOCmTdMChS7b/fHnAIj5sgbLVJkpEiNG0tFD5/hoVJh5CjFSd161
	 X+lyNjyI5H/gYfqWCX3LIo+xwTqP9J01V18K+ZGGFpxdQGKoyFIZF4Tmj9NC9lPkEcrET
	 HvJ6KuXqejXHHcNQIiIyebIzv+SshaI4CdRtLukECR1sOLpM3S9UYXAPytWaCvHB4yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AodZ3Jdo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D54606A335;
	Wed, 18 Nov 2026 18:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AodZ3Jdo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04401F000C4;
	Wed, 18 Nov 2026 18:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027061;
	bh=ZGX6cCL/QLmGbGAnPJzkT0lLc8hygGX9ufys5X5u1TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AodZ3Jdow9gZOiWLZ0Y92RiLQf1btlOGoTDkT+axExWhZlPfwuqItuNYpeNtnLnTa
	 lk7Jp0ZujjbhUH8VMi4qAmVDb3YK/wfyA6zf4dQJVWUirsSwjbr+NR9+0ND5q6/MX7
	 xxlBD3OXWUQZ/6DNJU4QXzAtiftwpQApWl7TvRGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1657/2151] bpf: Migrate bpf_task_work to kmalloc_nolock
Date: Wed, 18 Nov 2026 15:56:32 +0100
Message-ID: <20261118150222.204109952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit 90f51ebff242e9446a9bbd3ce1a04d50c30e8b96 ]

Replace bpf_mem_alloc/bpf_mem_free with
kmalloc_nolock/kfree_rcu for bpf_task_work_ctx.

Replace guard(rcu_tasks_trace)() with guard(rcu)() in
bpf_task_work_irq(). The function only accesses ctx struct members
(not map values), so tasks trace protection is not needed - regular
RCU is sufficient since ctx is freed via kfree_rcu. The guard in
bpf_task_work_callback() remains as tasks trace since it accesses map
values from process context.

Sleepable BPF programs hold rcu_read_lock_trace but not
regular rcu_read_lock. Since kfree_rcu
waits for a regular RCU grace period, the ctx memory can be freed
while a sleepable program is still running. Add scoped_guard(rcu)
around the pointer read and refcount tryget in
bpf_task_work_acquire_ctx to close this race window.

Since kfree_rcu uses call_rcu internally which is not safe from
NMI context, defer destruction via irq_work when irqs are disabled.

For the lost-cmpxchg path the ctx was never published, so
kfree_nolock is safe.

Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260330-kmalloc_special-v2-1-c90403f92ff0@meta.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: c961f7b41a10 ("bpf: Fix NULL task dereference in task work cancellation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 56 +++++++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 19 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 72757f7290ec2..fd59259ca9780 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -3986,17 +3986,25 @@ static bool bpf_task_work_ctx_tryget(struct bpf_task_work_ctx *ctx)
 	return refcount_inc_not_zero(&ctx->refcnt);
 }
 
+static void bpf_task_work_destroy(struct irq_work *irq_work)
+{
+	struct bpf_task_work_ctx *ctx = container_of(irq_work, struct bpf_task_work_ctx, irq_work);
+
+	bpf_task_work_ctx_reset(ctx);
+	kfree_rcu(ctx, rcu);
+}
+
 static void bpf_task_work_ctx_put(struct bpf_task_work_ctx *ctx)
 {
 	if (!refcount_dec_and_test(&ctx->refcnt))
 		return;
 
-	bpf_task_work_ctx_reset(ctx);
-
-	/* bpf_mem_free expects migration to be disabled */
-	migrate_disable();
-	bpf_mem_free(&bpf_global_ma, ctx);
-	migrate_enable();
+	if (irqs_disabled()) {
+		ctx->irq_work = IRQ_WORK_INIT(bpf_task_work_destroy);
+		irq_work_queue(&ctx->irq_work);
+	} else {
+		bpf_task_work_destroy(&ctx->irq_work);
+	}
 }
 
 static void bpf_task_work_cancel(struct bpf_task_work_ctx *ctx)
@@ -4051,7 +4059,7 @@ static void bpf_task_work_irq(struct irq_work *irq_work)
 	enum bpf_task_work_state state;
 	int err;
 
-	guard(rcu_tasks_trace)();
+	guard(rcu)();
 
 	if (cmpxchg(&ctx->state, BPF_TW_PENDING, BPF_TW_SCHEDULING) != BPF_TW_PENDING) {
 		bpf_task_work_ctx_put(ctx);
@@ -4073,9 +4081,9 @@ static void bpf_task_work_irq(struct irq_work *irq_work)
 	/*
 	 * It's technically possible for just scheduled task_work callback to
 	 * complete running by now, going SCHEDULING -> RUNNING and then
-	 * dropping its ctx refcount. Instead of capturing extra ref just to
-	 * protected below ctx->state access, we rely on RCU protection to
-	 * perform below SCHEDULING -> SCHEDULED attempt.
+	 * dropping its ctx refcount. Instead of capturing an extra ref just
+	 * to protect below ctx->state access, we rely on rcu_read_lock
+	 * above to prevent kfree_rcu from freeing ctx before we return.
 	 */
 	state = cmpxchg(&ctx->state, BPF_TW_SCHEDULING, BPF_TW_SCHEDULED);
 	if (state == BPF_TW_FREED)
@@ -4092,7 +4100,7 @@ static struct bpf_task_work_ctx *bpf_task_work_fetch_ctx(struct bpf_task_work *t
 	if (ctx)
 		return ctx;
 
-	ctx = bpf_mem_alloc(&bpf_global_ma, sizeof(struct bpf_task_work_ctx));
+	ctx = bpf_map_kmalloc_nolock(map, sizeof(*ctx), 0, NUMA_NO_NODE);
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
@@ -4106,7 +4114,7 @@ static struct bpf_task_work_ctx *bpf_task_work_fetch_ctx(struct bpf_task_work *t
 		 * tw->ctx is set by concurrent BPF program, release allocated
 		 * memory and try to reuse already set context.
 		 */
-		bpf_mem_free(&bpf_global_ma, ctx);
+		kfree_nolock(ctx);
 		return old_ctx;
 	}
 
@@ -4118,13 +4126,23 @@ static struct bpf_task_work_ctx *bpf_task_work_acquire_ctx(struct bpf_task_work
 {
 	struct bpf_task_work_ctx *ctx;
 
-	ctx = bpf_task_work_fetch_ctx(tw, map);
-	if (IS_ERR(ctx))
-		return ctx;
-
-	/* try to get ref for task_work callback to hold */
-	if (!bpf_task_work_ctx_tryget(ctx))
-		return ERR_PTR(-EBUSY);
+	/*
+	 * Sleepable BPF programs hold rcu_read_lock_trace but not
+	 * regular rcu_read_lock. Since kfree_rcu waits for regular
+	 * RCU GP, the ctx can be freed while we're between reading
+	 * the pointer and incrementing the refcount. Take regular
+	 * rcu_read_lock to prevent kfree_rcu from freeing the ctx
+	 * before we can tryget it.
+	 */
+	scoped_guard(rcu) {
+		ctx = bpf_task_work_fetch_ctx(tw, map);
+		if (IS_ERR(ctx))
+			return ctx;
+
+		/* try to get ref for task_work callback to hold */
+		if (!bpf_task_work_ctx_tryget(ctx))
+			return ERR_PTR(-EBUSY);
+	}
 
 	if (cmpxchg(&ctx->state, BPF_TW_STANDBY, BPF_TW_PENDING) != BPF_TW_STANDBY) {
 		/* lost acquiring race or map_release_uref() stole it from us, put ref and bail */
-- 
2.53.0



