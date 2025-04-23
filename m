Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09F027055F;
	Wed, 23 Apr 2025 15:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421298; cv=none; b=T7JwukcaqOu4X1IFOLPkAFQfkgRHuXDLN/4FNq/Yo1qjdT7YWr8NKYbvrhfgzkj9tpS48YMExDJB0nj91ARBf4K3QI/IZXYobY0gMjXt24nfHtEOoQoPnHUbmT+PdfCoAgoEc07cgmpMD0Ah/S3te9Cqj9nrWWBDsi2rnpQunLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421298; c=relaxed/simple;
	bh=1sgeAukXwMQGYqlWE8t7ZwKkFF3UqUu96Ar45lhhEu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCyBrylEMUiSPMQiCw7GqFuPg43AXFclKyXSq0SUkx+dDt+pdvCU+pZaBCJNILCimT1ww7id1UNgaq1GgAtNtq3kqHAGco5oKGmaANnMa6ZJFZLRL1ROtjByZr2pQyUgRRlJnZdt4HgcbZ/RJ7qfuI2Do+JYkvo+Sqc0gOJJtAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOvnmUWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOvnmUWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6278CC4CEE2;
	Wed, 23 Apr 2025 15:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421298;
	bh=1sgeAukXwMQGYqlWE8t7ZwKkFF3UqUu96Ar45lhhEu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOvnmUWJa9KMD59TDJ3ruDwcMZbYIVOWssRwyt9i3YwpkAgxdnQwQ/0ec6haV8wJz
	 q4P7jTatBMk4UdaNWebMmtrrwG8NiaEV/Jk/Ps3MWMCrewu8yV0HNUUrgDN1apkOZk
	 kDp4z/rxEK1FaAXvq4F7CV6l+YXDwXcinHHsg85Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+20ed41006cf9d842c2b5@syzkaller.appspotmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Jann Horn <jannh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 209/223] mm/vma: add give_up_on_oom option on modify/merge, use in uffd release
Date: Wed, 23 Apr 2025 16:44:41 +0200
Message-ID: <20250423142625.677479188@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

commit 41e6ddcaa0f18dda4c3fadf22533775a30d6f72f upstream.

Currently, if a VMA merge fails due to an OOM condition arising on commit
merge or a failure to duplicate anon_vma's, we report this so the caller
can handle it.

However there are cases where the caller is only ostensibly trying a
merge, and doesn't mind if it fails due to this condition.

Since we do not want to introduce an implicit assumption that we only
actually modify VMAs after OOM conditions might arise, add a 'give up on
oom' option and make an explicit contract that, should this flag be set, we
absolutely will not modify any VMAs should OOM arise and just bail out.

Since it'd be very unusual for a user to try to vma_modify() with this flag
set but be specifying a range within a VMA which ends up being split (which
can fail due to rlimit issues, not only OOM), we add a debug warning for
this condition.

The motivating reason for this is uffd release - syzkaller (and Pedro
Falcato's VERY astute analysis) found a way in which an injected fault on
allocation, triggering an OOM condition on commit merge, would result in
uffd code becoming confused and treating an error value as if it were a VMA
pointer.

To avoid this, we make use of this new VMG flag to ensure that this never
occurs, utilising the fact that, should we be clearing entire VMAs, we do
not wish an OOM event to be reported to us.

Many thanks to Pedro Falcato for his excellent analysis and Jann Horn for
his insightful and intelligent analysis of the situation, both of whom were
instrumental in this fix.

Link: https://lkml.kernel.org/r/20250321100937.46634-1-lorenzo.stoakes@oracle.com
Reported-by: syzbot+20ed41006cf9d842c2b5@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67dc67f0.050a0220.25ae54.001e.GAE@google.com/
Fixes: 47b16d0462a4 ("mm: abort vma_modify() on merge out of memory failure")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Pedro Falcato <pfalcato@suse.de>
Suggested-by: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/userfaultfd.c |   13 +++++++++++--
 mm/vma.c         |   38 ++++++++++++++++++++++++++++++++++----
 mm/vma.h         |    9 ++++++++-
 3 files changed, 53 insertions(+), 7 deletions(-)

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1873,6 +1873,14 @@ struct vm_area_struct *userfaultfd_clear
 					     unsigned long end)
 {
 	struct vm_area_struct *ret;
+	bool give_up_on_oom = false;
+
+	/*
+	 * If we are modifying only and not splitting, just give up on the merge
+	 * if OOM prevents us from merging successfully.
+	 */
+	if (start == vma->vm_start && end == vma->vm_end)
+		give_up_on_oom = true;
 
 	/* Reset ptes for the whole vma range if wr-protected */
 	if (userfaultfd_wp(vma))
@@ -1880,7 +1888,7 @@ struct vm_area_struct *userfaultfd_clear
 
 	ret = vma_modify_flags_uffd(vmi, prev, vma, start, end,
 				    vma->vm_flags & ~__VM_UFFD_FLAGS,
-				    NULL_VM_UFFD_CTX);
+				    NULL_VM_UFFD_CTX, give_up_on_oom);
 
 	/*
 	 * In the vma_merge() successful mprotect-like case 8:
@@ -1931,7 +1939,8 @@ int userfaultfd_register_range(struct us
 		new_flags = (vma->vm_flags & ~__VM_UFFD_FLAGS) | vm_flags;
 		vma = vma_modify_flags_uffd(&vmi, prev, vma, start, vma_end,
 					    new_flags,
-					    (struct vm_userfaultfd_ctx){ctx});
+					    (struct vm_userfaultfd_ctx){ctx},
+					    /* give_up_on_oom = */false);
 		if (IS_ERR(vma))
 			return PTR_ERR(vma);
 
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -846,7 +846,13 @@ static struct vm_area_struct *vma_merge_
 		if (anon_dup)
 			unlink_anon_vmas(anon_dup);
 
