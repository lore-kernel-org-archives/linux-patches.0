Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C877D28F92C;
	Wed, 23 Apr 2025 15:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421731; cv=none; b=RHfLpkkqk4VUcm/aZtwZToNZopSej/MWsdtSdmoN7c8P9YNaWmoxh8k4LaMYsGcrFryftGzscOHMS1G6MSlG3loZNJTwN09o4UL7OBxm/GGjVO1/eqwxhKkFbT6qHRmatUHV7SbUFYz9hGnH60Ww5uPAd/Ajz40rZa658mbetN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421731; c=relaxed/simple;
	bh=SskkhmQfkBzM6DAHQlgOoN1BS6LVn/1MByuTBdxe3dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bG+fri9yaWFBDpG+VPKJA1XL5TprR5xj73pHKKphbygOw3flbuSkzApkdV7BPkmlu8TtKXQmdAYKd9C7xDu/l2dNxiiuKR9st1K33Y9QW0RoXzzYePnnjSLwO64uy2qq1Q7FBZ//C8lDIVBaTjpOffxu5gxpOGXH92DSToiRzU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qESxRiB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qESxRiB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1AAC4CEE2;
	Wed, 23 Apr 2025 15:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421731;
	bh=SskkhmQfkBzM6DAHQlgOoN1BS6LVn/1MByuTBdxe3dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qESxRiB/lnQyvDzyn2EwsaJEaZsqjTASOQxa056JTzT4WmVyESO44ciWZIQ4JTCUO
	 t8R28TYNJbHMI5yVEE2qEoNz8h0nu0Hk1hhguIt/kC3AVyAWA2MM3Sh5sRQLNEQgSq
	 dv8oy7nAF+8hhSKRzFPIqfz2BfGV/7httsi6ZUOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 172/291] md/md-bitmap: fix stats collection for external bitmaps
Date: Wed, 23 Apr 2025 16:42:41 +0200
Message-ID: <20250423142631.412746584@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/md/md-bitmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2029,9 +2029,8 @@ int md_bitmap_get_stats(struct bitmap *b
 
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


