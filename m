Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77A315AE7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:15:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8A5C433C9;
	Wed, 20 Sep 2023 12:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212125;
	bh=GlUczk8fKihqcpL6WE4maZswpi6MnyWtt3N8aBv5yAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+vh9ULhIX/BOTqsf0zXZxclkSxaJ2CIvMPZEwBP/ed6VkhsDTE3DyVdo1v50WMu0
	 cxFpfD9bS+PxYt2hpsKJrKz8xqZwc3NCZtg22B5wLkwJnrf+njs1adsSdFEMKCNU77
	 UBWL5imudiiO2dEkjNwWi1EE0Rh70NK4t8AeIWck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksei Filippov <halip0503@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+5f088f29593e6b4c8db8@syzkaller.appspotmail.com
Subject: [PATCH 4.19 126/273] jfs: validate max amount of blocks before allocation.
Date: Wed, 20 Sep 2023 13:29:26 +0200
Message-ID: <20230920112850.394891083@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 2ae7d59ab10a5..c971e8a6525de 100644
--- a/fs/jfs/jfs_extent.c
+++ b/fs/jfs/jfs_extent.c
@@ -521,6 +521,11 @@ extBalloc(struct inode *ip, s64 hint, s64 * nblocks, s64 * blkno)
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



