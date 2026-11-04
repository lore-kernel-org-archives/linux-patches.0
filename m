Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828921;
	b=gfeGfRwECQ5SHj5mjDUgilg5yWONFePsgTron/8/wITtqkl3d6PsIkxjy3QE9Ijqxuhd
	 0G4FRetq4MCSmKz5wYQeQaar6LZTj6qzl0bTYLp5isz+9AtGxuyjQdZdj/kFQDNpWr6Wx
	 3Yt6gKvHMnkrpz/ako9i20IqX0mZp7Fo1fsusaPhyNCrdjONMWsmgh5DCibbhrqE05HN/
	 wnSm6zz4O1zCcIif3hwJODYVbrZ/dfC5oe847WQSoxdN/F8lXKHbd3HAAgiOd6o/Xo8+i
	 Sz7/kQC/2UWoKPafjDOtceMOvnc+C2R7439foFLoKRI/LQrzM9Zxy/sdj/zjsYBnh/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NX4VmOESvu2h0zeC9jC6H7e0M3gEW5R8MwGZphvR9Js=;
	b=N/5pCS3yeGiYshJAnQ2LJyvNTeQn4RL8OO38kHCBBkSx6F7iUQSvWBHtIt6/K639sDKv
	 2otZSL04zdbXp3KGTHKTVPx2gcDLi2IY8AriHBECBi1FRDevzXOv3cfp4YVdIVp8aBPDO
	 dWqB5CW/RDW7rNjxdJKMH+eIu4rTVmVAtwngrthlGWY8jOGF/ZO8m5dVgJ3XAm/9WEt4y
	 Kuyi4KMazOypsbE8T5huRASc74mVW8tPdm2wdZFxYNLWT4Re1W5UPmUbu/m0wGpVJdQ04
	 Qs0XUp1O9oqa6ccbxFWVA1cSX0qpFAvbKkNeLl1OKyxtvXfBlcd3o1N5JD3+BcdHixg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W6jTq6xY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D26607031B;
	Wed,  4 Nov 2026 21:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W6jTq6xY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8471F000C1;
	Wed,  4 Nov 2026 21:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828920;
	bh=NX4VmOESvu2h0zeC9jC6H7e0M3gEW5R8MwGZphvR9Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W6jTq6xYPrXGtWJ196Nq8WjmdkAS5m0z5z9aPoVvjmDqNf3PAcHOc9J1/eBmWQSFo
	 hCNU0MwTWqkiJ9iCZmxt7buyhUcWBtvmjcUANcyjsiDvJ+tuX364odtHVvHD/JCkGN
	 mi/wgOr/81Vck9g+X9fkqxT89skIOxrW/elU3AGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 327/547] xfs: check fork type against dabtree block magic number
Date: Wed,  4 Nov 2026 16:08:31 -0500
Message-ID: <20261104211047.517239547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 43030b72a11a532e7e3c21ac84a8625425b4201b upstream.

LOLLM complains that we fail to flag dabtree blocks that should never be
associated with the file fork -- data forks can't point to xattr leaves,
and attr forks can't point to dirent blocks.  Add the missing checks.

Cc: stable@vger.kernel.org # v4.15
Fixes: 7c4a07a424c18d ("xfs: scrub directory/attribute btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dabtree.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -410,6 +410,10 @@ xchk_da_btree_block(
 				XFS_BLFT_ATTR_LEAF_BUF);
 		blk->magic = XFS_ATTR_LEAF_MAGIC;
 		blk->hashval = xfs_attr_leaf_lasthash(blk->bp, pmaxrecs);
+		if (dargs->whichfork != XFS_ATTR_FORK) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		if (ds->tree_level != 0)
 			xchk_da_set_corrupt(ds, level);
 		break;
@@ -419,6 +423,10 @@ xchk_da_btree_block(
 				XFS_BLFT_DIR_LEAFN_BUF);
 		blk->magic = XFS_DIR2_LEAFN_MAGIC;
 		blk->hashval = xfs_dir2_leaf_lasthash(ip, blk->bp, pmaxrecs);
+		if (dargs->whichfork != XFS_DATA_FORK) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		if (ds->tree_level != 0)
 			xchk_da_set_corrupt(ds, level);
 		break;
@@ -428,6 +436,10 @@ xchk_da_btree_block(
 				XFS_BLFT_DIR_LEAF1_BUF);
 		blk->magic = XFS_DIR2_LEAF1_MAGIC;
 		blk->hashval = xfs_dir2_leaf_lasthash(ip, blk->bp, pmaxrecs);
+		if (dargs->whichfork != XFS_DATA_FORK) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		if (ds->tree_level != 0)
 			xchk_da_set_corrupt(ds, level);
 		break;


