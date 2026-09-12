Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050643DB31A;
	Sat, 12 Sep 2026 12:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217794; cv=none; b=A2CrUCfvGPUUA0ZfvsuyKIwz7tlP2tBlQj/iBOIci5IibFzGfYNWeyIFEO+tyFwPyEmGtvsmeaFBortcUadPcGuxe4sMkNBh77vHszI7isvzCemTbFL1vNFHWqz1XUagjoYweEpOnBpxO3nx7vkP0LEof5SZw1qSmYv3Ol9QXr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217794; c=relaxed/simple;
	bh=rMqjm+ssEbWsd+Sf2+w0Bg6W+1kyo1l6rEPas2vTgB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HH3rmhNp7/O36Sk4HAxGTToAaEbupzY3bi97LVMzEkNrC9cO9g+bTRlcYt7DYXxjL/OdX5RGvWA9nifyI7o486LDbYq0k8JagUqBmSxEhRKfYiM4DVzt6AozJzK3j1K6+cxdC/BQi/0MSPDg5dQbxEutIVT/sVgsUakQNCnWLC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MomrO23N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MomrO23N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9691F000FF;
	Sat, 12 Sep 2026 12:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217792;
	bh=5JgH9yh/CXyTDS/N3mhG5ntIlBN5Bn3nUpnFz8bW4TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MomrO23NmAI6fC3QO5nm6dJ/cMED94FT2Fpp2mf4wJO/UeeoStsXbpdaHoaIwLl2N
	 YGrQhOnaKaInqiaxgLb3XhdfCSdYqca87UVvzKYSJtgUQAQRgXqoaZKsQLaIUKsvFb
	 l0FjkfgD9LwEMihY8SndfqV0fYbR5IFNxWozTBFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0975/1376] block/bdev: lift block size restrictions to 64k
Date: Sat, 12 Sep 2026 08:56:41 +0200
Message-ID: <20260912065629.297388116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit 47dd67532303803a87f43195e088b3b4bcf0454d ]

We now can support blocksizes larger than PAGE_SIZE, so in theory
we should be able to lift the restriction up to the max supported page
cache order. However bound ourselves to what we can currently validate
and test. Through blktests and fstest we can validate up to 64k today.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20250221223823.1680616-8-mcgrof@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: bb31844d88b7 ("scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bdev.c           | 3 +--
 include/linux/blkdev.h | 8 +++++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index e96ff382a1ce9..1092998d28d42 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -198,8 +198,7 @@ int sb_set_blocksize(struct super_block *sb, int size)
 {
 	if (set_blocksize(sb->s_bdev_file, size))
 		return 0;
-	/* If we get here, we know size is power of two
-	 * and it's value is between 512 and PAGE_SIZE */
+	/* If we get here, we know size is validated */
 	sb->s_blocksize = size;
 	sb->s_blocksize_bits = blksize_bits(size);
 	return sb->s_blocksize;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 33f5b16c0fd9a..5a90245fbd8ec 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -268,10 +268,16 @@ static inline dev_t disk_devt(struct gendisk *disk)
 	return MKDEV(disk->major, disk->first_minor);
 }
 
+/*
+ * We should strive for 1 << (PAGE_SHIFT + MAX_PAGECACHE_ORDER)
+ * however we constrain this to what we can validate and test.
+ */
+#define BLK_MAX_BLOCK_SIZE      SZ_64K
+
 /* blk_validate_limits() validates bsize, so drivers don't usually need to */
 static inline int blk_validate_block_size(unsigned long bsize)
 {
-	if (bsize < 512 || bsize > PAGE_SIZE || !is_power_of_2(bsize))
+	if (bsize < 512 || bsize > BLK_MAX_BLOCK_SIZE || !is_power_of_2(bsize))
 		return -EINVAL;
 
 	return 0;
-- 
2.53.0



