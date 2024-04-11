Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBC3142624;
	Thu, 11 Apr 2024 10:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830193; cv=none; b=t0h3sn/PGJj5uML7vxs/05WB97jPUsyEq7sMfvxZpK5DIvI1J0y1pt29iIBFV8qyHXkYQJGy/ZGEHPV4B8u3a/EzCK2sZngdcZfbiiAvzs+pShjKn3DdLnnBQlJ1Is5HyxFmPnnchH2H9+FoAcdStAaEj2pPAQ+5HJnRsEiZD0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830193; c=relaxed/simple;
	bh=j8bEXFWjH4u7WCDyUFhxLK3fgidx7BdDrJ0WSx+tAwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9aODmDOWcQRQhJuJoj5E2iuxEwuH7/wztqsB9yrA6SetwTvnuZQ9yhinRsZVqRN/Mh7cmQ9ZQeThuCvpZ/FT85bcu+L0MZ0ouku6fCGwXpWfxLAXXD0F1/1uObEa9u8eoo6IjKm/kc2nBYa6AfFxtUBlnDPr1bR9ZphSwitWz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vBhbLslZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vBhbLslZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5215C433F1;
	Thu, 11 Apr 2024 10:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830193;
	bh=j8bEXFWjH4u7WCDyUFhxLK3fgidx7BdDrJ0WSx+tAwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vBhbLslZ8ao6MiNdMxkbzQOuIzmIeZ+UIL/uBVnxyI55LaeY1g2Q5k2p+BXpl1dbB
	 fyCFLtt0tuqLfvID79rDirdWKWHXl8hXEakgwA71XjpVUQ+/LjX5zOqht32tvLIoxu
	 EQSG229YxfkcR7ENPgkEsfr3LvAwx1LMELEHGOYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+69b40dc5fd40f32c199f@syzkaller.appspotmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 067/143] sysv: dont call sb_bread() with pointers_lock held
Date: Thu, 11 Apr 2024 11:55:35 +0200
Message-ID: <20240411095422.932083595@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit f123dc86388cb669c3d6322702dc441abc35c31e ]

syzbot is reporting sleep in atomic context in SysV filesystem [1], for
sb_bread() is called with rw_spinlock held.

A "write_lock(&pointers_lock) => read_lock(&pointers_lock) deadlock" bug
and a "sb_bread() with write_lock(&pointers_lock)" bug were introduced by
"Replace BKL for chain locking with sysvfs-private rwlock" in Linux 2.5.12.

Then, "[PATCH] err1-40: sysvfs locking fix" in Linux 2.6.8 fixed the
former bug by moving pointers_lock lock to the callers, but instead
introduced a "sb_bread() with read_lock(&pointers_lock)" bug (which made
this problem easier to hit).

Al Viro suggested that why not to do like get_branch()/get_block()/
find_shared() in Minix filesystem does. And doing like that is almost a
revert of "[PATCH] err1-40: sysvfs locking fix" except that get_branch()
 from with find_shared() is called without write_lock(&pointers_lock).

Reported-by: syzbot <syzbot+69b40dc5fd40f32c199f@syzkaller.appspotmail.com>
Link: https://syzkaller.appspot.com/bug?extid=69b40dc5fd40f32c199f
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://lore.kernel.org/r/0d195f93-a22a-49a2-0020-103534d6f7f6@I-love.SAKURA.ne.jp
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/sysv/itree.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/sysv/itree.c b/fs/sysv/itree.c
index 410ab2a44d2f6..19bcb51a22036 100644
--- a/fs/sysv/itree.c
+++ b/fs/sysv/itree.c
@@ -83,9 +83,6 @@ static inline sysv_zone_t *block_end(struct buffer_head *bh)
 	return (sysv_zone_t*)((char*)bh->b_data + bh->b_size);
 }
 
-/*
- * Requires read_lock(&pointers_lock) or write_lock(&pointers_lock)
- */
 static Indirect *get_branch(struct inode *inode,
 			    int depth,
 			    int offsets[],
@@ -105,15 +102,18 @@ static Indirect *get_branch(struct inode *inode,
 		bh = sb_bread(sb, block);
 		if (!bh)
 			goto failure;
+		read_lock(&pointers_lock);
 		if (!verify_chain(chain, p))
 			goto changed;
 		add_chain(++p, bh, (sysv_zone_t*)bh->b_data + *++offsets);
+		read_unlock(&pointers_lock);
 		if (!p->key)
 			goto no_block;
 	}
 	return NULL;
 
 changed:
+	read_unlock(&pointers_lock);
 	brelse(bh);
 	*err = -EAGAIN;
 	goto no_block;
@@ -219,9 +219,7 @@ static int get_block(struct inode *inode, sector_t iblock, struct buffer_head *b
 		goto out;
 
 reread:
-	read_lock(&pointers_lock);
 	partial = get_branch(inode, depth, offsets, chain, &err);
-	read_unlock(&pointers_lock);
 
 	/* Simplest case - block found, no allocation needed */
 	if (!partial) {
@@ -291,9 +289,9 @@ static Indirect *find_shared(struct inode *inode,
 	*top = 0;
 	for (k = depth; k > 1 && !offsets[k-1]; k--)
 		;
+	partial = get_branch(inode, k, offsets, chain, &err);
 
 	write_lock(&pointers_lock);
-	partial = get_branch(inode, k, offsets, chain, &err);
 	if (!partial)
 		partial = chain + k-1;
 	/*
-- 
2.43.0



