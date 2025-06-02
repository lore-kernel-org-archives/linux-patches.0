Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6833123817A;
	Mon,  2 Jun 2025 14:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874006; cv=none; b=AQEe/AFbM2FMvpHGMEeVB2yD1l/GZgYfFpGZJrJEctL9pZqUpFDYKdsUY90ohtiQasM5S16TBUPT1WTIyn8wHNAaK0uKUuWVVcZB8mJNrBng+Fniu/MuQB2ywbDcvUxREXP+M9i/W8zS9uOg7jRB3L5woxoGqxf+AGsL/tPvY4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874006; c=relaxed/simple;
	bh=LJ0MC24dtdL14j+6c58QIiuKDFmdko5X8iBuxmhicpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCSEbIemNNRtYmmzCKpvoRgjGK+cKlBnvsS0O9cag8MR969ICnLsN6Ya3wLWiYJ5SshsMpSQbNSWwFBfpWnzHpvYtPMhYOUe7vXuHjx3Z/UGUbt5agdjN3OiiDYBoWT7zIEe1h5k/e/38tXa2yORXFbNEEE7wx9RxTD1fWNalQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7VYPuJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7VYPuJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE726C4CEEB;
	Mon,  2 Jun 2025 14:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874006;
	bh=LJ0MC24dtdL14j+6c58QIiuKDFmdko5X8iBuxmhicpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7VYPuJANeq28I9d8bqu93df4AGmYXz9TL/jARuCTD/6Hu2//ZV4iHnFhmQC9l/BA
	 6xZ6T+bUXP41+1mNEPb969/DSMmr8r9R31J3B29fcQsyfO1+avIhtk/heySWD7qyEZ
	 4pstILBI2L0cQJmm55S0cmPkIaZsHr3c3w86mr5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 325/444] btrfs: avoid NULL pointer dereference if no valid csum tree
Date: Mon,  2 Jun 2025 15:46:29 +0200
Message-ID: <20250602134354.134657121@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6be092bb814fd..da49bdb70375b 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1538,8 +1538,8 @@ static int scrub_find_fill_first_stripe(struct btrfs_block_group *bg,
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



