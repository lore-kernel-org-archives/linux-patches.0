Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE43E175A6B;
	Mon, 17 Aug 2026 15:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978985; cv=none; b=OjlzTcIQhZ+ePNwRDubg5XOGB0gS+vXFm8ZPNQFuO3RBP76q0FFQ+wWW2pU3KlyOJHsKbsuaUngW7hEtROK4VymZIwZAssAKmJqZiAgNGQFwYIWhiVqQVD1k36/oiF3Y3FfmspX5ZtiFdMO+v+Lv77+tsl+pFU3C0v7FLsZtFpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978985; c=relaxed/simple;
	bh=C+2LdfHxsoUooh/05CI+mARZmoaxF0WnpbGWo0/xfzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pU8BEXRvoH4x214oMAFLnO2WllFSTEwrRKUtPWpBF6Pu4AMrbJaBLFgac+5IX9hnExCSzVkY+is6C6dSHgDT5/XduTKVKSoIwWo0P3F5ZnT0OwyLqhIGggqgbQbVHwgYOQ9lk+I9OBtwpnwdPWBdbMjs6JhhW0UtBr1yUPfhOsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Je6J3S+n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Je6J3S+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510031F000E9;
	Mon, 17 Aug 2026 15:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978983;
	bh=8XFO/cq0Ft96FKQVl1TMxweDQIMUXXaZSd+WR+hbWgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Je6J3S+nYU+ZP//LAqKq9oMyG0eejGMNfGxTO1rNxlg0w2pv9XBPXSTm+U7/ss6Ap
	 r8LLhCOiPujP5h6ci+nEDAkkf7p5ckMrg58OYtL8FYNkRyJMYOETCZvh0w21dv76js
	 FSG5NCj+5CdqK7YBzR+AsDif+1ZVy86MQN9SnhkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	Xiang Mei <xmei5@asu.edu>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/609] btrfs: reject free space cache with more entries than pages
Date: Mon, 17 Aug 2026 15:25:24 +0200
Message-ID: <20260817132544.183447247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit a2d8d5647ed854e38f941741aea45b9eb15a6350 ]

When loading a v1 free space cache, __load_free_space_cache() takes
num_entries and num_bitmaps straight from the on-disk
btrfs_free_space_header. That header is stored in the tree_root under a key
with type 0, which the tree-checker has no case for, so neither count is
validated before the load trusts it.

The load loops num_entries times and maps the next page whenever the current
one runs out, going through io_ctl_check_crc() -> io_ctl_map_page(), which
does io_ctl->pages[io_ctl->index++]. But pages[] is allocated in
io_ctl_init() from the cache inode's i_size, not from num_entries:

	num_pages = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
	io_ctl->pages = kcalloc(num_pages, sizeof(struct page *), GFP_NOFS);

So if num_entries claims more records than the pages can hold, io_ctl->index
runs off the end of pages[]. The write side never hits this because
io_ctl_add_entry() and io_ctl_add_bitmap() both stop once
io_ctl->index >= io_ctl->num_pages; the read side just never had the same
check.

To trigger it, take a clean cache (num_entries = <N> here), set num_entries
in the header to 0x10000, and fix up the leaf checksum so it still passes
the tree-checker. The cache inode has i_size = 65536, so num_pages is 16 and
pages[] is a 16-pointer (kmalloc-128) array. The load now tries to read
65536 entries, io_ctl->index walks up to 16, and pages[16] is read past the
array:

  BUG: KASAN: slab-out-of-bounds in io_ctl_check_crc (fs/btrfs/free-space-cache.c:420 fs/btrfs/free-space-cache.c:565)
  Read of size 8 at addr ffff88800c833a80 by task kworker/u8:3/58
   io_ctl_check_crc (fs/btrfs/free-space-cache.c:420 fs/btrfs/free-space-cache.c:565)
   __load_free_space_cache (fs/btrfs/free-space-cache.c:655 fs/btrfs/free-space-cache.c:820)
   load_free_space_cache (fs/btrfs/free-space-cache.c:1017)
   caching_thread (fs/btrfs/block-group.c:880)
   btrfs_work_helper (fs/btrfs/async-thread.c:312)
   process_one_work
   worker_thread
   kthread
   ret_from_fork

free-space-cache.c:420 is io_ctl_map_page(), inlined into io_ctl_check_crc()
at line 565, which is why that is the frame KASAN names. The out-of-bounds
slot is then treated as a struct page and handed to crc32c(), so the bad
read turns into a GP fault.

Add the missing check to io_ctl_check_crc(), which is where both the entry
loop and the bitmap loop end up. When num_entries is too large the load now
fails like any corrupt cache: __load_free_space_cache() drops it and rebuilds
the free space from the extent tree, so a valid cache is never rejected.

Reported-by: Weiming Shi <bestswngs@gmail.com>
Fixes: 5b0e95bf607d ("Btrfs: inline checksums into the disk free space cache")
Link: https://lore.kernel.org/linux-btrfs/CAPpSM+RMPByMCKXvM5QFKToxsyNccfuFLWMdD0mfd0wh2Ja62w@mail.gmail.com/
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/free-space-cache.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 9f4dae426037b8..92933cc5596e0f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -569,6 +569,9 @@ static int io_ctl_check_crc(struct btrfs_io_ctl *io_ctl, int index)
 	u32 crc = ~(u32)0;
 	unsigned offset = 0;
 
+	if (index >= io_ctl->num_pages)
+		return -EIO;
+
 	if (index == 0)
 		offset = sizeof(u32) * io_ctl->num_pages;
 
-- 
2.53.0



