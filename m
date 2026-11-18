Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018252;
	b=KvTlt/6PU9SGMfYhpwpPstNpcRVzMrunLob14UF6KmzmEmymjFJ7NmAq+I3AYmrcEkID
	 0i/x+rNqi9te4PbmblBxzySHMoG4+zheFGTaAPmioVCZmvuFN0jzxPp2atrhg7rNBfDwG
	 FDotDbq2jlhcd2n5aNMLvog0Sg+dZhmdJVz21SfARyXZY1vTGtfTYYaCG84pQBB0fNKxS
	 ooph8UAOWtbXNef6sZXQ2vqnnvbR1uBqqpwK0E2lBgjQk5xS25sujTmpvbNpsr4Om3B0c
	 G7A4vqF6BX5p19HVS+x6VvMLi3pV9tm/pXCBYE9Wp+v2UCZU7Hj7RWYylwHI1lbfCXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OmkOTPXocfxFgNZJFzkyIJPjzRROjhImA38d8MmSAvI=;
	b=IvTBp+bu7rdpj361/rkcW+4rhJxoqUjs1WbSeW0aGYYe/tmO4Tw6igYPKjSnm9Fz91Ul
	 Dv9A0/dd9X1txK71U6tAYD2cGgsDNg1qiktzK0DqyYRcBenjLh5d/nJBvNYBIja2A7n2h
	 MJBuiRD8kEdp6KUkGt9IBc3XRsDrBaJJ/qra8llnxmpLWD+EqJV95/LBNwJ36RtklW9eH
	 qZTTWVA3q3Q/JHY01UA/32Cyn48RV1ISqcPwrLmqn360i5gzkCpF0aKDZUOeUzwaGtFwU
	 7se5lp8I6QXJVHXiAhgWu3oOTrJzVZQ7eAK0SOLwLiEucJvOFAdr+7E4DfWv0b+ZGYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+Bv3pEp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E3A606A320;
	Wed, 18 Nov 2026 16:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+Bv3pEp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870EA1F000C4;
	Wed, 18 Nov 2026 16:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018252;
	bh=OmkOTPXocfxFgNZJFzkyIJPjzRROjhImA38d8MmSAvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g+Bv3pEpfCsszJ5cR4DqjsYSvY+Nzfy6JOjsbvmAqyXbe1nJOwqGgpHNRsWrlEowW
	 rWUWT5TZr0OT/zl4Fyy3XEtpDJUl6YUAIlEHbMbXPoH0VhRB3U3dp8mXJV7Nlaqh0K
	 MtCWXDPiv1JieztBLEtSyCIEwiqn7FZNMhpihyuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1172/2651] bpf: Add sleepable arena page allocation path
Date: Wed, 18 Nov 2026 15:40:12 +0100
Message-ID: <20261118150330.204530283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Tsalapatis <emil@etsalapatis.com>

[ Upstream commit 5316ede1f5d07653a669285ca715a24152d729c6 ]

The bpf_arena_alloc_pages() function currently only allocates pages
inside a spinlock critical section with IRQs off. This forces the use of
alloc_pages_nolock() in the BPF allocator, even when the caller is a
sleepable BPF function. This in turn causes allocation failures even in
cases where falling into the allocator slow path and possibly sleeping
would eventually succeed. This can be triggered consistently by heavy
BPF arena users like scx.

Allocate the arena pages before taking the critical section and pass
whether the caller can sleep to bpf_alloc_pages(). This lets sleepable
callers use the blocking allocator while non-sleepable callers retain
the no-lock allocation behavior.

Fixes: b8467290edab ("bpf: arena: make arena kfuncs any context safe")
Signed-off-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261002105218.6171-4-emil@etsalapatis.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 73 +++++++++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 27 deletions(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index c556df7730c4e..0ff707707da04 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -713,6 +713,27 @@ static u64 clear_lo32(u64 val)
 	return val & ~(u64)~0U;
 }
 
