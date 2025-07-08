Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC4623D2AB;
	Tue,  8 Jul 2025 16:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993359; cv=none; b=UQiYosdZPeyL7xD7epX+TQ42o/3rFir/hDu/vapVZw1vR+J9WFWLFAP46ofn5hAGDicZEU7+9KVl4PS0YTlzfIpSC8+wxeqJvyvfiYU1+6XQQmbsVhxTGttOVQPY3EhbGf+uu1d+1rwBKbE/R3rxR10hLkzn26Mhvuk1As21S5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993359; c=relaxed/simple;
	bh=nq5Ruco36RDV9rS4zsjdoG7PJBrdwnjksyAHaK1Xz48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXLXHxGieySSTLMq0V8uudPC7g8/GSYBWVXQXrlom/DM1GgPkkdXqYeAgubXRAdCCbWePAw8+s6OHKNQfPDqrT9wAAb3IF1aNQRtZX9RspkEe1zFBIkGM0Gk8wpyy3tPr+NFLX/IyFLHBpt4SWmX2pLtg2pyHf6JzJNSWS7gTts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=acbrhyXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="acbrhyXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D205C4CEF5;
	Tue,  8 Jul 2025 16:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993358;
	bh=nq5Ruco36RDV9rS4zsjdoG7PJBrdwnjksyAHaK1Xz48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=acbrhyXiZRbqBlSYVYnkFkuruvU+Oz3Kh67qK8/u/iuF08hCmtpf8TRIgKxZk/d09
	 pAoMR2hVRc2F3/rgKYm8Ww2WFR0NOfZZH2xvi72tbUbMifb2fW5QowDB6kumi49lGu
	 +jJnqc+4z3Oy2iHOTLg6YXvwIsEYywb3RMTq0xb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a4cc4ac22daa4a71b87c@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 047/178] nfs: Clean up /proc/net/rpc/nfs when nfs_fs_proc_net_init() fails.
Date: Tue,  8 Jul 2025 18:21:24 +0200
Message-ID: <20250708162237.914839298@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit e8d6f3ab59468e230f3253efe5cb63efa35289f7 ]

syzbot reported a warning below [1] following a fault injection in
nfs_fs_proc_net_init(). [0]

When nfs_fs_proc_net_init() fails, /proc/net/rpc/nfs is not removed.

Later, rpc_proc_exit() tries to remove /proc/net/rpc, and the warning
is logged as the directory is not empty.

Let's handle the error of nfs_fs_proc_net_init() properly.

[0]:
FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 0
CPU: 1 UID: 0 PID: 6120 Comm: syz.2.27 Not tainted 6.16.0-rc1-syzkaller-00010-g2c4a1f3fe03e #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
  dump_stack_lvl (lib/dump_stack.c:123)
 should_fail_ex (lib/fault-inject.c:73 lib/fault-inject.c:174)
 should_failslab (mm/failslab.c:46)
 kmem_cache_alloc_noprof (mm/slub.c:4178 mm/slub.c:4204)
 __proc_create (fs/proc/generic.c:427)
 proc_create_reg (fs/proc/generic.c:554)
 proc_create_net_data (fs/proc/proc_net.c:120)
 nfs_fs_proc_net_init (fs/nfs/client.c:1409)
 nfs_net_init (fs/nfs/inode.c:2600)
 ops_init (net/core/net_namespace.c:138)
 setup_net (net/core/net_namespace.c:443)
 copy_net_ns (net/core/net_namespace.c:576)
 create_new_namespaces (kernel/nsproxy.c:110)
 unshare_nsproxy_namespaces (kernel/nsproxy.c:218 (discriminator 4))
 ksys_unshare (kernel/fork.c:3123)
 __x64_sys_unshare (kernel/fork.c:3190)
 do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
 </TASK>

