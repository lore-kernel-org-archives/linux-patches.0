Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE46478E49;
	Sat, 12 Sep 2026 13:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219590; cv=none; b=UzWkr4dVwEMhDezaorWYgMxfgAnXEO9rHXb+oPt8wqsy/BeTXO/d8pqfztudp/LX8IqY+zratijmFoi96PM7uZjpaTpUKss6laBwegetaddMkY4JsLtXP/YjKJqfHbMvlifNE1YlHctFLLyjxr+WHMjC/ckliwESTKOlOVNrkOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219590; c=relaxed/simple;
	bh=ZlXCxF/J5U4o1fqzPuMJt75PBGXWUOc0gurYFSykwgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZnbsKTNyvegQVOadkfYevIz8n3V3TKco+m0ZAfBTHHRS8ShO4pSs6iUrfGYYfGMuITQwT14Xv9ho5BePVY2oypSlqR0qH9CizOgtCO/9jxHJUmJAwzdwXza+Gly6b0x5CviaTIWcJWXavVhpS3PLY7CLIbyXbpV+FzvMsSffUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSC3BEBb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSC3BEBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B061F000FF;
	Sat, 12 Sep 2026 13:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219588;
	bh=YeOL1Vh7p2yosiC3d8qF4XSnxHxpuW4HfqU1Z5Yh6eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wSC3BEBbX1EAlnz+M1cWrxVFR0+cf9igFbjDcdwSZo63TYt20UgQn0B3SJZmMAYPR
	 HW8hfWD3Ej40HRxiIJC6hzipNnA1tOdE8PduiCIcD110woYUF+wiacIJln86B9guR6
	 SGTD37vJBj2fF++YLVI86/lRAydf6qsFLbdMwmDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1346/1376] fscrypt: fix left shift underflow when inode->i_blkbits > PAGE_SHIFT
Date: Sat, 12 Sep 2026 09:02:52 +0200
Message-ID: <20260912065637.531994423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

[ Upstream commit 1e39da974ce621ed874c6d3aaf65ad14848c9f0d ]

When simulating an nvme device on qemu with both logical_block_size and
physical_block_size set to 8 KiB, an error trace appears during
partition table reading at boot time. The issue is caused by
inode->i_blkbits being larger than PAGE_SHIFT, which leads to a left
shift of -1 and triggering a UBSAN warning.

[    2.697306] ------------[ cut here ]------------
[    2.697309] UBSAN: shift-out-of-bounds in fs/crypto/inline_crypt.c:336:37
[    2.697311] shift exponent -1 is negative
[    2.697315] CPU: 3 UID: 0 PID: 274 Comm: (udev-worker) Not tainted 6.18.0-rc2+ #34 PREEMPT(voluntary)
[    2.697317] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[    2.697320] Call Trace:
[    2.697324]  <TASK>
[    2.697325]  dump_stack_lvl+0x76/0xa0
[    2.697340]  dump_stack+0x10/0x20
[    2.697342]  __ubsan_handle_shift_out_of_bounds+0x1e3/0x390
[    2.697351]  bh_get_inode_and_lblk_num.cold+0x12/0x94
[    2.697359]  fscrypt_set_bio_crypt_ctx_bh+0x44/0x90
[    2.697365]  submit_bh_wbc+0xb6/0x190
[    2.697370]  block_read_full_folio+0x194/0x270
[    2.697371]  ? __pfx_blkdev_get_block+0x10/0x10
[    2.697375]  ? __pfx_blkdev_read_folio+0x10/0x10
[    2.697377]  blkdev_read_folio+0x18/0x30
[    2.697379]  filemap_read_folio+0x40/0xe0
[    2.697382]  filemap_get_pages+0x5ef/0x7a0
[    2.697385]  ? mmap_region+0x63/0xd0
[    2.697389]  filemap_read+0x11d/0x520
[    2.697392]  blkdev_read_iter+0x7c/0x180
[    2.697393]  vfs_read+0x261/0x390
[    2.697397]  ksys_read+0x71/0xf0
[    2.697398]  __x64_sys_read+0x19/0x30
[    2.697399]  x64_sys_call+0x1e88/0x26a0
[    2.697405]  do_syscall_64+0x80/0x670
[    2.697410]  ? __x64_sys_newfstat+0x15/0x20
[    2.697414]  ? x64_sys_call+0x204a/0x26a0
[    2.697415]  ? do_syscall_64+0xb8/0x670
[    2.697417]  ? irqentry_exit_to_user_mode+0x2e/0x2a0
[    2.697420]  ? irqentry_exit+0x43/0x50
[    2.697421]  ? exc_page_fault+0x90/0x1b0
[    2.697422]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[    2.697425] RIP: 0033:0x75054cba4a06
[    2.697426] Code: 5d e8 41 8b 93 08 03 00 00 59 5e 48 83 f8 fc 75 19 83 e2 39 83 fa 08 75 11 e8 26 ff ff ff 66 0f 1f 44 00 00 48 8b 45 10 0f 05 <48> 8b 5d f8 c9 c3 0f 1f 40 00 f3 0f 1e fa 55 48 89 e5 48 83 ec 08
[    2.697427] RSP: 002b:00007fff973723a0 EFLAGS: 00000202 ORIG_RAX: 0000000000000000
[    2.697430] RAX: ffffffffffffffda RBX: 00005ea9a2c02760 RCX: 000075054cba4a06
[    2.697432] RDX: 0000000000002000 RSI: 000075054c190000 RDI: 000000000000001b
[    2.697433] RBP: 00007fff973723c0 R08: 0000000000000000 R09: 0000000000000000
[    2.697434] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
[    2.697434] R13: 00005ea9a2c027c0 R14: 00005ea9a2be5608 R15: 00005ea9a2be55f0
[    2.697436]  </TASK>
[    2.697436] ---[ end trace ]---

This situation can happen for block devices because when
CONFIG_TRANSPARENT_HUGEPAGE is enabled, the maximum logical_block_size
is 64 KiB. set_init_blocksize() then sets the block device
inode->i_blkbits to 13, which is within this limit.

File I/O does not trigger this problem because for filesystems that do
not support the FS_LBS feature, sb_set_blocksize() prevents
sb->s_blocksize_bits from being larger than PAGE_SHIFT. During inode
allocation, alloc_inode()->inode_init_always() assigns inode->i_blkbits
from sb->s_blocksize_bits. Currently, only xfs_fs_type has the FS_LBS
flag, and since xfs I/O paths do not reach submit_bh_wbc(), it does not
hit the left-shift underflow issue.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Fixes: 47dd67532303 ("block/bdev: lift block size restrictions to 64k")
Cc: stable@vger.kernel.org
[EB: use folio_pos() and consolidate the two shifts by i_blkbits]
Link: https://lore.kernel.org/r/20251105003642.42796-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/crypto/inline_crypt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 0a216d20e6950..60d15d5e02ca6 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -275,8 +275,7 @@ static bool bh_get_inode_and_lblk_num(const struct buffer_head *bh,
 	inode = mapping->host;
 
 	*inode_ret = inode;
-	*lblk_num_ret = ((u64)folio->index << (PAGE_SHIFT - inode->i_blkbits)) +
-			(bh_offset(bh) >> inode->i_blkbits);
+	*lblk_num_ret = (folio_pos(folio) + bh_offset(bh)) >> inode->i_blkbits;
 	return true;
 }
 
-- 
2.53.0



