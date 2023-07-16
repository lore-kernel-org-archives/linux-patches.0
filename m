Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5538F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D56C433C8;
	Sun, 16 Jul 2023 20:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538719;
	bh=8LwEVONkqocl7Y9+GBBhadiLTkoYInVL+YVOzB7dtKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ziQX8Oe2TCjyxNw1VSMgl6Moa15Pzp/Ut6pDjzVEJhhURBeQslwwchktexsq1zkJa
	 DjEx47rvpppqmjzhhk7FvCUoiZj0a6JVtS5gW6iUVmq5dcKiuuUPAZx+SrxMJFSgpy
	 lCixhHoWabErtOufyjzA3A3EXfK14BziqF0mMe+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Han <hanqi@vivo.com>,
	Yangtao Li <frank.li@vivo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 551/800] f2fs: do not allow to defragment files have FI_COMPRESS_RELEASED
Date: Sun, 16 Jul 2023 21:46:44 +0200
Message-ID: <20230716195001.889916618@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 7cd2e5f75b86a1befa99834f3ed1d735eeff69e6 ]

If a file has FI_COMPRESS_RELEASED, all writes for it should not be
allowed.

Fixes: 5fdb322ff2c2 ("f2fs: add F2FS_IOC_DECOMPRESS_FILE and F2FS_IOC_COMPRESS_FILE")
Signed-off-by: Qi Han <hanqi@vivo.com>
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 5ac53d2627d20..fa50c6475876c 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2593,6 +2593,11 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 
 	inode_lock(inode);
 
+	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+		err = -EINVAL;
+		goto unlock_out;
+	}
+
 	/* if in-place-update policy is enabled, don't waste time here */
 	set_inode_flag(inode, FI_OPU_WRITE);
 	if (f2fs_should_update_inplace(inode, NULL)) {
@@ -2717,6 +2722,7 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 	clear_inode_flag(inode, FI_SKIP_WRITES);
 out:
 	clear_inode_flag(inode, FI_OPU_WRITE);
+unlock_out:
 	inode_unlock(inode);
 	if (!err)
 		range->len = (u64)total << PAGE_SHIFT;
-- 
2.39.2



