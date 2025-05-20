Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541512505C7;
	Tue, 20 May 2025 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750671; cv=none; b=c9oU+yBQEjuoEMLWbJtZvHF9B758hY5H+KEqFftVeidPmm2MyhdqOCUNZtr047lRtsQoWTK8WDw6sKD8UvyNdi3YLBPt99Iy3UFiKqVMJIGvnSEYS8U1JYRijSjJkyLwVv+pA6wFDk3pEJ5et4nH0OrxJBKoQ/vT3mcGDwntiTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750671; c=relaxed/simple;
	bh=VsiOQTTZlodxZtTyG+5cNDL//iaSCnRn28yRgdiyIr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tU7G/Ei9Eld3eYNacW8DcxWDBL0Hsn4CA3Mfd4Sr0wONGlXBWN3Pj/aR/Tode1xdp3fYPdItMBFrdaJZAgOCYmlX0CnaKT5UwSrrsE7GLxIRjbPR4lA6NpG7kS8tKI0G+9Hd7azHvKoR2c41+eQ3M01eYVqkoZEalDQ558WHN/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ah6Ma8V+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ah6Ma8V+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B933AC4CEE9;
	Tue, 20 May 2025 14:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750671;
	bh=VsiOQTTZlodxZtTyG+5cNDL//iaSCnRn28yRgdiyIr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ah6Ma8V+86bHW3sjMJFs9DBvazYD/N/HB9Y2Tro02wYbX8Ipftr68WRt9/yADl9OJ
	 0wLG4IptB4BP1OlxMzsMknsgV9QvMf3cYbd4gqJqIDf/v77pLsJPANzohIs1XlAy0M
	 fChYkCM9c4mo70V4Z884PtWoy5L1Su2Jtbnsno5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.14 076/145] btrfs: fix folio leak in submit_one_async_extent()
Date: Tue, 20 May 2025 15:50:46 +0200
Message-ID: <20250520125813.561804012@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

From: Boris Burkov <boris@bur.io>

commit a0fd1c6098633f9a95fc2f636383546c82b704c3 upstream.

If btrfs_reserve_extent() fails while submitting an async_extent for a
compressed write, then we fail to call free_async_extent_pages() on the
async_extent and leak its folios. A likely cause for such a failure
would be btrfs_reserve_extent() failing to find a large enough
contiguous free extent for the compressed extent.

I was able to reproduce this by:

1. mount with compress-force=zstd:3
2. fallocating most of a filesystem to a big file
3. fragmenting the remaining free space
4. trying to copy in a file which zstd would generate large compressed
   extents for (vmlinux worked well for this)

Step 4. hits the memory leak and can be repeated ad nauseam to
eventually exhaust the system memory.

Fix this by detecting the case where we fallback to uncompressed
submission for a compressed async_extent and ensuring that we call
free_async_extent_pages().

Fixes: 131a821a243f ("btrfs: fallback if compressed IO fails for ENOSPC")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Co-developed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1116,6 +1116,7 @@ static void submit_one_async_extent(stru
 	struct extent_state *cached = NULL;
 	struct extent_map *em;
 	int ret = 0;
+	bool free_pages = false;
 	u64 start = async_extent->start;
 	u64 end = async_extent->start + async_extent->ram_size - 1;
 
@@ -1136,7 +1137,10 @@ static void submit_one_async_extent(stru
 	}
 
 	if (async_extent->compress_type == BTRFS_COMPRESS_NONE) {
+		ASSERT(!async_extent->folios);
+		ASSERT(async_extent->nr_folios == 0);
 		submit_uncompressed_range(inode, async_extent, locked_folio);
+		free_pages = true;
 		goto done;
 	}
 
@@ -1152,6 +1156,7 @@ static void submit_one_async_extent(stru
 		 * fall back to uncompressed.
 		 */
 		submit_uncompressed_range(inode, async_extent, locked_folio);
+		free_pages = true;
 		goto done;
 	}
 
@@ -1193,6 +1198,8 @@ static void submit_one_async_extent(stru
 done:
 	if (async_chunk->blkcg_css)
 		kthread_associate_blkcg(NULL);
+	if (free_pages)
+		free_async_extent_pages(async_extent);
 	kfree(async_extent);
 	return;
 


