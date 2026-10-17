Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CC622F767;
	Sat, 17 Oct 2026 17:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258107; cv=none; b=jeK3a2VFwuKCc1rLcSGGLpAxu2DDeMXy14GExtuUJPGDgJf2M1khbQ3R0xB2wExPmXPaFAFtTcJBDcV8LYV4CnNFs9FABHp+96hNlGMhYLoQsQ3a3TGvz4kpA7gukGDJh13kJGfoE4/yNgwUbnhm6OB0m9e05bzNqNSR7Q3AOyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258107; c=relaxed/simple;
	bh=oXRN4zif6CRVCfdXyuhUbpH6ZWaDYAdltr5x1NfVEts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uu1SJutFTEkc6zt91I2y2WxjzMN5I3HgZREimPOQ6ijrWHduxMU/eTe55A8y5OfoxrGwT8sw7VRZHHY7CF/i347ElMQVUiItVRjrRwMqGOZEFX4m2M+nGLVOw4wixKyjtpaadi6uBhRz4jAPLQTtFbHr4JvBAYIHRHTD+bbOuyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VrO0X+OK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VrO0X+OK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA961F000C4;
	Sat, 17 Oct 2026 17:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258105;
	bh=bkt7i6Lwe3zsaxd4IySKfgUaMzoHihb1q1UIhJaC8vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VrO0X+OK2RV6QP0ZrKb6QtiRAcTRrw9HhPrhAckaT1wzi8bFYBOVEwFTfeZkwEKzg
	 A4y5Zh1AKMao+Gfroav2O8hSBvufvmITxVmGty06dDD1x78xAN5B+iiWuZ6I7LNfQf
	 PR4MATr7NU2+1iz9awOq7k7a7GCLRAf1swoWNkJE=
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
Subject: [PATCH 6.6 0774/1674] mm/smaps: fix race between smaps_hugetlb_range and migration
Date: Sat, 17 Oct 2026 17:50:46 +0200
Message-ID: <20261017160450.971643828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ac7e356cacebc..5c6214d8e0937 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -724,8 +724,11 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = walk->vma;
 	struct page *page = NULL;
-	pte_t ptent = ptep_get(pte);
+	spinlock_t *ptl;
+	pte_t ptent;
 
+	ptl = huge_pte_lock(hstate_vma(vma), walk->mm, pte);
+	ptent = ptep_get(pte);
 	if (pte_present(ptent)) {
 		page = vm_normal_page(vma, addr, ptent);
 	} else if (is_swap_pte(ptent)) {
@@ -740,6 +743,7 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
 		else
 			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
 	}
+	spin_unlock(ptl);
 	return 0;
 }
 #else
-- 
2.53.0



