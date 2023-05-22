Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A99171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9379DC433EF;
	Mon, 22 May 2023 19:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784658;
	bh=uxQs/ZbF0Ne7HsUph3+NneBS5ASI+TbK0LZd6MXzlRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afIytAWgZ6RgqYzeHvsJvchYJzqHuSm0esnIpEu9jbORm9xztKAQjWovkLOKZsKgS
	 vl3v2W4Yb1AAvEz1Da4uSqcr0Oghqno9r0mSuQj03Ec9EYR2p03ikPk/CJlE+LCDgo
	 ysOwg6qMkbVchqck3cRUMlx9UPtjsf8UDYidMJZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 115/364] f2fs: fix to check readonly condition correctly
Date: Mon, 22 May 2023 20:07:00 +0100
Message-Id: <20230522190415.657948778@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chao Yu <chao@kernel.org>

[ Upstream commit d78dfefcde9d311284434560d69c0478c55a657e ]

With below case, it can mount multi-device image w/ rw option, however
one of secondary device is set as ro, later update will cause panic, so
let's introduce f2fs_dev_is_readonly(), and check multi-devices rw status
in f2fs_remount() w/ it in order to avoid such inconsistent mount status.

mkfs.f2fs -c /dev/zram1 /dev/zram0 -f
blockdev --setro /dev/zram1
mount -t f2fs dev/zram0 /mnt/f2fs
mount: /mnt/f2fs: WARNING: source write-protected, mounted read-only.
mount -t f2fs -o remount,rw mnt/f2fs
dd if=/dev/zero  of=/mnt/f2fs/file bs=1M count=8192

kernel BUG at fs/f2fs/inline.c:258!
RIP: 0010:f2fs_write_inline_data+0x23e/0x2d0 [f2fs]
Call Trace:
  f2fs_write_single_data_page+0x26b/0x9f0 [f2fs]
  f2fs_write_cache_pages+0x389/0xa60 [f2fs]
  __f2fs_write_data_pages+0x26b/0x2d0 [f2fs]
  f2fs_write_data_pages+0x2e/0x40 [f2fs]
  do_writepages+0xd3/0x1b0
  __writeback_single_inode+0x5b/0x420
  writeback_sb_inodes+0x236/0x5a0
  __writeback_inodes_wb+0x56/0xf0
  wb_writeback+0x2a3/0x490
  wb_do_writeback+0x2b2/0x330
  wb_workfn+0x6a/0x260
  process_one_work+0x270/0x5e0
  worker_thread+0x52/0x3e0
  kthread+0xf4/0x120
  ret_from_fork+0x29/0x50

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h  | 5 +++++
 fs/f2fs/super.c | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index d6f9d6e0f13b9..47eff365f536c 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4427,6 +4427,11 @@ static inline bool f2fs_hw_is_readonly(struct f2fs_sb_info *sbi)
 	return false;
 }
 
+static inline bool f2fs_dev_is_readonly(struct f2fs_sb_info *sbi)
+{
+	return f2fs_sb_has_readonly(sbi) || f2fs_hw_is_readonly(sbi);
+}
+
 static inline bool f2fs_lfs_mode(struct f2fs_sb_info *sbi)
 {
 	return F2FS_OPTION(sbi).fs_mode == FS_MODE_LFS;
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 5c1c3a84501fe..333ea095c8c50 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2274,7 +2274,7 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 	if (f2fs_readonly(sb) && (*flags & SB_RDONLY))
 		goto skip;
 
-	if (f2fs_sb_has_readonly(sbi) && !(*flags & SB_RDONLY)) {
+	if (f2fs_dev_is_readonly(sbi) && !(*flags & SB_RDONLY)) {
 		err = -EROFS;
 		goto restore_opts;
 	}
-- 
2.39.2



