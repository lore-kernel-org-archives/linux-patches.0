Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2725E38654F;
	Sat, 17 Oct 2026 16:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253783; cv=none; b=YuoIwcL/LC/rt8A1tQo6t7eLgNxlQhYRyJklyNYjafMnDSRmww5raWfkTfJj2qwbS6NewvWGX/wgYVtPg8WjfAaMBxs+KpB1FJS5Rl0+ya9hM9tNdtpfYWZphBA0w+j2cD2G7BglBmGyCMGELb1whwviwlRxrH4Tmj2ayLpQEOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253783; c=relaxed/simple;
	bh=o2DfGx9IQkLQnFdbcTGtyo/TxOetVE1MKS7XlKYp94Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEynZNovHPClWbW6wol4kxU8FsxXQGzWcbdYEEpBGzdfvLbKF7jgXkm+fCA0+0c1EvJZoIbW/XxAuuhx5dzOal780VMrX2WmTLhyCUYiUoXE+O5FT6hs7cYGfUG6uM5aiKLA0H68sxkyC9WmlG4JJ3dtjipfPi+seT5DEDrnvHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXQnWxgF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXQnWxgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAE81F000C5;
	Sat, 17 Oct 2026 16:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253782;
	bh=v9Ghd1c4zFmREyiUvxxyfczGjidB+TAWNs+1V/5a/es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kXQnWxgFR8TuGVLOCCtyrcyTVd/s7hWaA8yWvlqydNXve6jYhuJ6VTLpqu03Q3Si3
	 e+eBIDFmc4as2sSP7NsBZslvdx6/PHh4/13TF+DgC4gAiXWVYieiJf1jELFJDS1VE1
	 8Lvr9cLlpGbmYaOFShpQQZZ20P3OYPiMtsMXyxaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 230/869] xfs: remove bp->b_error check in xfs_attr3_root_inactive
Date: Sat, 17 Oct 2026 17:51:11 +0200
Message-ID: <20261017160042.946452288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit 09f7680dea8760d48dd5b8b5288a388fec122275 ]

The b_error check right after xfs_trans_get_buf() is redundant:

1) If the buffer is found in transaction via xfs_trans_buf_item_match(),
   any corrupted metadata error would have already been exposed during
   previous reads like xfs_da3_node_read().

2) If the buffer is obtained via xfs_buf_get_map():
   - It's called without XBF_READ flag, so won't return buffer with
     b_error set, since xfs_buf_get_map() will clear it anyway.
   - Buffer found in cache normally won't have error since previous reads
     had checked it, unless someone corrupts the buffer and the AIL
     pushes it out to disk while the buffer's unlocked. But in this case,
     AIL will shut down the log.

Remove this redundant check to simplify the code, make the code consistent
with most other xfs_trans_get_buf() callers in XFS.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Stable-dep-of: b854e1c4eff3 ("xfs: close crash window in attr dabtree inactivation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_attr_inactive.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 24fb12986a568..319004bf089fa 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -305,11 +305,6 @@ xfs_attr3_root_inactive(
 			XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0, &bp);
 	if (error)
 		return error;
-	error = bp->b_error;
-	if (error) {
-		xfs_trans_brelse(*trans, bp);
-		return error;
-	}
 	xfs_trans_binval(*trans, bp);	/* remove from cache */
 	/*
 	 * Commit the invalidate and start the next transaction.
-- 
2.53.0



