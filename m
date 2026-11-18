Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038210;
	b=aeHrbLXDea6/MQnLzIjvAVuP3JC/NbyR2I+TSYyqKiFzwaPcEuRsWmMTBt6mgVLNFkcF
	 gVAw/L0mbPNZ3coRJW207NJghzAh1je3nBBGK2Z4jy2kELDE/Ier2DqHBWDJn5NTAkkKb
	 +DNlZhySHT9FVt+wfSHqlc2N/4BSI3nLGbTtclRVtoebnbZ0cCGI7+YZEoRuZjrp0TR7Y
	 Dsl5SKMMBByQ/k7FEruIGy3jJI7SqqIRxII5RsWJiaMHtpOQiXRgJqkKnIGfDsRLxOvV4
	 DDzdf9ChI8JtnVn7ybyeAOyczv00ys8x4yrZWbz/m6MPm02wLkRw4p19aMBNVfFmhig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e+EPwlmgkesww9sEKkn2udezWle/FKsMkYf8ceSnpGw=;
	b=VQH1ou8CnnLUA3leWMd1cHe6SLXk4pok2JymD6YdysU8UyVc4nBQzxiJG4+c5xMGgi71
	 3xWyVBg23YyRAKd5Z6C1qkuN+dwzQvXC437Fx8m21JfJipkzT/Ce8Of8++nO8L6phUvzC
	 301se0HVtGIJDANvWoCHLDRphOPa40HPSGdeqtW5nvWMzQP4WKqXrKiLo88EIyPM3RkpY
	 /vls5S2o1IoiuK+VZcuX/PlQ74y2/tUqbqDU7aZj5uCLg0bsSRJrveodi8FQ7a4U5dGb4
	 NXpdkJVBAg59AKV3aOY+PQqXlTd1M4vP2MLYyhnqejTLaIGHWsPDxfP63PCGkC8y9bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tlBEjEv5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B48606A320;
	Wed, 18 Nov 2026 21:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tlBEjEv5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4281F000C4;
	Wed, 18 Nov 2026 21:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038210;
	bh=e+EPwlmgkesww9sEKkn2udezWle/FKsMkYf8ceSnpGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tlBEjEv5d+6q/Zhp/H7DK7q3W58REVPkmDeyV9zuQ2r0FW/8+U3UoU2uoBT3CraYJ
	 4f9f4Unm1INyM/BDnQVqsn2dleiiEP4VIwCZBmb09H9EkaQdF7yUClQfHcUEj9xskf
	 oPRAz+siqeqO56nhj9FD5nf684Rhl+LibfeqmQd8=
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
Subject: [PATCH 6.6 1665/3318] mm/page_vma_mapped: continue past nonmatching huge PMDs
Date: Wed, 18 Nov 2026 15:38:07 +0100
Message-ID: <20261118150411.732674905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted PMD checks to the existing swap-entry-based migration handling ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_vma_mapped.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index c7e8ccd1aa06f..70769e270c04d 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -254,18 +254,18 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 
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
@@ -284,8 +284,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 
 				spin_unlock(ptl);
 			}
-			step_forward(pvmw, PMD_SIZE);
-			continue;
+			goto next_pmd;
 		}
 		if (!map_pte(pvmw, &ptl)) {
 			if (!pvmw->pte)
@@ -318,6 +317,17 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
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



