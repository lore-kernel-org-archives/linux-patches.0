Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2B21D07B7;
	Wed,  2 Oct 2024 14:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878050; cv=none; b=pdV24uhTJFlMMALtQVHXw+G5wkYAzxaauAzLx//vsHZgtNTKlVWo+omOil/jWYdGS71dLZ/5XIxUr8KtocubralgV6p5VyHGwgxXctIbV5l4NOo2qgREsv+wUu/ot4pHbTGIHgUea+Uc4eUxJ1J+l1ZQBGsgdE6zQOzUTOcmZ4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878050; c=relaxed/simple;
	bh=SQygl5SZ8KkhnZ/ZsB/T+YMcydcsPydKjCA7reFeRHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvYn62amIIXV+VwnzPEjVHQ09YrHnyP5AB+4fNGPGGxrlM/xtij1feErl6H/B6LbYQKwz1sLf0pqM4ar0w3GNMqcVrLn/6mN6taOqwJfjS6wYj8QDGZrVLBbhoIETBfbbMacIea4U1KhpsP6rxS6AfUxOG1T8FwBAk1Zl/EVQwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3VgXe62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3VgXe62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E46C4CEC2;
	Wed,  2 Oct 2024 14:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878050;
	bh=SQygl5SZ8KkhnZ/ZsB/T+YMcydcsPydKjCA7reFeRHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3VgXe62ZZkj86H3cj2qyp/Usn2Z5h9W99eRNp2Cyn5BwpCMauAx+Z03/F9BQVk+J
	 QzGSci3bwBrU2sj06N8LrhGGVHIM+//dN9xXYd9RrD4fYLxw/8XAk0O9xPkVAU/tPZ
	 61IpC3yWKPdvpv8+GlhHNJFryWRSozc2vM8QCWdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 285/634] nilfs2: determine empty node blocks as corrupted
Date: Wed,  2 Oct 2024 14:56:25 +0200
Message-ID: <20241002125822.359977814@linuxfoundation.org>
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

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 111b812d3662f3a1b831d19208f83aa711583fe6 ]

Due to the nature of b-trees, nilfs2 itself and admin tools such as
mkfs.nilfs2 will never create an intermediate b-tree node block with 0
child nodes, nor will they delete (key, pointer)-entries that would result
in such a state.  However, it is possible that a b-tree node block is
corrupted on the backing device and is read with 0 child nodes.

Because operation is not guaranteed if the number of child nodes is 0 for
intermediate node blocks other than the root node, modify
nilfs_btree_node_broken(), which performs sanity checks when reading a
b-tree node block, so that such cases will be judged as metadata
corruption.

Link: https://lkml.kernel.org/r/20240904081401.16682-3-konishi.ryusuke@gmail.com
Fixes: 17c76b0104e4 ("nilfs2: B-tree based block mapping")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index d390b8ba00d45..dedd3c4808423 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -350,7 +350,7 @@ static int nilfs_btree_node_broken(const struct nilfs_btree_node *node,
 	if (unlikely(level < NILFS_BTREE_LEVEL_NODE_MIN ||
 		     level >= NILFS_BTREE_LEVEL_MAX ||
 		     (flags & NILFS_BTREE_NODE_ROOT) ||
-		     nchildren < 0 ||
+		     nchildren <= 0 ||
 		     nchildren > NILFS_BTREE_NODE_NCHILDREN_MAX(size))) {
 		nilfs_crit(inode->i_sb,
 			   "bad btree node (ino=%lu, blocknr=%llu): level = %d, flags = 0x%x, nchildren = %d",
-- 
2.43.0



