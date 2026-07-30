Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22EA37A85D;
	Thu, 30 Jul 2026 15:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425516; cv=none; b=lk1KLTmtSMqkJeauUfmpDt1xoeupWOmDxGlSBAJSlIAhPh6GfJrKr+aFEQc9RidK6M5i3PTYU+7hfNeLWaXNP7YS5zrAWBSBb7owlgLItEZNxQaCHkVT8VhnEDQWIgVxWlepQh2NeNtahvNEGv3FfnhAlG+3vQgn1sfx99n1sUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425516; c=relaxed/simple;
	bh=g3r7WA4ykg6W4/Iy9vgQuUha94/BW0Gb60/+bOxtxT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6ZtZx+VH29zBI0AsAXiSCB7g531BmjI1tyEyBDommPVHf/P0Id8eINfHTN1MTq3vOpE+ukTrpyoYPt3oqLjdDoARo0ofbQJRLongCMq/DHJs2vtS69/5ZCVJzKHu5OP30YzSvts0m1xf0xUsoengFn7GCWEdXgV1/HI7O9nF0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHX+4RWg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHX+4RWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0CB1F000E9;
	Thu, 30 Jul 2026 15:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425514;
	bh=9YUkxMKbGRx8XolTG8uknPa16bchJp4STupJN60h+wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VHX+4RWgGLRTggCYdU+x1Xro85US2n6h83fBAkSU7i4q3cCYXTMCzKhP7ajfaww9J
	 F6LEubDOy2RLnGIlao8OIWC+FAac9dr51W6BVnOAw2WkyLx5u5JNSoUQ8YD3uAtvzQ
	 koe0Wg7JFgvOWZVK30RGqk8m0OM0UV77kQBOWHO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	Xiang Mei <xmei5@asu.edu>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/602] btrfs: reject free space cache with more entries than pages
Date: Thu, 30 Jul 2026 16:07:13 +0200
Message-ID: <20260730141436.870601260@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index f4bcb25306606a..01588dd3c7028f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -556,6 +556,9 @@ static int io_ctl_check_crc(struct btrfs_io_ctl *io_ctl, int index)
 	u32 crc = ~(u32)0;
 	unsigned offset = 0;
 
+	if (index >= io_ctl->num_pages)
+		return -EIO;
+
 	if (index == 0)
 		offset = sizeof(u32) * io_ctl->num_pages;
 
-- 
2.53.0



