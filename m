Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFF1528454;
	Thu, 17 Sep 2026 17:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664424; cv=none; b=A+yjnw4J/ZRGkdfoDzhqp/94bsq/EF711VCuhYXikB3p3dhTzcWEaYeG3USr16FwH80ek4PtXiz/6xsl7rOJ3sAvJ163/eRJVm72LBx9bgSF+7huWKLNy0+LMluL9PjLYsNaNLDttEoIpWdXUrvpI/9x9GWHwBOCzHTo5NspYOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664424; c=relaxed/simple;
	bh=N5CYhvLM6XW9pspcYVX6qUIh6NvyRWT715ghPAmEaqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8pXf9uz2Hn15z7HohRptkSugawU7LP8DpVRe8Eg7oPvpcuFVG80UcMNGt6Yb6KjNEUSFqMvocCeewIPGwCvULH5KEDOzkIU0MfzZEF6vRVwQkWdXOfWtZ+3s5liN6qxhezUhC1p5yLqjfWDIEr75ZRgXIrHxbPeu61uBdiur6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/8nJmMc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/8nJmMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322B41F000FF;
	Thu, 17 Sep 2026 17:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664422;
	bh=z2u3u1wVh7a9rhVQ0Pkwpu3XKvWrACdj5kHRo1HeD2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/8nJmMcm3+gRmRKmavAjWUYDtBcFG60gPy83S8Ct2zLv9+3WD5sr/X2KmZkJ9VFk
	 NdCp+bmgcb2RwqJ3Pc2yMxXSbxQe9ogAf3rUdkWIg2XzaTwFT2gAdhPMTca7AVV9oQ
	 hFPSwSAs7iIC42FALvEk3eXMSMks+9+5zwS6n61w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KangNing Liao <lkangn.kernel@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0368/1250] btrfs: protect sb_write_pointer() with invalidate lock
Date: Thu, 17 Sep 2026 16:02:43 +0100
Message-ID: <20260917151602.033076744@linuxfoundation.org>
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
index 548cfc0fe28e0..0174c3f9cfb8e 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -130,8 +130,10 @@ static int sb_write_pointer(struct block_device *bdev, struct blk_zone *zones,
 			u64 bytenr = ALIGN_DOWN(zone_end, BTRFS_SUPER_INFO_SIZE) -
 						BTRFS_SUPER_INFO_SIZE;
 
+			filemap_invalidate_lock(mapping);
 			page[i] = read_cache_page_gfp(mapping,
 					bytenr >> PAGE_SHIFT, GFP_NOFS);
+			filemap_invalidate_unlock(mapping);
 			if (IS_ERR(page[i])) {
 				if (i == 1)
 					btrfs_release_disk_super(super[0]);
-- 
2.53.0



