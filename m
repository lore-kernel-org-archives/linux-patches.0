Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1368C340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301097; cv=none; b=aYsI+qtpdiNu204fzCrjEymSbscUktbMPAaB5avbShVO+vrNqZ1CAI/ES33DcCgQQH4iE6Y1jTRRlwAGXGfBXLAkY3pJFPBHnxOXwr5MZeie/bAi3ROket5UGnBTeO6oAsuj0hIA++HWWMGHIjGPvs2ws4Wr4Ls6vCEqzj+84Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301097; c=relaxed/simple;
	bh=MnePM5clM5bMJt3NTSI6XRI2xXw327QZDD7Xn1DK26Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSZpHul76865Oe9B8z7CF5QeKER7HaMUE7sJHTaQ++vZdfRbLW9E6ry+tBrGTFF9TevozlilDjtmLX1vcRMqoG0HP3Z2+++9IPPU8aUOYKpTOnaFwEHNYUl+5XnVYrkoQ1VnNnO97Y8RJ79D63A6OLrPHl/30a9syxHsg+rSIRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LFhVfdj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LFhVfdj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B54FC19425;
	Sat, 28 Feb 2026 17:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301096;
	bh=MnePM5clM5bMJt3NTSI6XRI2xXw327QZDD7Xn1DK26Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFhVfdj3Fnhciw2Q8F9f9wHlkuZ9h4bNjiKWFiH9Yydjw0KTw0hQ1PwEL0qQaB1nY
	 rYGV+BlShq0Kn/qtU+zBYqRFnDWtD9XCAMVUzBSr8hvqKlCImMEiNEJ/17UxKrO9eH
	 ZRd0QvO6294mwBTkEcwzTO+zFCG4RN43vB9TBSpHVEx5CQzldQC8CJ2AhL3A9G5+fd
	 NsPNz91pD8Qk7kbQjBoLYj1NVVw49S+IlcdgSe7Cf+gYctAZPgSE/oVHgbT3N3l7EF
	 od9D/BWSpvBUNRPvwPmrN2DaEMWqVnjV4B0UbCmg3HMbloSshSRji/ibhXpuvu0REP
	 hL13yrhkdHqsA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 248/752] ext4: move ext4_percpu_param_init() before ext4_mb_init()
Date: Sat, 28 Feb 2026 12:39:19 -0500
Message-ID: <20260228174750.1542406-248-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 270564513489d98b721a1e4a10017978d5213bff ]

When running `kvm-xfstests -c ext4/1k -C 1 generic/383` with the
`DOUBLE_CHECK` macro defined, the following panic is triggered:

==================================================================
EXT4-fs error (device vdc): ext4_validate_block_bitmap:423:
                        comm mount: bg 0: bad block bitmap checksum
BUG: unable to handle page fault for address: ff110000fa2cc000
PGD 3e01067 P4D 3e02067 PUD 0
Oops: Oops: 0000 [#1] SMP NOPTI
CPU: 0 UID: 0 PID: 2386 Comm: mount Tainted: G W
                        6.18.0-gba65a4e7120a-dirty #1152 PREEMPT(none)
RIP: 0010:percpu_counter_add_batch+0x13/0xa0
Call Trace:
 <TASK>
 ext4_mark_group_bitmap_corrupted+0xcb/0xe0
 ext4_validate_block_bitmap+0x2a1/0x2f0
 ext4_read_block_bitmap+0x33/0x50
 mb_group_bb_bitmap_alloc+0x33/0x80
 ext4_mb_add_groupinfo+0x190/0x250
 ext4_mb_init_backend+0x87/0x290
 ext4_mb_init+0x456/0x640
 __ext4_fill_super+0x1072/0x1680
 ext4_fill_super+0xd3/0x280
 get_tree_bdev_flags+0x132/0x1d0
 vfs_get_tree+0x29/0xd0
 vfs_cmd_create+0x59/0xe0
 __do_sys_fsconfig+0x4f6/0x6b0
 do_syscall_64+0x50/0x1f0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
==================================================================

This issue can be reproduced using the following commands:
        mkfs.ext4 -F -q -b 1024 /dev/sda 5G
        tune2fs -O quota,project /dev/sda
        mount /dev/sda /tmp/test

With DOUBLE_CHECK defined, mb_group_bb_bitmap_alloc() reads
and validates the block bitmap. When the validation fails,
ext4_mark_group_bitmap_corrupted() attempts to update
sbi->s_freeclusters_counter. However, this percpu_counter has not been
initialized yet at this point, which leads to the panic described above.

Fix this by moving the execution of ext4_percpu_param_init() to occur
before ext4_mb_init(), ensuring the per-CPU counters are initialized
before they are used.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20251209133116.731350-1-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4ef5590c73fda..b5774f4101045 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5565,6 +5565,10 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 			clear_opt2(sb, MB_OPTIMIZE_SCAN);
 	}
 
+	err = ext4_percpu_param_init(sbi);
+	if (err)
+		goto failed_mount5;
+
 	err = ext4_mb_init(sb);
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "failed to initialize mballoc (%d)",
@@ -5580,10 +5584,6 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		sbi->s_journal->j_commit_callback =
 			ext4_journal_commit_callback;
 
-	err = ext4_percpu_param_init(sbi);
-	if (err)
-		goto failed_mount6;
-
 	if (ext4_has_feature_flex_bg(sb))
 		if (!ext4_fill_flex_info(sb)) {
 			ext4_msg(sb, KERN_ERR,
@@ -5665,8 +5665,8 @@ failed_mount8: __maybe_unused
 failed_mount6:
 	ext4_mb_release(sb);
 	ext4_flex_groups_free(sbi);
-	ext4_percpu_param_destroy(sbi);
 failed_mount5:
+	ext4_percpu_param_destroy(sbi);
 	ext4_ext_release(sb);
 	ext4_release_system_zone(sb);
 failed_mount4a:
-- 
2.51.0

