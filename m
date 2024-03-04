Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E192D7868F;
	Mon,  4 Mar 2024 21:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588594; cv=none; b=u2QQrtbs6cKzYETuRqG7Fvt3FIIqjBvQJm1B4DvciBO35o6aAELQ2DY5oA1gilXdFbEfzkMFBC5K2pibTRZEef8I9rYVdGnptNf93gBqlzYt3H7TXSmVVzsC4W8sPdJtYOVeabaCRqGhuBbxzTWvCGT/XNQaR36boD0fb5cUcnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588594; c=relaxed/simple;
	bh=SQ1Qj+Coxsmamin8ktyOBaKWo0pZZpQWj6AJ4bVKGRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3B5Mf8uWTPAK28nyrmtCLw8/V5wXPuVgwZuLOXNp9bF/7u0WE65ZpO8x1p2b3e8RHdIxlSl/Px5LGGPm8pd8I589rx2/8uiwS6lVILfafC56NEzSY7r0SEhPOJGiYdu35SeuK1i8jXsjOskz1NT7HYD1UAeE0yPj4xX/b4ufdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JY5fpKGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JY5fpKGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75FFEC43390;
	Mon,  4 Mar 2024 21:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588593;
	bh=SQ1Qj+Coxsmamin8ktyOBaKWo0pZZpQWj6AJ4bVKGRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JY5fpKGG8WHGW50UBPL2oEOX3t2Js0ZPOs0jR7Q5TnlQQdvO2xvTgk/eF4z6J/qhj
	 foUfQmTU6Hdp1kfGeXr3sk4GifqurAk0Clk2w538HoR8bLNq2Lq120MUKQ7zuAVOzT
	 N0md/ftwm5y30o/XruY53D7uVHC0UQaP6B77p4mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f45957555ed4a808cc7a@syzkaller.appspotmail.com,
	Ye Bin <yebin10@huawei.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/215] fs/ntfs3: Fix NULL pointer dereference in ni_write_inode
Date: Mon,  4 Mar 2024 21:21:26 +0000
Message-ID: <20240304211557.733675049@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit db2a3cc6a3481076da6344cc62a80a4e2525f36f ]

Syzbot found the following issue:
Unable to handle kernel NULL pointer dereference at virtual address 0000000000000016
Mem abort info:
  ESR = 0x0000000096000006
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x06: level 2 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000006
  CM = 0, WnR = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=000000010af56000
[0000000000000016] pgd=08000001090da003, p4d=08000001090da003, pud=08000001090ce003, pmd=0000000000000000
Internal error: Oops: 0000000096000006 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 PID: 3036 Comm: syz-executor206 Not tainted 6.0.0-rc6-syzkaller-17739-g16c9f284e746 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : is_rec_inuse fs/ntfs3/ntfs.h:313 [inline]
pc : ni_write_inode+0xac/0x798 fs/ntfs3/frecord.c:3232
lr : ni_write_inode+0xa0/0x798 fs/ntfs3/frecord.c:3226
sp : ffff8000126c3800
x29: ffff8000126c3860 x28: 0000000000000000 x27: ffff0000c8b02000
x26: ffff0000c7502320 x25: ffff0000c7502288 x24: 0000000000000000
x23: ffff80000cbec91c x22: ffff0000c8b03000 x21: ffff0000c8b02000
x20: 0000000000000001 x19: ffff0000c75024d8 x18: 00000000000000c0
x17: ffff80000dd1b198 x16: ffff80000db59158 x15: ffff0000c4b6b500
x14: 00000000000000b8 x13: 0000000000000000 x12: ffff0000c4b6b500
x11: ff80800008be1b60 x10: 0000000000000000 x9 : ffff0000c4b6b500
x8 : 0000000000000000 x7 : ffff800008be1b50 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000008 x1 : 0000000000000001 x0 : 0000000000000000
Call trace:
 is_rec_inuse fs/ntfs3/ntfs.h:313 [inline]
 ni_write_inode+0xac/0x798 fs/ntfs3/frecord.c:3232
 ntfs_evict_inode+0x54/0x84 fs/ntfs3/inode.c:1744
 evict+0xec/0x334 fs/inode.c:665
 iput_final fs/inode.c:1748 [inline]
 iput+0x2c4/0x324 fs/inode.c:1774
 ntfs_new_inode+0x7c/0xe0 fs/ntfs3/fsntfs.c:1660
 ntfs_create_inode+0x20c/0xe78 fs/ntfs3/inode.c:1278
 ntfs_create+0x54/0x74 fs/ntfs3/namei.c:100
 lookup_open fs/namei.c:3413 [inline]
 open_last_lookups fs/namei.c:3481 [inline]
 path_openat+0x804/0x11c4 fs/namei.c:3688
 do_filp_open+0xdc/0x1b8 fs/namei.c:3718
 do_sys_openat2+0xb8/0x22c fs/open.c:1311
 do_sys_open fs/open.c:1327 [inline]
 __do_sys_openat fs/open.c:1343 [inline]
 __se_sys_openat fs/open.c:1338 [inline]
 __arm64_sys_openat+0xb0/0xe0 fs/open.c:1338
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:636
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:654
 el0t_64_sync+0x18c/0x190
Code: 97dafee4 340001b4 f9401328 2a1f03e0 (79402d14)
---[ end trace 0000000000000000 ]---

Above issue may happens as follows:
ntfs_new_inode
  mi_init
    mi->mrec = kmalloc(sbi->record_size, GFP_NOFS); -->failed to allocate memory
      if (!mi->mrec)
        return -ENOMEM;
iput
  iput_final
    evict
      ntfs_evict_inode
        ni_write_inode
	  is_rec_inuse(ni->mi.mrec)-> As 'ni->mi.mrec' is NULL trigger NULL-ptr-deref

To solve above issue if new inode failed make inode bad before call 'iput()' in
'ntfs_new_inode()'.

Reported-by: syzbot+f45957555ed4a808cc7a@syzkaller.appspotmail.com
Signed-off-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fsntfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 1eac80d55b554..4c2d079b3d49b 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -1674,6 +1674,7 @@ struct ntfs_inode *ntfs_new_inode(struct ntfs_sb_info *sbi, CLST rno, bool dir)
 
 out:
 	if (err) {
+		make_bad_inode(inode);
 		iput(inode);
 		ni = ERR_PTR(err);
 	}
-- 
2.43.0



