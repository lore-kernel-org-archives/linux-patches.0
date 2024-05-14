Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680601CFB2;
	Tue, 14 May 2024 11:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687801; cv=none; b=PP9hcCCNCgDvZpQYPRj3iYYvrRtE2FETJ2kCtYCikiy5e1lGZUb8pryTQeuY59a0HCxPkKAKef/HlZW/A3h4izqje8rLcbCl7VO+PRqtpx9OlNJM0tRzPFwgFn/UmkRv/zkOBqTNB+TeNVs5O9aaMIu+4TJoc8VkBjTw14aR3/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687801; c=relaxed/simple;
	bh=Qi801E/MSBTtGZs08fkb7a7IVwnrXN2czcDAQMRMxfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4pJ/hMNiu3qIIJxutls6oQsdLg9JYLTkDuE9OW73wlD6wLvf0qTEmRYlVvaNwLL7Y7Mx9dIWtSuhjoH4hArgSVfzFUflNU5xgkdTh4YiwMMu8DbcQ6ecHam/JI1HBBLI6/CpuETIsq32AQFoABtlfgfVCMnt0X2AFQ5XLIgu0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3Jy2iuH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3Jy2iuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50C0C32781;
	Tue, 14 May 2024 11:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687801;
	bh=Qi801E/MSBTtGZs08fkb7a7IVwnrXN2czcDAQMRMxfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3Jy2iuHzKq7XeucMGqAiQ8zU+ADIpoCHrqs+cvI8raOF3PVhevKexIU8ORka9acp
	 inzHqqZiWo3erQ9c+T4mhYTNQxZtvofs3SmqarQCcBFaudSwu9i+uJsTI3ve+8+ARf
	 RViaRhn9AyvMgNiPHlYoutrC9U8Vw/acStF5Up3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/168] btrfs: make btrfs_clear_delalloc_extent() free delalloc reserve
Date: Tue, 14 May 2024 12:19:36 +0200
Message-ID: <20240514101009.639498840@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c7d8a18daaf50..07c6ab4ba0d43 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2261,7 +2261,7 @@ void btrfs_clear_delalloc_extent(struct inode *vfs_inode,
 		 */
 		if (*bits & EXTENT_CLEAR_META_RESV &&
 		    root != fs_info->tree_root)
-			btrfs_delalloc_release_metadata(inode, len, false);
+			btrfs_delalloc_release_metadata(inode, len, true);
 
 		/* For sanity tests. */
 		if (btrfs_is_testing(fs_info))
-- 
2.43.0



