Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386DA5476C2;
	Thu, 17 Sep 2026 15:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659258; cv=none; b=bi3xW7GXlHAaSYWICRfvyvEqI/N26EFIsG9ZmdcaPMEcR0F6xJ1ro6I6g43YKDmySUdN/rN/ATGDWHe95dfL7B31zyisqCnasLaN966xsqifYNJvWbQUOU5l5zjrKbg4z1MFJQN7Xss8XWDx72OAZVImOdBNWO5SklsJF0qS/fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659258; c=relaxed/simple;
	bh=Zu2OHyGPuZymDK0BpGJBwdth12auDsDHjWyy76VIVyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJQ8HYV2v9xo58RAnbocPsM4nEShzWZ3+9o5WfKmR9LWd7rwdlpKycn/udu3V20OvyYOhaeycyy8L1DvJQjA+wEkI6alhT9P4ISUp+84WD87JxhGJaXStwx3nGzb0Hdiox/zEE9pMXPM06K3JiOhHK3hWHJA9t7n3qstAPX3FtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrq77zmN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrq77zmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2771F000FF;
	Thu, 17 Sep 2026 15:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659248;
	bh=/YeL4zvtiBTPc6kOQUIC5n25yb0uRNUQcnBAHR6+DP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jrq77zmN3j5nLtnKHWGUzj46kakLzzhyBc5XVLPZerriC+iOwSXcRocHGK+dtRSTL
	 O9egBLTRP0QNJPcpm1em5Jkwb/xAVJ+GnYrwr7EWzKreSEgFs9icHHg4qG+Lw+Fh76
	 tfYo1Dyo8+X9d94iHB4gQjNonTP3lGiMwpr2nUQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 192/733] btrfs: fix transaction use-after-free in raid stripe insertion
Date: Thu, 17 Sep 2026 16:08:20 +0100
Message-ID: <20260917151355.932414415@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

[ Upstream commit a8813a923f9e43f788b357fb55c35f7f6ed6f98c ]

If allocation of a RAID stripe extent fails,
btrfs_insert_one_raid_extent() aborts and ends the transaction before
returning -ENOMEM.

btrfs_finish_one_ordered(), the production caller through
btrfs_insert_raid_extent(), still owns the transaction handle. It handles
the error by aborting the transaction and then reaches the common exit
path, which ends the transaction again.

The premature end can free the handle and drop its transaction reference.
Transaction cleanup can then free the transaction before the caller's
second abort accesses the handle and transaction, resulting in
use-after-free.

Keep the abort at the failure site, but let the caller's common exit path
end the transaction once, after it has finished using both objects.

Fixes: 02c372e1f016 ("btrfs: add support for inserting raid stripe extents")
Assisted-by: Codex:GPT-5
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/raid-stripe-tree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index b210371ce91e3..89e259a47d8de 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -337,7 +337,6 @@ int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
 	stripe_extent = kzalloc(item_size, GFP_NOFS);
 	if (unlikely(!stripe_extent)) {
 		btrfs_abort_transaction(trans, -ENOMEM);
-		btrfs_end_transaction(trans);
 		return -ENOMEM;
 	}
 
-- 
2.53.0



