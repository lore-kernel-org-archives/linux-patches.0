Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D17613AA40;
	Wed, 19 Jun 2024 13:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802526; cv=none; b=uR8/DIf2WVWyAAou7Bz5JHgxXCy1FhlDRznhDDPye313BFVP4yhDa13iUX6Zaym7YBkp2neAhHigmnaIJexG34M3O/i+D6l0MbQAfVZJeOe9zB5/NsBgKbjkMjcycGOrYCPd9wvKyt06s9NQ/iwdmGXnWhc+aEozb2lUh+jZAkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802526; c=relaxed/simple;
	bh=8lVgAKEycOldnQ4vPy3Fk/uCwGFunujiJu5HtjRzQdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/wZixVfnwK/o17V4LEdkMFGB32TBvTkPlkWmnRYreK0aC298jisSk4iF248jFRUXE4vJ0HQwKAGbIROxaPZqWhKHmVsRXGiNkmXAtJzRaoE45iq/1/uiFEcbDLrHZOAzvW2NFYGfIz9iSSU+5wlV6uXHQKJOZjslNWQ4ac29C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G8GFJJuP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G8GFJJuP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E0FC2BBFC;
	Wed, 19 Jun 2024 13:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802526;
	bh=8lVgAKEycOldnQ4vPy3Fk/uCwGFunujiJu5HtjRzQdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G8GFJJuPQJ4TOxaa/1Q9wB0ecG8QA0rPfg5TZLMTru3mDVgg70iYygjP7/6BnDcJa
	 fU6WfNYfHEOtKMXIoMMg+LlccfGash6Oqe4oKGYkBEYKXYvxbR9DKPnK4TbwUNilUJ
	 ahqTaVztr2pKHmW/WlQGLG5jvYjyO4sYqijtEfyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 227/267] btrfs: zoned: factor out single bg handling from btrfs_load_block_group_zone_info
Date: Wed, 19 Jun 2024 14:56:18 +0200
Message-ID: <20240619125615.038837103@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 9e0e3e74dc6928a0956f4e27e24d473c65887e96 upstream.

Split the code handling a type single block group from
btrfs_load_block_group_zone_info to make the code more readable.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1374,6 +1374,24 @@ static int btrfs_load_zone_info(struct b
 	return 0;
 }
 
+static int btrfs_load_block_group_single(struct btrfs_block_group *bg,
+					 struct zone_info *info,
+					 unsigned long *active)
+{
+	if (info->alloc_offset == WP_MISSING_DEV) {
+		btrfs_err(bg->fs_info,
+			"zoned: cannot recover write pointer for zone %llu",
+			info->physical);
+		return -EIO;
+	}
+
+	bg->alloc_offset = info->alloc_offset;
+	bg->zone_capacity = info->capacity;
+	if (test_bit(0, active))
+		set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
+	return 0;
+}
+
 int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 {
 	struct btrfs_fs_info *fs_info = cache->fs_info;
@@ -1460,17 +1478,7 @@ int btrfs_load_block_group_zone_info(str
 
 	switch (map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
 	case 0: /* single */
-		if (zone_info[0].alloc_offset == WP_MISSING_DEV) {
-			btrfs_err(fs_info,
-			"zoned: cannot recover write pointer for zone %llu",
-				zone_info[0].physical);
-			ret = -EIO;
-			goto out;
-		}
-		cache->alloc_offset = zone_info[0].alloc_offset;
-		cache->zone_capacity = zone_info[0].capacity;
-		if (test_bit(0, active))
-			set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags);
+		ret = btrfs_load_block_group_single(cache, &zone_info[0], active);
 		break;
 	case BTRFS_BLOCK_GROUP_DUP:
 		if (map->type & BTRFS_BLOCK_GROUP_DATA) {


