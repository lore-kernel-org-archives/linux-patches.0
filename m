Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AB02727F3;
	Wed,  8 Apr 2026 18:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674278; cv=none; b=XWt0RfoFe9MM+IgVzoxfO6CeGcM2D7QmqZhlmQ/3umADl7Mjx+myz3MTo4zdSlsndizqy8pMl5UoWFfDSoaiy+rExFR304NeBfn9pWK8j2Mr/BNkTgPRtA9QDegQeQO81NFA/vdNlhnl2UUfIZUwzRGIyFUcgmQrCDV2XXHxckU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674278; c=relaxed/simple;
	bh=3wZcnch1Nc2N84M4ohvbrybmW42NpC75RFVdIXUNlyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4VVZXg3ci59O4QQv51ra2BTlfApax2opCFdhNpA4zADeEscyF15teM9FEXeOYT9cZGLYniHwTq3+Afk8beEP4SQtotUrCzo++zszkSLmW92RK/Et3ZGe18SFI5hgivXNNYWEcnLOgIxYoHGQBO3XruB11Qnw+Pb6UixvDTFQuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0pBlvam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0pBlvam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8C9C19421;
	Wed,  8 Apr 2026 18:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674278;
	bh=3wZcnch1Nc2N84M4ohvbrybmW42NpC75RFVdIXUNlyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0pBlvamrKQbK9pKSHxbt4LuDh2FYyA5kTvoWQz7C4g2Ch3eraiYs7odDOVyJ9IoX
	 vdtaTcu4emm77qeOscfwgXEFSpeaT7G2bUQ11F3isDR1WtPrrzRuNjGnMSmggVMXCq
	 XTMGF39qIVwfQoob01X2VcX+4WQLeMgLnnVEkzTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Long Li <leo.lilong@huawei.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 007/311] xfs: factor out xfs_attr3_leaf_init
Date: Wed,  8 Apr 2026 20:00:07 +0200
Message-ID: <20260408175939.681243019@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit e65bb55d7f8c2041c8fdb73cd29b0b4cad4ed847 ]

Factor out wrapper xfs_attr3_leaf_init function, which exported for
external use.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Long Li <leo.lilong@huawei.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Stable-dep-of: b854e1c4eff3 ("xfs: close crash window in attr dabtree inactivation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   22 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.h |    3 +++
 2 files changed, 25 insertions(+)

--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1317,6 +1317,28 @@ xfs_attr3_leaf_create(
 }
 
 /*
+ * Reinitialize an existing attr fork block as an empty leaf, and attach
+ * the buffer to tp.
+ */
+int
+xfs_attr3_leaf_init(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_dablk_t		blkno)
+{
+	struct xfs_buf		*bp = NULL;
+	struct xfs_da_args	args = {
+		.trans		= tp,
+		.dp		= dp,
+		.owner		= dp->i_ino,
+		.geo		= dp->i_mount->m_attr_geo,
+	};
+
+	ASSERT(tp != NULL);
+
+	return xfs_attr3_leaf_create(&args, blkno, &bp);
+}
+/*
  * Split the leaf node, rebalance, then add the new entry.
  *
  * Returns 0 if the entry was added, 1 if a further split is needed or a
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -86,6 +86,9 @@ int	xfs_attr3_leaf_list_int(struct xfs_b
 /*
  * Routines used for shrinking the Btree.
  */
+
+int	xfs_attr3_leaf_init(struct xfs_trans *tp, struct xfs_inode *dp,
+				xfs_dablk_t blkno);
 int	xfs_attr3_leaf_toosmall(struct xfs_da_state *state, int *retval);
 void	xfs_attr3_leaf_unbalance(struct xfs_da_state *state,
 				       struct xfs_da_state_blk *drop_blk,


