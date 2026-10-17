Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCA92D73A6;
	Sat, 17 Oct 2026 15:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252615; cv=none; b=oEJApk5NyP4oJppx2vFa7ET0sGQ0LyxY3F/YW2PUcy3nAkPjnW54dwXMG8TEFiOkAm0qOexg/hQYNn97hDp7d5E72NpWgsVffTcGRcocGDqHdi2Q4qLLBrGrZiMR0BQXd+kTg7FNKAz1awKBP9buDVFcUK3cPrvv2Q/+3NqyZ0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252615; c=relaxed/simple;
	bh=l+jzFBOWKZsJ4m0HmDc/f5r3YNornVRV+dbPa2T2fC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlK4IFmdXXIYeuJO47PUciqlhKlX/OCl4PObtQ36GjgL3JEr9ZORlAgah2eUTQHy2egUVq/VcLS6Lh472ggJKAGV5R/7v6DyaEARSQ2Ispb8wL7d33VJrvRF2TL3utUApQ4Nqdd8lCg8RTjZhS0FeaHxymYvCf5MlpRjMOVspQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOR4D4F4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOR4D4F4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8591C1F000C4;
	Sat, 17 Oct 2026 15:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252614;
	bh=dyusuUHr8a/OvwOP5cqPh8Sx4aFGUqgMGxHfA/b6PWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FOR4D4F4gfAF/u8sXqO9LWeEuJjFGdFS9LSkeMt4NHyk5s2YWUyREXKFBnM12b+Ro
	 8zCtl9Qktp71o/XRe5ryA8MgDptNImgc30/w3sXgW5zVoeNvSBGnTahtp48HfLnbgj
	 sVj1fuGnjtx1ifAm8QsgV1Piibbx5MK1/7J2hpbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Long Li <leo.lilong@huawei.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 38/52] xfs: factor out xfs_attr3_node_entry_remove
Date: Sat, 17 Oct 2026 17:54:39 +0200
Message-ID: <20261017155106.072300660@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit ce4e789cf3561c9fac73cc24445bfed9ea0c514b ]

Factor out wrapper xfs_attr3_node_entry_remove function, which
exported for external use.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Long Li <leo.lilong@huawei.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Stable-dep-of: b854e1c4eff3 ("xfs: close crash window in attr dabtree inactivation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_da_btree.c | 53 ++++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_da_btree.h |  2 ++
 2 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 90fbdef23def1..ca5f99c0878f2 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1506,21 +1506,20 @@ xfs_da3_fixhashpath(
 }
 
 /*
- * Remove an entry from an intermediate node.
+ * Internal implementation to remove an entry from an intermediate node.
  */
 STATIC void
-xfs_da3_node_remove(
-	struct xfs_da_state	*state,
-	struct xfs_da_state_blk	*drop_blk)
+__xfs_da3_node_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_da_geometry  *geo,
+	struct xfs_da_state_blk *drop_blk)
 {
 	struct xfs_da_intnode	*node;
 	struct xfs_da3_icnode_hdr nodehdr;
 	struct xfs_da_node_entry *btree;
 	int			index;
 	int			tmp;
-	struct xfs_inode	*dp = state->args->dp;
-
-	trace_xfs_da_node_remove(state->args);
 
 	node = drop_blk->bp->b_addr;
 	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
@@ -1536,17 +1535,17 @@ xfs_da3_node_remove(
 		tmp  = nodehdr.count - index - 1;
 		tmp *= (uint)sizeof(xfs_da_node_entry_t);
 		memmove(&btree[index], &btree[index + 1], tmp);
-		xfs_trans_log_buf(state->args->trans, drop_blk->bp,
+		xfs_trans_log_buf(tp, drop_blk->bp,
 		    XFS_DA_LOGRANGE(node, &btree[index], tmp));
 		index = nodehdr.count - 1;
 	}
 	memset(&btree[index], 0, sizeof(xfs_da_node_entry_t));
-	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
+	xfs_trans_log_buf(tp, drop_blk->bp,
 	    XFS_DA_LOGRANGE(node, &btree[index], sizeof(btree[index])));
 	nodehdr.count -= 1;
 	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &nodehdr);
-	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
-	    XFS_DA_LOGRANGE(node, &node->hdr, state->args->geo->node_hdr_size));
+	xfs_trans_log_buf(tp, drop_blk->bp,
+	    XFS_DA_LOGRANGE(node, &node->hdr, geo->node_hdr_size));
 
 	/*
 	 * Copy the last hash value from the block to propagate upwards.
@@ -1554,6 +1553,38 @@ xfs_da3_node_remove(
 	drop_blk->hashval = be32_to_cpu(btree[index - 1].hashval);
 }
 
+/*
+ * Remove an entry from an intermediate node.
+ */
+STATIC void
+xfs_da3_node_remove(
+	struct xfs_da_state	*state,
+	struct xfs_da_state_blk	*drop_blk)
+{
+	trace_xfs_da_node_remove(state->args);
+
+	__xfs_da3_node_remove(state->args->trans, state->args->dp,
+			state->args->geo, drop_blk);
+}
+
+/*
+ * Remove an entry from an intermediate attr node at the specified index.
+ */
+void
+xfs_attr3_node_entry_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_buf		*bp,
+	int			index)
+{
+	struct xfs_da_state_blk blk = {
+		.index		= index,
+		.bp		= bp,
+	};
+
+	__xfs_da3_node_remove(tp, dp, dp->i_mount->m_attr_geo, &blk);
+}
+
 /*
  * Unbalance the elements between two intermediate nodes,
  * move all Btree elements from one node into another.
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index cd2e213f5e74f..a718b1ceb0aab 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -184,6 +184,8 @@ int	xfs_da3_split(xfs_da_state_t *state);
 int	xfs_da3_join(xfs_da_state_t *state);
 void	xfs_da3_fixhashpath(struct xfs_da_state *state,
 			    struct xfs_da_state_path *path_to_to_fix);
+void	xfs_attr3_node_entry_remove(struct xfs_trans *tp, struct xfs_inode *dp,
+			    struct xfs_buf *bp, int index);
 
 /*
  * Routines used for finding things in the Btree.
-- 
2.53.0



