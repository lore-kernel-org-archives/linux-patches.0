Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EA234B69C;
	Wed, 21 Jan 2026 18:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020303; cv=none; b=UJOhamoU0ZmNaKm0bAxcLWjp1Ka/oGfW6a6ZvnXLeJ3eo7Kl1zhHeqsr92cIYP7ed9jgy5PcXDMAuSPOpM3hljK/CM+mEpfk8agVOsRcVSwFyAgtOzR6PUxtkUIXJ9SFAVr5VbJp41nJGclgYanD9bT0gpFt+f1bTPVoGUVahFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020303; c=relaxed/simple;
	bh=31jwoirnovSWF/SD0SiwYrgVbA76VGIok+ISk4Vqv0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9Ck4+Pb74QZomHlqf5ryfpyBSkPsQ+t7Ki9pleti/8m4rPRHS8x0Mf5WXv4Z5jqNNjw+zvHN/grTkGSRsVmtfGwWOxco40KIIZK2U1Z0C5mKUoCS8s7/jnvPq4PQuYO+raoFvqkHqL4lVteXM6/COlW9uHOGPDBTEMYzdFtW58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OcWRdyH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OcWRdyH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC32C4CEF1;
	Wed, 21 Jan 2026 18:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020302;
	bh=31jwoirnovSWF/SD0SiwYrgVbA76VGIok+ISk4Vqv0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OcWRdyH1FIrR3PH8GoWpl6+wYdbbOpI+GD1uErzZp9lLamfnm295QQ8aISRjliRT2
	 uSUFBxI9k55049sIbioz6NOKARMu6A9HDAiBfUKkzr9uxPr2U9HMbmi/4rHezzjZyK
	 Hxeg+CwrHFwL4Xe96fScHfGorRq8Xk6dXdB4FRA8=
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
Subject: [PATCH 6.18 101/198] tools/testing/selftests: add tests for !tgt, src mremap() merges
Date: Wed, 21 Jan 2026 19:15:29 +0100
Message-ID: <20260121181422.189443972@linuxfoundation.org>
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

commit 0ace8f2db6b3b4b0677e559d1a7ab7fd625d61ec upstream.

Test that mremap()'ing a VMA into a position such that the target VMA on
merge is unfaulted and the source faulted is correctly performed.

We cover 4 cases:

    1. Previous VMA unfaulted:

                  copied -----|
                              v
            |-----------|.............|
            | unfaulted |(faulted VMA)|
            |-----------|.............|
                 prev

    target = prev, expand prev to cover.

    2. Next VMA unfaulted:

                  copied -----|
                              v
                        |.............|-----------|
                        |(faulted VMA)| unfaulted |
                        |.............|-----------|
                                          next

    target = next, expand next to cover.

    3. Both adjacent VMAs unfaulted:

                  copied -----|
                              v
            |-----------|.............|-----------|
            | unfaulted |(faulted VMA)| unfaulted |
            |-----------|.............|-----------|
                 prev                      next

    target = prev, expand prev to cover.

    4. prev unfaulted, next faulted:

                  copied -----|
                              v
            |-----------|.............|-----------|
            | unfaulted |(faulted VMA)|  faulted  |
            |-----------|.............|-----------|
                 prev                      next

    target = prev, expand prev to cover. Essentially equivalent to 3, but
    with additional requirement that next's anon_vma is the same as the
    copied VMA's.

Each of these are performed with MREMAP_DONTUNMAP set, which will cause a
KASAN assert for UAF or an assert on zero refcount anon_vma if a bug
exists with correctly propagating anon_vma state in each scenario.

Link: https://lkml.kernel.org/r/f903af2930c7c2c6e0948c886b58d0f42d8e8ba3.1767638272.git.lorenzo.stoakes@oracle.com
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
 tools/testing/selftests/mm/merge.c |  232 +++++++++++++++++++++++++++++++++++++
 1 file changed, 232 insertions(+)

--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -1171,4 +1171,236 @@ TEST_F(merge, mremap_correct_placed_faul
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
 }
 
