Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769FC18A6C5;
	Mon, 24 Feb 2025 14:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407806; cv=none; b=lo/0MdAlEoEMupoLV6E8Lvtx8oy/utximPd+lRVA6ANtNY774STEEDIXrvG3YTxzJ3FAJuG1rFSa7zzlbkGsZaq/KukOTw++14a322+Sd8PXcF1ffaqjpHzPPL/Q7jG/Q/DmL++jQeU47snuXwzleTt4AknBXJ+hx4O75xVtTlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407806; c=relaxed/simple;
	bh=QFPUOJIEqcItETYHEp/2VAol/3fKSzZR+P0ONzp0MTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URvuhWww3CKRjE6tCdrUsKo+1MHsNA+7D7rdG+FUP3MF2YtMaV27MkPXJgJtKxkrhsOwbduLQONSsmfaIzxkpD7Kd7TMF2PC1Q7b58Gq+u8iaQd/Y4P02CKDJ8XPIm4PoxvDxZCj4775icnmcVxr6eVjCZwwkTS5Q0q2sYE0qLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StXK8GYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StXK8GYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECF3C4CED6;
	Mon, 24 Feb 2025 14:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407806;
	bh=QFPUOJIEqcItETYHEp/2VAol/3fKSzZR+P0ONzp0MTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StXK8GYQF/NKB6ldY2EIc1OODodx6Bb1gZLCdA5PilvXemrSHfkpnsiLhTh6qPcEx
	 ZjRPIal1XYrQ8jbCvcg8Vxc9HgN15YKJ8GaGjB6MvWFn12aUH9ChOEFy84VDsnN6yZ
	 aj6PLnWNR6C2X/wSIlmWtalpjCLRV74cxISIWrF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 015/140] xfs: support lowmode allocations in xfs_bmap_exact_minlen_extent_alloc
Date: Mon, 24 Feb 2025 15:33:34 +0100
Message-ID: <20250224142603.607078905@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 6aac77059881e4419df499392c995bf02fb9630b upstream.

Currently the debug-only xfs_bmap_exact_minlen_extent_alloc allocation
variant fails to drop into the lowmode last resort allocator, and
thus can sometimes fail allocations for which the caller has a
transaction block reservation.

Fix this by using xfs_bmap_btalloc_low_space to do the actual allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3412,7 +3412,13 @@ xfs_bmap_exact_minlen_extent_alloc(
 	 */
 	ap->blkno = XFS_AGB_TO_FSB(ap->ip->i_mount, 0, 0);
 
-	return xfs_alloc_vextent_first_ag(args, ap->blkno);
+	/*
+	 * Call xfs_bmap_btalloc_low_space here as it first does a "normal" AG
+	 * iteration and then drops args->total to args->minlen, which might be
+	 * required to find an allocation for the transaction reservation when
+	 * the file system is very full.
+	 */
+	return xfs_bmap_btalloc_low_space(ap, args);
 }
 
 /*


