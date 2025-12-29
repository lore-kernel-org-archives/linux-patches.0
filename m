Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD8D32FA0F;
	Mon, 29 Dec 2025 16:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025007; cv=none; b=uKzQysO//NM+GX4cTtQ0nQ/5/JsMpPsmvdJy552nmmw6bTE/514uIHH0hSNUc1DXdpkdB4Ofg9BBl0pCbvgUoC+Hvx9vySfsNi5qB8dnS/AsKyKNowyKDPgtFb3MPUC64WrmVDeGESnHS/ylwtFJQVvMU4iP/eBKXSDbwIZmx04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025007; c=relaxed/simple;
	bh=EjiVfx5drM+LZlgWS3vnHrH6Sc+usKyyvJ1WXzybjxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rs2ehVgMKVXs0k8S9AP5Z1nB6zs0Y+9uRHYC+8QVuCfDCP1flSDCeBPp2lTQEbcf1bpD5fqpqXyACWc7bQCH3df5yqKGsybAW7i7oQJu6j/KAsXJ8okEchmvkLtObZGEWXvT9eJJNc8oKLXJro/C4jCAFamns2Mok365wtH8ePw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNXsTHtf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNXsTHtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AE1C4CEF7;
	Mon, 29 Dec 2025 16:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025007;
	bh=EjiVfx5drM+LZlgWS3vnHrH6Sc+usKyyvJ1WXzybjxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNXsTHtfcaFRCdFnUUXbnkB1R/TVXNxslewerW0giarNJOy3dY4+e92s5ZiWfQacr
	 13aLY3HHAErgiUtkzR5Xg5oqwDgYhS8a1MbXkfvLIyxo8ay3eFxoh2ALvvk/cZhdb2
	 Xw6q5Z1sbh5qE5Nzec5XWQKjBii5cfS7BwiARbVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f4f84b57a01d6b8364ad@syzkaller.appspotmail.com,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 028/430] ntfs: set dummy blocksize to read boot_block when mounting
Date: Mon, 29 Dec 2025 17:07:10 +0100
Message-ID: <20251229160725.194617200@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
index ddff94c091b8c..e6c0908e27c29 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -933,6 +933,11 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 
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



