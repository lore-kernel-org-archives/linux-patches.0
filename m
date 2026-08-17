Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB603F23B1;
	Mon, 17 Aug 2026 14:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975396; cv=none; b=aHXtBUvHNNzcnG+kSAxACqUnJeKB9brdJDC2OUaWNHD18TMwlB+Fw6OkgH1O8tM2Ir5RSlKEXtMWfmppFa1w08uQKT4ulRPRcncbL5m86RXXP0p132zML3nwgi8w8xxONI/mdeMZrDNhzqkkc8jmG58eKqNbWpnqNUiZJTllZOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975396; c=relaxed/simple;
	bh=gBjbZ4FUngala8O6Z+FQdpKzVg0DmDvRDe50eHPAlAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/JkQOuMRZEdvd9+xJm2bxOyulrXQStRL56zwiv3z04A0wOF/+Rt36b6G9qdRYzSiBeAxNBRdfGaVeMQLTveSPE8v/yVJvuEdz55M4NFNw4/7A2sGf1zG8eIvHOAKf6EXDQQzfRv3p2td+vgD6VRiMR76Wr63Au/+DJyVQqgihI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0yXg0rQl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yXg0rQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CC31F000E9;
	Mon, 17 Aug 2026 14:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975395;
	bh=/DuFVA72uV7TU2slQAmbQhjie7HIWSi6A8OHQVVDZxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0yXg0rQlQmuqAV+vpGX5WWtdGVvxD7uFlresE4vEISSX6TyJoYnn0Q4Q09JM+Dces
	 GXvpvfnF+mlC50JpN9Q6NrApzQNV9IZm2VnJVfATiv3pD4WyeiYBhstvlPW7NIMx6+
	 McnTF5a2ESahQUf96xPBh7kFGiHd+lxSeHyy1kGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nborisov@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/389] btrfs: remove crc_check logic from free space
Date: Mon, 17 Aug 2026 15:27:33 +0200
Message-ID: <20260817132539.410980773@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit 7dbdb443a7b49f66d9c4da0d810e2c54e0727d82 ]

Following removal of the ino cache io_ctl_init will be called only on
behalf of the freespace inode. In this case we always want to check
CRCs so conditional code that depended on io_ctl::check_crc can be
removed.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: a2d8d5647ed8 ("btrfs: reject free space cache with more entries than pages")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/free-space-cache.c | 37 +++++--------------------------------
 fs/btrfs/free-space-cache.h |  1 -
 2 files changed, 5 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index a779965d299054..756a06f062fdf3 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -304,16 +304,11 @@ static int io_ctl_init(struct btrfs_io_ctl *io_ctl, struct inode *inode,
 		       int write)
 {
 	int num_pages;
-	int check_crcs = 0;
 
 	num_pages = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
 
-	if (btrfs_ino(BTRFS_I(inode)) != BTRFS_FREE_INO_OBJECTID)
-		check_crcs = 1;
-
 	/* Make sure we can fit our crcs and generation into the first page */
-	if (write && check_crcs &&
-	    (num_pages * sizeof(u32) + sizeof(u64)) > PAGE_SIZE)
+	if (write && (num_pages * sizeof(u32) + sizeof(u64)) > PAGE_SIZE)
 		return -ENOSPC;
 
 	memset(io_ctl, 0, sizeof(struct btrfs_io_ctl));
@@ -324,7 +319,6 @@ static int io_ctl_init(struct btrfs_io_ctl *io_ctl, struct inode *inode,
 
 	io_ctl->num_pages = num_pages;
 	io_ctl->fs_info = btrfs_sb(inode->i_sb);
-	io_ctl->check_crcs = check_crcs;
 	io_ctl->inode = inode;
 
 	return 0;
@@ -419,13 +413,8 @@ static void io_ctl_set_generation(struct btrfs_io_ctl *io_ctl, u64 generation)
 	 * Skip the csum areas.  If we don't check crcs then we just have a
 	 * 64bit chunk at the front of the first page.
 	 */
-	if (io_ctl->check_crcs) {
-		io_ctl->cur += (sizeof(u32) * io_ctl->num_pages);
-		io_ctl->size -= sizeof(u64) + (sizeof(u32) * io_ctl->num_pages);
-	} else {
-		io_ctl->cur += sizeof(u64);
-		io_ctl->size -= sizeof(u64) * 2;
-	}
+	io_ctl->cur += (sizeof(u32) * io_ctl->num_pages);
+	io_ctl->size -= sizeof(u64) + (sizeof(u32) * io_ctl->num_pages);
 
 	put_unaligned_le64(generation, io_ctl->cur);
 	io_ctl->cur += sizeof(u64);
@@ -439,14 +428,8 @@ static int io_ctl_check_generation(struct btrfs_io_ctl *io_ctl, u64 generation)
 	 * Skip the crc area.  If we don't check crcs then we just have a 64bit
 	 * chunk at the front of the first page.
 	 */
-	if (io_ctl->check_crcs) {
-		io_ctl->cur += sizeof(u32) * io_ctl->num_pages;
-		io_ctl->size -= sizeof(u64) +
-			(sizeof(u32) * io_ctl->num_pages);
-	} else {
-		io_ctl->cur += sizeof(u64);
-		io_ctl->size -= sizeof(u64) * 2;
-	}
+	io_ctl->cur += sizeof(u32) * io_ctl->num_pages;
+	io_ctl->size -= sizeof(u64) + (sizeof(u32) * io_ctl->num_pages);
 
 	cache_gen = get_unaligned_le64(io_ctl->cur);
 	if (cache_gen != generation) {
@@ -466,11 +449,6 @@ static void io_ctl_set_crc(struct btrfs_io_ctl *io_ctl, int index)
 	u32 crc = ~(u32)0;
 	unsigned offset = 0;
 
-	if (!io_ctl->check_crcs) {
-		io_ctl_unmap_page(io_ctl);
-		return;
-	}
-
 	if (index == 0)
 		offset = sizeof(u32) * io_ctl->num_pages;
 
@@ -488,11 +466,6 @@ static int io_ctl_check_crc(struct btrfs_io_ctl *io_ctl, int index)
 	u32 crc = ~(u32)0;
 	unsigned offset = 0;
 
-	if (!io_ctl->check_crcs) {
-		io_ctl_map_page(io_ctl, 0);
-		return 0;
-	}
-
 	if (index == 0)
 		offset = sizeof(u32) * io_ctl->num_pages;
 
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index e3d5e0ad8f8e4e..d8c2f3df5a0666 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -76,7 +76,6 @@ struct btrfs_io_ctl {
 	int num_pages;
 	int entries;
 	int bitmaps;
-	unsigned check_crcs:1;
 };
 
 struct inode *lookup_free_space_inode(struct btrfs_block_group *block_group,
-- 
2.53.0



