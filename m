Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9C61AB534;
	Tue, 15 Oct 2024 11:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992747; cv=none; b=ihTccpnHZ8YcyOK8lNFMYEMKTJQ2kkfwOxTJEwm8f/pa5znQdYY4guIWdaSTJtYFWKxf31EiYQuU6LCu+Vyye8bHSOQV6LarESuTabpyRWv3mNODhbF8HGnuiMyJ2b/kT/d4t/jiTwr7IhN1WK0VQcdx5FR95hqmyWH8n4GgIvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992747; c=relaxed/simple;
	bh=FtFlSixlEgjcrhu+j9BmtgKu5FRuK17AaVIhImuxvec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k50t1HYaPswYLwjJ+0daJ9l2iFQd5Bsq/cP+/fz7nBK+VbDgHAP+NZacXMaqCIPHUjyDEvMBaWSq2Vo4HNg6ZD3F4w2pPupRt5a+oV6BHP+jhwsW4n1jH001ts61f16P9p++49Ld+yGsndPSMaK0y3EM3FGDTUh5U5ZPjysVvr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXJcof/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXJcof/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDC5C4CEC6;
	Tue, 15 Oct 2024 11:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992747;
	bh=FtFlSixlEgjcrhu+j9BmtgKu5FRuK17AaVIhImuxvec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXJcof/IcbpX26ci1cMDW/MNfIOqN5QIoShOMhWbbdz7lYS/9qUmGf3O0onX9Anht
	 bys+5kxPEZpyjhYXnbl3z4KYC7c3Xq9bul7WMdSeNv2fcfHGQWCNOQBhg633gjaLp+
	 exxBu+RaX6qUB2yQ+zOmo4jcIiiUivnD713T4f1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 205/691] ext4: avoid buffer_head leak in ext4_mark_inode_used()
Date: Tue, 15 Oct 2024 13:22:33 +0200
Message-ID: <20241015112448.497215422@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
index 745d781da8915..4478ba2e8cc54 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -756,10 +756,10 @@ int ext4_mark_inode_used(struct super_block *sb, int ino)
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
@@ -862,6 +862,7 @@ int ext4_mark_inode_used(struct super_block *sb, int ino)
 	err = ext4_handle_dirty_metadata(NULL, NULL, group_desc_bh);
 	sync_dirty_buffer(group_desc_bh);
 out:
+	brelse(inode_bitmap_bh);
 	return err;
 }
 
-- 
2.43.0



