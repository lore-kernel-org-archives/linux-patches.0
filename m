Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215125;
	b=QSXbbmJsvBPzRrnTZ7dbsSqcEONNUAh+qNpCuKnK5zLoNonY+PjCp2W7vsDLfbMCs478
	 1j9FhEBGKCKSzC+Nb3ajIsN/D4v2ZO2GBq95Z1GIrgzlRn55PCF/6Dg4Qipk0NECqiZnV
	 DLpMvSVtpKLyje1JkqXithhRukEDAoPKHQbSme+CbMftwT3AnhSIgiuKxKu0ckNqOxUb3
	 kVVhFPjB9PLDo0KRjtSChgdrf9KN5MF2Bytd1kI+fxS3iRtyuT6KAflhl6qlFOcOLOUqC
	 zyHS4boBD5h3mKPR4luNLWLBlNbYi2gtwILrIwFLlyvizAVcu5rwE/gXrtI0xeOZutg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+m+bfUcU39DCWOo6uqg9VrFYAJ+OV8ReDqk3otOkkt0=;
	b=x1iqnC1PXcusfai/tVyLGD0RehULTSq90EiBisS4ouBZUxdx4/OjqxxugTsqmaLTvyDC
	 jisdtA9EY9/Fn5qPz7XWu6qTIAkSlTZZN82fQrQ2691ajs4DnDujaoxammCpH7zGSEV++
	 3LMBMEz19aPQ+KBM5Hb0+gzEPrWaHQdgYGtYgr/yaKww5S2X69Tt0xJwJVwPEBT935qf2
	 QsfaV+UMZpOKkfDOeeQsRVTR65J0J/6mO1NQogwLJ6F/3ddafgvHUukRjKFeyOKqoWcEe
	 TQP0Cet+5egf3SCjXxX/NU8aiu+gp7rygBKFEfUiiRUX6sknC4xzL6x3zdFb+oXt2ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ax/UEwwn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9FA606A31C;
	Wed, 28 Oct 2026 19:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ax/UEwwn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790DD1F01825;
	Wed, 28 Oct 2026 19:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215125;
	bh=+m+bfUcU39DCWOo6uqg9VrFYAJ+OV8ReDqk3otOkkt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ax/UEwwnJLU2QOx2Xx1GtuDfaa9Po755ohzo7q2KAkBquBLSTpNz17YmQeQE05gVg
	 cDYMzQR2VS6VUwgfngUGRtEn47ZYhkbXfw3Ugh5cpfAcdJuaHDbk3F7BsilyM3ONQA
	 tlznmowWrMB3fBKXkl/yylEpHyUo3SJePipflFCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1102/1887] btrfs: only release the dirty pages io tree after successful writes
Date: Wed, 28 Oct 2026 17:53:18 +0100
Message-ID: <20261028170524.482320037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 4066c55e109475a06d18a1f127c939d551211956 ]

[WARNING]
With extra warning on dirty extent buffers at umount (aka, the next
patch in the series), test case generic/388 can trigger the following
warning about dirty extent buffers at unmount time:

  BTRFS critical (device dm-2 state E): emergency shutdown
  BTRFS error (device dm-2 state E): error while writing out transaction: -30
  BTRFS warning (device dm-2 state E): Skipping commit of aborted transaction.
  BTRFS error (device dm-2 state EA): Transaction 9 aborted (error -30)
  BTRFS: error (device dm-2 state EA) in cleanup_transaction:2068: errno=-30 Readonly filesystem
  BTRFS info (device dm-2 state EA): forced readonly
  BTRFS info (device dm-2 state EA): last unmount of filesystem 4fbf2e15-f941-49a0-bc7c-716315d2777c
  ------------[ cut here ]------------
  WARNING: disk-io.c:3311 at invalidate_and_check_btree_folios+0xfd/0x1ca [btrfs], CPU#8: umount/914368
  CPU: 8 UID: 0 PID: 914368 Comm: umount Tainted: G           OE       7.1.0-rc1-custom+ #372 PREEMPT(full)  2de38db8d1deae71fde295430a0ff3ab98ccf596
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
  RIP: 0010:invalidate_and_check_btree_folios+0xfd/0x1ca [btrfs]
  Call Trace:
   <TASK>
   close_ctree+0x52e/0x574 [btrfs d2f0b1cd330d1287e7a9919d112eadfc0e914efd]
   generic_shutdown_super+0x89/0x1a0
   kill_anon_super+0x16/0x40
   btrfs_kill_super+0x16/0x20 [btrfs d2f0b1cd330d1287e7a9919d112eadfc0e914efd]
   deactivate_locked_super+0x2d/0xb0
   cleanup_mnt+0xdc/0x140
   task_work_run+0x5a/0xa0
   exit_to_user_mode_loop+0x123/0x4b0
   do_syscall_64+0x243/0x7c0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>
  ---[ end trace 0000000000000000 ]---
  BTRFS warning (device dm-2 state EA): unable to release extent buffer 30539776 owner 9 gen 9 refs 2 flags 0x7
  BTRFS warning (device dm-2 state EA): unable to release extent buffer 30621696 owner 257 gen 9 refs 2 flags 0x7
  BTRFS warning (device dm-2 state EA): unable to release extent buffer 30638080 owner 258 gen 9 refs 2 flags 0x7
  BTRFS warning (device dm-2 state EA): unable to release extent buffer 30654464 owner 7 gen 9 refs 2 flags 0x7
  BTRFS warning (device dm-2 state EA): unable to release extent buffer 30703616 owner 2 gen 9 refs 2 flags 0x7
  BTRFS warning (device dm-2 state EA): unable to release extent buffer 30720000 owner 10 gen 9 refs 2 flags 0x7
  BTRFS warning (device dm-2 state EA): unable to release extent buffer 30736384 owner 4 gen 9 refs 2 flags 0x7
  BTRFS warning (device dm-2 state EA): unable to release extent buffer 30752768 owner 11 gen 9 refs 2 flags 0x7

