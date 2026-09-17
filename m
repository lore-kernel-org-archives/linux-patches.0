Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0454E5336;
	Thu, 17 Sep 2026 17:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665501; cv=none; b=dLZMNtcxzdxZwUUnH9uGQ5mKR8K79Xf4hKJaSVWMSWz8s4hW0J406DKrjBJaA1X2h49VUQsm9a4wLOCtqDoJg9Ii0zL9NPIi87IuAWu5TOxlKvhSVg7rrEBIK3T6D/kB8Qdg/5LbzuyyAq98P5xgIlyJqIHvQr7ICQSeWGeEJ7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665501; c=relaxed/simple;
	bh=J73lCs4tGjaedUXND5f4bvZBMBx8YHk9TbtWGlrO+y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+w2gNpd7rloXedO5fX64a5DsGlho6vpbNlEg2ioYEHmYm+mfpFTwXPI8O8DunDbVCkKb2NsNba4lCSXpsQ/I3uujoy8aOykbrQDiOc0fS2Y6TNYyOG1vem245tG2KhA1swklReLJ+VeMIpZpYTi8g/8PMHf9Uqo1ew/R1IQGvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKbiaZoC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKbiaZoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842A51F000FF;
	Thu, 17 Sep 2026 17:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665500;
	bh=3E4se9rUDeuyfZRJau2IvhdJbdXoS4Np230eLz13euE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CKbiaZoCCszTVaSLVSgCnWciCymIbbc1NomylDlPZJIW/mKh9CscNRNqA01PZM6Fu
	 xWoInOal3q415avlLnvqP1vP4OJiKfhw2t8rTsxbCBMp0SxLKUX2oDGExOW8DuhG+e
	 YvnRCt1WesHliSpfFm8lLCyy5yvhAHCpnKfX6Fv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0724/1250] btrfs: fix transaction use-after-free in raid stripe insertion
Date: Thu, 17 Sep 2026 16:08:39 +0100
Message-ID: <20260917151611.513543155@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index f6f02463dd1a9..2daf66172e2a8 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -306,7 +306,6 @@ int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
 	stripe_extent = kzalloc(item_size, GFP_NOFS);
 	if (!unlikely(stripe_extent)) {
 		btrfs_abort_transaction(trans, -ENOMEM);
-		btrfs_end_transaction(trans);
 		return -ENOMEM;
 	}
 
-- 
2.53.0



