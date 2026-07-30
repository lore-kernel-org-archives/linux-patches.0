Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA8E40860A;
	Thu, 30 Jul 2026 15:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426605; cv=none; b=ig0pKtzBp64taZT3dO8XNBGTJOa6n2+LbEsVngqasD9dC6R7Rv7ssUAw+UT1ZlQfDAQ6+ghZFBiy+w3C96QtHb/pEx+A3op1L+m8KfyYzrv+ZljmWGw9jx9fg8H3qRXJNQtBMreZUiWPgXi6uNijeocgRDOdYPrBV5VYeewqlDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426605; c=relaxed/simple;
	bh=43S82qUaICmQrxgzZJ4RB4Sf3arbtyXhTEonyKpXR0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEeENgQ7zJ9gIzYGlS5pJb2vT+3bNkpHCXEFCqxwGfK+2VEHbPBidwOTPT3ZU8nE1KmYrMJh9eIjvri54hf+bVobhGPGjVA3EmTnGyuhOfFwVDBGm3HKlajNfK0v6qR86xT5l7oolCjmlemHALC34ylxcC9Ncgc3NvnLhoeRQEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Gp/seML; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Gp/seML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DF41F000E9;
	Thu, 30 Jul 2026 15:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426604;
	bh=gWsBtf5zrl2PkwFVtkLJpKExceeuXstB4lRPN2bJqSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Gp/seMLyo4L+y75alg66se/f6/FuwEgC48iEmFJALWWHG53QbZYKUhr3vKdjRaAt
	 ooSvtUf3wPij3/fwzeGX0ZLgMSJsd0wTTVTRmZ6NXPF62CN10+DQDkt2A0lYUsbPqH
	 WX5+TLxLbKHBlTJ+k3OVL/pYF1Dyv4CalCG2LCdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Long Li <leo.lilong@huawei.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 479/602] xfs: factor out xfs_attr3_leaf_init
Date: Thu, 30 Jul 2026 16:14:31 +0200
Message-ID: <20260730141446.030920695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

[ Upstream commit e65bb55d7f8c2041c8fdb73cd29b0b4cad4ed847 ]

Factor out wrapper xfs_attr3_leaf_init function, which exported for
external use.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Long Li <leo.lilong@huawei.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Stable-dep-of: a1caeeadbf57 ("xfs: don't replace the wrong part of the cow fork")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   22 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.h |    3 +++
 2 files changed, 25 insertions(+)

--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1330,6 +1330,28 @@ xfs_attr3_leaf_create(
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


