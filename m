Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D161DA4D;
	Tue, 16 Jul 2024 15:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144995; cv=none; b=V/lyrav/gfhgwnv6okK6kCO3dDVPGNaGUP7bnhAWt2V8BJxKZCuh0eo9tUgGa9loWlgDhwh80RrXIuB1ft8x6M5nTXUKQwUJK3klIpDzG38C+XTrIePonwlBb9maZa1ovfWX2M/B/cuMdMLZKtmQPMNME3euaFj6dBGZiCaQ7OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144995; c=relaxed/simple;
	bh=0XwFIkysHfaYSDF4Iz5L+7s0mKQ4bpNaNmG21Hhb5Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUZyFckbsO2ULtV5D6Mh+fyAWaI7kRYjROd7GOxmpGVepoB/zbVKiVqN9T8z0FUtek7BG7Oq4hQp0Wy1TBcTVCzTUmd6qHhiXOrOvXFbf4jzOX1EUv5LctCuMdV0pxnGxG+jLgj+TriWiZluCJKz3Q6+30DS+qgH59F/Cmxl+tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=faZf78iq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="faZf78iq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E47C116B1;
	Tue, 16 Jul 2024 15:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144995;
	bh=0XwFIkysHfaYSDF4Iz5L+7s0mKQ4bpNaNmG21Hhb5Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faZf78iqtV/9KmLl0SZZ715jpsriGuw8Y93D6+nNnWIJSE8deQCg4YeuIyVQhzPq0
	 GkmZ3ukXP/VGEmofHktCzo7FZApey5bi/gpaC5+vpFeowtxzTacs+BdbUyXSMaqwz9
	 shtHCIhm1ZCG+BR3WWyati/RIVv+haIo4+nlbswk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 033/143] bpf: replace bpf_timer_init with a generic helper
Date: Tue, 16 Jul 2024 17:30:29 +0200
Message-ID: <20240716152757.265247079@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <bentiss@kernel.org>

[ Upstream commit 56b4a177ae6322173360a93ea828ad18570a5a14 ]

