Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B163BB9EF;
	Wed, 21 Jan 2026 18:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020342; cv=none; b=U8LeITB5VBlB0UF0rwN2HWLSBwkrV2892uMV32N2gJufyx32z/ScMLGhu51Wuh2j8V2h5km7hxOOhE2gPpfodRYjhiqFZdfFx+Kg7+qcTlOD8Mc+GpLPf2bsVxWjZOgnlMHJ/gvW/5GLIFx6NDhUvFCwDkjsNjmtOsIA5rA2t2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020342; c=relaxed/simple;
	bh=HopRZptHdoRi4N6/SlDdWDWR1ucS+uy/OhYu62lndSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBk3e3LUzMcV884S6oYbG9SUAGjiNiindP4TN9xUh/j8O4R6595AGFpg4q2VI3hyE50t2FGg7tCivvupSWaM1G6my4LpJIWwoUmI1B+PB9pv1CymdfjXSSqAEGS/1Y2tGZv9POnF1lTqbIJdg6us6o+Ool5Mv13H7m/Ml4ukL0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUOINqzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUOINqzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAF0C4CEF1;
	Wed, 21 Jan 2026 18:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020342;
	bh=HopRZptHdoRi4N6/SlDdWDWR1ucS+uy/OhYu62lndSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUOINqzt9bSzYMmFfI8mH2qVSTxmlOKM8IhjEB3WS0uMFuAfkn38sfFPxm8c6FwEL
	 oco23KGI9nucbfHdJSAKLpQTGrILu5mz3k+qx2gmvaXo39O4DJ4C4kVnLSpIJ78g5/
	 ShF1pwbFfVvLhtHyoZdlujv3CvwuC3CIYmsEPmjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Jann Horn <jannh@google.com>,
	Jeongjun Park <aha310510@gmail.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 102/198] tools/testing/selftests: add forked (un)/faulted VMA merge tests
Date: Wed, 21 Jan 2026 19:15:30 +0100
Message-ID: <20260121181422.225055729@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

commit fb39444732f02c32a8312c168d97e33d872c14d3 upstream.

Now we correctly handle forked faulted/unfaulted merge on mremap(),
exhaustively assert that we handle this correctly.

Do this in the less duplicative way by adding a new merge_with_fork
fixture and forked/unforked variants, and abstract the forking logic as
necessary to avoid code duplication with this also.

Link: https://lkml.kernel.org/r/1daf76d89fdb9d96f38a6a0152d8f3c2e9e30ac7.1767638272.git.lorenzo.stoakes@oracle.com
Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jeongjun Park <aha310510@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/merge.c | 180 ++++++++++++++++++++++-------
 1 file changed, 139 insertions(+), 41 deletions(-)

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index 22be149f7109..10b686102b79 100644
--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -22,12 +22,37 @@ FIXTURE(merge)
 	struct procmap_fd procmap;
 };
 