[1]:
remove_proc_entry: removing non-empty directory 'net/rpc', leaking at least 'nfs'
 WARNING: CPU: 1 PID: 6120 at fs/proc/generic.c:727 remove_proc_entry+0x45e/0x530 fs/proc/generic.c:727
Modules linked in:
CPU: 1 UID: 0 PID: 6120 Comm: syz.2.27 Not tainted 6.16.0-rc1-syzkaller-00010-g2c4a1f3fe03e #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
 RIP: 0010:remove_proc_entry+0x45e/0x530 fs/proc/generic.c:727
Code: 3c 02 00 0f 85 85 00 00 00 48 8b 93 d8 00 00 00 4d 89 f0 4c 89 e9 48 c7 c6 40 ba a2 8b 48 c7 c7 60 b9 a2 8b e8 33 81 1d ff 90 <0f> 0b 90 90 e9 5f fe ff ff e8 04 69 5e ff 90 48 b8 00 00 00 00 00
RSP: 0018:ffffc90003637b08 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff88805f534140 RCX: ffffffff817a92c8
RDX: ffff88807da99e00 RSI: ffffffff817a92d5 RDI: 0000000000000001
RBP: ffff888033431ac0 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffff888033431a00
R13: ffff888033431ae4 R14: ffff888033184724 R15: dffffc0000000000
FS:  0000555580328500(0000) GS:ffff888124a62000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f71733743e0 CR3: 000000007f618000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
  sunrpc_exit_net+0x46/0x90 net/sunrpc/sunrpc_syms.c:76
  ops_exit_list net/core/net_namespace.c:200 [inline]
  ops_undo_list+0x2eb/0xab0 net/core/net_namespace.c:253
  setup_net+0x2e1/0x510 net/core/net_namespace.c:457
  copy_net_ns+0x2a6/0x5f0 net/core/net_namespace.c:574
  create_new_namespaces+0x3ea/0xa90 kernel/nsproxy.c:110
  unshare_nsproxy_namespaces+0xc0/0x1f0 kernel/nsproxy.c:218
  ksys_unshare+0x45b/0xa40 kernel/fork.c:3121
  __do_sys_unshare kernel/fork.c:3192 [inline]
  __se_sys_unshare kernel/fork.c:3190 [inline]
  __x64_sys_unshare+0x31/0x40 kernel/fork.c:3190
  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
  do_syscall_64+0xcd/0x490 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa1a6b8e929
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff3a090368 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 00007fa1a6db5fa0 RCX: 00007fa1a6b8e929
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000040000080
RBP: 00007fa1a6c10b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa1a6db5fa0 R14: 00007fa1a6db5fa0 R15: 0000000000000001
 </TASK>

Fixes: d47151b79e32 ("nfs: expose /proc/net/sunrpc/nfs in net namespaces")
Reported-by: syzbot+a4cc4ac22daa4a71b87c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a4cc4ac22daa4a71b87c
Tested-by: syzbot+a4cc4ac22daa4a71b87c@syzkaller.appspotmail.com
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 8ab7868807a7d..a2fa6bc4d74e3 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -2589,15 +2589,26 @@ EXPORT_SYMBOL_GPL(nfs_net_id);
 static int nfs_net_init(struct net *net)
 {
 	struct nfs_net *nn = net_generic(net, nfs_net_id);
+	int err;
 
 	nfs_clients_init(net);
 
 	if (!rpc_proc_register(net, &nn->rpcstats)) {
-		nfs_clients_exit(net);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto err_proc_rpc;
 	}
 
-	return nfs_fs_proc_net_init(net);
+	err = nfs_fs_proc_net_init(net);
+	if (err)
+		goto err_proc_nfs;
+
+	return 0;
+
+err_proc_nfs:
+	rpc_proc_unregister(net, "nfs");
+err_proc_rpc:
+	nfs_clients_exit(net);
+	return err;
 }
 
 static void nfs_net_exit(struct net *net)
-- 
2.39.5



