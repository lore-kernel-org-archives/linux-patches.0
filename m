Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6373E311592;
	Tue, 31 Mar 2026 17:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976921; cv=none; b=F9oJQgAGLfrCNNB5gTpc6aeQS+mFGrZZ5Yn+ViQG00a3QXhbUZNX59HBYCKi1tCLl4dl7bMeu3JWhhB6dY9v5Cuq51i+OkHjvcScdPJx1Qr7ISBKyInAAeZ0tRG0qRG2OkU7OiA01sDs40DtxP1PrJZXtmaVCLt8uZ78lW6/kuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976921; c=relaxed/simple;
	bh=JmquOdWSplFXLXkyGGIXQ+rEpRS7EMRvV4GghuBme5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gELvL+fIEX+iLctVH8Kirt85sHVkzJ9NRPuz1prVwgpYeVfyq9eWT5j2Sfn+AA6fGsIZSeefFFImxnQI55KIgSa68uMtIsWK1QjRY2RNg5FMDaKZIhcDy564jggeWarIM4sW0rW/vWTaSM51T+H/nsdf0lVSM/rLmlQyovFHJaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQpMheie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQpMheie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62B4C19424;
	Tue, 31 Mar 2026 17:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976921;
	bh=JmquOdWSplFXLXkyGGIXQ+rEpRS7EMRvV4GghuBme5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQpMheiejOq6VjTU8blHcUiYLfRbR+0QSb7tctN+TrXwuBYb+AMn18DLFvdv0u5ky
	 haOQ3vYXgbWEAMlEpQBZZmHrj/vuLxE80DfDcw1IllRbkcEdhNIREFIfbmUlDQRXbo
	 nBhRyopzb48FZ4SCNGLxKIbxctn884IAJBh8uBoI=
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
Subject: [PATCH 6.18 280/309] mm/huge_memory: fix folio isnt locked in softleaf_to_folio()
Date: Tue, 31 Mar 2026 18:23:03 +0200
Message-ID: <20260331161803.872940900@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ applied fix to swapops.h using old pfn_swap_entry/swp_entry_t naming ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/swapops.h |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -487,15 +487,29 @@ static inline int pte_none_mostly(pte_t
 	return pte_none(pte) || is_pte_marker(pte);
 }
 
-static inline struct page *pfn_swap_entry_to_page(swp_entry_t entry)
+static inline void swap_entry_migration_sync(swp_entry_t entry,
+		struct folio *folio)
 {
-	struct page *p = pfn_to_page(swp_offset_pfn(entry));
+	/*
+	 * Ensure we do not race with split, which might alter tail pages into new
+	 * folios and thus result in observing an unlocked folio.
+	 * This matches the write barrier in __split_folio_to_order().
+	 */
+	smp_rmb();
 
 	/*
 	 * Any use of migration entries may only occur while the
 	 * corresponding page is locked
 	 */
-	BUG_ON(is_migration_entry(entry) && !PageLocked(p));
+	BUG_ON(!folio_test_locked(folio));
+}
+
+static inline struct page *pfn_swap_entry_to_page(swp_entry_t entry)
+{
+	struct page *p = pfn_to_page(swp_offset_pfn(entry));
+
+	if (is_migration_entry(entry))
+		swap_entry_migration_sync(entry, page_folio(p));
 
 	return p;
 }
@@ -504,11 +518,8 @@ static inline struct folio *pfn_swap_ent
 {
 	struct folio *folio = pfn_folio(swp_offset_pfn(entry));
 
-	/*
-	 * Any use of migration entries may only occur while the
-	 * corresponding folio is locked
-	 */
-	BUG_ON(is_migration_entry(entry) && !folio_test_locked(folio));
+	if (is_migration_entry(entry))
+		swap_entry_migration_sync(entry, folio);
 
 	return folio;
 }


