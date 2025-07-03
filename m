Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827A522333B;
	Thu,  3 Jul 2025 15:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556135; cv=none; b=HhxM2WnOxb4x5N0nT7m/CHOVecLR9Zzg83iQaCVss2z/mdD0uOZnkBlCoth3S6UuP5K6V7IClMjHNlyjhYbgP9la6riLCw8IIC3blI9n4Q4Y5WwVbosJC0FZzMvaI4nXewLpYv2p6XaF5zHiQk3m/Xz5ky26QVODNTtG2kuU//A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556135; c=relaxed/simple;
	bh=9MUg5TBZdFtEl2kkEMk6/d8C25MFRtoN5eQBIb4qOlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOK1BctWm38HVYrQOuupOsAcm9mrtm834yegGv/0j/pwGOghVkC7shrJEBC52NuVLUTpAnmQFQbwbwRgeOcHP18hLomG1/uuKixfJBjWc9H+d1Z3qI0YEfNbBr7FLG8jcl5A5rTwJM9K7ryV772kFqUU1/ZKpEK0xLO2ri+jcpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ToUnPMhB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ToUnPMhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1540C4CEE3;
	Thu,  3 Jul 2025 15:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556135;
	bh=9MUg5TBZdFtEl2kkEMk6/d8C25MFRtoN5eQBIb4qOlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ToUnPMhBQOSzNxQt6mCp6w8sEgSE/+SOu56N6IuULFXUZEd/BPNQdeR7Als+N3szn
	 8MkFoztSyat5g0PS//nD9/1gux3Nb/dxCRtyBl0e7LgcAUNFBa7WSImAiUwBEy+nnz
	 nK+uoF2oBHnnzbj7JtWCg8/o5U4lz6OpDOzUVk8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8bd335d2ad3b93e80715@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/132] atm: Release atm_dev_mutex after removing procfs in atm_dev_deregister().
Date: Thu,  3 Jul 2025 16:42:54 +0200
Message-ID: <20250703143942.742198739@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit a433791aeaea6e84df709e0b9584b9bbe040cd1c ]

syzbot reported a warning below during atm_dev_register(). [0]

Before creating a new device and procfs/sysfs for it, atm_dev_register()
looks up a duplicated device by __atm_dev_lookup().  These operations are
done under atm_dev_mutex.

However, when removing a device in atm_dev_deregister(), it releases the
mutex just after removing the device from the list that __atm_dev_lookup()
iterates over.

So, there will be a small race window where the device does not exist on
the device list but procfs/sysfs are still not removed, triggering the
splat.

Let's hold the mutex until procfs/sysfs are removed in
atm_dev_deregister().

[0]:
proc_dir_entry 'atm/atmtcp:0' already registered
WARNING: CPU: 0 PID: 5919 at fs/proc/generic.c:377 proc_register+0x455/0x5f0 fs/proc/generic.c:377
Modules linked in:
CPU: 0 UID: 0 PID: 5919 Comm: syz-executor284 Not tainted 6.16.0-rc2-syzkaller-00047-g52da431bf03b #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:proc_register+0x455/0x5f0 fs/proc/generic.c:377
Code: 48 89 f9 48 c1 e9 03 80 3c 01 00 0f 85 a2 01 00 00 48 8b 44 24 10 48 c7 c7 20 c0 c2 8b 48 8b b0 d8 00 00 00 e8 0c 02 1c ff 90 <0f> 0b 90 90 48 c7 c7 80 f2 82 8e e8 0b de 23 09 48 8b 4c 24 28 48
RSP: 0018:ffffc9000466fa30 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff817ae248
RDX: ffff888026280000 RSI: ffffffff817ae255 RDI: 0000000000000001
RBP: ffff8880232bed48 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff888076ed2140
R13: dffffc0000000000 R14: ffff888078a61340 R15: ffffed100edda444
FS:  00007f38b3b0c6c0(0000) GS:ffff888124753000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f38b3bdf953 CR3: 0000000076d58000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 proc_create_data+0xbe/0x110 fs/proc/generic.c:585
 atm_proc_dev_register+0x112/0x1e0 net/atm/proc.c:361
 atm_dev_register+0x46d/0x890 net/atm/resources.c:113
 atmtcp_create+0x77/0x210 drivers/atm/atmtcp.c:369
 atmtcp_attach drivers/atm/atmtcp.c:403 [inline]
 atmtcp_ioctl+0x2f9/0xd60 drivers/atm/atmtcp.c:464
 do_vcc_ioctl+0x12c/0x930 net/atm/ioctl.c:159
 sock_do_ioctl+0x115/0x280 net/socket.c:1190
 sock_ioctl+0x227/0x6b0 net/socket.c:1311
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl fs/ioctl.c:893 [inline]
 __x64_sys_ioctl+0x18b/0x210 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f38b3b74459
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 51 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f38b3b0c198 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f38b3bfe318 RCX: 00007f38b3b74459
RDX: 0000000000000000 RSI: 0000000000006180 RDI: 0000000000000005
RBP: 00007f38b3bfe310 R08: 65732f636f72702f R09: 65732f636f72702f
R10: 65732f636f72702f R11: 0000000000000246 R12: 00007f38b3bcb0ac
R13: 00007f38b3b0c1a0 R14: 0000200000000200 R15: 00007f38b3bcb03b
 </TASK>

Fixes: 64bf69ddff76 ("[ATM]: deregistration removes device from atm_devs list immediately")
Reported-by: syzbot+8bd335d2ad3b93e80715@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/685316de.050a0220.216029.0087.GAE@google.com/
Tested-by: syzbot+8bd335d2ad3b93e80715@syzkaller.appspotmail.com
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250624214505.570679-1-kuni1840@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/resources.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/atm/resources.c b/net/atm/resources.c
index 995d29e7fb138..b19d851e1f443 100644
--- a/net/atm/resources.c
+++ b/net/atm/resources.c
@@ -146,11 +146,10 @@ void atm_dev_deregister(struct atm_dev *dev)
 	 */
 	mutex_lock(&atm_dev_mutex);
 	list_del(&dev->dev_list);
-	mutex_unlock(&atm_dev_mutex);
-
 	atm_dev_release_vccs(dev);
 	atm_unregister_sysfs(dev);
 	atm_proc_dev_deregister(dev);
+	mutex_unlock(&atm_dev_mutex);
 
 	atm_dev_put(dev);
 }
-- 
2.39.5



