Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB09D2571AE;
	Thu, 17 Apr 2025 18:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914171; cv=none; b=KVr6GE1AVATgezlYw7u/8Ust6bJP+V9BeEMZcPXGF+sUh+cqQHCFN+Kb9MBm5DnhXsIPrUACJUmZ9YUzINU2Jp+JBoftZLznXQmD4+lvXEZ/AZqNUbjykcvA4ZgcrDpnuPxyJyE0212oat02dBnpCjtrxa7jhmJbOmH59KqH8UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914171; c=relaxed/simple;
	bh=NMMYGROC/H/WA75cl//aTGiEC7nrceGBlUbIvw0pyoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odI/vFEiAt16nR5YKyi5QGpnjIRrWfwWvjmwYE2SH1bYZvuPIMj0Ez+9C9qyOodfIT3HIxj59qBJx34ENZU0kZUHofg2DANGfGvPbiS5e7dX5bNVaR2mAxj270TIcSk5VtqLk+ec1ElXFSWbKxAoiF1ERE0nomF4qFgkW5YbzMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3wAbyOT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3wAbyOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF18C4CEE4;
	Thu, 17 Apr 2025 18:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914171;
	bh=NMMYGROC/H/WA75cl//aTGiEC7nrceGBlUbIvw0pyoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3wAbyOTpXM/EIS7JC2XElu1bMzZ+0TTO/w5FPGcgxl3gB2ZxHH2rhyMb8WEW54I+
	 XORZw4kszRYDdg+qUNMk0kni1X6f+ORQ91ZTWEmu1jDB79diMwtpEGrCqTWrW19ZI7
	 T8L99/mc9YtUF918ppvEHw3lbNAQ+ZlTU/d840SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b244bda78289b00204ed@syzkaller.appspotmail.com,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Bhupesh <bhupesh@igalia.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 112/414] ext4: ignore xattrs past end
Date: Thu, 17 Apr 2025 19:47:50 +0200
Message-ID: <20250417175115.943158269@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bhupesh <bhupesh@igalia.com>

[ Upstream commit c8e008b60492cf6fd31ef127aea6d02fd3d314cd ]

Once inside 'ext4_xattr_inode_dec_ref_all' we should
ignore xattrs entries past the 'end' entry.

This fixes the following KASAN reported issue:

==================================================================
BUG: KASAN: slab-use-after-free in ext4_xattr_inode_dec_ref_all+0xb8c/0xe90
Read of size 4 at addr ffff888012c120c4 by task repro/2065

CPU: 1 UID: 0 PID: 2065 Comm: repro Not tainted 6.13.0-rc2+ #11
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x1fd/0x300
 ? tcp_gro_dev_warn+0x260/0x260
 ? _printk+0xc0/0x100
 ? read_lock_is_recursive+0x10/0x10
 ? irq_work_queue+0x72/0xf0
 ? __virt_addr_valid+0x17b/0x4b0
 print_address_description+0x78/0x390
 print_report+0x107/0x1f0
 ? __virt_addr_valid+0x17b/0x4b0
 ? __virt_addr_valid+0x3ff/0x4b0
 ? __phys_addr+0xb5/0x160
 ? ext4_xattr_inode_dec_ref_all+0xb8c/0xe90
 kasan_report+0xcc/0x100
 ? ext4_xattr_inode_dec_ref_all+0xb8c/0xe90
 ext4_xattr_inode_dec_ref_all+0xb8c/0xe90
 ? ext4_xattr_delete_inode+0xd30/0xd30
 ? __ext4_journal_ensure_credits+0x5f0/0x5f0
 ? __ext4_journal_ensure_credits+0x2b/0x5f0
 ? inode_update_timestamps+0x410/0x410
 ext4_xattr_delete_inode+0xb64/0xd30
 ? ext4_truncate+0xb70/0xdc0
 ? ext4_expand_extra_isize_ea+0x1d20/0x1d20
 ? __ext4_mark_inode_dirty+0x670/0x670
 ? ext4_journal_check_start+0x16f/0x240
 ? ext4_inode_is_fast_symlink+0x2f2/0x3a0
 ext4_evict_inode+0xc8c/0xff0
 ? ext4_inode_is_fast_symlink+0x3a0/0x3a0
 ? do_raw_spin_unlock+0x53/0x8a0
 ? ext4_inode_is_fast_symlink+0x3a0/0x3a0
 evict+0x4ac/0x950
 ? proc_nr_inodes+0x310/0x310
 ? trace_ext4_drop_inode+0xa2/0x220
 ? _raw_spin_unlock+0x1a/0x30
 ? iput+0x4cb/0x7e0
 do_unlinkat+0x495/0x7c0
 ? try_break_deleg+0x120/0x120
 ? 0xffffffff81000000
 ? __check_object_size+0x15a/0x210
 ? strncpy_from_user+0x13e/0x250
 ? getname_flags+0x1dc/0x530
 __x64_sys_unlinkat+0xc8/0xf0
 do_syscall_64+0x65/0x110
 entry_SYSCALL_64_after_hwframe+0x67/0x6f
RIP: 0033:0x434ffd
Code: 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 8
RSP: 002b:00007ffc50fa7b28 EFLAGS: 00000246 ORIG_RAX: 0000000000000107
RAX: ffffffffffffffda RBX: 00007ffc50fa7e18 RCX: 0000000000434ffd
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000005
RBP: 00007ffc50fa7be0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffc50fa7e08 R14: 00000000004bbf30 R15: 0000000000000001
 </TASK>

The buggy address belongs to the object at ffff888012c12000
 which belongs to the cache filp of size 360
The buggy address is located 196 bytes inside of
 freed 360-byte region [ffff888012c12000, ffff888012c12168)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x12c12
head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x40(head|node=0|zone=0)
page_type: f5(slab)
raw: 0000000000000040 ffff888000ad7640 ffffea0000497a00 dead000000000004
raw: 0000000000000000 0000000000100010 00000001f5000000 0000000000000000
head: 0000000000000040 ffff888000ad7640 ffffea0000497a00 dead000000000004
head: 0000000000000000 0000000000100010 00000001f5000000 0000000000000000
head: 0000000000000001 ffffea00004b0481 ffffffffffffffff 0000000000000000
head: 0000000000000002 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888012c11f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888012c12000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff888012c12080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff888012c12100: fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc
 ffff888012c12180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

Reported-by: syzbot+b244bda78289b00204ed@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b244bda78289b00204ed
Suggested-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Bhupesh <bhupesh@igalia.com>
Link: https://patch.msgid.link/20250128082751.124948-2-bhupesh@igalia.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 7647e9f6e1903..6ff94cdf1515c 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1176,15 +1176,24 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 {
 	struct inode *ea_inode;
 	struct ext4_xattr_entry *entry;
+	struct ext4_iloc iloc;
 	bool dirty = false;
 	unsigned int ea_ino;
 	int err;
 	int credits;
+	void *end;
+
+	if (block_csum)
+		end = (void *)bh->b_data + bh->b_size;
+	else {
+		ext4_get_inode_loc(parent, &iloc);
+		end = (void *)ext4_raw_inode(&iloc) + EXT4_SB(parent->i_sb)->s_inode_size;
+	}
 
 	/* One credit for dec ref on ea_inode, one for orphan list addition, */
 	credits = 2 + extra_credits;
 
-	for (entry = first; !IS_LAST_ENTRY(entry);
+	for (entry = first; (void *)entry < end && !IS_LAST_ENTRY(entry);
 	     entry = EXT4_XATTR_NEXT(entry)) {
 		if (!entry->e_value_inum)
 			continue;
-- 
2.39.5



