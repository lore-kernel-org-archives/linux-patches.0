Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321E43CF048;
	Fri, 15 May 2026 16:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862818; cv=none; b=KkT1g6J5j0Ad+4RP7f52ZMgnqNsq3smmrpG7m7fAxv66NC/o5mVoNj5uSB6Hi9ZZs75d4k5WUafoW3YgVSIv8wIWoHkniYgDm3lBi/Dua1uA4rOs8JnXqPq3fK++rGyni9fHENlKrzLhQRETcS0tKofqoZtlKTa8IXqF1FbBdok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862818; c=relaxed/simple;
	bh=XgJAx6+301VOC1hQYUY+M83DIEJNMkX88BweqH3cQ5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeQIynoV/j/LlR3vmLvOT7Ixk/3P4kNur/RQ9rVk3WIGM1P5HiqQ+jvkheHl8xTk2D9yNzCbuZv4R66uxRiZEfJU/42hLHPAYJXtEzMoQ6psNM+mBDiu5HoXIBevwN/Q7xBuXPhDyYRlmEy/5APxn4E3iy1JChCUR7ryxdXtaA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alvTPqaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alvTPqaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D47C2BCB0;
	Fri, 15 May 2026 16:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862818;
	bh=XgJAx6+301VOC1hQYUY+M83DIEJNMkX88BweqH3cQ5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=alvTPqaHLzDn5Eje2GKJF0HbI+2MyaNnbXEUghk50J33wQ8UwjeT+2zGzWrPPcJZa
	 amiON+xnFZqNUfWS04anTyYN9sMnLWcoOY59o68ZzS0wWU7gBjjMVvTAx1Y9/tg2yF
	 OAH3dF0fAeEneUbY4ld4c8qoZ2/6qS9P1ctFIGxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <ljs@kernel.org>,
	syzbot+db390288d141a1dccf96@syzkaller.appspotmail.com,
	David Hildenbrand <david@kernel.org>,
	Jann Horn <jannh@google.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 194/201] mm/vma: do not try to unmap a VMA if mmap_prepare() invoked from mmap()
Date: Fri, 15 May 2026 17:50:12 +0200
Message-ID: <20260515154702.783593328@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <ljs@kernel.org>

[ Upstream commit 619eab23e1ce7c97e54bfc5a417306d94b3f6f13 ]

The mmap_prepare hook functionality includes the ability to invoke
mmap_prepare() from the mmap() hook of existing 'stacked' drivers, that is
ones which are capable of calling the mmap hooks of other drivers/file
systems (e.g.  overlayfs, shm).

As part of the mmap_prepare action functionality, we deal with errors by
unmapping the VMA should one arise.  This works in the usual mmap_prepare
case, as we invoke this action at the last moment, when the VMA is
established in the maple tree.

However, the mmap() hook passes a not-fully-established VMA pointer to the
caller (which is the motivation behind the mmap_prepare() work), which is
detached.

So attempting to unmap a VMA in this state will be problematic, with the
most obvious symptom being a warning in vma_mark_detached(), because the
VMA is already detached.

It's also unncessary - the mmap() handler will clean up the VMA on error.

So to fix this issue, this patch propagates whether or not an mmap action
is being completed via the compatibility layer or directly.

If the former, then we do not attempt VMA cleanup, if the latter, then we
do.

This patch also updates the userland VMA tests to reflect the change.

