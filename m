Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C6546EF92;
	Fri,  9 Oct 2026 14:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556018; cv=none; b=cY0AE5L0xa0CX6fY7gWJQ9qNtGzdNJ2E9m9kgqEA31Z+1yEXYQweT+zs3m8DkoJ28z+k3dExM9tVIyZk4+dOXTayVG+HyYV4H0scTbw2dON2qnQgFosAaoDri+SAhEOjQ8nTEOpYTBwSzKAqiaQqhB4M+3fi+FX0XuvLilH0WoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556018; c=relaxed/simple;
	bh=ZHLm/LfY4LF3FeEv83G4ic8Qfj5KkxuXLhIo0fqUo/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r4YrTdjCjto7HghCZEDWG3k4Jj3XbNITgUhbvmlRUdXIaKYJfjIFRFohgFhOi1q9AB000Gj7/oBd+wplkDE9JG1sO2DX2YBBy9tcl/FArimty3MWi3F/V0U5xrv7LwT8//xFTZ+Y+DLE8xfNsuj7NtqsPJ1g1t6z6rKGvzGBdPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arOj3XL1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arOj3XL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D298F1F00899;
	Fri,  9 Oct 2026 14:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556017;
	bh=TzoKPqMBXsB5be4UJ/ghT3W+b7bfvwDPE+mSnSHl+Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=arOj3XL16N1pL3fDo14fNraqRy8pngJmr8BR9m4s/48h49Yp5m5G6mfFyuHc6y0oK
	 voic7jYo4o+g2XbyGntFPAO3h1PwSLmjH0yqNyDdTZWf9a+MjjQul4avFd65VHt1Qw
	 Hi4rqX5OOTXLkkAXyb266xqcwGgVZnhaJVRQLucI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 108/428] bpf: Hold map BTF for the memory allocator destructor record
Date: Fri,  9 Oct 2026 16:07:25 +0200
Message-ID: <20261009140948.579533290@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit ab39974240a0cff765f3bb9cce81d8001ffdb144 ]

bpf_ma_set_dtor() duplicates map->record so that the bpf_mem_alloc
destructor can release the special fields of hash and rhash map elements
once the allocator frees them for good. btf_record_dup() only acquires
references on kernel and module BTF. Fields whose types live in the map
BTF keep pointing into it: a kptr to a local type refers to map->btf,
and a list_head or rb_root field carries a value_rec owned by the struct
meta table of map->btf.

That borrowed state can outlive the map. When RCU callbacks are still in
flight, bpf_mem_alloc_destroy() copies the allocator and defers the final
drain, together with the destructor context, to a workqueue.
bpf_map_free() then frees map->record and drops the map's BTF reference
as soon as map_free() returns. Once the program that loaded the BTF is
gone as well, the BTF is freed while the worker still uses the
duplicate. The worker dereferences it through btf_is_kernel() and
btf_find_struct_meta() in bpf_obj_free_fields() when destroying elements
that were freed under RCU, and through btf_is_kernel() in
btf_record_free() when releasing the context itself:

  BUG: KASAN: slab-use-after-free in btf_is_kernel+0x19/0x30
  Read of size 1 at addr ffff88811505dce8 by task kworker/u16:2/50
  Workqueue: events_unbound free_mem_alloc_deferred
  Call Trace:
   btf_is_kernel+0x19/0x30
   btf_record_free+0xc7/0xf0
   htab_dtor_ctx_free+0x1a/0x30
   free_mem_alloc_no_barrier+0x39/0x230
   free_mem_alloc_deferred+0x2a/0x40
   process_scheduled_works+0x5ce/0x9d0
   worker_thread+0x42a/0x5e0
   kthread+0x1f5/0x230
   ret_from_fork+0x1dd/0x390
   ret_from_fork_asm+0x1a/0x30

  Allocated by task 358:
   __kmalloc_cache_noprof+0x287/0x510
   btf_new_fd+0xf7/0x3d0
   __sys_bpf+0x487/0x840

  Freed by task 0:
   kfree+0x186/0x560
   rcu_core+0x6f6/0xd40

Freeing a map that still holds more elements than the allocator's high
watermark is enough to get there, because the bulk free during teardown
queues the RCU callback that makes bpf_mem_alloc_destroy() defer.
Non-preallocated hash maps and resizable hash maps both register the
destructor and are affected alike.

Keep one reference on the map BTF in the destructor context. Every
non-kernel pointer in the duplicated record is either map->btf or memory
owned by it, so a single reference covers kptrs, list heads, and rb
roots, and mirrors what bpf_map_meta_alloc() does for the duplicated
record of an inner map. Release it only after the duplicated record has
been freed: the worker is preemptible and not in an RCU read-side
critical section, so dropping the last reference first would let the
BTF be freed while btf_record_free() still reads its fields.

Fixes: 1df97a7453ee ("bpf: Register dtor for freeing special fields")
Reported-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20260901062845.1379760-3-chenyuan_fl@163.com
Link: https://patch.msgid.link/20260925064652.2261885-1-memxor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 61ef6191f79ad..68b7e87268f21 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -128,6 +128,7 @@ struct htab_elem {
 
 struct htab_btf_record {
 	struct btf_record *record;
+	struct btf *btf;
 	u32 key_size;
 };
 
@@ -497,8 +498,13 @@ static void htab_dtor_ctx_free(void *ctx)
 {
 	struct htab_btf_record *hrec = ctx;
 
+	/*
+	 * The duplicated record still points into the map BTF, so free it
+	 * before dropping the reference that keeps that BTF alive.
+	 */
 	btf_record_free(hrec->record);
-	kfree(ctx);
+	btf_put(hrec->btf);
+	kfree(hrec);
 }
 
 static int bpf_ma_set_dtor(struct bpf_map *map, struct bpf_mem_alloc *ma,
@@ -521,6 +527,15 @@ static int bpf_ma_set_dtor(struct bpf_map *map, struct bpf_mem_alloc *ma,
 		kfree(hrec);
 		return err;
 	}
+	/*
+	 * btf_record_dup() only acquires kernel and module BTF. Fields whose
+	 * types live in the map BTF keep pointing into it: kptrs to local
+	 * types refer to map->btf, and graph roots carry a value record owned
+	 * by its struct meta table. The context can outlive the map when the
+	 * allocator defers its teardown, so hold a reference of our own.
+	 */
+	hrec->btf = map->btf;
+	btf_get(hrec->btf);
 	bpf_mem_alloc_set_dtor(ma, dtor, htab_dtor_ctx_free, hrec);
 	return 0;
 }
-- 
2.53.0