No code change except for the new flags argument being stored in the
local data struct.

Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Link: https://lore.kernel.org/r/20240420-bpf_wq-v2-2-6c986a5a741f@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: d4523831f07a ("bpf: Fail bpf_timer_cancel when callback is being cancelled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 91 ++++++++++++++++++++++++++++++--------------
 1 file changed, 63 insertions(+), 28 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 2544220c23338..ff18b467d7d75 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1111,7 +1111,10 @@ struct bpf_hrtimer {
 
 /* the actual struct hidden inside uapi struct bpf_timer */
 struct bpf_async_kern {
-	struct bpf_hrtimer *timer;
+	union {
+		struct bpf_async_cb *cb;
+		struct bpf_hrtimer *timer;
+	};
 	/* bpf_spin_lock is used here instead of spinlock_t to make
 	 * sure that it always fits into space reserved by struct bpf_timer
 	 * regardless of LOCKDEP and spinlock debug flags.
@@ -1119,6 +1122,10 @@ struct bpf_async_kern {
 	struct bpf_spin_lock lock;
 } __attribute__((aligned(8)));
 
+enum bpf_async_type {
+	BPF_ASYNC_TYPE_TIMER = 0,
+};
+
 static DEFINE_PER_CPU(struct bpf_hrtimer *, hrtimer_running);
 
 static enum hrtimer_restart bpf_timer_cb(struct hrtimer *hrtimer)
@@ -1160,46 +1167,55 @@ static enum hrtimer_restart bpf_timer_cb(struct hrtimer *hrtimer)
 	return HRTIMER_NORESTART;
 }
 
-BPF_CALL_3(bpf_timer_init, struct bpf_async_kern *, timer, struct bpf_map *, map,
-	   u64, flags)
+static int __bpf_async_init(struct bpf_async_kern *async, struct bpf_map *map, u64 flags,
+			    enum bpf_async_type type)
 {
-	clockid_t clockid = flags & (MAX_CLOCKS - 1);
+	struct bpf_async_cb *cb;
 	struct bpf_hrtimer *t;
+	clockid_t clockid;
+	size_t size;
 	int ret = 0;
 
-	BUILD_BUG_ON(MAX_CLOCKS != 16);
-	BUILD_BUG_ON(sizeof(struct bpf_async_kern) > sizeof(struct bpf_timer));
-	BUILD_BUG_ON(__alignof__(struct bpf_async_kern) != __alignof__(struct bpf_timer));
-
 	if (in_nmi())
 		return -EOPNOTSUPP;
 
-	if (flags >= MAX_CLOCKS ||
-	    /* similar to timerfd except _ALARM variants are not supported */
-	    (clockid != CLOCK_MONOTONIC &&
-	     clockid != CLOCK_REALTIME &&
-	     clockid != CLOCK_BOOTTIME))
+	switch (type) {
+	case BPF_ASYNC_TYPE_TIMER:
+		size = sizeof(struct bpf_hrtimer);
+		break;
+	default:
 		return -EINVAL;
-	__bpf_spin_lock_irqsave(&timer->lock);
-	t = timer->timer;
+	}
+
+	__bpf_spin_lock_irqsave(&async->lock);
+	t = async->timer;
 	if (t) {
 		ret = -EBUSY;
 		goto out;
 	}
+
 	/* allocate hrtimer via map_kmalloc to use memcg accounting */
-	t = bpf_map_kmalloc_node(map, sizeof(*t), GFP_ATOMIC, map->numa_node);
-	if (!t) {
+	cb = bpf_map_kmalloc_node(map, size, GFP_ATOMIC, map->numa_node);
+	if (!cb) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	t->cb.value = (void *)timer - map->record->timer_off;
-	t->cb.map = map;
-	t->cb.prog = NULL;
-	rcu_assign_pointer(t->cb.callback_fn, NULL);
-	hrtimer_init(&t->timer, clockid, HRTIMER_MODE_REL_SOFT);
-	t->timer.function = bpf_timer_cb;
-	WRITE_ONCE(timer->timer, t);
-	/* Guarantee the order between timer->timer and map->usercnt. So
+
+	if (type == BPF_ASYNC_TYPE_TIMER) {
+		clockid = flags & (MAX_CLOCKS - 1);
+		t = (struct bpf_hrtimer *)cb;
+
+		hrtimer_init(&t->timer, clockid, HRTIMER_MODE_REL_SOFT);
+		t->timer.function = bpf_timer_cb;
+		cb->value = (void *)async - map->record->timer_off;
+	}
+	cb->map = map;
+	cb->prog = NULL;
+	cb->flags = flags;
+	rcu_assign_pointer(cb->callback_fn, NULL);
+
+	WRITE_ONCE(async->cb, cb);
+	/* Guarantee the order between async->cb and map->usercnt. So
 	 * when there are concurrent uref release and bpf timer init, either
 	 * bpf_timer_cancel_and_free() called by uref release reads a no-NULL
 	 * timer or atomic64_read() below returns a zero usercnt.
@@ -1209,15 +1225,34 @@ BPF_CALL_3(bpf_timer_init, struct bpf_async_kern *, timer, struct bpf_map *, map
 		/* maps with timers must be either held by user space
 		 * or pinned in bpffs.
 		 */
-		WRITE_ONCE(timer->timer, NULL);
-		kfree(t);
+		WRITE_ONCE(async->cb, NULL);
+		kfree(cb);
 		ret = -EPERM;
 	}
 out:
-	__bpf_spin_unlock_irqrestore(&timer->lock);
+	__bpf_spin_unlock_irqrestore(&async->lock);
 	return ret;
 }
 
+BPF_CALL_3(bpf_timer_init, struct bpf_async_kern *, timer, struct bpf_map *, map,
+	   u64, flags)
+{
+	clock_t clockid = flags & (MAX_CLOCKS - 1);
+
+	BUILD_BUG_ON(MAX_CLOCKS != 16);
+	BUILD_BUG_ON(sizeof(struct bpf_async_kern) > sizeof(struct bpf_timer));
+	BUILD_BUG_ON(__alignof__(struct bpf_async_kern) != __alignof__(struct bpf_timer));
+
+	if (flags >= MAX_CLOCKS ||
+	    /* similar to timerfd except _ALARM variants are not supported */
+	    (clockid != CLOCK_MONOTONIC &&
+	     clockid != CLOCK_REALTIME &&
+	     clockid != CLOCK_BOOTTIME))
+		return -EINVAL;
+
+	return __bpf_async_init(timer, map, flags, BPF_ASYNC_TYPE_TIMER);
+}
+
 static const struct bpf_func_proto bpf_timer_init_proto = {
 	.func		= bpf_timer_init,
 	.gpl_only	= true,
-- 
2.43.0



