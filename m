Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44A84F68AB;
	Thu, 17 Sep 2026 17:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666641; cv=none; b=PgUK6dsCdH+gq1N0FejZhHUmEnRqp9YU9CrHQz8t+N+ZY9EuIbkCJisej0yyzvMVLRKqdMXrlR4jQMOjeVqpleKmebKwmZyMjnYuEG2KXI48yUImYhwgqGsxlBOIMkMMdszc7BL1Y3rQYmZn+H59UrJTQyBN92h52gKDm9BTXms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666641; c=relaxed/simple;
	bh=DRzommKJ7biwn1LtCR++lYkM7EWXvKZl/+GBTXGC9Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKfcgQMy4NuaCTNXDktrmSS75rWurfzO7nvQgTKXsS2gyDUW7ng844Uv/Pp9i4rEVYd5SmbdKG5U1EK1eCdoJ35btwhiN1Reg+AkIgLrpoiUW20MITtJxkkkyADnQtNQwtmVT1I81cAznguhUn65OCQeG1lriDYrdpbL4u4kzUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsPjYMgU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsPjYMgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30DA1F00893;
	Thu, 17 Sep 2026 17:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666639;
	bh=u8gIzYMXLVYGplaq0Kubg9jSS7DwMHyIlWJBiYu58AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wsPjYMgU8AS3pkgMvPg5Nkz0QAH3SRBC8bXW49JjLbIrDboeLsJ3V4VD+KIaUTp3Y
	 rwkqPb5g7o42TZNw4l6v5/qqPGORnn3BvQoVvRKk2qU7CrFBtxo0reQ776WlfobTO9
	 XBScusQY8o694xsg7dL9BTzFwjAk3R9IT3N0MyFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1102/1250] xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap filesystems
Date: Thu, 17 Sep 2026 16:14:57 +0100
Message-ID: <20260917151622.050086072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 022d5f5fce7f0b6125d404eb74044e6238aef369 upstream.

It's possible to construct an in-memory rtrmap btree for filesystems
that don't have the rmap feature enabled.  The kernel doesn't do this,
but xfs_repair will, if asked to reindex a filesystem that has rtreflink
enabled but not rtrmap.  Therefore, we must create the cursor with
enough levels to handle a maximally sized btree possible.

Note that the rtrmapbt btree cursor slab creates objects large enough to
handle xfs_rtrmap_maxlevels_ondisk() levels, so setting bc_nlevels to
the same value isn't costing us any extra memory.

Cc: stable@vger.kernel.org # v6.14
Fixes: 4a61f12eb11958 ("xfs: create a shadow rmap btree during realtime rmap repair")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_rtrmap_btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 0cb2113d5b40..a15e460a1ec7 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -618,7 +618,7 @@ xfs_rtrmapbt_mem_cursor(
 	struct xfs_btree_cur	*cur;
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rtrmapbt_mem_ops,
-			mp->m_rtrmap_maxlevels, xfs_rtrmapbt_cur_cache);
+			xfs_rtrmapbt_maxlevels_ondisk(), xfs_rtrmapbt_cur_cache);
 	cur->bc_mem.xfbtree = xfbt;
 	cur->bc_nlevels = xfbt->nlevels;
 	cur->bc_group = xfs_group_hold(rtg_group(rtg));
-- 
2.55.0



