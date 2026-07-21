Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0981A46C4BC;
	Tue, 21 Jul 2026 15:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649154; cv=none; b=JpBxJ/pWPXWLuPdcb0MaGMn/9YH0q33KW0WUi3YD52lK0THqlt/W0EA48xnBhyzaeihG7VUG7DIu8HptKuBAChPdwsE6hFsnJSZX5sTARhILgRzxtNtraEgzfpLQr7OJJ/n84wKyqFfLWEjAPWX4/+GWNayE88YZEj1OzlKyWds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649154; c=relaxed/simple;
	bh=FKMwNWxEFEWjLeHnp8jLCpT3Ofl53XHFPEumQgL13w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8VY4YyaWhyX4L7ZmKfpT187RPuAjnjH02iIi9mvf7od/44p1HpS2vVljMqwrdMOT4UIFGOscDlPmpd8HY2MsFPOT/6NY0755hiHWmgj1IiKW0GUo8NkLBzc8spLP0gIW00f2W8n2b1k6MFk4c0JPMpHi8btUw/PR9YzKT1Nmhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0ctbVOi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0ctbVOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651BD1F000E9;
	Tue, 21 Jul 2026 15:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649152;
	bh=BsObQOnve24vqZrYNQ19E3rEPTLzIRqx2OQ9dGeP29o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y0ctbVOiwLACc87w9b+oXAdncLQ7RtgtVALcticjmRNusdixwND9WeluzMhNv26CC
	 t9fsJIeYlaDcNq4jzDHmKcwUFgXCxxowV4a5YdnY44e9vWCsQXMThyR4aJBhrIMWzk
	 jvUvqbN+0Df0tfnrLjK+suqAVlTgKSl7iY86zSaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0471/2077] bpf: Take mmap_lock in zap_pages()
Date: Tue, 21 Jul 2026 17:02:24 +0200
Message-ID: <20260721152603.907304946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 80b89d0226a05e8b67969de99c31b51fcd54f76a ]

zap_vma_range() requires the owning mm's mmap_lock to be held.

Taking mmap_read_lock under arena->lock would AB-BA against
arena_vm_close() and arena_map_mmap(), both of which run with
mmap_write_lock held and then acquire arena->lock. Instead drop
arena->lock, mmget_not_zero() the vma's mm, take mmap_read_lock, and
re-resolve the vma via find_vma() since it may have been unmapped or
replaced while waiting.

Track processed vmls with a per-call generation in vml->zap_gen and
serialize zap_pages() callers with a new arena->zap_mutex so
concurrent callers on different uaddr ranges do not mark each other's
vmls processed before the zap is done.

Reported-by: David Hildenbrand <david@kernel.org>
Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/r/20260528222014.38980-1-alexei.starovoitov@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 61 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 57 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 49a8f7b1beef59..40c42e28a6168c 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -59,6 +59,8 @@ struct bpf_arena {
 	struct list_head vma_list;
 	/* protects vma_list */
 	struct mutex lock;
+	u64 zap_gen;
+	struct mutex zap_mutex;
 	struct irq_work     free_irq;
 	struct work_struct  free_work;
 	struct llist_head   free_spans;
@@ -228,6 +230,7 @@ static struct bpf_map *arena_map_alloc(union bpf_attr *attr)
 		goto err;
 	}
 	mutex_init(&arena->lock);
+	mutex_init(&arena->zap_mutex);
 	raw_res_spin_lock_init(&arena->spinlock);
 	err = populate_pgtable_except_pte(arena);
 	if (err) {
@@ -318,6 +321,7 @@ struct vma_list {
 	struct vm_area_struct *vma;
 	struct list_head head;
 	refcount_t mmap_count;
+	u64 zap_gen;
 };
 
 static int remember_vma(struct bpf_arena *arena, struct vm_area_struct *vma)
@@ -330,6 +334,7 @@ static int remember_vma(struct bpf_arena *arena, struct vm_area_struct *vma)
 	refcount_set(&vml->mmap_count, 1);
 	vma->vm_private_data = vml;
 	vml->vma = vma;
+	vml->zap_gen = 0;
 	list_add(&vml->head, &arena->vma_list);
 	return 0;
 }
@@ -668,12 +673,60 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
  */
 static void zap_pages(struct bpf_arena *arena, long uaddr, long page_cnt)
 {
+	unsigned long size = (unsigned long)page_cnt << PAGE_SHIFT;
+	struct vm_area_struct *vma;
+	struct mm_struct *mm;
 	struct vma_list *vml;
+	unsigned long vm_start;
+	u64 my_gen;
 
-	guard(mutex)(&arena->lock);
-	/* iterate link list under lock */
-	list_for_each_entry(vml, &arena->vma_list, head)
-		zap_vma_range(vml->vma, uaddr, PAGE_SIZE * page_cnt);
+	/*
+	 * Taking mmap_read_lock() under arena->lock would deadlock against
+	 * arena_vm_close(), which runs with mmap_write_lock held and then
+	 * acquires arena->lock. Drop arena->lock for mmap_read_lock().
+	 *
+	 * Use per-call my_gen, recorded in vml->zap_gen, to remember which
+	 * vmls this invocation has already processed across the lock drop.
+	 * Hold zap_mutex around the whole walk so concurrent zap_pages()
+	 * callers cannot overwrite each other's marks on shared vmls --
+	 * otherwise call B's mark would make call A skip a vml that A has
+	 * not yet zapped for A's uaddr range.
+	 */
+	mutex_lock(&arena->zap_mutex);
+	mutex_lock(&arena->lock);
+	my_gen = ++arena->zap_gen;
+	for (;;) {
+		mm = NULL;
+		list_for_each_entry(vml, &arena->vma_list, head) {
+			if (vml->zap_gen >= my_gen)
+				continue;
+			vml->zap_gen = my_gen;
+			if (!mmget_not_zero(vml->vma->vm_mm))
+				continue;
+			mm = vml->vma->vm_mm;
+			vm_start = vml->vma->vm_start;
+			break;
+		}
+		if (!mm)
+			break;
+		mutex_unlock(&arena->lock);
+
+		mmap_read_lock(mm);
+		/*
+		 * Re-resolve: while we waited the VMA could have been unmapped
+		 * and a different mapping installed at the same address.
+		 */
+		vma = find_vma(mm, vm_start);
+		if (vma && vma->vm_start == vm_start &&
+		    vma->vm_file && vma->vm_file->private_data == &arena->map)
+			zap_vma_range(vma, uaddr, size);
+		mmap_read_unlock(mm);
+		mmput(mm);
+
+		mutex_lock(&arena->lock);
+	}
+	mutex_unlock(&arena->lock);
+	mutex_unlock(&arena->zap_mutex);
 }
 
 static void arena_free_pages(struct bpf_arena *arena, long uaddr, long page_cnt, bool sleepable)
-- 
2.53.0



