Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F7326AC5;
	Sat, 12 Sep 2026 15:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228756; cv=none; b=Y3oF9HKJaDFoCV3+y4xdNQpnW4rR0WJfPzSlHR08MUsZjvU6ewhW+2DCMV82mNMocEBAluFjmqn6+oHOE2fjPYk7Lxpy/+s9Yh0SnOo2IUbj0v+kadWGpgX295zkGzIBNGmvJn80ZvBHsXwAKiChxKcSXJ5IN3wuGBLVM1HTqLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228756; c=relaxed/simple;
	bh=ar9tIgOdFeWuAGwNuCnavUDQZOr9B8W450WGx8irqHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVDCEAlU2uSNd3Y6x1Jn4u0ZlSPaLUWeHSGfRf9Rqjm2hDgipCfE0We7uSDhf4dbGZJGX4jbYIdQqu76W+g4Xx666cbmO5unY3zmVqkH8Dck8jqWvHV4MG9hE9nx5FjzwnqoJkXhw78YvSB5GS1ImwNNhIjeA9T9qYlp3DroKbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pHzpVI+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pHzpVI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCD71F000FF;
	Sat, 12 Sep 2026 15:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228755;
	bh=Y7gxKmYPURORacGhBspRb0Gh3ShQDbnlgMupt29ae/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0pHzpVI+L1q8T0Cu3CcvkQjWxRnys9pFHvrBUtuk5pM+2CD0uRUeAKH8ACQ5tmoQa
	 cBOTdYq37IJTymw7f4QanU2Z+zEw+/ezvfSQQYO0AsOajgwLCtQRvvL5KimDxA9U/X
	 5RJeAuRoKHGei7ZoiESKv5yBxCorcz/hf7j+46uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0449/1191] ext4: move ext4_percpu_param_init() before ext4_mb_init()
Date: Sat, 12 Sep 2026 08:52:57 +0200
Message-ID: <20260912065558.316787842@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 44b8c0dc9a41f..f2a569868e416 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5515,6 +5515,10 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 			clear_opt2(sb, MB_OPTIMIZE_SCAN);
 	}
 
+	err = ext4_percpu_param_init(sbi);
+	if (err)
+		goto failed_mount5;
+
 	err = ext4_mb_init(sb);
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "failed to initialize mballoc (%d)",
@@ -5530,10 +5534,6 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		sbi->s_journal->j_commit_callback =
 			ext4_journal_commit_callback;
 
-	err = ext4_percpu_param_init(sbi);
-	if (err)
-		goto failed_mount6;
-
 	if (ext4_has_feature_flex_bg(sb))
 		if (!ext4_fill_flex_info(sb)) {
 			ext4_msg(sb, KERN_ERR,
@@ -5616,8 +5616,8 @@ failed_mount9: __maybe_unused
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
2.53.0



