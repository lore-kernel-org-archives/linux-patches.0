Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4E14E3226;
	Thu, 17 Sep 2026 15:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660778; cv=none; b=J9EcPfDrBU8Q5fwbu8gEA9+Bcj3jQsP8EGkMfthcKh0zAZPg/9ai0mzNXnN1BVJ14hHPmrtLw4lVst4/hI50iIrHjJCpNoqeOjM7dOW32TaUAMX2sQOWzwK2ou2TsPF9XtXmrqYmHmKV7U5yISpBgNm/bVvXy8K1/6sMCkapxWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660778; c=relaxed/simple;
	bh=OndRcE25wDhOBxhseXC6tXUPKp7AXNV4DM3l4uLwvSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFrl0a8ui0uUuxbQDu6s6ESZEvobU+nnA/Azebdk14IE9hn2f3KdrKB/K4sHGYPEqhdGQQ8bV9g8i3V2QvqseUTVwfrO1eO3+EuKLCi9TDf4/mqT0vcnHdXDQnJIovuCWM2NLZZJQsZhxdCKxx+JVWlnmDaBRAfHMs9gA7HGyZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lk97C+0+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lk97C+0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B961F000FF;
	Thu, 17 Sep 2026 15:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660777;
	bh=avJVGXImmaweMn8GEaWSS9jmG/WK23Xi4alRE80mV+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lk97C+0+VBj3HJtRQ0GBbOs4+UUMEMElxm70btlge1sWDRfhk0ZMG1oKYEXmdGxhw
	 ELO3qHVleiDcOsWqPmQpeEwF4lqiwzv1n1+W02YePxEUGaVwWGk0A1GMJGfbAqH9x3
	 NJkZptYENKrpF92fL0iq5SUzyrWO7T9kbM+LNLgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 657/733] xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap filesystems
Date: Thu, 17 Sep 2026 16:16:05 +0100
Message-ID: <20260917151409.030671507@linuxfoundation.org>
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
 fs/xfs/libxfs/xfs_rtrmap_btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


