Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1971A3E7151;
	Wed, 30 Sep 2026 19:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795147; cv=none; b=U0Aqqlf2Dg+r8p4dJFOGd8LVnKr/hPv5BUxFtyS8vkn7kFvAlyE6Hzfcq7YyymxmMfdt3d0D44JO2lD6gAfwzaC3uVR/YcBKlfsA70wFV9j8OEgz8nQ0eULmD6Ezqzjaic8bOQTaFXzv7jnz2vKPQoLfywoEmsRSuPtDZ+2j+6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795147; c=relaxed/simple;
	bh=OighnhKKFoK2NZrnefeOZUCibKd8KdJ8tmqf8yWQbEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcM0FiKtFmKwX8vbXZjbCb7HoYzjkJCduHxCr0KsHrTaoCmPctvkt72mOxZpHi1NdMkwNKsLmzyYbTslnuIwXGiaOAEL/KVRxp7LasH+9cbdLAOv7313Fgi0BhLKYzPFdHOtioIyP/TK26NVig/9YdZKFpTxjejkpzJqjr/GFCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yct84bp9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yct84bp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36EBA1F000FF;
	Wed, 30 Sep 2026 19:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795145;
	bh=UXR8cQD++VPrevFNbAXC5YcFrbWth86dHTG7WwspRek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yct84bp93mt42lzPumN5FMFYPvPYqJlSghsyqse0dubKct5gqDTOCypr16BvHS/oF
	 ecdwaDBWVzLGHtk3Ekpwawq1AqXurlx1YeVxYtz2v1oDWniXR9WOvCdAHAxzld9wBN
	 r6PxaQXp9Rtd4B82F6dv7M4GdFkup3jGShn3Tr70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0458/1193] btrfs: fix transaction use-after-free in raid stripe insertion
Date: Wed, 30 Sep 2026 17:19:02 +0200
Message-ID: <20260930152444.349052748@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index c093e0bbb7be3..38917236bbb95 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -29,7 +29,6 @@ static int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
 	stripe_extent = kzalloc(item_size, GFP_NOFS);
 	if (!stripe_extent) {
 		btrfs_abort_transaction(trans, -ENOMEM);
-		btrfs_end_transaction(trans);
 		return -ENOMEM;
 	}
 
-- 
2.53.0



