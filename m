Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7740A33E355;
	Fri,  7 Aug 2026 15:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116735; cv=none; b=QyW8N3k7gvYvDWd+Sqr3z1v4oRCYYsf73izwkaTooDdouJWgMH8KA3Llg87baCFzrrsgU/lp+SX0B5KCz0fXraduGjn6TxKcbYCbaPwgnAtbRGSAAEVKN2MHZkEoY510si1+w3oNMnV3YpH7muXW6M1nVyMVngvwped15DINXno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116735; c=relaxed/simple;
	bh=HhdF6N9meUcaWI5fNFuD8htJK3LRD4Wzjru1SSn11Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZ+IN0yZn5feaZGBeZJLsf0YgdmVz+PHV4wEKs0U0Y+xdLVrSf6tnUiLMkrBFd7p0sAXwVHMaeku9qC3FAIFdUsqKFqnOnYk3Mt9AorP+tS9znor8FBjJ4CpbjYgUvGhKVxHyXOExw3FIbMyjSznmFlrO4aTF6kMrji9MMflFOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBhKfrs4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBhKfrs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BCF1F000E9;
	Fri,  7 Aug 2026 15:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116734;
	bh=tkNWWl3d60hh5S4/PsaVXfg/qrreEiUyiK0kTe49Xb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBhKfrs4nFmwj2/TIo4GGivzzGtgL8TiC7Nd7KFX4b53tI+/jRq4Ai27vAr0WIzJI
	 olbmk+150BkgUpAUgQBxOZn+YApTL1lN6CXsNJDsMFB3nBJRWNLbWFRt/4H/hjj1Ni
	 0SazXWg/5kJr7kBSQbqz68ftmxqG40kep9VydXqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 027/438] btrfs: zoned: reset meta_write_pointer on zone reset
Date: Fri,  7 Aug 2026 16:33:43 +0200
Message-ID: <20260807143428.587553017@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 5fabb1cf25d723274009d7b759545fd59f230c9d ]

btrfs_reset_unused_block_groups() resets a block group's zone and sets
alloc_offset back to 0 so the space can be reused, but it leaves
meta_write_pointer pointing at the previous end of the zone.

Once the block group is reactivated and reused for metadata, newly
allocated tree blocks live before that stale write pointer.
btrfs_check_meta_write_pointer() then sees them behind the write pointer,
so they can never be written out in sequential order: the dirty extent
buffers are stranded and pin their btree_inode folios until unmount.

Reset meta_write_pointer back to the start of the block group for
metadata and system block groups.

Fixes: 453a73c3069a ("btrfs: zoned: reclaim unused zone by zone resetting")
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index a85fc150c97b5..6963e9068a565 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3196,6 +3196,17 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		reclaimed = bg->alloc_offset;
 		bg->zone_unusable = bg->length - bg->zone_capacity;
 		bg->alloc_offset = 0;
+		/*
+		 * The zone was just reset to empty, so alloc_offset went back to
+		 * the start of the zone. For metadata/system block groups the
+		 * write pointer must follow it back to the start of the zone;
+		 * otherwise it stays stale at the previous (finished) zone end,
+		 * and metadata written into the reused zone would sit behind the
+		 * write pointer, could never be written out in sequential order,
+		 * and would be stranded (pinning its folio) until unmount.
+		 */
+		if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
+			bg->meta_write_pointer = bg->start;
 		/*
 		 * This holds because we currently reset fully used then freed
 		 * block group.
-- 
2.53.0



