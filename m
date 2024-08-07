Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA68B23CE;
	Wed,  7 Aug 2024 15:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042937; cv=none; b=NOuRMMJRS8bqRNhIuA7Z+sIKebJJ/PNaS522kUv8tSJ2NJbCYrdycyPR4nfTbR/d4iHCXlmg5mYyM4TUz08QLkqt0uz6sZibRVcU2f7a4ExasgGzKApJ3T3584mcCKYQWg+PC1xI6LDmOaadHwT838pnXfsbDAPQIR4uoVbzmSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042937; c=relaxed/simple;
	bh=xPRCY2YIc89lzf6sYLr6DWAVes5Bmg7F39U6/VqGtUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T479j92vOjJpY385JwYFV4FYsCmWZmpP3MX07OZFQpWNvp6dd9QMUI/4sWPFVqEhC+THWkWqR1+DBKMu4P3IshvFaFrJtsy/KADVk0z+lvk+NjqiUQBsGgEiLpLBesfc1Czh6HacOtydDV7xSCyqq0a37XGuILYAKhQS05mLWS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3CWvb0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3CWvb0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395F5C32781;
	Wed,  7 Aug 2024 15:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042937;
	bh=xPRCY2YIc89lzf6sYLr6DWAVes5Bmg7F39U6/VqGtUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3CWvb0frIie247QX3Vp+NzZznncEJCLYjYdw4+Eog6JP4WqiuIEvm7e1zwhThoXa
	 qXZyeo60uH1A69Jcg+O3j6zAVjiaFa/XNKYNomGDH407+rfDiw02c5va44eyLDJTyN
	 teu5m1k+wM4zDIXCZxdfnXH9AwJ2A+ZiFNBeTAmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 003/123] mm/migrate: make migrate_misplaced_folio() return 0 on success
Date: Wed,  7 Aug 2024 16:58:42 +0200
Message-ID: <20240807150020.908601126@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 4b88c23ab8c9bc3857f7c8847e2c6bed95185530 ]

Patch series "mm/migrate: move NUMA hinting fault folio isolation + checks
under PTL".

Let's just return 0 on success, which is less confusing.

...  especially because we got it wrong in the migrate.h stub where we
have "return -EAGAIN; /* can't migrate now */" instead of "return 0;".
Likely this wrong return value doesn't currently matter, but it certainly
adds confusion.

We'll add migrate_misplaced_folio_prepare() next, where we want to use the
same "return 0 on success" approach, so let's just clean this up.

Link: https://lkml.kernel.org/r/20240620212935.656243-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240620212935.656243-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 6e49019db5f7 ("mm/migrate: putback split folios when numa hint migration fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 5 ++---
 mm/memory.c      | 2 +-
 mm/migrate.c     | 4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e234954cf5067..5ca9d45e6742c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1666,7 +1666,7 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	int nid = NUMA_NO_NODE;
 	int target_nid, last_cpupid = (-1 & LAST_CPUPID_MASK);
-	bool migrated = false, writable = false;
+	bool writable = false;
 	int flags = 0;
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
@@ -1710,8 +1710,7 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 	spin_unlock(vmf->ptl);
 	writable = false;
 
-	migrated = migrate_misplaced_folio(folio, vma, target_nid);
-	if (migrated) {
+	if (!migrate_misplaced_folio(folio, vma, target_nid)) {
 		flags |= TNF_MIGRATED;
 		nid = target_nid;
 	} else {
diff --git a/mm/memory.c b/mm/memory.c
index f81760c93801f..b1e77b9d17e75 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5214,7 +5214,7 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 	ignore_writable = true;
 
 	/* Migrate to the requested node */
-	if (migrate_misplaced_folio(folio, vma, target_nid)) {
+	if (!migrate_misplaced_folio(folio, vma, target_nid)) {
 		nid = target_nid;
 		flags |= TNF_MIGRATED;
 	} else {
diff --git a/mm/migrate.c b/mm/migrate.c
index a8c6f466e33ac..83e0e1aa21c7e 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2656,11 +2656,11 @@ int migrate_misplaced_folio(struct folio *folio, struct vm_area_struct *vma,
 					    nr_succeeded);
 	}
 	BUG_ON(!list_empty(&migratepages));
-	return isolated;
+	return isolated ? 0 : -EAGAIN;
 
 out:
 	folio_put(folio);
-	return 0;
+	return -EAGAIN;
 }
 #endif /* CONFIG_NUMA_BALANCING */
 #endif /* CONFIG_NUMA */
-- 
2.43.0



