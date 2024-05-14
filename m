Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F5C139CE4;
	Tue, 14 May 2024 11:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687042; cv=none; b=r/8rRAcf1os7C69gLKs+2Rq606W24GjtSM+5B1hx2yZYFTUTIQk8lGX3DHtYzTW4NlNATYa3RQfsndod6lzhnxcqL9vD4CGRT8iRfA8xoHAXTq6rINrE8Bl6f0S65FoSvL3KqVIWC5zssTUZVW0ol80O0xIJZccKcx6lu5OUcVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687042; c=relaxed/simple;
	bh=jo/g9zlHrEEQGo0eUSmON5FjBZohppBmlpYzn9kmrlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMRGl79u7wxGyekZ0sLky1GGUQyD4MJUbSVsgrC02svi1NvNO74cmRgtMCwksrSJ84hh7XAMg70Vi5kGtSD0Cxczo6v9NA0sN266AZjLJ4zX7lTqmpZpTw2OYKi7dzgA1C4rmx7CGLohXtyDqqScKV9VWKSvonTthQ5DN4XppW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3wuKGrw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3wuKGrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAF6C32781;
	Tue, 14 May 2024 11:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687041;
	bh=jo/g9zlHrEEQGo0eUSmON5FjBZohppBmlpYzn9kmrlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3wuKGrw2I/4cymDgXAtj48Ynu4mXJ7x1Cd4jEFD7Nsfv9WfhSHYyy5eHJLTOoZ9y
	 ekMxT9QvCGcabAQeAb9EHGtMwZpEhYYmTfd553YYukna/NA0gPKu4g9fKFVLDrnPBg
	 wDI+rE3RZe2IlMstKkEzmsMI9/9qLD6iwtzuaHho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 45/84] btrfs: make btrfs_clear_delalloc_extent() free delalloc reserve
Date: Tue, 14 May 2024 12:19:56 +0200
Message-ID: <20240514100953.384353579@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

[ Upstream commit 3c6f0c5ecc8910d4ffb0dfe85609ebc0c91c8f34 ]

Currently, this call site in btrfs_clear_delalloc_extent() only converts
the reservation. We are marking it not delalloc, so I don't think it
makes sense to keep the rsv around.  This is a path where we are not
sure to join a transaction, so it leads to incorrect free-ing during
umount.

Helps with the pass rate of generic/269 and generic/475.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c89e85a7da7d4..2c86be3fc25cd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2051,7 +2051,7 @@ void btrfs_clear_delalloc_extent(struct inode *vfs_inode,
 		 */
 		if (*bits & EXTENT_CLEAR_META_RESV &&
 		    root != fs_info->tree_root)
-			btrfs_delalloc_release_metadata(inode, len, false);
+			btrfs_delalloc_release_metadata(inode, len, true);
 
 		/* For sanity tests. */
 		if (btrfs_is_testing(fs_info))
-- 
2.43.0



