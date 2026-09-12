Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129222E2663;
	Sat, 12 Sep 2026 14:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222398; cv=none; b=MrP1yRiShcQazm9OnBp3584RdOCHc4Hnq8WRxnakth0VRQWLFr8Q0MgucG2mSnC90D2fo0l2BsWtzWEdWdja0kdo8qb4mkVjkRJhi/GVnF03aQF0Hbs6EFel4a5S/49kZhGR2lYPmn8dxIf9GDBGCfgt7Ljb/PUkeC2mw6927u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222398; c=relaxed/simple;
	bh=Yk1ZfmZH+nwM8H4RMkgweDPfDQNbpNZGZ8FKFAqUbCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/Ox1ymBUS3fIWUU/7Qfp+yDFxlxsDpztZP0gjprXHtdrZXh15FYP22v1HP54I69sXDO2GhSkvWOShW9b9FrxPXCFPcD9gVUPvHVQtzqqCsmU1QGpvCnO6cV3mAocQkdm7guNK6hSETQyVwdltJJ9oOH5dYQkmc3F9jgfXxu6fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBy/zoU/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBy/zoU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E1B1F000FF;
	Sat, 12 Sep 2026 14:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222396;
	bh=oOyRC5k516Yv1Ugb4D1u3Wm8aj79GvnfvOW0i2hWmdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBy/zoU/c6673vyp2hMERexy4qlGowDjwq+W7Uj/wUUYqhK7xtCIAheDyBIbyz9M/
	 yxrlhart/yu9WHV7oFsNZnf/hxBvxSpMAozmgOip061Cg7vRaC6tLF+HePYKS/zHIu
	 /uWhmOIPgKonmBpoMJrO8XIchVVsICPNPrO9N7Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Yue <glass.su@suse.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0541/1424] md/md-bitmap: fix wrong bitmap_limit for clustermd when write sb
Date: Sat, 12 Sep 2026 08:49:33 +0200
Message-ID: <20260912065619.417297646@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Yue <glass.su@suse.com>

[ Upstream commit 6130825f34d41718c98a9b1504a79a23e379701e ]

In clustermd, separate write-intent-bitmaps are used for each cluster
node:

0                    4k                     8k                    12k
-------------------------------------------------------------------
| idle                | md super            | bm super [0] + bits |
| bm bits[0, contd]   | bm super[1] + bits  | bm bits[1, contd]   |
| bm super[2] + bits  | bm bits [2, contd]  | bm super[3] + bits  |
| bm bits [3, contd]  |                     |                     |

So in node 1, pg_index in __write_sb_page() could equal to
bitmap->storage.file_pages. Then bitmap_limit will be calculated to
0. md_super_write() will be called with 0 size.
That means the first 4k sb area of node 1 will never be updated
through filemap_write_page().
This bug causes hang of mdadm/clustermd_tests/01r1_Grow_resize.

Here use (pg_index % bitmap->storage.file_pages) to make calculation
of bitmap_limit correct.

Fixes: ab99a87542f1 ("md/md-bitmap: fix writing non bitmap pages")
Signed-off-by: Su Yue <glass.su@suse.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Link: https://lore.kernel.org/linux-raid/20250303033918.32136-1-glass.su@suse.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index ace28eb81111c..03be53313e3c1 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -227,8 +227,8 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
 	struct block_device *bdev;
 	struct mddev *mddev = bitmap->mddev;
 	struct bitmap_storage *store = &bitmap->storage;
-	unsigned int bitmap_limit = (bitmap->storage.file_pages - pg_index) <<
-		PAGE_SHIFT;
+	unsigned long num_pages = bitmap->storage.file_pages;
+	unsigned int bitmap_limit = (num_pages - pg_index % num_pages) << PAGE_SHIFT;
 	loff_t sboff, offset = mddev->bitmap_info.offset;
 	sector_t ps = pg_index * PAGE_SIZE / SECTOR_SIZE;
 	unsigned int size = PAGE_SIZE;
@@ -237,7 +237,7 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
 
 	bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
 	/* we compare length (page numbers), not page offset. */
-	if ((pg_index - store->sb_index) == store->file_pages - 1) {
+	if ((pg_index - store->sb_index) == num_pages - 1) {
 		unsigned int last_page_size = store->bytes & (PAGE_SIZE - 1);
 
 		if (last_page_size == 0)
-- 
2.53.0



