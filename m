Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EB513B7AB;
	Tue, 27 Feb 2024 14:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043743; cv=none; b=eRgs/NW/JScMx4XNQxDdD/HxzIwTrkRpRIOu0fT2KZEC+ekA1GhEkuFiT5cFTBJlRQWG7B95LzWzk/HqRfU2V60RaWMMaWTOi6i5jnkgkXZeebT5QDJ398KnFNXKXyxWvn/CIpobI+5QfaB/7d0+mvxR53xvXSHfqn1DB6TcStA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043743; c=relaxed/simple;
	bh=NctMyBi8+ZKnXfIjAN+c1Au26D/JOeWaM3UnMhqYRGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTUqmjhluDLYzgclVL8F/zOoKffVzY/ECylWOjSbI0cwOvoXGKbd3kNxTXaf02ITqjEjMVwoaJjGrQ23d0FDrUE7+7BDRynfZvRYf2CmIsMCHiUGjz6pxB6NYW3wO3Vb2nKem6AfaiKQB0WNPrkNaquKMyX63lyXHGZE6iF5rCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oe12DV/9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oe12DV/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB29C433C7;
	Tue, 27 Feb 2024 14:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043743;
	bh=NctMyBi8+ZKnXfIjAN+c1Au26D/JOeWaM3UnMhqYRGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oe12DV/9lPrL9Kmi+naObgEcoYuXmoqH4P9ZnPfy7eVyVXs1S/eMKohZszSu1BGB9
	 Y5d6vcr65U/yzb0j0QS4GIAlZhDxkSiwgwov9uxi5foaWSu7YWoVxzsIsFa5p30nvN
	 DXtkfDt/3Ygy3RkLI3zcaHpCA44UM2mq6y2TZb9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/84] ext4: avoid allocating blocks from corrupted group in ext4_mb_try_best_found()
Date: Tue, 27 Feb 2024 14:26:48 +0100
Message-ID: <20240227131553.557873738@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 4530b3660d396a646aad91a787b6ab37cf604b53 ]

Determine if the group block bitmap is corrupted before using ac_b_ex in
ext4_mb_try_best_found() to avoid allocating blocks from a group with a
corrupted block bitmap in the following concurrency and making the
situation worse.

ext4_mb_regular_allocator
  ext4_lock_group(sb, group)
  ext4_mb_good_group
   // check if the group bbitmap is corrupted
  ext4_mb_complex_scan_group
   // Scan group gets ac_b_ex but doesn't use it
  ext4_unlock_group(sb, group)
                           ext4_mark_group_bitmap_corrupted(group)
                           // The block bitmap was corrupted during
                           // the group unlock gap.
  ext4_mb_try_best_found
    ext4_lock_group(ac->ac_sb, group)
    ext4_mb_use_best_found
      mb_mark_used
      // Allocating blocks in block bitmap corrupted group

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240104142040.2835097-7-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 0745330228cf0..1af9daaff8ba2 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1802,6 +1802,9 @@ int ext4_mb_try_best_found(struct ext4_allocation_context *ac,
 		return err;
 
 	ext4_lock_group(ac->ac_sb, group);
+	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info)))
+		goto out;
+
 	max = mb_find_extent(e4b, ex.fe_start, ex.fe_len, &ex);
 
 	if (max > 0) {
@@ -1809,6 +1812,7 @@ int ext4_mb_try_best_found(struct ext4_allocation_context *ac,
 		ext4_mb_use_best_found(ac, e4b);
 	}
 
+out:
 	ext4_unlock_group(ac->ac_sb, group);
 	ext4_mb_unload_buddy(e4b);
 
-- 
2.43.0



