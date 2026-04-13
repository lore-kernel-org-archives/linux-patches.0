Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DD03264F2;
	Mon, 13 Apr 2026 16:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099349; cv=none; b=HTkPN353KRBF7D9Ib/vq64y4etf+SfF8KcmMnY0k+qHlzRXTmyKa+l3tEHjY/vhShh96uR4LVoY6of3oqxB6YVnlW9eoSzaRkD6kwyFXLQiDE/gWPw3+jAdLreLGbVOb37VDZc5Xg+ck51h++/rsZmiJaOokj3TXKq//uIGh37M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099349; c=relaxed/simple;
	bh=LtJd5CcpA0dBg/rKDJ9WVSfS00VAKbu41iVvUgyNgAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niuUS5DN9/LHGxvCSG8W+dqIEGGU2GVbK1plm788AZe+C22E7ehuV0wkmchZNMBzEDvDY90zq4J39bIWYBeegY3hLc3h1k7b7ZZv+OkulyybteUfNn1GmVMzGdCye4Eb/L9Uari1KkRktO/QOKvBasMPmGi4nJVIhFCl825fsTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=010siBDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="010siBDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70778C2BCAF;
	Mon, 13 Apr 2026 16:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099349;
	bh=LtJd5CcpA0dBg/rKDJ9WVSfS00VAKbu41iVvUgyNgAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=010siBDkr9D/CcwR3CprY6WmPKb6Lypfm6W7HN1iOlb1Ik/1EiIEZc15Cf0XCnp/q
	 vsek1v7igEIQoPkRcmquvqXK5Hn2jgS8/LDk+ZtrTetAIo2ljKNJF9m9Fpn5UtfuUt
	 2OlJRAojPYHATcO2r6ilh06L86N1Mu5GHSpyJa70=
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
Subject: [PATCH 5.10 306/491] ext4: avoid allocate block from corrupted group in ext4_mb_find_by_goal()
Date: Mon, 13 Apr 2026 17:59:11 +0200
Message-ID: <20260413155830.496958091@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1929,8 +1929,12 @@ int ext4_mb_find_by_goal(struct ext4_all
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


