Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAF61E8332;
	Tue, 17 Jun 2025 15:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175026; cv=none; b=f4cpwg9UYs8mI3ZrogLEs9m6pzvTSEfz7x6c4eyLtKOietufLFP5me0IJz2A6/s1GtIuXT8adUelHRhnieN7Jmey24Edqklx+wEACGwm46GxfcyHO8ZD2JoOvIG+2yKzyR4k4szFTfissKB3pr5+7yY/5ZKlqKKHsmIOQfuQZtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175026; c=relaxed/simple;
	bh=cxvJkPntm5Fj5Y3es8YnMKqbS7YsWGumvO2BiTNctvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZbO7kVNHDLeHnANuJQq9NqglvyjfIK7UnnyDmirn4o3Kt9feZ2xjLHcVROVxODk1Ui3RSL1d/dmAXbvnGEcmAy0Jr5yQ7g1Q7u1rUxf9yVLSrkpioGJ5pqz0+Z6RXyC+Y8+/kyWKrpEuMVXkQKSGMeUXuUsh08zpSIUuJxbY6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x0p373eC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x0p373eC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93294C4CEE3;
	Tue, 17 Jun 2025 15:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175026;
	bh=cxvJkPntm5Fj5Y3es8YnMKqbS7YsWGumvO2BiTNctvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x0p373eCp1SdSBBtY6Or+qWwaNseAQ4JgahBpLeHmzLxjSZAw9YaMwI59xqW1F59g
	 64HkZgqCAKgM3ajCLvSZ7HOvU4RgNqUsOZRPuHVfXZr0QKftCV4njVRWpLw41TFOQV
	 bmtHauYTWqrCGqHtMkgF+eNbVC0QFiyeofszmw9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 042/780] btrfs: fix invalid data space release when truncating block in NOCOW mode
Date: Tue, 17 Jun 2025 17:15:50 +0200
Message-ID: <20250617152453.210913288@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit d3914d6030aa6be2993dfc223d096ff93018c236 ]

If when truncating a block we fail to reserve data space and then we
proceed anyway because we can do a NOCOW write, if we later get an error
when trying to get the folio from the inode's mapping, we end up releasing
data space that we haven't reserved, screwing up the bytes_may_use counter
from the data space_info, eventually resulting in an underflow when all
other reservations done by other tasks are released, if any, or right away
if there are no other reservations at the moment.

This is because when we get an error when trying to grab the block's folio
we call btrfs_delalloc_release_space(), which releases metadata (which we
have reserved) and data (which we haven't reserved).

Fix this by calling btrfs_delalloc_release_space() only if we did reserve
data space, that is, if we aren't falling back to NOCOW, meaning the local
variable @only_release_metadata has a false value, otherwise release only
metadata by calling btrfs_delalloc_release_metadata().

Fixes: 6d4572a9d71d ("btrfs: allow btrfs_truncate_block() to fallback to nocow for data space reservation")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 90f5da3c520ac..8a3f44302788c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4849,8 +4849,11 @@ int btrfs_truncate_block(struct btrfs_inode *inode, loff_t from, loff_t len,
 	folio = __filemap_get_folio(mapping, index,
 				    FGP_LOCK | FGP_ACCESSED | FGP_CREAT, mask);
 	if (IS_ERR(folio)) {
-		btrfs_delalloc_release_space(inode, data_reserved, block_start,
-					     blocksize, true);
+		if (only_release_metadata)
+			btrfs_delalloc_release_metadata(inode, blocksize, true);
+		else
+			btrfs_delalloc_release_space(inode, data_reserved,
+						     block_start, blocksize, true);
 		btrfs_delalloc_release_extents(inode, blocksize);
 		ret = -ENOMEM;
 		goto out;
-- 
2.39.5



