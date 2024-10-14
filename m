Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68FA1C7610;
	Mon, 14 Oct 2024 14:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917919; cv=none; b=n4l2CMlace+1kKiAgd9Bzod9x3tHDItMZWYf6zDW3iDqqAzXZ5kx7bNRJN1yadQeOFrA3QXDee8dzNfxGQRSpf0TWw3y9QPMdCYYvFcdOBafn0ebt4qy1Kxgt2U+maCfG7yiZWD2qxKcAoHKXhH1O7Lq+o3+exbc2654Y3tWMZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917919; c=relaxed/simple;
	bh=rtUY5tmKa4mG3pw8sSoM5bHzORH8x4ZOHbmnYyaK2Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRxQ9UFk9IE+DQJIYgHd6LOsMYx3P+4w4umQyw2A8TmESvHfTa4tseR66ocJfCRcHMRBRHYyQbMxLahnqyj4WDBzMWKlEupLvwZUNhFjp/DshcL+AtqU1rAW0/EwKufRyTVCeafvC7OYkDq7iihZeYsmQa5Y4fgLH9n6xbGxB14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xaCq9/gg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xaCq9/gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B0CC4CECF;
	Mon, 14 Oct 2024 14:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917919;
	bh=rtUY5tmKa4mG3pw8sSoM5bHzORH8x4ZOHbmnYyaK2Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xaCq9/ggkbkZDhFzOXBVI4GODy/y46w2IvtnuTJRlzK68u67hkdPYf7hWFXvZJrZw
	 8wfoeFve1u5Duh+GxTtN4IyP2y8yLarQ9GWuqi0kn+oFA4Lh7hZqKlL8RQxAjDYodO
	 YXES2DbrRotSPeqp4HQxp/NZVYR55hY3rDExiZ8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/798] nilfs2: fix potential oob read in nilfs_btree_check_delete()
Date: Mon, 14 Oct 2024 16:12:07 +0200
Message-ID: <20241014141224.722261975@linuxfoundation.org>
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

[ Upstream commit f9c96351aa6718b42a9f42eaf7adce0356bdb5e8 ]

The function nilfs_btree_check_delete(), which checks whether degeneration
to direct mapping occurs before deleting a b-tree entry, causes memory
access outside the block buffer when retrieving the maximum key if the
root node has no entries.

This does not usually happen because b-tree mappings with 0 child nodes
are never created by mkfs.nilfs2 or nilfs2 itself.  However, it can happen
if the b-tree root node read from a device is configured that way, so fix
this potential issue by adding a check for that case.

Link: https://lkml.kernel.org/r/20240904081401.16682-4-konishi.ryusuke@gmail.com
Fixes: 17c76b0104e4 ("nilfs2: B-tree based block mapping")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/btree.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 4c81bc9f48ad6..3139a1863751b 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1659,13 +1659,16 @@ static int nilfs_btree_check_delete(struct nilfs_bmap *btree, __u64 key)
 	int nchildren, ret;
 
 	root = nilfs_btree_get_root(btree);
+	nchildren = nilfs_btree_node_get_nchildren(root);
+	if (unlikely(nchildren == 0))
+		return 0;
+
 	switch (nilfs_btree_height(btree)) {
 	case 2:
 		bh = NULL;
 		node = root;
 		break;
 	case 3:
-		nchildren = nilfs_btree_node_get_nchildren(root);
 		if (nchildren > 1)
 			return 0;
 		ptr = nilfs_btree_node_get_ptr(root, nchildren - 1,
@@ -1674,12 +1677,12 @@ static int nilfs_btree_check_delete(struct nilfs_bmap *btree, __u64 key)
 		if (ret < 0)
 			return ret;
 		node = (struct nilfs_btree_node *)bh->b_data;
+		nchildren = nilfs_btree_node_get_nchildren(node);
 		break;
 	default:
 		return 0;
 	}
 
-	nchildren = nilfs_btree_node_get_nchildren(node);
 	maxkey = nilfs_btree_node_get_key(node, nchildren - 1);
 	nextmaxkey = (nchildren > 1) ?
 		nilfs_btree_node_get_key(node, nchildren - 2) : 0;
-- 
2.43.0



