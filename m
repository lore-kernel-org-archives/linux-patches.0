Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11F32D0C94;
	Sat, 12 Sep 2026 10:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210346; cv=none; b=QypmyW7hU3FtMQDU0IXhdWlTO1IKDQjT0XelTVZ1aZNcf+dTNkc5F4oZDUyfBhV3h2iOyDS23T+3ZGl+X9jkLK229nRa9cLex+XkRguKelZ2tovCl09LlEN/Vwt0bRYsBSsln/AOV4/LgKRBRLzc6KgvZhUBKCHpQ1yQGS2OTqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210346; c=relaxed/simple;
	bh=TDk2a5P+Lz/i/mdfNhejvd7N3T6NkLJ9U3pFcr98ABM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lwspz5rlR4OspcKAk2yml33iT0wgNEs4i0eENg2mlWkOqL1UCF39KGjvGsJhymNhg06l/y/fRFPxamvYZkh2amYZZRD/ZCzLupAlq5rhBaKo1L6UVDGkkKepBqpX6+Sy8JWrGbrj8jTNA8bu7piTayHtCL4GEJuWUQG0nk/IWSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRd/KuE/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRd/KuE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483901F000FF;
	Sat, 12 Sep 2026 10:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210344;
	bh=G8JGW+MBx6WKlFbLIxoeKEALi6WEbysh71nql0/wMN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bRd/KuE/lnFmpl20UxOiDctmdRad/GZxtb0RlVeTx5XV2TFoVYiSCtEQ6FPjRcUQt
	 X4+HQ09K/ya7dC9DuucA7cMl6znuV9kRDPJJ7C6qttCOr8oBI8P4G6EDdGKd8KqG+G
	 F5dVD0Dilv/4c/GiChylXNiSwAe16xQSDEZRVNmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1005/1518] btrfs: use aligned range for locking in extent_fiemap()
Date: Sat, 12 Sep 2026 08:52:54 +0200
Message-ID: <20260912065646.188018306@linuxfoundation.org>
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

[ Upstream commit 681e073614515b892cacef0eeec0c761a2c2ab87 ]

The @end parameter for all extent io tree helpers is inclusive, but
the call site in extent_fiemap() is passing an exclusive end into
btrfs_lock_extent(), which will step into the next block unexpectedly.

Pass the inclusive end into btrfs_lock_extent() and
btrfs_unlock_extent().

Fixes: ac3c0d36a2a2 ("btrfs: make fiemap more efficient and accurate reporting extent sharedness")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/fiemap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
index f2eaaef8422bf..30a0f66c9c9ef 100644
--- a/fs/btrfs/fiemap.c
+++ b/fs/btrfs/fiemap.c
@@ -661,7 +661,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
 	range_end = round_up(start + len, sectorsize);
 	prev_extent_end = range_start;
 
-	btrfs_lock_extent(&inode->io_tree, range_start, range_end, &cached_state);
+	btrfs_lock_extent(&inode->io_tree, range_start, range_end - 1, &cached_state);
 
 	ret = fiemap_find_last_extent_offset(inode, path, &last_extent_end);
 	if (ret < 0)
@@ -841,7 +841,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
 	}
 
 out_unlock:
-	btrfs_unlock_extent(&inode->io_tree, range_start, range_end, &cached_state);
+	btrfs_unlock_extent(&inode->io_tree, range_start, range_end - 1, &cached_state);
 
 	if (ret == BTRFS_FIEMAP_FLUSH_CACHE) {
 		btrfs_release_path(path);
-- 
2.53.0



