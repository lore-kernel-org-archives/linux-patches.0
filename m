Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827162;
	b=WLHPskU4hph5cZOXR4RjAeRg5FJgFNvsTzcYZ3vUdi+TaScLEJoVZESucWBrDMaDmLWf
	 tef4Cc4ET4L9p5efIo6X7cQE1eZbRXCCa59YB0lvggjGMXDzkKTVawskaUyfPBg0i+Zau
	 YJX/BOQD5FANZQvSn7H0rbsSfKNEQVUQVNTaLXbm6h3uiaTDmyxfqwgcnkijefPLKFp+L
	 eKxT0zEKz7eKnrq4lia8opoQdVjHlKyaeEVkcLIF82riG/hu38n+RuJxgC2Tthy7JsquX
	 mxYmJLIMqPvFia+ySumQH0DH4NlW5dKbXukYEYk4GJGjFEsWStNzjnQERfCe7ROlWtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F8vOEDDvorPKfkwaNi3fXFN6U64ch1htT8mMDCjK5rU=;
	b=Azezl7YvQOgg46nNuDGOPzdjTNVmkg/T9S57o6iEhJymYukoIMqdoevE+3hGcqVTgc3j
	 1wmwarf3QjZzaix2uFlO2LrTWIgSA4OmnNIWIdXHXPloc5GGdqZ38Xv/huvegwadqksM/
	 /EC8QzNpQMpa8SHt8sw49UOgmsa6XV+FV+JN1lCpIYV6LeXtbb5C/sRB2Ia0zskq1uskH
	 GqfRdzpcSkgRIsxzhm6bwPLfif7R6FnKg6ibzuiIRuEHYpCMEs22O+lLftYjsycK+k8Gu
	 V1CPoVvj3zwb8eunvlhEYjOrNvGRjFdkGm+xWSF7NnITshKjtli07Zl5I7S8ZhQqMXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DLlHVmWX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681AE606AB17;
	Wed,  4 Nov 2026 21:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DLlHVmWX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C691F0093A;
	Wed,  4 Nov 2026 21:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827162;
	bh=F8vOEDDvorPKfkwaNi3fXFN6U64ch1htT8mMDCjK5rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DLlHVmWXZkL01PbAqP06RcnJ/LnIOZ7m2SPCebPKK2UGOd/CXfusgNWQMdFKIdRab
	 FBodqInQdoFDmObQjAQwt5MY1aP+X3utURFJKyoXT+54Rh1ZaSrOzUPru8aodoKkye
	 hHZ047oLDIFvFrCt6nJKD26RtNeYttG7sx0/SxWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kyle Zeng <kylebot@openai.com>,
	Lance Yang <lance.yang@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"JongHyuk Kim(MalHyuk)" <malhyuk97@gmail.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 7.3 233/547] mm/rmap: dont discard lazyfree THPs at PMD level
Date: Wed,  4 Nov 2026 16:06:57 -0500
Message-ID: <20261104211044.780126217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zi Yan <ziy@nvidia.com>

commit 984c0700854e35779a2bcce6b02783e709b6efa2 upstream.

__discard_anon_folio_pmd_locked() clears a lazyfree THP's PMD before it
determines whether the folio can be discarded, and restores it if the
folio is dirty or has extra references.  It is done under only the PMD
lock and the anon_vma read lock inside try_to_unmap_one() and no mmap lock
is held.  The temporarily none PMD causes UAF.

A parallel munmap() or mremap() is supposed to serialize with it on the
PMD lock, but zap_pmd_range() (called by munmap()) and move_page_tables()
(called by mremap()) do not take the lock when they see the temporarily
none PMD and skip the PMD.  There is no more page table walk after the
none PMD is restored:

- munmap(): free_pgtables() waits in unlink_anon_vmas() for the anon_vma
  lock, then free_pmd_range() drops the restored PMD as bad without
  removing the rmap, so the folio keeps a stale mapcount.

- whole-VMA MREMAP_DONTUNMAP: dontunmap_complete() unlinks the source VMA
  from its anon_vma while the restored PMD still maps the folio.

- plain mremap(): the THP is not moved but unmapped, so the THP's data is
  lost.

In the first two cases, the folio stays mapped, but no VMA that maps it is
linked to its anon_vma.  When the anon_vma is freed, it is still reachable
when one rmap walks the folio.  Racing lazyfree reclaim against
MREMAP_DONTUNMAP as an unprivileged user reproduces a KASAN use-after-free
in folio_lock_anon_vma_read() as reported in the Closes link.

One solution is to use an invalidated PMD instead of a cleared one until
the discard is committed, but it needs arch fixes first.
1. GUP-fast still follows an invalidated PMD on riscv, LoongArch and s390.
2. sparc64 miscounts thp_pte_count when an invalidated PMD is set again or
   cleared.

To keep the fix simple for backport, stop discarding lazyfree THPs at PMD
level instead. try_to_unmap_one() splits the PMD and discards the folio at
PTE level.

unmap_huge_pmd_locked() and __discard_anon_folio_pmd_locked() are left in
place, unused, to minimize this fix for backport and the invalidated PMD
approach is planned as a follow-up series to use them again.

Link: https://lore.kernel.org/20261012-lazyfree-stable-fix-v2-1-6387d6e30063@nvidia.com
Fixes: 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during shrink_folio_list()")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Kyle Zeng <kylebot@openai.com>
Closes: https://lore.kernel.org/r/20261009165214.40212-2-kylebot@openai.com
Reviewed-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: JongHyuk Kim(MalHyuk) <malhyuk97@gmail.com>
  Link: https://lore.kernel.org/CADQRuqvXQ=YE=7T3oR66vTxE33pi=ygEeZKPTOU=cALZL0Figw@mail.gmail.com
Assisted-by: LLM
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/rmap.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2275,17 +2275,6 @@ static bool try_to_unmap_one(struct foli
 		}
 
 		if (!pvmw.pte) {
-			if (folio_test_lazyfree(folio)) {
-				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
-					goto walk_done;
-				/*
-				 * unmap_huge_pmd_locked has either already marked
-				 * the folio as swap-backed or decided to retain it
-				 * due to GUP or speculative references.
-				 */
-				goto walk_abort;
-			}
-
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				/*
 				 * We temporarily have to drop the PTL and