Link: https://lore.kernel.org/20260421102150.189982-1-ljs@kernel.org
Fixes: ac0a3fc9c07d ("mm: add ability to take further action in vm_area_desc")
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reported-by: syzbot+db390288d141a1dccf96@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69e69734.050a0220.24bfd3.0027.GAE@google.com/
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h                |    2 -
 mm/util.c                         |   51 +++++++++++++++++++++-----------------
 mm/vma.c                          |    3 --
 tools/testing/vma/include/dup.h   |   41 ++++++++++++++----------------
 tools/testing/vma/include/stubs.h |    3 +-
 5 files changed, 53 insertions(+), 47 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4080,7 +4080,7 @@ static inline void mmap_action_ioremap_f
 
 int mmap_action_prepare(struct vm_area_desc *desc);
 int mmap_action_complete(struct vm_area_struct *vma,
-			 struct mmap_action *action);
+			 struct mmap_action *action, bool is_compat);
 
 /* Look up the first VMA which exactly match the interval vm_start ... vm_end */
 static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
--- a/mm/util.c
+++ b/mm/util.c
@@ -1186,7 +1186,8 @@ int compat_vma_mmap(struct file *file, s
 		return err;
 
 	set_vma_from_desc(vma, &desc);
-	err = mmap_action_complete(vma, &desc.action);
+	err = mmap_action_complete(vma, &desc.action,
+				   /*is_compat=*/true);
 	if (err) {
 		const size_t len = vma_pages(vma) << PAGE_SHIFT;
 
@@ -1277,28 +1278,31 @@ again:
 }
 
 static int mmap_action_finish(struct vm_area_struct *vma,
-			      struct mmap_action *action, int err)
+			      struct mmap_action *action, int err,
+			      bool is_compat)
 {
+	if (!err && action->success_hook)
+		err = action->success_hook(vma);
+
+	/*
+	 * If this is invoked from the compatibility layer, post-mmap() hook
+	 * logic will handle cleanup for us.
+	 */
+	if (!err || is_compat)
+		return err;
+
 	/*
 	 * If an error occurs, unmap the VMA altogether and return an error. We
 	 * only clear the newly allocated VMA, since this function is only
 	 * invoked if we do NOT merge, so we only clean up the VMA we created.
 	 */
-	if (err) {
-		if (action->error_hook) {
-			/* We may want to filter the error. */
-			err = action->error_hook(err);
-
-			/* The caller should not clear the error. */
-			VM_WARN_ON_ONCE(!err);
-		}
-		return err;
+	if (action->error_hook) {
+		/* We may want to filter the error. */
+		err = action->error_hook(err);
+		/* The caller should not clear the error. */
+		VM_WARN_ON_ONCE(!err);
 	}
-
-	if (action->success_hook)
-		return action->success_hook(vma);
-
-	return 0;
+	return err;
 }
 
 #ifdef CONFIG_MMU
@@ -1329,14 +1333,16 @@ EXPORT_SYMBOL(mmap_action_prepare);
  * mmap_action_complete - Execute VMA descriptor action.
  * @vma: The VMA to perform the action upon.
  * @action: The action to perform.
+ * @is_compat: Is this being invoked from the compatibility layer?
  *
  * Similar to mmap_action_prepare().
  *
- * Return: 0 on success, or error, at which point the VMA will be unmapped.
+ * Return: 0 on success, or error, at which point the VMA will be unmapped if
+ * !@is_compat.
  */
 int mmap_action_complete(struct vm_area_struct *vma,
-			 struct mmap_action *action)
-
+			 struct mmap_action *action,
+			 bool is_compat)
 {
 	int err = 0;
 
@@ -1353,7 +1359,7 @@ int mmap_action_complete(struct vm_area_
 		break;
 	}
 
-	return mmap_action_finish(vma, action, err);
+	return mmap_action_finish(vma, action, err, is_compat);
 }
 EXPORT_SYMBOL(mmap_action_complete);
 #else
