Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804A91C687;
	Mon,  4 Mar 2024 21:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588136; cv=none; b=H+J4Ttgp6W1Or2SmVJ3jtAAsrD3ac/OMzKJuLey7uqTcOMTg3MkdVKAz5Xdd5DtytBQHepemPofN8Bug9MFpkfOQlpS0KqLGxWNC0hBdeWI1P1K5gV6B30+taQpULFYyE+LuOWdkObKjYY9ah9ed6Z1nETFsKHeUgJdMA42edYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588136; c=relaxed/simple;
	bh=rkigtyckAqwEooavJvh/6pKJQ16ctNJwmawE0sNn98U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXt+KvScU3N1cWWAmLFd37bQtTd/7iE0i/Ss/IsAXnxvHxapQojYNIxeL1MYsQF7IMpdxFM5LObWifefw367Vz1A4XHUlgiYvtz20uAz6BMpUMPwp4jXCq5r9Cn0bmYx2d5SpJq0HBGdlWzpdpvXhyZaO8H0b/a/POVPlGsa824=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OO3iqKpM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OO3iqKpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B71C433C7;
	Mon,  4 Mar 2024 21:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588136;
	bh=rkigtyckAqwEooavJvh/6pKJQ16ctNJwmawE0sNn98U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OO3iqKpMckdBsXYu285b5ftdX0vkatCjHnrdFusOyN5dguvSR1lUEnp2N3BZCLMxr
	 RCEiOn7RGnMrJsqM+QLPf54X60DrYYuDl4XMcXd8CiHfPp85QaK5eJMJgVCZacFLqX
	 xickE+bI0htJNEf7XUP0YM2AlES/UBK6S3uyPD34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 35/42] ext4: avoid bb_free and bb_fragments inconsistency in mb_free_blocks()
Date: Mon,  4 Mar 2024 21:24:02 +0000
Message-ID: <20240304211538.831054302@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211537.631764077@linuxfoundation.org>
References: <20240304211537.631764077@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

commit 2331fd4a49864e1571b4f50aa3aa1536ed6220d0 upstream.

After updating bb_free in mb_free_blocks, it is possible to return without
updating bb_fragments because the block being freed is found to have
already been freed, which leads to inconsistency between bb_free and
bb_fragments.

Since the group may be unlocked in ext4_grp_locked_error(), this can lead
to problems such as dividing by zero when calculating the average fragment
length. Hence move the update of bb_free to after the block double-free
check guarantees that the corresponding statistics are updated only after
the core block bitmap is modified.

Fixes: eabe0444df90 ("ext4: speed-up releasing blocks on commit")
CC:  <stable@vger.kernel.org> # 3.10
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240104142040.2835097-5-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1494,11 +1494,6 @@ static void mb_free_blocks(struct inode
 	mb_check_buddy(e4b);
 	mb_free_blocks_double(inode, e4b, first, count);
 
-	this_cpu_inc(discard_pa_seq);
-	e4b->bd_info->bb_free += count;
-	if (first < e4b->bd_info->bb_first_free)
-		e4b->bd_info->bb_first_free = first;
-
 	/* access memory sequentially: check left neighbour,
 	 * clear range and then check right neighbour
 	 */
@@ -1512,23 +1507,31 @@ static void mb_free_blocks(struct inode
 		struct ext4_sb_info *sbi = EXT4_SB(sb);
 		ext4_fsblk_t blocknr;
 
+		/*
+		 * Fastcommit replay can free already freed blocks which
+		 * corrupts allocation info. Regenerate it.
+		 */
+		if (sbi->s_mount_state & EXT4_FC_REPLAY) {
+			mb_regenerate_buddy(e4b);
+			goto check;
+		}
+
 		blocknr = ext4_group_first_block_no(sb, e4b->bd_group);
 		blocknr += EXT4_C2B(sbi, block);
-		if (!(sbi->s_mount_state & EXT4_FC_REPLAY)) {
-			ext4_grp_locked_error(sb, e4b->bd_group,
-					      inode ? inode->i_ino : 0,
-					      blocknr,
-					      "freeing already freed block (bit %u); block bitmap corrupt.",
-					      block);
-			ext4_mark_group_bitmap_corrupted(
-				sb, e4b->bd_group,
+		ext4_grp_locked_error(sb, e4b->bd_group,
+				      inode ? inode->i_ino : 0, blocknr,
+				      "freeing already freed block (bit %u); block bitmap corrupt.",
+				      block);
+		ext4_mark_group_bitmap_corrupted(sb, e4b->bd_group,
 				EXT4_GROUP_INFO_BBITMAP_CORRUPT);
-		} else {
-			mb_regenerate_buddy(e4b);
-		}
-		goto done;
+		return;
 	}
 
+	this_cpu_inc(discard_pa_seq);
+	e4b->bd_info->bb_free += count;
+	if (first < e4b->bd_info->bb_first_free)
+		e4b->bd_info->bb_first_free = first;
+
 	/* let's maintain fragments counter */
 	if (left_is_free && right_is_free)
 		e4b->bd_info->bb_fragments--;
@@ -1553,8 +1556,8 @@ static void mb_free_blocks(struct inode
 	if (first <= last)
 		mb_buddy_mark_free(e4b, first >> 1, last >> 1);
 
-done:
 	mb_set_largest_free_order(sb, e4b->bd_info);
+check:
 	mb_check_buddy(e4b);
 }
 


