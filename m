Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376AA4D1795;
	Thu, 17 Sep 2026 18:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789669022; cv=none; b=K7vBJzgPe0q/p5mOnhmpKC9k2SE3qn6UVzDPbKLwiI8tSacVLrBgZmzJojFi1892zklLhvSHv2a53lbAWsPy35S4l1sArKc45fSFajM+nv19PUpGaJfsAHxBcWdDH42RbmCuilHgUgSo/zDXpmGQ2RZiYSJBI9gzkBundF7QARQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789669022; c=relaxed/simple;
	bh=mEAEKnRPsalAGgSUHTbzEZj8c4++q/CI3bS1hb2U6Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnujHKQIwLiF447Gexs8wdf99iSeDc9su+kcDyn4uG8AKjHmoYV6hnhNzwQZ1zB1tnJpi8gLsyjWeupGhfVCJ2pjWeBxioVJPqW21sNUn8fqIJRjOLIqY0vAdifeoSC3nbOUAXWmzDu9CM4RN5vlhecm86oWbSv9GyWItm1NufQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cn1+PdUQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cn1+PdUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15EF1F000FF;
	Thu, 17 Sep 2026 18:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789669021;
	bh=LC2KP+PWsSLNPFlz5xP/o2uNFu6BTqsTjnya11WztMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cn1+PdUQmwlaRPTqLnt7/ZIV0MXBumtMqXeKJYtiChPgAn1Z3q1E+vpvMMft6vCxP
	 I4Az2aI0WOnMy8fm3qSRh3GEGd2VOds0nfm5V6mVWr5SPak0q048DqsVAFzdba6+tp
	 JVu7CkHQUnWj/v5UnMa50poif1ZaYyvNN8A5Lpx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0618/1102] btrfs: fix transaction use-after-free in raid stripe insertion
Date: Thu, 17 Sep 2026 16:09:21 +0100
Message-ID: <20260917151555.579287350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 4c859b550f6c3..192835b2aba06 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -122,7 +122,6 @@ static int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
 	stripe_extent = kzalloc(item_size, GFP_NOFS);
 	if (!stripe_extent) {
 		btrfs_abort_transaction(trans, -ENOMEM);
-		btrfs_end_transaction(trans);
 		return -ENOMEM;
 	}
 
-- 
2.53.0



