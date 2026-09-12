Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A240A421237;
	Sat, 12 Sep 2026 10:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208003; cv=none; b=jVfl+x7PQ5fLgZSAs9hdWUPJY25U2yLJBPiyDrN+Esz19Mk3cdZYBi6IYS6Vop1ouQzZqn54RuQ85C+M2GJNmd9bQDVeQfv3DV7QWM6lAe1PoSavbLqlu/dBl5vAzhKFdDSJGX8TCndHsfe3RjQH7GWkSqW1lZWz1bj9wP26/PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208003; c=relaxed/simple;
	bh=bl3rct+jIH+dZTPQA+TY5NtxtkrR8ptaCCYGXfjPMS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+rpmmNsRpf5F7wQLhIGWWZhqD9CQ/tUT8venztWzGjUO8A0fgHXc1go0YVHk3knOh8AkDjUVFe0KJwnhDfXgGs45cXWF1p1UmHmuy2Xi9hlfOipMlarGw3K0ChCCxYcIwVHsvCeZLnrJKBfPnNOKx1+L4OQVjHLsPO89aSS630=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMER7bC1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMER7bC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002EA1F00893;
	Sat, 12 Sep 2026 10:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208000;
	bh=YilmKQ9k5l6wreoLR2o80sddDFKHYd/W80SAApg/giU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMER7bC1YWZGdN37ZE6lTQ525V3f3Akt7KHOqV3lOHaw1lTKQUdGkk3jDsJeOyj/u
	 0LFXbVfdkxrqD21CMD1XTRVLKZz4cyWdzeJEDy8Gwh7La9gCjwu/S3NhEa6PjpCirf
	 tDtZ8g6gQ3iRJW82X7LZiK9a962sJuUtKe3kPWmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Yang <gerald.yang@canonical.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0528/1518] ext4: clear stale xarray tags on folios skipped during writeback
Date: Sat, 12 Sep 2026 08:44:57 +0200
Message-ID: <20260912065635.388077810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index e03c749772f38..3fcb5c446c6b6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2687,13 +2687,25 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
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



