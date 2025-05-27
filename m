Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E00271464;
	Tue, 27 May 2025 17:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366318; cv=none; b=tFHw3hvSDNwWOEhIewuIyyHDp8fKHYEE2RyvtdlU1UE0nKXhAzdey091gkv8S6cnLCgovePjfQLV81eS6AtIioLtp5RXa+W6nUZpbyl7uPj1o1erL/NC3q1ntVowRoKdmGfMVWxTZ1B+bles4V7NDI2H6+TwyJTkskXObin3b08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366318; c=relaxed/simple;
	bh=qGB8rheHpHxYizpH5JQaU5ulXJ3FdAnlZS/stPWXdsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/Um4CI8qjxy33Q8bx/cnKtAQxCcJR8ou5oM22eXZMcwVP2adbHL9iamNstB2ryL5vE/1WkBFv+/wE2Vcq0bTWkt9eFNfV2nPNFdK5bIuEqU8eowEY0fga/FLZLuJqHHD9zIrDaT2hodAde8TUPAwTItTPyWOz2I7Ekz2cXCU/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usLJ/xAw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usLJ/xAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BD7C4CEE9;
	Tue, 27 May 2025 17:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366318;
	bh=qGB8rheHpHxYizpH5JQaU5ulXJ3FdAnlZS/stPWXdsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usLJ/xAwVHvOx9vjrer+kMib5xs5mX7HPC725D++FEsAN73Px0T39s9sugKY/EXm6
	 LBEIelsFcv6PB0hrO+ncQMe0RyDl/1TjomNEQ/MrAP+SE4vF7Mt2YUEtLFF6po1abV
	 1If/NnPWIknDVVxlUX7Avy44x3MIFO3a9I3JOBB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Davidlohr Bueso <dave@stgolabs.net>,
	kdevops@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 030/783] fs/buffer: split locking for pagecache lookups
Date: Tue, 27 May 2025 18:17:07 +0200
Message-ID: <20250527162514.350990133@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit 7ffe3de53a885dbb5836541c2178bd07d1bad7df ]

Callers of __find_get_block() may or may not allow for blocking
semantics, and is currently assumed that it will not. Layout
two paths based on this. The the private_lock scheme will
continued to be used for atomic contexts. Otherwise take the
folio lock instead, which protects the buffers, such as
vs migration and try_to_free_buffers().

Per the "hack idea", the latter can alleviate contention on
the private_lock for bdev mappings. For reasons of determinism
and avoid making bugs hard to reproduce, the trylocking is not
attempted.

No change in semantics. All lookup users still take the spinlock.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Link: https://kdevops.org/ext4/v6.15-rc2.html # [0]
Link: https://lore.kernel.org/all/aAAEvcrmREWa1SKF@bombadil.infradead.org/ # [1]
Link: https://lore.kernel.org/20250418015921.132400-2-dave@stgolabs.net
Tested-by: kdevops@lists.linux.dev
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/buffer.c | 41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index cc8452f602516..a03c245022dcf 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -176,18 +176,8 @@ void end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 }
 EXPORT_SYMBOL(end_buffer_write_sync);
 
-/*
- * Various filesystems appear to want __find_get_block to be non-blocking.
- * But it's the page lock which protects the buffers.  To get around this,
- * we get exclusion from try_to_free_buffers with the blockdev mapping's
- * i_private_lock.
- *
- * Hack idea: for the blockdev mapping, i_private_lock contention
- * may be quite high.  This code could TryLock the page, and if that
- * succeeds, there is no need to take i_private_lock.
- */
 static struct buffer_head *
-__find_get_block_slow(struct block_device *bdev, sector_t block)
+__find_get_block_slow(struct block_device *bdev, sector_t block, bool atomic)
 {
 	struct address_space *bd_mapping = bdev->bd_mapping;
 	const int blkbits = bd_mapping->host->i_blkbits;
@@ -204,7 +194,16 @@ __find_get_block_slow(struct block_device *bdev, sector_t block)
 	if (IS_ERR(folio))
 		goto out;
 
-	spin_lock(&bd_mapping->i_private_lock);
+	/*
+	 * Folio lock protects the buffers. Callers that cannot block
+	 * will fallback to serializing vs try_to_free_buffers() via
+	 * the i_private_lock.
+	 */
+	if (atomic)
+		spin_lock(&bd_mapping->i_private_lock);
+	else
+		folio_lock(folio);
+
 	head = folio_buffers(folio);
 	if (!head)
 		goto out_unlock;
@@ -236,7 +235,10 @@ __find_get_block_slow(struct block_device *bdev, sector_t block)
 		       1 << blkbits);
 	}
 out_unlock:
-	spin_unlock(&bd_mapping->i_private_lock);
+	if (atomic)
+		spin_unlock(&bd_mapping->i_private_lock);
+	else
+		folio_unlock(folio);
 	folio_put(folio);
 out:
 	return ret;
@@ -1388,14 +1390,15 @@ lookup_bh_lru(struct block_device *bdev, sector_t block, unsigned size)
  * it in the LRU and mark it as accessed.  If it is not present then return
  * NULL
  */
-struct buffer_head *
-__find_get_block(struct block_device *bdev, sector_t block, unsigned size)
+static struct buffer_head *
+find_get_block_common(struct block_device *bdev, sector_t block,
+			unsigned size, bool atomic)
 {
 	struct buffer_head *bh = lookup_bh_lru(bdev, block, size);
 
 	if (bh == NULL) {
 		/* __find_get_block_slow will mark the page accessed */
-		bh = __find_get_block_slow(bdev, block);
+		bh = __find_get_block_slow(bdev, block, atomic);
 		if (bh)
 			bh_lru_install(bh);
 	} else
@@ -1403,6 +1406,12 @@ __find_get_block(struct block_device *bdev, sector_t block, unsigned size)
 
 	return bh;
 }
+
+struct buffer_head *
+__find_get_block(struct block_device *bdev, sector_t block, unsigned size)
+{
+	return find_get_block_common(bdev, block, size, true);
+}
 EXPORT_SYMBOL(__find_get_block);
 
 /**
-- 
2.39.5



