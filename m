Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C53C15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB9CC433D6;
	Tue,  8 Nov 2022 14:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916889;
	bh=mRpyBmb3JyKUnp9g1O5F69Fu/EwI9Jiq4F6HMfmM4lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2dLo1pZ9fk4ilUeHcQC0VKqhOY/GQRhIHnJHGNn18nA9KLsH/CHEepCh2S0OrfgR0
	 gy8/O2yVeRKm/DeV+oQCUqoskmfxkXu4EZwvbs5KOnXMf+YMc+Zjv2TFIqGIKd5esf
	 I8rpg/zqjo9iigx9rUSqMFLqJKOp3PeeQ5Qk9Oxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.0 166/197] ext4: update the backup superblocks at the end of the online resize
Date: Tue,  8 Nov 2022 14:40:04 +0100
Message-Id: <20221108133402.484225247@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Theodore Ts'o <tytso@mit.edu>

commit 9a8c5b0d061554fedd7dbe894e63aa34d0bac7c4 upstream.

When expanding a file system using online resize, various fields in
the superblock (e.g., s_blocks_count, s_inodes_count, etc.) change.
To update the backup superblocks, the online resize uses the function
update_backups() in fs/ext4/resize.c.  This function was not updating
the checksum field in the backup superblocks.  This wasn't a big deal
previously, because e2fsck didn't care about the checksum field in the
backup superblock.  (And indeed, update_backups() goes all the way
back to the ext3 days, well before we had support for metadata
checksums.)

However, there is an alternate, more general way of updating
superblock fields, ext4_update_primary_sb() in fs/ext4/ioctl.c.  This
function does check the checksum of the backup superblock, and if it
doesn't match will mark the file system as corrupted.  That was
clearly not the intent, so avoid to aborting the resize when a bad
superblock is found.

In addition, teach update_backups() to properly update the checksum in
the backup superblocks.  We will eventually want to unify
updapte_backups() with the infrasture in ext4_update_primary_sb(), but
that's for another day.

Note: The problem has been around for a while; it just didn't really
matter until ext4_update_primary_sb() was added by commit bbc605cdb1e1
("ext4: implement support for get/set fs label").  And it became
trivially easy to reproduce after commit 827891a38acc ("ext4: update
the s_overhead_clusters in the backup sb's when resizing") in v6.0.

Cc: stable@kernel.org # 5.17+
Fixes: bbc605cdb1e1 ("ext4: implement support for get/set fs label")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ioctl.c  |    3 +--
 fs/ext4/resize.c |    5 +++++
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -145,9 +145,8 @@ static int ext4_update_backup_sb(struct
 	if (ext4_has_metadata_csum(sb) &&
 	    es->s_checksum != ext4_superblock_csum(sb, es)) {
 		ext4_msg(sb, KERN_ERR, "Invalid checksum for backup "
-		"superblock %llu\n", sb_block);
+		"superblock %llu", sb_block);
 		unlock_buffer(bh);
-		err = -EFSBADCRC;
 		goto out_bh;
 	}
 	func(es, arg);
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1158,6 +1158,7 @@ static void update_backups(struct super_
 	while (group < sbi->s_groups_count) {
 		struct buffer_head *bh;
 		ext4_fsblk_t backup_block;
+		struct ext4_super_block *es;
 
 		/* Out of journal space, and can't get more - abort - so sad */
 		err = ext4_resize_ensure_credits_batch(handle, 1);
@@ -1186,6 +1187,10 @@ static void update_backups(struct super_
 		memcpy(bh->b_data, data, size);
 		if (rest)
 			memset(bh->b_data + size, 0, rest);
+		es = (struct ext4_super_block *) bh->b_data;
+		es->s_block_group_nr = cpu_to_le16(group);
+		if (ext4_has_metadata_csum(sb))
+			es->s_checksum = ext4_superblock_csum(sb, es);
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
 		err = ext4_handle_dirty_metadata(handle, NULL, bh);


