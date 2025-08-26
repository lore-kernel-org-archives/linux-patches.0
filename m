Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E5E2BEC52;
	Tue, 26 Aug 2025 11:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208676; cv=none; b=lBfDuEK9mMXtSQP1LmO2ZWEDLBN+rkmx7Tq8NbwtvdzrtxphaaR1oQCSAa7w9rC1C6gfQdJM7Tlc+jGm1f4T8ZH+ie3ehYa4absb4dq/PnojdC4r7ttBO3jz8/Ou1zqVBdiC0AwUsV/L4Ai8G7FgW6vUMJsx5qE/rE6nJbbMCCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208676; c=relaxed/simple;
	bh=gG3E/g8FmEV8O7U2Eh+96mjsIA9Tmf1OAYWnQKDzXhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kk9oeEkup6XxabawPhi9j8EzIY0QUUyw0B3LO1r7SXBQhv+diC9ADuHcRyDjTsNNzWK6A+5WupipDAtaYm2BN37+Siw4muoBY6/0XygBfOWQysmVAATOa7yog1GKn29iFbcV3OWH0mu+9joe2flTmGs77oi9yCwAhUBiMh9JaOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqmRuLR2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqmRuLR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F73EC4CEF1;
	Tue, 26 Aug 2025 11:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208675;
	bh=gG3E/g8FmEV8O7U2Eh+96mjsIA9Tmf1OAYWnQKDzXhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqmRuLR21DnxeHvpIJTqf6D83Mt5spci1fywOzMpw+qGYjCNeLEDq4+9GDq6uq5b8
	 Kp7iQTIp/xCxP+Tgg1/RDbQuTUTs+lUnrM9CNe7R4KZCJ6wVhOXWkWnRkCEfZRpORi
	 dVbALEkGHpt6MJ9ViiPfXpS/+pohemUYA84zLgFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 201/322] btrfs: subpage: keep TOWRITE tag until folio is cleaned
Date: Tue, 26 Aug 2025 13:10:16 +0200
Message-ID: <20250826110920.831353563@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit b1511360c8ac882b0c52caa263620538e8d73220 ]

btrfs_subpage_set_writeback() calls folio_start_writeback() the first time
a folio is written back, and it also clears the PAGECACHE_TAG_TOWRITE tag
even if there are still dirty blocks in the folio. This can break ordering
guarantees, such as those required by btrfs_wait_ordered_extents().

That ordering breakage leads to a real failure. For example, running
generic/464 on a zoned setup will hit the following ASSERT. This happens
because the broken ordering fails to flush existing dirty pages before the
file size is truncated.

  assertion failed: !list_empty(&ordered->list) :: 0, in fs/btrfs/zoned.c:1899
  ------------[ cut here ]------------
  kernel BUG at fs/btrfs/zoned.c:1899!
  Oops: invalid opcode: 0000 [#1] SMP NOPTI
  CPU: 2 UID: 0 PID: 1906169 Comm: kworker/u130:2 Kdump: loaded Not tainted 6.16.0-rc6-BTRFS-ZNS+ #554 PREEMPT(voluntary)
  Hardware name: Supermicro Super Server/H12SSL-NT, BIOS 2.0 02/22/2021
  Workqueue: btrfs-endio-write btrfs_work_helper [btrfs]
  RIP: 0010:btrfs_finish_ordered_zoned.cold+0x50/0x52 [btrfs]
  RSP: 0018:ffffc9002efdbd60 EFLAGS: 00010246
  RAX: 000000000000004c RBX: ffff88811923c4e0 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: ffffffff827e38b1 RDI: 00000000ffffffff
  RBP: ffff88810005d000 R08: 00000000ffffdfff R09: ffffffff831051c8
  R10: ffffffff83055220 R11: 0000000000000000 R12: ffff8881c2458c00
  R13: ffff88811923c540 R14: ffff88811923c5e8 R15: ffff8881c1bd9680
  FS:  0000000000000000(0000) GS:ffff88a04acd0000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f907c7a918c CR3: 0000000004024000 CR4: 0000000000350ef0
  Call Trace:
   <TASK>
   ? srso_return_thunk+0x5/0x5f
   btrfs_finish_ordered_io+0x4a/0x60 [btrfs]
   btrfs_work_helper+0xf9/0x490 [btrfs]
   process_one_work+0x204/0x590
   ? srso_return_thunk+0x5/0x5f
   worker_thread+0x1d6/0x3d0
   ? __pfx_worker_thread+0x10/0x10
   kthread+0x118/0x230
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x205/0x260
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>

Consider process A calling writepages() with WB_SYNC_NONE. In zoned mode or
for compressed writes, it locks several folios for delalloc and starts
writing them out. Let's call the last locked folio folio X. Suppose the
write range only partially covers folio X, leaving some pages dirty.
Process A calls btrfs_subpage_set_writeback() when building a bio. This
function call clears the TOWRITE tag of folio X, whose size = 8K and
the block size = 4K. It is following state.

   0     4K    8K
   |/////|/////|  (flag: DIRTY, tag: DIRTY)
   <-----> Process A will write this range.

Now suppose process B concurrently calls writepages() with WB_SYNC_ALL. It
calls tag_pages_for_writeback() to tag dirty folios with
PAGECACHE_TAG_TOWRITE. Since folio X is still dirty, it gets tagged. Then,
B collects tagged folios using filemap_get_folios_tag() and must wait for
folio X to be written before returning from writepages().

   0     4K    8K
   |/////|/////|  (flag: DIRTY, tag: DIRTY|TOWRITE)

However, between tagging and collecting, process A may call
btrfs_subpage_set_writeback() and clear folio X's TOWRITE tag.
   0     4K    8K
   |     |/////|  (flag: DIRTY|WRITEBACK, tag: DIRTY)

As a result, process B won't see folio X in its batch, and returns without
waiting for it. This breaks the WB_SYNC_ALL ordering requirement.

Fix this by using btrfs_subpage_set_writeback_keepwrite(), which retains
the TOWRITE tag. We now manually clear the tag only after the folio becomes
clean, via the xas operation.

Fixes: 3470da3b7d87 ("btrfs: subpage: introduce helpers for writeback status")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/subpage.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -452,8 +452,25 @@ void btrfs_subpage_set_writeback(const s
 
 	spin_lock_irqsave(&subpage->lock, flags);
 	bitmap_set(subpage->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
+
+	/*
+	 * Don't clear the TOWRITE tag when starting writeback on a still-dirty
+	 * folio. Doing so can cause WB_SYNC_ALL writepages() to overlook it,
+	 * assume writeback is complete, and exit too early — violating sync
+	 * ordering guarantees.
+	 */
 	if (!folio_test_writeback(folio))
-		folio_start_writeback(folio);
+		__folio_start_writeback(folio, true);
+	if (!folio_test_dirty(folio)) {
+		struct address_space *mapping = folio_mapping(folio);
+		XA_STATE(xas, &mapping->i_pages, folio->index);
+		unsigned long flags;
+
+		xas_lock_irqsave(&xas, flags);
+		xas_load(&xas);
+		xas_clear_mark(&xas, PAGECACHE_TAG_TOWRITE);
+		xas_unlock_irqrestore(&xas, flags);
+	}
 	spin_unlock_irqrestore(&subpage->lock, flags);
 }
 


