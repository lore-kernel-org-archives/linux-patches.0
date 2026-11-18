Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053869;
	b=KyU5vjEnzgKHsYOesbayTvVhiaKRV+C1ugRbzrwbnbEkziYgbLyRMcMQj4k/M5/tMbKh
	 Lvm8lfwfknTKni5H7uqksu5D2jmJlqQVU8TLmzX0LHqUxQQOkm8Lw27oorJOiT9+JlXhY
	 Wtopv4wi3mdKZDyXC1ayEz65pVgPq3PZCqBH9X/fdsuHQgWfyXLR+bSsy8iyi99h4N+p+
	 F6x2EdB+9Vw/UToy5hxz2JQANc1PbUMyok9FCIGjOx5MsA6jRJtXuB2b6do0yColom0ld
	 OTwE7myiVgjB6NORKMkek2ROn+vqbZoHLWbRoVmWl5ha0YByM2b/tq/wMwj5/NMhk6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5Gh8u4100BQO7J+IKQ0Z1Oc+kuyXUmG+D5GjaGeFnoU=;
	b=pFaGiCvsk0zfaJH8sw38bu8QLx5QRJ5qSQ97wc2HFmRgXg8nHfVg396pCQ92PvfE5Oha
	 s9oxnc9EZymtalXI9TqKnMoNswAldasyO490Kk41g0IGpPEUl9ku51AHKP1kDWKRURLVS
	 1bMSdTxbZEuPvLj3QnVI/WI8iqcCIsmo2Hx5WGxnQIxkkpa8LKomWodK+6qyX+7veaido
	 mMVCNg5SiE95K/uXRzQqfnWEPOz4DDwyYwTQW3SzUoNJNjg9PVtZ5PS0uiNyGrLwtaa6O
	 9HMAHhm4GcFoELUbZsSeBnWfBWXoU2NbiN7b583LdsP6dBOXEGY1IdIQosJ3dFOmOJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E2ZBY3e4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404D9606A320;
	Thu, 19 Nov 2026 02:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E2ZBY3e4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6C01F000C5;
	Thu, 19 Nov 2026 02:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053869;
	bh=5Gh8u4100BQO7J+IKQ0Z1Oc+kuyXUmG+D5GjaGeFnoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E2ZBY3e4EhZlrVMClGepqzMUmMABjA2UReOlgOu9BHvlo0uUsiCOeMSaBlPsPShnM
	 PQ7Ky6wyobFtXZs63I1PBzYqdJVkGCk7IvGMfAJvdPWhobV81PKxh6z87qbJGsO8XH
	 1p89KreGHPN3kSE0nKrn6LpXS2+37fEdnMLc71RU=
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
Subject: [PATCH 5.15 1021/2214] mm/page_vma_mapped: continue past nonmatching huge PMDs
Date: Wed, 18 Nov 2026 15:44:57 +0100
Message-ID: <20261118150053.205629057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: used existing page-pointer comparisons in place of upstream PFN-range checks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_vma_mapped.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index f7b3310817910..ea4eaece8c887 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -223,9 +223,9 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			pmde = *pvmw->pmd;
 			if (likely(pmd_trans_huge(pmde))) {
 				if (pvmw->flags & PVMW_MIGRATION)
-					return not_found(pvmw);
+					goto next_pmd;
 				if (pmd_page(pmde) != page)
-					return not_found(pvmw);
+					goto next_pmd;
 				return true;
 			}
 			if (!pmd_present(pmde)) {
@@ -233,11 +233,11 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 
 				if (!thp_migration_supported() ||
 				    !(pvmw->flags & PVMW_MIGRATION))
-					return not_found(pvmw);
+					goto next_pmd;
 				entry = pmd_to_swp_entry(pmde);
 				if (!is_migration_entry(entry) ||
 				    pfn_swap_entry_to_page(entry) != page)
-					return not_found(pvmw);
+					goto next_pmd;
 				return true;
 			}
 			/* THP pmd was split under us: handle on pte level */
@@ -255,8 +255,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 
 				spin_unlock(ptl);
 			}
-			step_forward(pvmw, PMD_SIZE);
-			continue;
+			goto next_pmd;
 		}
 		if (!map_pte(pvmw))
 			goto next_pte;
@@ -290,6 +289,17 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
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



