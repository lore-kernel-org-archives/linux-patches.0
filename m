Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398ED26A08E;
	Tue,  8 Apr 2025 11:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111639; cv=none; b=ENHZUwmh8l1ksVANmHPqu2u3pw2EKs5JILw4/ImdKJQ1KtY6K/ZDRy3TLRGloJnNkJPda/7d3m1IifTxhv5+hYgALdwFfyKqPiCCKBbFfzX+uTtE5rfElz4WXlEkbhEwGmh3cuSgonTUxYETzeMxinV6QKUiJfhLN9z7SPSGKbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111639; c=relaxed/simple;
	bh=Dl4j0081yegnCy7YFmzj+7sJ18Mr3jhjXtZ3r8eFaR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0GpLiUWssw+CLEDkYRptyXzeIDXLHfDSx9sWbijQM49aB0KUdCTGpxv4FIDKr9h4Mx7peGI3FyZyKH0XApfzjQ6Vx/sJhGaCc2GDswtkFGTbP8QBhaaD6ZzX4smcph80cdUluBiDap/fFQGJAyYUatBEc1tUZrgkbRCxjYwqwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ux6OH+Rb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ux6OH+Rb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25677C4CEE5;
	Tue,  8 Apr 2025 11:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111638;
	bh=Dl4j0081yegnCy7YFmzj+7sJ18Mr3jhjXtZ3r8eFaR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ux6OH+RbZyMkkJwhTuBeiqeOloHVoLL43r95dDKl/+GIFG9gLCjUgA9sWpPgzr14I
	 OK82FkTfCvKimbTNYfvVZpq0y8RK/YlXzmePp+7YRNHKIyYMIkIe/eotuaoZuJxyPT
	 hlBdCCEVT0MFKRNnr/V6MDS21D52QQwq8J9wbwaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Alex Shi <alexs@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Dave Airlie <airlied@gmail.com>,
	Jann Horn <jannh@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jerome Glisse <jglisse@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Karol Herbst <kherbst@redhat.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Lyude <lyude@redhat.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Peter Xu <peterx@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	SeongJae Park <sj@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yanteng Si <si.yanteng@linux.dev>,
	Barry Song <v-songbaohua@oppo.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 503/731] kernel/events/uprobes: handle device-exclusive entries correctly in __replace_page()
Date: Tue,  8 Apr 2025 12:46:40 +0200
Message-ID: <20250408104925.974075703@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 096cbb80ab3fd85a9035ec17a1312c2a7db8bc8c ]

Ever since commit b756a3b5e7ea ("mm: device exclusive memory access") we
can return with a device-exclusive entry from page_vma_mapped_walk().

__replace_page() is not prepared for that, so teach it about these PFN
swap PTEs.  Note that device-private entries are so far not applicable on
that path, because GUP would never have returned such folios (conversion
to device-private happens by page migration, not in-place conversion of
the PTE).

There is a race between GUP and us locking the folio to look it up using
page_vma_mapped_walk(), so this is likely a fix (unless something else
could prevent that race, but it doesn't look like).  pte_pfn() on
something that is not a present pte could give use garbage, and we'd
wrongly mess up the mapcount because it was already adjusted by calling
folio_remove_rmap_pte() when making the entry device-exclusive.

Link: https://lkml.kernel.org/r/20250210193801.781278-9-david@redhat.com
Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
Signed-off-by: David Hildenbrand <david@redhat.com>
Tested-by: Alistair Popple <apopple@nvidia.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lyude <lyude@redhat.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yanteng Si <si.yanteng@linux.dev>
Cc: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/uprobes.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index b4ca8898fe178..eac24f39c2c2d 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -173,6 +173,7 @@ static int __replace_page(struct vm_area_struct *vma, unsigned long addr,
 	DEFINE_FOLIO_VMA_WALK(pvmw, old_folio, vma, addr, 0);
 	int err;
 	struct mmu_notifier_range range;
+	pte_t pte;
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, addr,
 				addr + PAGE_SIZE);
@@ -192,6 +193,16 @@ static int __replace_page(struct vm_area_struct *vma, unsigned long addr,
 	if (!page_vma_mapped_walk(&pvmw))
 		goto unlock;
 	VM_BUG_ON_PAGE(addr != pvmw.address, old_page);
+	pte = ptep_get(pvmw.pte);
+
+	/*
+	 * Handle PFN swap PTES, such as device-exclusive ones, that actually
+	 * map pages: simply trigger GUP again to fix it up.
+	 */
+	if (unlikely(!pte_present(pte))) {
+		page_vma_mapped_walk_done(&pvmw);
+		goto unlock;
+	}
 
 	if (new_page) {
 		folio_get(new_folio);
@@ -206,7 +217,7 @@ static int __replace_page(struct vm_area_struct *vma, unsigned long addr,
 		inc_mm_counter(mm, MM_ANONPAGES);
 	}
 
-	flush_cache_page(vma, addr, pte_pfn(ptep_get(pvmw.pte)));
+	flush_cache_page(vma, addr, pte_pfn(pte));
 	ptep_clear_flush(vma, addr, pvmw.pte);
 	if (new_page)
 		set_pte_at(mm, addr, pvmw.pte,
-- 
2.39.5



