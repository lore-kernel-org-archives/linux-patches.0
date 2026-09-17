Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C074F7CD7;
	Thu, 17 Sep 2026 17:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666661; cv=none; b=S68Pr81ROaacaBaGlo/Ey+nLSLjGiykg1lYn+fGMU5cnk4vetbVZxgzHw3MXwnzahNqvThaUhH9nScQcHiDuJOGfsBnhBJTNZj7gr6nOe5Oxh34b7Xv5EAfYJKmbFbtW7gfI6917yoPp8T1pOSqUZDJTbuFXiVCjr2zpXBbu64c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666661; c=relaxed/simple;
	bh=h8i69gfz9VpI1zdH13EWg0FUXyDalbTjwiIq/y6Uz0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iALch0MQfGNa0wtOCdZvtSIehXpnp9rh1THH+VzcHNhQ+z5BsRBPjqQTnOze+2fcybJxeuULzJ8EQvKuoIZxdn6WSZrpVBXpEynsk8dcH7V0ndr0RNNdQqzFvw7t7a1T1b7ba/B8+7XKG+oPTS6QGHQKLULtPwMZzTUz68/J1dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGgFQvhO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGgFQvhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E8E1F000FF;
	Thu, 17 Sep 2026 17:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666660;
	bh=NM5XC9E+2bzLuBCh7y16OPptgGJ55J+dqAbDDknYlqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uGgFQvhOJYSTfHebROAxL3lT+OQVsw/Xqtnj/vZPrWsKiobsN9d75+DpyC81SRiRL
	 HQgM7OFv+b2anjfFCxoswGVW0HY0pcvTMuKc+oFfOOy0QTtpk47//vkVFUgShcAYHJ
	 j2ImwZC1Z8ws6VrkWmjaukPakiJ87UvSFU+WxJ8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1104/1250] xfs: fix the rtrmap and rtrefcount _maxlevels_ondisk functions
Date: Thu, 17 Sep 2026 16:14:59 +0100
Message-ID: <20260917151622.108495387@linuxfoundation.org>
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


