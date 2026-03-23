Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2A13BE634;
	Mon, 23 Mar 2026 16:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283359; cv=none; b=jnwBKiF6aai137PkU5rrXU7vNFhWXt3wMCY7oeA57+8GobRz6DurMrDEYgcXNO+eSSjk1V0Mm30FrU+15ygBvZQaiHHbigbZKe1NG8+9PGp0Qi9E6K0TD/aMH/re0USNc7n/ymqVKzRBAHbn7yeJqxUBHamNFsHi4sHp6hKfr90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283359; c=relaxed/simple;
	bh=fwy4Xq9VNPk6TYgBXBtt4ro+prbkoOXiB0XfqlbmNM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTbsvW05LNTpiqmAeVdmOom9/QNKii3FjkfzT8uRfyIAKVKtpmJd0hfipgZmuV304Wp35yZkIXYFrwBW2yznRVU368IgTQ+27tkqVnmKpINNz3UYl7hyWt5HFdNwD2mJqhtoCE7E8p73DlUHwQsGYAj5l0UwrmAPX3yYSwEx2AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDUghqow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDUghqow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C6BC2BCB0;
	Mon, 23 Mar 2026 16:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283358;
	bh=fwy4Xq9VNPk6TYgBXBtt4ro+prbkoOXiB0XfqlbmNM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xDUghqowkphvuWgeLIu/D47y5oQBg/WqTrz1wQpCXwg3JDzdAyVMVmBO+PLh27NmA
	 1XcF0txMk0FR7WEq8ga7tbcbAnqVaA+igc12IdBfpvpkdRqjYFkb7b+cGJNvui/vr1
	 b1WQXoMRghPnh+KaDGn31Q+emwDqyVwizaItiLzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f4f84b57a01d6b8364ad@syzkaller.appspotmail.com,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 6.1 467/481] ntfs: set dummy blocksize to read boot_block when mounting
Date: Mon, 23 Mar 2026 14:47:29 +0100
Message-ID: <20260323134536.598196049@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>

[ Upstream commit d1693a7d5a38acf6424235a6070bcf5b186a360d ]

When mounting, sb->s_blocksize is used to read the boot_block without
being defined or validated. Set a dummy blocksize before attempting to
read the boot_block.

The issue can be triggered with the following syz reproducer:

  mkdirat(0xffffffffffffff9c, &(0x7f0000000080)='./file1\x00', 0x0)
  r4 = openat$nullb(0xffffffffffffff9c, &(0x7f0000000040), 0x121403, 0x0)
  ioctl$FS_IOC_SETFLAGS(r4, 0x40081271, &(0x7f0000000980)=0x4000)
  mount(&(0x7f0000000140)=@nullb, &(0x7f0000000040)='./cgroup\x00',
        &(0x7f0000000000)='ntfs3\x00', 0x2208004, 0x0)
  syz_clone(0x88200200, 0x0, 0x0, 0x0, 0x0, 0x0)

Here, the ioctl sets the bdev block size to 16384. During mount,
get_tree_bdev_flags() calls sb_set_blocksize(sb, block_size(bdev)),
but since block_size(bdev) > PAGE_SIZE, sb_set_blocksize() leaves
sb->s_blocksize at zero.

Later, ntfs_init_from_boot() attempts to read the boot_block while
sb->s_blocksize is still zero, which triggers the bug.

Reported-by: syzbot+f4f84b57a01d6b8364ad@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f4f84b57a01d6b8364ad
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
[almaz.alexandrovich@paragon-software.com: changed comment style, added
return value handling]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
[ The context change is due to the commit c39de951282d
("fs/ntfs3: Improve alternative boot processing")
in v6.8 which is irrelevant to the logic of this patch. ]
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/super.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -693,6 +693,11 @@ static int ntfs_init_from_boot(struct su
 
 	sbi->volume.blocks = dev_size >> PAGE_SHIFT;
 
+	/* Set dummy blocksize to read boot_block. */
+	if (!sb_min_blocksize(sb, PAGE_SIZE)) {
+		return -EINVAL;
+	}
+
 	bh = ntfs_bread(sb, 0);
 	if (!bh)
 		return -EIO;


