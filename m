Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0B7280A5F;
	Tue, 27 May 2025 17:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365899; cv=none; b=Oaru0ZnvSSPSarQ2mkmHk4eUF9ykTKyisugdZNIwzi0jOTL8muhklrKRM/7bFfu9bmclq7hSy3HOcbxjx3+FKGPVdGwugs/nvnR1jd8x/IIX/qaJMlo9aGfKQirlRbIk9Rxo9fdYmrztQSozyRMUXiPshw/BtG9R05XOxYcAAl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365899; c=relaxed/simple;
	bh=JDbmfF+M//nQjpTB/Y3fIg4d4vb8tBdCFCQ8BQMRcno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHKQAoKLWq98qdIOqWpS8QN6P6rBNwvmDj49FFUzFT1a6iZVMtVJoredRt1ORsCsjRpwcKS1HUpn5dOWyRsO7CRzWv56yM1VCl6ss+NqB5AfSuXWj//kbfO8Z+d87wkc0uM6yZ2Fx+4KwoYJQ9qlMhj81c+2C4N/xGhomZvxMzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sx33p4yb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sx33p4yb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA17C4CEE9;
	Tue, 27 May 2025 17:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365899;
	bh=JDbmfF+M//nQjpTB/Y3fIg4d4vb8tBdCFCQ8BQMRcno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sx33p4ybTx5XJtsB9jNPNJ77j1iJt2VkX7k1Pup+Ceg6J8wEatfZupNBecjuTTc+F
	 NrG2pKTuNmZFuwUB5CeroeSuTVn+lDCgvDt+dr6IKMZFNBxXJmwLf/7WlXmLtaCkPT
	 eYc/yU223CndmiDdBZfGx1XXiGQl+3aP2nLNuCcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 526/626] btrfs: avoid NULL pointer dereference if no valid csum tree
Date: Tue, 27 May 2025 18:26:59 +0200
Message-ID: <20250527162506.368725994@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit f95d186255b319c48a365d47b69bd997fecb674e ]

[BUG]
When trying read-only scrub on a btrfs with rescue=idatacsums mount
option, it will crash with the following call trace:

  BUG: kernel NULL pointer dereference, address: 0000000000000208
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  CPU: 1 UID: 0 PID: 835 Comm: btrfs Tainted: G           O        6.15.0-rc3-custom+ #236 PREEMPT(full)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
  RIP: 0010:btrfs_lookup_csums_bitmap+0x49/0x480 [btrfs]
  Call Trace:
   <TASK>
   scrub_find_fill_first_stripe+0x35b/0x3d0 [btrfs]
   scrub_simple_mirror+0x175/0x290 [btrfs]
   scrub_stripe+0x5f7/0x6f0 [btrfs]
   scrub_chunk+0x9a/0x150 [btrfs]
   scrub_enumerate_chunks+0x333/0x660 [btrfs]
   btrfs_scrub_dev+0x23e/0x600 [btrfs]
   btrfs_ioctl+0x1dcf/0x2f80 [btrfs]
   __x64_sys_ioctl+0x97/0xc0
   do_syscall_64+0x4f/0x120
   entry_SYSCALL_64_after_hwframe+0x76/0x7e

[CAUSE]
Mount option "rescue=idatacsums" will completely skip loading the csum
tree, so that any data read will not find any data csum thus we will
ignore data checksum verification.

Normally call sites utilizing csum tree will check the fs state flag
NO_DATA_CSUMS bit, but unfortunately scrub does not check that bit at all.

This results in scrub to call btrfs_search_slot() on a NULL pointer
and triggered above crash.

[FIX]
Check both extent and csum tree root before doing any tree search.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index c73a41b1ad560..d8fcc3eb85c88 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1541,8 +1541,8 @@ static int scrub_find_fill_first_stripe(struct btrfs_block_group *bg,
 	u64 extent_gen;
 	int ret;
 
-	if (unlikely(!extent_root)) {
-		btrfs_err(fs_info, "no valid extent root for scrub");
+	if (unlikely(!extent_root || !csum_root)) {
+		btrfs_err(fs_info, "no valid extent or csum root for scrub");
 		return -EUCLEAN;
 	}
 	memset(stripe->sectors, 0, sizeof(struct scrub_sector_verification) *
-- 
2.39.5



