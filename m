Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906492FF163;
	Tue, 12 Aug 2025 18:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024826; cv=none; b=tPOr3VI5AYbbBJ95hTFm0WfJcrCP5elO9fBACmR+qy2iGh2yK1z0dPQ1q5b+g5zFnVHDH43hlTvfvYmsEM0VeOjkXGY9i+ZnN2Q5zvLoVZX+OdMhWxGFC9tt99KzgId+xhxzDCaGrjioS/M/EVlWITERopVvx9OVol0WyPQvLHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024826; c=relaxed/simple;
	bh=XfguIhKvNwW72n/dU7y0chw2IHt57x84idBmvx8GTxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nz4RcZ8UjhMqMFHz8UXbY6XYHUhc+iSjKmsuJZAYWTQboDpz6sdSWwhdaMZWS3g03GHQkEzNrSITW3LOdDOnzvN8fmYuB9OR9wVrfz0Qigyxq+RBSDhiLzwoWbJ5SoWYJ+kwAMJlvafG5KBsCJlzesw9d/OdpSItn83hFPDpTA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxUki1Pc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxUki1Pc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9ABC4CEF0;
	Tue, 12 Aug 2025 18:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024826;
	bh=XfguIhKvNwW72n/dU7y0chw2IHt57x84idBmvx8GTxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxUki1PcQfrtbLDwzeDjktC650hbeqAolzV05SGuUKDYfpyQBUHFFSiwunAH6Bt7A
	 uaJspZ5L4sPqhDrF3IwTf7ki4XayMoqLFT6Oe5M6DU9v3zM1d4JOeYMTX225OPBqoC
	 W1p7UYRJIHxL3weEKlLGhUkhaL47keoFnpQu8eVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 487/627] f2fs: fix to trigger foreground gc during f2fs_map_blocks() in lfs mode
Date: Tue, 12 Aug 2025 19:33:02 +0200
Message-ID: <20250812173444.466987680@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 1005a3ca28e90c7a64fa43023f866b960a60f791 ]

w/ "mode=lfs" mount option, generic/299 will cause system panic as below:

------------[ cut here ]------------
kernel BUG at fs/f2fs/segment.c:2835!
Call Trace:
 <TASK>
 f2fs_allocate_data_block+0x6f4/0xc50
 f2fs_map_blocks+0x970/0x1550
 f2fs_iomap_begin+0xb2/0x1e0
 iomap_iter+0x1d6/0x430
 __iomap_dio_rw+0x208/0x9a0
 f2fs_file_write_iter+0x6b3/0xfa0
 aio_write+0x15d/0x2e0
 io_submit_one+0x55e/0xab0
 __x64_sys_io_submit+0xa5/0x230
 do_syscall_64+0x84/0x2f0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0010:new_curseg+0x70f/0x720

The root cause of we run out-of-space is: in f2fs_map_blocks(), f2fs may
trigger foreground gc only if it allocates any physical block, it will be
a little bit later when there is multiple threads writing data w/
aio/dio/bufio method in parallel, since we always use OPU in lfs mode, so
f2fs_map_blocks() does block allocations aggressively.

In order to fix this issue, let's give a chance to trigger foreground
gc in prior to block allocation in f2fs_map_blocks().

Fixes: 36abef4e796d ("f2fs: introduce mode=lfs mount option")
Cc: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 718e0b81a02f..53b64f4ff2d7 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1572,8 +1572,11 @@ int f2fs_map_blocks(struct inode *inode, struct f2fs_map_blocks *map, int flag)
 	end = pgofs + maxblocks;
 
 next_dnode:
-	if (map->m_may_create)
+	if (map->m_may_create) {
+		if (f2fs_lfs_mode(sbi))
+			f2fs_balance_fs(sbi, true);
 		f2fs_map_lock(sbi, flag);
+	}
 
 	/* When reading holes, we need its node page */
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
-- 
2.39.5



