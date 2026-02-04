Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512732BD012;
	Wed,  4 Feb 2026 15:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217336; cv=none; b=cT0yh52ZrZwF4kgWBiWLWY+HceI1ErHsxBWHmCIZHOoIRvC7HevQ/sfO5P3pArtbnIAQjTbK8b1sFnaaa2cF0rnkziacaICfSxhXTOCTWVZWJVrlsbQ2AX5dYGaykekWBPB32+QHmKaqwEs3IjoXMAfZ3zuShPbe/PL+lxtYfCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217336; c=relaxed/simple;
	bh=/mhnN1FHMGIZRe3LHdSZjdy4a0BPNcBpgsVED7VeF9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAPouXzqNPH/wvroexlDtKyhR1e7Egt5gveZp9iwVS0hC0zyr3AzngxE4wC8TvOnSlOsFls88kLaKPA1qSkjj1R4GWq9ZSkl1emitPz6ko3wm3/gb574bse5fHEe/jn4KGQwnMxYZDmxjV0m0ZHke2o3XGJNbZgVcX2pwKr3Tug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlCkZNd3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlCkZNd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7376C4CEF7;
	Wed,  4 Feb 2026 15:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217336;
	bh=/mhnN1FHMGIZRe3LHdSZjdy4a0BPNcBpgsVED7VeF9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlCkZNd3NNrD6+tUbYSFN/EmTklVb0lJIknJF5Vv/dhvdS6bwu8sNYxYk3KyAmJPe
	 nlh6vHyzUmUo0nKmng8asrKP6xaU5j0V2ZFozPT5VnmBItcUIz5mMu3UdcSz2gs00Y
	 TNB7wuoUuuXbjFsv/VnJWwsKHW0MnddtLJeBBBxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	JP Kobryn <inwardvessel@gmail.com>
Subject: [PATCH 5.15 193/206] btrfs: prevent use-after-free on page private data in btrfs_subpage_clear_uptodate()
Date: Wed,  4 Feb 2026 15:40:24 +0100
Message-ID: <20260204143905.174602644@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2900,6 +2900,19 @@ static noinline_for_stack int prealloc_f
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