@@ -1373,7 +1379,8 @@ int mmap_action_prepare(struct vm_area_d
 EXPORT_SYMBOL(mmap_action_prepare);
 
 int mmap_action_complete(struct vm_area_struct *vma,
-			 struct mmap_action *action)
+			 struct mmap_action *action,
+			 bool is_compat)
 {
 	int err = 0;
 
@@ -1388,7 +1395,7 @@ int mmap_action_complete(struct vm_area_
 		break;
 	}
 
-	return mmap_action_finish(vma, action, err);
+	return mmap_action_finish(vma, action, err, is_compat);
 }
 EXPORT_SYMBOL(mmap_action_complete);
 #endif
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2708,7 +2708,7 @@ static int call_action_complete(struct m
 {
 	int err;
 
-	err = mmap_action_complete(vma, action);
+	err = mmap_action_complete(vma, action, /*is_compat=*/false);
 
 	/* If we held the file rmap we need to release it. */
 	if (map->hold_file_rmap_lock) {
@@ -2778,7 +2778,6 @@ static unsigned long __mmap_region(struc
 
 	if (have_mmap_prepare && allocated_new) {
 		error = call_action_complete(&map, &desc.action, vma);
-
 		if (error)
 			return error;
 	}
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1071,8 +1071,17 @@ static inline void vma_set_anonymous(str
 static inline void set_vma_from_desc(struct vm_area_struct *vma,
 		struct vm_area_desc *desc);
 
-static inline int __compat_vma_mmap(const struct file_operations *f_op,
-		struct file *file, struct vm_area_struct *vma)
+static inline unsigned long vma_pages(struct vm_area_struct *vma)
+{
+	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+}
+
+static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
+{
+	return file->f_op->mmap_prepare(desc);
+}
+
+static inline int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct vm_area_desc desc = {
 		.mm = vma->vm_mm,
@@ -1082,14 +1091,14 @@ static inline int __compat_vma_mmap(cons
 
 		.pgoff = vma->vm_pgoff,
 		.vm_file = vma->vm_file,
-		.vm_flags = vma->vm_flags,
+		.vma_flags = vma->flags,
 		.page_prot = vma->vm_page_prot,
 
 		.action.type = MMAP_NOTHING, /* Default */
 	};
 	int err;
 
-	err = f_op->mmap_prepare(&desc);
+	err = vfs_mmap_prepare(file, &desc);
 	if (err)
 		return err;
 
@@ -1098,27 +1107,22 @@ static inline int __compat_vma_mmap(cons
 		return err;
 
 	set_vma_from_desc(vma, &desc);
-	return mmap_action_complete(vma, &desc.action);
-}
+	err = mmap_action_complete(vma, &desc.action,
+				   /*is_compat=*/true);
+	if (err) {
+		const size_t len = vma_pages(vma) << PAGE_SHIFT;
 
-static inline int compat_vma_mmap(struct file *file,
-		struct vm_area_struct *vma)
-{
-	return __compat_vma_mmap(file->f_op, file, vma);
+		do_munmap(current->mm, vma->vm_start, len, NULL);
+	}
+	return err;
 }
 
-
 static inline void vma_iter_init(struct vma_iterator *vmi,
 		struct mm_struct *mm, unsigned long addr)
 {
 	mas_init(&vmi->mas, &mm->mm_mt, addr);
 }
 
-static inline unsigned long vma_pages(struct vm_area_struct *vma)
-{
-	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
-}
-
 static inline void mmap_assert_locked(struct mm_struct *);
 static inline struct vm_area_struct *find_vma_intersection(struct mm_struct *mm,
 						unsigned long start_addr,
@@ -1309,11 +1313,6 @@ static inline int vfs_mmap(struct file *
 	return file->f_op->mmap(file, vma);
 }
 
-static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
-{
-	return file->f_op->mmap_prepare(desc);
-}
-
 static inline void vma_set_file(struct vm_area_struct *vma, struct file *file)
 {
 	/* Changing an anonymous vma with this is illegal */
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -87,7 +87,8 @@ static inline int mmap_action_prepare(st
 }
 
 static inline int mmap_action_complete(struct vm_area_struct *vma,
-				       struct mmap_action *action)
+				       struct mmap_action *action,
+				       bool is_compat)
 {
 	return 0;
 }


