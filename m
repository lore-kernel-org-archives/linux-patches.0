Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215EC4AEDF;
	Mon,  1 Apr 2024 15:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986695; cv=none; b=p8vKkatfKybs8S2Dkr6gup/oG5n5HCbgqpU+KPi4EESn1h3kmNn9a3CAsNRgsY3gpWLu1Uj5r71jehdGjAi39oLtBLpMmllbnRRK/Wr8DAJVYOpIROmd81ey+lM6UIyLefWyjcuqusiA/XNFKpPrwEYOfMWP3GeHMbIWdFq9WK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986695; c=relaxed/simple;
	bh=GLbB4M3BlyP194jYoKCngNVrW+tIENRmsPz9blbsjdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csSe7TDdkAfieR3N1vs83cC8Vog2TZNdajFUcjyEAt2PtPIfTCMSzsNqdDH1kGvfrAbvBbOLNWrYSyjSlHnxHxDkOeLxRcnTGYwoFcMhTLhkDL7GsTeZo8hz5pX6W6Bd0bapEE6wKGMEoKzpEMLUhcCkX2La+kcY8bKTA5tLL4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kl7oEP3B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kl7oEP3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4988BC43390;
	Mon,  1 Apr 2024 15:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986694;
	bh=GLbB4M3BlyP194jYoKCngNVrW+tIENRmsPz9blbsjdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kl7oEP3BDSyMI5bpQdG934Zk/83FSt1qku4oO3/6dxQJQorcV6WHTyABVoJPfs2K1
	 uOhnuTDgc+UlNqD60SBBZSOEUtXgkakF/PCKRkCzym4DeU90uMiJk9Nj2JsAJWLOnh
	 6kSYBVyJBSp+R8+W9jcp816pzt1zn6NpjLDvTUpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>,
	Christoph Hellwig <hch@lst.de>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 055/399] md/md-bitmap: fix incorrect usage for sb_index
Date: Mon,  1 Apr 2024 17:40:21 +0200
Message-ID: <20240401152550.827028884@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heming Zhao <heming.zhao@suse.com>

[ Upstream commit ecbd8ebb51bf7e4939d83b9e6022a55cac44ef06 ]

Commit d7038f951828 ("md-bitmap: don't use ->index for pages backing the
bitmap file") removed page->index from bitmap code, but left wrong code
logic for clustered-md. current code never set slot offset for cluster
nodes, will sometimes cause crash in clustered env.

Call trace (partly):
 md_bitmap_file_set_bit+0x110/0x1d8 [md_mod]
 md_bitmap_startwrite+0x13c/0x240 [md_mod]
 raid1_make_request+0x6b0/0x1c08 [raid1]
 md_handle_request+0x1dc/0x368 [md_mod]
 md_submit_bio+0x80/0xf8 [md_mod]
 __submit_bio+0x178/0x300
 submit_bio_noacct_nocheck+0x11c/0x338
 submit_bio_noacct+0x134/0x614
 submit_bio+0x28/0xdc
 submit_bh_wbc+0x130/0x1cc
 submit_bh+0x1c/0x28

Fixes: d7038f951828 ("md-bitmap: don't use ->index for pages backing the bitmap file")
Cc: stable@vger.kernel.org # v6.6+
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240223121128.28985-1-heming.zhao@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 9672f75c30503..a4976ceae8688 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -234,7 +234,8 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
 	sector_t doff;
 
 	bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
-	if (pg_index == store->file_pages - 1) {
+	/* we compare length (page numbers), not page offset. */
+	if ((pg_index - store->sb_index) == store->file_pages - 1) {
 		unsigned int last_page_size = store->bytes & (PAGE_SIZE - 1);
 
 		if (last_page_size == 0)
@@ -438,8 +439,8 @@ static void filemap_write_page(struct bitmap *bitmap, unsigned long pg_index,
 	struct page *page = store->filemap[pg_index];
 
 	if (mddev_is_clustered(bitmap->mddev)) {
-		pg_index += bitmap->cluster_slot *
-			DIV_ROUND_UP(store->bytes, PAGE_SIZE);
+		/* go to node bitmap area starting point */
+		pg_index += store->sb_index;
 	}
 
 	if (store->file)
@@ -952,6 +953,7 @@ static void md_bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	unsigned long index = file_page_index(store, chunk);
 	unsigned long node_offset = 0;
 
+	index += store->sb_index;
 	if (mddev_is_clustered(bitmap->mddev))
 		node_offset = bitmap->cluster_slot * store->file_pages;
 
@@ -982,6 +984,7 @@ static void md_bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
 	unsigned long index = file_page_index(store, chunk);
 	unsigned long node_offset = 0;
 
+	index += store->sb_index;
 	if (mddev_is_clustered(bitmap->mddev))
 		node_offset = bitmap->cluster_slot * store->file_pages;
 
-- 
2.43.0



