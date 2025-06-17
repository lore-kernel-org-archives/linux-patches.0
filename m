Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7CF221F1F;
	Tue, 17 Jun 2025 15:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174517; cv=none; b=j6+TIkP70JhhQ2flyokqcDhfgf3CL0dhVALuV26Y2ZJTodfUKuhRenrbAUtWLwSyfEsCIMWbrWl3NuMQlgB18ICvN5HzhlkRMRHB1jTDtpaYkyOD4UMpMbi+s2RLZNthcXNOHMObuLDn7N0GNYyjomV5XKJOWP2Mc9bKmejwX9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174517; c=relaxed/simple;
	bh=vLEqN4+2oCpnoF9VSbiOOQK/ZErEAovFhTfvB420Ty0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5+MbfVYZDFgEYXNFgfSRBtKNRsnRNDSHxkOXqS1tbRjmiD1oFB5PGIyZe5+nmWC+e2zrx6l5IV5/ij9KJ6q+uF7+5zyxLyv+J9NiZFzzd3BNyXLdGoVOE4Y0JV2Nsr4kwP+uHBiOGGLwJ0cMm6nmzd28ELhh+ULZ2tsqUZ+eHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQOQo7/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQOQo7/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86CCC4CEE3;
	Tue, 17 Jun 2025 15:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174517;
	bh=vLEqN4+2oCpnoF9VSbiOOQK/ZErEAovFhTfvB420Ty0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQOQo7/qnu8GaCjkb/uk9/OapkTCVP44UrfZAVbvEvvazBMV1oOio5HhTjwcmONBK
	 JiRbV8o6c8Ujp4Up8itdTPCnZGanmo+xJuC8Z16pDz8bc878oAaeAZbE0SSVxbTFRz
	 z5U4AzJWBnB/7wsvya3gLFjaUZMVUh8xp9oYji14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/512] btrfs: fix invalid data space release when truncating block in NOCOW mode
Date: Tue, 17 Jun 2025 17:19:55 +0200
Message-ID: <20250617152420.738957220@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9ce1270addb04..1ab5b0c1b9b76 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4857,8 +4857,11 @@ int btrfs_truncate_block(struct btrfs_inode *inode, loff_t from, loff_t len,
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



