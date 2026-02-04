Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F7621FF4C;
	Wed,  4 Feb 2026 15:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218519; cv=none; b=DBcW2sA2kuRWYFajXQQbues+BNP3qcXIuoYqqb7OH2a3rGXsLhiJzi+CmWJb9K0Cz1oZPIrUIvaze0APw85WvJ1Nj3oA54/ELnI5pSoou6r21ofLwPjjwt8RuFhtoZUgTxEQy1osTRtpTWzGFcYNc0MH3WCYbTPUgrUlU83s59w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218519; c=relaxed/simple;
	bh=PblyKgjD4AZT5z1UCIlZZqcbcKwcdgtGSpz6M6edUDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQcQGzKy0bCh3DJiMItYBu2zp48LW5JKH0RZXDL7Vzx9Qgj6OaVU3ABgIFPmRlNnKDG1PQfIVmxvDBzHjeyPPy6hNb/PS09E7ss6SYSZxXx4CGGcPElks2LPgXtKfBAAR7Nulhbw6stkB34OhSNJAvm+7D1ewHqZYRba20/JtEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pRl3MJa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pRl3MJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE827C4CEF7;
	Wed,  4 Feb 2026 15:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218519;
	bh=PblyKgjD4AZT5z1UCIlZZqcbcKwcdgtGSpz6M6edUDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0pRl3MJa/yZ4ipaIb9gerjRSPukTZjiTz4UKj8DVGjr8U4EF3NkWRGutGWg1Cx/22
	 lbOFHi0mhbGSXAnPCvFvoppNOwOi+/QICEeUHgj+Vd7U/kB9Y1JloSuFb+xfaq3xDV
	 2mJtSuqBlmcSkgiI13qdiAEOm/cJdT/VVcsIK/gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	JP Kobryn <inwardvessel@gmail.com>
Subject: [PATCH 6.6 55/72] btrfs: prevent use-after-free on page private data in btrfs_subpage_clear_uptodate()
Date: Wed,  4 Feb 2026 15:40:58 +0100
Message-ID: <20260204143847.627926052@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

From: JP Kobryn <inwardvessel@gmail.com>

This is a stable-only patch. The issue was inadvertently fixed in 6.17 [0]
as part of a refactoring, but this patch serves as a minimal targeted fix
for prior kernels.

Users of find_lock_page() need to guard against the situation where
releasepage() has been invoked during reclaim but the page was ultimately
not removed from the page cache. This patch covers one location that was
overlooked.

After acquiring the page, use set_page_extent_mapped() to ensure the page
private state is valid. This is especially important in the subpage case,
where the private field is an allocated struct containing bitmap and lock
data.

Without this protection, the race below is possible:

[mm] page cache reclaim path        [fs] relocation in subpage mode
shrink_page_list()
  trylock_page() /* lock acquired */
  try_to_release_page()
    mapping->a_ops->releasepage()
      btrfs_releasepage()
        __btrfs_releasepage()
          clear_page_extent_mapped()
            btrfs_detach_subpage()
              subpage = detach_page_private(page)
              btrfs_free_subpage(subpage)
                kfree(subpage) /* point A */
                                        prealloc_file_extent_cluster()
                                          find_lock_page()
                                            page_cache_get_speculative()
                                            lock_page() /* wait for lock */
  if (...)
    ...
  else if (!mapping || !__remove_mapping(..))
    /*
     * __remove_mapping() returns zero when
     * page_ref_freeze(page, refcount) fails /* point B */
     */
    goto keep_locked /* page remains in cache */
keep_locked:
  unlock_page(page) /* lock released */
                                        /* lock acquired */
                                        btrfs_subpage_clear_uptodate()
                                          /* use-after-free */
                                          subpage = page->private
[0] 4e346baee95f ("btrfs: reloc: unconditionally invalidate the page cache for each cluster")

Fixes: 9d9ea1e68a05 ("btrfs: subpage: fix relocation potentially overwriting last page data")
Cc: stable@vger.kernel.org # 5.15 - 6.9
Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/relocation.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2847,6 +2847,19 @@ static noinline_for_stack int prealloc_f
 		 * will re-read the whole page anyway.
 		 */
 		if (page) {
+			/*
+			 * releasepage() could have cleared the page private data while
+			 * we were not holding the lock. Reset the mapping if needed so
+			 * subpage operations can access a valid private page state.
+			 */
+			ret = set_page_extent_mapped(page);
+			if (ret) {
+				unlock_page(page);
+				put_page(page);
+
+				return ret;
+			}
+
 			btrfs_subpage_clear_uptodate(fs_info, page, i_size,
 					round_up(i_size, PAGE_SIZE) - i_size);
 			unlock_page(page);


