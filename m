Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347931D1317;
	Wed,  2 Oct 2024 14:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878027; cv=none; b=R4/hF6MwaGuHcqx4a9CgW/IUNwu0tVyz8HpotTIg22vu0YLMwaNPnRmSWYFU5PzH/Xk4O5+OG5ITHwREZ6djVxIUOXi315qjS1W/1rxw5llxzbdTl3fLyRxeeoIbJ3Nh+z/IeLRXT2O5i1DJQ+toalCj2FsHT/kWi+e/hNOrqBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878027; c=relaxed/simple;
	bh=GDazl1KXQJjCZfSWYjWfZkGJ+JwIWG/NIVuCbalUno8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXx0e+J6GB3LwS4dV9rKU37WpUSqwvQK3dhp6Ysodse6m0BM+2s/iJqVMMuzxn2OFhCZuPgNGT867wg9AYyZdhz8Tr8r6J/lRKu5SpxHHXVHfpfK6QmLxzeAS3V/g03EMYQauyESxSvgMJy9yDmItRxwhXU7UPYPmFtNqEm2nSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4keIXYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4keIXYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF484C4CEC2;
	Wed,  2 Oct 2024 14:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878027;
	bh=GDazl1KXQJjCZfSWYjWfZkGJ+JwIWG/NIVuCbalUno8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4keIXYFMpqhaekFTmDbNhBaFlrwXkNgBeVCzxZTCkSu23Ysw+JnjgtYRI8RFH8En
	 zTgreTgLoGvi5K/QBavVmzj309Wlz+7vCnoAF4lGkJNNTTW43gBv+ti2CZ5ryVusG5
	 X6phGYIwnGe/ECPIVorsr8o1SBM2Fygw+icltBuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 277/634] ext4: avoid buffer_head leak in ext4_mark_inode_used()
Date: Wed,  2 Oct 2024 14:56:17 +0200
Message-ID: <20241002125822.034965240@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 5e5b2a56c57def1b41efd49596621504d7bcc61c ]

Release inode_bitmap_bh from ext4_read_inode_bitmap() in
ext4_mark_inode_used() to avoid buffer_head leak.
By the way, remove unneeded goto for invalid ino when inode_bitmap_bh
is NULL.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Link: https://patch.msgid.link/20240820132234.2759926-2-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ialloc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index e9bbb1da2d0a2..bf14450da35f4 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -755,10 +755,10 @@ int ext4_mark_inode_used(struct super_block *sb, int ino)
 	struct ext4_group_desc *gdp;
 	ext4_group_t group;
 	int bit;
-	int err = -EFSCORRUPTED;
+	int err;
 
 	if (ino < EXT4_FIRST_INO(sb) || ino > max_ino)
-		goto out;
+		return -EFSCORRUPTED;
 
 	group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
 	bit = (ino - 1) % EXT4_INODES_PER_GROUP(sb);
@@ -860,6 +860,7 @@ int ext4_mark_inode_used(struct super_block *sb, int ino)
 	err = ext4_handle_dirty_metadata(NULL, NULL, group_desc_bh);
 	sync_dirty_buffer(group_desc_bh);
 out:
+	brelse(inode_bitmap_bh);
 	return err;
 }
 
-- 
2.43.0