+static char *map_carveout(unsigned int page_size)
+{
+	return mmap(NULL, 30 * page_size, PROT_NONE,
+		    MAP_ANON | MAP_PRIVATE, -1, 0);
+}
+
+static pid_t do_fork(struct procmap_fd *procmap)
+{
+	pid_t pid = fork();
+
+	if (pid == -1)
+		return -1;
+	if (pid != 0) {
+		wait(NULL);
+		return pid;
+	}
+
+	/* Reopen for child. */
+	if (close_procmap(procmap))
+		return -1;
+	if (open_self_procmap(procmap))
+		return -1;
+
+	return 0;
+}
+
 FIXTURE_SETUP(merge)
 {
 	self->page_size = psize();
 	/* Carve out PROT_NONE region to map over. */
-	self->carveout = mmap(NULL, 30 * self->page_size, PROT_NONE,
-			      MAP_ANON | MAP_PRIVATE, -1, 0);
+	self->carveout = map_carveout(self->page_size);
 	ASSERT_NE(self->carveout, MAP_FAILED);
 	/* Setup PROCMAP_QUERY interface. */
 	ASSERT_EQ(open_self_procmap(&self->procmap), 0);
@@ -36,7 +61,8 @@ FIXTURE_SETUP(merge)
 FIXTURE_TEARDOWN(merge)
 {
 	ASSERT_EQ(munmap(self->carveout, 30 * self->page_size), 0);
-	ASSERT_EQ(close_procmap(&self->procmap), 0);
+	/* May fail for parent of forked process. */
+	close_procmap(&self->procmap);
 	/*
 	 * Clear unconditionally, as some tests set this. It is no issue if this
 	 * fails (KSM may be disabled for instance).
@@ -44,6 +70,44 @@ FIXTURE_TEARDOWN(merge)
 	prctl(PR_SET_MEMORY_MERGE, 0, 0, 0, 0);
 }
 
+FIXTURE(merge_with_fork)
+{
+	unsigned int page_size;
+	char *carveout;
+	struct procmap_fd procmap;
+};
+
+FIXTURE_VARIANT(merge_with_fork)
+{
+	bool forked;
+};
+
+FIXTURE_VARIANT_ADD(merge_with_fork, forked)
+{
+	.forked = true,
+};
+
+FIXTURE_VARIANT_ADD(merge_with_fork, unforked)
+{
+	.forked = false,
+};
+
+FIXTURE_SETUP(merge_with_fork)
+{
+	self->page_size = psize();
+	self->carveout = map_carveout(self->page_size);
+	ASSERT_NE(self->carveout, MAP_FAILED);
+	ASSERT_EQ(open_self_procmap(&self->procmap), 0);
+}
+
+FIXTURE_TEARDOWN(merge_with_fork)
+{
+	ASSERT_EQ(munmap(self->carveout, 30 * self->page_size), 0);
+	ASSERT_EQ(close_procmap(&self->procmap), 0);
+	/* See above. */
+	prctl(PR_SET_MEMORY_MERGE, 0, 0, 0, 0);
+}
+
 TEST_F(merge, mprotect_unfaulted_left)
 {
 	unsigned int page_size = self->page_size;
@@ -322,8 +386,8 @@ TEST_F(merge, forked_target_vma)
 	unsigned int page_size = self->page_size;
 	char *carveout = self->carveout;
 	struct procmap_fd *procmap = &self->procmap;
-	pid_t pid;
 	char *ptr, *ptr2;
+	pid_t pid;
 	int i;
 
 	/*
@@ -344,19 +408,10 @@ TEST_F(merge, forked_target_vma)
 	 */
 	ptr[0] = 'x';
 
-	pid = fork();
+	pid = do_fork(&self->procmap);
 	ASSERT_NE(pid, -1);
-
-	if (pid != 0) {
-		wait(NULL);
+	if (pid != 0)
 		return;
-	}
-
-	/* Child process below: */
-
-	/* Reopen for child. */
-	ASSERT_EQ(close_procmap(&self->procmap), 0);
-	ASSERT_EQ(open_self_procmap(&self->procmap), 0);
 
 	/* unCOWing everything does not cause the AVC to go away. */
 	for (i = 0; i < 5 * page_size; i += page_size)
@@ -386,8 +441,8 @@ TEST_F(merge, forked_source_vma)
 	unsigned int page_size = self->page_size;
 	char *carveout = self->carveout;
 	struct procmap_fd *procmap = &self->procmap;
-	pid_t pid;
 	char *ptr, *ptr2;
+	pid_t pid;
 	int i;
 
 	/*
@@ -408,19 +463,10 @@ TEST_F(merge, forked_source_vma)
 	 */
 	ptr[0] = 'x';
 
-	pid = fork();
+	pid = do_fork(&self->procmap);
 	ASSERT_NE(pid, -1);
-
-	if (pid != 0) {
-		wait(NULL);
+	if (pid != 0)
 		return;
-	}
-
-	/* Child process below: */
-
-	/* Reopen for child. */
-	ASSERT_EQ(close_procmap(&self->procmap), 0);
-	ASSERT_EQ(open_self_procmap(&self->procmap), 0);
 
 	/* unCOWing everything does not cause the AVC to go away. */
 	for (i = 0; i < 5 * page_size; i += page_size)
@@ -1171,10 +1217,11 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
 }
 
-TEST_F(merge, mremap_faulted_to_unfaulted_prev)
+TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
 {
 	struct procmap_fd *procmap = &self->procmap;
 	unsigned int page_size = self->page_size;
+	unsigned long offset;
 	char *ptr_a, *ptr_b;
 
 	/*
@@ -1197,6 +1244,14 @@ TEST_F(merge, mremap_faulted_to_unfaulted_prev)
 	/* Fault it in. */
 	ptr_a[0] = 'x';
 
+	if (variant->forked) {
+		pid_t pid = do_fork(&self->procmap);
+
+		ASSERT_NE(pid, -1);
+		if (pid != 0)
+			return;
+	}
+
 	/*
 	 * Now move it out of the way so we can place VMA B in position,
 	 * unfaulted.
@@ -1220,16 +1275,19 @@ TEST_F(merge, mremap_faulted_to_unfaulted_prev)
 		       &self->carveout[page_size + 3 * page_size]);
 	ASSERT_NE(ptr_a, MAP_FAILED);
 
-	/* The VMAs should have merged. */
+	/* The VMAs should have merged, if not forked. */
 	ASSERT_TRUE(find_vma_procmap(procmap, ptr_b));
 	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_b);
-	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_b + 6 * page_size);
+
+	offset = variant->forked ? 3 * page_size : 6 * page_size;
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_b + offset);
 }
 
