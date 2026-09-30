Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CB823ABBE;
	Wed, 30 Sep 2026 18:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794496; cv=none; b=uXuCZtY1ybYrM8VqWFCNARBI8wMXxx3W8Tp2iC4SoVPRi0SG0hDlrxSAvvX1QOBWCliec0fLEOVmB70XPvFG5tZRpM+jvCWXDH3a9nUdhxijZ4ETd4P5kvhuF0pje2KA3eYfgs2F4ubh5iyuer4YDo7QVH/KxQzHmtGTak4BO3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794496; c=relaxed/simple;
	bh=kydA5tql3/Zvwz2EfZkB9HFtlVCZj+3nINZqZiJrQSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1CKmN0nX1N7oY5iYAgDM5a3QhZnZMkgtRH6KhS6+M55Z2VXb6+9aPRYrAmy9sgL46y+ray+wCM4fSLkHKe/Sk2Q2Fc5wabP1LWNj3agJEPBPIET0J8LGk1yg1n/8vU2LvEzH7f22KvoWCv/z2n1Qrxm4RBMmHQ8WwPf2Rs3D1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYeHnjE8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYeHnjE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE91B1F000FF;
	Wed, 30 Sep 2026 18:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794495;
	bh=yLZJW6zW4nWqhL0cDsvMiEU4yBaRjx5si/DbawzQrCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYeHnjE8eCXEDh3+77EwB12TTxDEH4LmK53AUTBSqW0Vh8dhUhMonmVxelgjnLfNO
	 VXRNUdoLkdqsW2d1M1nA+5VVZUtc4cFHJ/syGO3idrW7u1EKSD3pjqQ5gtldgqJELs
	 6BJJUFhNLnr3JReWdIUiDSQUOGtR09KH9u212MiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KangNing Liao <lkangn.kernel@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0197/1193] btrfs: protect sb_write_pointer() with invalidate lock
Date: Wed, 30 Sep 2026 17:14:41 +0200
Message-ID: <20260930152438.580794417@linuxfoundation.org>
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

From: KangNing Liao <lkangn.kernel@gmail.com>

[ Upstream commit 123b9a545f4d0348e81f558a032bf2a93ee5722f ]

sb_write_pointer() reads the super block from the block device page cache
using read_cache_page_gfp(). This has the same race with BLKBSZSET as the
one fixed by commit 3f29d661e568 ("btrfs: sync read disk super and set
block size").

Take the mapping invalidate lock around read_cache_page_gfp() to
serialize the read against block size changes.

Signed-off-by: KangNing Liao <lkangn.kernel@gmail.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index b704df009fc5a..92ec2d91c41fe 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -130,8 +130,10 @@ static int sb_write_pointer(struct block_device *bdev, struct blk_zone *zones,
 			u64 bytenr = ALIGN_DOWN(zone_end, BTRFS_SUPER_INFO_SIZE) -
 						BTRFS_SUPER_INFO_SIZE;
 
+			filemap_invalidate_lock(mapping);
 			page[i] = read_cache_page_gfp(mapping,
 					bytenr >> PAGE_SHIFT, GFP_NOFS);
+			filemap_invalidate_unlock(mapping);
 			if (IS_ERR(page[i])) {
 				if (i == 1)
 					btrfs_release_disk_super(super[0]);
-- 
2.53.0



