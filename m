Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1F0335BA3;
	Mon, 18 Aug 2025 13:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524783; cv=none; b=GXOTk46n4wr1MK5m0zKbEqLy4YlbEYAEpCDtrkbThLTUTSklJskdlXOfKB34Syn3F/vURpaRP5TlVClYu0YQiGIffow2tjRU9rNWStxplCmoNwz2DlSqrfpWPwD0K4eXYx12NvZtV6s0A/xKsSbqm0NCH4DHPw6PM3AFe25OGA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524783; c=relaxed/simple;
	bh=3QwDQPp6nFDFoQDgKeay8LwwUeoxnSenNiYaQLp/HZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZWz7FiWvvUBtFeMxzVRrpLWLdqhRfqgqaKpVAG2rhbuNJyagylA2cQiR2f4qqEYHaVLWEQ8/g0nqgITxxORA/0SuIOaKfgQx6aKSskouN6478lxX9+Jm9HReMU5goCq1VRokIuvWaiqAYdxSD295yzn+QtAAEXWDgh9SuNvFIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KOTEE0x+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KOTEE0x+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0531C4CEEB;
	Mon, 18 Aug 2025 13:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524783;
	bh=3QwDQPp6nFDFoQDgKeay8LwwUeoxnSenNiYaQLp/HZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOTEE0x+dbQj+AMaK7t16pR3RwM/HsarwiVo+XYYnwReZgJuIS/YbPmHtGKbAsdXB
	 zlcHkdol5u8D4q33AGXrKgGrqrnOK8UD3sjMkAxxNFsJwxvankm7pVyzJl4qEv8Hpu
	 qL/UDcfU4jyKcr+c+PlQSirui1gOCO9g1LZyTqsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjiang Tu <tujinjiang@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	Andrei Vagin <avagin@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Brahmajit Das <brahmajit.xyz@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	David Rientjes <rientjes@google.com>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Joern Engel <joern@logfs.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thiago Jung Bauermann <thiago.bauermann@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 060/570] mm/smaps: fix race between smaps_hugetlb_range and migration
Date: Mon, 18 Aug 2025 14:40:47 +0200
Message-ID: <20250818124508.132494514@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjiang Tu <tujinjiang@huawei.com>

[ Upstream commit 45d19b4b6c2d422771c29b83462d84afcbb33f01 ]

smaps_hugetlb_range() handles the pte without holdling ptl, and may be
concurrenct with migration, leaing to BUG_ON in pfn_swap_entry_to_page().
The race is as follows.

smaps_hugetlb_range              migrate_pages
  huge_ptep_get
                                   remove_migration_ptes
				   folio_unlock
  pfn_swap_entry_folio
    BUG_ON

To fix it, hold ptl lock in smaps_hugetlb_range().

Link: https://lkml.kernel.org/r/20250724090958.455887-1-tujinjiang@huawei.com
Link: https://lkml.kernel.org/r/20250724090958.455887-2-tujinjiang@huawei.com
Fixes: 25ee01a2fca0 ("mm: hugetlb: proc: add hugetlb-related fields to /proc/PID/smaps")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brahmajit Das <brahmajit.xyz@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joern Engel <joern@logfs.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/task_mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 751479eb128f..0102ab3aaec1 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1020,10 +1020,13 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = walk->vma;
-	pte_t ptent = huge_ptep_get(walk->mm, addr, pte);
 	struct folio *folio = NULL;
 	bool present = false;
+	spinlock_t *ptl;
+	pte_t ptent;
 
+	ptl = huge_pte_lock(hstate_vma(vma), walk->mm, pte);
+	ptent = huge_ptep_get(walk->mm, addr, pte);
 	if (pte_present(ptent)) {
 		folio = page_folio(pte_page(ptent));
 		present = true;
@@ -1042,6 +1045,7 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
 		else
 			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
 	}
+	spin_unlock(ptl);
 	return 0;
 }
 #else
-- 
2.50.1



