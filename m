Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CCD168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78C6C433D2;
	Mon,  8 May 2023 10:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542236;
	bh=5OwhriKLAN/fkY8AB9fk04gRwc5KZGXUiaa2PNQe5Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3+byGee35FniUrkoN6kznitMzhxhN8+1+KNe28CE5jK/sF/QXC7urJx6IghGQZRy
	 zoaucjlGN3/Ti5t7BZcqS1w2ypi0KZdOmUjMl07DG9RD5EwdaiU/OIHDOHLr2nGGK3
	 NDkNz227OpAV6hXYUK4pO3Jye7zy4ibV66fH7KTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 370/663] f2fs: fix to check return value of f2fs_do_truncate_blocks()
Date: Mon,  8 May 2023 11:43:16 +0200
Message-Id: <20230508094440.136100767@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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

[ Upstream commit b851ee6ba3cc212641e622ebcf92b950c7bafa07 ]

Otherwise, if truncation on cow_inode failed, remained data may
pollute current transaction of atomic write.

Cc: Daeho Jeong <daehojeong@google.com>
Fixes: a46bebd502fe ("f2fs: synchronize atomic write aborts")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 23fb9861dba40..de92279a80020 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2117,7 +2117,11 @@ static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
 		clear_inode_flag(fi->cow_inode, FI_INLINE_DATA);
 	} else {
 		/* Reuse the already created COW inode */
-		f2fs_do_truncate_blocks(fi->cow_inode, 0, true);
+		ret = f2fs_do_truncate_blocks(fi->cow_inode, 0, true);
+		if (ret) {
+			f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
+			goto out;
+		}
 	}
 
 	f2fs_write_inode(inode, NULL);
-- 
2.39.2



