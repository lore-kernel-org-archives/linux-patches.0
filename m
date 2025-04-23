Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EB62820A8;
	Wed, 23 Apr 2025 14:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419639; cv=none; b=RoD7tAlWn82iY5QVFFJCH+7UcOU3rxlKI/r9Q3QC9xP4ZeZQ6uryfOav3+/HawtbGb+xLjOIFyokgbdE64tJ4IHYOb4AsTU1eZSBFFIvopVbQWY93iXQT8L7yTN9s07VWB2WiQembBIUgahUvhsEDJ1/HgsVTppBO12Z3uv8Now=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419639; c=relaxed/simple;
	bh=9HV/XbvTkywT2tqbxLFEZPWogID0hZYYdHxmTDgnHxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hckr36tIAY/EBBCguHIKcr1kgoyFgGjtRQJUJbK3lHkcDoCT4MfdYuJYj1qdd1Prprb6LKNGAYNugzxx0SgZuSE6AXkvz3ms0CutPWfyroY4EkNVdUsNQhe+6maEOg7vWEnf6XvdS5HjPOpdEZITQu8TiAwzXj5k4uiIaIjnVjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R69eJI4a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R69eJI4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E53C4CEE3;
	Wed, 23 Apr 2025 14:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419639;
	bh=9HV/XbvTkywT2tqbxLFEZPWogID0hZYYdHxmTDgnHxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R69eJI4adIVgy7lqrTkENiyX28UMatbbuW6DN4GhqNWjYgFRN8XBxLuP02qx3l5/9
	 zcGhU7Q4tqa4BLPjRt/uh/Z1lJMWF158Xkb4kkJbkmWC2tFjc/HPN65xu1rwC9owDi
	 GlxHQI2+am2DFDanJCVhPOT9eVUa2nDnXyKOrZV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/223] md/md-bitmap: fix stats collection for external bitmaps
Date: Wed, 23 Apr 2025 16:41:24 +0200
Message-ID: <20250423142617.620637221@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Qixing <zhengqixing@huawei.com>

[ Upstream commit 6ec1f0239485028445d213d91cfee5242f3211ba ]

The bitmap_get_stats() function incorrectly returns -ENOENT for external
bitmaps.

Remove the external bitmap check as the statistics should be available
regardless of bitmap storage location.

Return -EINVAL only for invalid bitmap with no storage (neither in
superblock nor in external file).

Note: "bitmap_info.external" here refers to a bitmap stored in a separate
file (bitmap_file), not to external metadata.

Fixes: 8d28d0ddb986 ("md/md-bitmap: Synchronize bitmap_get_stats() with bitmap lifetime")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Link: https://lore.kernel.org/linux-raid/20250403015322.2873369-1-zhengqixing@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 2e3087556adb3..fbb4f57010da6 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2355,9 +2355,8 @@ static int bitmap_get_stats(void *data, struct md_bitmap_stats *stats)
 
 	if (!bitmap)
 		return -ENOENT;
-	if (bitmap->mddev->bitmap_info.external)
-		return -ENOENT;
-	if (!bitmap->storage.sb_page) /* no superblock */
+	if (!bitmap->mddev->bitmap_info.external &&
+	    !bitmap->storage.sb_page)
 		return -EINVAL;
 	sb = kmap_local_page(bitmap->storage.sb_page);
 	stats->sync_size = le64_to_cpu(sb->sync_size);
-- 
2.39.5



