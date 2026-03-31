Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F71B1C861A;
	Tue, 31 Mar 2026 16:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975447; cv=none; b=hmJ/9CV1rpXj7GsAZTHKX4pVv2oB0xT9Ax+OLlKk++zbj2dxUbMRMK4djC3QvcgTSvt/xt2Zb1bhl10rb1W69XBERbB6zy2vz5yWIn0/7B9wrvqnnJFClsgSmDaTsfslImFQHU3FOARbzBW5LY+gnyc1VvhUuE1W5WeC/NgSvao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975447; c=relaxed/simple;
	bh=gvHjz8s8a96+6/YUklGlSDl+n3VHHMp/XuyQPJQf5jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6DRMvpIfTKUayae481L/B8mJo/+f1WQPfLdilYMzSoDyxNIeUzgSAEUCq/FEp31SNhEwswR6GZHMx770hu8MkNAr606arOHb+7zbPlTdTiknn/B181n9gQjnsZcM7TpzfWV8YXq7ZhugwbUCx5T409401d4mQWsc7zHSX4w6A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6xa0ii7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6xa0ii7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E8FC19423;
	Tue, 31 Mar 2026 16:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975447;
	bh=gvHjz8s8a96+6/YUklGlSDl+n3VHHMp/XuyQPJQf5jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6xa0ii78MY4PdB2wPXGgWdp+fmEvlA4YQjdt8+3g4LZNYh7rXPN6+U1dXGlLkNms
	 PL44S+w4DP1pyqDYFMxpI+7HIAignOzGS7sfeupEqk0ornl+LCXj8QITJTiII5SKhT
	 ncMiDGkYncLNR6350L0qsdtEzzVPa05KnIBToePE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <me@linux.beauty>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.19 297/342] ext4: publish jinode after initialization
Date: Tue, 31 Mar 2026 18:22:10 +0200
Message-ID: <20260331161809.862634183@linuxfoundation.org>
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

From: Li Chen <me@linux.beauty>

commit 1aec30021edd410b986c156f195f3d23959a9d11 upstream.

ext4_inode_attach_jinode() publishes ei->jinode to concurrent users.
It used to set ei->jinode before jbd2_journal_init_jbd_inode(),
allowing a reader to observe a non-NULL jinode with i_vfs_inode
still unset.

The fast commit flush path can then pass this jinode to
jbd2_wait_inode_data(), which dereferences i_vfs_inode->i_mapping and
may crash.

Below is the crash I observe:
```
BUG: unable to handle page fault for address: 000000010beb47f4
PGD 110e51067 P4D 110e51067 PUD 0
Oops: Oops: 0000 [#1] SMP NOPTI
CPU: 1 UID: 0 PID: 4850 Comm: fc_fsync_bench_ Not tainted 6.18.0-00764-g795a690c06a5 #1 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.17.0-2-2 04/01/2014
RIP: 0010:xas_find_marked+0x3d/0x2e0
Code: e0 03 48 83 f8 02 0f 84 f0 01 00 00 48 8b 47 08 48 89 c3 48 39 c6 0f 82 fd 01 00 00 48 85 c9 74 3d 48 83 f9 03 77 63 4c 8b 0f <49> 8b 71 08 48 c7 47 18 00 00 00 00 48 89 f1 83 e1 03 48 83 f9 02
RSP: 0018:ffffbbee806e7bf0 EFLAGS: 00010246
RAX: 000000000010beb4 RBX: 000000000010beb4 RCX: 0000000000000003
RDX: 0000000000000001 RSI: 0000002000300000 RDI: ffffbbee806e7c10
RBP: 0000000000000001 R08: 0000002000300000 R09: 000000010beb47ec
R10: ffff9ea494590090 R11: 0000000000000000 R12: 0000002000300000
R13: ffffbbee806e7c90 R14: ffff9ea494513788 R15: ffffbbee806e7c88
FS: 00007fc2f9e3e6c0(0000) GS:ffff9ea6b1444000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000010beb47f4 CR3: 0000000119ac5000 CR4: 0000000000750ef0
PKRU: 55555554
Call Trace:
<TASK>
filemap_get_folios_tag+0x87/0x2a0
__filemap_fdatawait_range+0x5f/0xd0
? srso_alias_return_thunk+0x5/0xfbef5
? __schedule+0x3e7/0x10c0
? srso_alias_return_thunk+0x5/0xfbef5
? srso_alias_return_thunk+0x5/0xfbef5
? srso_alias_return_thunk+0x5/0xfbef5
? preempt_count_sub+0x5f/0x80
? srso_alias_return_thunk+0x5/0xfbef5
? cap_safe_nice+0x37/0x70
? srso_alias_return_thunk+0x5/0xfbef5
? preempt_count_sub+0x5f/0x80
? srso_alias_return_thunk+0x5/0xfbef5
filemap_fdatawait_range_keep_errors+0x12/0x40
ext4_fc_commit+0x697/0x8b0
? ext4_file_write_iter+0x64b/0x950
? srso_alias_return_thunk+0x5/0xfbef5
? preempt_count_sub+0x5f/0x80
? srso_alias_return_thunk+0x5/0xfbef5
? vfs_write+0x356/0x480
? srso_alias_return_thunk+0x5/0xfbef5
? preempt_count_sub+0x5f/0x80
ext4_sync_file+0xf7/0x370
do_fsync+0x3b/0x80
? syscall_trace_enter+0x108/0x1d0
__x64_sys_fdatasync+0x16/0x20
do_syscall_64+0x62/0x2c0
entry_SYSCALL_64_after_hwframe+0x76/0x7e
...
```

