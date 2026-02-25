Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF57C1D5ABA;
	Wed, 25 Feb 2026 01:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982824; cv=none; b=Xwp/rPmJVCtm9gszPgXZTSL/WOM+ucZ71JVahwuhPN84hkk6lsyzhkoX2FQY5Ep+x2dB4cgcSFRN8apa38JV/Gh3+MNC1llRaxwUThyc/C/jem1VdSv+y/3JhIC8h+P++nQIgVBxkT7JJ5YVPlHUSbjCjTDGOIjCqKhUlSUdeLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982824; c=relaxed/simple;
	bh=l4XBKajq2ltXxNKr1o6tfSm+VpXNpk4rnCwhD7kJqEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/yxQ52oQMrchY/2Z/g9Qf5pCMYomVvxSjkabGpijKulwz7QFEddqS3+iah69sPVXjqm2M4cJUfSLsXWOY4L1/eBX+JkRw1Ts82QVLNGGBqdT0rEQlSrStKB/CoaTRWgbrthfNe384hsdLfXA/+bvPMsedpD4elnFOl4qTHiIjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IiYNHO8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IiYNHO8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D570C116D0;
	Wed, 25 Feb 2026 01:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982824;
	bh=l4XBKajq2ltXxNKr1o6tfSm+VpXNpk4rnCwhD7kJqEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IiYNHO8B6osJwzMfmodod1URjRM/udZsfdSQV8RpbBLdMXxDwAMTWA2tC4BNvQEUQ
	 ube+YC22qXddN+nKTM89gpcklvi63ryevkD449ANizH37RZnR21xlnQ9ExQaYNbL1Y
	 PsYdEXv0VnQu2D3RvdKWvRKnm/n2cXE+ctt4AQpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1c8ff72d0cd8a50dfeaa@syzkaller.appspotmail.com,
	Shardul Bankar <shardul.b@mpiricsoftware.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 004/781] hfsplus: return error when node already exists in hfs_bnode_create
Date: Tue, 24 Feb 2026 17:11:53 -0800
Message-ID: <20260225012359.805056827@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 191661af96778..250a226336ea7 100644
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



