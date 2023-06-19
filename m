Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B781095F
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A2FC433C8;
	Mon, 19 Jun 2023 10:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170891;
	bh=A1uVDAhQQ60xWAubq4apbu2qdEObQYRqNM1ohP7oS1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XD2nkJV6jGb+ahM7lHxfr/MOERceUylsUiRXABLPQDPzSsIxbPuLngznK41J1yZlK
	 Oq9w1v8ibZ+3XPS9xAoqKKKCj82/jpttIb0npsNnDkNReLtmiJS4+s5kWFHP3Zrues
	 fxq6qCbE7tuIjxP6TxgrOVkS0awC7ld/b4ec8wtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.3 065/187] btrfs: subpage: fix a crash in metadata repair path
Date: Mon, 19 Jun 2023 12:28:03 +0200
Message-ID: <20230619102200.824375535@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qu Wenruo <wqu@suse.com>

commit 917ac77846b907dfdbd878688a9a61236ad6c51e upstream.

[BUG]
Test case btrfs/027 would crash with subpage (64K page size, 4K
sectorsize) with the following dying messages:

  debug: map_length=16384 length=65536 type=metadata|raid6(0x104)
  assertion failed: map_length >= length, in fs/btrfs/volumes.c:8093
  ------------[ cut here ]------------
  kernel BUG at fs/btrfs/messages.c:259!
  Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
  Call trace:
   btrfs_assertfail+0x28/0x2c [btrfs]
   btrfs_map_repair_block+0x150/0x2b8 [btrfs]
   btrfs_repair_io_failure+0xd4/0x31c [btrfs]
   btrfs_read_extent_buffer+0x150/0x16c [btrfs]
   read_tree_block+0x38/0xbc [btrfs]
   read_tree_root_path+0xfc/0x1bc [btrfs]
   btrfs_get_root_ref.part.0+0xd4/0x3a8 [btrfs]
   open_ctree+0xa30/0x172c [btrfs]
   btrfs_mount_root+0x3c4/0x4a4 [btrfs]
   legacy_get_tree+0x30/0x60
   vfs_get_tree+0x28/0xec
   vfs_kern_mount.part.0+0x90/0xd4
   vfs_kern_mount+0x14/0x28
   btrfs_mount+0x114/0x418 [btrfs]
   legacy_get_tree+0x30/0x60
   vfs_get_tree+0x28/0xec
   path_mount+0x3e0/0xb64
   __arm64_sys_mount+0x200/0x2d8
   invoke_syscall+0x48/0x114
   el0_svc_common.constprop.0+0x60/0x11c
   do_el0_svc+0x38/0x98
   el0_svc+0x40/0xa8
   el0t_64_sync_handler+0xf4/0x120
   el0t_64_sync+0x190/0x194
  Code: aa0403e2 b0fff060 91010000 959c2024 (d4210000)

[CAUSE]
In btrfs/027 we test RAID6 with missing devices, in this particular
case, we're repairing a metadata at the end of a data stripe.

But at btrfs_repair_io_failure(), we always pass a full PAGE for repair,
and for subpage case this can cross stripe boundary and lead to the
above BUG_ON().

This metadata repair code is always there, since the introduction of
subpage support, but this can trigger BUG_ON() after the bio split
ability at btrfs_map_bio().

[FIX]
Instead of passing the old PAGE_SIZE, we calculate the correct length
based on the eb size and page size for both regular and subpage cases.

CC: stable@vger.kernel.org # 6.3+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2b1b227505f3..88e6d1072a35 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -242,7 +242,6 @@ static int btrfs_repair_eb_io_failure(const struct extent_buffer *eb,
 				      int mirror_num)
 {
 	struct btrfs_fs_info *fs_info = eb->fs_info;
-	u64 start = eb->start;
 	int i, num_pages = num_extent_pages(eb);
 	int ret = 0;
 
@@ -251,12 +250,14 @@ static int btrfs_repair_eb_io_failure(const struct extent_buffer *eb,
 
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = eb->pages[i];
+		u64 start = max_t(u64, eb->start, page_offset(p));
+		u64 end = min_t(u64, eb->start + eb->len, page_offset(p) + PAGE_SIZE);
+		u32 len = end - start;
 
-		ret = btrfs_repair_io_failure(fs_info, 0, start, PAGE_SIZE,
-				start, p, start - page_offset(p), mirror_num);
+		ret = btrfs_repair_io_failure(fs_info, 0, start, len,
+				start, p, offset_in_page(start), mirror_num);
 		if (ret)
 			break;
-		start += PAGE_SIZE;
 	}
 
 	return ret;
-- 
2.41.0



