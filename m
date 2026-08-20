Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C19C46D544;
	Thu, 20 Aug 2026 16:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244572; cv=none; b=uI0D4isB9RFkLYe20T+jr1arJGt9Nf3duAYL8og8oEeTgJSjsTay8P3L4szLtZN9Yo34YvS6RtvE13uKGpcRVNVC2IAAaD0MHyJwhw5/4DPlbtiDfnXIYJScYirwUzuK3M35NWpoWKH/OPIF4tSxn1Vir92ndibJ1egc4jP5C+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244572; c=relaxed/simple;
	bh=ItBZy0+ai6S472fDKUW0sjB4Kc+ieSfBzSESbVKWOfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/tnkIFz+EyJQWr8QrbyCzG/UuzOZoCdjoKN7zBS82rg7thsAjfNbxeb4Gq7R63zXwL28u4ZAaw57Z2Q5+3kRn+k3WPL+PcrBH3vQoRskubBAv/+1RyZ2u/hPDceWfqJDA+7+OWKPeRtQ5+FE9VY3mvHDstJaxkL1QF5YW1mkKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kI83UTf1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kI83UTf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D451F000E9;
	Thu, 20 Aug 2026 16:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244571;
	bh=OfG4EmjhzBBwrlqjNLqUiVrvbhHp+zdkIDoaV2zy+oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kI83UTf1/Jq0ZcdhZ0EF1FABrqlMsg18i1PwhMriI9CFvJsRKLJBHbicbySwYX6tC
	 opKhK7iTw2EqSX60fUTKYXFxGgBudhf7xUihHGt9pt6+IkwEmmZp9t0XzuhzB3v/W1
	 S/TJXxlzzlF6O7zOXdkFN2MDTu1l038JsHHWxLB8=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 214/235] mm/ptdump: always stabilise against page table freeing using init_mm
Date: Thu, 20 Aug 2026 16:57:30 +0200
Message-ID: <20260820145223.095013065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>

[ Upstream commit 27c32e5538344b13c1505a08861e04620c125d47 ]

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
[ Adapted the hunk to `walk_page_range_novma()` since 5.15 lacks the `walk_page_range_debug()` rename and the `walk_kernel_page_table_range()` dispatch, keeping the existing `!walk.mm` guard. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/pagewalk.c |    8 ++++++++
 mm/ptdump.c   |    7 +++++++
 2 files changed, 15 insertions(+)

--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -457,6 +457,14 @@ int walk_page_range_novma(struct mm_stru
 		return -EINVAL;
 
 	mmap_assert_write_locked(walk.mm);
+	/*
+	 * x86, arm64 ptdump allow walks of efi mm's and x86 ptdump allows walks
+	 * of arbitrary mm's.
+	 *
+	 * However, they both must also hold the init_mm lock to account for
+	 * concurrent kernel page table freeing.
+	 */
+	mmap_assert_write_locked(&init_mm);
 
 	return walk_pgd_range(start, end, &walk);
 }
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -143,11 +143,18 @@ void ptdump_walk_pgd(struct ptdump_state
 
 	get_online_mems();
 	mmap_write_lock(mm);
+	/* To stabilise kernel page tables we must hold the init_mm lock too. */
+	if (mm != &init_mm)
+		mmap_write_lock_nested(&init_mm, SINGLE_DEPTH_NESTING);
+
 	while (range->start != range->end) {
 		walk_page_range_novma(mm, range->start, range->end,
 				      &ptdump_ops, pgd, st);
 		range++;
 	}
+
+	if (mm != &init_mm)
+		mmap_write_unlock(&init_mm);
 	mmap_write_unlock(mm);
 	put_online_mems();
 


