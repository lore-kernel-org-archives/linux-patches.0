Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95A82BEFED;
	Wed,  4 Feb 2026 15:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218838; cv=none; b=WpyymfAx8xUPNd7jgxfWkqTj58estF8i1Dm5QkyrlSOLKxeGUn3IeW+ofvvM1CE2eBp7hvtJ0Dc/WlGi48+CJZzVPjMZg+RrFeGggHZYfoJERPzZEaRgQ1WdvqWleps7KZAxaV7m+MQbPUwubxaNsweOOcKBuS0DlXh+iIFn6Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218838; c=relaxed/simple;
	bh=eknv+vQq88jTNr51PLkApTP7lOz/OiLSwmJ5VIOl7gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQR5V7nDAcvDdGdT/AfIYiI/h1k6p9ZoMNdjelZLr+UeVwwzgJtpnsKHB8EAB1e70vX7AhDC1u4lt1hspdJkfB8QGXF9xt5MTiAaMRxH8FbhhEAnWSRRWeaG4JMDbsl+bEGxn7+CZNuStJ84xxN3rHF2Z7rnlwNn5UQSLbjErks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9Y6XT7h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9Y6XT7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC13C4CEF7;
	Wed,  4 Feb 2026 15:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218838;
	bh=eknv+vQq88jTNr51PLkApTP7lOz/OiLSwmJ5VIOl7gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s9Y6XT7hWYOWjfE/x9+ONAqxZayQOnaUfCrKvXd3YOT4qT8giCSvDKAe+HTeALFtf
	 x8hedGnYKp/h7AA8fXYJEc95GfKY+cJkbXmknrARSLR6LrdmLChSLlgI2U2CkiI/OH
	 CD26tNYlfMQGCZ0UGNGXskAT1wvcuSWzvWZPE968=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	JP Kobryn <inwardvessel@gmail.com>,
	Qu Wenruo <wqu@suse.com>
Subject: [PATCH 6.12 76/87] btrfs: prevent use-after-free on folio private data in btrfs_subpage_clear_uptodate()
Date: Wed,  4 Feb 2026 15:41:14 +0100
Message-ID: <20260204143849.655692755@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: JP Kobryn <inwardvessel@gmail.com>

This is a stable-only patch. The issue was inadvertently fixed in 6.17 [0]
as part of a refactoring, but this patch serves as a minimal targeted fix
for prior kernels.

Users of filemap_lock_folio() need to guard against the situation where
release_folio() has been invoked during reclaim but the folio was
ultimately not removed from the page cache. This patch covers one location
that was overlooked.

After acquiring the folio, use set_folio_extent_mapped() to ensure the
folio private state is valid. This is especially important in the subpage
case, where the private field is an allocated struct containing bitmap and
lock data.

Without this protection, the race below is possible:

[mm] page cache reclaim path        [fs] relocation in subpage mode
shrink_folio_list()
  folio_trylock() /* lock acquired */
  filemap_release_folio()
    mapping->a_ops->release_folio()
      btrfs_release_folio()
        __btrfs_release_folio()
          clear_folio_extent_mapped()
            btrfs_detach_subpage()
              subpage = folio_detach_private(folio)
              btrfs_free_subpage(subpage)
                kfree(subpage) /* point A */

                                   prealloc_file_extent_cluster()
                                     filemap_lock_folio()
                                       folio_try_get() /* inc refcount */
                                       folio_lock() /* wait for lock */

  if (...)
    ...
  else if (!mapping || !__remove_mapping(..))
    /*
     * __remove_mapping() returns zero when
     * folio_ref_freeze(folio, refcount) fails /* point B */
     */
    goto keep_locked /* folio remains in cache */

keep_locked:
  folio_unlock(folio) /* lock released */

                                   /* lock acquired */
                                   btrfs_subpage_clear_uptodate()
                                     /* use-after-free */
                                     subpage = folio_get_private(folio)

[0] 4e346baee95f ("btrfs: reloc: unconditionally invalidate the page cache for each cluster")

Fixes: 9d9ea1e68a05 ("btrfs: subpage: fix relocation potentially overwriting last page data")
Cc: stable@vger.kernel.org # 6.10-6.16
Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/relocation.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2811,6 +2811,20 @@ static noinline_for_stack int prealloc_f
 		 * will re-read the whole page anyway.
 		 */
 		if (!IS_ERR(folio)) {
+			/*
+			 * release_folio() could have cleared the folio private data
+			 * while we were not holding the lock. Reset the mapping if
+			 * needed so subpage operations can access a valid private
+			 * folio state.
+			 */
+			ret = set_folio_extent_mapped(folio);
+			if (ret) {
+				folio_unlock(folio);
+				folio_put(folio);
+
+				return ret;
+			}
+
 			btrfs_subpage_clear_uptodate(fs_info, folio, i_size,
 					round_up(i_size, PAGE_SIZE) - i_size);
 			folio_unlock(folio);


