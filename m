Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331123214;
	Thu, 15 Aug 2024 14:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731763; cv=none; b=JLK5A5eqDYw/0TWcKjAXFQv37nQTv8G1TWlPki7Ppw/E6jpAYLkpFMpCLHKQEd3wq+gHegXjKX7v1LoXPsKCWzxSGxRzzUNp6GmAPjp35kpNizqzFwvGMTMp6QvPck55dlCWecIUV0CwLr9VKK1bPar6XjwD9JTH5AF1ODulYt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731763; c=relaxed/simple;
	bh=XAf1L0JX+kGP7Th2SSmuhyZbiwiz0a38VLJjVVWncvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMqVqxzaL8Cnosv/xs7rBmWncOgRoERLrFVaQLkP5IbKc2tqr3/BNg3hKkhP6m6xiu96+SZxl5dvxQzzUruNvsRNG6vQ2tQS+6PRn6bNGF4lPDbL37O82e4jmZHuPdDVksBajuzp9kd069Q7m9L9/EHHPbsS4capo2DyPeKSzNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJATKC8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJATKC8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF369C4AF0D;
	Thu, 15 Aug 2024 14:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731763;
	bh=XAf1L0JX+kGP7Th2SSmuhyZbiwiz0a38VLJjVVWncvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJATKC8FuTVcLt71rShFNnReHnXIADmB1BkihjMl3QCPZJRmI94CuNUzk2MXbII5n
	 2+WQVKlUA6n+MJzFN3YCRI4zo1VGlSQrGSeEu8u7dJnLkflMKfUwun9jEKFAfrv3mL
	 aL560rlDZkBEYhl8mnQvMk8dp8pOnIVOmt3B6vPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 200/259] btrfs: fix bitmap leak when loading free space cache on duplicate entry
Date: Thu, 15 Aug 2024 15:25:33 +0200
Message-ID: <20240815131910.498765463@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 320d8dc612660da84c3b70a28658bb38069e5a9a ]

If we failed to link a free space entry because there's already a
conflicting entry for the same offset, we free the free space entry but
we don't free the associated bitmap that we had just allocated before.
Fix that by freeing the bitmap before freeing the entry.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/free-space-cache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 0cb93f73acb2d..af89fce57ff75 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -788,6 +788,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 				spin_unlock(&ctl->tree_lock);
 				btrfs_err(fs_info,
 					"Duplicate entries in free space cache, dumping");
+				kmem_cache_free(btrfs_free_space_bitmap_cachep, e->bitmap);
 				kmem_cache_free(btrfs_free_space_cachep, e);
 				goto free_cache;
 			}
-- 
2.43.0



