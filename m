Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8CE1DFE0F;
	Tue,  8 Oct 2024 13:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394241; cv=none; b=V5/gCnCzAHpA04Ow2WHV8GCWf0TPb5ZksxOPCH+U3ezMWUSUgEQxlxAh4xIH5fmnhD91zlmRbh8/9LlerCzOw+FFFFPvlpIA8ZEnV6byme2GYabf8Bfc8ZDhqXb++kIVEbUzaSmuiZLEh7Nk5Nd8EeexfrdfU+x9kIHPY+78j9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394241; c=relaxed/simple;
	bh=w9liF0c9UnmKwp1EGFQldQx1lmSV3R3diA0eqONCYUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0LO+D7xBVuN6enzklVUgeht2rBpt270F6I95fw2iUORqsAnv5maBjuKmLSz4HHPs9ATJ2dXhExojYe6UIJ9sOc8m3Blwg1LgJzoengpgOPIik+q/TmoGNrk8uy2v7dSIL5DVQdPhG6Ebus/LMvNCafo01wGLQWhX1tMlk67/P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWgULPjb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWgULPjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C60C4CEC7;
	Tue,  8 Oct 2024 13:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394240;
	bh=w9liF0c9UnmKwp1EGFQldQx1lmSV3R3diA0eqONCYUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWgULPjbed/Iug94RaDlBm6Unfa+HsQip1vwrLFlw8DrFifZD/WmEOYp5WbRzIB4H
	 aRL6A7QPyyIm75tkO3qUG6mJ/vLLjFrVcdUhl5g0bBY+NJYbLvRP2+066yu19Tvu/E
	 un5Djo92EU9PXZ/Mf+qwgESdBFNwVnHLi8WgdbEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 363/386] btrfs: relocation: return bool from btrfs_should_ignore_reloc_root
Date: Tue,  8 Oct 2024 14:10:08 +0200
Message-ID: <20241008115643.667467477@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit 32f2abca380fedc60f7a8d3288e4c9586672e207 ]

btrfs_should_ignore_reloc_root() is a predicate so it should return
bool.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: db7e68b522c0 ("btrfs: drop the backref cache during relocation if we commit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 19 +++++++++----------
 fs/btrfs/relocation.h |  2 +-
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 05b2a59ce8897..1f4fd6c86fb00 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -329,31 +329,30 @@ static bool have_reloc_root(struct btrfs_root *root)
 	return true;
 }
 
-int btrfs_should_ignore_reloc_root(struct btrfs_root *root)
+bool btrfs_should_ignore_reloc_root(struct btrfs_root *root)
 {
 	struct btrfs_root *reloc_root;
 
 	if (!test_bit(BTRFS_ROOT_SHAREABLE, &root->state))
-		return 0;
+		return false;
 
 	/* This root has been merged with its reloc tree, we can ignore it */
 	if (reloc_root_is_dead(root))
-		return 1;
+		return true;
 
 	reloc_root = root->reloc_root;
 	if (!reloc_root)
-		return 0;
+		return false;
 
 	if (btrfs_header_generation(reloc_root->commit_root) ==
 	    root->fs_info->running_transaction->transid)
-		return 0;
+		return false;
 	/*
-	 * if there is reloc tree and it was created in previous
-	 * transaction backref lookup can find the reloc tree,
-	 * so backref node for the fs tree root is useless for
-	 * relocation.
+	 * If there is reloc tree and it was created in previous transaction
+	 * backref lookup can find the reloc tree, so backref node for the fs
+	 * tree root is useless for relocation.
 	 */
-	return 1;
+	return true;
 }
 
 /*
diff --git a/fs/btrfs/relocation.h b/fs/btrfs/relocation.h
index 77d69f6ae967c..af749c780b4e7 100644
--- a/fs/btrfs/relocation.h
+++ b/fs/btrfs/relocation.h
@@ -18,7 +18,7 @@ int btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
 			      struct btrfs_pending_snapshot *pending);
 int btrfs_should_cancel_balance(struct btrfs_fs_info *fs_info);
 struct btrfs_root *find_reloc_root(struct btrfs_fs_info *fs_info, u64 bytenr);
-int btrfs_should_ignore_reloc_root(struct btrfs_root *root);
+bool btrfs_should_ignore_reloc_root(struct btrfs_root *root);
 u64 btrfs_get_reloc_bg_bytenr(struct btrfs_fs_info *fs_info);
 
 #endif
-- 
2.43.0



