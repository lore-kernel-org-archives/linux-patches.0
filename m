Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4CA42EEC4;
	Wed,  4 Feb 2026 15:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217447; cv=none; b=L2VdJG5GX6rJsWHafGWcSrVjPW+Fk74J31lMWncHlL+Wf6g708x2LANpl3KgrWXndihNOIaP3vgNNcCBEt8JITZi39t8TiVOREmLHsW0sb050POVJf1kmtyW2wdlxHhH+1i7j/VboY26u57WmwSVA1wybWQ/Tvb4IiiuATNXMfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217447; c=relaxed/simple;
	bh=1CZSXZSxr2Tyz2ZbBtNNqOpecrY5iv8VG565DApOxrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeZm/LaMoAWuqr+y7dS6zku0EWVt5hOIKCDJEEh4t7UvKvUfg+GM1wGQwFXfR6lnTF3dh44rzNvSsFyM1Y5f2HojdWL2cqTRDJ1+hSsMxIKFEZzwh1fKlLTMbtBarzKtD1uM9HxC7lgbYm5qMk9xKFZvw4GU99Dp73DywsJAyHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uD6av4Fv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uD6av4Fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A31C116C6;
	Wed,  4 Feb 2026 15:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217446;
	bh=1CZSXZSxr2Tyz2ZbBtNNqOpecrY5iv8VG565DApOxrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uD6av4FvgUmpUw+EMyIoqyqWyTLXTNy3aJMvkOyvXsqA1W+kkeR5rAB/gO9+wF3Mt
	 Zg56uR60RX+GuWI4xjHpqiqytKZIN6LFgLMMPpYuxUSk5HyY5Ge/9PaCXmmyG/AWB0
	 oq2VSqFnR35PZgftiTCeNnuXfIQB6t68bJDUr/+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/280] btrfs: send: check for inline extents in range_is_hole_in_parent()
Date: Wed,  4 Feb 2026 15:36:23 +0100
Message-ID: <20260204143909.963341803@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 08b096c1372cd69627f4f559fb47c9fb67a52b39 ]

Before accessing the disk_bytenr field of a file extent item we need
to check if we are dealing with an inline extent.
This is because for inline extents their data starts at the offset of
the disk_bytenr field. So accessing the disk_bytenr
means we are accessing inline data or in case the inline data is less
than 8 bytes we can actually cause an invalid
memory access if this inline extent item is the first item in the leaf
or access metadata from other items.

Fixes: 82bfb2e7b645 ("Btrfs: incremental send, fix unnecessary hole writes for sparse files")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index f5a9f6689c460..486d4fcc597b2 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6289,6 +6289,8 @@ static int range_is_hole_in_parent(struct send_ctx *sctx,
 		extent_end = btrfs_file_extent_end(path);
 		if (extent_end <= start)
 			goto next;
+		if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE)
+			return 0;
 		if (btrfs_file_extent_disk_bytenr(leaf, fi) == 0) {
 			search_start = extent_end;
 			goto next;
-- 
2.51.0



