Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0B035A925;
	Fri,  9 Jan 2026 12:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960311; cv=none; b=uAThQOT0gTcPUbdkFgBVxhXHCeukPqcWCTMQ8Bb83ff9b/9lYnBrMaheLCilY3C73HzKm4hkAFUc6nWC5vpa7HzuRlZJLfc/lN4jSfRmmKm8+0xmLXJAK641eBIPkLLkphSvAcFDIB6btEIjGyF5kLTy5XHvoyrgixZlQfncHD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960311; c=relaxed/simple;
	bh=++rBdbm1iRTlB4bpfCJUh8PFTLrJ3m6CoxvXMOAV17E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwYiMiMMjc+EbfCMPMt6a5xIezObFPpwOnt6r+sBzUI7HdyOtrvz7sThdw9aY/+C+tn9VdEeI4QEWfjk2M5mcUNDGjp1EOaBv7lNRyrDFrMnxQUKnwSnUr6tJ4SnkeWzpziiK5yOIQU9eC/DFv4rclIBphg5Q0X2Ffpj0jW6PLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjIE50SH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjIE50SH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C55FC16AAE;
	Fri,  9 Jan 2026 12:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960311;
	bh=++rBdbm1iRTlB4bpfCJUh8PFTLrJ3m6CoxvXMOAV17E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjIE50SHJbAPjfV8USwQ8YpxjefG8qewrajopAj++7j/ag5jjeoQaCwdmRi5M4zj2
	 qLsz2/ReF0SNMUTDwnhIsn6IT+EikXCqZW+3P4Ejb2VXPpheLzF7Bu9ukCf6zEHBas
	 g85YYLmvEZ+aurbXYLw+XZNKlxK+/qUKo2MMZukY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f4f84b57a01d6b8364ad@syzkaller.appspotmail.com,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 317/737] ntfs: set dummy blocksize to read boot_block when mounting
Date: Fri,  9 Jan 2026 12:37:36 +0100
Message-ID: <20260109112145.926826013@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index c14b55cdea85c..0b96d0f995c61 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -885,6 +885,11 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 
 	sbi->volume.blocks = dev_size >> PAGE_SHIFT;
 
+	/* Set dummy blocksize to read boot_block. */
+	if (!sb_min_blocksize(sb, PAGE_SIZE)) {
+		return -EINVAL;
+	}
+
 read_boot:
 	bh = ntfs_bread(sb, boot_block);
 	if (!bh)
-- 
2.51.0



