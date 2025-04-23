Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D86927F4D9;
	Wed, 23 Apr 2025 15:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421932; cv=none; b=HQdIgbFHvjmhDEnxuPSFRk+JGxLmWnaN+ZDV3ecqVQQOkPdT/S5hUOsx4S3AXGdinJOSx+e6eGig0Y4IHT53sM2kvFiECdyE1hs0cO2iX+7DMpvz0Sgn0IS31UmopsbN+lek7ZijrQtbCc1zbxCpnEUBixMtH5eEz07i9ARxICA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421932; c=relaxed/simple;
	bh=RafI/QgSK8DVAkh228TsmBPM7LcTt38/Revd1D38KFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWFEf2jr8IUbG7LYGQVMdmfEymKWGiImF4w0X395DjUosCyccwVA1cymwTi3hvkcbhpXAs34N6l3yruSrQ0VRN4ltglfLrDZrBlegnPNG52N2Ik1w6L6BGSq3b4HIkK2my6mQYFqnRBB1JXP4dATiH5+9k6AJe33zaaXEONF6vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RSS4yzT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSS4yzT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31803C4CEE2;
	Wed, 23 Apr 2025 15:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421931;
	bh=RafI/QgSK8DVAkh228TsmBPM7LcTt38/Revd1D38KFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSS4yzT9i0zujS4IlmRY1PTIZh14QyCy9ywsM+Z65OQFeQOl9Q6IGYKOY4B/gxbmQ
	 wSfbfvrfSlYBZmYyJd/3LX2LrSWAy2HlJ8cIgfpLKxwwWcqMfaC4i43Xfo4dptix7A
	 EsfbroOaut+kOdWm2tGuWwVtORDDcmkPIifA4dlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 247/393] md/md-bitmap: fix stats collection for external bitmaps
Date: Wed, 23 Apr 2025 16:42:23 +0200
Message-ID: <20250423142653.582514970@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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
index deb40a8ba3999..8317e07b326d0 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2119,9 +2119,8 @@ int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 
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



