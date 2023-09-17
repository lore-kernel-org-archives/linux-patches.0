Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DA47469
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BA3C433C8;
	Sun, 17 Sep 2023 20:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982359;
	bh=07TZftQeWRhSku28gLhFpUpxyta9Btg4/2uXBlQXisI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G1bcQTiK++ImDpyyn0F0+E9GpG5lBdyBY5XuEE4lAIv3UJyRjWQXhT3KBwXf9/Htq
	 OUuqKyq6rVILi00NQDcru/7m8uB14KJZFsranUOAaQDxWWKji+QxfQk8qpOOmDaT+G
	 XOSWpKxpEAPrbiFPd6v/zhehYy3iXFOvCuUflYLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksei Filippov <halip0503@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+5f088f29593e6b4c8db8@syzkaller.appspotmail.com
Subject: [PATCH 5.15 228/511] jfs: validate max amount of blocks before allocation.
Date: Sun, 17 Sep 2023 21:10:55 +0200
Message-ID: <20230917191119.314302300@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Filippov <halip0503@gmail.com>

[ Upstream commit 0225e10972fa809728b8d4c1bd2772b3ec3fdb57 ]

The lack of checking bmp->db_max_freebud in extBalloc() can lead to
shift out of bounds, so this patch prevents undefined behavior, because
bmp->db_max_freebud == -1 only if there is no free space.

Signed-off-by: Aleksei Filippov <halip0503@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-and-tested-by: syzbot+5f088f29593e6b4c8db8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?id=01abadbd6ae6a08b1f1987aa61554c6b3ac19ff2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_extent.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/jfs/jfs_extent.c b/fs/jfs/jfs_extent.c
index bb4a342a193d4..6420b6749d48f 100644
--- a/fs/jfs/jfs_extent.c
+++ b/fs/jfs/jfs_extent.c
@@ -508,6 +508,11 @@ extBalloc(struct inode *ip, s64 hint, s64 * nblocks, s64 * blkno)
 	 * blocks in the map. in that case, we'll start off with the
 	 * maximum free.
 	 */
+
+	/* give up if no space left */
+	if (bmp->db_maxfreebud == -1)
+		return -ENOSPC;
+
 	max = (s64) 1 << bmp->db_maxfreebud;
 	if (*nblocks >= max && *nblocks > nbperpage)
 		nb = nblks = (max > nbperpage) ? max : nbperpage;
-- 
2.40.1



