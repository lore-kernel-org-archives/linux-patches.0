Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A09370ACE;
	Sat, 17 Oct 2026 16:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253334; cv=none; b=Q0Aq022onzxk/EoxIQwEs1UfmCKhfk5Z43sOeiY+qAeQv/eN+FEh5jtIWglVgvszeW11Xfsed4mEcW6XqP6N5RocK06/0cKUq4BsUSLWCEkxeffn8I164DnX4/dvqnDK9kcbI4cQAwDKvu1gler1SuMnn68CSLmWbNwh/RO6c2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253334; c=relaxed/simple;
	bh=CMciuwpajdcs34kEC4bZktNrXCh7vUrs94euNEXhrIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAvlK31/rLw2K5BertXD25q/VkQlzi48E9NggRgfkK8xCaerBGiw+IFaToeDE6L7CWnDD17jllq8aFMZYpk9JrjDbissjaHxo2q3HzBUIGUldNm9kC2vjUMcm61SvsNM6bhxdJWXU6pyvAbKZGel9D4ZSfLgzPI+bdHDzJ6miPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+4fBJPz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+4fBJPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01421F000C5;
	Sat, 17 Oct 2026 16:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253333;
	bh=vhzx6Qv8VczGfEhdO1jxco+Sd0bI0s41kBgwNTywe84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M+4fBJPzbgUpEuNJ5nVeUhZ7318gPTNB08/3+zoh4fnHWJgXgPa1aDqMXbpExHYQz
	 25DQxmEjqEC6aFz2nr3E3rtHb/IUyPwvzieotNxjUwGAQf1DZW6VdbIvnR/q2KggGG
	 xMUD/cUJYFQuDSL0x4+5CBTvUJZgcB5fUVHRd/Q4=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/869] mm: fix uprobe pte be overwritten when expanding vma
Date: Sat, 17 Oct 2026 17:48:45 +0200
Message-ID: <20261017160039.184649998@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 2b12d06c37fd3a394376f42f026a7478d826ed63 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vma.c | 18 +++++++++++++++---
 mm/vma.h |  7 +++++++
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index b58588cac3aab..66b0472b7d8a6 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -236,10 +236,13 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 
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
@@ -592,6 +595,7 @@ static int commit_merge(struct vma_merge_struct *vmg,
 	struct vma_prepare vp;
 
 	init_multi_vma_prep(&vp, vmg->vma, adjust, remove, remove2);
+	vp.skip_vma_uprobe = vmg->skip_vma_uprobe;
 
 	VM_WARN_ON(vp.anon_vma && adjust && adjust->anon_vma &&
 		   vp.anon_vma != adjust->anon_vma);
@@ -1660,6 +1664,14 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
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
diff --git a/mm/vma.h b/mm/vma.h
index 7c2932ec62356..f7efbe41c44c5 100644
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
@@ -93,6 +95,11 @@ struct vma_merge_struct {
 	 * execute the merge, returning NULL.
 	 */
 	bool give_up_on_oom :1;
+
+	/*
+	 * If set, skip uprobe_mmap upon merged vma.
+	 */
+	bool skip_vma_uprobe :1;
 };
 
 static inline bool vmg_nomem(struct vma_merge_struct *vmg)
-- 
2.53.0



