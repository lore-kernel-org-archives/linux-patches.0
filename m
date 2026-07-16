Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E298332604;
	Thu, 16 Jul 2026 14:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211573; cv=none; b=VPuKjJsw2Acn/Ezoww0lMn+ErbiC4ZTuALlU0lXO9bY+B0/n+uaMwuGLB8UvHhxs6f0ALqE/5B174TDXn3eaCpk15XmXNnOV1zs84Ddf7tDGX5AxaxkSe1TTB2qG8vTij9Gux/2+CQ6bT8SP27c4sKQo/qgpN0RI0BeE244wYGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211573; c=relaxed/simple;
	bh=BOF9tYsOunSaAFjiRM7BSi7tFpmhxZmJSR6KtwhPIko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1L1kIIOVPJb/Cc2t2f8bd43Yu3Gx6i7/ukj3GuGZG+iH07g+MC6KHHwaNdNHcjsXzv+RgpEAFp9KE0ZN3BSXFAn9fFCYn1xR1WYYAmvbHE2mHgnJGoPNaYmaLv9krGNlgioJeBb/xfgEhFXITYBFtOgZpLgtScq6aossMgkTLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXXHMIQ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXXHMIQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945431F000E9;
	Thu, 16 Jul 2026 14:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211572;
	bh=O//djmFtw5UxeX65rD/sO0MP+Asn+d0RyT+icPPdd4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bXXHMIQ92uObxT6VToF693kfjMnZ23PVUSZXQ2+ol0X0sK1WDa0UZDN/HN4VVVW3H
	 JcJz6dEpEybleM30WSiaeWDuztQWdF4C7yVNk6MQwITp9rBnpyuTpjJ9xXsPElI5wn
	 vhfZexsPEql4kkoibok1mW/V1LH640vh/n0eRrh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 480/480] Revert "f2fs: remove non-uptodate folio from the page cache in move_data_block"
Date: Thu, 16 Jul 2026 15:33:47 +0200
Message-ID: <20260716133055.208060559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

commit ccaba785821970f422c47770331c7e3271763f17 upstream.

This reverts commit 9609dd704725a40cd63d915f2ab6c44248a44598.

The kernel panics are keeping to be reported especially when the f2fs
partition get almost full. By investigation, we find that the reason is
one f2fs page got freed to buddy without being deleted from LRU and the
root cause is the race happened in [2] which is enrolled by this commit.

There are 3 race processes in this scenario, please find below for their
main activities.

The changed code in move_data_block() lets the GC path evict the tail-end
folio from the page cache through folio_end_dropbehind().  Once
folio_unmap_invalidate() removes the folio from mapping->i_pages, the
page-cache references for all pages in the folio are dropped.  The folio
is then kept alive only by temporary external references, which allows a
later split to operate on a folio whose subpages are no longer protected
by page-cache references.

After the page-cache references are gone, split_folio_to_order() can
split the big folio into individual pages and put the resulting subpages
back on the LRU.  For tail pages beyond EOF, split removes them from the
page cache and drops their page-cache references.  A tail page can then
remain on the LRU with PG_lru set while holding only the split caller's
temporary reference.  When free_folio_and_swap_cache() drops that final
reference, the page enters the final folio_put() release path.

In parallel, folio_isolate_lru() can observe the same tail page with a
non-zero refcount and PG_lru set.  It clears PG_lru before taking its own
reference.  If this races with the final folio_put() from the split path,
__folio_put() sees PG_lru already cleared and skips lruvec_del_folio().
The page is then freed back to the allocator while its lru links are
still present in the LRU list.  A later LRU operation on a neighboring
page detects the stale link and reports list corruption.

[1]
[   22.486082] list_del corruption. next->prev should be fffffffec10e0ac8, but was dead000000000122. (next=fffffffec10e0a88)
[   22.486130] ------------[ cut here ]------------
[   22.486134] kernel BUG at lib/list_debug.c:67!
[   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
[   22.488502] Tainted: [W]=WARN, [O]=OOT_MODULE
[   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
[   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
[   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
[   22.488539] sp : ffffffc08006b830
[   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 0000000000000000
[   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: fffffffec10e0ac0
[   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead000000000122
[   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: ffffffc080061060
[   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 0000000000000058
[   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 0000000000000003
[   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe85721f0e25f00
[   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c65645f7473696c
[   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 0000000000000010
[   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 000000000000006d
[   22.488647] Call trace:
[   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
[   22.488661]  __folio_put+0x2bc/0x434
[   22.488670]  folio_put+0x28/0x58
[   22.488678]  do_garbage_collect+0x1a34/0x2584
[   22.488689]  f2fs_gc+0x230/0x9b4
[   22.488697]  f2fs_fallocate+0xb90/0xdf4
[   22.488706]  vfs_fallocate+0x1b4/0x2bc
[   22.488716]  __arm64_sys_fallocate+0x44/0x78
[   22.488725]  invoke_syscall+0x58/0xe4
[   22.488732]  do_el0_svc+0x48/0xdc
[   22.488739]  el0_svc+0x3c/0x98
[   22.488747]  el0t_64_sync_handler+0x20/0x130
[   22.488754]  el0t_64_sync+0x1c4/0x1c8

[2]
CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU2 (folio_isolate_lru)

F: pagecache refs = n
F: extra refs = GC + split
F: PG_lru set
move_data_block()
folio = f2fs_grab_cache_folio(F)
...
__folio_set_dropbehind(F)
folio_unlock(F)
folio_end_dropbehind(F)
  folio_unmap_invalidate(F)
    __filemap_remove_folio(F)
    folio_put_refs(F, n)
folio_put(F)
                            split_folio_to_order(F)
                              folio_ref_freeze(F, 1)
                              ...
                              lru_add_split_folio(T)
                                list_add_tail(&T->lru, &F->lru)
                                folio_set_lru(T)
                              __filemap_remove_folio(T)
                              folio_put_refs(T, 1)
                              /* T refcount == 1, PageLRU set */
                                                                  folio_isolate_lru(T)
                                                                    folio_test_clear_lru(T)
                            free_folio_and_swap_cache(T)
                              folio_put(T)
                                /* refcount: 1 -> 0 */
                                __folio_put(T)
                                  __page_cache_release(T)
                                    folio_test_lru(T) == false
                                    /* skip lruvec_del_folio(T) */
                                  free_frozen_pages(T)
                                                                  folio_get(T)
                                                                  lruvec_del_folio(T)
later:
  list_del(adjacent->lru)
    next == &T->lru
    next->prev == LIST_POISON / PCP freelist
    BUG

Cc: stable@vger.kernel.org
Fixes: 9609dd704725 ("f2fs: remove non-uptodate folio from the page cache in move_data_block")
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/gc.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1487,11 +1487,7 @@ up_out:
 put_out:
 	f2fs_put_dnode(&dn);
 out:
-	if (!folio_test_uptodate(folio))
-		__folio_set_dropbehind(folio);
-	folio_unlock(folio);
-	folio_end_dropbehind(folio);
-	folio_put(folio);
+	f2fs_folio_put(folio, true);
 out_iput:
 	if (atomic_inode)
 		iput(atomic_inode);


