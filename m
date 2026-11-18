Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018243;
	b=29PKGly2muF4pjOs4gb+/BKLJLqq1zeNjvpSyVHki8vRCLUaHymt0JZLoGIba8xYXsqZ
	 Mois1+1uiEf37mRpOgKpEhqlD3ZsyF84ojkxTxVt/98K2s8scK+z0tp7Q6xtRNLyWFl4c
	 GHd7uqK+R9VRhTZDaH/MSWZTWJWhy7dtZ65nKLEhBteAyJyfV0zNUXOyBjClCZQh18ypU
	 SNFXacMMxbL96Nfk1Q9UiLJDy0BFaa4Fjk2hNBuB8tpDS29DD3Ebfr2ojTna5mgHJvVog
	 mrzgN4gE22R0QsFEFfj85UWr/NfEkTWM8X99Mto7T00f4+fojxUcKZJzhx7HJtDs4zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KN5l480FvGDkcLAv0DulDSlK/EtRv7me4KpUtwR/3R0=;
	b=Optcg5VW4RNQFh6Rb69nTMDynBuB2YE7Jc82lDys00zUn4ZUgoEzKERQR4QsyU56Tu1E
	 baIJt8OJRYnNvOD1x05RxZxUBHkReJCkMwcGC/1peYYNB+u4FjRt3cE1x03hueSkqWaMd
	 yf1pTA8mCSxqU+xdcB4NKjmo9CqW6o799U1XUyUD6gZxxSWDVcwy7hKiG0hx2W76vFFE8
	 SG4JfsxjSC6MfNSO1XVJV+Tr+DdMW5SECu0Mm/OQ/RiqtI35PyKo3s1Cy6Lhl8VY6QLs2
	 ZBPngaNRf1NO+6hovt7Pn4Z3LwTK9d5Bx8G69bWGDKsztuZ3zMLrccAF/3lNrJnKjXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vFnZN9MB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDD6606A31C;
	Wed, 18 Nov 2026 16:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vFnZN9MB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6961F000C4;
	Wed, 18 Nov 2026 16:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018243;
	bh=KN5l480FvGDkcLAv0DulDSlK/EtRv7me4KpUtwR/3R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vFnZN9MB40HFhzox4y0Zbg+Bgen77EQW21MincpQNOczBqPZ/bNvoOYetsaJQRUQp
	 gIey5ir1/foUWyBGnLlrnmA3OBD4RG2sq8xTFHjeXfI7P+VpnRjLZQC/KyhbKc3/4B
	 F5w+iCeAw68e33IEQhWpyQ684r5YTrxtvYmsHhDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1169/2651] bpf: arena: Allocate the fault-in page outside the lock
Date: Wed, 18 Nov 2026 15:40:09 +0100
Message-ID: <20261118150330.095525808@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit c7cd8be3d72f9b03454424fff31542b8a0122437 ]

arena_vm_fault() allocated the page while holding arena->spinlock, so it
could only use the non-blocking allocator, which never reclaims. Once the
memcg is at memory.max that allocation just fails, the fault turns into
VM_FAULT_SIGSEGV, and the process gets a SIGSEGV on a perfectly valid
arena address. Hitting memory.max is routine (e.g. page cache from
reading a big file), so this kills innocent processes over memory that
reclaim could have freed.

Rework the fault handler:

- Preallocate the page before taking the lock, like do_anonymous_page()
  does, so it can sleep and reclaim, instead of turning a routine
  memory.max into a fake segfault. The allocation uses
  __GFP_RETRY_MAYFAIL so it never invokes the OOM killer: the page is
  charged to the map's memcg, which need not be the faulting task's, so
  an OOM there could kill unrelated tasks in the map's cgroup while a
  foreign faulter could never be its victim. map->numa_node is always
  NUMA_NO_NODE for an arena (BPF_F_NUMA_NODE is rejected), so the page
  comes from the local node, as before.

- On allocation failure fall through to the locked recheck rather than
  failing right away: a page a concurrent allocator installed meanwhile
  is used, otherwise the non-blocking fallback fails and we return
  VM_FAULT_SIGBUS. Not VM_FAULT_OOM: nothing ran the OOM killer, and the
  fault path would just retry it forever.

- A lockless probe skips that preallocation when a page is already mapped
  (e.g. allocated by the bpf program), so the common case wastes no
  allocation. The rare race where such a page is freed before we take the
  lock falls back to the non-blocking allocator under the lock.

- Return VM_FAULT_SIGBUS for the other non-recoverable errors
  (allocation, range-tree and page-table failures) instead of
  VM_FAULT_SIGSEGV; the lock failure already did. Only
  BPF_F_SEGV_ON_FAULT, and a scratch-page hole under that flag, is a
  real user addressing error and keeps VM_FAULT_SIGSEGV.

