Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA87D101DE;
	Thu,  3 Jul 2025 14:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554138; cv=none; b=L0v8c5M4NTyh6O8gge8zXVTB5d6hITf8MmOG0GPorFPUd2qBg1+Ni8UsokwIhdyaC8wNs3x30vzH7918qL76YAqoU4dsWf7/76cQ4I4tFTheZxnsO5ClWQNaZlhKwi5azFNVRBH5DvMK81kI5aFrQePrF7gz0n/Wwqu+ose6pts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554138; c=relaxed/simple;
	bh=ct3KJ2rfBWewiA+CgBHtsBenWcaVWLpA1tiaRZU8MJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwohpMRXLV0h5z7DObrNh68EUlkSryM4k8FwVVvcT5jdlYre3P5j4fo78a8mV6oz0Pzal/jnmjqMHUp6FxjjkA5E/iWurnIX1qOzlMR660lNP19tJZZF2llqxGXAk+WK8Dp1iMkYAYg4YBQTIFp/JijTNbRzbOR8masypcxt6sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qoKgJIDH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qoKgJIDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A8BC4CEE3;
	Thu,  3 Jul 2025 14:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554137;
	bh=ct3KJ2rfBWewiA+CgBHtsBenWcaVWLpA1tiaRZU8MJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qoKgJIDHslj0QTedZhVq9YuYI5LbcBv4An917nPmrknI25ivj86WsJuH3BHu7XfaA
	 wi/ktKc8vzVlWYaZzTznFXawaRcbGbKLJQ2hF/aFtMFw6drk1Mh+eKHIrrgSgLu5JR
	 hnqmhplYYLA4D4w9WwVYWeMdWuXeTedNntBGuMfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/218] btrfs: fix qgroup reservation leak on failure to allocate ordered extent
Date: Thu,  3 Jul 2025 16:40:10 +0200
Message-ID: <20250703143958.421272574@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

[ Upstream commit 1f2889f5594a2bc4c6a52634c4a51b93e785def5 ]

If we fail to allocate an ordered extent for a COW write we end up leaking
a qgroup data reservation since we called btrfs_qgroup_release_data() but
we didn't call btrfs_qgroup_free_refroot() (which would happen when
running the respective data delayed ref created by ordered extent
completion or when finishing the ordered extent in case an error happened).

So make sure we call btrfs_qgroup_free_refroot() if we fail to allocate an
ordered extent for a COW write.

Fixes: 7dbeaad0af7d ("btrfs: change timing for qgroup reserved space for ordered extents to fix reserved space leak")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ordered-data.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 7baee52cac184..880f9553d79d3 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -153,9 +153,10 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 	struct btrfs_ordered_extent *entry;
 	int ret;
 	u64 qgroup_rsv = 0;
+	const bool is_nocow = (flags &
+	       ((1U << BTRFS_ORDERED_NOCOW) | (1U << BTRFS_ORDERED_PREALLOC)));
 
-	if (flags &
-	    ((1U << BTRFS_ORDERED_NOCOW) | (1U << BTRFS_ORDERED_PREALLOC))) {
+	if (is_nocow) {
 		/* For nocow write, we can release the qgroup rsv right now */
 		ret = btrfs_qgroup_free_data(inode, NULL, file_offset, num_bytes, &qgroup_rsv);
 		if (ret < 0)
@@ -170,8 +171,13 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 			return ERR_PTR(ret);
 	}
 	entry = kmem_cache_zalloc(btrfs_ordered_extent_cache, GFP_NOFS);
-	if (!entry)
+	if (!entry) {
+		if (!is_nocow)
+			btrfs_qgroup_free_refroot(inode->root->fs_info,
+						  btrfs_root_id(inode->root),
+						  qgroup_rsv, BTRFS_QGROUP_RSV_DATA);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	entry->file_offset = file_offset;
 	entry->num_bytes = num_bytes;
-- 
2.39.5



