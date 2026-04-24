Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB58F19A288;
	Fri, 24 Apr 2026 13:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038189; cv=none; b=uc/5QRtjppbSiMJWzsYAS89oMpAErmfKM6WZBzhbFNEqgpcWW0DptpOqJHjyurYlDD0mG2RTAnvjDHvBPqPHI45jOd7d+resuXumRFymeo9iwBYh7xb0uc/y0eEtblALLWhDhNLtoRqtmXVsDA72k70QNszmvdBHVW7H1P9Ww/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038189; c=relaxed/simple;
	bh=T6v0uC1OJw/qaD+fHF5DkUZjfQjZX9lLBNEn4HdGpXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/veL0rS5FMOi5uY16BibAjG6vR8CpqnTQabwN+Np5IJyU5wbMdGrjsWFW+uvOAhi1qsoLxtLcTGwtTaGB0x0lfAkIt9GlAtPhebfAOyQyETqKexxpVMTa6zj5dDbQesTK8nEi+Rlbu5A2MaEh589j+yjg6qCl2ACWAEHdcCSfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVzdaXF+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVzdaXF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF82C19425;
	Fri, 24 Apr 2026 13:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038189;
	bh=T6v0uC1OJw/qaD+fHF5DkUZjfQjZX9lLBNEn4HdGpXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tVzdaXF+dvkz9JQUWPBX+lkgB7sOf8+feRkKpI/qgkcjdJBSx7n6xC1kbd9dIsd2b
	 S/WbMpltHpqnDpvNbaKGOB8paSFxrUj+j0jsilzrd7NYMULJjdrLamkVu4OZlf6MAY
	 u1eJItBjsn5mtnC7ucAH5fMVrNpZYZ257RGoD48g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+62538b67389ee582837a@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 27/55] f2fs: fix to do sanity check on dcc->discard_cmd_cnt conditionally
Date: Fri, 24 Apr 2026 15:31:06 +0200
Message-ID: <20260424132435.686937652@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 6af249c996f7d73a3435f9e577956fa259347d18 upstream.

Syzbot reported a f2fs bug as below:

------------[ cut here ]------------
kernel BUG at fs/f2fs/segment.c:1900!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 6527 Comm: syz.5.110 Not tainted syzkaller #0 PREEMPT_{RT,(full)}
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
RIP: 0010:f2fs_issue_discard_timeout+0x59b/0x5a0 fs/f2fs/segment.c:1900
Code: d9 80 e1 07 80 c1 03 38 c1 0f 8c d6 fe ff ff 48 89 df e8 a8 5e fa fd e9 c9 fe ff ff e8 4e 46 94 fd 90 0f 0b e8 46 46 94 fd 90 <0f> 0b 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3
RSP: 0018:ffffc9000494f940 EFLAGS: 00010283
RAX: ffffffff843009ca RBX: 0000000000000001 RCX: 0000000000080000
RDX: ffffc9001ca78000 RSI: 00000000000029f3 RDI: 00000000000029f4
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed100893a431 R12: 1ffff1100893a430
R13: 1ffff1100c2b702c R14: dffffc0000000000 R15: ffff8880449d2160
FS:  00007ffa35fed6c0(0000) GS:ffff88812643d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2b68634000 CR3: 0000000039f62000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __f2fs_remount fs/f2fs/super.c:2960 [inline]
 f2fs_reconfigure+0x108a/0x1710 fs/f2fs/super.c:5443
 reconfigure_super+0x227/0x8a0 fs/super.c:1080
 do_remount fs/namespace.c:3391 [inline]
 path_mount+0xdc5/0x10e0 fs/namespace.c:4151
 do_mount fs/namespace.c:4172 [inline]
 __do_sys_mount fs/namespace.c:4361 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4338
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ffa37dbda0a

The root cause is there will be race condition in between f2fs_ioc_fitrim()
and f2fs_remount():

- f2fs_remount			- f2fs_ioc_fitrim
 - f2fs_issue_discard_timeout
  - __issue_discard_cmd
  - __drop_discard_cmd
  - __wait_all_discard_cmd
				 - f2fs_trim_fs
				  - f2fs_write_checkpoint
				   - f2fs_clear_prefree_segments
				    - f2fs_issue_discard
				     - __issue_discard_async
				      - __queue_discard_cmd
				       - __update_discard_tree_range
				        - __insert_discard_cmd
				         - __create_discard_cmd
				         : atomic_inc(&dcc->discard_cmd_cnt);
  - sanity check on dcc->discard_cmd_cnt (expect discard_cmd_cnt to be zero)

