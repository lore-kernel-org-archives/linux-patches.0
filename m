Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF91233923;
	Mon, 17 Aug 2026 13:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974644; cv=none; b=nsz43Z+pNFYOBvs0Ta0K2dVgjzpZDnnoyF8Lfxr7f+d3n7FAQjI8d1bWayUgFYE+mmFZg3OWAMWtWq9zBs1AQxjJkkrcS68jjhgaJJ1fVytECVNaWDMT6bKuPj7H3kYL+4k4YgLNOekVh2WRWRiyWhFnR3gNtGwuKTvFRpbRjfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974644; c=relaxed/simple;
	bh=h2I5F5KkiAFndwC/UQNPS4qO/xbAJZBUJOT1XlBmeds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eL5nsBPq98YR1l1/JhadpvKk8pLvx+B+iH7GBuTv3n6M4cIbAGVMH59neSRWqCx77dcjq0xDBSs7OfeGCPRdcVCjXhlvuyEReTidZ6Mo3z6eLfhXFalttK53bVTUaExMC6kolhNU+u9OZew0FBkVDfqReEqys4X3VND1sANHe0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDwutzOH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDwutzOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEB41F000E9;
	Mon, 17 Aug 2026 13:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974637;
	bh=yJ1JfK7nm9znuVAgs8GwZsj13tUx0jg4L93GLgdcjNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jDwutzOHm3JQ4kn6+N8xYHqkL9AW7DSviaU8KwI3UkO/R71mAd8u6GKPa7W+2AAtF
	 0bQ9fnlAKZhYa9SDb7zzw6bvnugYgX5kCNDiSgB7P+petq8ygh+kzkmoOzoczXUmZN
	 x1I9roZCmqB0dtLMt8ab27JVzzrc9l3PhiLJ0E84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	"Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Carlier <devnexen@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Toshi Kani <toshi.kani@hpe.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 253/271] mm/ptdump: always stabilise against page table freeing using init_mm
Date: Mon, 17 Aug 2026 15:32:58 +0200
Message-ID: <20260817132547.160451967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

commit 27c32e5538344b13c1505a08861e04620c125d47 upstream.

Previous commits have established the invariant that kernel page table
freeing is performed while an mmap read lock on init_mm is held, which
fixes races between ptdump and kernel page table freeing over init_mm.

However, x86 and arm64 can perform a ptdump over an mm other than init_mm
via ptdump_walk_pgd() and since kernel memory ranges are shared across
non-kernel mm's, this means that the race still exists for these cases.

Fix this by acquiring a nested mmap write lock for init_mm in
ptdump_walk_pgd().

This is safe as we take this after mmap write locking the mm, and nothing
acquires the init_mm lock first before locking an arbitrary mm, so no
deadlock is possible.

Also update walk_page_range_debug() to assert that init_mm is write
locked, add a comment explaining why and remove some redundant code, and
eliminate the unnecessary and confusing invocation of
walk_kernel_page_table_range().

We can safely remove the non-NULL check for walk.mm, as the mmap lock
asserts would NULL pointer deref if it was (and of course no callers do
this).

The first point at which ptdump can race kernel page table freeing is
commit b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page
table"), so we target this in the Fixes tag.

Link: https://lore.kernel.org/20260723-series-vmap-race-fix-v6-4-8cc77dcc0018@kernel.org
Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Carlier <devnexen@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/pagewalk.c |   14 +++++++++-----
 mm/ptdump.c   |    7 +++++++
 2 files changed, 16 insertions(+), 5 deletions(-)

--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -702,12 +702,16 @@ int walk_page_range_debug(struct mm_stru
 	 * to account for page table freeing on vmap huge page mapping.
 	 */
 	mmap_assert_write_locked(mm);
+	/*
+	 * x86, arm64 ptdump allow walks of efi mm's and x86 ptdump allows walks
+	 * of arbitrary mm's.
+	 *
+	 * However, they both must also hold the init_mm lock to account for
+	 * concurrent kernel page table freeing.
+	 */
+	mmap_assert_write_locked(&init_mm);
 
-	/* For convenience, we allow traversal of kernel mappings. */
-	if (mm == &init_mm)
-		return walk_kernel_page_table_range(start, end, ops,
-						    pgd, private);
-	if (start >= end || !walk.mm)
+	if (start >= end)
 		return -EINVAL;
 	if (!check_ops_safe(ops))
 		return -EINVAL;
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -178,11 +178,18 @@ void ptdump_walk_pgd(struct ptdump_state
 
 	get_online_mems();
 	mmap_write_lock(mm);
+	/* To stabilise kernel page tables we must hold the init_mm lock too. */
+	if (mm != &init_mm)
+		mmap_write_lock_nested(&init_mm, SINGLE_DEPTH_NESTING);
+
 	while (range->start != range->end) {
 		walk_page_range_debug(mm, range->start, range->end,
 				      &ptdump_ops, pgd, st);
 		range++;
 	}
+
+	if (mm != &init_mm)
+		mmap_write_unlock(&init_mm);
 	mmap_write_unlock(mm);
 	put_online_mems();
 


