Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D45B43F8CB;
	Thu, 30 Jul 2026 14:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421207; cv=none; b=WppKoUUVOQdkfV2B5hcq+GpE1krPQGNS1RgoRcjBUyZD/9Oxfcunw/tbAEs35iR16xZrXP7sHps1lvhtT0EnstT3gpRhhSnxHR+RJDpzHHJ2Ug476PVLqodprboyDVHyRFIqxJQsaH0ovvnIYa2D/0LktEmAbZ5gIAon4eQQfho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421207; c=relaxed/simple;
	bh=GOtqwkWiWFYlZ1XlePbd6+SsJ50dEqXvX0kV3AH/crs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oG6P0V6JgiwRJmfYU/2yYq0WBp5G3mKRNPiIkXD6GwuT1krsVeivfIfwM2hq9q7sNIYYuYbNOwvmD2nXJmMdGS7sflGqVhdKC3aEW2/gHrVGynOFdjAhnmeCj5YrJL481g8jBSXalvaG+X8cJv+i8px0hON/1Y2vBF5u21SWEKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHy4HHvg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHy4HHvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5C01F000E9;
	Thu, 30 Jul 2026 14:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421205;
	bh=NsNiIyJesWma9/HQLLl9rKjKFsSjkwHvFGyOAVW5xtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HHy4HHvgFpnv7STjZBrw3fEXOCFcC+sGx/dhY5GqrlYXMiTBX/bS6wnsnbPqByXDH
	 Okznl33qqSdieEaxF2aG61JUBIBVbcgRtgQjidqFT2SITJkdmeykNmUyckYkLsL/lm
	 mHmdIk4XU6qJ34d9IrkEJCzISLP9m+4AhTOCS2uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 026/744] btrfs: fallback to transaction csum tree on a commit root csum miss
Date: Thu, 30 Jul 2026 16:04:59 +0200
Message-ID: <20260730141444.839861887@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

[ Upstream commit 3dcd50730814e5220072d2b26d0587af6bfb6dbe ]

We have been running with commit root csums enabled for some time and
have noticed a slight uptick in zero csum errors. Investigating those
revealed that they were same transaction reads of extents that were just
relocated, but the extent map generation was long ago.

It turns out that relocation intentionally does not update the extent
generation (replace_file_extents()), but must write a new csum since the
data has moved, so we must account for this with commit root csum reading.

Luckily this is a short lived condition: after the relocation transaction
the commit root will once again have the csum. So we can add a generic
fallback to the lookup to try again with the transaction csum root.

Fixes: f07b855c56b1 ("btrfs: try to search for data csums in commit root")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file-item.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index d72249390030f4..e50b10b30c717b 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -356,6 +356,7 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
 	const unsigned int nblocks = orig_len >> fs_info->sectorsize_bits;
 	int ret = 0;
 	u32 bio_offset = 0;
+	bool using_commit_root = false;
 
 	if ((inode->flags & BTRFS_INODE_NODATASUM) ||
 	    test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state))
@@ -429,6 +430,7 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
 	 * from across transactions.
 	 */
 	if (bbio->csum_search_commit_root) {
+		using_commit_root = true;
 		path->search_commit_root = true;
 		path->skip_locking = true;
 		down_read(&fs_info->commit_root_sem);
@@ -461,6 +463,28 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
 		 * assume this is the case.
 		 */
 		if (count == 0) {
+			/*
+			 * If an extent is relocated in the current transaction
+			 * then relocation writes a new csum without updating
+			 * the extent map generation. Until the next commit, we
+			 * will see a hole in that case, so we need to fallback
+			 * to searching the transaction csum root.
+			 *
+			 * Note that a commit root lookup of a referenced extent can
+			 * only miss, not return a stale csum. A freed extent's csum
+			 * is deleted in the same transaction and its bytenr is not
+			 * reusable until that transaction has committed and the
+			 * extent is unpinned.
+			 */
+			if (using_commit_root) {
+				up_read(&fs_info->commit_root_sem);
+				using_commit_root = false;
+				path->search_commit_root = false;
+				path->skip_locking = false;
+				btrfs_release_path(path);
+				continue;
+			}
+
 			memset(csum_dst, 0, csum_size);
 			count = 1;
 
@@ -479,7 +503,7 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
 		bio_offset += count * sectorsize;
 	}
 
-	if (bbio->csum_search_commit_root)
+	if (using_commit_root)
 		up_read(&fs_info->commit_root_sem);
 	return ret;
 }
-- 
2.53.0



