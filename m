Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7303F4418DF;
	Tue, 16 Jun 2026 15:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623807; cv=none; b=oa3ui0GQ8LOuvtwwGijnaflhiJOOMcypaq+SfkA7uChKswy3LJzqkh5uq8+BkrLUsC/S0XknP4zNFgQvQ5wKmbVIoVctYVukQbzZPnKHjn3WBMR/8a3oXyL2HsizEzTouDyg4J4/VMfMdYL0prQsEV45q1sBOJvLW9iTTCXUFCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623807; c=relaxed/simple;
	bh=0YvvWJioPThYDR26nfATSWGQuh2uezj5K21BVMRtGco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaurbhcS5oVPcKgjrcP0hyeb/dcXr76eDi0xD4Wad+fE+wopkBOxKtqh+SF/SAaeo72noZvCPod6jEy6UMRJ1XtMuKnOSyM8zDDkKuR8rLXyIIHPod+lGD3MEYuG1YM7+wqQmDJ3CBqWnVPnkjTtvQmeZFF+wcfI/1Y+mTOW/zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pmrijibm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pmrijibm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321121F000E9;
	Tue, 16 Jun 2026 15:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623806;
	bh=67kEeF5ZlTK4OhxQDLKB1chRFXRLRLFv5nwPN4s9Xq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pmrijibmLgUV8Lhjxr+MiR9cBhoctVi3s/5TmMrpL6vht4MU52XjeySybucaDOzVy
	 H9OIcY3FWr6w2hSK1+dyH8HRGVELXomrhPxlkASqb/xqiLjM28XSYoUlkNLCR316G1
	 OkUY+neWBtrL8DG5GsvCWKNgkToa8FrqWSucGxIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yin Tirui <yintirui@huawei.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"David Hildenbrand (arm)" <david@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Dev Jain <dev.jain@arm.com>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Chen Jun <chenjun102@huawei.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 220/378] mm/huge_memory: update file PUD counter before folio_put()
Date: Tue, 16 Jun 2026 20:27:31 +0530
Message-ID: <20260616145121.893890619@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yin Tirui <yintirui@huawei.com>

commit 40990c87a26e371594475acdc560c93cfae308a1 upstream.

__split_huge_pud_locked() updates the file/shmem RSS counter after
dropping the PUD mapping's folio reference.  If folio_put() drops the last
reference, mm_counter_file() can later read freed folio state via
folio_test_swapbacked().

Move the counter update before folio_put().

Link: https://lore.kernel.org/20260526101355.1984244-1-yintirui@huawei.com
Fixes: dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
Signed-off-by: Yin Tirui <yintirui@huawei.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chen Jun <chenjun102@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2913,9 +2913,9 @@ static void __split_huge_pud_locked(stru
 	if (!folio_test_referenced(folio) && pud_young(old_pud))
 		folio_set_referenced(folio);
 	folio_remove_rmap_pud(folio, page, vma);
-	folio_put(folio);
 	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
 		-HPAGE_PUD_NR);
+	folio_put(folio);
 }
 
 void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,


