Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D80B54903;
	Tue, 14 May 2024 11:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686958; cv=none; b=L8FfqAEdjqyI0MQ4/dcenNEeWbSfMe7fw+++NIEoIKVbogLQGCidIaiJTzTH3UK15LWcCEFCXLT3IGxF+3/HxtBAXwqSZTFvetRVz4Hxub4FuzHS+s0hRKCNQrDDNs+WGASLGfWTOpleAwfpThWHa+GAGXjPZKJ8tZ4htRpAGCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686958; c=relaxed/simple;
	bh=9z2oK8QvAwVi6eZ1uIxV+BOhxe13hh8a6x5By0U7oCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvXDwL+KsJ+GyBtfr5P8c9FcwwltMOpjL+bztw2F1GtxUUR/QsFvnWET047uZxbP0KnISfaCJ4LjqGFCzg1Y2ZlGDwwfve2N9hRZYhVK1Xpg1oH1SaDtqpXby0QZkwJ0k8iNDEqxwxC5cgfXNeel0m9yILo4H4OKHK1Sak/NvW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8VofKh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8VofKh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C19C2BD10;
	Tue, 14 May 2024 11:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686958;
	bh=9z2oK8QvAwVi6eZ1uIxV+BOhxe13hh8a6x5By0U7oCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8VofKh8UwOCZR8ewM731n2c60Algkn6HSgUM2PQ2Oa4D0v/49kVsSYEhXgqgjLsy
	 aW6t9Hc3nrFld/eUphC8x7NjVOcMteLDv/FaPQyPnk00HNg043gjNBnv7WNjhm+p+o
	 AdbYrMbUsbHeZT9oxv+iojvv7V0HZ6RMusGxdfHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/84] nfs: Handle error of rpc_proc_register() in nfs_net_init().
Date: Tue, 14 May 2024 12:19:28 +0200
Message-ID: <20240514100952.341633419@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 24457f1be29f1e7042e50a7749f5c2dde8c433c8 ]

syzkaller reported a warning [0] triggered while destroying immature
netns.

rpc_proc_register() was called in init_nfs_fs(), but its error
has been ignored since at least the initial commit 1da177e4c3f4
("Linux-2.6.12-rc2").

Recently, commit d47151b79e32 ("nfs: expose /proc/net/sunrpc/nfs
in net namespaces") converted the procfs to per-netns and made
the problem more visible.

Even when rpc_proc_register() fails, nfs_net_init() could succeed,
and thus nfs_net_exit() will be called while destroying the netns.

Then, remove_proc_entry() will be called for non-existing proc
directory and trigger the warning below.

Let's handle the error of rpc_proc_register() properly in nfs_net_init().

[0]:
name 'nfs'
WARNING: CPU: 1 PID: 1710 at fs/proc/generic.c:711 remove_proc_entry+0x1bb/0x2d0 fs/proc/generic.c:711
Modules linked in:
CPU: 1 PID: 1710 Comm: syz-executor.2 Not tainted 6.8.0-12822-gcd51db110a7e #12
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
RIP: 0010:remove_proc_entry+0x1bb/0x2d0 fs/proc/generic.c:711
Code: 41 5d 41 5e c3 e8 85 09 b5 ff 48 c7 c7 88 58 64 86 e8 09 0e 71 02 e8 74 09 b5 ff 4c 89 e6 48 c7 c7 de 1b 80 84 e8 c5 ad 97 ff <0f> 0b eb b1 e8 5c 09 b5 ff 48 c7 c7 88 58 64 86 e8 e0 0d 71 02 eb
RSP: 0018:ffffc9000c6d7ce0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff8880422b8b00 RCX: ffffffff8110503c
RDX: ffff888030652f00 RSI: ffffffff81105045 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: ffffffff81bb62cb R12: ffffffff84807ffc
R13: ffff88804ad6fcc0 R14: ffffffff84807ffc R15: ffffffff85741ff8
FS:  00007f30cfba8640(0000) GS:ffff88807dd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff51afe8000 CR3: 000000005a60a005 CR4: 0000000000770ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 rpc_proc_unregister+0x64/0x70 net/sunrpc/stats.c:310
 nfs_net_exit+0x1c/0x30 fs/nfs/inode.c:2438
 ops_exit_list+0x62/0xb0 net/core/net_namespace.c:170
 setup_net+0x46c/0x660 net/core/net_namespace.c:372
 copy_net_ns+0x244/0x590 net/core/net_namespace.c:505
 create_new_namespaces+0x2ed/0x770 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xae/0x160 kernel/nsproxy.c:228
 ksys_unshare+0x342/0x760 kernel/fork.c:3322
 __do_sys_unshare kernel/fork.c:3393 [inline]
 __se_sys_unshare kernel/fork.c:3391 [inline]
 __x64_sys_unshare+0x1f/0x30 kernel/fork.c:3391
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x4f/0x110 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x46/0x4e
RIP: 0033:0x7f30d0febe5d
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 73 9f 1b 00 f7 d8 64 89 01 48
RSP: 002b:00007f30cfba7cc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 00000000004bbf80 RCX: 00007f30d0febe5d
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000006c020600
RBP: 00000000004bbf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 000000000000000b R14: 00007f30d104c530 R15: 0000000000000000
 </TASK>

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 96468ee4406fa..6a7a3b1d926ea 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -2181,7 +2181,12 @@ static int nfs_net_init(struct net *net)
 	struct nfs_net *nn = net_generic(net, nfs_net_id);
 
 	nfs_clients_init(net);
-	rpc_proc_register(net, &nn->rpcstats);
+
+	if (!rpc_proc_register(net, &nn->rpcstats)) {
+		nfs_clients_exit(net);
+		return -ENOMEM;
+	}
+
 	return nfs_fs_proc_net_init(net);
 }
 
-- 
2.43.0