+static int arena_adjust_tree(struct bpf_arena *arena, long uaddr, long page_cnt, long *pgoff)
+{
+	int ret;
+
+	/* Special case where user is requesting specific range. */
+	if (uaddr) {
+		ret = is_range_tree_set(&arena->rt, *pgoff, page_cnt);
+		if (ret)
+			return ret;
+		return range_tree_clear(&arena->rt, *pgoff, page_cnt);
+	}
+
+	ret = range_tree_find(&arena->rt, page_cnt);
+	if (ret < 0)
+		return ret;
+
+	*pgoff = ret;
+
+	return range_tree_clear(&arena->rt, *pgoff, page_cnt);
+}
+
 /*
  * Allocate pages and vmap them into kernel vmalloc area.
  * Later the pages will be mmaped into user space vma.
@@ -730,6 +751,7 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
 	unsigned long flags;
 	long pgoff = 0;
 	u32 uaddr32;
+	long addr = 0;
 	int ret;
 
 	if (node_id != NUMA_NO_NODE &&
@@ -747,8 +769,12 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
 			/* requested address will be outside of user VMA */
 			return 0;
 	}
-
 	bpf_map_memcg_enter(&arena->map, &old_memcg, &new_memcg);
+
+	ret = bpf_alloc_pages(node_id, page_cnt, &pages, sleepable);
+	if (ret)
+		goto out_memcg;
+
 	data.arena = arena;
 	data.pages = &pages;
 	data.i = 0;
@@ -756,25 +782,14 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
 	if (raw_res_spin_lock_irqsave(&arena->spinlock, flags))
 		goto out_free_pages;
 
-	if (uaddr) {
-		ret = is_range_tree_set(&arena->rt, pgoff, page_cnt);
-		if (ret)
-			goto out_unlock_free_pages;
-		ret = range_tree_clear(&arena->rt, pgoff, page_cnt);
-	} else {
-		ret = pgoff = range_tree_find(&arena->rt, page_cnt);
-		if (pgoff >= 0)
-			ret = range_tree_clear(&arena->rt, pgoff, page_cnt);
+	ret = arena_adjust_tree(arena, uaddr, page_cnt, &pgoff);
+	if (ret) {
+		raw_res_spin_unlock_irqrestore(&arena->spinlock, flags);
+		goto out_free_pages;
 	}
-	if (ret)
-		goto out_unlock_free_pages;
 
 	uaddr32 = (u32)(arena->user_vm_start + pgoff * PAGE_SIZE);
 
-	ret = bpf_alloc_pages(node_id, page_cnt, &pages, false);
-	if (ret)
-		goto out;
-
 	/*
 	 * Earlier checks made sure that uaddr32 + page_cnt * PAGE_SIZE - 1
 	 * will not overflow 32-bit. Lower 32-bit need to represent
@@ -787,26 +802,30 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
 				  page_cnt << PAGE_SHIFT, apply_range_set_cb, &data);
 	mapped = data.i;
 	if (ret)
-		goto out;
+		goto out_unmap;
 
 	flush_vmap_cache(kern_vm_start + uaddr32, mapped << PAGE_SHIFT);
 	raw_res_spin_unlock_irqrestore(&arena->spinlock, flags);
-	bpf_map_memcg_exit(old_memcg, new_memcg);
-	return clear_lo32(arena->user_vm_start) + uaddr32;
-out:
+
+	addr = clear_lo32(arena->user_vm_start) + uaddr32;
+	goto out_memcg;
+
+out_unmap:
+	/* Error handling: Undo partial mappings. */
+	flush_vmap_cache(kern_vm_start + uaddr32, mapped << PAGE_SHIFT);
 	range_tree_set(&arena->rt, pgoff + mapped, page_cnt - mapped);
 	raw_res_spin_unlock_irqrestore(&arena->spinlock, flags);
-	if (mapped) {
-		flush_vmap_cache(kern_vm_start + uaddr32, mapped << PAGE_SHIFT);
+	if (mapped)
 		arena_free_pages(arena, uaddr32, mapped, sleepable);
-	}
-	goto out_free_pages;
-out_unlock_free_pages:
-	raw_res_spin_unlock_irqrestore(&arena->spinlock, flags);
+
 out_free_pages:
+	/* Error handling: Free back any unmapped pages. */
 	bpf_free_pages(&pages);
+
+out_memcg:
 	bpf_map_memcg_exit(old_memcg, new_memcg);
-	return 0;
+
+	return addr;
 }
 
 /*
-- 
2.53.0



