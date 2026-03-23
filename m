Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3840323B62C;
	Mon, 23 Mar 2026 14:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277542; cv=none; b=pA9x+ITP2o/M0s0+hY+1EKNHAO4CwNhmdws2mWa63ZMcDLHaxa4uHuP0SHYbFqk02Z6XEVt3giGHxkuEnb5kg9k2WpPnVdXSLVIuZwoIBqKf8ExvJy6NInvncS9VWhjP1cmiBXyetZ+o9JHba7bShZnURRECHGFFj6KqrrGJmWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277542; c=relaxed/simple;
	bh=mbD5WIVvIaUpYORxZGbAcQFkzw5kpyR1RB8c2VwwLrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1X1Ovt40EjGORyl1/jBZ4lb7HCuQkSO5SEQEHfZbc2TYatCnu6H85pF2uYYi9A0IQC+dK3kQFgSfFY+Wx8+ifZkD0rS4AHsXR7h8P1x3Vo9BB0PBn08CJsjpEBNhrz/fiokdDzAzMTFyi0SaDmOQ4/4EloybJuPotIwyxTdRnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXuxdkD6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXuxdkD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE92DC4CEF7;
	Mon, 23 Mar 2026 14:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277542;
	bh=mbD5WIVvIaUpYORxZGbAcQFkzw5kpyR1RB8c2VwwLrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXuxdkD6JeN3no6oUXqincMpeV//hY3UK5K6rPYAPWNK6MM7Ge8l0NW00kyzU+1tI
	 RC+pkAfviia8IiwA3cYNjWlsbi1jsqB+c8FlsnyI7zioe2gm5lBuqQKAipn/37GgGn
	 x5HV53EhIdMbhzvwL67qXMtr5mPO91ib++IXO+iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/567] btrfs: remove btrfs_crc32c wrapper
Date: Mon, 23 Mar 2026 14:38:56 +0100
Message-ID: <20260323134534.168944393@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 03e86348965a5fa13593db8682132033d663f7ee ]

This simply sends the same arguments into crc32c(), and is just used in
a few places.  Remove this wrapper and directly call crc32c() in these
instances.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 511dc8912ae3 ("btrfs: fix incorrect key offset in error message in check_dev_extent_item()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h            | 5 -----
 fs/btrfs/extent-tree.c      | 6 +++---
 fs/btrfs/free-space-cache.c | 4 ++--
 fs/btrfs/send.c             | 6 +++---
 4 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3108852ff47d7..11691c70ba791 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -472,11 +472,6 @@ static inline u32 BTRFS_MAX_XATTR_SIZE(const struct btrfs_fs_info *info)
 #define BTRFS_BYTES_TO_BLKS(fs_info, bytes) \
 				((bytes) >> (fs_info)->sectorsize_bits)
 
-static inline u32 btrfs_crc32c(u32 crc, const void *address, unsigned length)
-{
-	return crc32c(crc, address, length);
-}
-
 static inline u64 btrfs_name_hash(const char *name, int len)
 {
        return crc32c((u32)~1, name, len);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 774bdafc822c1..1528a81b2c307 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -414,11 +414,11 @@ u64 hash_extent_data_ref(u64 root_objectid, u64 owner, u64 offset)
 	__le64 lenum;
 
 	lenum = cpu_to_le64(root_objectid);
-	high_crc = btrfs_crc32c(high_crc, &lenum, sizeof(lenum));
+	high_crc = crc32c(high_crc, &lenum, sizeof(lenum));
 	lenum = cpu_to_le64(owner);
-	low_crc = btrfs_crc32c(low_crc, &lenum, sizeof(lenum));
+	low_crc = crc32c(low_crc, &lenum, sizeof(lenum));
 	lenum = cpu_to_le64(offset);
-	low_crc = btrfs_crc32c(low_crc, &lenum, sizeof(lenum));
+	low_crc = crc32c(low_crc, &lenum, sizeof(lenum));
 
 	return ((u64)high_crc << 31) ^ (u64)low_crc;
 }
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index edf3612ba3108..c6e3b9a2921ab 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -545,7 +545,7 @@ static void io_ctl_set_crc(struct btrfs_io_ctl *io_ctl, int index)
 	if (index == 0)
 		offset = sizeof(u32) * io_ctl->num_pages;
 
-	crc = btrfs_crc32c(crc, io_ctl->orig + offset, PAGE_SIZE - offset);
+	crc = crc32c(crc, io_ctl->orig + offset, PAGE_SIZE - offset);
 	btrfs_crc32c_final(crc, (u8 *)&crc);
 	io_ctl_unmap_page(io_ctl);
 	tmp = page_address(io_ctl->pages[0]);
@@ -567,7 +567,7 @@ static int io_ctl_check_crc(struct btrfs_io_ctl *io_ctl, int index)
 	val = *tmp;
 
 	io_ctl_map_page(io_ctl, 0);
-	crc = btrfs_crc32c(crc, io_ctl->orig + offset, PAGE_SIZE - offset);
+	crc = crc32c(crc, io_ctl->orig + offset, PAGE_SIZE - offset);
 	btrfs_crc32c_final(crc, (u8 *)&crc);
 	if (val != crc) {
 		btrfs_err_rl(io_ctl->fs_info,
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6768e2231d610..4fa05ee81d434 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -814,7 +814,7 @@ static int send_cmd(struct send_ctx *sctx)
 	put_unaligned_le32(sctx->send_size - sizeof(*hdr), &hdr->len);
 	put_unaligned_le32(0, &hdr->crc);
 
-	crc = btrfs_crc32c(0, (unsigned char *)sctx->send_buf, sctx->send_size);
+	crc = crc32c(0, (unsigned char *)sctx->send_buf, sctx->send_size);
 	put_unaligned_le32(crc, &hdr->crc);
 
 	ret = write_buf(sctx->send_filp, sctx->send_buf, sctx->send_size,
@@ -5740,8 +5740,8 @@ static int send_encoded_extent(struct send_ctx *sctx, struct btrfs_path *path,
 	hdr = (struct btrfs_cmd_header *)sctx->send_buf;
 	hdr->len = cpu_to_le32(sctx->send_size + disk_num_bytes - sizeof(*hdr));
 	hdr->crc = 0;
-	crc = btrfs_crc32c(0, sctx->send_buf, sctx->send_size);
-	crc = btrfs_crc32c(crc, sctx->send_buf + data_offset, disk_num_bytes);
+	crc = crc32c(0, sctx->send_buf, sctx->send_size);
+	crc = crc32c(crc, sctx->send_buf + data_offset, disk_num_bytes);
 	hdr->crc = cpu_to_le32(crc);
 
 	ret = write_buf(sctx->send_filp, sctx->send_buf, sctx->send_size,
-- 
2.51.0



