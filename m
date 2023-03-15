Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B144431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2923FC433EF;
	Wed, 15 Mar 2023 12:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882730;
	bh=4fWTWuO4f2ruh9prlLWaLCFTHcl3BECXU1oqqaDOyKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KU8+Xdvpj3I60vwDeJAKmquEj9eU8SNvyPE1wWjV+t1pf9YpHtz/7AdOiLQJebQfv
	 IF7p7Tzpi1MrLHuBx81c8abMoYDPb2F2eosV9tnHGu0xiZP33Ga8V3QStAohtGV16c
	 1NDcPhWRQaBEMMMkzRf1Lf9JJETYOOW+m+OBUqnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 08/68] ext4: zero i_disksize when initializing the bootloader inode
Date: Wed, 15 Mar 2023 13:12:02 +0100
Message-Id: <20230315115726.435965253@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit f5361da1e60d54ec81346aee8e3d8baf1be0b762 upstream.

If the boot loader inode has never been used before, the
EXT4_IOC_SWAP_BOOT inode will initialize it, including setting the
i_size to 0.  However, if the "never before used" boot loader has a
non-zero i_size, then i_disksize will be non-zero, and the
inconsistency between i_size and i_disksize can trigger a kernel
warning:

 WARNING: CPU: 0 PID: 2580 at fs/ext4/file.c:319
 CPU: 0 PID: 2580 Comm: bb Not tainted 6.3.0-rc1-00004-g703695902cfa
 RIP: 0010:ext4_file_write_iter+0xbc7/0xd10
 Call Trace:
  vfs_write+0x3b1/0x5c0
  ksys_write+0x77/0x160
  __x64_sys_write+0x22/0x30
  do_syscall_64+0x39/0x80

Reproducer:
 1. create corrupted image and mount it:
       mke2fs -t ext4 /tmp/foo.img 200
       debugfs -wR "sif <5> size 25700" /tmp/foo.img
       mount -t ext4 /tmp/foo.img /mnt
       cd /mnt
       echo 123 > file
 2. Run the reproducer program:
       posix_memalign(&buf, 1024, 1024)
       fd = open("file", O_RDWR | O_DIRECT);
       ioctl(fd, EXT4_IOC_SWAP_BOOT);
       write(fd, buf, 1024);

Fix this by setting i_disksize as well as i_size to zero when
initiaizing the boot loader inode.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217159
Cc: stable@kernel.org
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Link: https://lore.kernel.org/r/20230308032643.641113-1-chengzhihao1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ioctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -179,6 +179,7 @@ static long swap_inode_boot_loader(struc
 		ei_bl->i_flags = 0;
 		inode_set_iversion(inode_bl, 1);
 		i_size_write(inode_bl, 0);
+		EXT4_I(inode_bl)->i_disksize = inode_bl->i_size;
 		inode_bl->i_mode = S_IFREG;
 		if (ext4_has_feature_extents(sb)) {
 			ext4_set_inode_flag(inode_bl, EXT4_INODE_EXTENTS);


