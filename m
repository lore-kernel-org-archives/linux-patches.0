Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCCE375AC5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301615; cv=none; b=g0U4OVWGXo/imWwk2+1hhGmkQMSOEWrVv9UR0XPy/mWBktJh2Dpg1vuL+FODMfXi7tf+dM9PSVR71QihBEn6+6IxuRECowAUPlMfIjX5BTB+6oWUCk3psZRbGxQiCzYNkSUu33H61EUu0k76qMq7RZqOeIt2itXdGHbLRUbjX/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301615; c=relaxed/simple;
	bh=irCTvV80UA/HegHh5k6Q5EDCxsA8yNewTFu9PPD89YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZIDkamgtlhVYEBh/Z3stxilKvrY6JOUCBsyn1ZZXvKdlGu/eGI/oHEpqs0rFRRBwXAPKWUIrPDBlJG/vUrAfQglICS1yy031C9+SgkRVAnyXicSZA31o0VK69Gj2T107qZtN4PU89bZcxt8WyTVoFryMXoySunqsR5r+rZVurY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WXosCv2E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WXosCv2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA48DC19424;
	Sat, 28 Feb 2026 18:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301615;
	bh=irCTvV80UA/HegHh5k6Q5EDCxsA8yNewTFu9PPD89YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WXosCv2Eyy2PhwBnXc2tFCy7kAAeLHddkGT9Hh+3bKatcS8kMLOv2ZZOV/35LSshx
	 n9GeOiE9ed7M3LMBPpdLsTjAK0p0LD9iX4fSZROUEMynsSY8LSlKuqOo0UT4s8Y8dw
	 VCU2wRtLwk/DgIWHqIrahluUaYa8JtXQv8tNMmP2eQO/qDJs9ST/JIk8CG80fbjaG3
	 vLI3u+xb4VjkVc1hMLlNK/mnC+bJmNouE4bd3B8/upZ6qEPMwPXOqDJ/Bf6t4FfxcI
	 5nPMYN9n+mWdtYKqS3pbUHz3C0G1Er2+sDEA0UQX8sBINCIURV6wgSRdE5G7MIYS8Q
	 qv/hu5NGf4a6Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shardul Bankar <shardul.b@mpiricsoftware.com>,
	syzbot+1c8ff72d0cd8a50dfeaa@syzkaller.appspotmail.com,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/385] hfsplus: return error when node already exists in hfs_bnode_create
Date: Sat, 28 Feb 2026 12:53:46 -0500
Message-ID: <20260228180011.1568201-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index c0089849be50e..fb437598e2625 100644
--- a/fs/hfsplus/bnode.c
+++ b/fs/hfsplus/bnode.c
@@ -629,7 +629,7 @@ struct hfs_bnode *hfs_bnode_create(struct hfs_btree *tree, u32 num)
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

