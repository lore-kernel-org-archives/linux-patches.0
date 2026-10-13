Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA1E3FD955;
	Tue, 13 Oct 2026 12:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893811; cv=none; b=V82BNKfMM8sWM1svvJ0QQMrYPgJmx+2nkN0qeBioS3Ab5TWXWNXwaLzmymgxiT5uk9iC9GmbH09l6EJpUGOiIvlKyNJ5U4Xsflx/NlYQxv0diTXo8yJy7LW0FyNvaolSC1Z7u3fiMwwc/igHKXLtvGcEX7kEycZlVVYBJcZh+yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893811; c=relaxed/simple;
	bh=EWBBhvKcqkjOHjW1u7o70xKbxEqyg5g+xnnW6tAbzdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hR9tE+W9egzEsNn2N0hZ3BjL4JRXiNKUBsI43qS+gBJkRGiShxOkDoxhb1ur5qAVp2udjHs4sXyGQBcWTtp5Q5Jfeom1xw0b7tM9JaVF3mtR2oKZBU6tPsq6xdXgpmC9GUhmpAlLmDAW6XTXOPKfgzZE05SAEeHGZvWEJMjL8AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/VAHdx2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/VAHdx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B33F1F000FF;
	Tue, 13 Oct 2026 12:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893810;
	bh=sVBmOE7IPgJsNVRTr6i1KunnRVCLhDz2BckRs9cGsao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K/VAHdx29AC+tahUYLPj7hzNJHyScVD1+3cxJZMNSszxeFF8ds6/XpEmpGx63eF76
	 wTsaUyCaJgyVRO8x3lbSH22gBxuobl42a/4+ExzdZCkZr6cXcynCh1AXDY82kXVuOl
	 chSuiHEv0fpV8lR808zsBtgRzMZiqRuwr/M1zt48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 343/621] btrfs: lzo: reject inline extents without valid headers
Date: Tue, 13 Oct 2026 13:35:38 +0200
Message-ID: <20261013112928.993053092@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: David Lee <david.lee@trailofbits.com>

[ Upstream commit 0fa78ef637deb5dbe341582f88553a4bce496de0 ]

[BUG]
For a crafted btrfs image, the following KASAN can be triggered when
reading an inline lzo compressed file extent:

  BUG: KASAN: slab-out-of-bounds in lzo_decompress+0x57d/0x700
  Read of size 4 at addr ffff888006f2e644 by task btrfs_lzo_inlin/77

  Call Trace:
   <TASK>
   dump_stack_lvl+0x5b/0x70
   print_report+0xd1/0x610
   kasan_report+0xe0/0x110
   __asan_report_load_n_noabort+0x13/0x20
   lzo_decompress+0x57d/0x700
   btrfs_decompress+0x140/0x1c0
   uncompress_inline+0x147/0x1b0
   btrfs_get_extent+0xb23/0x10a0
   btrfs_do_readpage.constprop.0+0x538/0x1ac0
   btrfs_readahead+0x32f/0x5f0
   read_pages+0x16f/0x850
   page_cache_ra_unbounded+0x296/0x490
   do_page_cache_ra+0xd9/0x130
   page_cache_sync_ra+0x3ee/0x6f0
   filemap_get_pages+0x306/0x15c0
   filemap_read+0x329/0xd00
   btrfs_file_read_iter+0x1f8/0x2b0
   vfs_read+0x4ef/0x720
   ksys_read+0xf8/0x1d0
   __x64_sys_read+0x71/0xb0
   x64_sys_call+0x1ab0/0x1b70
   do_syscall_64+0x61/0x470
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>

[CAUSE]
For an inline lzo compressed file extent, there should always be one lzo
header, recording the total length of the compressed data, followed by
one segment header, recording the compressed lzo payload.

But if a crafted inline lzo compressed file extent contains only an lzo
header, without the segment header or payload, lzo_decompress() will
still try to read the segment header, causing a read beyond the item
boundary.

Furthermore if the inline lzo compressed file extent is the first item
of the leaf, it will be at the extent buffer boundary. The above
out-of-boundary read will go beyond the extent buffer boundary,
triggering the above KASAN report.

[FIX]
Validate the total length of the inlined lzo compressed file extent, to
make sure there is at least one LZO header and one segment header, and a
non-zero payload.

Fixes: a6fa6fae40ec ("btrfs: Add lzo compression support")
Assisted-by: Codex:gpt-5.5
Signed-off-by: David Lee <david.lee@trailofbits.com>
[ Rework the commit message to remove slop ]
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/lzo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 4758f66da449c..6b1cf1e67be72 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -458,7 +458,8 @@ int lzo_decompress(struct list_head *ws, const u8 *data_in,
 	size_t max_segment_len = workspace_buf_length(fs_info);
 	int ret = 0;
 
-	if (unlikely(srclen < LZO_LEN || srclen > max_segment_len + LZO_LEN * 2))
+	if (unlikely(srclen <= LZO_LEN * 2 ||
+		     srclen > max_segment_len + LZO_LEN * 2))
 		return -EUCLEAN;
 
 	in_len = read_compress_length(data_in);
-- 
2.53.0



