Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D41F5BAD4;
	Tue, 23 Jan 2024 01:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974357; cv=none; b=ELtWSfS0f/NYfFohlNhL1xt5OluMJIvqNsAJKCpwdvcLpGr6KxuOaUnMgW1qG2+cQQJ7GPu506F9dQU8+1jLcJXmi2WQQRpRvC29Q4BYm+PPQ4o+Y9ruKmvZVvcGd8ntV9V3ro2TcSzQi8WJcCgiCGrDcqfgLewg9ihOhciEe/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974357; c=relaxed/simple;
	bh=lZAfmNQ2jgktDSUAp5l+kN8NSS3qcJfGGKyzMFhmvp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsZset/pajSn0gJbl5cG0QHLhsm43aPUVFqqftN+u8+HdpCAo5iqrShcVzLzpbvVlPBfu/n95SHs8U7+ygQAMsinV8lAZAHL5R89wLxv6BrDznOeIvlWvymS9tRroQjcLebb2qkLDXJBV4jd0WlXWBEPDqihac1Zu3zUAT9oVCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9UYyQAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9UYyQAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FACDC433C7;
	Tue, 23 Jan 2024 01:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974357;
	bh=lZAfmNQ2jgktDSUAp5l+kN8NSS3qcJfGGKyzMFhmvp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9UYyQALapaPAeGpWkSoRS4Klhb0WBkAYgzwHvpCBWk3w62450x5KyG7a3NnbC2gd
	 TewOaDbWeqnLtS6CPzu8igGSgsCXlTOIX1RCEQ00pKmSnC5eBjk3Xf+pTPURJlf4KX
	 Q57x5ShwNbewh86JiJNaruKhNwMEbc07RpRZmacg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+3b6e67ac2b646da57862@syzkaller.appspotmail.com
Subject: [PATCH 6.6 064/583] gfs2: fix kernel BUG in gfs2_quota_cleanup
Date: Mon, 22 Jan 2024 15:51:55 -0800
Message-ID: <20240122235814.095301954@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 71733b4922007500ae259af9e96017080f5d36d9 ]

[Syz report]
kernel BUG at fs/gfs2/quota.c:1508!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 5060 Comm: syz-executor505 Not tainted 6.7.0-rc3-syzkaller-00134-g994d5c58e50e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/10/2023
RIP: 0010:gfs2_quota_cleanup+0x6b5/0x6c0 fs/gfs2/quota.c:1508
Code: fe e9 cf fd ff ff 44 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 2d fe ff ff 4c 89 ef e8 b6 19 23 fe e9 20 fe ff ff e8 ec 11 c7 fd 90 <0f> 0b e8 84 9c 4f 07 0f 1f 40 00 66 0f 1f 00 55 41 57 41 56 41 54
RSP: 0018:ffffc9000409f9e0 EFLAGS: 00010293
RAX: ffffffff83c76854 RBX: 0000000000000002 RCX: ffff888026001dc0
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
RBP: ffffc9000409fb00 R08: ffffffff83c762b0 R09: 1ffff1100fd38015
R10: dffffc0000000000 R11: ffffed100fd38016 R12: dffffc0000000000
R13: ffff88807e9c0828 R14: ffff888014693580 R15: ffff88807e9c0000
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f16d1bd70f8 CR3: 0000000027199000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 gfs2_put_super+0x2e1/0x940 fs/gfs2/super.c:611
 generic_shutdown_super+0x13a/0x2c0 fs/super.c:696
 kill_block_super+0x44/0x90 fs/super.c:1667
 deactivate_locked_super+0xc1/0x130 fs/super.c:484
 cleanup_mnt+0x426/0x4c0 fs/namespace.c:1256
 task_work_run+0x24a/0x300 kernel/task_work.c:180
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xa34/0x2750 kernel/exit.c:871
 do_group_exit+0x206/0x2c0 kernel/exit.c:1021
 __do_sys_exit_group kernel/exit.c:1032 [inline]
 __se_sys_exit_group kernel/exit.c:1030 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1030
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x45/0x110 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0x6b
...

[pid  5060] fsconfig(4, FSCONFIG_CMD_RECONFIGURE, NULL, NULL, 0) = 0
[pid  5060] exit_group(1)               = ?
...

[Analysis]
When the task exits, it will execute cleanup_mnt() to recycle the mounted gfs2
file system, but it performs a system call fsconfig(4, FSCONFIG_CMD_RECONFIGURE,
NULL, NULL, 0) before executing the task exit operation.

This will execute the following kernel path to complete the setting of
SDF_JOURNAL_LIVE for sd_flags:

SYSCALL_DEFINE5(fsconfig, ..)->
	vfs_fsconfig_locked()->
		vfs_cmd_reconfigure()->
			gfs2_reconfigure()->
				gfs2_make_fs_rw()->
					set_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);

[Fix]
Add SDF_NORECOVERY check in gfs2_quota_cleanup() to avoid checking
SDF_JOURNAL_LIVE on the path where gfs2 is being unmounted.

Reported-and-tested-by: syzbot+3b6e67ac2b646da57862@syzkaller.appspotmail.com
Fixes: f66af88e3321 ("gfs2: Stop using gfs2_make_fs_ro for withdraw")
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/quota.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 41d0232532a0..f689847bab40 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1493,7 +1493,8 @@ void gfs2_quota_cleanup(struct gfs2_sbd *sdp)
 	LIST_HEAD(dispose);
 	int count;
 
-	BUG_ON(test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags));
+	BUG_ON(!test_bit(SDF_NORECOVERY, &sdp->sd_flags) &&
+		test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags));
 
 	spin_lock(&qd_lock);
 	list_for_each_entry(qd, &sdp->sd_quota_list, qd_list) {
-- 
2.43.0



