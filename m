Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B093C02
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 10:00:52 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7AF2D34432;
	Fri, 24 Feb 2023 10:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1677232842; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T637DVEgnPwS8p7L5KrNfCTDsHvOXi2P3RnjOxBPfWY=;
	b=zXBjdlaHJo4OPani0e7zgMaltNOkXOKjI1Vn7WQY4kdLxSIAH0M91voUErlN7tAhfYP5r+
	AfesZ2Nn3ui5lM1I2fCq0a3XrC5HdGtE/UwODQutPhOXIu67II16+lo1FQxsinIDP8Yt/v
	aDg9Sm9wuE/lGQvXeupSfWGCQ8IbVYE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1677232842;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T637DVEgnPwS8p7L5KrNfCTDsHvOXi2P3RnjOxBPfWY=;
	b=ve/+OwGM7xKTsy5jb3bE/R482UYK814GXEMl5iQTRZyrSn+PiltVpWmaWLfmSyY0/2hjMQ
	ioRmMh8NT9tj3PAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 58C0F13246;
	Fri, 24 Feb 2023 10:00:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id iJuVFMqK+GPeTgAAMHmgww
	(envelope-from <vbabka@suse.cz>); Fri, 24 Feb 2023 10:00:42 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: linux-mm@kvack.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	maple-tree@lists.infradead.org,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [RFC 10/11] mm/mmap: start distinguishing if vma can be removed in mergeability test
Date: Fri, 24 Feb 2023 11:00:21 +0100
Message-Id: <20230224100022.11268-11-vbabka@suse.cz>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230224100022.11268-1-vbabka@suse.cz>
References: <20230224100022.11268-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since pre-git times, is_mergeable_vma() returns false for a vma with
vm_ops->close, so that no owner assumptions are violated in case the vma
is removed as part of the merge.

This check is currently very conservative and can prevent merging even
situations where vma can't be removed, such as simple expansion of
previous vma, as evidenced by commit d014cd7c1c35 ("mm, mremap: fix
mremap() expanding for vma's with vm_ops->close()")

In order to allow more merging when appropriate and simplify the code
that was made more complex by commit d014cd7c1c35, start distinguishing
cases where the vma can be really removed, and allow merging with
vm_ops->close otherwise.

As a first step, add a may_remove_vma parameter to is_mergeable_vma().
can_vma_merge_before() sets it to true, because when called from
vma_merge(), a removal of the vma is possible.

In can_vma_merge_after(), pass the parameter as false, because no
removal can occur in each of its callers:
- vma_merge() calls it on the 'prev' vma, which is never removed
- mmap_region() and do_brk_flags() call it to determine if it can expand
  a vma, which is not removed

As a result, vma's with vm_ops->close may now merge with compatible
ranges in more situations than previously. We can also revert commit
d014cd7c1c35 as the next step to simplify mremap code again.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/mmap.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 6e439806d4ac..21343da452e8 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -742,12 +742,14 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 /*
  * If the vma has a ->close operation then the driver probably needs to release
- * per-vma resources, so we don't attempt to merge those.
+ * per-vma resources, so we don't attempt to merge those in case the caller
+ * indicates the current vma may be removed as part of the merge.
  */
 static inline bool is_mergeable_vma(struct vm_area_struct *vma,
 				    struct file *file, unsigned long vm_flags,
 				    struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
-				    struct anon_vma_name *anon_name)
+				    struct anon_vma_name *anon_name,
+				    bool may_remove_vma)
 {
 	/*
 	 * VM_SOFTDIRTY should not prevent from VMA merging, if we
@@ -761,7 +763,7 @@ static inline bool is_mergeable_vma(struct vm_area_struct *vma,
 		return false;
 	if (vma->vm_file != file)
 		return false;
-	if (vma->vm_ops && vma->vm_ops->close)
+	if (may_remove_vma && vma->vm_ops && vma->vm_ops->close)
 		return false;
 	if (!is_mergeable_vm_userfaultfd_ctx(vma, vm_userfaultfd_ctx))
 		return false;
@@ -794,6 +796,8 @@ static inline bool is_mergeable_anon_vma(struct anon_vma *anon_vma1,
  * We don't check here for the merged mmap wrapping around the end of pagecache
  * indices (16TB on ia32) because do_mmap() does not permit mmap's which
  * wrap, nor mmaps which cover the final page at index -1UL.
+ *
+ * We assume the vma may be removed as part of the merge.
  */
 static bool
 can_vma_merge_before(struct vm_area_struct *vma, unsigned long vm_flags,
@@ -802,7 +806,7 @@ can_vma_merge_before(struct vm_area_struct *vma, unsigned long vm_flags,
 		     struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
 		     struct anon_vma_name *anon_name)
 {
-	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name) &&
+	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name, true) &&
 	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
 		if (vma->vm_pgoff == vm_pgoff)
 			return true;
@@ -816,6 +820,8 @@ can_vma_merge_before(struct vm_area_struct *vma, unsigned long vm_flags,
  *
  * We cannot merge two vmas if they have differently assigned (non-NULL)
  * anon_vmas, nor if same anon_vma is assigned but offsets incompatible.
+ *
+ * We assume that vma is not removed as part of the merge.
  */
 static bool
 can_vma_merge_after(struct vm_area_struct *vma, unsigned long vm_flags,
@@ -824,7 +830,7 @@ can_vma_merge_after(struct vm_area_struct *vma, unsigned long vm_flags,
 		    struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
 		    struct anon_vma_name *anon_name)
 {
-	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name) &&
+	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name, false) &&
 	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
 		pgoff_t vm_pglen;
 		vm_pglen = vma_pages(vma);
-- 
2.39.2