This will only happen when fitrim races w/ remount rw, if we remount to
readonly filesystem, remount will wait until mnt_pcp.mnt_writers to zero,
that means fitrim is not in process at that time.

Cc: stable@kernel.org
Fixes: 2482c4325dfe ("f2fs: detect bug_on in f2fs_wait_discard_bios")
Reported-by: syzbot+62538b67389ee582837a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/69b07d7c.050a0220.8df7.09a1.GAE@google.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h    |    2 +-
 fs/f2fs/segment.c |    6 +++---
 fs/f2fs/super.c   |   11 ++++++++---
 3 files changed, 12 insertions(+), 7 deletions(-)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3930,7 +3930,7 @@ bool f2fs_is_checkpointed_data(struct f2
 int f2fs_start_discard_thread(struct f2fs_sb_info *sbi);
 void f2fs_drop_discard_cmd(struct f2fs_sb_info *sbi);
 void f2fs_stop_discard_thread(struct f2fs_sb_info *sbi);
-bool f2fs_issue_discard_timeout(struct f2fs_sb_info *sbi);
+bool f2fs_issue_discard_timeout(struct f2fs_sb_info *sbi, bool need_check);
 void f2fs_clear_prefree_segments(struct f2fs_sb_info *sbi,
 					struct cp_control *cpc);
 void f2fs_dirty_to_prefree(struct f2fs_sb_info *sbi);
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1895,7 +1895,7 @@ void f2fs_stop_discard_thread(struct f2f
  *
  * Return true if issued all discard cmd or no discard cmd need issue, otherwise return false.
  */
-bool f2fs_issue_discard_timeout(struct f2fs_sb_info *sbi)
+bool f2fs_issue_discard_timeout(struct f2fs_sb_info *sbi, bool need_check)
 {
 	struct discard_cmd_control *dcc = SM_I(sbi)->dcc_info;
 	struct discard_policy dpolicy;
@@ -1912,7 +1912,7 @@ bool f2fs_issue_discard_timeout(struct f
 	/* just to make sure there is no pending discard commands */
 	__wait_all_discard_cmd(sbi, NULL);
 
-	f2fs_bug_on(sbi, atomic_read(&dcc->discard_cmd_cnt));
+	f2fs_bug_on(sbi, need_check && atomic_read(&dcc->discard_cmd_cnt));
 	return !dropped;
 }
 
@@ -2382,7 +2382,7 @@ static void destroy_discard_cmd_control(
 	 * Recovery can cache discard commands, so in error path of
 	 * fill_super(), it needs to give a chance to handle them.
 	 */
-	f2fs_issue_discard_timeout(sbi);
+	f2fs_issue_discard_timeout(sbi, true);
 
 	kfree(dcc);
 	SM_I(sbi)->dcc_info = NULL;
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1961,7 +1961,7 @@ static void f2fs_put_super(struct super_
 	}
 
 	/* be sure to wait for any on-going discard commands */
-	done = f2fs_issue_discard_timeout(sbi);
+	done = f2fs_issue_discard_timeout(sbi, true);
 	if (f2fs_realtime_discard_enable(sbi) && !sbi->discard_blks && done) {
 		struct cp_control cpc = {
 			.reason = CP_UMOUNT | CP_TRIMMED,
@@ -2104,7 +2104,7 @@ static int f2fs_unfreeze(struct super_bl
 	 * will recover after removal of snapshot.
 	 */
 	if (test_opt(sbi, DISCARD) && !f2fs_hw_support_discard(sbi))
-		f2fs_issue_discard_timeout(sbi);
+		f2fs_issue_discard_timeout(sbi, true);
 
 	clear_sbi_flag(F2FS_SB(sb), SBI_IS_FREEZING);
 	return 0;
@@ -2884,7 +2884,12 @@ static int __f2fs_remount(struct fs_cont
 			need_stop_discard = true;
 		} else {
 			f2fs_stop_discard_thread(sbi);
-			f2fs_issue_discard_timeout(sbi);
+			/*
+			 * f2fs_ioc_fitrim() won't race w/ "remount ro"
+			 * so it's safe to check discard_cmd_cnt in
+			 * f2fs_issue_discard_timeout().
+			 */
+			f2fs_issue_discard_timeout(sbi, flags & SB_RDONLY);
 			need_restart_discard = true;
 		}
 	}


