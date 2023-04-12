Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1CB2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5CCC433D2;
	Wed, 12 Apr 2023 08:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289632;
	bh=ZefDklmrsTTQ5PY63HS6HzzE5cDiHFSYRqRQ5neXBLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H25t4vybd9HXPSs5fISCNZjR9cfSb9nfd59JM5sFP/76TOkT3VxcM3g5WzNuC/Z09
	 mjYNkMu4H16GOYD1CrFu1FDvBj865rb0Ty5vGqsDgw1hIbDI8ysUC57/ZLU8mCXe0p
	 zblfJk4MxS3TVfIQPOr3BOJgNbSZrpXqcP7pwTuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	syzbot+8d95422d3537159ca390@syzkaller.appspotmail.com
Subject: [PATCH 6.2 173/173] mm: enable maple tree RCU mode by default.
Date: Wed, 12 Apr 2023 10:34:59 +0200
Message-Id: <20230412082845.173684860@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 3dd4432549415f3c65dd52d5c687629efbf4ece1 upstream.

Use the maple tree in RCU mode for VMA tracking.

The maple tree tracks the stack and is able to update the pivot
(lower/upper boundary) in-place to allow the page fault handler to write
to the tree while holding just the mmap read lock.  This is safe as the
writes to the stack have a guard VMA which ensures there will always be
a NULL in the direction of the growth and thus will only update a pivot.

It is possible, but not recommended, to have VMAs that grow up/down
without guard VMAs.  syzbot has constructed a testcase which sets up a
VMA to grow and consume the empty space.  Overwriting the entire NULL
entry causes the tree to be altered in a way that is not safe for
concurrent readers; the readers may see a node being rewritten or one
that does not match the maple state they are using.

Enabling RCU mode allows the concurrent readers to see a stable node and
will return the expected result.

Link: https://lkml.kernel.org/r/20230227173632.3292573-9-surenb@google.com
Cc: stable@vger.kernel.org
Fixes: d4af56c5c7c6 ("mm: start tracking VMAs with maple tree")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: syzbot+8d95422d3537159ca390@syzkaller.appspotmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm_types.h |    3 ++-
 kernel/fork.c            |    3 +++
 mm/mmap.c                |    3 ++-
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -810,7 +810,8 @@ struct mm_struct {
 	unsigned long cpu_bitmap[];
 };
 
-#define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN)
+#define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN | \
+			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;
 
 /* Pointer magic because the dynamic array size confuses some compilers. */
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -617,6 +617,7 @@ static __latent_entropy int dup_mmap(str
 	if (retval)
 		goto out;
 
+	mt_clear_in_rcu(mas.tree);
 	mas_for_each(&old_mas, mpnt, ULONG_MAX) {
 		struct file *file;
 
@@ -703,6 +704,8 @@ static __latent_entropy int dup_mmap(str
 	retval = arch_dup_mmap(oldmm, mm);
 loop_out:
 	mas_destroy(&mas);
+	if (!retval)
+		mt_set_in_rcu(mas.tree);
 out:
 	mmap_write_unlock(mm);
 	flush_tlb_mm(oldmm);
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2308,7 +2308,7 @@ do_mas_align_munmap(struct ma_state *mas
 	int count = 0;
 	int error = -ENOMEM;
 	MA_STATE(mas_detach, &mt_detach, 0, 0);
-	mt_init_flags(&mt_detach, MT_FLAGS_LOCK_EXTERN);
+	mt_init_flags(&mt_detach, mas->tree->ma_flags & MT_FLAGS_LOCK_MASK);
 	mt_set_external_lock(&mt_detach, &mm->mmap_lock);
 
 	if (mas_preallocate(mas, vma, GFP_KERNEL))
@@ -3095,6 +3095,7 @@ void exit_mmap(struct mm_struct *mm)
 	 */
 	set_bit(MMF_OOM_SKIP, &mm->flags);
 	mmap_write_lock(mm);
+	mt_clear_in_rcu(&mm->mm_mt);
 	free_pgtables(&tlb, &mm->mm_mt, vma, FIRST_USER_ADDRESS,
 		      USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb);