Fix this by initializing the jbd2_inode first.
Use smp_wmb() and WRITE_ONCE() to publish ei->jinode after
initialization. Readers use READ_ONCE() to fetch the pointer.

Fixes: a361293f5fede ("jbd2: Fix oops in jbd2_journal_file_inode()")
Cc: stable@vger.kernel.org
Signed-off-by: Li Chen <me@linux.beauty>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260225082617.147957-1-me@linux.beauty
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |    4 ++--
 fs/ext4/inode.c       |   15 +++++++++++----
 2 files changed, 13 insertions(+), 6 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -975,13 +975,13 @@ static int ext4_fc_flush_data(journal_t
 	int ret = 0;
 
 	list_for_each_entry(ei, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
-		ret = jbd2_submit_inode_data(journal, ei->jinode);
+		ret = jbd2_submit_inode_data(journal, READ_ONCE(ei->jinode));
 		if (ret)
 			return ret;
 	}
 
 	list_for_each_entry(ei, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
-		ret = jbd2_wait_inode_data(journal, ei->jinode);
+		ret = jbd2_wait_inode_data(journal, READ_ONCE(ei->jinode));
 		if (ret)
 			return ret;
 	}
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -126,6 +126,8 @@ void ext4_inode_csum_set(struct inode *i
 static inline int ext4_begin_ordered_truncate(struct inode *inode,
 					      loff_t new_size)
 {
+	struct jbd2_inode *jinode = READ_ONCE(EXT4_I(inode)->jinode);
+
 	trace_ext4_begin_ordered_truncate(inode, new_size);
 	/*
 	 * If jinode is zero, then we never opened the file for
@@ -133,10 +135,10 @@ static inline int ext4_begin_ordered_tru
 	 * jbd2_journal_begin_ordered_truncate() since there's no
 	 * outstanding writes we need to flush.
 	 */
-	if (!EXT4_I(inode)->jinode)
+	if (!jinode)
 		return 0;
 	return jbd2_journal_begin_ordered_truncate(EXT4_JOURNAL(inode),
-						   EXT4_I(inode)->jinode,
+						   jinode,
 						   new_size);
 }
 
@@ -4499,8 +4501,13 @@ int ext4_inode_attach_jinode(struct inod
 			spin_unlock(&inode->i_lock);
 			return -ENOMEM;
 		}
-		ei->jinode = jinode;
-		jbd2_journal_init_jbd_inode(ei->jinode, inode);
+		jbd2_journal_init_jbd_inode(jinode, inode);
+		/*
+		 * Publish ->jinode only after it is fully initialized so that
+		 * readers never observe a partially initialized jbd2_inode.
+		 */
+		smp_wmb();
+		WRITE_ONCE(ei->jinode, jinode);
 		jinode = NULL;
 	}
 	spin_unlock(&inode->i_lock);


