Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C501C07C9;
	Tue, 15 Oct 2024 13:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997342; cv=none; b=mfhMHmDAOVsmpFZI4K5RNaLwG8xTtn436NLsXIgHH1IQ+vK3wlZkfFKqTYfbiMJiuD/yzQeR0tuEdM1hvNXCnJX/KBa2VUDTDgKHPNk029G1ZVSeMLCHo1yHy/GTFt7YN1GEM5Omu+NbHer8iBeU5IfeOCzY8gIEyEHq9Kb8aQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997342; c=relaxed/simple;
	bh=pI5cZthNTSgyqtN7rfDIx9ls+MtMAlnBj76Bxn9RekA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdgrvA8IMb7jXvOU36/xm7ROUO7GFPr4rEBqCYnqcFh6PtLlSPkVvGRL0e3DT2t9jxkZFMmAw+x8AcPwzfl4wzqvdoBlxHGHT9NTJzW4mWajJb7Wk19n2qtW8NbkiNNpZJnmtabcHUTTsY8mveVJpeZ2umoXDbTpy8QDSzLkm3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDAnkGNp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDAnkGNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C610C4CEC6;
	Tue, 15 Oct 2024 13:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997342;
	bh=pI5cZthNTSgyqtN7rfDIx9ls+MtMAlnBj76Bxn9RekA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aDAnkGNpsfte3aOjRy0tynUdEWEcuquswh5pYBWse8pc1/VpheS4JtfZomakGFiBq
	 yf9TtkKxAmuwPU3SIQfUHLgi/Xg/oK/CNH4u6pHgAtRQQ0To5Sw8bjPGfwbazq71Wx
	 ClCo6donQkxHGbyUltttER8GrNHFrjSVA6y2z67Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+9bff4c7b992038a7409f@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 154/518] nilfs2: fix potential null-ptr-deref in nilfs_btree_insert()
Date: Tue, 15 Oct 2024 14:40:58 +0200
Message-ID: <20241015123922.949318197@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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
index a426e4e2acdac..c2aca9cd78644 100644
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



