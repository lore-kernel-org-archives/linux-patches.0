Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706D2262A6;
	Tue, 31 Mar 2026 16:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975457; cv=none; b=cCrwyjPXkqt3Rk6J4tKZGbFP4LtgI5cZis2U4DHeNjjJDHfrtIAWzb9PcAjwexMKn/OrxnkSZvWpzIiYdEZCBUoQAWsydfUAJeiWyWzKZYhBcyQOHRA+grABxryN1x5MfN/+Ug0M7+0Bj2b9HXvuwZ2jP0HYvuaP5IwBg8w0T0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975457; c=relaxed/simple;
	bh=KOsMyFTrY7w9pGFNiXVJd+tR/sOD2sPyO/2TzXah3Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNmnV51hbI88ixgeoEOnZCG1aycEt/Vg9Sj8AKJEDSlwoiHrR27oYYBtFFznkJGD424Qmg76u6NSMw+dju13EXYeIyNM23pSe2EWqxFt5LjlFuNdsYwzMtJbg6a0o0c4s/sQynkOLs9AQ7BMpFBawVQcgbyJ42UmYpHkbEEGBcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/NKJfRi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/NKJfRi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060D2C19423;
	Tue, 31 Mar 2026 16:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975457;
	bh=KOsMyFTrY7w9pGFNiXVJd+tR/sOD2sPyO/2TzXah3Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/NKJfRiREISfAdZx40YXxpG/iaVmvtNdea+j7ZTh9vjMEDgfwvrdmL0iQhqMo/M4
	 KOzRnBC2U+N1p2PdKh0m29Cn9FavDShPEAtcJR0ZE5f5bn65BFjlT5lhUUHXyHACeI
	 QTXtgzM57IpDKedZzJsp7JDRsaxDhrKt2i/d0+GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.19 301/342] ext4: avoid allocate block from corrupted group in ext4_mb_find_by_goal()
Date: Tue, 31 Mar 2026 18:22:14 +0200
Message-ID: <20260331161810.004813004@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

commit 46066e3a06647c5b186cc6334409722622d05c44 upstream.

There's issue as follows:
...
EXT4-fs (mmcblk0p1): Delayed block allocation failed for inode 206 at logical offset 0 with max blocks 1 with error 117
EXT4-fs (mmcblk0p1): This should not happen!! Data will be lost

EXT4-fs (mmcblk0p1): Delayed block allocation failed for inode 206 at logical offset 0 with max blocks 1 with error 117
EXT4-fs (mmcblk0p1): This should not happen!! Data will be lost

EXT4-fs (mmcblk0p1): Delayed block allocation failed for inode 206 at logical offset 0 with max blocks 1 with error 117
EXT4-fs (mmcblk0p1): This should not happen!! Data will be lost

EXT4-fs (mmcblk0p1): Delayed block allocation failed for inode 206 at logical offset 0 with max blocks 1 with error 117
EXT4-fs (mmcblk0p1): This should not happen!! Data will be lost

EXT4-fs (mmcblk0p1): Delayed block allocation failed for inode 2243 at logical offset 0 with max blocks 1 with error 117
EXT4-fs (mmcblk0p1): This should not happen!! Data will be lost

EXT4-fs (mmcblk0p1): Delayed block allocation failed for inode 2239 at logical offset 0 with max blocks 1 with error 117
EXT4-fs (mmcblk0p1): This should not happen!! Data will be lost

EXT4-fs (mmcblk0p1): error count since last fsck: 1
EXT4-fs (mmcblk0p1): initial error at time 1765597433: ext4_mb_generate_buddy:760
EXT4-fs (mmcblk0p1): last error at time 1765597433: ext4_mb_generate_buddy:760
...

According to the log analysis, blocks are always requested from the
corrupted block group. This may happen as follows:
ext4_mb_find_by_goal
  ext4_mb_load_buddy
   ext4_mb_load_buddy_gfp
     ext4_mb_init_cache
      ext4_read_block_bitmap_nowait
      ext4_wait_block_bitmap
       ext4_validate_block_bitmap
        if (!grp || EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
         return -EFSCORRUPTED; // There's no logs.
 if (err)
  return err;  // Will return error
ext4_lock_group(ac->ac_sb, group);
  if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info))) // Unreachable
   goto out;

After commit 9008a58e5dce ("ext4: make the bitmap read routines return
real error codes") merged, Commit 163a203ddb36 ("ext4: mark block group
as corrupt on block bitmap error") is no real solution for allocating
blocks from corrupted block groups. This is because if
'EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info)' is true, then
'ext4_mb_load_buddy()' may return an error. This means that the block
allocation will fail.
Therefore, check block group if corrupted when ext4_mb_load_buddy()
returns error.

Fixes: 163a203ddb36 ("ext4: mark block group as corrupt on block bitmap error")
Fixes: 9008a58e5dce ("ext4: make the bitmap read routines return real error codes")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260302134619.3145520-1-yebin@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2443,8 +2443,12 @@ int ext4_mb_find_by_goal(struct ext4_all
 		return 0;
 
 	err = ext4_mb_load_buddy(ac->ac_sb, group, e4b);
-	if (err)
+	if (err) {
+		if (EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info) &&
+		    !(ac->ac_flags & EXT4_MB_HINT_GOAL_ONLY))
+			return 0;
 		return err;
+	}
 
 	ext4_lock_group(ac->ac_sb, group);
 	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info)))


