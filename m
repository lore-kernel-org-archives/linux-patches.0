Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530FC4218BB;
	Wed,  4 Feb 2026 15:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218343; cv=none; b=D8VUDFb0FrtU1D6DfIWfqDepQwVVrsogR9SPAIgL2esImk66RrV/yoj1ip+2vcGvgAKDeNAgh2S/BgHX1FFCxRgzSzg3l0vhGQ3yz6UxI35Pnc3dNCih8q+PYzLRHi8Gev0I3ywFF5HFq49Fpox1xfEWxgre9b7MslZMde9XalU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218343; c=relaxed/simple;
	bh=7VfOC/LUceFnP+2HhQqxkfn5pTlekKV5EmS4dYznkZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIk2Xdv25i52RmOGJGXUTEtPDioO32v8j2pIqLIwhwquAEI2/L/zgYPuhCfcIM4uc0/T7HWNn/puKQt0vxqYad7TsE75jth96CFkraRZqKhr7N45W/xHS6nbCPCi9D78gpiK+vmpb/Z1Nnjgy7m6jfJbER3o9s2zpc39Fizt9xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DYmV3S7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DYmV3S7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD8EC116C6;
	Wed,  4 Feb 2026 15:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218342;
	bh=7VfOC/LUceFnP+2HhQqxkfn5pTlekKV5EmS4dYznkZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DYmV3S7PDtM/wPVfZMEyhWjYJwc7Or4OKdFC7GdIZTqt3kc3kA9Qml3GFXwDiOsdJ
	 sIw0C/So5D4kTB51qeMEW2CHNx7qWV/90MdUX0J9IhuvC1Eruc8nSq9cZdTCeM+/j2
	 7ZudvOhqpUUrwnuf0NsZdb1zbVihGQp0XInVCD/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	JP Kobryn <inwardvessel@gmail.com>
Subject: [PATCH 6.1 273/280] btrfs: prevent use-after-free on page private data in btrfs_subpage_clear_uptodate()
Date: Wed,  4 Feb 2026 15:40:47 +0100
Message-ID: <20260204143919.527715186@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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
@@ -2897,6 +2897,19 @@ static noinline_for_stack int prealloc_f
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


