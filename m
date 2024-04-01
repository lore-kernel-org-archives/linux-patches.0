Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346DE47A5D;
	Mon,  1 Apr 2024 17:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991361; cv=none; b=tP5RZDW++E6kCJYCLhDZVcYtz+hw6quf0iltvw1PHFFye/5PO4oZ06Ju1Vxdbolxkjg2ni1rYaeQGIDSWunYpRggxovfh+ePIF1GLIHNKDnCxknXLSfDUwNHeooIHhHF/MQqOsQQ8cOVSv0+Ek5pzSALbdf+gORsBDtEOeRExiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991361; c=relaxed/simple;
	bh=Y+uvM5u5r1eEdseRFlgmjFyNibB2OCh+BhOWaA/hUkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6Isv0YCuO+JRXHwR2z285i/1IHhY3WsPA5IkOBF2VaH24PrAWTmLPdVNy0A+4f6PPaAQVNEknPno/M0OBEvj2pgUHOYs996Oo/S7pTiUXXPPq/69XUD1PPpVlS6fbebCsQ/LkWGxrCnW1N/uEaqzMC9OkZqlEcw448Wh2k+554=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+hoRiUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+hoRiUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9643C433C7;
	Mon,  1 Apr 2024 17:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991361;
	bh=Y+uvM5u5r1eEdseRFlgmjFyNibB2OCh+BhOWaA/hUkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+hoRiUkeo7J9tjhm9mrk/p4bHVdKglg1rW48cWQfMDwxqtMtzkRaVXFfhJlDRBnI
	 iLPdjkEn/XeV2+sxsU65bJImbTwB31ZAYbJ1KB1xZaIeNhujxBKSSs0MpzR6UVWuli
	 skvDANhmiYGmg8jG3HPlH8ZUNxZ5dn2uZzIySZwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 213/272] btrfs: zoned: dont skip block groups with 100% zone unusable
Date: Mon,  1 Apr 2024 17:46:43 +0200
Message-ID: <20240401152537.583148927@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit a8b70c7f8600bc77d03c0b032c0662259b9e615e upstream.

Commit f4a9f219411f ("btrfs: do not delete unused block group if it may be
used soon") changed the behaviour of deleting unused block-groups on zoned
filesystems. Starting with this commit, we're using
btrfs_space_info_used() to calculate the number of used bytes in a
space_info. But btrfs_space_info_used() also accounts
btrfs_space_info::bytes_zone_unusable as used bytes.

So if a block group is 100% zone_unusable it is skipped from the deletion
step.

In order not to skip fully zone_unusable block-groups, also check if the
block-group has bytes left that can be used on a zoned filesystem.

Fixes: f4a9f219411f ("btrfs: do not delete unused block group if it may be used soon")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1413,7 +1413,8 @@ void btrfs_delete_unused_bgs(struct btrf
 		 * needing to allocate extents from the block group.
 		 */
 		used = btrfs_space_info_used(space_info, true);
-		if (space_info->total_bytes - block_group->length < used) {
+		if (space_info->total_bytes - block_group->length < used &&
+		    block_group->zone_unusable < block_group->length) {
 			/*
 			 * Add a reference for the list, compensate for the ref
 			 * drop under the "next" label for the