+TEST_F(merge, mremap_faulted_to_unfaulted_prev)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *ptr_a, *ptr_b;
+
+	/*
+	 * mremap() such that A and B merge:
+	 *
+	 *                             |------------|
+	 *                             |    \       |
+	 *           |-----------|     |    /  |---------|
+	 *           | unfaulted |     v    \  | faulted |
+	 *           |-----------|          /  |---------|
+	 *                 B                \       A
+	 */
+
+	/* Map VMA A into place. */
+	ptr_a = mmap(&self->carveout[page_size + 3 * page_size],
+		     3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+	/* Fault it in. */
+	ptr_a[0] = 'x';
+
+	/*
+	 * Now move it out of the way so we can place VMA B in position,
+	 * unfaulted.
+	 */
+	ptr_a = mremap(ptr_a, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE, &self->carveout[20 * page_size]);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+
+	/* Map VMA B into place. */
+	ptr_b = mmap(&self->carveout[page_size], 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+
+	/*
+	 * Now move VMA A into position with MREMAP_DONTUNMAP to catch incorrect
+	 * anon_vma propagation.
+	 */
+	ptr_a = mremap(ptr_a, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
+		       &self->carveout[page_size + 3 * page_size]);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+
+	/* The VMAs should have merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr_b));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_b);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_b + 6 * page_size);
+}
+
+TEST_F(merge, mremap_faulted_to_unfaulted_next)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *ptr_a, *ptr_b;
+
+	/*
+	 * mremap() such that A and B merge:
+	 *
+	 *      |---------------------------|
+	 *      |                   \       |
+	 *      |    |-----------|  /  |---------|
+	 *      v    | unfaulted |  \  | faulted |
+	 *           |-----------|  /  |---------|
+	 *                 B        \       A
+	 *
+	 * Then unmap VMA A to trigger the bug.
+	 */
+
+	/* Map VMA A into place. */
+	ptr_a = mmap(&self->carveout[page_size], 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+	/* Fault it in. */
+	ptr_a[0] = 'x';
+
+	/*
+	 * Now move it out of the way so we can place VMA B in position,
+	 * unfaulted.
+	 */
+	ptr_a = mremap(ptr_a, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE, &self->carveout[20 * page_size]);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+
+	/* Map VMA B into place. */
+	ptr_b = mmap(&self->carveout[page_size + 3 * page_size], 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+
+	/*
+	 * Now move VMA A into position with MREMAP_DONTUNMAP to catch incorrect
+	 * anon_vma propagation.
+	 */
+	ptr_a = mremap(ptr_a, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
+		       &self->carveout[page_size]);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+
+	/* The VMAs should have merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 6 * page_size);
+}
+
+TEST_F(merge, mremap_faulted_to_unfaulted_prev_unfaulted_next)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *ptr_a, *ptr_b, *ptr_c;
+
+	/*
+	 * mremap() with MREMAP_DONTUNMAP such that A, B and C merge:
+	 *
+	 *                  |---------------------------|
+	 *                  |                   \       |
+	 * |-----------|    |    |-----------|  /  |---------|
+	 * | unfaulted |    v    | unfaulted |  \  | faulted |
+	 * |-----------|         |-----------|  /  |---------|
+	 *       A                     C        \        B
+	 */
+
+	/* Map VMA B into place. */
+	ptr_b = mmap(&self->carveout[page_size + 3 * page_size], 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+	/* Fault it in. */
+	ptr_b[0] = 'x';
+
+	/*
+	 * Now move it out of the way so we can place VMAs A, C in position,
+	 * unfaulted.
+	 */
+	ptr_b = mremap(ptr_b, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE, &self->carveout[20 * page_size]);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+
+	/* Map VMA A into place. */
+
+	ptr_a = mmap(&self->carveout[page_size], 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+
+	/* Map VMA C into place. */
+	ptr_c = mmap(&self->carveout[page_size + 3 * page_size + 3 * page_size],
+		     3 * page_size, PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_c, MAP_FAILED);
+
+	/*
+	 * Now move VMA B into position with MREMAP_DONTUNMAP to catch incorrect
+	 * anon_vma propagation.
+	 */
+	ptr_b = mremap(ptr_b, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
+		       &self->carveout[page_size + 3 * page_size]);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+
+	/* The VMAs should have merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 9 * page_size);
+}
+
+TEST_F(merge, mremap_faulted_to_unfaulted_prev_faulted_next)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *ptr_a, *ptr_b, *ptr_bc;
+
+	/*
+	 * mremap() with MREMAP_DONTUNMAP such that A, B and C merge:
+	 *
+	 *                  |---------------------------|
+	 *                  |                   \       |
+	 * |-----------|    |    |-----------|  /  |---------|
+	 * | unfaulted |    v    |  faulted  |  \  | faulted |
+	 * |-----------|         |-----------|  /  |---------|
+	 *       A                     C        \       B
+	 */
+
+	/*
+	 * Map VMA B and C into place. We have to map them together so their
+	 * anon_vma is the same and the vma->vm_pgoff's are correctly aligned.
+	 */
+	ptr_bc = mmap(&self->carveout[page_size + 3 * page_size],
+		      3 * page_size + 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_bc, MAP_FAILED);
+
+	/* Fault it in. */
+	ptr_bc[0] = 'x';
+
+	/*
+	 * Now move VMA B out the way (splitting VMA BC) so we can place VMA A
+	 * in position, unfaulted, and leave the remainder of the VMA we just
+	 * moved in place, faulted, as VMA C.
+	 */
+	ptr_b = mremap(ptr_bc, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE, &self->carveout[20 * page_size]);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+
+	/* Map VMA A into place. */
+	ptr_a = mmap(&self->carveout[page_size], 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+
+	/*
+	 * Now move VMA B into position with MREMAP_DONTUNMAP to catch incorrect
+	 * anon_vma propagation.
+	 */
+	ptr_b = mremap(ptr_b, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
+		       &self->carveout[page_size + 3 * page_size]);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+
+	/* The VMAs should have merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 9 * page_size);
+}
+
 TEST_HARNESS_MAIN


