Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AA3185E7F;
	Tue, 27 May 2025 17:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366321; cv=none; b=XephF7cITn7SU9H5rRq7rocSZ6BG/pZDFIAXFhSIt794VBbu7TKIBkkfOEa5/jy2DAoHb645QaGkE44ZXsp8tizsbPjDTa7kcM/eITOm/dmTFMK9iexjqb4Lz4Jb3dgtc02hSsvsJqZY8zdR8hS9RbvoiF2iU3i3uM3G+0wPh6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366321; c=relaxed/simple;
	bh=zl4akWeOOXGssNl7sYYrhvUX7TOv5JeRri2bFtWWfi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZyqFvPjVaGZ+9zy0dKhY1+ItNTjIhKEtMfDreYnmhcI/WoX+TqRc17MlheHAs7YKmwx8Yn5DQeHj+xPKO33LtwlPUErQvult1kz1EaHdg8euozcCe9Z2mHwzyHCkdYGX0DrkbKlJREnZX+xhh0U+nAP+xVtW7/WFy9zYhDLjYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrzLj6B6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrzLj6B6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CCBC4CEE9;
	Tue, 27 May 2025 17:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366321;
	bh=zl4akWeOOXGssNl7sYYrhvUX7TOv5JeRri2bFtWWfi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vrzLj6B6dR4FnZQLZlV0N55akYTwIxdMsT5c9tk/qC3CBu1DaX177kJJEpqTIFUCG
	 rYljwYNnLjfwtU6ASq8PMBKcUeoq5cqXDW8vdGgMDca7FYKI5zfiZE4Ax418Dh7Owh
	 qopo3po377QbkLl9nN2d4yKVwIM+Wbne1vm8kkR0=
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
Subject: [PATCH 6.14 031/783] fs/buffer: introduce sleeping flavors for pagecache lookups
Date: Tue, 27 May 2025 18:17:08 +0200
Message-ID: <20250527162514.392451899@linuxfoundation.org>
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

[ Upstream commit 2814a7d3d2ff5d2cdd22936f641f758fdb971fa0 ]

Add __find_get_block_nonatomic() and sb_find_get_block_nonatomic()
calls for which users will be converted where safe. These versions
will take the folio lock instead of the mapping's private_lock.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Link: https://kdevops.org/ext4/v6.15-rc2.html # [0]
Link: https://lore.kernel.org/all/aAAEvcrmREWa1SKF@bombadil.infradead.org/ # [1]
Link: https://lore.kernel.org/20250418015921.132400-3-dave@stgolabs.net
Tested-by: kdevops@lists.linux.dev
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/buffer.c                 | 9 +++++++++
 include/linux/buffer_head.h | 8 ++++++++
 2 files changed, 17 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index a03c245022dcf..7981097c846d4 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1414,6 +1414,15 @@ __find_get_block(struct block_device *bdev, sector_t block, unsigned size)
 }
 EXPORT_SYMBOL(__find_get_block);
 
+/* same as __find_get_block() but allows sleeping contexts */
+struct buffer_head *
+__find_get_block_nonatomic(struct block_device *bdev, sector_t block,
+			   unsigned size)
+{
+	return find_get_block_common(bdev, block, size, false);
+}
+EXPORT_SYMBOL(__find_get_block_nonatomic);
+
 /**
  * bdev_getblk - Get a buffer_head in a block device's buffer cache.
  * @bdev: The block device.
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 932139c5d46f5..ffcd76d977703 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -223,6 +223,8 @@ void __wait_on_buffer(struct buffer_head *);
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 struct buffer_head *__find_get_block(struct block_device *bdev, sector_t block,
 			unsigned size);
+struct buffer_head *__find_get_block_nonatomic(struct block_device *bdev,
+			sector_t block, unsigned size);
 struct buffer_head *bdev_getblk(struct block_device *bdev, sector_t block,
 		unsigned size, gfp_t gfp);
 void __brelse(struct buffer_head *);
@@ -398,6 +400,12 @@ sb_find_get_block(struct super_block *sb, sector_t block)
 	return __find_get_block(sb->s_bdev, block, sb->s_blocksize);
 }
 
+static inline struct buffer_head *
+sb_find_get_block_nonatomic(struct super_block *sb, sector_t block)
+{
+	return __find_get_block_nonatomic(sb->s_bdev, block, sb->s_blocksize);
+}
+
 static inline void
 map_bh(struct buffer_head *bh, struct super_block *sb, sector_t block)
 {
-- 
2.39.5



