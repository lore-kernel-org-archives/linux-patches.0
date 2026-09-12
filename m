Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF19311597;
	Sat, 12 Sep 2026 08:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202673; cv=none; b=gbbRYWoJDGqXCjFGXFy4v40x46yOPfFkvShAWDNd5TzS9uMKFg10FzCDD/e/txbf4wM0n1dlflvLQN00/jFDW7XcVLpTMarwZ/AzdENv2lSxqgOKiIlc0dSgXVwt1UleZLuRH5mya0BTSMDIWqCxEPapC6Jjl5f36egCz93icDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202673; c=relaxed/simple;
	bh=qCDGqpCmANOXvcSp/uKFsQ84Ky+b6Dfvl/3XS566Qqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRzUFSKsQDuXYnryGKbZkZjZbr+HDleIU6/9XubgodjX6otmHBbsmPBQE0DyqDcCB7GmSoJ3eFyXHtt3rONcUv1nyDzcaIdD6L9PPBu1S2HYjv2nOQ3aBABlFobDsH0pgfnT5G5pAKtyYIfQy0wIKDaT+d2t2ssBq2rfwTHK7Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5F5WUgU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5F5WUgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C811F000FF;
	Sat, 12 Sep 2026 08:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202671;
	bh=wdlZhAlu5UjYHit1pOI4TfondEvqGnxv5QpnZxh/AhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h5F5WUgU61xyhjjvLyBkNKMpOaz2oZ5fUXftG+T97E7kHxT76AEm67hm4ucUijKhS
	 dUIl6imqtbDgO6LhjzZfJMXjpaaFXk659Ahrfmulc5KuasAghjYQcwqjKIZB/ZU/rr
	 NTyn/4K7mw2vLwbbyklVm0eorWI04MZEi1agjZAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1234/1815] btrfs: qgroup: fix a wrong length calculation in qgroup_free_reserved_data()
Date: Sat, 12 Sep 2026 08:49:44 +0200
Message-ID: <20260912065717.980904762@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 9102b179512e11644fb0489ae62010a09afa199c ]

In that function, we round down the start position and round up the
ending position.

But during the calculation of @len, we use "round_up(start + len,
sectorsize)", which is the rounded up end position, not the rounded up
length.

Which results a much larger length, and later we are still using
"start + len", which is completely incorrect.

Fix it by declaring a local @aligned_start and @aligned_len and use them
instead.

Fixes: bc42bda22345 ("btrfs: qgroup: Fix qgroup reserved space underflow by only freeing reserved ranges")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 502fb4a55cb22..f64a4537be315 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4339,12 +4339,13 @@ static int qgroup_free_reserved_data(struct btrfs_inode *inode,
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 	struct extent_changeset changeset;
+	const u32 sectorsize = root->fs_info->sectorsize;
+	const u64 aligned_start = round_down(start, sectorsize);
+	const u64 aligned_len = round_up(start + len, sectorsize) - aligned_start;
 	u64 freed = 0;
 	int ret;
 
 	extent_changeset_init_bytes_only(&changeset);
-	len = round_up(start + len, root->fs_info->sectorsize);
-	start = round_down(start, root->fs_info->sectorsize);
 
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(&reserved->range_changed, &uiter))) {
@@ -4356,12 +4357,15 @@ static int qgroup_free_reserved_data(struct btrfs_inode *inode,
 
 		extent_changeset_release(&changeset);
 
-		/* Only free range in range [start, start + len) */
-		if (range_start >= start + len ||
-		    range_start + range_len <= start)
+		/*
+		 * Only free the range within
+		 * [aligned_start, aligned_start + aligned_len).
+		 */
+		if (range_start >= aligned_start + aligned_len ||
+		    range_start + range_len <= aligned_start)
 			continue;
-		free_start = max(range_start, start);
-		free_len = min(start + len, range_start + range_len) -
+		free_start = max(range_start, aligned_start);
+		free_len = min(aligned_start + aligned_len, range_start + range_len) -
 			   free_start;
 		/*
 		 * TODO: To also modify reserved->ranges_reserved to reflect
-- 
2.53.0



