Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6140F2550CD;
	Mon, 12 May 2025 18:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072846; cv=none; b=Z/6v9neqkEIw7eiKwXACsSUSG5GXcERi9KcrCSrMr7EOINCfN286UID6ebb7ANWrPdhWSrneNOJT9fXH7GC5lXPScjrLa8VyZoQi3R4SOPAKl0RiP7h6HFIVd+//oeeUmmKL5HkPZVEdFswUuCNRhGxi9ez+CUuoRcWnHMlBkGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072846; c=relaxed/simple;
	bh=+6cAxesUuWrSf5Q5M+ppbZ/0XWzdlZcNSChbWv2/V9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYaKtr2ufT3htL3qXe9MOFauFh0WJTfBR9lwmpgXxhH16e4RezAoAv47eRZEZqfzSk1VYRxXln6F0+lthRFaaaWyehQ/d2j55ifd41QYuSWcusJAI+MP4bvZ7/+w+onJQEmyJVlsIFXAvkFi0AbR9V78PgLpbx4f9c/3wEcj718=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKgGOBvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKgGOBvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FD0C4CEE7;
	Mon, 12 May 2025 18:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072846;
	bh=+6cAxesUuWrSf5Q5M+ppbZ/0XWzdlZcNSChbWv2/V9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKgGOBvU4spBbKvpytiZ8ZNKHGSY8BaEmhid0NHCr9bVsYHEPrw2EZttrRVOjZZtJ
	 ENGlZJGP4AdtHgd6UuTLg7m4NkurSOGExaedEFsxA7Ad9Dr+toVzW3UXXPQ7H7Ep7I
	 czk8S+cgqB41BhqOg6Cs9HfS+JbXkbE4uvC+61mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Erhard Furtner <erhard_f@mailbox.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 074/184] mm: vmalloc: support more granular vrealloc() sizing
Date: Mon, 12 May 2025 19:44:35 +0200
Message-ID: <20250512172044.843396589@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kees Cook <kees@kernel.org>

commit a0309faf1cb0622cac7c820150b7abf2024acff5 upstream.

Introduce struct vm_struct::requested_size so that the requested
(re)allocation size is retained separately from the allocated area size.
This means that KASAN will correctly poison the correct spans of requested
bytes.  This also means we can support growing the usable portion of an
allocation that can already be supported by the existing area's existing
allocation.

Link: https://lkml.kernel.org/r/20250426001105.it.679-kees@kernel.org
Fixes: 3ddc2fefe6f3 ("mm: vmalloc: implement vrealloc()")
Signed-off-by: Kees Cook <kees@kernel.org>
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Closes: https://lore.kernel.org/all/20250408192503.6149a816@outsider.home/
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/vmalloc.h |    1 +
 mm/vmalloc.c            |   31 ++++++++++++++++++++++++-------
 2 files changed, 25 insertions(+), 7 deletions(-)

--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -61,6 +61,7 @@ struct vm_struct {
 	unsigned int		nr_pages;
 	phys_addr_t		phys_addr;
 	const void		*caller;
+	unsigned long		requested_size;
 };
 
 struct vmap_area {
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1940,7 +1940,7 @@ static inline void setup_vmalloc_vm(stru
 {
 	vm->flags = flags;
 	vm->addr = (void *)va->va_start;
-	vm->size = va_size(va);
+	vm->size = vm->requested_size = va_size(va);
 	vm->caller = caller;
 	va->vm = vm;
 }
@@ -3128,6 +3128,7 @@ static struct vm_struct *__get_vm_area_n
 
 	area->flags = flags;
 	area->caller = caller;
+	area->requested_size = requested_size;
 
 	va = alloc_vmap_area(size, align, start, end, node, gfp_mask, 0, area);
 	if (IS_ERR(va)) {
@@ -4067,6 +4068,8 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
  */
 void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
 {
+	struct vm_struct *vm = NULL;
+	size_t alloced_size = 0;
 	size_t old_size = 0;
 	void *n;
 
@@ -4076,15 +4079,17 @@ void *vrealloc_noprof(const void *p, siz
 	}
 
 	if (p) {
-		struct vm_struct *vm;
-
 		vm = find_vm_area(p);
 		if (unlikely(!vm)) {
 			WARN(1, "Trying to vrealloc() nonexistent vm area (%p)\n", p);
 			return NULL;
 		}
 
-		old_size = get_vm_area_size(vm);
+		alloced_size = get_vm_area_size(vm);
+		old_size = vm->requested_size;
+		if (WARN(alloced_size < old_size,
+			 "vrealloc() has mismatched area vs requested sizes (%p)\n", p))
+			return NULL;
 	}
 
 	/*
@@ -4092,14 +4097,26 @@ void *vrealloc_noprof(const void *p, siz
 	 * would be a good heuristic for when to shrink the vm_area?
 	 */
 	if (size <= old_size) {
-		/* Zero out spare memory. */
-		if (want_init_on_alloc(flags))
+		/* Zero out "freed" memory. */
+		if (want_init_on_free())
 			memset((void *)p + size, 0, old_size - size);
+		vm->requested_size = size;
 		kasan_poison_vmalloc(p + size, old_size - size);
-		kasan_unpoison_vmalloc(p, size, KASAN_VMALLOC_PROT_NORMAL);
 		return (void *)p;
 	}
 
+	/*
+	 * We already have the bytes available in the allocation; use them.
+	 */
+	if (size <= alloced_size) {
+		kasan_unpoison_vmalloc(p + old_size, size - old_size,
+				       KASAN_VMALLOC_PROT_NORMAL);
+		/* Zero out "alloced" memory. */
+		if (want_init_on_alloc(flags))
+			memset((void *)p + old_size, 0, size - old_size);
+		vm->requested_size = size;
+	}
+
 	/* TODO: Grow the vm_area, i.e. allocate and map additional pages. */
 	n = __vmalloc_noprof(size, flags);
 	if (!n)


