Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9981E520A;
	Sat, 17 Oct 2026 16:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253964; cv=none; b=eqObOttI+dymx/23pE64MYsPIlJNSCP9uD89rUByHrTO31ykLNCQwxGZJB/A7U/3XlzNI1D8YxJPSdkrmv3+niNFxoytN6MlXPtTAOpTBWDpKEPyVRqpfe0Hs+DUcfz+J3qyne+hIHxIz5zrGhE38VBsQTLZkcc6T/dTyvr4d74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253964; c=relaxed/simple;
	bh=qPK5/Hfdy0SvzxIXbgFVYUKnlhb3YmQ9SxPYhdxbKu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLyNpVdllaq3YYb23Tg5DrVxRFVYVhDie49ny4Y65RF56ROZ8XUgbXqkVycTYPD1J/HpQK5evaEzZpvTwnOZfWu6LrZftL0RnIXZCBF0QTocWE8bXG1lS3vjJD9AafftpIZ3K2ztd5llw2xRP1Zoa5aqlFM4To2tRq3PLqoCDkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uafrUSa+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uafrUSa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B3A1F000C4;
	Sat, 17 Oct 2026 16:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253963;
	bh=fik0/neDpK/tUGAvAU5pguP6rY383suZ0Y5sg0Nj5HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uafrUSa+nfeDfLXpyiYkJVR8TJOQZQ9vDniqR9EWyPNrQsgOpkCiWo4MJGSgky8hR
	 KIZz/3mNHb2A5+25ZizHzM56t+hxkN+tvvK2LA0o2EuYrs7LLeSFYKbpLN3uYHWOWA
	 cLtU+nO+esSe128oNd3LqRXh/GkLV0w21ZGdqJsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 251/869] btrfs: do not ASSERT() when the fs flips RO inside btrfs_repair_io_failure()
Date: Sat, 17 Oct 2026 17:51:32 +0200
Message-ID: <20261017160043.492673878@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 8ceaad6cd6e7fa5f73b0b2796a2e85d75d37e9f3 ]

[BUG]
There is a bug report that when btrfs hits ENOSPC error in a critical
path, btrfs flips RO (this part is expected, although the ENOSPC bug
still needs to be addressed).

The problem is after the RO flip, if there is a read repair pending, we
can hit the ASSERT() inside btrfs_repair_io_failure() like the following:

  BTRFS info (device vdc): relocating block group 30408704 flags metadata|raid1
  ------------[ cut here ]------------
  BTRFS: Transaction aborted (error -28)
  WARNING: fs/btrfs/extent-tree.c:3235 at __btrfs_free_extent.isra.0+0x453/0xfd0, CPU#1: btrfs/383844
  Modules linked in: kvm_intel kvm irqbypass
  [...]
  ---[ end trace 0000000000000000 ]---
  BTRFS info (device vdc state EA): 2 enospc errors during balance
  BTRFS info (device vdc state EA): balance: ended with status: -30
  BTRFS error (device vdc state EA): parent transid verify failed on logical 30556160 mirror 2 wanted 8 found 6
  BTRFS error (device vdc state EA): bdev /dev/nvme0n1 errs: wr 0, rd 0, flush 0, corrupt 10, gen 0
  [...]
  assertion failed: !(fs_info->sb->s_flags & SB_RDONLY) :: 0, in fs/btrfs/bio.c:938
  ------------[ cut here ]------------
  assertion failed: !(fs_info->sb->s_flags & SB_RDONLY) :: 0, in fs/btrfs/bio.c:938
  kernel BUG at fs/btrfs/bio.c:938!
  Oops: invalid opcode: 0000 [#1] SMP NOPTI
  CPU: 0 UID: 0 PID: 868 Comm: kworker/u8:13 Tainted: G        W        N  6.19.0-rc6+ #4788 PREEMPT(full)
  Tainted: [W]=WARN, [N]=TEST
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
  Workqueue: btrfs-endio simple_end_io_work
  RIP: 0010:btrfs_repair_io_failure.cold+0xb2/0x120
  RSP: 0000:ffffc90001d2bcf0 EFLAGS: 00010246
  RAX: 0000000000000051 RBX: 0000000000001000 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: ffffffff8305cf42 RDI: 00000000ffffffff
  RBP: 0000000000000002 R08: 00000000fffeffff R09: ffffffff837fa988
  R10: ffffffff8327a9e0 R11: 6f69747265737361 R12: ffff88813018d310
  R13: ffff888168b8a000 R14: ffffc90001d2bd90 R15: ffff88810a169000
  FS:  0000000000000000(0000) GS:ffff8885e752c000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  ------------[ cut here ]------------

[CAUSE]
The cause of -ENOSPC error during the test case btrfs/124 is still
unknown, although it's known that we still have cases where metadata can
be over-committed but can not be fulfilled correctly, thus if we hit
such ENOSPC error inside a critical path, we have no choice but abort
the current transaction.

This will mark the fs read-only.

The problem is inside the btrfs_repair_io_failure() path that we require
the fs not to be mount read-only. This is normally fine, but if we are
doing a read-repair meanwhile the fs flips RO due to a critical error,
we can enter btrfs_repair_io_failure() with super block set to
read-only, thus triggering the above crash.

[FIX]
Just replace the ASSERT() with a proper return if the fs is already
read-only.

Reported-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/linux-btrfs/20260126045555.GB31641@lst.de/
Tested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/bio.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 5fd0b39d8c703..6225f9d045efe 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -812,9 +812,15 @@ int btrfs_repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
 	struct bio bio;
 	int ret = 0;
 
-	ASSERT(!(fs_info->sb->s_flags & SB_RDONLY));
 	BUG_ON(!mirror_num);
 
+	/*
+	 * The fs either mounted RO or hit critical errors, no need
+	 * to continue repairing.
+	 */
+	if (unlikely(sb_rdonly(fs_info->sb)))
+		return 0;
+
 	if (btrfs_repair_one_zone(fs_info, logical))
 		return 0;
 
-- 
2.53.0



