Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C167DA7D;
	Thu, 15 Aug 2024 13:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730336; cv=none; b=o7Q10Ukprdy/aoUQbo1YMuyTOqDUUpSfN6aIobqOHWfE0Fmf61FYth7GrHfhPek/eehyJGYLpCA6J6A9yHYY3gSyuPf7WyYNB1T2nBDiHapmiGuHF9n6lxK1tiTpb4ugrLT5bIotB8OvMbfJBH+x76hQVFW8jvqJPICCYn4RC4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730336; c=relaxed/simple;
	bh=0wDkmZiK9LD5tGX7deVWDP5Qje8ipysrlir9Mhn8onI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVfPxmi5cQCAsIQFZSwJ4dX31RWThIAayWtBwj8yeQv76vj6oaSt37tNyobtQMUftB3VIsdnS3ryLKNgVDfAyjHTexb6j3BDg7pRCTHaHtULCyG7QJm2AdcntqPDogz8NS+wEiJHwdAY/988xJq3XmiD/Ixi9/T6mTR0Brkztcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylgTznnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylgTznnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD286C32786;
	Thu, 15 Aug 2024 13:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730336;
	bh=0wDkmZiK9LD5tGX7deVWDP5Qje8ipysrlir9Mhn8onI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylgTznnKOcx6Q43WzIEhiGBcbBBE+yBaasxWBOijMtOjGYF5N5BToe7a6J1lzLcN9
	 ysRsQ0yqOTV7czifrbAOxqFAnLb5m9EwDWi9ldiXsOXzJBvHIngYTbgSGIy6j/xl9n
	 99fTwXmgucF9TjS3nuDpgctOypVOD7cLGjQnDPxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 377/484] btrfs: fix bitmap leak when loading free space cache on duplicate entry
Date: Thu, 15 Aug 2024 15:23:55 +0200
Message-ID: <20240815131956.007128257@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9161bc4f40649..0004488eeb060 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -829,6 +829,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 				spin_unlock(&ctl->tree_lock);
 				btrfs_err(fs_info,
 					"Duplicate entries in free space cache, dumping");
+				kmem_cache_free(btrfs_free_space_bitmap_cachep, e->bitmap);
 				kmem_cache_free(btrfs_free_space_cachep, e);
 				goto free_cache;
 			}
-- 
2.43.0



