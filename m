Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F25E574
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AA7C433D2;
	Thu,  1 Jun 2023 13:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625918;
	bh=+8peShet22ajnHVDeInGp6WiH7rvvC8Bb74XV2rQ6WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dlEHdZALqVZAoJd1CLRN3jhOhOpPG4PGPlJSInymSCPFTZ4xXv2YNvEH6NklU0tlZ
	 oZsk25WRWvvF087IHZFb14m/Obes6WZVyQOkBdWSymUbFcsE28PlE05hIVzmKyaeIs
	 bbEvbJDr5tFHhOmUnT513A02LzS99TP0Ux2GcqbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Howlett <liam.howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.15 38/42] Revert "android: binder: stop saving a pointer to the VMA"
Date: Thu,  1 Jun 2023 14:21:25 +0100
Message-Id: <20230601131938.415893856@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131936.699199833@linuxfoundation.org>
References: <20230601131936.699199833@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Carlos Llamas <cmllamas@google.com>

commit c0fd2101781ef761b636769b2f445351f71c3626 upstream.

This reverts commit a43cfc87caaf46710c8027a8c23b8a55f1078f19.

This patch fixed an issue reported by syzkaller in [1]. However, this
turned out to be only a band-aid in binder. The root cause, as bisected
by syzkaller, was fixed by commit 5789151e48ac ("mm/mmap: undo ->mmap()
when mas_preallocate() fails"). We no longer need the patch for binder.

Reverting such patch allows us to have a lockless access to alloc->vma
in specific cases where the mmap_lock is not required. This approach
avoids the contention that caused a performance regression.

[1] https://lore.kernel.org/all/0000000000004a0dbe05e1d749e0@google.com

[cmllamas: resolved conflicts with rework of alloc->mm and removal of
 binder_alloc_set_vma() also fixed comment section]

Fixes: a43cfc87caaf ("android: binder: stop saving a pointer to the VMA")
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20230502201220.1756319-2-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[cmllamas: fixed merge conflict in binder_alloc_set_vma()]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c          |   27 +++++++++++++--------------
 drivers/android/binder_alloc.h          |    2 +-
 drivers/android/binder_alloc_selftest.c |    2 +-
 3 files changed, 15 insertions(+), 16 deletions(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -213,7 +213,7 @@ static int binder_update_page_range(stru
 
 	if (mm) {
 		mmap_read_lock(mm);
-		vma = vma_lookup(mm, alloc->vma_addr);
+		vma = alloc->vma;
 	}
 
 	if (!vma && need_mm) {
@@ -313,14 +313,12 @@ err_no_vma:
 static inline void binder_alloc_set_vma(struct binder_alloc *alloc,
 		struct vm_area_struct *vma)
 {
-	unsigned long vm_start = 0;
-
-	if (vma) {
-		vm_start = vma->vm_start;
-		mmap_assert_write_locked(alloc->vma_vm_mm);
-	}
-
-	alloc->vma_addr = vm_start;
+	/*
+	 * If we see alloc->vma is not NULL, buffer data structures set up
+	 * completely. Look at smp_rmb side binder_alloc_get_vma.
+	 */
+	smp_wmb();
+	alloc->vma = vma;
 }
 
 static inline struct vm_area_struct *binder_alloc_get_vma(
@@ -328,9 +326,11 @@ static inline struct vm_area_struct *bin
 {
 	struct vm_area_struct *vma = NULL;
 
-	if (alloc->vma_addr)
-		vma = vma_lookup(alloc->vma_vm_mm, alloc->vma_addr);
-
+	if (alloc->vma) {
+		/* Look at description in binder_alloc_set_vma */
+		smp_rmb();
+		vma = alloc->vma;
+	}
 	return vma;
 }
 
@@ -819,8 +819,7 @@ void binder_alloc_deferred_release(struc
 
 	buffers = 0;
 	mutex_lock(&alloc->mutex);
-	BUG_ON(alloc->vma_addr &&
-	       vma_lookup(alloc->vma_vm_mm, alloc->vma_addr));
+	BUG_ON(alloc->vma);
 
 	while ((n = rb_first(&alloc->allocated_buffers))) {
 		buffer = rb_entry(n, struct binder_buffer, rb_node);
--- a/drivers/android/binder_alloc.h
+++ b/drivers/android/binder_alloc.h
@@ -100,7 +100,7 @@ struct binder_lru_page {
  */
 struct binder_alloc {
 	struct mutex mutex;
-	unsigned long vma_addr;
+	struct vm_area_struct *vma;
 	struct mm_struct *vma_vm_mm;
 	void __user *buffer;
 	struct list_head buffers;
--- a/drivers/android/binder_alloc_selftest.c
+++ b/drivers/android/binder_alloc_selftest.c
@@ -287,7 +287,7 @@ void binder_selftest_alloc(struct binder
 	if (!binder_selftest_run)
 		return;
 	mutex_lock(&binder_selftest_lock);
-	if (!binder_selftest_run || !alloc->vma_addr)
+	if (!binder_selftest_run || !alloc->vma)
 		goto done;
 	pr_info("STARTED\n");
 	binder_selftest_alloc_offset(alloc, end_offset, 0);