-TEST_F(merge, mremap_faulted_to_unfaulted_next)
+TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_next)
 {
 	struct procmap_fd *procmap = &self->procmap;
 	unsigned int page_size = self->page_size;
+	unsigned long offset;
 	char *ptr_a, *ptr_b;
 
 	/*
@@ -1253,6 +1311,14 @@ TEST_F(merge, mremap_faulted_to_unfaulted_next)
 	/* Fault it in. */
 	ptr_a[0] = 'x';
 
+	if (variant->forked) {
+		pid_t pid = do_fork(&self->procmap);
+
+		ASSERT_NE(pid, -1);
+		if (pid != 0)
+			return;
+	}
+
 	/*
 	 * Now move it out of the way so we can place VMA B in position,
 	 * unfaulted.
@@ -1276,16 +1342,18 @@ TEST_F(merge, mremap_faulted_to_unfaulted_next)
 		       &self->carveout[page_size]);
 	ASSERT_NE(ptr_a, MAP_FAILED);
 
-	/* The VMAs should have merged. */
+	/* The VMAs should have merged, if not forked. */
 	ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
 	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
-	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 6 * page_size);
+	offset = variant->forked ? 3 * page_size : 6 * page_size;
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + offset);
 }
 
-TEST_F(merge, mremap_faulted_to_unfaulted_prev_unfaulted_next)
+TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev_unfaulted_next)
 {
 	struct procmap_fd *procmap = &self->procmap;
 	unsigned int page_size = self->page_size;
+	unsigned long offset;
 	char *ptr_a, *ptr_b, *ptr_c;
 
 	/*
@@ -1307,6 +1375,14 @@ TEST_F(merge, mremap_faulted_to_unfaulted_prev_unfaulted_next)
 	/* Fault it in. */
 	ptr_b[0] = 'x';
 
+	if (variant->forked) {
+		pid_t pid = do_fork(&self->procmap);
+
+		ASSERT_NE(pid, -1);
+		if (pid != 0)
+			return;
+	}
+
 	/*
 	 * Now move it out of the way so we can place VMAs A, C in position,
 	 * unfaulted.
@@ -1337,13 +1413,21 @@ TEST_F(merge, mremap_faulted_to_unfaulted_prev_unfaulted_next)
 		       &self->carveout[page_size + 3 * page_size]);
 	ASSERT_NE(ptr_b, MAP_FAILED);
 
-	/* The VMAs should have merged. */
+	/* The VMAs should have merged, if not forked. */
 	ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
 	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
-	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 9 * page_size);
+	offset = variant->forked ? 3 * page_size : 9 * page_size;
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + offset);
+
+	/* If forked, B and C should also not have merged. */
+	if (variant->forked) {
+		ASSERT_TRUE(find_vma_procmap(procmap, ptr_b));
+		ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_b);
+		ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_b + 3 * page_size);
+	}
 }
 
-TEST_F(merge, mremap_faulted_to_unfaulted_prev_faulted_next)
+TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev_faulted_next)
 {
 	struct procmap_fd *procmap = &self->procmap;
 	unsigned int page_size = self->page_size;
@@ -1373,6 +1457,14 @@ TEST_F(merge, mremap_faulted_to_unfaulted_prev_faulted_next)
 	/* Fault it in. */
 	ptr_bc[0] = 'x';
 
+	if (variant->forked) {
+		pid_t pid = do_fork(&self->procmap);
+
+		ASSERT_NE(pid, -1);
+		if (pid != 0)
+			return;
+	}
+
 	/*
 	 * Now move VMA B out the way (splitting VMA BC) so we can place VMA A
 	 * in position, unfaulted, and leave the remainder of the VMA we just
@@ -1397,10 +1489,16 @@ TEST_F(merge, mremap_faulted_to_unfaulted_prev_faulted_next)
 		       &self->carveout[page_size + 3 * page_size]);
 	ASSERT_NE(ptr_b, MAP_FAILED);
 
-	/* The VMAs should have merged. */
-	ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
-	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
-	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 9 * page_size);
+	/* The VMAs should have merged. A,B,C if unforked, B, C if forked. */
+	if (variant->forked) {
+		ASSERT_TRUE(find_vma_procmap(procmap, ptr_b));
+		ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_b);
+		ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_b + 6 * page_size);
+	} else {
+		ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
+		ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
+		ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 9 * page_size);
+	}
 }
 
 TEST_HARNESS_MAIN
-- 
2.52.0



