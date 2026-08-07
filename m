Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8102D12ED;
	Fri,  7 Aug 2026 15:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115856; cv=none; b=WDrRmG0mwlWg4xf2jrXg6rWqACkAp9DATfqjhVtSq+UfTzZcwkbuOnXaNNqniJX3LYZtrRSOET5S8y2uUYP8N99QCxGHQETJjCFLhjL9WzssfBiwlDK3VUu1UzCw5HesuyYrT+nLy/Q8/KuYrklfMiVcPWMb7DvV7RB/um+2UKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115856; c=relaxed/simple;
	bh=Q4DuPlMuoZhEw5mod/S8ILIFRIHGLw1yH+xQ01RUEhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PdczhgXZhFtNdJ/IfxiSoioebUXPBGetYyiuVf9x31Hmbyk7SWZZwbRpl3BJ/msV9WbXuWLc0cCR3DGlowH5LTPJFfw1zAfuI436f8ZlFdJFhcy+79Ebs3q3DScjIIbKpRuoeQ0OMabEWHOAtvBCK+HsB+P62v20BYY3jLX6BSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyuEnYJP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyuEnYJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C651F00A3A;
	Fri,  7 Aug 2026 15:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115855;
	bh=k0XHWpUYevN0yRzgaASuvTtUzbaAVTyW6xzcpuVXzBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cyuEnYJPTrVCvLChhwKIXICXlEhk1gCIqvSaSh5wgsolTI5SFYWtWPRVLT2t9NUED
	 Wq4yi5+jGyEEUV4Fl7gm8MKnh3EaHkutFh9GPhPTbomclV3K01Yd0FNShLOyGwJtE9
	 bqevYyF1F+7MFFlrGmEWfxrzSnMXZ1qh4rp9OkeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/261] btrfs: zoned: fix deadlock between metadata writeback and transaction commit
Date: Fri,  7 Aug 2026 16:36:16 +0200
Message-ID: <20260807143415.783792463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 1ebe51c29fa9755d5b2fea28727c051117907cf8 ]

When writing out metadata extent buffers in a zoned filesystem,
btree_writepages() holds fs_info->zoned_meta_io_lock across the whole
writeback loop, including the call to btrfs_check_meta_write_pointer() ->
check_bg_is_active().

For the tree-log block group, check_bg_is_active() may fail to activate
the zone and fall back to btrfs_zone_finish_one_bg() to free an active
zone. That path waits for the running transaction to commit while still
holding zoned_meta_io_lock, but the committer needs that same lock to
write out the tree extents, so the two tasks deadlock:

  Task A (kworker, metadata writeback)      Task B (fsstress, transaction commit)
  ------------------------------------      -------------------------------------
  wb_workfn()                               btrfs_commit_transaction(T)
   btree_writepages()                        btrfs_write_and_wait_transaction()
    btrfs_zoned_meta_io_lock()                btrfs_write_marked_extents()
    btrfs_check_meta_write_pointer()           btree_writepages()
     check_bg_is_active() [treelog_bg]          btrfs_zoned_meta_io_lock()
      btrfs_zone_finish_one_bg()               <blocks on zoned_meta_io_lock,
       btrfs_zone_finish()                      held by Task A>
        do_zone_finish()
         btrfs_inc_block_group_ro()
          btrfs_wait_for_commit()
           <blocks waiting for commit
            of transaction T, done by
            Task B>

The sibling branch in check_bg_is_active() already drops zoned_meta_io_lock
around do_zone_finish() for this exact reason. Do the same in the tree-log
branch: release the lock around btrfs_zone_finish_one_bg() and re-acquire
it afterwards. The lock only protects fs_info->active_{meta,system}_bg,
which this branch does not touch, and ctx->zoned_bg keeps a reference to
the block group across the unlock, so nothing is lost while the lock
is dropped.

This hang occasionally reproduces with fstests generic/475 on a zoned
btrfs filesystem.

Fixes: 13bb483d32ab ("btrfs: zoned: activate metadata block group on write time")
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index dabbfc3b7d776..9962ae292b128 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1775,7 +1775,11 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 
 	if (fs_info->treelog_bg == block_group->start) {
 		if (!btrfs_zone_activate(block_group)) {
-			int ret_fin = btrfs_zone_finish_one_bg(fs_info);
+			int ret_fin;
+
+			btrfs_zoned_meta_io_unlock(fs_info);
+			ret_fin = btrfs_zone_finish_one_bg(fs_info);
+			btrfs_zoned_meta_io_lock(fs_info);
 
 			if (ret_fin != 1 || !btrfs_zone_activate(block_group))
 				return false;
-- 
2.53.0