-		vmg->state = VMA_MERGE_ERROR_NOMEM;
+		/*
+		 * We've cleaned up any cloned anon_vma's, no VMAs have been
+		 * modified, no harm no foul if the user requests that we not
+		 * report this and just give up, leaving the VMAs unmerged.
+		 */
+		if (!vmg->give_up_on_oom)
+			vmg->state = VMA_MERGE_ERROR_NOMEM;
 		return NULL;
 	}
 
@@ -859,7 +865,15 @@ static struct vm_area_struct *vma_merge_
 abort:
 	vma_iter_set(vmg->vmi, start);
 	vma_iter_load(vmg->vmi);
-	vmg->state = VMA_MERGE_ERROR_NOMEM;
+
+	/*
+	 * This means we have failed to clone anon_vma's correctly, but no
+	 * actual changes to VMAs have occurred, so no harm no foul - if the
+	 * user doesn't want this reported and instead just wants to give up on
+	 * the merge, allow it.
+	 */
+	if (!vmg->give_up_on_oom)
+		vmg->state = VMA_MERGE_ERROR_NOMEM;
 	return NULL;
 }
 
@@ -1033,9 +1047,15 @@ int vma_expand(struct vma_merge_struct *
 	return 0;
 
 nomem:
-	vmg->state = VMA_MERGE_ERROR_NOMEM;
 	if (anon_dup)
 		unlink_anon_vmas(anon_dup);
+	/*
+	 * If the user requests that we just give upon OOM, we are safe to do so
+	 * here, as commit merge provides this contract to us. Nothing has been
+	 * changed - no harm no foul, just don't report it.
+	 */
+	if (!vmg->give_up_on_oom)
+		vmg->state = VMA_MERGE_ERROR_NOMEM;
 	return -ENOMEM;
 }
 
@@ -1428,6 +1448,13 @@ static struct vm_area_struct *vma_modify
 	if (vmg_nomem(vmg))
 		return ERR_PTR(-ENOMEM);
 
+	/*
+	 * Split can fail for reasons other than OOM, so if the user requests
+	 * this it's probably a mistake.
+	 */
+	VM_WARN_ON(vmg->give_up_on_oom &&
+		   (vma->vm_start != start || vma->vm_end != end));
+
 	/* Split any preceding portion of the VMA. */
 	if (vma->vm_start < start) {
 		int err = split_vma(vmg->vmi, vma, start, 1);
@@ -1496,12 +1523,15 @@ struct vm_area_struct
 		       struct vm_area_struct *vma,
 		       unsigned long start, unsigned long end,
 		       unsigned long new_flags,
-		       struct vm_userfaultfd_ctx new_ctx)
+		       struct vm_userfaultfd_ctx new_ctx,
+		       bool give_up_on_oom)
 {
 	VMG_VMA_STATE(vmg, vmi, prev, vma, start, end);
 
 	vmg.flags = new_flags;
 	vmg.uffd_ctx = new_ctx;
+	if (give_up_on_oom)
+		vmg.give_up_on_oom = true;
 
 	return vma_modify(&vmg);
 }
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -87,6 +87,12 @@ struct vma_merge_struct {
 	struct anon_vma_name *anon_name;
 	enum vma_merge_flags merge_flags;
 	enum vma_merge_state state;
+
+	/*
+	 * If a merge is possible, but an OOM error occurs, give up and don't
+	 * execute the merge, returning NULL.
+	 */
+	bool give_up_on_oom :1;
 };
 
 static inline bool vmg_nomem(struct vma_merge_struct *vmg)
@@ -303,7 +309,8 @@ struct vm_area_struct
 		       struct vm_area_struct *vma,
 		       unsigned long start, unsigned long end,
 		       unsigned long new_flags,
-		       struct vm_userfaultfd_ctx new_ctx);
+		       struct vm_userfaultfd_ctx new_ctx,
+		       bool give_up_on_oom);
 
 struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg);
 