- Tidy up the error labels.

Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://patch.msgid.link/20260922101831.192102-2-jiayuan.chen@linux.dev
Stable-dep-of: 5316ede1f5d0 ("bpf: Add sleepable arena page allocation path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 83 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 63 insertions(+), 20 deletions(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 7b6847200b431..c6369ea5e2082 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -481,7 +481,8 @@ static vm_fault_t arena_vm_fault(struct vm_fault *vmf)
 	struct bpf_map *map = vmf->vma->vm_file->private_data;
 	struct bpf_arena *arena = container_of(map, struct bpf_arena, map);
 	struct mem_cgroup *new_memcg, *old_memcg;
-	struct page *page;
+	struct page *page, *new_page = NULL;
+	vm_fault_t fault_ret;
 	long kbase, kaddr;
 	unsigned long flags;
 	int ret;
@@ -489,59 +490,101 @@ static vm_fault_t arena_vm_fault(struct vm_fault *vmf)
 	kbase = bpf_arena_get_kern_vm_start(arena);
 	kaddr = kbase + (u32)(vmf->address);
 
-	if (raw_res_spin_lock_irqsave(&arena->spinlock, flags))
+	page = vmalloc_to_page((void *)kaddr);
+	if (!page && !(arena->map.map_flags & BPF_F_SEGV_ON_FAULT)) {
+		/*
+		 * Preallocate outside the lock so the allocation can reclaim;
+		 * __GFP_RETRY_MAYFAIL keeps the OOM killer out of it.
+		 */
+		bpf_map_memcg_enter(&arena->map, &old_memcg, &new_memcg);
+		new_page = alloc_pages_node(map->numa_node,
+					    GFP_KERNEL | __GFP_ZERO |
+					    __GFP_ACCOUNT | __GFP_NOWARN |
+					    __GFP_RETRY_MAYFAIL, 0);
+		bpf_map_memcg_exit(old_memcg, new_memcg);
+	}
+
+	if (raw_res_spin_lock_irqsave(&arena->spinlock, flags)) {
 		/*
 		 * A failed lock means a possible deadlock was detected. Don't
 		 * return VM_FAULT_RETRY: this handler never took mmap_lock, but
 		 * the fault path would re-take it on retry and deadlock. Fail.
 		 */
+		if (new_page)
+			free_pages_nolock(new_page, 0);
 		return VM_FAULT_SIGBUS;
+	}
 
 	page = vmalloc_to_page((void *)kaddr);
 	if (page) {
-		if (page == arena->scratch_page)
+		if (page == arena->scratch_page) {
 			/* BPF triggered scratch here; don't lazy-alloc over it */
-			goto out_sigsegv;
+			fault_ret = (arena->map.map_flags & BPF_F_SEGV_ON_FAULT)
+				    ? VM_FAULT_SIGSEGV : VM_FAULT_SIGBUS;
+			goto out_err_locked;
+		}
 		/* already have a page vmap-ed */
 		goto out;
 	}
 
+	if (arena->map.map_flags & BPF_F_SEGV_ON_FAULT) {
+		/*
+		 * User space requested to segfault when page is not allocated
+		 * by bpf prog
+		 */
+		fault_ret = VM_FAULT_SIGSEGV;
+		goto out_err_locked;
+	}
+
 	bpf_map_memcg_enter(&arena->map, &old_memcg, &new_memcg);
 
-	if (arena->map.map_flags & BPF_F_SEGV_ON_FAULT)
-		/* User space requested to segfault when page is not allocated by bpf prog */
-		goto out_sigsegv_memcg;
+	if (!new_page) {
+		/*
+		 * The probed page was freed meanwhile or preallocation failed;
+		 * try the non-blocking allocator, we cannot sleep here.
+		 */
+		ret = bpf_map_alloc_pages(map, map->numa_node, 1, &new_page);
+		if (ret) {
+			fault_ret = VM_FAULT_SIGBUS;
+			goto out_err_locked_memcg;
+		}
+	}
 
 	ret = range_tree_clear(&arena->rt, vmf->pgoff, 1);
-	if (ret)
-		goto out_sigsegv_memcg;
-
-	struct apply_range_data data = { .arena = arena, .pages = &page, .i = 0 };
-	/* Account into memcg of the process that created bpf_arena */
-	ret = bpf_map_alloc_pages(map, NUMA_NO_NODE, 1, &page);
 	if (ret) {
-		range_tree_set(&arena->rt, vmf->pgoff, 1);
-		goto out_sigsegv_memcg;
+		fault_ret = VM_FAULT_SIGBUS;
+		goto out_err_locked_memcg;
 	}
+	struct apply_range_data data = {
+		.arena = arena, .pages = &new_page, .i = 0
+	};
 
 	ret = apply_to_page_range(&init_mm, kaddr, PAGE_SIZE, apply_range_set_cb, &data);
 	if (ret) {
 		range_tree_set(&arena->rt, vmf->pgoff, 1);
-		free_pages_nolock(page, 0);
-		goto out_sigsegv_memcg;
+		fault_ret = VM_FAULT_SIGBUS;
+		goto out_err_locked_memcg;
 	}
 	flush_vmap_cache(kaddr, PAGE_SIZE);
 	bpf_map_memcg_exit(old_memcg, new_memcg);
+	/* new_page was consumed */
+	page = new_page;
+	new_page = NULL;
 out:
 	page_ref_add(page, 1);
 	raw_res_spin_unlock_irqrestore(&arena->spinlock, flags);
+	if (new_page)
+		free_pages_nolock(new_page, 0);
 	vmf->page = page;
 	return 0;
-out_sigsegv_memcg:
+
+out_err_locked_memcg:
 	bpf_map_memcg_exit(old_memcg, new_memcg);
-out_sigsegv:
+out_err_locked:
 	raw_res_spin_unlock_irqrestore(&arena->spinlock, flags);
-	return VM_FAULT_SIGSEGV;
+	if (new_page)
+		free_pages_nolock(new_page, 0);
+	return fault_ret;
 }
 
 static const struct vm_operations_struct arena_vm_ops = {
-- 
2.53.0



