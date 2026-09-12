Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E1928B4FA;
	Sat, 12 Sep 2026 07:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199615; cv=none; b=UHJLdaA3xhI2L5vO3tKJvjuoTmbqLQtBge1AhdsH+/8dBS/H7ARi8XGuh5DYmXaIetMzDNsQ3/DNqUpUU+NYiO8BgHcsUe4kKu3IyyUNyiYVCwApmgYcPdZu1Nb0SNPSixL1MyYqAUKvEzsQmZylsseHB/I4x8X4e299w5FI1ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199615; c=relaxed/simple;
	bh=agw+eRXeEpLB4TiV/eVNi+cux5i0FyboDVP6YDFM6rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOgSTMK4etFW2s0mRVu/8ODkmYxmzEGuESr8cODRuSx+WGGgHAlUvsLEBZQlfvPi2KUX6uXWC9WNRZ5kZb0o/6BccQRTORHIdlh4RAUq4bhXrTExkTOn1AuFtK75PR1Euo94JdLmlQrpxPnV+5VzUPp4oFAnlry7zrT6l1URAmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtU0kM1t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtU0kM1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39151F000FF;
	Sat, 12 Sep 2026 07:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199614;
	bh=8c8hj/ZsvA5LE7lm8zIcDgMWaxHdIBY/UBolqtHO5wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gtU0kM1tmrGibQIhZ1yk1ruT9RqND5UdCXpZ2p1Gzy/6/xmI2eir4dhnBfI5n3+2x
	 bOPKTAC0QTpfgQgA+iDOfAH7YQRJIxcsp/nKgrCb91zj365LeGwOAlLUEehH84u3c7
	 usrERyeLCXn0j4fhfjX3eTVXYc2BrRK2Lemwz5jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Yang <gerald.yang@canonical.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0594/1815] ext4: clear stale xarray tags on folios skipped during writeback
Date: Sat, 12 Sep 2026 08:39:04 +0200
Message-ID: <20260912065702.827637493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerald Yang <gerald.yang@canonical.com>

[ Upstream commit ec524aae479b4b2078c47492b90ec21200bce434 ]

In data=journal mode, the writeback thread can hit the
WARN_ON_ONCE(sb_rdonly(sb)) in ext4_journal_check_start() while the
superblock is being remounted read-only during reboot:

Workqueue: writeback wb_workfn (flush-253:0)
RIP: 0010:ext4_journal_check_start+0x8b/0xd0
Call Trace:
  __ext4_journal_start_sb+0x3c/0x1e0
  mpage_prepare_extent_to_map+0x4af/0x580
  ext4_do_writepages+0x3c0/0x1080
  ext4_writepages+0xc8/0x1a0
  do_writepages+0xc4/0x180
  __writeback_single_inode+0x45/0x2f0
  writeback_sb_inodes+0x26b/0x5d0
  __writeback_inodes_wb+0x54/0x100
  wb_writeback+0x1ac/0x320
  wb_workfn+0x394/0x470

And followed by the warning:
EXT4-fs warning (device vda1): ext4_evict_inode:195: inode #6263:
comm (sd-umount): data will be lost

This issue is not reproduced every time, but frequently.
The reproduction step is to create a VM with 8 CPUs, 16G memory and
setup data=journal:
sudo tune2fs -o journal_data /dev/vda1
Run fio:
rm -f fiotest
fio --name=fiotest --rw=randwrite --bs=4k --runtime=6 --ioengine=libaio
--iodepth=256 --numjobs=8 --filename=fiotest --filesize=30G
--group_reporting
Reboot the VM, and check the console output from:
virsh console testvm

But there is no dirty inode, folio_clear_dirty_for_io clears PG_dirty
but leaves tags PAGECACHE_TAG_DIRTY and PAGECACHE_TAG_TOWRITE set which
are only cleared by __folio_start_writeback.
In data=journal mode, jbd2 checkpoints the journalled data to its final
location and clears its own dirty flag without touching folio PG_dirty
or xarray dirty flags.
The commit f4a2b42e7891 ("ext4: fix stale xarray tags after writeback")
fixes when PG_dirty is still set but there is no dirty page.
Another case is PG_dirty is cleared, but PAGECACHE_TAG_DIRTY and
PAGECACHE_TAG_TOWRITE is still set. In this case, writeback thread
checks clean folio and skips it in mpage_prepare_extent_to_map:
if (!folio_test_dirty(folio) ||
    ...
        folio_unlcok(folio);
	continue

And never reaches ext4_bio_write_folio where the commit f4a2b42e7891
clears the stale xarray tags. Print debug logs after the filesystem
is remounted read-only:
writepages RDONLY nrpages=2048 dirtytag=1 wbtag=0 towrite=1 sync=0
And all folios are actually clean:
folio idx=3 dirty=0 wb=0 checked=0 dirtybuf=0 jbddirty=0 mapped=1
...

We need to clear the xarray stale tags for such clean folios by
cycling them through writeback in the skip path, the same way
f4a2b42e7891 does in ext4_bio_write_folio.

Fixes: dff4ac75eeee ("ext4: move keep_towrite handling to ext4_bio_write_page()")
Signed-off-by: Gerald Yang <gerald.yang@canonical.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260625160127.162272-1-gerald.yang@canonical.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9cf0a8a212970..61c3fce38d889 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2695,13 +2695,25 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 			 * page is already under writeback and we are not doing
 			 * a data integrity writeback, skip the page
 			 */
-			if (!folio_test_dirty(folio) ||
-			    (folio_test_writeback(folio) &&
-			     (mpd->wbc->sync_mode == WB_SYNC_NONE)) ||
+			if ((folio_test_writeback(folio) &&
+			    mpd->wbc->sync_mode == WB_SYNC_NONE) ||
 			    unlikely(folio->mapping != mapping)) {
 				folio_unlock(folio);
 				continue;
 			}
+			/*
+			 * If the folio is clean, skip writing it back.
+			 * Cycle the folio through the writeback state
+			 * though, to clear stale xarray tags.
+			 */
+			if (!folio_test_dirty(folio)) {
+				if (!folio_test_writeback(folio)) {
+					__folio_start_writeback(folio, false);
+					folio_end_writeback(folio);
+				}
+				folio_unlock(folio);
+				continue;
+			}
 
 			folio_wait_writeback(folio);
 			BUG_ON(folio_test_writeback(folio));
-- 
2.53.0



