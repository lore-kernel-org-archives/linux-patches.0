Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3B122F772;
	Mon,  2 Jun 2025 14:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873335; cv=none; b=osVEdz9I47hTMTbwLiKu51GBmBgDzxIEoII302DZ+RwoOVbqWhYjE6lLVib6caYxeV2E45P90WYyxym6GKy9fbxkO95s+3b2xDNq7h6mThNoApYPbVvZj+MpQe27f7J+hWs+00FZQIUwhvgKzYHm4/xW7ZoSrttPhZG/zKANMYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873335; c=relaxed/simple;
	bh=uTZ674H3i6tklBzL3SRYeXOe5w1UWSzwDW9vtlk10C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HibqSs/skSaum5BF7z6Cji9ChYBR4lKJb7izBF+/R2wvqWwXHnYM6Ffrv+XwhXar3i6qUGpGwQwBXGhUcGBIyfyQe12SzOBZ/XsEtMBOqocqrv8/eONj0dMjrFl+295/SoTNeFx+e0fljy9xesUWLAK1jkPPMl+74nqTVagKsHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ydF9y/vf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ydF9y/vf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C18CC4CEEB;
	Mon,  2 Jun 2025 14:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873335;
	bh=uTZ674H3i6tklBzL3SRYeXOe5w1UWSzwDW9vtlk10C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ydF9y/vflVI+Xh/GAD7WaiHB1QixsNDp2chjU5vMnfMsvQya0xAhEgk7Iiphyazy9
	 ekpXxmJ3/9w+Te8A+rrOpHBlIJzI24J+93bH+iXKk/a38g9oiYYQWt6xCp2XoojmIT
	 WKHdjPrKrKtMoyfLwyuw4DOoewp2rCpyB1Pv7sJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/444] btrfs: get zone unusable bytes while holding lock at btrfs_reclaim_bgs_work()
Date: Mon,  2 Jun 2025 15:42:23 +0200
Message-ID: <20250602134344.112062932@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 1283b8c125a83bf7a7dbe90c33d3472b6d7bf612 ]

At btrfs_reclaim_bgs_work(), we are grabbing a block group's zone unusable
bytes while not under the protection of the block group's spinlock, so
this can trigger race reports from KCSAN (or similar tools) since that
field is typically updated while holding the lock, such as at
__btrfs_add_free_space_zoned() for example.

Fix this by grabbing the zone unusable bytes while we are still in the
critical section holding the block group's spinlock, which is right above
where we are currently grabbing it.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 434cf3d5f4cf1..226e6434a58a9 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1885,6 +1885,17 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 			up_write(&space_info->groups_sem);
 			goto next;
 		}
+
+		/*
+		 * Cache the zone_unusable value before turning the block group
+		 * to read only. As soon as the block group is read only it's
+		 * zone_unusable value gets moved to the block group's read-only
+		 * bytes and isn't available for calculations anymore. We also
+		 * cache it before unlocking the block group, to prevent races
+		 * (reports from KCSAN and such tools) with tasks updating it.
+		 */
+		zone_unusable = bg->zone_unusable;
+
 		spin_unlock(&bg->lock);
 
 		/*
@@ -1900,13 +1911,6 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 			goto next;
 		}
 
-		/*
-		 * Cache the zone_unusable value before turning the block group
-		 * to read only. As soon as the blog group is read only it's
-		 * zone_unusable value gets moved to the block group's read-only
-		 * bytes and isn't available for calculations anymore.
-		 */
-		zone_unusable = bg->zone_unusable;
 		ret = inc_block_group_ro(bg, 0);
 		up_write(&space_info->groups_sem);
 		if (ret < 0)
-- 
2.39.5



