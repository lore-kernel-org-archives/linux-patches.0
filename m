Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235721AC893;
	Thu, 15 Aug 2024 14:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732740; cv=none; b=dYuEMWq/sY1QH88vmyQEf2ccTZTPBglzCwCGUdq7SoeL44FLlBZcEBgrjHVOFuFgF1rwoSSke/3LRlDi/v0VFh/ytYGaI4ckVACPsVkCN6m9ccWCzGGLQ52FE5uIaHkAfRcRFca+jYQ2i2K4tvv/inkZBWAd2X7FOgPTBQUudpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732740; c=relaxed/simple;
	bh=WCdFpOBj50uSNiJvHpME9an8b1zf1uA5ERRFPrNcabI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AK777eUwCRGTFB6Uftk8/wUk4JKLt6wVVPsihnp2cEpXFBGyfE63/YRqCU8PJkqDlIjGvdEnlPEBOixybdMQ+E6Fx5HEPbhkrAoiopIidLIVBIgUwNh3wbpsssfNJbIGY2vzeRZAQP/+fhoFDhGKTG936cvhFFwK3kstegT7Gl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ek+8bFiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ek+8bFiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474E4C32786;
	Thu, 15 Aug 2024 14:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732739;
	bh=WCdFpOBj50uSNiJvHpME9an8b1zf1uA5ERRFPrNcabI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ek+8bFiI/03v4KwrAb1aYtQYyT+jrgaQoQF71P588b+YZa7IMBNq4WWkUE5ihZyeU
	 Ttib0w1+z2kgg519dw6xv1bfemtuzOwP30qsYkKeKSjP51JhiddpJCIroN8c2kAZhf
	 34KO+7AkRlo5tqI+Wt82AllTGlAbyfuTVuRDtq34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 271/352] btrfs: fix bitmap leak when loading free space cache on duplicate entry
Date: Thu, 15 Aug 2024 15:25:37 +0200
Message-ID: <20240815131929.925714640@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4989c60b1df9c..af52c9e005b3c 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -798,6 +798,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 				spin_unlock(&ctl->tree_lock);
 				btrfs_err(fs_info,
 					"Duplicate entries in free space cache, dumping");
+				kmem_cache_free(btrfs_free_space_bitmap_cachep, e->bitmap);
 				kmem_cache_free(btrfs_free_space_cachep, e);
 				goto free_cache;
 			}
-- 
2.43.0



