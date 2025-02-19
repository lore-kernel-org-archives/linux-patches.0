Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A54E1805B;
	Wed, 19 Feb 2025 09:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956295; cv=none; b=LQ9PygXGFVBgXMF8OqPm07mTYSdgFJK5NjpWZswbN/U0NdympBfRHV2KuMMekPub1sKLvi9tYiCrXShR020aWvKAWcFABXywr/Pd3Mk1udGmQ35+Cu3S3D05U87deowRbsHw707pA4XAkXJOsEbfq5odm96lQc+3YQtFyPTLW1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956295; c=relaxed/simple;
	bh=bZHxTfEcwQNcYCUb6FNOerbq+HgzSSt0AbDof5AaanQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nc+MxzfyXGQ7UOvQXO1FMkTRkbcuF+0z1Ng+rUe3eJNA0LjaKYgbTW0B+lj0GTj4MKiT3BUcJqPdLf5Yelxt9LELrmVdBDnKpYzR3HezOBdI8Uxyjla1Ma+NgeHXw9BTIMGCxRItfaccc8F4TQeQeUXKtA0vI2SQIqQtWWvy984=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Uae3E4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Uae3E4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F564C4CED1;
	Wed, 19 Feb 2025 09:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956295;
	bh=bZHxTfEcwQNcYCUb6FNOerbq+HgzSSt0AbDof5AaanQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Uae3E4dnbuc1ghW1Tt2ANnXhPSYaMIWcmA7qlWOSy/ZGhhv2Qfj6jGNpfotQ3/Wu
	 hpWNnQOyoPv28Vw4YlYp5t7j7JZV6d2XEfY3Hc7j2QGEEqgePQh0ZnKsdhh4isCU3l
	 aQM1082fnr/xqx/DSZ/USBpEa7XJtj02G1HqhtS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Frank Sorenson <sorenson@redhat.com>,
	Jay Shin <jaeshin@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/578] smb: client: fix oops due to unset link speed
Date: Wed, 19 Feb 2025 09:22:15 +0100
Message-ID: <20250219082658.139568916@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit be7a6a77669588bfa5022a470989702bbbb11e7f ]

It isn't guaranteed that NETWORK_INTERFACE_INFO::LinkSpeed will always
be set by the server, so the client must handle any values and then
prevent oopses like below from happening:

Oops: divide error: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 1323 Comm: cat Not tainted 6.13.0-rc7 #2
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-3.fc41
04/01/2014
RIP: 0010:cifs_debug_data_proc_show+0xa45/0x1460 [cifs] Code: 00 00 48
89 df e8 3b cd 1b c1 41 f6 44 24 2c 04 0f 84 50 01 00 00 48 89 ef e8
e7 d0 1b c1 49 8b 44 24 18 31 d2 49 8d 7c 24 28 <48> f7 74 24 18 48 89
c3 e8 6e cf 1b c1 41 8b 6c 24 28 49 8d 7c 24
RSP: 0018:ffffc90001817be0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88811230022c RCX: ffffffffc041bd99
RDX: 0000000000000000 RSI: 0000000000000567 RDI: ffff888112300228
RBP: ffff888112300218 R08: fffff52000302f5f R09: ffffed1022fa58ac
R10: ffff888117d2c566 R11: 00000000fffffffe R12: ffff888112300200
R13: 000000012a15343f R14: 0000000000000001 R15: ffff888113f2db58
FS: 00007fe27119e740(0000) GS:ffff888148600000(0000)
knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe2633c5000 CR3: 0000000124da0000 CR4: 0000000000750ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? __die_body.cold+0x19/0x27
 ? die+0x2e/0x50
 ? do_trap+0x159/0x1b0
 ? cifs_debug_data_proc_show+0xa45/0x1460 [cifs]
 ? do_error_trap+0x90/0x130
 ? cifs_debug_data_proc_show+0xa45/0x1460 [cifs]
 ? exc_divide_error+0x39/0x50
 ? cifs_debug_data_proc_show+0xa45/0x1460 [cifs]
 ? asm_exc_divide_error+0x1a/0x20
 ? cifs_debug_data_proc_show+0xa39/0x1460 [cifs]
 ? cifs_debug_data_proc_show+0xa45/0x1460 [cifs]
 ? seq_read_iter+0x42e/0x790
 seq_read_iter+0x19a/0x790
 proc_reg_read_iter+0xbe/0x110
 ? __pfx_proc_reg_read_iter+0x10/0x10
 vfs_read+0x469/0x570
 ? do_user_addr_fault+0x398/0x760
 ? __pfx_vfs_read+0x10/0x10
 ? find_held_lock+0x8a/0xa0
 ? __pfx_lock_release+0x10/0x10
 ksys_read+0xd3/0x170
 ? __pfx_ksys_read+0x10/0x10
 ? __rcu_read_unlock+0x50/0x270
 ? mark_held_locks+0x1a/0x90
 do_syscall_64+0xbb/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe271288911
Code: 00 48 8b 15 01 25 10 00 f7 d8 64 89 02 b8 ff ff ff ff eb bd e8
20 ad 01 00 f3 0f 1e fa 80 3d b5 a7 10 00 00 74 13 31 c0 0f 05 <48> 3d
00 f0 ff ff 77 4f c3 66 0f 1f 44 00 00 55 48 89 e5 48 83 ec
RSP: 002b:00007ffe87c079d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000000000040000 RCX: 00007fe271288911
RDX: 0000000000040000 RSI: 00007fe2633c6000 RDI: 0000000000000003
RBP: 00007ffe87c07a00 R08: 0000000000000000 R09: 00007fe2713e6380
R10: 0000000000000022 R11: 0000000000000246 R12: 0000000000040000
R13: 00007fe2633c6000 R14: 0000000000000003 R15: 0000000000000000
 </TASK>

Fix this by setting cifs_server_iface::speed to a sane value (1Gbps)
by default when link speed is unset.

Cc: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Fixes: a6d8fb54a515 ("cifs: distribute channels across interfaces based on speed")
Reported-by: Frank Sorenson <sorenson@redhat.com>
Reported-by: Jay Shin <jaeshin@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 4b9cd9893ac61..e368b10a9034d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -615,7 +615,8 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 
 	while (bytes_left >= (ssize_t)sizeof(*p)) {
 		memset(&tmp_iface, 0, sizeof(tmp_iface));
-		tmp_iface.speed = le64_to_cpu(p->LinkSpeed);
+		/* default to 1Gbps when link speed is unset */
+		tmp_iface.speed = le64_to_cpu(p->LinkSpeed) ?: 1000000000;
 		tmp_iface.rdma_capable = le32_to_cpu(p->Capability & RDMA_CAPABLE) ? 1 : 0;
 		tmp_iface.rss_capable = le32_to_cpu(p->Capability & RSS_CAPABLE) ? 1 : 0;
 
-- 
2.39.5



