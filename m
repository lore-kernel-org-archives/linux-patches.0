Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DFC227EA8;
	Tue, 26 Aug 2025 13:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215112; cv=none; b=gOKrEH9oaRx6+wDfB21lJ5xd3SBUTL5DK+g5DbEiOTcqFALHKEVWD4QVtuPowOcfAWCFyc8BaQDVMyShvJPRitLVVvDC2Ya3sBgLQqX3J0dng+0iWUFLYHqkg9TbuVqnxjs4629X8aTq4GtypmwquDqndrViqtZO9LY9M71PvZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215112; c=relaxed/simple;
	bh=1QYVcY9toOewMd4QO/XV9pjGi6Fs5FzlSrZwJCXWuQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GeViSE3xYhZRYKe+PRtoHy1Oi+9aVPF0LV6mGXIMN/wAa4ktBr++2wtjq5L6p+sV7Lfw2APLD+YBdxZ6vROxFrx1JFb7IxfED9qwfks/vQgbeNSDVyMj1tuG+5V1Nm+v/uNv3VRMY8wGGRDfadivjNB4Td2Ohr7OhorNsYhGcfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMNNr3Pw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMNNr3Pw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3582C4CEF1;
	Tue, 26 Aug 2025 13:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215112;
	bh=1QYVcY9toOewMd4QO/XV9pjGi6Fs5FzlSrZwJCXWuQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMNNr3PwvJkXtCN+Bbb/PKceg5+v2xrUhBmVACY7XF31uPn65b67X7Nbr6hE1xfkE
	 OhkDrHS6901DH9dA2oqFxyZ6ctB1CqHCKYi5LKO5uuKR0tQ0ppNzSmLAYUHYTLmD4x
	 na3BKNGu/wjPeS/14S9F6CI8/bep7V3Btn0QYz8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>
Subject: [PATCH 6.1 384/482] mm: drop the assumption that VM_SHARED always implies writable
Date: Tue, 26 Aug 2025 13:10:37 +0200
Message-ID: <20250826110940.315664300@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lstoakes@gmail.com>

[ Upstream commit e8e17ee90eaf650c855adb0a3e5e965fd6692ff1 ]

Patch series "permit write-sealed memfd read-only shared mappings", v4.

The man page for fcntl() describing memfd file seals states the following
about F_SEAL_WRITE:-

    Furthermore, trying to create new shared, writable memory-mappings via
    mmap(2) will also fail with EPERM.

With emphasis on 'writable'.  In turns out in fact that currently the
kernel simply disallows all new shared memory mappings for a memfd with
F_SEAL_WRITE applied, rendering this documentation inaccurate.

This matters because users are therefore unable to obtain a shared mapping
to a memfd after write sealing altogether, which limits their usefulness.
This was reported in the discussion thread [1] originating from a bug
report [2].

This is a product of both using the struct address_space->i_mmap_writable
atomic counter to determine whether writing may be permitted, and the
kernel adjusting this counter when any VM_SHARED mapping is performed and
more generally implicitly assuming VM_SHARED implies writable.

It seems sensible that we should only update this mapping if VM_MAYWRITE
is specified, i.e.  whether it is possible that this mapping could at any
point be written to.

If we do so then all we need to do to permit write seals to function as
documented is to clear VM_MAYWRITE when mapping read-only.  It turns out
this functionality already exists for F_SEAL_FUTURE_WRITE - we can
therefore simply adapt this logic to do the same for F_SEAL_WRITE.

We then hit a chicken and egg situation in mmap_region() where the check
for VM_MAYWRITE occurs before we are able to clear this flag.  To work
around this, perform this check after we invoke call_mmap(), with careful
consideration of error paths.

Thanks to Andy Lutomirski for the suggestion!

[1]:https://lore.kernel.org/all/20230324133646.16101dfa666f253c4715d965@linux-foundation.org/
[2]:https://bugzilla.kernel.org/show_bug.cgi?id=217238

This patch (of 3):

There is a general assumption that VMAs with the VM_SHARED flag set are
writable.  If the VM_MAYWRITE flag is not set, then this is simply not the
case.

Update those checks which affect the struct address_space->i_mmap_writable
field to explicitly test for this by introducing
[vma_]is_shared_maywrite() helper functions.

This remains entirely conservative, as the lack of VM_MAYWRITE guarantees
that the VMA cannot be written to.

