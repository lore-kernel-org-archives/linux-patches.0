Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA453B05AC;
	Fri,  4 Sep 2026 05:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498415; cv=none; b=cq7wRub4ixdyyqGV+2BluQQ69Uaoa4vwdv3ckPf1nuxV0iLy00Q+aVUkUQq4AtNLo/IykL8DALg166ckqcHoHRETH37/pmmOPaNV787EOIcXliOUzMB4o6FqZE+WvqDmrZlQxs12b7C9s07kdNhARjJUUkrxeW72Lq4pRbz2DkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498415; c=relaxed/simple;
	bh=BHj+i2RthNWauN007MkX6Z4bAoyacgFIVLHUlQULYs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOclKmnOfs8qCsiZ+je2VKsbdxdXdPExkmJllZzB3X9IU4UY0LIvGTD9p/vObDCh8AdCKlXfIUrvo97ZmddSedk7hIzISL0OkQAHMI1gl8jv4fwCRSKoCq4/XTtVZGtJw5yZZW6wPyWbCrivJzP03A3rlGLM+uWLAtsuPsZAwzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6lrHSCD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6lrHSCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5541F00A3D;
	Fri,  4 Sep 2026 05:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498414;
	bh=FjBjXu6yDMKjb4hgsnlIBGC7trDSWeVez7DD8mEH+H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g6lrHSCDJuF97RxzUdwmZJDruWIrdLKchd9ZLduU7XmlgQ4L04WSZ6X9oR6q1jiWp
	 OD6u+0L7mOSgltvaRsR9x8zVp6YocyPt+Vx78q5ZvSKJvIrhtpVjbno8jMW38b0gkv
	 WInL82Rm3rMvkOj5U3nV96hf/YQzIWg6nhHssTmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Usama Arif <usama.arif@linux.dev>,
	sashiko-bot <sashiko-bot@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Byungchul Park <byungchul@sk.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Jann Horn <jannh@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Nico Pache <npache@redhat.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 054/713] mm/madvise: skip device-private PMDs in cold and pageout walks
Date: Fri,  4 Sep 2026 06:50:22 +0200
Message-ID: <20260904045805.042904797@linuxfoundation.org>
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

From: Usama Arif <usama.arif@linux.dev>

commit d4b76d0b03cb49611312ecc4bcfb55ccdf0843e2 upstream.

madvise_cold_or_pageout_pte_range() takes pmd_trans_huge_lock(), whose
pmd_is_huge() check returns true for a device-private PMD.  The subsequent
!pmd_present() branch has a VM_BUG_ON() asserting migration is the only
allowed non-present case; a device-private PMD trips it.

Skip device-private PMDs in that non-present branch and continue to
huge_unlock before calling pmd_folio().  Downgrade the check to
VM_WARN_ON_ONCE() so an unexpected PMD softleaf logs a warning rather than
panicking.  Drop the thp_migration_supported() guard: it expands to
IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF), and both
pmd_is_migration_entry() and pmd_is_device_private_entry() already return
false when that config is not selected, so the guard suppresses only the
case where the warning would already be silent.

Potential trigger: an HMM-based GPU driver races with
madvise(MADV_COLD)/MADV_PAGEOUT: pmd_trans_huge(*pmd) reads true, then
migrate_vma_pages() flips the PMD to a device-private entry before the PMD
lock is acquired.

Link: https://lore.kernel.org/20260710105557.1987433-3-usama.arif@linux.dev
Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/madvise.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 917f764fef80..bf9ce199935a 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -388,8 +388,8 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			goto huge_unlock;
 
 		if (unlikely(!pmd_present(orig_pmd))) {
-			VM_BUG_ON(thp_migration_supported() &&
-					!pmd_is_migration_entry(orig_pmd));
+			VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
+					!pmd_is_device_private_entry(orig_pmd));
 			goto huge_unlock;
 		}
 
-- 
2.55.0



