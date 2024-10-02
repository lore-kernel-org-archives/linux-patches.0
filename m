Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E3C1CF7D4;
	Wed,  2 Oct 2024 14:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879787; cv=none; b=AcfqPokqqQ+N34OoNmQIiHpyJMBnBkrHOmTubdS71vEuvm1wUb4Uda+sMy4FtEnDhA8x+fnUlSDYvpIo4BgqAOCDdItVzQD/HJA9Rr4uAmZxRDaF8DjgPocjehTtH7dKWjNla5qSbS1P1LDwCJYbh2B9KeBlqDgVn6ePrk2ZaFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879787; c=relaxed/simple;
	bh=oRD5dnKDm7D41oAQtfzV0Nh/ZULD9hb32Ok3q/DLB1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVJ8Mu29tA1mujueAftI9q3QYpuHSRgu1nEA/widDXVpTKvdELeSiHiZvKo+/rk5H0ynNdwJaIzbQha7ls0wtblODCq0LF09MvuSr0sBQAI1m915s+OsRKbRJ6H7/e1J0KLXOXuJxa2T+mAj3sR23ErTcg6QWUii56bn7C6dFhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGu2Qy7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGu2Qy7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE1EC4CEC2;
	Wed,  2 Oct 2024 14:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879787;
	bh=oRD5dnKDm7D41oAQtfzV0Nh/ZULD9hb32Ok3q/DLB1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGu2Qy7DkfamNe+0gG1zYxDmopE5Pk8kzCY5tO2qqPZjuI7kiqGRLOhsbRhvyMqeb
	 94rwdSIbLaP7JJYIiOLzyNVgRwCT8g+zoJERjNKyHqLyilzxGD2ktq8zZIR0Y//ZA/
	 64m/EVriXwqB4du3abNBhYrMaetyQ2O/DfzE/Ghg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+9bff4c7b992038a7409f@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 239/538] nilfs2: fix potential null-ptr-deref in nilfs_btree_insert()
Date: Wed,  2 Oct 2024 14:57:58 +0200
Message-ID: <20241002125801.684440077@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 598f058670595..fa51ed649968e 100644
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