Link: https://lkml.kernel.org/r/cover.1697116581.git.lstoakes@gmail.com
Link: https://lkml.kernel.org/r/d978aefefa83ec42d18dfa964ad180dbcde34795.1697116581.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
[isaacmanjarres: resolved merge conflicts due to
due to refactoring that happened in upstream commit
5de195060b2e ("mm: resolve faulty mmap_region() error path behaviour")]
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fs.h |    4 ++--
 include/linux/mm.h |   11 +++++++++++
 kernel/fork.c      |    2 +-
 mm/filemap.c       |    2 +-
 mm/madvise.c       |    2 +-
 mm/mmap.c          |    8 ++++----
 6 files changed, 20 insertions(+), 9 deletions(-)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -410,7 +410,7 @@ extern const struct address_space_operat
  *   It is also used to block modification of page cache contents through
  *   memory mappings.
  * @gfp_mask: Memory allocation flags to use for allocating pages.
- * @i_mmap_writable: Number of VM_SHARED mappings.
+ * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
  * @nr_thps: Number of THPs in the pagecache (non-shmem only).
  * @i_mmap: Tree of private and shared mappings.
  * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
@@ -513,7 +513,7 @@ static inline int mapping_mapped(struct
 
 /*
  * Might pages of this file have been modified in userspace?
- * Note that i_mmap_writable counts all VM_SHARED vmas: do_mmap
+ * Note that i_mmap_writable counts all VM_SHARED, VM_MAYWRITE vmas: do_mmap
  * marks vma as VM_SHARED if it is shared, and the file was opened for
  * writing i.e. vma may be mprotected writable even if now readonly.
  *
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -673,6 +673,17 @@ static inline bool vma_is_accessible(str
 	return vma->vm_flags & VM_ACCESS_FLAGS;
 }
 
+static inline bool is_shared_maywrite(vm_flags_t vm_flags)
+{
+	return (vm_flags & (VM_SHARED | VM_MAYWRITE)) ==
+		(VM_SHARED | VM_MAYWRITE);
+}
+
+static inline bool vma_is_shared_maywrite(struct vm_area_struct *vma)
+{
+	return is_shared_maywrite(vma->vm_flags);
+}
+
 static inline
 struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
 {
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -669,7 +669,7 @@ static __latent_entropy int dup_mmap(str
 
 			get_file(file);
 			i_mmap_lock_write(mapping);
-			if (tmp->vm_flags & VM_SHARED)
+			if (vma_is_shared_maywrite(tmp))
 				mapping_allow_writable(mapping);
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3554,7 +3554,7 @@ int generic_file_mmap(struct file *file,
  */
 int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE))
+	if (vma_is_shared_maywrite(vma))
 		return -EINVAL;
 	return generic_file_mmap(file, vma);
 }
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -980,7 +980,7 @@ static long madvise_remove(struct vm_are
 			return -EINVAL;
 	}
 
-	if ((vma->vm_flags & (VM_SHARED|VM_WRITE)) != (VM_SHARED|VM_WRITE))
+	if (!vma_is_shared_maywrite(vma))
 		return -EACCES;
 
 	offset = (loff_t)(start - vma->vm_start)
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -106,7 +106,7 @@ void vma_set_page_prot(struct vm_area_st
 static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 		struct file *file, struct address_space *mapping)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_is_shared_maywrite(vma))
 		mapping_unmap_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
@@ -408,7 +408,7 @@ static unsigned long count_vma_pages_ran
 static void __vma_link_file(struct vm_area_struct *vma,
 			    struct address_space *mapping)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_is_shared_maywrite(vma))
 		mapping_allow_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
@@ -2827,7 +2827,7 @@ cannot_expand:
 	vma_mas_store(vma, &mas);
 	mm->map_count++;
 	if (vma->vm_file) {
-		if (vma->vm_flags & VM_SHARED)
+		if (vma_is_shared_maywrite(vma))
 			mapping_allow_writable(vma->vm_file->f_mapping);
 
 		flush_dcache_mmap_lock(vma->vm_file->f_mapping);
@@ -2901,7 +2901,7 @@ unsigned long mmap_region(struct file *f
 		return -EINVAL;
 
 	/* Map writable and ensure this isn't a sealed memfd. */
-	if (file && (vm_flags & VM_SHARED)) {
+	if (file && is_shared_maywrite(vm_flags)) {
 		int error = mapping_map_writable(file->f_mapping);
 
 		if (error)


