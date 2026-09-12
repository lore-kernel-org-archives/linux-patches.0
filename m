Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EE744AB60;
	Sat, 12 Sep 2026 10:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210356; cv=none; b=HWvQ7J97/hfSpM68IiCTwsKR80uRZLOUijguYx9t3opcebbluvBT10cnEdNxc742L7W3lkZWKHKrJJhtcig248PAN1IWS5xh5xUhLzIh/aQcxATYn3idITKv3/D0Uh1aEVOsTTV4GcD4LS/Jpiah8RwfFsdZpCCf2U5PU1J0RUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210356; c=relaxed/simple;
	bh=IzDM7RrtIld/pj+TtJFoex+E1Stl33LPuJ18OIp2gfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChrUAJv+e2f6N9Sb8nRvfVUYPiGTIwPPNBc+ET5U/TfSDKOrBtPY2QWyxjK1n5ootoG4G4dKy1+800OMioCOdyZmfHZkjw/56yjm3F/jzDM8gVvH+RsBwqge/96oqH2RAO3m6IatpzPIVC35WdFc4jVe/8saZJ2s1ca0vNjfULA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxIDF7d4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxIDF7d4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031F31F000FF;
	Sat, 12 Sep 2026 10:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210355;
	bh=wYAQDJQEUoGK2ybnZJiiDKo0j9fVP7vCh1QezbCi0Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lxIDF7d4Ns1HlvpOZOGTPlil+YJQBQHyuWoRQIVltp7bRI5JZ60g1P49ih3XxhSa5
	 c/HGLAk6Icdz0EJtAV3Nja8wuS1iWxXs5EgRDXVCBm5TUKpbkwZe4dB/cnI2otDBct
	 eA8UOszHL39le7XOJ1ng5ynZmv3ElO+aYJtXsfWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1007/1518] btrfs: qgroup: fix a wrong length calculation in qgroup_free_reserved_data()
Date: Sat, 12 Sep 2026 08:52:56 +0200
Message-ID: <20260912065646.234693675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 80c74166beefe..f654639334fcd 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4344,12 +4344,13 @@ static int qgroup_free_reserved_data(struct btrfs_inode *inode,
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
@@ -4361,12 +4362,15 @@ static int qgroup_free_reserved_data(struct btrfs_inode *inode,
 
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



