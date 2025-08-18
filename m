Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63910335BA0;
	Mon, 18 Aug 2025 13:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524500; cv=none; b=s2a09oCgqpM0esmUuASB6A/pAw3cTAu1JZ0kvyPoyzTclTjK+Hqa3laRP1mxexcirO2vvjTVAp6uoibQn2/3x54mOI6w3CeJxJnGwdXtgkTBdmj+NXZrnKpFabgaZCj4gNw5PKRipD6gcCe2uSYzE5AQiVU1PnxBiaae4vtS3RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524500; c=relaxed/simple;
	bh=/eSPlJrwaHnUjs4D/EeIAjsurSn80KmJPOBRPG8oHRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2umSwvfWzjWcKtuFdxETuUyh3VVUGNla9C+pCzEPJgHyEQGdV28OgboKpzC3L0990SiNuvoL2YYax7Qjl0EuyPabeRHVKrV0QKxB5/OsA0gA3TFwwDce6y8uLCTd+5QtmCgAhGHdPKR27rCgKaozR3/hDqT2ExTzvQLx2BaSws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+mE40Du; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+mE40Du"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72BFC116B1;
	Mon, 18 Aug 2025 13:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524500;
	bh=/eSPlJrwaHnUjs4D/EeIAjsurSn80KmJPOBRPG8oHRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+mE40DumWNIBSG+AAHmuX3yKgAEYuxmh6kGGS0H38zHpRlSN/GcoRMhAN8ipx2Hy
	 Vtz3XEU6IjiCxKSvDUDCTZ8ai7Rmt9SKhokscy8n/W4MJXP/+goZevUrKajsUHIlRx
	 abi5qRA1a74gD32xQt9u3VFQ7wD28anFXjD+0tmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Mariano Pache <npache@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 491/515] mm/huge_memory: dont ignore queried cachemode in vmf_insert_pfn_pud()
Date: Mon, 18 Aug 2025 14:47:57 +0200
Message-ID: <20250818124517.338155682@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

commit 09fefdca80aebd1023e827cb0ee174983d829d18 upstream.

Patch series "mm/huge_memory: vmf_insert_folio_*() and
vmf_insert_pfn_pud() fixes", v3.

While working on improving vm_normal_page() and friends, I stumbled over
this issues: refcounted "normal" folios must not be marked using
pmd_special() / pud_special().  Otherwise, we're effectively telling the
system that these folios are no "normal", violating the rules we
documented for vm_normal_page().

Fortunately, there are not many pmd_special()/pud_special() users yet.  So
far there doesn't seem to be serious damage.

Tested using the ndctl tests ("ndctl:dax" suite).


This patch (of 3):

We set up the cache mode but ...  don't forward the updated pgprot to
insert_pfn_pud().

Only a problem on x86-64 PAT when mapping PFNs using PUDs that require a
special cachemode.

Fix it by using the proper pgprot where the cachemode was setup.

It is unclear in which configurations we would get the cachemode wrong:
through vfio seems possible.  Getting cachemodes wrong is usually ...
bad.  As the fix is easy, let's backport it to stable.

Identified by code inspection.

Link: https://lkml.kernel.org/r/20250613092702.1943533-1-david@redhat.com
Link: https://lkml.kernel.org/r/20250613092702.1943533-2-david@redhat.com
Fixes: 7b806d229ef1 ("mm: remove vmf_insert_pfn_xxx_prot() for huge page-table entries")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1516,10 +1516,9 @@ static pud_t maybe_pud_mkwrite(pud_t pud
 }
 
 static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
-		pud_t *pud, pfn_t pfn, bool write)
+		pud_t *pud, pfn_t pfn, pgprot_t prot, bool write)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	pgprot_t prot = vma->vm_page_prot;
 	pud_t entry;
 
 	if (!pud_none(*pud)) {
@@ -1581,7 +1580,7 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_
 	track_pfn_insert(vma, &pgprot, pfn);
 
 	ptl = pud_lock(vma->vm_mm, vmf->pud);
-	insert_pfn_pud(vma, addr, vmf->pud, pfn, write);
+	insert_pfn_pud(vma, addr, vmf->pud, pfn, pgprot, write);
 	spin_unlock(ptl);
 
 	return VM_FAULT_NOPAGE;
@@ -1625,7 +1624,7 @@ vm_fault_t vmf_insert_folio_pud(struct v
 		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PUD_NR);
 	}
 	insert_pfn_pud(vma, addr, vmf->pud, pfn_to_pfn_t(folio_pfn(folio)),
-		write);
+		       vma->vm_page_prot, write);
 	spin_unlock(ptl);
 
 	return VM_FAULT_NOPAGE;


