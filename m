Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213473;
	b=yVmSodazK2pYu/fQnL844cbQz9KGZ+Ay9Y6QbmT+UoPL7dqidZnWbf7kon/yNPvo2JUM
	 ZNHy7zjZADojYHjZN3e0IC7Yc8m227qq8ozudCqLNILUQGPUXIYeifm/LPhTGhXdp0J0d
	 2zFva5OGWJLvcINN7DjKbR0pK/N03J7rkmxuA1nr2+ZOZMzzL5+zJaFMtqKNfD7poyULr
	 dWfqSQhiyAqNgx9WP19Hdx9hypfgQY65I/k4TsXbiUC7nGrmUkMvsQyNQmGRQPszy4l0C
	 nsDbXQrTV+iOgaCJqiC7FjB1PEmNBKttM+jLW3wkAf3WT1yWVBjwRh9POoiD00bYGVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A7rE/TNfAypJtMC1OuujUdC461Obv8C3BA77Rr71ikw=;
	b=ujC6NPhliaZAi8so76M3lN0XOBmZD+yFL3pxT/IQ0iggHU7HvIkoqclr8PLPxyifhUat
	 6sAJTM3DwH8UV0nMPYN6gw8BuDONrndAyeU09T0lLgcSWY6WyWD6q/dapiG7VElG9Mnfk
	 efJOoyan6nZ4oxsn4qoRNTMqHPzZJBqF6yHPL80CRsGMxAoFBQKGwOWTusKu+V0LbeS0i
	 L3Gd4Oxu84L4/XP37/wQMhdb1UYM0WlP/7c5VI2FHY/r36BWuG3EIV5WRPO7fV64+Q8JN
	 qFS9En0MGAf6A4k3yLpi3mfqF1rtooqhUSC6ljMKd2gd1mFy8Do6DdPF3fG2wl8sdvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j78l++C4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A86606A31A;
	Wed, 28 Oct 2026 18:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j78l++C4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677961F01828;
	Wed, 28 Oct 2026 18:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213472;
	bh=A7rE/TNfAypJtMC1OuujUdC461Obv8C3BA77Rr71ikw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j78l++C4k44kCBAwoPcn7VMA1ujMO51Q+fkQoab6xWXaqVvOIvKPOn4fH1yRCKxNI
	 oR0Tx2uVPonEYIfHbDC5IfCojFkGmcwIey661Lf3RWlomTxNBrBmbb7AgxaKxRHRgl
	 qm14SXZ5o2ksffx41jo585ZWbSI6u0vQHBE+ARHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0517/1887] mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP self-merge
Date: Wed, 28 Oct 2026 17:43:33 +0100
Message-ID: <20261028170511.086529899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 838bb60dc21553e32df90f2f3bac5b905376e7aa ]

The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
operations that keep the original VMA in place.

Historically this has led to a lot of bugs where non-obvious interactions
occur between existing mremap() operations and the original VMA.

Fix another of these - self-merge.

Self-merge occurs when a VMA is moved in front of or behind itself and the
attributes of the VMA permit such a merge.

Practically this can only happen for unfaulted anonymous VMAs due to the
page offset equality requirement for merge:

                           |------------|
                           |            |
                           |            v
        |...........||-----------||...........|
        |           || unfaulted ||           |
        |...........||-----------||...........|
              ^            |
              |            |
              |------------|

This becomes problematic if the VMA is configured by the user to
mlock-on-fault, i.e. the VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT VMA flags are
set.

MREMAP_DONTUNMAP clears mlock flags for the source VMA and maintains them
for the destination VMA.

Self-merge makes this impossible (there is only one VMA) and incorrectly
clears the destination VMA's mlock flags.

This causes a leak in mm->locked_vm as clearing this flag does not
decrement the counter and the VMA no longer has VMA_LOCKED_BIT set so it
is not decremented on unmap.

Resolve this by simply disallowing a self-merge in this case - the source
and destination VMAs are kept distinct and then are able to have distinct
mlock() flags.

Update to make the now-redundant self-merge check a VM_WARN_ON_ONCE()
instead to guard against future regressions.

