Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D8D3376A9;
	Mon, 18 Aug 2025 14:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526341; cv=none; b=tHlVHhwckpA1EyJx9u1z0Uw21s6k4oKug8aVJa2lcX919DjK3cNpslRzd94WCgasULwyYRtyFCN8yLeb34YdeCsgvkXtTPoSzqEHI2eYBNqfK8zgwtJTl4B5+bxHRUMAz5/gbaOiSl3upoeoCFWr+lytK9c8lkGC3HWOaH4Hj20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526341; c=relaxed/simple;
	bh=Prd85aY9yw7N/wyA2AMhzIynte7Ch4NsN5u5IZBIWR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqiX6zk0a0GWz5fpBojfWKn3XRfdCSbtiIf2Jt8YpNGEuv3Z/ObX237bG5Uy1u3MV2yiln05I1HtvrxeR2OzUwryT6XlVfOetd0gFBiCXBjuKb/htdEzlXRGcQQzVC3W5Q5lLx1E69fvh7B7DjhCxcm7L5N8G+1k7Jstp+p0r3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOn5ibuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOn5ibuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36801C4CEEB;
	Mon, 18 Aug 2025 14:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526341;
	bh=Prd85aY9yw7N/wyA2AMhzIynte7Ch4NsN5u5IZBIWR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOn5ibuCUquWHQF9vlsUghpDem3Z8FGRJOrsK06UczanFpzZj+O8o6zegwrywbate
	 hSZAHoBXPHxfIJRAFYsD5ujySj4tipuZZSha4TgiixguGLeaS87R8Sm17DtcACvLon
	 lA/KCap6LWDu+4zhpru1MGzYiKMHry3CL8dchAVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.16 528/570] btrfs: error on missing block group when unaccounting log tree extent buffers
Date: Mon, 18 Aug 2025 14:48:35 +0200
Message-ID: <20250818124526.205927704@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit fc5799986fbca957e2e3c0480027f249951b7bcf upstream.

Currently we only log an error message if we can't find the block group
for a log tree extent buffer when unaccounting it (while freeing a log
tree). A missing block group means something is seriously wrong and we
end up leaking space from the metadata space info. So return -ENOENT in
case we don't find the block group.

CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2574,14 +2574,14 @@ static int replay_one_buffer(struct btrf
 /*
  * Correctly adjust the reserved bytes occupied by a log tree extent buffer
  */
-static void unaccount_log_buffer(struct btrfs_fs_info *fs_info, u64 start)
+static int unaccount_log_buffer(struct btrfs_fs_info *fs_info, u64 start)
 {
 	struct btrfs_block_group *cache;
 
 	cache = btrfs_lookup_block_group(fs_info, start);
 	if (!cache) {
 		btrfs_err(fs_info, "unable to find block group for %llu", start);
-		return;
+		return -ENOENT;
 	}
 
 	spin_lock(&cache->space_info->lock);
@@ -2592,27 +2592,22 @@ static void unaccount_log_buffer(struct
 	spin_unlock(&cache->space_info->lock);
 
 	btrfs_put_block_group(cache);
+
+	return 0;
 }
 
 static int clean_log_buffer(struct btrfs_trans_handle *trans,
 			    struct extent_buffer *eb)
 {
-	int ret;
-
 	btrfs_tree_lock(eb);
 	btrfs_clear_buffer_dirty(trans, eb);
 	wait_on_extent_buffer_writeback(eb);
 	btrfs_tree_unlock(eb);
 
-	if (trans) {
-		ret = btrfs_pin_reserved_extent(trans, eb);
-		if (ret)
-			return ret;
-	} else {
-		unaccount_log_buffer(eb->fs_info, eb->start);
-	}
+	if (trans)
+		return btrfs_pin_reserved_extent(trans, eb);
 
-	return 0;
+	return unaccount_log_buffer(eb->fs_info, eb->start);
 }
 
 static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,


