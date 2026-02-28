Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E619A39B946
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302510; cv=none; b=rkL21sNwCG7xsQWVt/YXpN681JlioDXSKNoLGd5/FYo+TlH9u8swiaBi6OwwDhwbby2bWdD/BnLoSLeki1utU4AqrfdDFHg8lN87NVZSXALnzAfCKge75j4Kv/2raOqMCi9iXQWu0wI1DeAYZ9wI2qH3LR1bH7+dYcI4IAOTfIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302510; c=relaxed/simple;
	bh=NW73rD4VECkj9JS1Jdyha9U5tIPOfpnVZo1bLuIwMVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWu3xn+W2vwoj5JNebf+s8CL5j1L2AUm93hMy7G1O/9LRScDRJUm54D0xMo79GEeUBZWhlgAFkWXszIomDc5C5YSf25/e4V/wdSnQSeLv3476mUhMe4xMnihJb6GXN3O7KmM8I7zyNF1FCBW6yAMwWc9aXEvII/+kxy6THqq3Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OMnuAF6y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OMnuAF6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1612CC116D0;
	Sat, 28 Feb 2026 18:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302509;
	bh=NW73rD4VECkj9JS1Jdyha9U5tIPOfpnVZo1bLuIwMVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMnuAF6yBhcnBQAWHJUJUQG4kmj0OxOmy5ivGCfFDcLlmCQRRGxvWaPBhKKKQQE6c
	 N6AeO8oQPMZtr6Cp21iHvim7oMt6zhg5zVR2+FoYZMVMI3/wjyexy+VpH1Szw/CBdW
	 5GfgDuslfMQgNuGxLuEdHHgHWdxqiz977dUXZBoZJmfeadp5b8C0YoXvqbH0v6kmIM
	 ZUpWOXShPJLPyHbUGHLy6ibIwvDdNwQSEkSc4WttvKcqlQ1Defye/z4W0nR5x+5KUy
	 7f+7K1DaDgjCcZqi73g8nSQmCphGvXOofMxVTRu6yIQgsBLZM+fAxezrh97Wnxz1fk
	 7NVG53lCo4/qQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shardul Bankar <shardul.b@mpiricsoftware.com>,
	syzbot+1c8ff72d0cd8a50dfeaa@syzkaller.appspotmail.com,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/164] hfsplus: return error when node already exists in hfs_bnode_create
Date: Sat, 28 Feb 2026 13:12:23 -0500
Message-ID: <20260228181505.1600663-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shardul Bankar <shardul.b@mpiricsoftware.com>

[ Upstream commit d8a73cc46c8462a969a7516131feb3096f4c49d3 ]

When hfs_bnode_create() finds that a node is already hashed (which should
not happen in normal operation), it currently returns the existing node
without incrementing its reference count. This causes a reference count
inconsistency that leads to a kernel panic when the node is later freed
in hfs_bnode_put():

    kernel BUG at fs/hfsplus/bnode.c:676!
    BUG_ON(!atomic_read(&node->refcnt))

This scenario can occur when hfs_bmap_alloc() attempts to allocate a node
that is already in use (e.g., when node 0's bitmap bit is incorrectly
unset), or due to filesystem corruption.

Returning an existing node from a create path is not normal operation.

Fix this by returning ERR_PTR(-EEXIST) instead of the node when it's
already hashed. This properly signals the error condition to callers,
which already check for IS_ERR() return values.

Reported-by: syzbot+1c8ff72d0cd8a50dfeaa@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=1c8ff72d0cd8a50dfeaa
Link: https://lore.kernel.org/all/784415834694f39902088fa8946850fc1779a318.camel@ibm.com/
Fixes: 634725a92938 ("[PATCH] hfs: cleanup HFS+ prints")
Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20251229204938.1907089-1-shardul.b@mpiricsoftware.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/bnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hfsplus/bnode.c b/fs/hfsplus/bnode.c
index 7c127922ac0c7..1fa4a1d18b7b2 100644
--- a/fs/hfsplus/bnode.c
+++ b/fs/hfsplus/bnode.c
@@ -640,7 +640,7 @@ struct hfs_bnode *hfs_bnode_create(struct hfs_btree *tree, u32 num)
 	if (node) {
 		pr_crit("new node %u already hashed?\n", num);
 		WARN_ON(1);
-		return node;
+		return ERR_PTR(-EEXIST);
 	}
 	node = __hfs_bnode_create(tree, num);
 	if (!node)
-- 
2.51.0

