Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1796D611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:40:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9755AC433EF;
	Sun, 28 May 2023 19:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302852;
	bh=+FJ8yemOT7JWdrZ6udMvaPqghNpIDUBbIN3TbfOTubo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JdMrN08mZC9DDA8JMFuwMdKVHq5hs8ZtVG0exX2Y6SG+IGyH9nDgD8BJcAY1j10CI
	 OBBejVFWcf8RdWWDkrTWeAKyKpFAAQANocm/UjKvFLsIz1djIWoEqUmAQL65/qZ5Yd
	 RsW9mtPTXoeD1E/GANsSzzEyj4ik6nDOaK2Q9kZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunguang Xu <brookxu@tencent.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/211] ext4: remove redundant mb_regenerate_buddy()
Date: Sun, 28 May 2023 20:09:06 +0100
Message-Id: <20230528190844.144081608@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chunguang Xu <brookxu@tencent.com>

[ Upstream commit 6bd97bf273bdb4944904e57480f6545bca48ad77 ]

After this patch (163a203), if an abnormal bitmap is detected, we
will mark the group as corrupt, and we will not use this group in
the future. Therefore, it should be meaningless to regenerate the
buddy bitmap of this group, It might be better to delete it.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/1604764698-4269-2-git-send-email-brookxu@tencent.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 5354b2af3406 ("ext4: allow ext4_get_group_info() to fail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a7c42e4bfc5ec..708a5fa3c69f6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -822,24 +822,6 @@ void ext4_mb_generate_buddy(struct super_block *sb,
 	spin_unlock(&sbi->s_bal_lock);
 }
 
-static void mb_regenerate_buddy(struct ext4_buddy *e4b)
-{
-	int count;
-	int order = 1;
-	void *buddy;
-
-	while ((buddy = mb_find_buddy(e4b, order++, &count))) {
-		ext4_set_bits(buddy, 0, count);
-	}
-	e4b->bd_info->bb_fragments = 0;
-	memset(e4b->bd_info->bb_counters, 0,
-		sizeof(*e4b->bd_info->bb_counters) *
-		(e4b->bd_sb->s_blocksize_bits + 2));
-
-	ext4_mb_generate_buddy(e4b->bd_sb, e4b->bd_buddy,
-		e4b->bd_bitmap, e4b->bd_group);
-}
-
 /* The buddy information is attached the buddy cache inode
  * for convenience. The information regarding each group
  * is loaded via ext4_mb_load_buddy. The information involve
@@ -1512,7 +1494,6 @@ static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 				sb, e4b->bd_group,
 				EXT4_GROUP_INFO_BBITMAP_CORRUPT);
 		}
-		mb_regenerate_buddy(e4b);
 		goto done;
 	}
 
-- 
2.39.2



