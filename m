Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1327F7F0;
	Mon,  8 Apr 2024 13:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581979; cv=none; b=oacQjyIWwzecStdgar2MMLRKw6H2qicI9Mi5ZS3lqhLKkK1ZvUSTDKdwCoCuEX3hPasRBJMdCNUMSc90jkdOW33FJlHT4nU+dIJUeJi0blRAGhBGmlpkNHyIqHJxFKj1TRVzSY54ezgpE27dxzy8O+Ot7bOMsJFp4H2WWNQdTo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581979; c=relaxed/simple;
	bh=YDSOsmpmdzEkDcq04GLXyHw/awn3Qnoe04rjDkOQBvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxU8ISeszwDOSj5u9NnveQzxk9ihvsqm+Q8kwLxX58nBmhhd8VQRtSjgFiJCqU54Ww3me7xgmHLhr1SQT6ZRt6HxK1mvs647Ndn8Ul5iWuDXe5QB3UVazChJaEMdad6NJse9ClxFfqd1cdBmiyyImbmb5hCGr+0BAJ1qVc/6sUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trI9LBLS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trI9LBLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70030C433F1;
	Mon,  8 Apr 2024 13:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581978;
	bh=YDSOsmpmdzEkDcq04GLXyHw/awn3Qnoe04rjDkOQBvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trI9LBLS8BCt+0Flcc++3BHAFKflpZgMChOkZXt41w1NqRGNJfPGPZyEBxy3m6OtZ
	 20hHmNipGUgbDk7/IFN/C9aSnIzoNCniCwfQAdZlz9+MWaZ57/nMEbIM563lfgNBVG
	 Cdns435HiMkS42n6VyhyTU4D74pM7b42yOFalpbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/252] btrfs: ensure fiemap doesnt race with writes when FIEMAP_FLAG_SYNC is given
Date: Mon,  8 Apr 2024 14:55:53 +0200
Message-ID: <20240408125308.312970422@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 418b09027743d9a9fb39116bed46a192f868a3c3 ]

When FIEMAP_FLAG_SYNC is given to fiemap the expectation is that that
are no concurrent writes and we get a stable view of the inode's extent
layout.

When the flag is given we flush all IO (and wait for ordered extents to
complete) and then lock the inode in shared mode, however that leaves open
the possibility that a write might happen right after the flushing and
before locking the inode. So fix this by flushing again after locking the
inode - we leave the initial flushing before locking the inode to avoid
holding the lock and blocking other RO operations while waiting for IO
and ordered extents to complete. The second flushing while holding the
inode's lock will most of the time do nothing or very little since the
time window for new writes to have happened is small.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 978b63f7464a ("btrfs: fix race when detecting delalloc ranges during fiemap")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 21 ++++++++-------------
 fs/btrfs/inode.c     | 22 +++++++++++++++++++++-
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fc8eb8d86ca25..45d427c3033d7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2953,17 +2953,15 @@ int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 	range_end = round_up(start + len, sectorsize);
 	prev_extent_end = range_start;
 
-	btrfs_inode_lock(inode, BTRFS_ILOCK_SHARED);
-
 	ret = fiemap_find_last_extent_offset(inode, path, &last_extent_end);
 	if (ret < 0)
-		goto out_unlock;
+		goto out;
 	btrfs_release_path(path);
 
 	path->reada = READA_FORWARD;
 	ret = fiemap_search_slot(inode, path, range_start);
 	if (ret < 0) {
-		goto out_unlock;
+		goto out;
 	} else if (ret > 0) {
 		/*
 		 * No file extent item found, but we may have delalloc between
@@ -3010,7 +3008,7 @@ int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 						  backref_ctx, 0, 0, 0,
 						  prev_extent_end, hole_end);
 			if (ret < 0) {
-				goto out_unlock;
+				goto out;
 			} else if (ret > 0) {
 				/* fiemap_fill_next_extent() told us to stop. */
 				stopped = true;
@@ -3066,7 +3064,7 @@ int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 								  extent_gen,
 								  backref_ctx);
 				if (ret < 0)
-					goto out_unlock;
+					goto out;
 				else if (ret > 0)
 					flags |= FIEMAP_EXTENT_SHARED;
 			}
@@ -3077,7 +3075,7 @@ int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 		}
 
 		if (ret < 0) {
-			goto out_unlock;
+			goto out;
 		} else if (ret > 0) {
 			/* fiemap_fill_next_extent() told us to stop. */
 			stopped = true;
@@ -3088,12 +3086,12 @@ int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 next_item:
 		if (fatal_signal_pending(current)) {
 			ret = -EINTR;
-			goto out_unlock;
+			goto out;
 		}
 
 		ret = fiemap_next_leaf_item(inode, path);
 		if (ret < 0) {
-			goto out_unlock;
+			goto out;
 		} else if (ret > 0) {
 			/* No more file extent items for this inode. */
 			break;
@@ -3117,7 +3115,7 @@ int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 					  &delalloc_cached_state, backref_ctx,
 					  0, 0, 0, prev_extent_end, range_end - 1);
 		if (ret < 0)
-			goto out_unlock;
+			goto out;
 		prev_extent_end = range_end;
 	}
 
@@ -3155,9 +3153,6 @@ int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 	}
 
 	ret = emit_last_fiemap_cache(fieinfo, &cache);
-
-out_unlock:
-	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 out:
 	free_extent_state(delalloc_cached_state);
 	btrfs_free_backref_share_ctx(backref_ctx);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ca79c2b8adc46..1ac14223ffb50 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7813,6 +7813,7 @@ struct iomap_dio *btrfs_dio_write(struct kiocb *iocb, struct iov_iter *iter,
 static int btrfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			u64 start, u64 len)
 {
+	struct btrfs_inode *btrfs_inode = BTRFS_I(inode);
 	int	ret;
 
 	ret = fiemap_prep(inode, fieinfo, start, &len, 0);
@@ -7838,7 +7839,26 @@ static int btrfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			return ret;
 	}
 
-	return extent_fiemap(BTRFS_I(inode), fieinfo, start, len);
+	btrfs_inode_lock(btrfs_inode, BTRFS_ILOCK_SHARED);
+
+	/*
+	 * We did an initial flush to avoid holding the inode's lock while
+	 * triggering writeback and waiting for the completion of IO and ordered
+	 * extents. Now after we locked the inode we do it again, because it's
+	 * possible a new write may have happened in between those two steps.
+	 */
+	if (fieinfo->fi_flags & FIEMAP_FLAG_SYNC) {
+		ret = btrfs_wait_ordered_range(inode, 0, LLONG_MAX);
+		if (ret) {
+			btrfs_inode_unlock(btrfs_inode, BTRFS_ILOCK_SHARED);
+			return ret;
+		}
+	}
+
+	ret = extent_fiemap(btrfs_inode, fieinfo, start, len);
+	btrfs_inode_unlock(btrfs_inode, BTRFS_ILOCK_SHARED);
+
+	return ret;
 }
 
 static int btrfs_writepages(struct address_space *mapping,
-- 
2.43.0



