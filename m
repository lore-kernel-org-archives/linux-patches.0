Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F13A280331;
	Fri,  7 Aug 2026 15:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116732; cv=none; b=JkboAm+RGo7y9xTQgOosTtLLTJyJ5IXs6o+i1WhFtNiYLJ3bqlj0KK0LNXERcQltW3Xb78uyr95mE83HZrk2VD/YYXBfLRDuPxOIdL7oOGjdywCCQ11V9h1ry1stLihhEfzGJJIc6TuZJWFkPpCK3NWatEo67LTiLkJhxhANRBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116732; c=relaxed/simple;
	bh=5B0SmhBJ3oPHk7sS6jsgexg2R4j7IaRdiKGfczqrwPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HH5TyzI8pJQk3uMcPM9LkKCu9R9XxCwYnk1RjIzwVXcuB/g+r8PovGn6fPfBs4adL0aYE0RNDpFy6ChpHQk7CuhRpRmzYXs5oSMDaZdl5+H0UuqhO0XZQSBSlKt89Y0TxCaAn5IudPB10NaSGrlghZXQ8yeFlXf+pDp5XZfQ4u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMM46pzt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMM46pzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A6B1F000E9;
	Fri,  7 Aug 2026 15:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116731;
	bh=vD9HmmqoZIczSnTJkTYpTKHp9K+qLeZ1WrtNTJUXV5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cMM46pztxQQXx2v7apFuFRXfGsDoMzpyY6/2bM2UUDGkck7/c3b4J3QJqQ672Z49t
	 FR0VHcjOOBjH3UykwwxhRhl7Zv5JWzFVA4rsKc1ULCCmHPY9+TCWWf6omlvSePH4v5
	 B4Mk6a50CZXTqz4hxX/Z6JKqzPaaIZsKUr2Agxis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 026/438] btrfs: zoned: fix deadlock between metadata writeback and transaction commit
Date: Fri,  7 Aug 2026 16:33:42 +0200
Message-ID: <20260807143428.565603093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0d590e81f3259..a85fc150c97b5 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2188,7 +2188,11 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 
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



