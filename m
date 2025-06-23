Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA744315A;
	Mon, 23 Jun 2025 21:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714943; cv=none; b=Oz6Wuj5UV/paMP7a3rkYkqV716Z2TPZF0UGG1Ibn4ApjSLAVu3nhUNP2ZoHnNGXJ3BNmdb9rtac9g1NeeuPiLY6EF3OVbKvPvo/MEqRiDr/HrI8oSZ2BCvdZoi8aivzzFN8PgtyM6heO3xKiVZZaWqI69XgHrTJCCVQ1107sQwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714943; c=relaxed/simple;
	bh=O3bWtmSlz1g0nkQtng8NZBrjMfP4UyXcBt+eG9/s/l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkXKZIZnH5vcNdQJiUcrPaad4ubQ/q6uKQGxZqPZvjRPxXihKDNBY5nrnL6pvE40fWmiD50gAHKfphGqekFuhvkIr2He4qpTuWr0wf4InhbpoYObDjcbOdCzFDCIu3UgIzed7Y72nJwi0ELamYpCInTjh7WnMJNl1z1Yn2f1Mk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxH3lBy+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxH3lBy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D15EC4CEEA;
	Mon, 23 Jun 2025 21:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714943;
	bh=O3bWtmSlz1g0nkQtng8NZBrjMfP4UyXcBt+eG9/s/l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxH3lBy+09xdXJO54tvzeMf/xQWdZokvEkfsc4IiFux6WbyT3POLpO1wflDd7tcG5
	 Iz9yu3UOI4rnKkcX1kiB/YTf13aR0eskQLh7KRWst7jVcLtBgLWqheURLez7q57tgO
	 PAzJxOnKMAhplDl9W2zkkNOzfym7NTYI+gVtGZPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 205/508] xfs: Fix xfs_prepare_shift() range for RT
Date: Mon, 23 Jun 2025 15:04:10 +0200
Message-ID: <20250623130650.311867123@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit f23660f059470ec7043748da7641e84183c23bc8 ]

The RT extent range must be considered in the xfs_flush_unmap_range() call
to stabilize the boundary.

This code change is originally from Dave Chinner.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index dabae6323c503..bab8ba224e10d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1059,7 +1059,7 @@ xfs_prepare_shift(
 	struct xfs_inode	*ip,
 	loff_t			offset)
 {
-	struct xfs_mount	*mp = ip->i_mount;
+	unsigned int		rounding;
 	int			error;
 
 	/*
@@ -1077,11 +1077,13 @@ xfs_prepare_shift(
 	 * with the full range of the operation. If we don't, a COW writeback
 	 * completion could race with an insert, front merge with the start
 	 * extent (after split) during the shift and corrupt the file. Start
-	 * with the block just prior to the start to stabilize the boundary.
+	 * with the allocation unit just prior to the start to stabilize the
+	 * boundary.
 	 */
-	offset = round_down(offset, mp->m_sb.sb_blocksize);
+	rounding = xfs_inode_alloc_unitsize(ip);
+	offset = rounddown_64(offset, rounding);
 	if (offset)
-		offset -= mp->m_sb.sb_blocksize;
+		offset -= rounding;
 
 	/*
 	 * Writeback and invalidate cache for the remainder of the file as we're
-- 
2.39.5