I'm using a stripped down version, which seems to trigger the warning
more reliably:

  _fsstress_pid=""
  workload()
  {
  	dmesg -C
  	mkfs.btrfs -f -K $dev > /dev/null
  	echo 1 > /sys/kernel/debug/clear_warn_once
  	mount $dev $mnt
  	$fsstress -w -n 1024 -p 4 -d $mnt &
  	_fsstress_pid=$!
  	sleep 0
  	$godown $mnt
  	pkill --echo -PIPE fsstress > /dev/null
  	wait $_fsstress_pid
  	unset _fsstress_pid
  	umount $mnt

  	if dmesg | grep -q "WARNING"; then
  		fail
  	fi
  }

  for (( i = 0; i < $runtime; i++ )); do
  	echo "=== $i/$runtime ==="
  	workload
  done

[CAUSE]
Inside btrfs_write_and_wait_transaction(), we first try to write all
dirty ebs, then wait for them to finish.

After that we call btrfs_extent_io_tree_release() to free all
extent states from dirty_pages io tree.

However if we hit an error from btrfs_write_marked_extent(), then we
still call btrfs_extent_io_tree_release() to clear that dirty_pages io
tree, which may contain dirty records that we haven't yet submitted.

Furthermore, the later transaction cleanup path will utilize that
dirty_pages io tree to properly cleanup those dirty ebs, but since it's
already empty, no dirty ebs are properly cleaned up, thus will later
trigger the warnings inside invalidate_btree_folios().

[FIX]
Normally such dirty ebs won't cause problems, as when the iput() is
called on the btree inode, the dirty ebs will be forcibly written back,
and since the fs is already in an error status, such writeback will not
reach disk and finish immediately.

But it's still better to get rid of such dirty ebs, if we ended up with
dirty ebs but the fs is not in an error status, then such writeback at
iput() time will be too late, as all workers are already stopped but
writeback will utilize workers, which will lead to NULL pointer
dereferences.

Instead of unconditionally calling btrfs_extent_io_tree_release(), only
call it if btrfs_write_and_wait_transaction() finished successfully, so
that @dirty_pages extent io tree is kept untouched for transaction
cleanup.

CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c     | 1 +
 fs/btrfs/transaction.c | 9 ++++-----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dd804bfc3a497..7916dbd138554 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -5134,6 +5134,7 @@ static int btrfs_destroy_marked_extents(struct btrfs_fs_info *fs_info,
 			free_extent_buffer_stale(eb);
 		}
 	}
+	extent_io_tree_release(dirty_pages);
 
 	return ret;
 }
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 6b9a41c939d28..245dc18e89470 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1231,14 +1231,13 @@ static int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans)
 	blk_finish_plug(&plug);
 	ret2 = btrfs_wait_extents(fs_info, dirty_pages);
 
-	extent_io_tree_release(&trans->transaction->dirty_pages);
-
 	if (ret)
 		return ret;
-	else if (ret2)
+	if (ret2)
 		return ret2;
-	else
-		return 0;
+
+	extent_io_tree_release(&trans->transaction->dirty_pages);
+	return 0;
 }
 
 /*
-- 
2.53.0



