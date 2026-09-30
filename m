Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F20352CCF0;
	Wed, 30 Sep 2026 17:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791078; cv=none; b=RD1izT3i1DKU6qGNA1nrvr9J1aNbZLcWD4ce46hYRfNeuJjt3WsYUMCKQPGa0D4eTKsa5pHNM2r19goj1eULiwJ3EQliTCft5D0xYceqeJNS8FOU6ka5epT9IslTqY0MOstISFboC92Vh1tJPBOQBeI4bHiRCo2sW4Y/d/uT9zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791078; c=relaxed/simple;
	bh=OIsBII7SByToB6hkPP6ZpA7OA7xGPOYZbeJGq9u2srk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgjzqBELbC0dVD2+n2wTIUWlJJvDQairQfUlsBxc6O5LLAE+vC/1vpzWi75s7K5nV3o2pGdCilHIcJSiM9mQ272grvVygDWhXb7yFbaDyAMRA99a99d5Yj70pFrP5Y1EXjNuFM5CbGBhRTsmG+vZ/luleMfp1v8fE68jet/5LUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3jurWau; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3jurWau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A441F000FF;
	Wed, 30 Sep 2026 17:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791077;
	bh=lfpJ7aTg6I+jgrUz6tGVaD0jeghP7dfllFym2toPqM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3jurWauDyelNTROseKiniJKqLTuXlMZSiwY70kJnHkfAZY4sdqwsCHoDFnCvKvvz
	 oPBPiNoqJQNGLTVqN7QM2/cw3PMOw+1Xs4T8B09KAw66MaAKf1UENc3f7uTJUONUYb
	 niHbmsXEV8kxe4laSlWxClpuztz5eyXLRXC8CXzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KangNing Liao <lkangn.kernel@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/752] btrfs: protect sb_write_pointer() with invalidate lock
Date: Wed, 30 Sep 2026 17:20:04 +0200
Message-ID: <20260930152401.079031415@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: KangNing Liao <lkangn.kernel@gmail.com>

[ Upstream commit 123b9a545f4d0348e81f558a032bf2a93ee5722f ]

sb_write_pointer() reads the super block from the block device page cache
using read_cache_page_gfp(). This has the same race with BLKBSZSET as the
one fixed by commit 3f29d661e568 ("btrfs: sync read disk super and set
block size").

Take the mapping invalidate lock around read_cache_page_gfp() to
serialize the read against block size changes.

Signed-off-by: KangNing Liao <lkangn.kernel@gmail.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index bff56f87b426a..fc20d74447ed6 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -104,8 +104,10 @@ static int sb_write_pointer(struct block_device *bdev, struct blk_zone *zones,
 			bytenr = ((zones[i].start + zones[i].len)
 				   << SECTOR_SHIFT) - BTRFS_SUPER_INFO_SIZE;
 
+			filemap_invalidate_lock(mapping);
 			page[i] = read_cache_page_gfp(mapping,
 					bytenr >> PAGE_SHIFT, GFP_NOFS);
+			filemap_invalidate_unlock(mapping);
 			if (IS_ERR(page[i])) {
 				if (i == 1)
 					btrfs_release_disk_super(super[0]);
-- 
2.53.0



