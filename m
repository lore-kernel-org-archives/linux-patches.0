Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9879739FD9;
	Tue, 26 Aug 2025 13:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214822; cv=none; b=DXlP8nPdfgkMy1wt9ZApB31NlOjQnMwzlD2lByl9h45SjdfJjJV3DebegxPfXdCFIp1RjxgWzDJcyCG+FrCW8m2gzwYTyxVwLNIKRESwgUVSYdP8gtTrOXhcEowq+UXhiv8tA6KIU8Y4OR4EmyLkm0EznJKJ7Amemg7FuqQws0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214822; c=relaxed/simple;
	bh=LjwRD8eKi1tQTIjn9AJVfhz1kv3JjkeaCM3XTR83nRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWM0yzLhU3HzlRq0PENPnDvEEomXCieAsSTpLcPeDSywU26a7ZPRENfbAM2pP8pd44RiM5ZXuQp7i209Q+YzeJFl929IJ5Rg0rjHaQ2TBn7wb1IrRWODPQREnqHqMuA+0Z75vie6amYB8uTcHLfzV2JQENI7B8KFIv9qmkWg5+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sc/qblqZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sc/qblqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC54C4CEF1;
	Tue, 26 Aug 2025 13:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214822;
	bh=LjwRD8eKi1tQTIjn9AJVfhz1kv3JjkeaCM3XTR83nRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sc/qblqZp/LKcW5oiD68J7cdMjuHjezfsV0LbzxsIhS35AVV4nDXrhTi2K1QekfCt
	 QA/NL8OpD9zdyMcRtS4jYC99804LKG7d7PB1IsyqYg6Sm7dJtkauaznLZKRr7TT4ar
	 UrqQWQcnWaWDk3PvWwz3yDwXVYcWAmrGQP6JjUJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Disha Goel <disgoel@linux.ibm.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 281/482] ext4: fix fsmap end of range reporting with bigalloc
Date: Tue, 26 Aug 2025 13:08:54 +0200
Message-ID: <20250826110937.724686401@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

commit bae76c035bf0852844151e68098c9b7cd63ef238 upstream.

With bigalloc enabled, the logic to report last extent has a bug since
we try to use cluster units instead of block units. This can cause an
issue where extra incorrect entries might be returned back to the
user. This was flagged by generic/365 with 64k bs and -O bigalloc.

** Details of issue **

The issue was noticed on 5G 64k blocksize FS with -O bigalloc which has
only 1 bg.

$ xfs_io -c "fsmap -d" /mnt/scratch

  0: 253:48 [0..127]: static fs metadata 128   /* sb */
  1: 253:48 [128..255]: special 102:1 128   /* gdt */
  3: 253:48 [256..383]: special 102:3 128   /* block bitmap */
  4: 253:48 [384..2303]: unknown 1920       /* flex bg empty space */
  5: 253:48 [2304..2431]: special 102:4 128   /* inode bitmap */
  6: 253:48 [2432..4351]: unknown 1920      /* flex bg empty space */
  7: 253:48 [4352..6911]: inodes 2560
  8: 253:48 [6912..538623]: unknown 531712
  9: 253:48 [538624..10485759]: free space 9947136

The issue can be seen with:

$ xfs_io -c "fsmap -d 0 3" /mnt/scratch

  0: 253:48 [0..127]: static fs metadata 128
  1: 253:48 [384..2047]: unknown 1664

Only the first entry was expected to be returned but we get 2. This is
because:

ext4_getfsmap_datadev()
  first_cluster, last_cluster = 0
  ...
  info->gfi_last = true;
  ext4_getfsmap_datadev_helper(sb, end_ag, last_cluster + 1, 0, info);
    fsb = C2B(1) = 16
    fslen = 0
    ...
    /* Merge in any relevant extents from the meta_list */
    list_for_each_entry_safe(p, tmp, &info->gfi_meta_list, fmr_list) {
      ...
      // since fsb = 16, considers all metadata which starts before 16 blockno
      iter 1: error = ext4_getfsmap_helper(sb, info, p);  // p = sb (0,1), nop
        info->gfi_next_fsblk = 1
      iter 2: error = ext4_getfsmap_helper(sb, info, p);  // p = gdt (1,2), nop
        info->gfi_next_fsblk = 2
      iter 3: error = ext4_getfsmap_helper(sb, info, p);  // p = blk bitmap (2,3), nop
        info->gfi_next_fsblk = 3
      iter 4: error = ext4_getfsmap_helper(sb, info, p);  // p = ino bitmap (18,19)
        if (rec_blk > info->gfi_next_fsblk) { // (18 > 3)
          // emits an extra entry ** BUG **
        }
    }

Fix this by directly calling ext4_getfsmap_datadev() with a dummy
record that has fmr_physical set to (end_fsb + 1) instead of
last_cluster + 1. By using the block instead of cluster we get the
correct behavior.

Replacing ext4_getfsmap_datadev_helper() with ext4_getfsmap_helper()
is okay since the gfi_lastfree and metadata checks in
ext4_getfsmap_datadev_helper() are anyways redundant when we only want
to emit the last allocated block of the range, as we have already
taken care of emitting metadata and any last free blocks.

Cc: stable@kernel.org
Reported-by: Disha Goel <disgoel@linux.ibm.com>
Fixes: 4a622e4d477b ("ext4: fix FS_IOC_GETFSMAP handling")
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Link: https://patch.msgid.link/e7472c8535c9c5ec10f425f495366864ea12c9da.1754377641.git.ojaswin@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fsmap.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/fs/ext4/fsmap.c
+++ b/fs/ext4/fsmap.c
@@ -526,6 +526,7 @@ static int ext4_getfsmap_datadev(struct
 	ext4_group_t end_ag;
 	ext4_grpblk_t first_cluster;
 	ext4_grpblk_t last_cluster;
+	struct ext4_fsmap irec;
 	int error = 0;
 
 	bofs = le32_to_cpu(sbi->s_es->s_first_data_block);
@@ -609,10 +610,18 @@ static int ext4_getfsmap_datadev(struct
 			goto err;
 	}
 
-	/* Report any gaps at the end of the bg */
+	/*
+	 * The dummy record below will cause ext4_getfsmap_helper() to report
+	 * any allocated blocks at the end of the range.
+	 */
+	irec.fmr_device = 0;
+	irec.fmr_physical = end_fsb + 1;
+	irec.fmr_length = 0;
+	irec.fmr_owner = EXT4_FMR_OWN_FREE;
+	irec.fmr_flags = 0;
+
 	info->gfi_last = true;
-	error = ext4_getfsmap_datadev_helper(sb, end_ag, last_cluster + 1,
-					     0, info);
+	error = ext4_getfsmap_helper(sb, info, &irec);
 	if (error)
 		goto err;
 


