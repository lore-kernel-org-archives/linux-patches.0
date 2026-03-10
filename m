Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81DB382F05;
	Tue, 10 Mar 2026 11:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140771; cv=none; b=dYUCDxLD/we/rs9W7KDgyKsGkbdDUWfwZeHLNiXofO66OdEDlIpNBGvONMpSCkspbPBRodDV3F9eJsJ3ndM6YH/xTbqhVqJImaes6fEXLiRjDJr0MvFmXCRMPsrzQiYwRSkS/lVE7hd0FfuJGCePu3hA5rNNvicH/0WZUPOd+Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140771; c=relaxed/simple;
	bh=P1o2kDtCh/g+aIOhR6KueaD0n+odKUtSKOf2kdvoXJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=onLdE+p36ZEORoHd0oYeQcqbmSPa2lG1W20U331fwKm0yf1Lpfhbg6e51t/LfqkVVjq/deQr3bzs99HiqpAFyq3ZInJQS7FBqZM9TXNYlJMaQ9WXf4ktS5HTK/M2MmjyX4uS4HlFo/ISPQcLQnpCb981HjHwTJp/S+mNrU0PaGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kqfUOeml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kqfUOeml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA188C19423;
	Tue, 10 Mar 2026 11:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140771;
	bh=P1o2kDtCh/g+aIOhR6KueaD0n+odKUtSKOf2kdvoXJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kqfUOemlB5uBJzkg8PecLsuxWw7y4TURAg6Yt1dCG2fJJPqSINlMmwkahhGuYeAx5
	 pX2jtwlHm47KOyxtH0zjkRQ28lwDwvHJ40mcaCyf6lnmXW+INGtvbErQ5ozEfuKPnB
	 3ROtVd4ZUvzT6Zs/dXfgJIL7AfqaPPlgB7DQgWaMFyjzK067EcqK0+mz7jsg22GgbL
	 DnsMZjIX2QXikAT2ROH9vjxq1IfBzE9zEr+R3mx65tZumrkG+mihqfKZHEK9TKHl+A
	 vkCtKsAa1i8RTOK2G8CMgLn990Zv0JW3zO39FECytfAdMqKHg+h1y+kkDVGXhqo6eh
	 WuDhCWj2XPIeg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Alexei Starovoitov <ast@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 004/311] debugobject: Make it work with deferred page initialization - again
Date: Tue, 10 Mar 2026 07:00:51 -0400
Message-ID: <99cbf0965aba5cc7fba214e3a972b5c846b986bc.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Gleixner <tglx@kernel.org>

[ Upstream commit fd3634312a04f336dcbfb481060219f0cd320738 ]

debugobjects uses __GFP_HIGH for allocations as it might be invoked
within locked regions. That worked perfectly fine until v6.18. It still
works correctly when deferred page initialization is disabled and works
by chance when no page allocation is required before deferred page
initialization has completed.

Since v6.18 allocations w/o a reclaim flag cause new_slab() to end up in
alloc_frozen_pages_nolock_noprof(), which returns early when deferred
page initialization has not yet completed. As the deferred page
initialization takes quite a while the debugobject pool is depleted and
debugobjects are disabled.

This can be worked around when PREEMPT_COUNT is enabled as that allows
debugobjects to add __GFP_KSWAPD_RECLAIM to the GFP flags when the context
is preemtible. When PREEMPT_COUNT is disabled the context is unknown and
the reclaim bit can't be set because the caller might hold locks which
might deadlock in the allocator.

In preemptible context the reclaim bit is harmless and not a performance
issue as that's usually invoked from slow path initialization context.

That makes debugobjects depend on PREEMPT_COUNT || !DEFERRED_STRUCT_PAGE_INIT.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Link: https://patch.msgid.link/87pl6gznti.ffs@tglx
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug  |  1 +
 lib/debugobjects.c | 19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 4bae3b389a9c5..52c7a3a89f088 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -723,6 +723,7 @@ source "mm/Kconfig.debug"
 
 config DEBUG_OBJECTS
 	bool "Debug object operations"
+	depends on PREEMPT_COUNT || !DEFERRED_STRUCT_PAGE_INIT
 	depends on DEBUG_KERNEL
 	help
 	  If you say Y here, additional code will be inserted into the
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 89a1d6745dc2c..12f50de85b621 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -398,9 +398,26 @@ static void fill_pool(void)
 
 	atomic_inc(&cpus_allocating);
 	while (pool_should_refill(&pool_global)) {
+		gfp_t gfp = __GFP_HIGH | __GFP_NOWARN;
 		HLIST_HEAD(head);
 
-		if (!kmem_alloc_batch(&head, obj_cache, __GFP_HIGH | __GFP_NOWARN))
+		/*
+		 * Allow reclaim only in preemptible context and during
+		 * early boot. If not preemptible, the caller might hold
+		 * locks causing a deadlock in the allocator.
+		 *
+		 * If the reclaim flag is not set during early boot then
+		 * allocations, which happen before deferred page
+		 * initialization has completed, will fail.
+		 *
+		 * In preemptible context the flag is harmless and not a
+		 * performance issue as that's usually invoked from slow
+		 * path initialization context.
+		 */
+		if (preemptible() || system_state < SYSTEM_SCHEDULING)
+			gfp |= __GFP_KSWAPD_RECLAIM;
+
+		if (!kmem_alloc_batch(&head, obj_cache, gfp))
 			break;
 
 		guard(raw_spinlock_irqsave)(&pool_lock);
-- 
2.51.0

