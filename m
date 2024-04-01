Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3501CA8F;
	Mon,  1 Apr 2024 16:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987391; cv=none; b=bckNtGVN8n0Aaj5rRGT+a06JScpygz5F4/SyvamUD/iy8dwLmGwJB+gaW0wUS+7VFOzrvF0xjvSLxRayb11EE1VnpDYWBTtYUykMBhwqKMqz9adKwoWFU+TYNh3POnoLioyjvQ9oPdIXI10YI+k3xWR5b7QnDNigR5axcdeG+1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987391; c=relaxed/simple;
	bh=HtV05bO/H/qfHo9/kMK2DvAQneQKUcIVrlN76IrJAws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7qtTaxGq4YD8yUHYgqWNFJRw8mSQlTiyZ0xXpskikDPjHiD0L+t0/RtT/m0L7mv7YaOT5dK+ZK5zH22fufW1wNJMMqxUCKRBqg56egdBh0NjVUb7B8UBw/qHgTaDO780rHzAHzMN3qZ33t/XjxtvEm9423KPikOxe+VdgAmbn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBb3j57y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBb3j57y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D61EC433C7;
	Mon,  1 Apr 2024 16:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987391;
	bh=HtV05bO/H/qfHo9/kMK2DvAQneQKUcIVrlN76IrJAws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBb3j57yOSw2vJZDzEBkGgN69hDttDVykY0UXxp5gBcTjZHRPHSPzAZXPye1NuLfb
	 h0SD/kjo2qTOddaKETIYOduq73H5Oa9xIVlt1j6O5Ji+RPk+Bz93YqvIH1BcE27OpV
	 QAsMO5X5cuhRY0SpMpZel8V4sJtNzvpHUUz0Lykg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Anand Jain <anand.jain@oracle.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 274/399] btrfs: fix warning messages not printing interval at unpin_extent_range()
Date: Mon,  1 Apr 2024 17:44:00 +0200
Message-ID: <20240401152557.361359425@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 4dc1d69c2b101eee0bf071187794ffed2f9c2596 ]

At unpin_extent_range() we print warning messages that are supposed to
print an interval in the form "[X, Y)", with the first element being an
inclusive start offset and the second element being the exclusive end
offset of a range. However we end up printing the range's length instead
of the range's exclusive end offset, so fix that to avoid having confusing
and non-sense messages in case we hit one of these unexpected scenarios.

Fixes: 00deaf04df35 ("btrfs: log messages at unpin_extent_range() during unexpected cases")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_map.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index f170e7122e747..c02039db5d247 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -311,7 +311,7 @@ int unpin_extent_cache(struct btrfs_inode *inode, u64 start, u64 len, u64 gen)
 		btrfs_warn(fs_info,
 "no extent map found for inode %llu (root %lld) when unpinning extent range [%llu, %llu), generation %llu",
 			   btrfs_ino(inode), btrfs_root_id(inode->root),
-			   start, len, gen);
+			   start, start + len, gen);
 		ret = -ENOENT;
 		goto out;
 	}
@@ -320,7 +320,7 @@ int unpin_extent_cache(struct btrfs_inode *inode, u64 start, u64 len, u64 gen)
 		btrfs_warn(fs_info,
 "found extent map for inode %llu (root %lld) with unexpected start offset %llu when unpinning extent range [%llu, %llu), generation %llu",
 			   btrfs_ino(inode), btrfs_root_id(inode->root),
-			   em->start, start, len, gen);
+			   em->start, start, start + len, gen);
 		ret = -EUCLEAN;
 		goto out;
 	}
-- 
2.43.0



