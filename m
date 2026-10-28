Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211581;
	b=cY63RcSmGLlgzMieM4OV4GahnJgz5LckoDo7fyRdpe6P909+fepFq2vOJL8jG9k0F/kt
	 Yt/wZVkPhQkuX9TIsJO/ONLB5nHzXohBYQi2gwHcit4RnmJCN2zwxnz6I0AHzhNRFgBLR
	 VrRX290gGUs2YnHHx7Uz/fgJCL7m1q5KmW2VCG6HedWszxqY5RoPMEJpZj3DeGfm0EsSl
	 +NAcP11xV9Jz1apc0BC00bNGGWXvlHJ4p/hcrhbpisnX6a4f+1vUtGi522No7pY7H9aF1
	 46+F/V8TNWG8c3aFgAnPZZOnH5ZaCWC7lm3gf66Tst2KF7vwvVLR8Ibzo0De88+V9lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G/S+owyDT59GtWU6IQtxmCA+sfgdOD2KINza+OSb5Q0=;
	b=eN03VnHuWZH50ir3hgJ4HaA+NTilrUmlzU4bruDSl7vqJu6szhiOzvSMrV+Qgs3w/Jae
	 9IhRmhZhmGa8U5UT8JAyOtMVvhbDMCrQU2i7WI5vqNpjj+zu3H7kD+atlqRzI6wsqEWOg
	 TrPSLqgxhLBclnSwDN05YauymQk8L47fzHegnTwIuJtCfejUoE1ROgkM7jRqwHRXJ1eKo
	 4rJ8jQp0stvIFfjR7yJbkLNUuQ59wonHU8pzTZTKMEC8mY+I0FnqDERVGOhpOS6IHqKeC
	 2WVA7KXRewCMlMH8tKuUahgUUeiRxQ1YOpsXXoWKM6P8X3gCWNiMT50JTI9fS+53UnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mCU9Pdy4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEA4606A31D;
	Wed, 28 Oct 2026 18:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mCU9Pdy4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43F21F01825;
	Wed, 28 Oct 2026 18:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211581;
	bh=G/S+owyDT59GtWU6IQtxmCA+sfgdOD2KINza+OSb5Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mCU9Pdy4PIPx2fZeRPZtOI58Y+K7IG6LL2Z45G3fOMlTMAy0iGTh5uZz6fconVXM6
	 YXqhbS04MVyjKLlIpZIk3kOdG46n9KK/fVLPRbdHNfW/S1egefqqMAvHLpg4D3cVgQ
	 o5AsBwZRctrlr/HGqBbjCZSegWuLYbocww995dLg=
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
Subject: [PATCH 5.15 429/571] mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP self-merge
Date: Wed, 28 Oct 2026 17:59:36 +0100
Message-ID: <20261028170018.196713292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 071dd864a7b2b..bd69dd6c5e9d5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2581,7 +2581,7 @@ extern void __vma_link_rb(struct mm_struct *, struct vm_area_struct *,
 extern void unlink_file_vma(struct vm_area_struct *);
 extern struct vm_area_struct *copy_vma(struct vm_area_struct **,
 	unsigned long addr, unsigned long len, pgoff_t pgoff,
-	bool *need_rmap_locks);
+	bool *need_rmap_locks, bool keep_source);
 extern void exit_mmap(struct mm_struct *);
 
 static inline int check_data_rlimit(unsigned long rlim,
diff --git a/mm/mmap.c b/mm/mmap.c
index 52ab2f7f6632a..53fa4f5167dd0 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -3281,7 +3281,7 @@ int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
  */
 struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	unsigned long addr, unsigned long len, pgoff_t pgoff,
-	bool *need_rmap_locks)
+	bool *need_rmap_locks, bool keep_source)
 {
 	struct vm_area_struct *vma = *vmap;
 	unsigned long vma_start = vma->vm_start;
@@ -3289,6 +3289,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	struct vm_area_struct *new_vma, *prev;
 	struct rb_node **rb_link, *rb_parent;
 	bool faulted_in_anon_vma = true;
+	bool can_self_merge = false;
 
 	/*
 	 * If anonymous vma has not yet been faulted, update new pgoff
@@ -3297,13 +3298,27 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	if (unlikely(vma_is_anonymous(vma) && !vma->anon_vma)) {
 		pgoff = addr >> PAGE_SHIFT;
 		faulted_in_anon_vma = false;
+		can_self_merge = true;
 	}
 
 	if (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent))
 		return NULL;	/* should never get here */
-	new_vma = vma_merge(mm, prev, addr, addr + len, vma->vm_flags,
-			    vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma),
-			    vma->vm_userfaultfd_ctx);
+
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
+				    vma_policy(vma), vma->vm_userfaultfd_ctx);
 	if (new_vma) {
 		/*
 		 * Source vma may have been merged into new_vma
diff --git a/mm/mremap.c b/mm/mremap.c
index f7a5f1106699d..5d8b8309ae2ac 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -629,7 +629,7 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 
 	new_pgoff = vma->vm_pgoff + ((old_addr - vma->vm_start) >> PAGE_SHIFT);
 	new_vma = copy_vma(&vma, new_addr, new_len, new_pgoff,
-			   &need_rmap_locks);
+			   &need_rmap_locks, flags & MREMAP_DONTUNMAP);
 	if (!new_vma) {
 		if (unlikely(flags & MREMAP_DONTUNMAP && vm_flags & VM_ACCOUNT))
 			vm_unacct_memory(new_len >> PAGE_SHIFT);
@@ -686,6 +686,9 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 		untrack_pfn_moved(vma);
 
 	if (unlikely(!err && (flags & MREMAP_DONTUNMAP))) {
+		/* Self-merge is disallowed. */
+		VM_WARN_ON_ONCE(new_vma == vma);
+
 		/* We always clear VM_LOCKED[ONFAULT] on the old vma */
 		vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
 
@@ -693,7 +696,7 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 		 * anon_vma links of the old vma is no longer needed after its page
 		 * table has been moved.
 		 */
-		if (new_vma != vma && vma->vm_start == old_addr &&
+		if (vma->vm_start == old_addr &&
 			vma->vm_end == (old_addr + old_len)) {
 			const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
 
-- 
2.53.0



