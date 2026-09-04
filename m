Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4351415B85;
	Fri,  4 Sep 2026 05:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498440; cv=none; b=Ox9664KQsHQ66wTBTPZZxDa3/K3iyO/3fHk+WuHtgCnEBKYTKqGeKmOGPZQJyCa+aOWTP3Vt/PD8ZJuUhotXbLwAPdh8UYCbrS2ZO1cLlU4kppBMsTnnooPlKw2LhGK8ZxOwunaMosFC7RpVs6NXj09OWUKZ5ExKy1Bxpp9rab0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498440; c=relaxed/simple;
	bh=auh5VcJthaaAG1ohlXZ1YfBht89Q6VkXAYno8gbrsy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqUOIyK2YiU2tRmoJU49y+4RD0ZkOznRztg7bBl74eQTtERJTeovfFM3EQKOyrlSSNBGjA94wyZrMeVlY5XgN87wLvk5Hgr8ODZYXWSFJu3VDLxm60xiBnyF2wPJ+K82uwijaoW7ijcV0tlvTViwSr2lh+jQ31ZTLpAth2JnNGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ScVuyr6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ScVuyr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E10F1F00A3E;
	Fri,  4 Sep 2026 05:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498436;
	bh=fi0HQ7ErhX1IPa9W1Gj1AYMZpdbt8wX2S4MHcSSZdy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ScVuyr6fpwb0PrEP6ShXmjRqqvvU5DmptQmi+jbmZhaYwpDVQxNAmZJVhuVq754e
	 DOxy6gc+Hd8tKQd7IdNmbGxIJreA6TzUbjLhEjmLk0Rdm7GjUPB+gk+3mfwyGb+eZX
	 SCogMewVZNL6/94JRBmUuZJxuFSdtcbU5R3fHxhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dev Jain <dev.jain@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Alistair Popple <apopple@nvidia.com>,
	Andi Kleen <ak@linux.intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Byungchul Park <byungchul@sk.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@intel.com>,
	Gregory Price <gourry@gourry.net>,
	Harry Yoo <harry@kernel.org>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Jann Horn <jannh@google.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	=?UTF-8?q?Junichi=20 Nick =20Nomura?= <j-nomura@ce.jp.nec.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mel@csn.ul.ie>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Pedro Falcato <pfalcato@suse.de>,
	Rakie Kim <rakie.kim@sk.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Rik van Riel <riel@surriel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 062/713] mm/page_vma_mapped: use huge_ptep_get() for hugetlb
Date: Fri,  4 Sep 2026 06:50:30 +0200
Message-ID: <20260904045805.226681332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dev Jain <dev.jain@arm.com>

commit e87df0d5d6962bde50f55f6d02b779daa394f894 upstream.

check_pte() is the final validation step in page_vma_mapped_walk().  It
reads pvmw->pte with ptep_get() to decide whether the entry maps the PFN
range being walked.  For hugetlb VMAs, that pointer refers to a hugetlb
entry.

On arches which provide their own huge_ptep_get() to dereference a huge
pte pointer, accessing via ptep_get() would cause pte_pfn(), pte_present()
etc to misbehave.

It is not clear whether this has a trivially visible effect to userspace.

Use huge_ptep_get() to dereference a huge pte pointer.

Link: https://lore.kernel.org/20260703114202.365553-6-dev.jain@arm.com
Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Jun'ichi "Nick" Nomura <j-nomura@ce.jp.nec.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_vma_mapped.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -107,7 +107,13 @@ again:
 static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
 {
 	unsigned long pfn;
-	pte_t ptent = ptep_get(pvmw->pte);
+	pte_t ptent;
+
+	if (is_vm_hugetlb_page(pvmw->vma))
+		ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
+				      pvmw->pte);
+	else
+		ptent = ptep_get(pvmw->pte);
 
 	if (pvmw->flags & PVMW_MIGRATION) {
 		const softleaf_t entry = softleaf_from_pte(ptent);


