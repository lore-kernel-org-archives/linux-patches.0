Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510151B4F08;
	Mon, 14 Oct 2024 14:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917913; cv=none; b=Y3Z7eLE1LGXqlWrt2pwC0jweWaPSrBicPKHCJRZU7KgfTnME08TFLYOn/Rphl173yl8Lqm7xpz04YrCqLSxY+8Z90GLlaJ1iTI7QeKA9FRKr/A3Do2TOdt6T/emjJwJVNkcDjEd/PC0zg48YeF1FIUYiukItb2iFXc5jhIYH7hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917913; c=relaxed/simple;
	bh=CUR5rXAt1I9+ocyHko3JGRoim2LDZnbqZzND0U1TkYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqMvHMSyU8LxIaKFcEUJphZOl0c68KCxPMQj1YEzfuQB0Td/PPjxp5lKXdFKao2fZ8H2rcsh7D1GZVzyhMoOkREpp7f8cZIWu44E7f+ATGoRhRsty5GbSjfLcbFMgnWg0eHhSIj6e1WvgqizBFAXXPLpshbmoCuBgXsxGuqBxME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zgrLPWUM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zgrLPWUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C528C4CEC3;
	Mon, 14 Oct 2024 14:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917912;
	bh=CUR5rXAt1I9+ocyHko3JGRoim2LDZnbqZzND0U1TkYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zgrLPWUMl87Uly71rXN8A1LESTPLjXrkTXsX6TOXhZGy3w/qvYwuO22L4/9FPyEPr
	 lUoAf6FXiD2MzZV2up4OfOyeUd4ushnW5LN9Cho9lEC30F+Xdb8e/H29uK60fQzp4A
	 BYmY8dOJGPeO84hKIErsTErh9w84smurKyH/3h+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+9bff4c7b992038a7409f@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 171/798] nilfs2: fix potential null-ptr-deref in nilfs_btree_insert()
Date: Mon, 14 Oct 2024 16:12:05 +0200
Message-ID: <20241014141224.643759913@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 9403001ad65ae4f4c5de368bdda3a0636b51d51a ]

Patch series "nilfs2: fix potential issues with empty b-tree nodes".

This series addresses three potential issues with empty b-tree nodes that
can occur with corrupted filesystem images, including one recently
discovered by syzbot.

This patch (of 3):

If a b-tree is broken on the device, and the b-tree height is greater than
2 (the level of the root node is greater than 1) even if the number of
child nodes of the b-tree root is 0, a NULL pointer dereference occurs in
nilfs_btree_prepare_insert(), which is called from nilfs_btree_insert().

This is because, when the number of child nodes of the b-tree root is 0,
nilfs_btree_do_lookup() does not set the block buffer head in any of
path[x].bp_bh, leaving it as the initial value of NULL, but if the level
of the b-tree root node is greater than 1, nilfs_btree_get_nonroot_node(),
which accesses the buffer memory of path[x].bp_bh, is called.

Fix this issue by adding a check to nilfs_btree_root_broken(), which
performs sanity checks when reading the root node from the device, to
detect this inconsistency.

Thanks to Lizhi Xu for trying to solve the bug and clarifying the cause
early on.

Link: https://lkml.kernel.org/r/20240904081401.16682-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20240902084101.138971-1-lizhi.xu@windriver.com
Link: https://lkml.kernel.org/r/20240904081401.16682-2-konishi.ryusuke@gmail.com
Fixes: 17c76b0104e4 ("nilfs2: B-tree based block mapping")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+9bff4c7b992038a7409f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9bff4c7b992038a7409f
Cc: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/btree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 42617080a8384..56f7752ec19ac 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -381,7 +381,8 @@ static int nilfs_btree_root_broken(const struct nilfs_btree_node *node,
 	if (unlikely(level < NILFS_BTREE_LEVEL_NODE_MIN ||
 		     level >= NILFS_BTREE_LEVEL_MAX ||
 		     nchildren < 0 ||
-		     nchildren > NILFS_BTREE_ROOT_NCHILDREN_MAX)) {
+		     nchildren > NILFS_BTREE_ROOT_NCHILDREN_MAX ||
+		     (nchildren == 0 && level > NILFS_BTREE_LEVEL_NODE_MIN))) {
 		nilfs_crit(inode->i_sb,
 			   "bad btree root (ino=%lu): level = %d, flags = 0x%x, nchildren = %d",
 			   inode->i_ino, level, flags, nchildren);
-- 
2.43.0



