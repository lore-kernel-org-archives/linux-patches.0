Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A031EA8F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88D4C433C8;
	Tue,  1 Aug 2023 09:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883441;
	bh=xQ0T0vI8Z7xS+7Ts1lyIfeWB9UPz0g1wrLrRbSViaZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgqaoGHNkwbrYcx5eRGxTtbxyoMg1nL25VELIFgf/TOQvnelUT7qEcZnXDcDy0int
	 T6C+YP+FdG/6N3iz5ijczA1uDOE6lDmwXdGBHP0QU0aIAJUTGdGtdmRXibNXiFwhhd
	 7iHPMiBpZHgRAR0ky4kTRBR96Gi63gUliUYcjh58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	stable@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.4 237/239] mm/mempolicy: Take VMA lock before replacing policy
Date: Tue,  1 Aug 2023 11:21:41 +0200
Message-ID: <20230801091934.599552469@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jann Horn <jannh@google.com>

commit 6c21e066f9256ea1df6f88768f6ae1080b7cf509 upstream.

mbind() calls down into vma_replace_policy() without taking the per-VMA
locks, replaces the VMA's vma->vm_policy pointer, and frees the old
policy.  That's bad; a concurrent page fault might still be using the
old policy (in vma_alloc_folio()), resulting in use-after-free.

Normally this will manifest as a use-after-free read first, but it can
result in memory corruption, including because vma_alloc_folio() can
call mpol_cond_put() on the freed policy, which conditionally changes
the policy's refcount member.

This bug is specific to CONFIG_NUMA, but it does also affect non-NUMA
systems as long as the kernel was built with CONFIG_NUMA.

Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Fixes: 5e31275cc997 ("mm: add per-VMA lock and helper functions to control it")
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -384,8 +384,10 @@ void mpol_rebind_mm(struct mm_struct *mm
 	VMA_ITERATOR(vmi, mm, 0);
 
 	mmap_write_lock(mm);
-	for_each_vma(vmi, vma)
+	for_each_vma(vmi, vma) {
+		vma_start_write(vma);
 		mpol_rebind_policy(vma->vm_policy, new);
+	}
 	mmap_write_unlock(mm);
 }
 
@@ -765,6 +767,8 @@ static int vma_replace_policy(struct vm_
 	struct mempolicy *old;
 	struct mempolicy *new;
 
+	vma_assert_write_locked(vma);
+
 	pr_debug("vma %lx-%lx/%lx vm_ops %p vm_file %p set_policy %p\n",
 		 vma->vm_start, vma->vm_end, vma->vm_pgoff,
 		 vma->vm_ops, vma->vm_file,
@@ -1313,6 +1317,14 @@ static long do_mbind(unsigned long start
 	if (err)
 		goto mpol_out;
 
+	/*
+	 * Lock the VMAs before scanning for pages to migrate, to ensure we don't
+	 * miss a concurrently inserted page.
+	 */
+	vma_iter_init(&vmi, mm, start);
+	for_each_vma_range(vmi, vma, end)
+		vma_start_write(vma);
+
 	ret = queue_pages_range(mm, start, end, nmask,
 			  flags | MPOL_MF_INVERT, &pagelist);
 
@@ -1538,6 +1550,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
 			break;
 		}
 
+		vma_start_write(vma);
 		new->home_node = home_node;
 		err = mbind_range(&vmi, vma, &prev, start, end, new);
 		mpol_put(new);