Fixes: e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Cc: <stable@vger.kernel.org>
[ ljs - Converted to work with vma_merge(), tweaked commit msg. ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm.h |  2 +-
 mm/mmap.c          | 23 +++++++++++++++++++----
 mm/mremap.c        |  7 +++++--
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4f0aa81257c58..279c121ef6b3c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2822,7 +2822,7 @@ extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void unlink_file_vma(struct vm_area_struct *);
 extern struct vm_area_struct *copy_vma(struct vm_area_struct **,
 	unsigned long addr, unsigned long len, pgoff_t pgoff,
-	bool *need_rmap_locks);
+	bool *need_rmap_locks, bool keep_source);
 extern void exit_mmap(struct mm_struct *);
 
 void vma_mas_store(struct vm_area_struct *vma, struct ma_state *mas);
diff --git a/mm/mmap.c b/mm/mmap.c
index d39e31f15e86c..54c73823fba33 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -3337,13 +3337,14 @@ int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
  */
 struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	unsigned long addr, unsigned long len, pgoff_t pgoff,
-	bool *need_rmap_locks)
+	bool *need_rmap_locks, bool keep_source)
 {
 	struct vm_area_struct *vma = *vmap;
 	unsigned long vma_start = vma->vm_start;
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *new_vma, *prev;
 	bool faulted_in_anon_vma = true;
+	bool can_self_merge = false;
 
 	validate_mm_mt(mm);
 	/*
@@ -3353,15 +3354,29 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	if (unlikely(vma_is_anonymous(vma) && !vma->anon_vma)) {
 		pgoff = addr >> PAGE_SHIFT;
 		faulted_in_anon_vma = false;
+		can_self_merge = true;
 	}
 
 	new_vma = find_vma_prev(mm, addr, &prev);
 	if (new_vma && new_vma->vm_start < addr + len)
 		return NULL;	/* should never get here */
 
-	new_vma = vma_merge(mm, prev, addr, addr + len, vma->vm_flags,
-			    vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma),
-			    vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+	/*
+	 * If the original VMA is kept (MREMAP_DONTUNMAP), the source and
+	 * destination VMA must be treated distinctly.
+	 *
+	 * A merge violates this, so in this case disallow a self-merge. A
+	 * self-merge can only occur if the new range is immediately adjacent to
+	 * the source VMA, so simply do not attempt to merge in that case.
+	 */
+	if (can_self_merge && keep_source &&
+	    (addr == vma->vm_end || vma->vm_start == addr + len))
+		new_vma = NULL;
+	else
+		new_vma = vma_merge(mm, prev, addr, addr + len, vma->vm_flags,
+				    vma->anon_vma, vma->vm_file, pgoff,
+				    vma_policy(vma), vma->vm_userfaultfd_ctx,
+				    anon_vma_name(vma));
 	if (new_vma) {
 		/*
 		 * Source vma may have been merged into new_vma
diff --git a/mm/mremap.c b/mm/mremap.c
index e1d7047f6ee5e..5eca7534e8706 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -639,7 +639,7 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 
 	new_pgoff = vma->vm_pgoff + ((old_addr - vma->vm_start) >> PAGE_SHIFT);
 	new_vma = copy_vma(&vma, new_addr, new_len, new_pgoff,
-			   &need_rmap_locks);
+			   &need_rmap_locks, flags & MREMAP_DONTUNMAP);
 	if (!new_vma) {
 		if (vm_flags & VM_ACCOUNT)
 			vm_unacct_memory(to_account >> PAGE_SHIFT);
@@ -700,6 +700,9 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 		untrack_pfn_clear(vma);
 
 	if (unlikely(!err && (flags & MREMAP_DONTUNMAP))) {
+		/* Self-merge is disallowed. */
+		VM_WARN_ON_ONCE(new_vma == vma);
+
 		/* We always clear VM_LOCKED[ONFAULT] on the old vma */
 		vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
 
@@ -707,7 +710,7 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 		 * anon_vma links of the old vma is no longer needed after its page
 		 * table has been moved.
 		 */
-		if (new_vma != vma && vma->vm_start == old_addr &&
+		if (vma->vm_start == old_addr &&
 			vma->vm_end == (old_addr + old_len)) {
 			const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
 
-- 
2.53.0



