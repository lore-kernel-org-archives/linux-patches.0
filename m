Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B6D442C;
	Wed, 30 Jul 2025 09:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869264; cv=none; b=TOgufjLsvauH0f1HZFprWe6FNXI8GflM8lW1XiJHA0AnVqGj3YJdKHzGaaLO3y3KEBggnDswec3g89xTqAyl6qHp/ZyZj7ipoXM5TT7V4iBUoSbiCtri/SZzY05WRp+qbqUaLm4OrC+3ZywPab0c+GpomsYZYbSM9Qh2dJIb2jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869264; c=relaxed/simple;
	bh=5/j08/R9ToaZftSESL5A3QIT/pX+ePFfm4w7WMXQaFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpPoml0O6ZlFSe11mNzzkd8ZZI2YFk21UrE4p/vSpmnGCVjIdg/cD7CI8AHI/m8i2kTgvI3l7FQekwOhV85l/TL43Ycbu1m5JWMi0rDLKRHCcKNa7Ov+MUClpFVFg1TaXD+BgVRxExa8TOT2hUqmbAwp9uTaEymPfglncVhUPG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KzR3K6tj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KzR3K6tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FDBC4CEF5;
	Wed, 30 Jul 2025 09:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869264;
	bh=5/j08/R9ToaZftSESL5A3QIT/pX+ePFfm4w7WMXQaFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KzR3K6tjIzBR8jG5/C622EQFxZUh8mYbf0IeeNg/mOlcnRsjkquCtpv62zj/jy0C5
	 7aSMf+LzK/yR2WDMhZYVvgFszdpU8wGlagoB7kdCSNInZX9+Osne0QpcBzGF8LmUTF
	 rUQfMVNue2o2rnY7mGD1X+S+t43BSv5CNeWV44dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjiang Tu <tujinjiang@huawei.com>,
	syzbot+3b220254df55d8ca8a61@syzkaller.appspotmail.com,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 78/92] mm/vmscan: fix hwpoisoned large folio handling in shrink_folio_list
Date: Wed, 30 Jul 2025 11:36:26 +0200
Message-ID: <20250730093233.774349408@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

From: Jinjiang Tu <tujinjiang@huawei.com>

commit 9f1e8cd0b7c4c944e9921b52a6661b5eda2705ab upstream.

In shrink_folio_list(), the hwpoisoned folio may be large folio, which
can't be handled by unmap_poisoned_folio().  For THP, try_to_unmap_one()
must be passed with TTU_SPLIT_HUGE_PMD to split huge PMD first and then
retry.  Without TTU_SPLIT_HUGE_PMD, we will trigger null-ptr deref of
pvmw.pte.  Even we passed TTU_SPLIT_HUGE_PMD, we will trigger a
WARN_ON_ONCE due to the page isn't in swapcache.

Since UCE is rare in real world, and race with reclaimation is more rare,
just skipping the hwpoisoned large folio is enough.  memory_failure() will
handle it if the UCE is triggered again.

This happens when memory reclaim for large folio races with
memory_failure(), and will lead to kernel panic.  The race is as
follows:

cpu0      cpu1
 shrink_folio_list memory_failure
  TestSetPageHWPoison
  unmap_poisoned_folio
  --> trigger BUG_ON due to
  unmap_poisoned_folio couldn't
   handle large folio

[tujinjiang@huawei.com: add comment to unmap_poisoned_folio()]
  Link: https://lkml.kernel.org/r/69fd4e00-1b13-d5f7-1c82-705c7d977ea4@huawei.com
Link: https://lkml.kernel.org/r/20250627125747.3094074-2-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Fixes: 1b0449544c64 ("mm/vmscan: don't try to reclaim hwpoison folio")
Reported-by: syzbot+3b220254df55d8ca8a61@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68412d57.050a0220.2461cf.000e.GAE@google.com/
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |    4 ++++
 mm/vmscan.c         |    8 ++++++++
 2 files changed, 12 insertions(+)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1561,6 +1561,10 @@ static int get_hwpoison_page(struct page
 	return ret;
 }
 
+/*
+ * The caller must guarantee the folio isn't large folio, except hugetlb.
+ * try_to_unmap() can't handle it.
+ */
 int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill)
 {
 	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_SYNC | TTU_HWPOISON;
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1128,6 +1128,14 @@ retry:
 			goto keep;
 
 		if (folio_contain_hwpoisoned_page(folio)) {
+			/*
+			 * unmap_poisoned_folio() can't handle large
+			 * folio, just skip it. memory_failure() will
+			 * handle it if the UCE is triggered again.
+			 */
+			if (folio_test_large(folio))
+				goto keep_locked;
+
 			unmap_poisoned_folio(folio, folio_pfn(folio), false);
 			folio_unlock(folio);
 			folio_put(folio);


