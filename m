Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88314ABBBD;
	Thu, 17 Sep 2026 15:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660723; cv=none; b=V0gecmXRzqDdLXhthFSjMvr2ofQ8NQ2Y1p7daTPyGcUaqcCoVkUaty49K08zmtkN6QkwY8TgbdT4NMiueajcYk464/uAwDBac8bUAzh7erJ1gnCkjTqs39fcedCsOYa/LaP+Uo3TK1oZoZQPbsplj2L7RrNt9gsaCtlzILt+7NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660723; c=relaxed/simple;
	bh=RJO89IaCdEfkiBu+mLeXzM7aDfFd5g2GfmAsY9PsdBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ej8vpNi2h1SzeNQT0tjryQNamaTml2riOFEpFZrNsQI1AHusmrILqrPfArHz1S/JP3UX7gzhka8Cb8tvyoRhlHWWnM9M5qR5HtSY4SgLeoR8HEGYaKI75Arg0S89wxv77JhB/EotFSvNj1ZHiH67Zx/FYoiT33oyAb8xysAPyTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wlCr5gOl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wlCr5gOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06A41F00893;
	Thu, 17 Sep 2026 15:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660721;
	bh=FBaqxDvvkKOw5xzIQwVnVZhieSQk+GBp50aL7eOjQh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wlCr5gOlSjYhQchOpUlbn5Ev/WcXQNZon7rjM4R1DJHiQQayqz5S9n5rSNpI+OkzG
	 HJFGwupOvVjaBWoKOQCDJapUOJDQSRwV/cPZfluQish4qfXC/LECzdHkHRo4BOx+1A
	 KFw5xpFBlNdlDEA9d+X2dE8vtenG7k57IcQZo0WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 660/733] xfs: fix the rtrmap and rtrefcount _maxlevels_ondisk functions
Date: Thu, 17 Sep 2026 16:16:08 +0100
Message-ID: <20260917151409.117834898@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit aa301322f72f82f26e4ba0826018d41388ab9896 upstream.

The _maxlevels_ondisk functions are used to compute the size of
in-memory btree cursors for each btree type.  Unfortunately, LOLLM
noticed that the rtrmap and rtrefcount versions of these functions
forget to account for the inode root, which means that we could access
beyond the end of the cursor given a sufficiently large btree.  Fix
this.

Cc: stable@vger.kernel.org # v6.14
Fixes: 9abe03a0e4f978 ("xfs: introduce realtime refcount btree ondisk definitions")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |    7 +++++--
 fs/xfs/libxfs/xfs_rtrmap_btree.c     |    4 +++-
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -489,8 +489,11 @@ xfs_rtrefcountbt_maxlevels_ondisk(void)
 	minrecs[0] = xfs_rtrefcountbt_block_maxrecs(blocklen, true) / 2;
 	minrecs[1] = xfs_rtrefcountbt_block_maxrecs(blocklen, false) / 2;
 
-	/* We need at most one record for every block in an rt group. */
-	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_RGBLOCKS);
+	/*
+	 * We need at most one record for every block in an rt group, and
+	 * one extra level for the inode root.
+	 */
+	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_RGBLOCKS) + 1;
 }
 
 int __init
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -716,10 +716,12 @@ xfs_rtrmapbt_maxlevels_ondisk(void)
 	 * happens, which means that we must compute the max height based on
 	 * what the btree will look like if it consumes almost all the blocks
 	 * in the data device due to maximal sharing factor.
+	 *
+	 * Add one extra level for the inode root.
 	 */
 	max_dblocks = -1U; /* max ag count */
 	max_dblocks *= XFS_MAX_CRC_AG_BLOCKS;
-	return xfs_btree_space_to_height(minrecs, max_dblocks);
+	return xfs_btree_space_to_height(minrecs, max_dblocks) + 1;
 }
 
 int __init


