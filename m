Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E7226F440;
	Tue, 25 Mar 2025 12:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906360; cv=none; b=TRePMxnUoggJx4i5ThkMGxGdZzidpGNkCjo5qH9dDGbcFFOsRbkpKiGM6vkGMok3mLjkFqwOq4OHe9Uwm547YCqNdeRh+6WNC/vG6bu9Jyf3fCjnOR70SF15Fsi93DqImV4uu8XD+aYMG3KTlRQvehTT0LQ1fRo5nV1wOVv8aus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906360; c=relaxed/simple;
	bh=EOIluI+kny8fB5FWGurRevjygR9iiBLGtbHuxvyPhUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3vy7NXUdSo5bjtmu45HRVrnLLm+91fC0Y3yRK4Lk587GDGlckrnk7n2h7OmWkfjpruEAmqn+1GrU0iZGhAp3lO4MByRwWxthDrnE6qa82W+nVPX2H90Jb4E7Zv6/Fe6emRrL4p+/koA6G/J8rk7GAV74DwTEUejY9WVUgrSGeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J3IGNcJx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3IGNcJx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE43FC4CEE4;
	Tue, 25 Mar 2025 12:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906360;
	bh=EOIluI+kny8fB5FWGurRevjygR9iiBLGtbHuxvyPhUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3IGNcJxyf+yfh/xsnvVI9f3Spa2LipdcM5zyZBnxhMXMg9OYmbKFqNbGzGy98F5a
	 O7m7bskhWcQD5PbRhFLS55WW67kImL0baUhP97BPFOZnZ/bU4VYQiGQyBBPN69MeiR
	 PdylnYoTvFOLm+yH06ULH38mIgURYZFWtKzzoKPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	Liu Shixin <liushixin2@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	David Hildenbrand <david@redhat.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Lance Yang <ioworker0@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 076/116] mm/migrate: fix shmem xarray update during migration
Date: Tue, 25 Mar 2025 08:22:43 -0400
Message-ID: <20250325122151.151590770@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

From: Zi Yan <ziy@nvidia.com>

commit 60cf233b585cdf1f3c5e52d1225606b86acd08b0 upstream.

A shmem folio can be either in page cache or in swap cache, but not at the
same time.  Namely, once it is in swap cache, folio->mapping should be
NULL, and the folio is no longer in a shmem mapping.

In __folio_migrate_mapping(), to determine the number of xarray entries to
update, folio_test_swapbacked() is used, but that conflates shmem in page
cache case and shmem in swap cache case.  It leads to xarray multi-index
entry corruption, since it turns a sibling entry to a normal entry during
xas_store() (see [1] for a userspace reproduction).  Fix it by only using
folio_test_swapcache() to determine whether xarray is storing swap cache
entries or not to choose the right number of xarray entries to update.

[1] https://lore.kernel.org/linux-mm/Z8idPCkaJW1IChjT@casper.infradead.org/

Note:
In __split_huge_page(), folio_test_anon() && folio_test_swapcache() is
used to get swap_cache address space, but that ignores the shmem folio in
swap cache case.  It could lead to NULL pointer dereferencing when a
in-swap-cache shmem folio is split at __xa_store(), since
!folio_test_anon() is true and folio->mapping is NULL.  But fortunately,
its caller split_huge_page_to_list_to_order() bails out early with EBUSY
when folio->mapping is NULL.  So no need to take care of it here.

Link: https://lkml.kernel.org/r/20250305200403.2822855-1-ziy@nvidia.com
Fixes: fc346d0a70a1 ("mm: migrate high-order folios in swap cache correctly")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Liu Shixin <liushixin2@huawei.com>
Closes: https://lore.kernel.org/all/28546fb4-5210-bf75-16d6-43e1f8646080@huawei.com/
Suggested-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -526,15 +526,13 @@ static int __folio_migrate_mapping(struc
 	if (folio_test_anon(folio) && folio_test_large(folio))
 		mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
 	folio_ref_add(newfolio, nr); /* add cache reference */
-	if (folio_test_swapbacked(folio)) {
+	if (folio_test_swapbacked(folio))
 		__folio_set_swapbacked(newfolio);
-		if (folio_test_swapcache(folio)) {
-			folio_set_swapcache(newfolio);
-			newfolio->private = folio_get_private(folio);
-		}
+	if (folio_test_swapcache(folio)) {
+		folio_set_swapcache(newfolio);
+		newfolio->private = folio_get_private(folio);
 		entries = nr;
 	} else {
-		VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
 		entries = 1;
 	}
 


