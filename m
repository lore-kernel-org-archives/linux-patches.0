Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3C4320392;
	Mon, 18 Aug 2025 12:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521544; cv=none; b=BXx62hGREhhlkJfM+sN088SKxArMUDCZ4rJ8rZ4kZyPhyEnCrF8QQBu5MNTHOTmL1OOADFOoBo94zq31+qVvT8lIxl+O9+PGdEWEkAvc68ujwi2JYUEWC1+ghZQYaqnFWby7X+oLurByftCUtQISaVfqZxfzOF6h8KHnrIp6JNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521544; c=relaxed/simple;
	bh=Qy5DktpLrhEMDS94UwQxvx6mCVxWiin/mTq53LaLVRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3wUxnUC/sGoptzDFmZ/MmWmSm6gEte8vwkkK872hJSRS/lnV6vMQpTMjiAefIEDjzYP4XAT+TC38DfUwBFh5x64APrTzyt+KA41eqPw+tp5gPngph2ADkGKMKlMdkmJ68zqw2UIUx8OkZSVjdJmI8mh703nDJ10UBmFr6oF/JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDVjyFd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDVjyFd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA25DC4CEF1;
	Mon, 18 Aug 2025 12:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521544;
	bh=Qy5DktpLrhEMDS94UwQxvx6mCVxWiin/mTq53LaLVRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDVjyFd7EhYmMSat20q7KWU7fPLPkWZc6P1+p9OyFFtfx7dskYCFyQTCvkuyr/lu3
	 gddsMz2ZfBIlNJ4bRUjnMLLUCM+/XPc6AJSmzw48DuEIHRRhhqT+s+bRag3/MFv2KV
	 l1ahYtLw1fwxV0lrcgEFXKI/sMY2hsS0RZfOPEoc=
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
Subject: [PATCH 6.12 053/444] mm/smaps: fix race between smaps_hugetlb_range and migration
Date: Mon, 18 Aug 2025 14:41:19 +0200
Message-ID: <20250818124450.917571064@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 72a58681f031..2257bf52fb2a 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1007,10 +1007,13 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
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
@@ -1029,6 +1032,7 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
 		else
 			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
 	}
+	spin_unlock(ptl);
 	return 0;
 }
 #else
-- 
2.50.1



