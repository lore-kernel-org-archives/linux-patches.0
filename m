Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A187253925;
	Mon, 23 Jun 2025 13:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684978; cv=none; b=flUayW0QHw1bsByqH3w+r4xe+oGyq6OR+58R1Iigf9YWCsKJc4x3KY72V/nSslNrK1KdOhlzWXI/LqaycEv8iig8uoU2Xv9TwyuLJMKzvY28hrxVbKIFsAV2fn33EnQpo+rVBF0HHKOW+2lIAb4Qb29G75wfhfyfZct2CZST2EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684978; c=relaxed/simple;
	bh=WGZKBUDw/glt/v6yzZSAIqnOVzBcFVOw482adN6r0K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuopXMDAmfzVgq5IEAHCMIyi6Q8/8d/+CkVwVIaICJ4T6ibnGfIJI9zZhx3i4XqqlbGQqG9qEHIIxHcUU5AzMEq6RXu9BVg0yioM52tLNTxJMidLaan61Ezug0MuYA9qOnBC4Dw1E8jXAiXDL9uOCaGSS1aQs7DStQ2O87YvzI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUyuaPqn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUyuaPqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CA4C4CEF0;
	Mon, 23 Jun 2025 13:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684978;
	bh=WGZKBUDw/glt/v6yzZSAIqnOVzBcFVOw482adN6r0K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUyuaPqnI2sRvJvYbifWPqugsa+faREaxNm8hKKzjvTJ9+WNIlCs6IPuZ6TJiPSbW
	 j1nmrVBfQ0OJ2oGgrDFyh8uidmD/VXCh87JxUr/OlDk1zJ84xCX61Gy3vvWegCuBts
	 0wmmuGA5tbimAXTUDO5cKUkvPOecd03RmAPF8y8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Jann Horn <jannh@google.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 197/592] mm: fix uprobe pte be overwritten when expanding vma
Date: Mon, 23 Jun 2025 15:02:35 +0200
Message-ID: <20250623130704.975719595@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

commit 2b12d06c37fd3a394376f42f026a7478d826ed63 upstream.

Patch series "Fix uprobe pte be overwritten when expanding vma".


This patch (of 4):

We encountered a BUG alert triggered by Syzkaller as follows:
   BUG: Bad rss-counter state mm:00000000b4a60fca type:MM_ANONPAGES val:1

And we can reproduce it with the following steps:
1. register uprobe on file at zero offset
2. mmap the file at zero offset:
   addr1 = mmap(NULL, 2 * 4096, PROT_NONE, MAP_PRIVATE, fd, 0);
3. mremap part of vma1 to new vma2:
   addr2 = mremap(addr1, 4096, 2 * 4096, MREMAP_MAYMOVE);
4. mremap back to orig addr1:
   mremap(addr2, 4096, 4096, MREMAP_MAYMOVE | MREMAP_FIXED, addr1);

In step 3, the vma1 range [addr1, addr1 + 4096] will be remap to new vma2
with range [addr2, addr2 + 8192], and remap uprobe anon page from the vma1
to vma2, then unmap the vma1 range [addr1, addr1 + 4096].

In step 4, the vma2 range [addr2, addr2 + 4096] will be remap back to the
addr range [addr1, addr1 + 4096].  Since the addr range [addr1 + 4096,
addr1 + 8192] still maps the file, it will take vma_merge_new_range to
expand the range, and then do uprobe_mmap in vma_complete.  Since the
merged vma pgoff is also zero offset, it will install uprobe anon page to
the merged vma.  However, the upcomming move_page_tables step, which use
set_pte_at to remap the vma2 uprobe pte to the merged vma, will overwrite
the newly uprobe pte in the merged vma, and lead that pte to be orphan.

Since the uprobe pte will be remapped to the merged vma, we can remove the
unnecessary uprobe_mmap upon merged vma.

This problem was first found in linux-6.6.y and also exists in the
community syzkaller:
https://lore.kernel.org/all/000000000000ada39605a5e71711@google.com/T/

Link: https://lkml.kernel.org/r/20250529155650.4017699-1-pulehui@huaweicloud.com
Link: https://lkml.kernel.org/r/20250529155650.4017699-2-pulehui@huaweicloud.com
Fixes: 2b1444983508 ("uprobes, mm, x86: Add the ability to install and remove uprobes breakpoints")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vma.c |   20 +++++++++++++++++---
 mm/vma.h |    7 +++++++
 2 files changed, 24 insertions(+), 3 deletions(-)

--- a/mm/vma.c
+++ b/mm/vma.c
@@ -144,6 +144,9 @@ static void init_multi_vma_prep(struct v
 	vp->file = vma->vm_file;
 	if (vp->file)
 		vp->mapping = vma->vm_file->f_mapping;
+
+	if (vmg && vmg->skip_vma_uprobe)
+		vp->skip_vma_uprobe = true;
 }
 
 /*
@@ -333,10 +336,13 @@ static void vma_complete(struct vma_prep
 
 	if (vp->file) {
 		i_mmap_unlock_write(vp->mapping);
-		uprobe_mmap(vp->vma);
 
-		if (vp->adj_next)
-			uprobe_mmap(vp->adj_next);
+		if (!vp->skip_vma_uprobe) {
+			uprobe_mmap(vp->vma);
+
+			if (vp->adj_next)
+				uprobe_mmap(vp->adj_next);
+		}
 	}
 
 	if (vp->remove) {
@@ -1783,6 +1789,14 @@ struct vm_area_struct *copy_vma(struct v
 		faulted_in_anon_vma = false;
 	}
 
+	/*
+	 * If the VMA we are copying might contain a uprobe PTE, ensure
+	 * that we do not establish one upon merge. Otherwise, when mremap()
+	 * moves page tables, it will orphan the newly created PTE.
+	 */
+	if (vma->vm_file)
+		vmg.skip_vma_uprobe = true;
+
 	new_vma = find_vma_prev(mm, addr, &vmg.prev);
 	if (new_vma && new_vma->vm_start < addr + len)
 		return NULL;	/* should never get here */
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -19,6 +19,8 @@ struct vma_prepare {
 	struct vm_area_struct *insert;
 	struct vm_area_struct *remove;
 	struct vm_area_struct *remove2;
+
+	bool skip_vma_uprobe :1;
 };
 
 struct unlink_vma_file_batch {
@@ -120,6 +122,11 @@ struct vma_merge_struct {
 	 */
 	bool give_up_on_oom :1;
 
+	/*
+	 * If set, skip uprobe_mmap upon merged vma.
+	 */
+	bool skip_vma_uprobe :1;
+
 	/* Internal flags set during merge process: */
 
 	/*


