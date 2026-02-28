Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABA83A2AE4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302660; cv=none; b=bbQSK0zt2bZUMBTg7bksPtuaW307+879DTT0Cya9YSR4XkUderquWZ4Zmc7MHM4i65LqNwM9KaffSEVeIH+z5c+gOYr1xoQHjLGXGTEb0RsfaMNBdCSeKNkZ3Cd8d15WAnzfDgcHMzXl/CuJOOaxZAhsi1zaEnOX5q2PeSTCqh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302660; c=relaxed/simple;
	bh=NW73rD4VECkj9JS1Jdyha9U5tIPOfpnVZo1bLuIwMVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ab3Zx0Hyy2tP8mJIOgalsvTGGfa83KM96imseB6j3//RW3F5gdvBBeUhn6T5cF0qcUS5trZu1Lo5zs1Plll9n2w/BM2VN6L9YCMV4zBAeIKwqauE8WsfRjAnEKeDNTuFq2Xga9elwlaJu4I1XljxXvLMMWM2j/P2afJyWkuirh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ROWpYAYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ROWpYAYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E82C116D0;
	Sat, 28 Feb 2026 18:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302660;
	bh=NW73rD4VECkj9JS1Jdyha9U5tIPOfpnVZo1bLuIwMVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROWpYAYc3oJ05CNtHJ/mTixgn4RygreYkMMX8+iaeXTnf1xwCBix35TWpUYRGo+4e
	 2bUeO8QYkBTQSw6BNrOAZxOqARGLyh9mwzIx+FmkGKhFrzYX0EKUUIpNkhqNGWYDSN
	 8MaKtIpPgGdDtjk5+6WZgUBMJCg7FcXJXO98n9ZbCfzSOlp+ZVAQdzrVqXbjRBchLA
	 Tk2EAHmm7YXX6/pl5gHSDnK6dZFjOmeoFnSRiVI0Ma+tR1UCbWLyH1me6qQwvsnL87
	 bBLotiVWxQw8nA2N8wlF7nY2c9ph0Oh9YwjJYDrAdbg+AlrVuE7xcQIrgl9kkl55Vs
	 7h5L3Xpdi1rsQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shardul Bankar <shardul.b@mpiricsoftware.com>,
	syzbot+1c8ff72d0cd8a50dfeaa@syzkaller.appspotmail.com,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/147] hfsplus: return error when node already exists in hfs_bnode_create
Date: Sat, 28 Feb 2026 13:15:12 -0500
Message-ID: <20260228181736.1605592-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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

