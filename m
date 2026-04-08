Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A857EB67E;
	Wed,  8 Apr 2026 18:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672330; cv=none; b=qbocj5uCikFsuUQ8UC3EbEoS/XZm6Td4jhuXRYZjBQaYQj14UQkn02HxOb3KUC/t68kcVzHqL+TlLg/T9WqoXnUqzAaD+a2nssn4C5XiHIAZccQc7K7Wq+CzfEizzfjVpfBuiffPSDjPHmX44Od37Sz1fK5LGzu4DXWONluKCRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672330; c=relaxed/simple;
	bh=j9+fyB1YjuTQoKQyHhYNDxgZQTlIzEJq0spo3jfHBWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qogrnVeOkdM+m5sVtySTWcdykSh+AGrvhOPCJmlyA883i9y0gMz5u58EZ8u6NtI3u5RH1NSHK5qPJT+RUp6fFvpB/weH9JTJNLAouZm7CDdvw+RE6i1nRg/OFhfiH/0EHwKw5e0O9wKqAGXoQJB8S/6LpY+mkutm/yi8Oifv46c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZyUQdQqq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZyUQdQqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1414BC19421;
	Wed,  8 Apr 2026 18:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672330;
	bh=j9+fyB1YjuTQoKQyHhYNDxgZQTlIzEJq0spo3jfHBWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyUQdQqqrMocFxIQ2hvlx14wupFe2atpCaiGrgqUYp0TaIqzpH4S8cymNHwXlCD0f
	 tNiov5jYAddRzb7ydq8NoDkoUvhbv8KrmQuFpJyjCO2+hqAl78rhKp2Lbayu5NWmFm
	 DZPmTjocmx0MF9Nb0NTldz9/21gV0caAm2c4SsRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjiang Tu <tujinjiang@huawei.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nanyong Sun <sunnanyong@huawei.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 279/312] mm/huge_memory: fix folio isnt locked in softleaf_to_folio()
Date: Wed,  8 Apr 2026 20:03:16 +0200
Message-ID: <20260408175944.172068265@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjiang Tu <tujinjiang@huawei.com>

[ Upstream commit 4c5e7f0fcd592801c9cc18f29f80fbee84eb8669 ]

On arm64 server, we found folio that get from migration entry isn't locked
in softleaf_to_folio().  This issue triggers when mTHP splitting and
zap_nonpresent_ptes() races, and the root cause is lack of memory barrier
in softleaf_to_folio().  The race is as follows:

	CPU0                                             CPU1

deferred_split_scan()                              zap_nonpresent_ptes()
  lock folio
  split_folio()
    unmap_folio()
      change ptes to migration entries
    __split_folio_to_order()                         softleaf_to_folio()
      set flags(including PG_locked) for tail pages    folio = pfn_folio(softleaf_to_pfn(entry))
      smp_wmb()                                        VM_WARN_ON_ONCE(!folio_test_locked(folio))
      prep_compound_page() for tail pages

In __split_folio_to_order(), smp_wmb() guarantees page flags of tail pages
are visible before the tail page becomes non-compound.  smp_wmb() should
be paired with smp_rmb() in softleaf_to_folio(), which is missed.  As a
result, if zap_nonpresent_ptes() accesses migration entry that stores tail
pfn, softleaf_to_folio() may see the updated compound_head of tail page
before page->flags.

This issue will trigger VM_WARN_ON_ONCE() in pfn_swap_entry_folio()
because of the race between folio split and zap_nonpresent_ptes()
leading to a folio incorrectly undergoing modification without a folio
lock being held.

This is a BUG_ON() before commit 93976a20345b ("mm: eliminate further
swapops predicates"), which in merged in v6.19-rc1.

To fix it, add missing smp_rmb() if the softleaf entry is migration entry
in softleaf_to_folio() and softleaf_to_page().

[tujinjiang@huawei.com: update function name and comments]
  Link: https://lkml.kernel.org/r/20260321075214.3305564-1-tujinjiang@huawei.com
Link: https://lkml.kernel.org/r/20260319012541.4158561-1-tujinjiang@huawei.com
Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ adapted fix from leafops.h softleaf_to_page()/softleaf_to_folio() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/swapops.h |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -541,11 +541,21 @@ static inline struct page *pfn_swap_entr
 {
 	struct page *p = pfn_to_page(swp_offset_pfn(entry));
 
-	/*
-	 * Any use of migration entries may only occur while the
-	 * corresponding page is locked
-	 */
-	BUG_ON(is_migration_entry(entry) && !PageLocked(p));
+	if (is_migration_entry(entry)) {
+		/*
+		 * Ensure we do not race with split, which might alter tail
+		 * pages into new folios and thus result in observing an
+		 * unlocked folio.
+		 * This matches the write barrier in __split_folio_to_order().
+		 */
+		smp_rmb();
+
+		/*
+		 * Any use of migration entries may only occur while the
+		 * corresponding page is locked
+		 */
+		BUG_ON(!PageLocked(p));
+	}
 
 	return p;
 }


