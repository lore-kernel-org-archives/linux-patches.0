Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591388;
	b=2quyMeoOxVGAjyVdq7gyl7FrrnZneKtVVDzKKkJeGg+FFX2MSnRelyNYPDOyjvDes5JU
	 /F2mQOzsV5ebtmF/dT+dpMpx/bpNucfCHA6GQWPnv3n0+ScOKcqnGEV3mav8GALQsmExK
	 OGQcWFKUmF8DdBUe07AKtCB4qOeFLRBRefFEF0IN6kjp2uI6hA+6Eyj/fXVgM2jHrd6VJ
	 wO066y1qCGvQqlYYsDfumbJDHowsbctv5cdeQnkooxGFQ7eUiRLVjdEV1ms2eQtt3jyF5
	 j3PYWf1d7qNnJtZjHHxemSEYoOzqJlfZgcu5rtW0w2FLc627VO4x2wleuvfio+vFS/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IMQ5O7pIwawvfyezs7spM3O2zxRjlFi0sggDEY7I8Wo=;
	b=VVsgDccpp3EEPOdMJtS9ABPNTg8FN04ohpnI+GSjE4mKFXAv+ioMzlDpdxJpTZELKYWI
	 Mgj+l4yR3jflGXRPZMKXPuFyOyJ2au9uoq9qJVj7KWFeOJ3Ey+xdZLxdZE1N5hTn7qELe
	 gtFob0eTTrLFXuvNy7y7Dt8lsdo7bB0kKw5r9oSvkUlBEDpbSk6BHiipmy91zGxJ7CVck
	 sGiF/8uvlQFjZMPL3+1of7ey8ftd8Ftsx17bRB3eAVZMToPCqjKUzkr2DNjl4Ei1uaTM3
	 i3PSFMK/9dHezzWfWSnqu0V9kdGrhBqlG1hUMAIezRiVbv1DIKklTfhwVuX17hmB5Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EXvU52jY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45655607A5C8;
	Fri, 13 Nov 2026 17:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EXvU52jY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBABA1F000C4;
	Fri, 13 Nov 2026 17:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591388;
	bh=IMQ5O7pIwawvfyezs7spM3O2zxRjlFi0sggDEY7I8Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EXvU52jYGKc2W3Ljjm2ADDBjyUGeDffntZUp4br+F8Zo4Q6ds3XXmegj+Ahlta/he
	 UcWClRwdcs7/qtye3+qUkL3wFCX6xyiW+GGLSQSl6hpl5Or5vXJIk2JGpKO7zODN5w
	 3NyIY7LwpOirskhiaBvD6MwVs7CuZLN64BYiQuBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 489/670] mm/page_vma_mapped: continue past nonmatching huge PMDs
Date: Fri, 13 Nov 2026 10:50:53 -0500
Message-ID: <20261113153828.505498355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 1a2993227e8a27fc4cdea305bbdae82d290bc885 ]

A PTE-mapped large folio can straddle PMD boundaries after an unaligned
mremap().  If the first part is discarded and replaced with an unrelated
huge PMD, page_vma_mapped_walk() stops instead of looking for the rest of
the folio in subsequent PMDs.

This also affects migration entries.  A walk that stops at an unrelated
huge PMD can leave migration PTEs behind when migration or an anonymous
folio split restores the mappings.  Those entries do not hold mapping
references and can outlive the source folio.

This issue can lead to memory corruption and I have a reproducer for
it.

Skip the current PMD rather than ending the walk on a flag or PFN
mismatch.  Do the same if the PMD became nonpresent before the locked
recheck.  Release the PMD lock, clear the per-PMD state and advance with
step_forward(), so the existing range limit controls termination.  This
covers present, migration and device-private huge PMDs while preserving
the matching-PMD and split-to-PTE paths.

Link: https://lore.kernel.org/20261016011549.61146-1-kylebot@openai.com
Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: <stable@vger.kernel.org>
[ sashal: adjusted context for swap-entry-based PMD handling and older page-table walking interfaces ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_vma_mapped.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 1cc8fd382cd13..67e6a32644bad 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -255,18 +255,18 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 
 				if (!thp_migration_supported() ||
 				    !(pvmw->flags & PVMW_MIGRATION))
-					return not_found(pvmw);
+					goto next_pmd;
 				entry = pmd_to_swp_entry(pmde);
 				if (!is_migration_entry(entry) ||
 				    !check_pmd(swp_offset_pfn(entry), pvmw))
-					return not_found(pvmw);
+					goto next_pmd;
 				return true;
 			}
 			if (likely(pmd_trans_huge(pmde) || pmd_devmap(pmde))) {
 				if (pvmw->flags & PVMW_MIGRATION)
-					return not_found(pvmw);
+					goto next_pmd;
 				if (!check_pmd(pmd_pfn(pmde), pvmw))
-					return not_found(pvmw);
+					goto next_pmd;
 				return true;
 			}
 			/* THP pmd was split under us: handle on pte level */
@@ -286,8 +286,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 
 				spin_unlock(ptl);
 			}
-			step_forward(pvmw, PMD_SIZE);
-			continue;
+			goto next_pmd;
 		}
 		if (!map_pte(pvmw, &ptl)) {
 			if (!pvmw->pte)
@@ -320,6 +319,17 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			spin_lock(pvmw->ptl);
 		}
 		goto this_pte;
+next_pmd:
+		/*
+		 * A large folio can be PTE-mapped across PMDs, so a
+		 * nonmatching PMD does not end the walk.
+		 */
+		if (pvmw->ptl) {
+			spin_unlock(pvmw->ptl);
+			pvmw->ptl = NULL;
+		}
+		pvmw->pmd = NULL;
+		step_forward(pvmw, PMD_SIZE);
 	} while (pvmw->address < end);
 
 	return false;
-- 
2.53.0



