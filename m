Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635A71D0485;
	Wed,  2 Oct 2024 13:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876063; cv=none; b=oI+iQpzVgaYD4pMCO5EfLv/OyFvJy9CejmXA4WOjYbCPnJmwwlrDiFbkZF547ADhytwytpAUF+JrNtxEwkSjB/z5mszI8fecw6CP0U0vCC119W1oZiCa2AcRAmnIVj+a3omZdR9DI0qGR6hEh8bV94TcZ3mPNxN+n/uheMSU0KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876063; c=relaxed/simple;
	bh=Z+sJBYXWFB6sv3bZO9uahYYZjyZaedOyfHSMLZ78tgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfASUP1BJgsNoY+vGjTZbnBhZ9S/cZxzZ/bkTgR+06tb9MryezO3cXfKjwzr5cI9gR9HT/Vlg90HwmGNOeRq+QM6xk4JlINBbfEbSFUaUMWDBDjeh1mU/dy5U+MPi+kbTgNH4z/P/NSU3LQK5NLer74AoIzOL4xJfW/lh6wCrQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9Ls39dp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9Ls39dp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07AAC4CECF;
	Wed,  2 Oct 2024 13:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876063;
	bh=Z+sJBYXWFB6sv3bZO9uahYYZjyZaedOyfHSMLZ78tgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9Ls39dp5CUrtujxuOie2lnyC3RVYK816OLaSNpyKzoyTr1m7Xb6uDFwtBxHZxB0O
	 tGgnG6EOpuVyLdI234kYngsVenB86wYHCslbFV+jPEVdmx5w+YWXBKRj3A9Sxt6hGq
	 551LTCInJgVV+764g/dHLanhAa5zlYlSY8+OKquA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+9bff4c7b992038a7409f@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 315/695] nilfs2: fix potential null-ptr-deref in nilfs_btree_insert()
Date: Wed,  2 Oct 2024 14:55:13 +0200
Message-ID: <20241002125835.024854520@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 862bdf23120e8..d390b8ba00d45 100644
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



