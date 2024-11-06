Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BE21E009E;
	Wed,  6 Nov 2024 12:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896507; cv=none; b=bHwYJNqF7oRPrKO2QyKi7DkzulUsNPCJ0LQx17+5QciwO4v+VaE3G1ZsahOZHrXuzvlJSbWTACua8UoOmtWkdQ6ar9atX/5Fja519sWvZFqx54Th4iNNzabPat5dNke+bXZ9jRXs7RDtviyTiUZwjBoPliso48lvM1pEWLagoJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896507; c=relaxed/simple;
	bh=tHWb+TtrBtMLtlqIKCAq4XTL2LQjP2gd+PV8jur2Qrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouGc1kIpjbRhmIQZkYhOmCdd6MumT7q6wa6azTHFTaeSV4xSKeePNiJuxE29sujrYTePa0Zlbu00He/9vEM4BqZYNrQTdMo2pClfwqLdZapuMt7jwdjGdlT5vZrk24IEBgdoyhDMO3jXjr41dOu7MsGV30poPNyDbfhI9EWt198=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLMGvx66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLMGvx66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4786C4CECD;
	Wed,  6 Nov 2024 12:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896507;
	bh=tHWb+TtrBtMLtlqIKCAq4XTL2LQjP2gd+PV8jur2Qrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLMGvx661baHdkHNpCPGutm1OBtPG/dmjqb4H1PpvrvtwjrrL4Ur9NwM82lh+otRN
	 7xB6FBRvNYRDVO6VL/BzFgKC9+aLHqLoym5Tfg1V0zFks15bb7pEaOXcZyqO33Zk1l
	 vnlu5zUSUC+cTmtthIJQqG+vuFPV+ut43Fp3a3Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 198/245] btrfs: fix extent map merging not happening for adjacent extents
Date: Wed,  6 Nov 2024 13:04:11 +0100
Message-ID: <20241106120324.117704832@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a0f0625390858321525c2a8d04e174a546bd19b3 ]

If we have 3 or more adjacent extents in a file, that is, consecutive file
extent items pointing to adjacent extents, within a contiguous file range
and compatible flags, we end up not merging all the extents into a single
extent map.

For example:

  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt/sdc

  $ xfs_io -f -d -c "pwrite -b 64K 0 64K" \
                 -c "pwrite -b 64K 64K 64K" \
                 -c "pwrite -b 64K 128K 64K" \
                 -c "pwrite -b 64K 192K 64K" \
                 /mnt/sdc/foo

After all the ordered extents complete we unpin the extent maps and try
to merge them, but instead of getting a single extent map we get two
because:

1) When the first ordered extent completes (file range [0, 64K)) we
   unpin its extent map and attempt to merge it with the extent map for
   the range [64K, 128K), but we can't because that extent map is still
   pinned;

2) When the second ordered extent completes (file range [64K, 128K)), we
   unpin its extent map and merge it with the previous extent map, for
   file range [0, 64K), but we can't merge with the next extent map, for
   the file range [128K, 192K), because this one is still pinned.

   The merged extent map for the file range [0, 128K) gets the flag
   EXTENT_MAP_MERGED set;

3) When the third ordered extent completes (file range [128K, 192K)), we
   unpin its extent map and attempt to merge it with the previous extent
   map, for file range [0, 128K), but we can't because that extent map
   has the flag EXTENT_MAP_MERGED set (mergeable_maps() returns false
   due to different flags) while the extent map for the range [128K, 192K)
   doesn't have that flag set.

   We also can't merge it with the next extent map, for file range
   [192K, 256K), because that one is still pinned.

   At this moment we have 3 extent maps:

   One for file range [0, 128K), with the flag EXTENT_MAP_MERGED set.
   One for file range [128K, 192K).
   One for file range [192K, 256K) which is still pinned;

4) When the fourth and final extent completes (file range [192K, 256K)),
   we unpin its extent map and attempt to merge it with the previous
   extent map, for file range [128K, 192K), which succeeds since none
   of these extent maps have the EXTENT_MAP_MERGED flag set.

   So we end up with 2 extent maps:

   One for file range [0, 128K), with the flag EXTENT_MAP_MERGED set.
   One for file range [128K, 256K), with the flag EXTENT_MAP_MERGED set.

   Since after merging extent maps we don't attempt to merge again, that
   is, merge the resulting extent map with the one that is now preceding
   it (and the one following it), we end up with those two extent maps,
   when we could have had a single extent map to represent the whole file.

Fix this by making mergeable_maps() ignore the EXTENT_MAP_MERGED flag.
While this doesn't present any functional issue, it prevents the merging
of extent maps which allows to save memory, and can make defrag not
merging extents too (that will be addressed in the next patch).

Fixes: 199257a78bb0 ("btrfs: defrag: don't use merged extent map for their generation check")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_map.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 72ae8f64482c6..b56ec83bf9528 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -227,7 +227,12 @@ static bool mergeable_maps(const struct extent_map *prev, const struct extent_ma
 	if (extent_map_end(prev) != next->start)
 		return false;
 
-	if (prev->flags != next->flags)
+	/*
+	 * The merged flag is not an on-disk flag, it just indicates we had the
+	 * extent maps of 2 (or more) adjacent extents merged, so factor it out.
+	 */
+	if ((prev->flags & ~EXTENT_FLAG_MERGED) !=
+	    (next->flags & ~EXTENT_FLAG_MERGED))
 		return false;
 
 	if (next->disk_bytenr < EXTENT_MAP_LAST_BYTE - 1)
-- 
2.43.0



