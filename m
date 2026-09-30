Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2C44FECCF;
	Wed, 30 Sep 2026 16:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784590; cv=none; b=jZ1/sKoWEJQUg6evi5Omc1ZIbjt1AzXfIodYRyRKOuhYNnP/KMEMF8i4E7UKwkZbW01Tv49dRcbo/p4m7DeasgwAimzxezdWarL+C9H1b5zt7AMCjOCVctqYqVAx1j8nCKZhgIW+c/kW8PPXIbiRkAK69JgjKaHGJqlmRnVHGJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784590; c=relaxed/simple;
	bh=CnX9Qm/D6uwdN1YafSOcMe04v3qFczFOhl2ftWuBZ2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbiL/iylrhtcq6wMBje4SrwNUipxDZGHetLlX3EYjvYCEvy95nCAjJbxbVrEuU0E/ZJWTR/75RNFtmO6/424jbdPVw8xVIDr7qpnE9rxYrZlp3UD7OSd/swVgie42XOKJZiIkdd2xGXFN87oD6kDh9U1gae++o+c3hFKLWO8/t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=brRfgiIr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brRfgiIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764C81F0089A;
	Wed, 30 Sep 2026 16:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784584;
	bh=jwSues7Jzr+bg4UnQmJjNQqOZuQ6tMml/xeaT0T1NC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=brRfgiIrJQqoNFJsDRVWcGT5X8UNB14eFhDnzjho+zORaRXe0jk4q9aPKnsAIaFBY
	 snw6hnB3fVvY/4FzEIW8Y8E4z/fRgVh1AeqA8c7xKDmT/4FZkzWll+GX59lWDiXvx0
	 rs3BUzoSTAtqZB55JQBm7WUFbKMB0FaEZlrsnmeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KangNing Liao <lkangn.kernel@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 171/982] btrfs: protect sb_write_pointer() with invalidate lock
Date: Wed, 30 Sep 2026 17:15:07 +0200
Message-ID: <20260930152420.488310711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4e2ed51297ea1..1c4f959923dd4 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -123,8 +123,10 @@ static int sb_write_pointer(struct block_device *bdev, struct blk_zone *zones,
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



