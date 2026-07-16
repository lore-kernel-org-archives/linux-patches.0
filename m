Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0020B3876DE;
	Thu, 16 Jul 2026 13:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210362; cv=none; b=Kwy+1370LbRigTTyR0bd+/3D5j/JnbqlA95cslU8bu07coCOKEBm+MmxDWY280QHGfrEjtsT/pQGJ4OTdOcmktYXaAh0gfUNFO38v0jJi4OLuxqwHZ3wuQ7cJa9SqAS7Jf11/c/Sa/4ZHQwGj7ZjT3dRGdOq0U/ij0W5DyrpLV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210362; c=relaxed/simple;
	bh=JBlqSDvjc+7QJYks8b8Hy2YTC+iCDaZgS9m33Yyi0KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AN0d6O/+CwVVcZRR/gkRr+qjsLuOH4IoKX4qbvU2ACBMZMEX574ewar79XFre/KlGn3jjSoQZAX/hwLTlW7mzotOf/9rqvYctUg/OSbVzbAIxzC8xdT8Yn/FV6y742wmmrXzNGdxJC7CpE6ZDnfX2Sbnmdd+XvFieNCT953zo9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MaXzcl6/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MaXzcl6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AF41F000E9;
	Thu, 16 Jul 2026 13:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210360;
	bh=wP44oUV7sfdtitMGooV0lIcqQPuZean35XIxlhi+vFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MaXzcl6/i7bqRCwHmC4f4TWIeFILVnfsoeoNpVNQ/ggJUZQKnzETXEGEWNBo2od+F
	 SSfQpfN21WAoMkomLL99t4H0/9MEy29x44qP/GkgCLulXsikG6FpA3XzzsxN9Kf+sQ
	 SrwZbHk0QiMcXZS8jy2FrZyT5WGH5Ar/5iIOd6fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+2488d8d751b27f7ce268@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 019/480] f2fs: fix to do sanity check on f2fs_get_node_folio_ra()
Date: Thu, 16 Jul 2026 15:26:06 +0200
Message-ID: <20260716133045.110319575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

[ Upstream commit 8712353ed80f87271d732297567dcdbe4b84e8c7 ]

kernel BUG at fs/f2fs/file.c:845!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5336 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:f2fs_do_truncate_blocks+0x1115/0x1140 fs/f2fs/file.c:845
Code: fc fc 90 0f 0b e8 8b 9d 9a fd 90 0f 0b e8 83 9d 9a fd 48 89 df 48 c7 c6 60 d1 1a 8c e8 54 f1 fc fc 90 0f 0b e8 6c 9d 9a fd 90 <0f> 0b e8 64 9d 9a fd 90 0f 0b 90 e9 93 fd ff ff e8 56 9d 9a fd 90
RSP: 0018:ffffc9000e4474c0 EFLAGS: 00010283
RAX: ffffffff842b1d34 RBX: 0000000000000003 RCX: 0000000000100000
RDX: ffffc9000f03a000 RSI: 0000000000035503 RDI: 0000000000035504
RBP: ffffc9000e447608 R08: ffff8880123b0000 R09: 0000000000000002
R10: 00000000fffffffe R11: 0000000000000002 R12: 0000000000000001
R13: 0000000000000000 R14: 1ffff92001c88ea0 R15: 00000000ffff039c
FS:  00007f7e02ee36c0(0000) GS:ffff88808c887000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff0305c4000 CR3: 0000000012d4c000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 f2fs_truncate_blocks+0x10a/0x300 fs/f2fs/file.c:882
 f2fs_truncate+0x471/0x7c0 fs/f2fs/file.c:940
 f2fs_evict_inode+0xa3f/0x1ac0 fs/f2fs/inode.c:907
 evict+0x61e/0xb10 fs/inode.c:841
 f2fs_fill_super+0x5f43/0x78f0 fs/f2fs/super.c:5224
 get_tree_bdev_flags+0x431/0x4f0 fs/super.c:1694
 vfs_get_tree+0x92/0x2a0 fs/super.c:1754
 fc_mount fs/namespace.c:1193 [inline]
 do_new_mount_fc fs/namespace.c:3758 [inline]
 do_new_mount+0x341/0xd30 fs/namespace.c:3834
 do_mount fs/namespace.c:4167 [inline]
 __do_sys_mount fs/namespace.c:4383 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4360
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

	count = ADDRS_PER_PAGE(dn.node_folio, inode);

	count -= dn.ofs_in_node;
	f2fs_bug_on(sbi, count < 0);

The fuzz test will trigger above bug_on in f2fs.

The root cause should be: in the corrupted inode, there is a direct node
which has the same ino and nid in its footer, so in f2fs_do_truncate_blocks(),
after f2fs_get_dnode_of_data() finds such dnode:
1) ADDRS_PER_PAGE(dn.node_folio, inode) will return 923
2) once dn.ofs_in_node points to addr[923, 1017]
Then it will trigger the system panic.

Let's introduce NODE_TYPE_NON_IXNODE to indicate current node should
not be an inode or xattr node, and then use it in below path to detect
inconsistent node chain in inode mapping table:

- f2fs_do_truncate_blocks
 - f2fs_get_dnode_of_data
  - f2fs_get_node_folio_ra
   -  __get_node_folio
    - f2fs_sanity_check_node_footer
     - case NODE_TYPE_NON_IXNODE -> check whether it is inode|xnode

Cc: stable@kernel.org
Reported-by: syzbot+2488d8d751b27f7ce268@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69fa3697.170a0220.59368.0018.GAE@google.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h |    1 +
 fs/f2fs/node.c |    6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1533,6 +1533,7 @@ enum node_type {
 	NODE_TYPE_INODE,
 	NODE_TYPE_XATTR,
 	NODE_TYPE_NON_INODE,
+	NODE_TYPE_NON_IXNODE,	/* non inode and xnode */
 };
 
 
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1529,6 +1529,10 @@ int f2fs_sanity_check_node_footer(struct
 		if (is_inode)
 			goto out_err;
 		break;
+	case NODE_TYPE_NON_IXNODE:
+		if (is_inode || is_xnode)
+			goto out_err;
+		break;
 	default:
 		break;
 	}
@@ -1622,7 +1626,7 @@ static struct folio *f2fs_get_node_folio
 	struct f2fs_sb_info *sbi = F2FS_F_SB(parent);
 	nid_t nid = get_nid(parent, start, false);
 
-	return __get_node_folio(sbi, nid, parent, start, NODE_TYPE_REGULAR);
+	return __get_node_folio(sbi, nid, parent, start, NODE_TYPE_NON_IXNODE);
 }
 
 static void flush_inline_data(struct f2fs_sb_info *sbi, nid_t ino)


