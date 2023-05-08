Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201B3168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977C5C433EF;
	Mon,  8 May 2023 10:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540438;
	bh=suGItS/ta70a6CIxL0LTXnMMzE8hUaidPaRLPN92wok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fsTU2VU0bH91tqnmKxW0sAqwIUuH5MroMsPeFIub7UNaOVtiQIptm+dj6Jv2YXE2N
	 FHx/Dh4+P0vemjTkMeqW2xU2EdM6C9VtbKe1n70EIHEk4kk/DsbO/z6C63wa7rJPFo
	 GhYpZUo3PVkrvGlK/VjbBrDFspEYklxNzZFWWLrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 347/611] f2fs: fix to check return value of inc_valid_block_count()
Date: Mon,  8 May 2023 11:43:09 +0200
Message-Id: <20230508094433.685027944@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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

[ Upstream commit 935fc6fa6466cf18dd72dd1518ebc7bfc4cd58a4 ]

In __replace_atomic_write_block(), we missed to check return value
of inc_valid_block_count(), for extreme testcase that f2fs image is
run out of space, it may cause inconsistent status in between SIT
table and total valid block count.

Cc: Daeho Jeong <daehojeong@google.com>
Fixes: 3db1de0e582c ("f2fs: change the current atomic write way")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index c926479485775..b0fbdee16a96c 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -245,10 +245,16 @@ static int __replace_atomic_write_block(struct inode *inode, pgoff_t index,
 	} else {
 		blkcnt_t count = 1;
 
+		err = inc_valid_block_count(sbi, inode, &count);
+		if (err) {
+			f2fs_put_dnode(&dn);
+			return err;
+		}
+
 		*old_addr = dn.data_blkaddr;
 		f2fs_truncate_data_blocks_range(&dn, 1);
 		dec_valid_block_count(sbi, F2FS_I(inode)->cow_inode, count);
-		inc_valid_block_count(sbi, inode, &count);
+
 		f2fs_replace_block(sbi, &dn, dn.data_blkaddr, new_addr,
 					ni.version, true, false);
 	}
-- 
2.39.2



